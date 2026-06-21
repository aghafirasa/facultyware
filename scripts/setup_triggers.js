const db = require('../lib/db');

async function setupTriggers() {
  try {
    // Drop existing triggers
    await db.query('DROP TRIGGER IF EXISTS before_insert_potential_partners');
    await db.query('DROP TRIGGER IF EXISTS before_update_potential_partners');

    // Create before insert trigger
    await db.query(`
      CREATE TRIGGER before_insert_potential_partners
      BEFORE INSERT ON potential_partners
      FOR EACH ROW
      BEGIN
        IF NEW.company_name IS NOT NULL AND NEW.nama_instansi IS NULL THEN
          SET NEW.nama_instansi = NEW.company_name;
        ELSEIF NEW.nama_instansi IS NOT NULL AND NEW.company_name IS NULL THEN
          SET NEW.company_name = NEW.nama_instansi;
        END IF;

        IF NEW.contact_person IS NOT NULL AND NEW.kontak_person IS NULL THEN
          SET NEW.kontak_person = NEW.contact_person;
        ELSEIF NEW.kontak_person IS NOT NULL AND NEW.contact_person IS NULL THEN
          SET NEW.contact_person = NEW.kontak_person;
        END IF;

        IF NEW.phone IS NOT NULL AND NEW.telepon IS NULL THEN
          SET NEW.telepon = NEW.phone;
        ELSEIF NEW.telepon IS NOT NULL AND NEW.phone IS NULL THEN
          SET NEW.phone = NEW.telepon;
        END IF;

        IF NEW.address IS NOT NULL AND NEW.alamat IS NULL THEN
          SET NEW.alamat = NEW.address;
        ELSEIF NEW.alamat IS NOT NULL AND NEW.address IS NULL THEN
          SET NEW.address = NEW.alamat;
        END IF;

        IF NEW.partnership_type IS NOT NULL AND NEW.bidang IS NULL THEN
          SET NEW.bidang = NEW.partnership_type;
        ELSEIF NEW.bidang IS NOT NULL AND NEW.partnership_type IS NULL THEN
          IF NEW.bidang IN ('Academic', 'Industry', 'Research', 'Internship', 'Other') THEN
            SET NEW.partnership_type = NEW.bidang;
          ELSE
            SET NEW.partnership_type = 'Other';
          END IF;
        END IF;

        IF NEW.status = 'aktif' THEN
          SET NEW.status = 'active';
        ELSEIF NEW.status = 'nonaktif' THEN
          SET NEW.status = 'inactive';
        END IF;
      END
    `);
    console.log('BEFORE INSERT trigger created successfully.');

    // Create before update trigger
    await db.query(`
      CREATE TRIGGER before_update_potential_partners
      BEFORE UPDATE ON potential_partners
      FOR EACH ROW
      BEGIN
        IF NEW.company_name IS NOT NULL AND (OLD.company_name IS NULL OR NEW.company_name <> OLD.company_name) THEN
          SET NEW.nama_instansi = NEW.company_name;
        ELSEIF NEW.nama_instansi IS NOT NULL AND (OLD.nama_instansi IS NULL OR NEW.nama_instansi <> OLD.nama_instansi) THEN
          SET NEW.company_name = NEW.nama_instansi;
        END IF;

        IF NEW.contact_person IS NOT NULL AND (OLD.contact_person IS NULL OR NEW.contact_person <> OLD.contact_person) THEN
          SET NEW.kontak_person = NEW.contact_person;
        ELSEIF NEW.kontak_person IS NOT NULL AND (OLD.kontak_person IS NULL OR NEW.kontak_person <> OLD.kontak_person) THEN
          SET NEW.contact_person = NEW.kontak_person;
        END IF;

        IF NEW.phone IS NOT NULL AND (OLD.phone IS NULL OR NEW.phone <> OLD.phone) THEN
          SET NEW.telepon = NEW.phone;
        ELSEIF NEW.telepon IS NOT NULL AND (OLD.telepon IS NULL OR NEW.telepon <> OLD.telepon) THEN
          SET NEW.phone = NEW.telepon;
        END IF;

        IF NEW.address IS NOT NULL AND (OLD.address IS NULL OR NEW.address <> OLD.address) THEN
          SET NEW.alamat = NEW.address;
        ELSEIF NEW.alamat IS NOT NULL AND (OLD.alamat IS NULL OR NEW.alamat <> OLD.alamat) THEN
          SET NEW.address = NEW.alamat;
        END IF;

        IF NEW.partnership_type IS NOT NULL AND (OLD.partnership_type IS NULL OR NEW.partnership_type <> OLD.partnership_type) THEN
          SET NEW.bidang = NEW.partnership_type;
        ELSEIF NEW.bidang IS NOT NULL AND (OLD.bidang IS NULL OR NEW.bidang <> OLD.bidang) THEN
          IF NEW.bidang IN ('Academic', 'Industry', 'Research', 'Internship', 'Other') THEN
            SET NEW.partnership_type = NEW.bidang;
          ELSE
            SET NEW.partnership_type = 'Other';
          END IF;
        END IF;

        IF NEW.status = 'aktif' THEN
          SET NEW.status = 'active';
        ELSEIF NEW.status = 'nonaktif' THEN
          SET NEW.status = 'inactive';
        END IF;
      END
    `);
    console.log('BEFORE UPDATE trigger created successfully.');

    process.exit(0);
  } catch (err) {
    console.error('Error setting up triggers:', err);
    process.exit(1);
  }
}

setupTriggers();
