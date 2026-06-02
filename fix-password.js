require('dotenv').config();
const db = require('./config/db');
const bcrypt = require('bcryptjs');

const plainPassword = 'admin123';
const targetEmail = 'admin@unand.ac.id';

console.log('⏳ Menghitung hash asli menggunakan bcryptjs lokal proyek Anda...');

bcrypt.hash(plainPassword, 10, (err, hash) => {
  if (err) {
    console.error('❌ Gagal membuat hash:', err.message);
    process.exit(1);
  }

  console.log(`⏳ Memperbarui password untuk ${targetEmail}...`);
  
  const query = 'UPDATE users SET password = ? WHERE email = ?';
  db.query(query, [hash, targetEmail], (errQuery, result) => {
    if (errQuery) {
      console.error('❌ Gagal memperbarui database:', errQuery.message);
      process.exit(1);
    }
    
    if (result.affectedRows === 0) {
      console.log('❌ Gagal: Email admin@unand.ac.id tidak ditemukan di tabel users.');
    } else {
      console.log('==================================================');
      console.log('✅ SINKRONISASI PASSWORD BERHASIL!');
      console.log(`👉 Password "${plainPassword}" telah di-hash secara lokal.`);
      console.log('👉 Kolom password di phpMyAdmin telah diperbarui.');
      console.log('==================================================');
    }
    process.exit(0);
  });
});