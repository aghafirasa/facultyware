const db = require('../lib/db');

async function main() {
  try {
    console.log('Memulai pembuatan tabel sinkronisasi potential_partners...');

    // 1. Buat tabel potential_partners kembali jika belum ada
    await db.query(`
      CREATE TABLE IF NOT EXISTS \`potential_partners\` (
        \`id\` BIGINT UNSIGNED NOT NULL,
        \`nama_instansi\` VARCHAR(255) NULL,
        \`bidang\` VARCHAR(100) NULL,
        \`kontak_person\` VARCHAR(255) NULL,
        \`email\` VARCHAR(255) NULL,
        \`telepon\` VARCHAR(50) NULL,
        \`alamat\` TEXT NULL,
        \`status\` VARCHAR(50) NULL DEFAULT 'aktif',
        \`created_at\` TIMESTAMP NULL DEFAULT NULL,
        \`updated_at\` TIMESTAMP NULL DEFAULT NULL,
        PRIMARY KEY (\`id\`)
      ) ENGINE = InnoDB DEFAULT CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci;
    `);
    console.log('Tabel physical "potential_partners" siap.');

    // 2. Kosongkan data lama di potential_partners dan isi ulang dari partners + partner_potentials
    await db.query('TRUNCATE TABLE potential_partners');
    
    const [rows] = await db.query(`
      SELECT 
        pp.id,
        p.name AS nama_instansi,
        CASE p.type
          WHEN 'university' THEN 'Academic'
          WHEN 'company' THEN 'Industry'
          WHEN 'government' THEN 'Research'
          WHEN 'ngo' THEN 'Other'
          ELSE 'Other'
        END AS bidang,
        p.contact_person AS kontak_person,
        p.email AS email,
        p.phone AS telepon,
        p.address AS alamat,
        CASE pp.status
          WHEN 'rejected' THEN 'nonaktif'
          ELSE 'aktif'
        END AS status,
        pp.created_at,
        pp.updated_at
      FROM partner_potentials pp
      JOIN partners p ON pp.partner_id = p.id
    `);

    console.log(`Mengisi ulang ${rows.length} data ke potential_partners...`);
    for (const row of rows) {
      await db.query(`
        INSERT INTO potential_partners 
          (id, nama_instansi, bidang, kontak_person, email, telepon, alamat, status, created_at, updated_at)
        VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
      `, [
        row.id,
        row.nama_instansi,
        row.bidang,
        row.kontak_person,
        row.email,
        row.telepon,
        row.alamat,
        row.status,
        row.created_at,
        row.updated_at
      ]);
    }
    console.log('Data potential_partners berhasil disinkronkan.');

    // 3. Drop trigger lama jika ada
    await db.query('DROP TRIGGER IF EXISTS after_insert_partner_potentials');
    await db.query('DROP TRIGGER IF EXISTS after_update_partner_potentials');
    await db.query('DROP TRIGGER IF EXISTS after_update_partners');
    await db.query('DROP TRIGGER IF EXISTS after_delete_partner_potentials');
    await db.query('DROP TRIGGER IF EXISTS before_update_potential_partners');
    console.log('Trigger lama dibersihkan.');

    // 4. Buat trigger sinkronisasi dari partner_potentials ke potential_partners (INSERT)
    await db.query(`
      CREATE TRIGGER after_insert_partner_potentials
      AFTER INSERT ON partner_potentials
      FOR EACH ROW
      BEGIN
        DECLARE partner_name VARCHAR(255);
        DECLARE partner_type VARCHAR(50);
        DECLARE partner_email VARCHAR(255);
        DECLARE partner_phone VARCHAR(50);
        DECLARE partner_address TEXT;
        DECLARE partner_contact VARCHAR(255);
        
        SELECT name, type, email, phone, address, contact_person 
        INTO partner_name, partner_type, partner_email, partner_phone, partner_address, partner_contact
        FROM partners WHERE id = NEW.partner_id;
        
        INSERT INTO potential_partners 
          (id, nama_instansi, bidang, kontak_person, email, telepon, alamat, status, created_at, updated_at)
        VALUES (
          NEW.id,
          partner_name,
          CASE partner_type
            WHEN 'university' THEN 'Academic'
            WHEN 'company' THEN 'Industry'
            WHEN 'government' THEN 'Research'
            WHEN 'ngo' THEN 'Other'
            ELSE 'Other'
          END,
          partner_contact,
          partner_email,
          partner_phone,
          partner_address,
          CASE NEW.status
            WHEN 'rejected' THEN 'nonaktif'
            ELSE 'aktif'
          END,
          NEW.created_at,
          NEW.updated_at
        );
      END;
    `);
    console.log('Trigger after_insert_partner_potentials berhasil dibuat.');

    // 5. Buat trigger sinkronisasi dari partner_potentials ke potential_partners (UPDATE)
    await db.query(`
      CREATE TRIGGER after_update_partner_potentials
      AFTER UPDATE ON partner_potentials
      FOR EACH ROW
      BEGIN
        UPDATE potential_partners
        SET status = CASE NEW.status WHEN 'rejected' THEN 'nonaktif' ELSE 'aktif' END,
            description = NEW.description,
            updated_at = NEW.updated_at
        WHERE id = NEW.id;
      END;
    `);
    console.log('Trigger after_update_partner_potentials berhasil dibuat.');

    // 6. Buat trigger sinkronisasi dari partners ke potential_partners (UPDATE)
    await db.query(`
      CREATE TRIGGER after_update_partners
      AFTER UPDATE ON partners
      FOR EACH ROW
      BEGIN
        UPDATE potential_partners pp
        JOIN partner_potentials pot ON pp.id = pot.id
        SET pp.nama_instansi = NEW.name,
            pp.bidang = CASE NEW.type
              WHEN 'university' THEN 'Academic'
              WHEN 'company' THEN 'Industry'
              WHEN 'government' THEN 'Research'
              WHEN 'ngo' THEN 'Other'
              ELSE 'Other'
            END,
            pp.kontak_person = NEW.contact_person,
            pp.email = NEW.email,
            pp.telepon = NEW.phone,
            pp.alamat = NEW.address
        WHERE pot.partner_id = NEW.id;
      END;
    `);
    console.log('Trigger after_update_partners berhasil dibuat.');

    // 7. Buat trigger sinkronisasi dari partner_potentials ke potential_partners (DELETE)
    await db.query(`
      CREATE TRIGGER after_delete_partner_potentials
      AFTER DELETE ON partner_potentials
      FOR EACH ROW
      BEGIN
        DELETE FROM potential_partners WHERE id = OLD.id;
      END;
    `);
    console.log('Trigger after_delete_partner_potentials berhasil dibuat.');

    // 8. Buat trigger sinkronisasi balik dari potential_partners ke partner_potentials (UPDATE)
    // Digunakan saat teman meng-update status di MoU / follow-up
    await db.query(`
      CREATE TRIGGER before_update_potential_partners
      BEFORE UPDATE ON potential_partners
      FOR EACH ROW
      BEGIN
        DECLARE new_pp_status VARCHAR(50);
        IF NEW.status = 'active' OR NEW.status = 'aktif' THEN
          SET new_pp_status = 'converted';
        ELSEIF NEW.status = 'inactive' OR NEW.status = 'nonaktif' THEN
          SET new_pp_status = 'rejected';
        ELSE
          SET new_pp_status = NEW.status;
        END IF;
        
        UPDATE partner_potentials
        SET status = new_pp_status,
            updated_at = NOW()
        WHERE id = NEW.id;
      END;
    `);
    console.log('Trigger before_update_potential_partners berhasil dibuat.');

    console.log('Sinkronisasi database berhasil disiapkan sepenuhnya!');
    process.exit(0);
  } catch (err) {
    console.error('Error saat setup sinkronisasi:', err);
    process.exit(1);
  }
}

main();
