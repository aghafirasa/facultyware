CREATE DATABASE IF NOT EXISTS db_kerjasama;
USE db_kerjasama;

CREATE TABLE users (
  id INT PRIMARY KEY AUTO_INCREMENT,
  name VARCHAR(100),
  email VARCHAR(100) UNIQUE,
  password VARCHAR(255),
  role ENUM('admin', 'user') DEFAULT 'user',
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE potential_partners (
  id INT PRIMARY KEY AUTO_INCREMENT,
  nama_instansi VARCHAR(200),
  bidang VARCHAR(100),
  kontak_person VARCHAR(100),
  email VARCHAR(100),
  telepon VARCHAR(20),
  alamat TEXT,
  status ENUM('aktif', 'nonaktif') DEFAULT 'aktif',
  created_by INT,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (created_by) REFERENCES users(id)
);

CREATE TABLE follow_up (
  id INT PRIMARY KEY AUTO_INCREMENT,
  potential_partner_id INT,
  catatan TEXT,
  tanggal DATE,
  created_by INT,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (potential_partner_id) REFERENCES potential_partners(id),
  FOREIGN KEY (created_by) REFERENCES users(id)
);

CREATE TABLE mou (
  id INT PRIMARY KEY AUTO_INCREMENT,
  potential_partner_id INT,
  draft_isi TEXT,
  status ENUM('draft', 'disetujui', 'ditolak') DEFAULT 'draft',
  created_by INT,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (potential_partner_id) REFERENCES potential_partners(id),
  FOREIGN KEY (created_by) REFERENCES users(id)
);