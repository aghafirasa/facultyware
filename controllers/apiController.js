const db = require('../config/db');

const getPartners = (req, res) => {
  db.query('SELECT id, nama_instansi, bidang, email, status, created_at FROM potential_partners', (err, results) => {
    if (err) return res.status(500).json({ status: 'error', message: err.message });
    res.status(200).json({ status: 'success', data: results });
  });
};

const getMoU = (req, res) => {
  db.query('SELECT m.id, p.nama_instansi, m.status, m.created_at FROM mou m JOIN potential_partners p ON m.potential_partner_id = p.id', (err, results) => {
    if (err) return res.status(500).json({ status: 'error', message: err.message });
    res.status(200).json({ status: 'success', data: results });
  });
};

module.exports = { getPartners, getMoU };