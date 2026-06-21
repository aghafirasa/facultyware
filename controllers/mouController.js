const db = require('../config/db');

const index = (req, res) => {
  db.query('SELECT m.*, p.nama_instansi FROM mou m JOIN potential_partners p ON m.potential_partner_id = p.id ORDER BY m.created_at DESC', (err, results) => {
    if (err) {
      console.error("DB Error (mou/index):", err);
      return res.status(500).send("Terjadi kesalahan pada server saat mengambil data MoU.");
    }
    res.render('mou/index', { mous: results, user: req.session.user });
  });
};

const create = (req, res) => {
  db.query('SELECT id, nama_instansi FROM potential_partners', (err, partners) => {
    if (err) {
      console.error("DB Error (mou/create):", err);
      return res.status(500).send("Terjadi kesalahan pada server saat mengambil data mitra potensial.");
    }
    res.render('mou/create', { partners, user: req.session.user });
  });
};

const store = (req, res) => {
  const { potential_partner_id, draft_isi } = req.body;
  const created_by = req.session.user.id;
  
  db.query(
    'INSERT INTO mou (potential_partner_id, draft_isi, created_by) VALUES (?, ?, ?)',
    [potential_partner_id, draft_isi, created_by],
    (err) => {
      if (err) {
        console.error("DB Error (mou/store):", err);
        return res.status(500).send("Gagal menyimpan draft MoU ke database.");
      }
      res.redirect('/mou');
    }
  );
};

const edit = (req, res) => {
  db.query('SELECT * FROM mou WHERE id = ?', [req.params.id], (err, results) => {
    if (err) {
      console.error("DB Error (mou/edit - query 1):", err);
      return res.status(500).send("Terjadi kesalahan saat mengambil data MoU.");
    }
    if (results.length === 0) return res.redirect('/mou');

    db.query('SELECT id, nama_instansi FROM potential_partners', (err2, partners) => {
      if (err2) {
        console.error("DB Error (mou/edit - query 2):", err2);
        return res.status(500).send("Terjadi kesalahan saat mengambil data mitra potensial.");
      }
      res.render('mou/edit', { mou: results[0], partners, user: req.session.user });
    });
  });
};

const update = (req, res) => {
  const { draft_isi, status } = req.body;
  
  db.query(
    'UPDATE mou SET draft_isi=?, status=? WHERE id=?',
    [draft_isi, status, req.params.id],
    (err) => {
      if (err) {
        console.error("DB Error (mou/update):", err);
        return res.status(500).send("Gagal memperbarui data draft MoU.");
      }
      res.redirect('/mou');
    }
  );
};

const destroy = (req, res) => {
  db.query('DELETE FROM mou WHERE id = ?', [req.params.id], (err) => {
    if (err) {
      console.error("DB Error (mou/destroy):", err);
      return res.status(500).send("Gagal menghapus data MoU.");
    }
    res.redirect('/mou');
  });
};

const approve = (req, res) => {
  const mouId = req.params.id;

  db.query('SELECT potential_partner_id FROM mou WHERE id = ?', [mouId], (err, results) => {
    if (err) {
      console.error("DB Error (mou/approve - Lapisan 1):", err);
      return res.status(500).send("Terjadi kesalahan awal pada proses persetujuan MoU.");
    }
    if (results.length === 0) return res.redirect('/mou');

    const partnerId = results[0].potential_partner_id;

    db.query('UPDATE mou SET status="disetujui" WHERE id=?', [mouId], (err) => {
      if (err) {
        console.error("DB Error (mou/approve - Lapisan 2):", err);
        return res.status(500).send("Gagal memperbarui status dokumen MoU.");
      }

      db.query('UPDATE potential_partners SET status="active" WHERE id=?', [partnerId], (err) => {
        if (err) {
          console.error("DB Error (mou/approve - Lapisan 3):", err);
          return res.status(500).send("MoU disetujui, namun gagal memperbarui status partner menjadi aktif.");
        }
        res.redirect('/mou');
      });
    });
  });
};

const reject = (req, res) => {
  db.query('UPDATE mou SET status="ditolak" WHERE id=?', [req.params.id], (err) => {
    if (err) {
      console.error("DB Error (mou/reject):", err);
      return res.status(500).send("Gagal menolak dokumen MoU.");
    }
    res.redirect('/mou');
  });
};

module.exports = { index, create, store, edit, update, destroy, approve, reject };