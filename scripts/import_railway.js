const fs = require('fs');
const path = require('path');
const mysql = require('mysql2/promise');
require('dotenv').config();

async function run() {
  try {
    const host = process.env.DB_HOST;
    const port = process.env.DB_PORT || 3306;
    const user = process.env.DB_USER;
    const password = process.env.DB_PASSWORD;
    const database = process.env.DB_NAME;

    console.log(`Menghubungkan ke database Railway: ${host}:${port} (${database})...`);
    
    const connection = await mysql.createConnection({
      host: host,
      port: Number(port),
      user: user,
      password: password,
      database: database
    });

    console.log('Koneksi berhasil! Membersihkan database (Drop all existing tables)...');
    
    // 1. Matikan foreign key checks agar proses drop tabel lancar
    await connection.query('SET FOREIGN_KEY_CHECKS = 0');
    
    // 2. Ambil list semua tabel di database
    const [tables] = await connection.query('SHOW TABLES');
    const dbKey = `Tables_in_${database}`;
    
    for (let tableRow of tables) {
      const tableName = tableRow[dbKey] || Object.values(tableRow)[0];
      console.log(`[DROP]: Menghapus tabel \`${tableName}\`...`);
      await connection.query(`DROP TABLE IF EXISTS \`${tableName}\``);
    }
    
    // 3. Hidupkan kembali foreign key checks
    await connection.query('SET FOREIGN_KEY_CHECKS = 1');
    console.log('Database bersih! Membaca file facultyware.sql...');

    const sqlPath = path.join(__dirname, '..', 'facultyware.sql');
    if (!fs.existsSync(sqlPath)) {
      throw new Error(`File facultyware.sql tidak ditemukan di path: ${sqlPath}`);
    }

    let sqlContent = fs.readFileSync(sqlPath, 'utf8');
    
    // Perbaiki typo pluralisasi tabel secara dinamis agar foreign key tidak error
    console.log('Memperbaiki typo nama tabel (official_travels -> official_travel) di SQL...');
    sqlContent = sqlContent.replace(/`official_travels`/gi, '`official_travel`');
    sqlContent = sqlContent.replace(/\bofficial_travels\b/gi, 'official_travel');

    const lines = sqlContent.split('\n');
    let queries = [];
    let currentQuery = '';
    let activeDelimiter = ';';

    for (let line of lines) {
      const trimmed = line.trim();
      
      // Skip empty lines and single-line comments
      if (!trimmed || trimmed.startsWith('--') || trimmed.startsWith('#')) {
        continue;
      }
      
      // Skip multi-line comments that are single line here
      if (trimmed.startsWith('/*') && trimmed.endsWith('*/')) {
        continue;
      }

      // Handle DELIMITER command
      if (trimmed.toUpperCase().startsWith('DELIMITER')) {
        const parts = trimmed.split(/\s+/);
        if (parts.length > 1) {
          activeDelimiter = parts[1];
          console.log(`[DELIMITER CHANGE] Mengubah delimiter ke: ${activeDelimiter}`);
        }
        continue;
      }

      currentQuery += line + '\n';

      // Check if current block ends with the active delimiter
      if (trimmed.endsWith(activeDelimiter)) {
        let queryToPush = currentQuery.trim();
        // Hapus delimiter di akhir query
        if (queryToPush.endsWith(activeDelimiter)) {
          queryToPush = queryToPush.slice(0, -activeDelimiter.length).trim();
        }
        if (queryToPush) {
          queries.push(queryToPush);
        }
        currentQuery = '';
      }
    }

    if (currentQuery.trim()) {
      queries.push(currentQuery.trim());
    }

    console.log(`Ditemukan ${queries.length} statement SQL. Mulai mengimpor...`);

    for (let i = 0; i < queries.length; i++) {
      let query = queries[i];
      
      // Skip database creation/use statements
      if (
        query.toUpperCase().startsWith('CREATE DATABASE') || 
        query.toUpperCase().startsWith('CREATE SCHEMA') || 
        query.toUpperCase().startsWith('USE ')
      ) {
        console.log(`[SKIP] ${query}`);
        continue;
      }

      // Penanganan khusus untuk tabel sessions:
      // Karena aplikasi Node.js Anda sedang aktif berjalan, ia mungkin langsung menulis data session baru
      // ke tabel `sessions` segera setelah dibuat, sehingga menyebabkan error duplikat saat ALTER TABLE.
      if (query.toUpperCase().startsWith('ALTER TABLE `SESSIONS`')) {
        console.log('[INFO] Mengosongkan tabel sessions sebelum ALTER TABLE untuk menghindari error key duplikat...');
        try {
          await connection.query('DELETE FROM `sessions`');
        } catch (e) {
          console.warn('[WARN] Gagal mengosongkan tabel sessions:', e.message);
        }
      }

      console.log(`[EXECUTE ${i + 1}/${queries.length}]: ${query.substring(0, 80).replace(/\n/g, ' ')}...`);
      try {
        await connection.query(query);
      } catch (queryErr) {
        // Toleransi error duplikat khusus untuk tabel sessions
        if (queryErr.errno === 1062 && query.toUpperCase().includes('`SESSIONS`')) {
          console.log('[INFO] Mengabaikan error duplikasi data pada tabel sessions yang sedang aktif.');
        } else if (queryErr.errno === 1060 || queryErr.errno === 1061 || queryErr.errno === 1050) {
          console.log(`[INFO] Kolom/indeks/tabel sudah ada, dilewati (Error ${queryErr.errno}).`);
        } else {
          console.error(`Gagal pada query: ${query}`);
          throw queryErr;
        }
      }
    }

    console.log('Import database ke Railway selesai dengan sukses!');
    await connection.end();
    process.exit(0);
  } catch (err) {
    console.error('Gagal mengimpor database:', err);
    process.exit(1);
  }
}

run();
