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

    console.log('Memperbaiki tabel follow_up di Railway (menambahkan AUTO_INCREMENT)...');
    await railwayConnection.query('ALTER TABLE `follow_up` MODIFY `id` int NOT NULL AUTO_INCREMENT');

    console.log('Memperbaiki tabel mou di Railway (menambahkan AUTO_INCREMENT)...');
    await railwayConnection.query('ALTER TABLE `mou` MODIFY `id` int NOT NULL AUTO_INCREMENT');

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

    console.log('Memperbaiki tabel follow_up di LOCAL (menambahkan AUTO_INCREMENT)...');
    await localConnection.query('ALTER TABLE `follow_up` MODIFY `id` int NOT NULL AUTO_INCREMENT');

    console.log('Memperbaiki tabel mou di LOCAL (menambahkan AUTO_INCREMENT)...');
    await localConnection.query('ALTER TABLE `mou` MODIFY `id` int NOT NULL AUTO_INCREMENT');

    console.log('Sukses memperbaiki database LOCAL!');
    await localConnection.end();
  } catch (err) {
    console.error('Gagal memperbaiki LOCAL database (apakah MySQL lokal mati/beda password?):', err.message);
  }
}

run();
