require('dotenv').config(); 
const db = require('./config/db');

// Password asli: 'admin123'
const adminPasswordHash = '$2b$12$R9h/cIPz0gi.URNNX3kh2OPST9/OBXWE5krO9ao5H5UX66vKmTL0W';

console.log('⏳ Mengonfigurasi ulang struktur tabel users...');

// Langkah 1: Ubah kolom username menjadi email (jika belum diubah)
const alterQuery = `
  ALTER TABLE users 
  CHANGE COLUMN username email VARCHAR(100) NOT NULL;
`;

// Langkah 2: Suntikkan data dengan email
const insertQuery = `
  INSERT INTO users (email, password, name, role) 
  VALUES ('admin@unand.ac.id', ?, 'Hubbil Haqi', 'admin')
`;

db.query(alterQuery, (err) => {
  
  console.log('⏳ Menyuntikkan akun admin...');
  db.query(insertQuery, [adminPasswordHash], (err2) => {
    if (err2) {
      if (err2.code === 'ER_DUP_ENTRY') {
        console.log('✅ Akun Admin sudah ada di database.');
      } else {
        console.error('❌ Gagal menyuntikkan user admin:', err2.message);
        process.exit(1);
      }
    } else {
      console.log('==================================================');
      console.log('✅ DATABASE SEEDER SUKSES!');
      console.log('👉 Akun Admin berhasil dibuat dengan Email.');
      console.log('👉 Email    : admin@unand.ac.id');
      console.log('👉 Password : admin123');
      console.log('==================================================');
    }
    process.exit(0);
  });
});