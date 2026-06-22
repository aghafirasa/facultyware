const db = require('../lib/db');
const fs = require('fs');
const path = require('path');

async function migrate() {
  try {
    console.log('Memulai migrasi database modul Potential Partner...');

    // 1. Cek apakah tabel potential_partners ada
    const [tables] = await db.query('SHOW TABLES');
    const tableNames = tables.map(t => Object.values(t)[0]);
    const hasOldTable = tableNames.includes('potential_partners');

    if (!hasOldTable) {
      console.log('Tabel lama "potential_partners" tidak ditemukan. Menjalankan setup skema tabel baru...');
      await runSetupScript();
      return;
    }

    // 2. Ambil data dari tabel lama
    const [oldRows] = await db.query('SELECT * FROM potential_partners');
    console.log(`Menemukan ${oldRows.length} data di tabel lama "potential_partners".`);

    // 3. Jalankan setup skema tabel baru (partners & partner_potentials)
    await runSetupScript();

    // 4. Migrasi data ke tabel baru jika ada data lama
    if (oldRows.length > 0) {
      console.log('Memindahkan data ke tabel baru...');
      
      const typeMapping = {
        'Academic': 'university',
        'Research': 'university',
        'Industry': 'company',
        'Internship': 'company',
        'Other': 'other'
      };

      const statusMapping = {
        'active': 'identified',
        'inactive': 'rejected'
      };

      for (const row of oldRows) {
        // Cek apakah data ini sudah pernah dimigrasi (hindari duplikasi)
        const [existingPartner] = await db.query('SELECT id FROM partners WHERE name = ? AND email = ?', [row.company_name, row.email]);
        
        let partnerId;
        if (existingPartner.length > 0) {
          partnerId = existingPartner[0].id;
          console.log(`Mitra "${row.company_name}" sudah ada di tabel partners (ID: ${partnerId}).`);
        } else {
          // Insert ke partners
          const mappedType = typeMapping[row.partnership_type] || 'other';
          const [partnerResult] = await db.query(
            `INSERT INTO partners (name, type, email, phone, address, contact_person, created_at, updated_at)
             VALUES (?, ?, ?, ?, ?, ?, ?, ?)`,
            [
              row.company_name,
              mappedType,
              row.email || null,
              row.phone || null,
              row.address || null,
              row.contact_person || null,
              row.created_at,
              row.updated_at
            ]
          );
          partnerId = partnerResult.insertId;
        }

        // Insert ke partner_potentials jika belum ada
        const [existingPotential] = await db.query('SELECT id FROM partner_potentials WHERE partner_id = ? AND title = ?', [partnerId, row.company_name]);
        if (existingPotential.length === 0) {
          const mappedStatus = statusMapping[row.status] || 'identified';
          await db.query(
            `INSERT INTO partner_potentials (partner_id, title, description, status, created_at, updated_at)
             VALUES (?, ?, ?, ?, ?, ?)`,
            [
              partnerId,
              row.company_name,
              row.description || null,
              mappedStatus,
              row.created_at,
              row.updated_at
            ]
          );
        }
      }
      console.log('Seluruh data lama berhasil dimigrasikan ke tabel baru.');
    }

    // 5. Ubah nama tabel lama agar tidak dipakai lagi (sebagai backup)
    const backupTableName = `potential_partners_backup_${Date.now()}`;
    await db.query(`RENAME TABLE potential_partners TO ${backupTableName}`);
    console.log(`Tabel lama "potential_partners" telah di-rename menjadi "${backupTableName}" sebagai cadangan.`);
    console.log('Migrasi selesai dengan sukses!');
    process.exit(0);

  } catch (err) {
    console.error('Terjadi error saat migrasi:', err);
    process.exit(1);
  }
}

async function runSetupScript() {
  const sqlFilePath = path.join(__dirname, 'potential_partners_setup.sql');
  const sqlContent = fs.readFileSync(sqlFilePath, 'utf8');

  // Pisahkan query berdasarkan titik koma
  const lines = sqlContent.split('\n');
  let queries = [];
  let currentQuery = '';

  for (let line of lines) {
    const trimmed = line.trim();
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

  for (let i = 0; i < queries.length; i++) {
    const query = queries[i];
    if (query.toUpperCase().startsWith('USE ')) {
      continue;
    }
    try {
      await db.query(query);
    } catch (queryErr) {
      // Abaikan error kolom/indeks duplikat
      if (queryErr.errno === 1060 || queryErr.errno === 1061) {
        continue;
      } else {
        throw queryErr;
      }
    }
  }
  console.log('Skema database baru berhasil dipastikan.');
}

migrate();
