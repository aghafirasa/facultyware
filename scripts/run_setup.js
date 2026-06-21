const fs = require('fs');
const path = require('path');
const mysql = require('mysql2/promise');
require('dotenv').config();

async function runSetup() {
  try {
    const dbName = process.env.DB_NAME || 'facultyware';
    console.log(`Menghubungkan ke MySQL server untuk membuat database "${dbName}" jika belum ada...`);

    // Hubungkan tanpa database dulu
    const tempConnection = await mysql.createConnection({
      host: process.env.DB_HOST,
      user: process.env.DB_USER,
      password: process.env.DB_PASSWORD,
    });

    await tempConnection.query(`CREATE DATABASE IF NOT EXISTS \`${dbName}\``);
    console.log(`Database "${dbName}" berhasil dipastikan keberadaannya.`);
    await tempConnection.end();

    // Sekarang hubungkan menggunakan db library kita yang asli
    const db = require('../lib/db');

    // Buat tabel users jika belum ada agar ALTER TABLE tidak error
    console.log('Membuat tabel users jika belum ada...');
    await db.query(`
      CREATE TABLE IF NOT EXISTS \`users\` (
        \`id\` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
        \`name\` VARCHAR(255) NOT NULL,
        \`email\` VARCHAR(255) NOT NULL,
        \`password\` VARCHAR(255) NOT NULL,
        \`created_at\` TIMESTAMP NULL DEFAULT NULL,
        \`updated_at\` TIMESTAMP NULL DEFAULT NULL,
        PRIMARY KEY (\`id\`),
        UNIQUE INDEX \`users_email_unique\` (\`email\`)
      ) ENGINE = InnoDB DEFAULT CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci;
    `);
    console.log('Tabel users siap.');

    const sqlFilePath = path.join(__dirname, 'potential_partners_setup.sql');
    console.log(`Membaca file SQL dari: ${sqlFilePath}`);
    const sqlContent = fs.readFileSync(sqlFilePath, 'utf8');

    // Split statements by semicolon
    const lines = sqlContent.split('\n');
    let queries = [];
    let currentQuery = '';

    for (let line of lines) {
      const trimmed = line.trim();
      
      // Skip empty lines and single-line comments
      if (!trimmed || trimmed.startsWith('--') || trimmed.startsWith('#')) {
        continue;
      }

      currentQuery += line + '\n';

      if (trimmed.endsWith(';')) {
        queries.push(currentQuery.trim());
        currentQuery = '';
      }
    }

    if (currentQuery.trim()) {
      queries.push(currentQuery.trim());
    }

    console.log(`Ditemukan ${queries.length} query untuk dieksekusi.`);

    for (let i = 0; i < queries.length; i++) {
      let query = queries[i];
      
      // Skip USE statements
      if (query.toUpperCase().startsWith('USE ')) {
        console.log(`[SKIP] ${query}`);
        continue;
      }

      console.log(`[EXECUTE ${i + 1}/${queries.length}]: ${query.substring(0, 100)}...`);
      try {
        await db.query(query);
      } catch (queryErr) {
        // Ignored errors:
        // 1060: Duplicate column name (kolom username sudah ada)
        // 1061: Duplicate key name (index unik sudah ada)
        if (queryErr.errno === 1060 || queryErr.errno === 1061) {
          console.log(`[INFO] Kolom atau indeks sudah ada, dilewati (Error ${queryErr.errno}).`);
        } else {
          throw queryErr;
        }
      }
    }

    console.log('Database setup selesai dengan sukses!');
    process.exit(0);
  } catch (err) {
    console.error('Error saat menjalankan setup database:', err);
    process.exit(1);
  }
}

runSetup();
