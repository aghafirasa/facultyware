const db = require('../config/db');

const index = (req, res) => {
  db.query('SELECT f.*, p.nama_instansi FROM follow_up f JOIN potential_partners p ON f.potential_partner_id = p.id ORDER BY f.created_at DESC', (err, results) => {
    if (err) {
      console.error("DB Error (followUp/index):", err);
      return res.status(500).send("Terjadi kesalahan saat mengambil data follow up.");
    }
    res.render('followUp/index', { followUps: results, user: req.session.user });
  });
};

const create = (req, res) => {
  db.query('SELECT id, nama_instansi FROM potential_partners', (err, partners) => {
    if (err) {
      console.error("DB Error (followUp/create):", err);
      return res.status(500).send("Terjadi kesalahan saat memuat data mitra.");
    }
    res.render('followUp/create', { partners, user: req.session.user });
  });
};

const store = (req, res) => {
const { potential_partner_id, catatan, tanggal } = req.body;
  
const created_by = req.session.user?.id || 1;

  if (!potential_partner_id) {
    console.error("Error: potential_partner_id tidak terbaca dari form!");
    return res.status(400).send("ID Partner tidak valid.");
  }

  const query = 'INSERT INTO follow_up (potential_partner_id, catatan, tanggal, created_by) VALUES (?, ?, ?, ?)';
  
  db.query(query, [potential_partner_id, catatan, tanggal, created_by], (err, result) => {
    if (err) {
      console.error("Error menyimpan follow up baru:", err);
      return res.status(500).send("Gagal menyimpan data follow up ke database.");
    }
    
    res.redirect('/follow-up');
  });
};

const edit = (req, res) => {
  db.query('SELECT * FROM follow_up WHERE id = ?', [req.params.id], (err, results) => {
    if (err) {
      console.error("DB Error (followUp/edit - query 1):", err);
      return res.status(500).send("Terjadi kesalahan saat mengambil data follow up.");
    }
    if (results.length === 0) return res.redirect('/follow-up');

    db.query('SELECT id, nama_instansi FROM potential_partners', (err2, partners) => {
      if (err2) {
        console.error("DB Error (followUp/edit - query 2):", err2);
        return res.status(500).send("Terjadi kesalahan saat mengambil data mitra potensial.");
      }

      const followUp = results[0];
      
      if (followUp.tanggal) {
        const d = new Date(followUp.tanggal);
        const year = d.getFullYear();
        const month = String(d.getMonth() + 1).padStart(2, '0');
        const day = String(d.getDate()).padStart(2, '0');
        followUp.tanggal_formatted = `${year}-${month}-${day}`;
      } else {
        followUp.tanggal_formatted = '';
      }

      res.render('followUp/edit', { followUp, partners, user: req.session.user });
    });
  });
};

const update = (req, res) => {
  const { potential_partner_id, catatan, tanggal } = req.body;
  db.query(
    'UPDATE follow_up SET potential_partner_id=?, catatan=?, tanggal=? WHERE id=?',
    [potential_partner_id, catatan, tanggal, req.params.id],
    (err) => {
      if (err) {
        console.error("DB Error (followUp/update):", err);
        return res.status(500).send("Gagal memperbarui data follow up.");
      }
      res.redirect('/follow-up');
    }
  );
};

const destroy = (req, res) => {
  db.query('DELETE FROM follow_up WHERE id = ?', [req.params.id], (err) => {
    if (err) {
      console.error("DB Error (followUp/destroy):", err);
      return res.status(500).send("Gagal menghapus data follow up.");
    }
    res.redirect('/follow-up');
  });
};

module.exports = { index, create, store, edit, update, destroy };