const db = require('../lib/db');

async function main() {
  try {
    console.log('Membersihkan trigger untuk menghindari error lock...');
    await db.query('DROP TRIGGER IF EXISTS after_insert_partner_potentials');
    await db.query('DROP TRIGGER IF EXISTS after_update_partner_potentials');
    await db.query('DROP TRIGGER IF EXISTS after_update_partners');
    await db.query('DROP TRIGGER IF EXISTS after_delete_partner_potentials');
    await db.query('DROP TRIGGER IF EXISTS before_update_potential_partners');
    console.log('Trigger berhasil dibersihkan sepenuhnya!');
    process.exit(0);
  } catch (err) {
    console.error('Error:', err);
    process.exit(1);
  }
}

main();
