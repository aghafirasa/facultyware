const express = require('express');
const router = express.Router();
const db = require('../config/db');

router.get('/potential-partners', (req, res) => {
  const query = 'SELECT id, nama_instansi, bidang, kontak_person, email, telepon, alamat, status, created_at FROM potential_partners ORDER BY created_at DESC';
  
  db.query(query, (err, results) => {
    if (err) {
      return res.status(500).json({ success: false, message: "Gagal mengambil data partner.", error: err.message });
    }
    res.status(200).json({ success: true, total_data: results.length, data: results });
  });
});

router.get('/mou', (req, res) => {
  const query = `
    SELECT 
      mou.id AS mou_id, 
      mou.potential_partner_id, 
      potential_partners.nama_instansi, 
      potential_partners.bidang,
      mou.draft_isi, 
      mou.status AS status_mou, 
      mou.created_at 
    FROM mou
    JOIN potential_partners ON mou.potential_partner_id = potential_partners.id
    ORDER BY mou.created_at DESC
  `;

  db.query(query, (err, results) => {
    if (err) {
      return res.status(500).json({ success: false, message: "Gagal mengambil data kerjasama.", error: err.message });
    }
    res.status(200).json({ success: true, total_data: results.length, data: results });
  });
});

module.exports = router;