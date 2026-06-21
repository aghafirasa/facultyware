const db = require('../config/db');

const index = (req, res) => {
  db.query('SELECT * FROM potential_partners ORDER BY created_at DESC', (err, results) => {
    if (err) {
      console.error("Error memuat index partner:", err);
      return res.status(500).send("Terjadi kesalahan pada server saat mengambil data partner.");
    }
    res.render('potentialPartner/index', { partners: results, user: req.session.user });
  });
};

const create = (req, res) => {
  res.render('potentialPartner/create', { user: req.session.user });
};

const store = (req, res) => {
  const { nama_instansi, bidang, kontak_person, email, telepon, alamat } = req.body;
  
  const created_by = req.session.user?.id || 1; 
  
  db.query(
    'INSERT INTO potential_partners (nama_instansi, bidang, kontak_person, email, telepon, alamat, created_by) VALUES (?, ?, ?, ?, ?, ?, ?)',
    [nama_instansi, bidang, kontak_person, email, telepon, alamat, created_by],
    (err) => {
      if (err) {
        console.error("Error menyimpan partner baru:", err);
        return res.status(500).send("Gagal menyimpan data partner ke database.");
      }
      res.redirect('/potential-partners');
    }
  );
};

const edit = (req, res) => {
  db.query('SELECT * FROM potential_partners WHERE id = ?', [req.params.id], (err, results) => {
    if (err) {
      console.error("Error mengambil data edit partner:", err);
      return res.redirect('/potential-partners');
    }
    if (results.length === 0) return res.redirect('/potential-partners');
    res.render('potentialPartner/edit', { partner: results[0], user: req.session.user });
  });
};

const update = (req, res) => {
  const { nama_instansi, bidang, kontak_person, email, telepon, alamat, status } = req.body;
  
  db.query(
    'UPDATE potential_partners SET nama_instansi=?, bidang=?, kontak_person=?, email=?, telepon=?, alamat=?, status=? WHERE id=?',
    [nama_instansi, bidang, kontak_person, email, telepon, alamat, status, req.params.id],
    (err) => {
      if (err) {
        console.error("Error memperbarui data partner:", err);
        return res.status(500).send("Gagal memperbarui data partner di database.");
      }
      res.redirect('/potential-partners');
    }
  );
};

const destroy = (req, res) => {
  const partnerId = req.params.id;

  db.query('DELETE FROM potential_partners WHERE id = ?', [partnerId], (err) => {
    if (err) {
      console.error("Delete Error Log:", err);

      if (err.errno === 1451 || err.code === 'ER_ROW_IS_REFERENCED_2') {
        return res.status(400).send(`
          <script>
            alert("Gagal Menghapus! Partner ini tidak bisa dihapus karena masih memiliki riwayat MoU atau Follow-Up aktif. Hapus data terkait terlebih dahulu.");
            window.location.href = "/potential-partners";
          </script>
        `);
      }

      return res.status(500).send("Terjadi kesalahan internal server saat mencoba menghapus data.");
    }

    res.redirect('/potential-partners');
  });
};

module.exports = { index, create, store, edit, update, destroy };
