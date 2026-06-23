const mysql = require('mysql2/promise');
require('dotenv').config();

async function run() {
  // 1. Fix Railway Database
  try {
    console.log('Menghubungkan ke database Railway...');
    const railwayConnection = await mysql.createConnection({
      host: 'thomas.proxy.rlwy.net',
      port: 29503,
      user: 'root',
      password: 'yuwpOeRMeVnFlrPZdbKwlzDhrwhSylvh',
      database: 'railway'
    });

    console.log('Memperbaiki tabel partners di Railway (menambahkan AUTO_INCREMENT)...');
    await railwayConnection.query('ALTER TABLE `partners` MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT');

    console.log('Memperbaiki tabel partner_potentials di Railway (menambahkan AUTO_INCREMENT)...');
    await railwayConnection.query('ALTER TABLE `partner_potentials` MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT');

    console.log('Sukses memperbaiki database Railway!');
    await railwayConnection.end();
  } catch (err) {
    console.error('Gagal memperbaiki Railway database:', err.message);
  }

  // 2. Fix Local Database
  try {
    console.log('Menghubungkan ke database LOCAL (localhost)...');
    const localConnection = await mysql.createConnection({
      host: 'localhost',
      user: 'root',
      password: '',
      database: 'facultyware'
    });

    console.log('Memperbaiki tabel partners di LOCAL (menambahkan AUTO_INCREMENT)...');
    await localConnection.query('ALTER TABLE `partners` MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT');

    console.log('Memperbaiki tabel partner_potentials di LOCAL (menambahkan AUTO_INCREMENT)...');
    await localConnection.query('ALTER TABLE `partner_potentials` MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT');

    console.log('Sukses memperbaiki database LOCAL!');
    await localConnection.end();
  } catch (err) {
    console.error('Gagal memperbaiki LOCAL database (apakah MySQL lokal mati/beda password?):', err.message);
  }
}

run();
