const db = require('../config/db');

const exportPartners = (req, res) => {
  db.query('SELECT id, nama_instansi, bidang, kontak_person, email, telepon, status FROM potential_partners ORDER BY created_at DESC', (err, results) => {
    if (err) {
        console.error(err);
        return res.status(500).send("Gagal mengambil data ekspor partner");
    }

    let csvData = "ID,Nama Instansi,Bidang,Kontak Person,Email,Telepon,Status\n";
    results.forEach(row => {
      const escape = (str) => str ? String(str).replace(/"/g, '""') : '';
      
      csvData += `${row.id},"${escape(row.nama_instansi)}","${escape(row.bidang)}","${escape(row.kontak_person)}","${escape(row.email)}","${escape(row.telepon)}","${row.status}"\n`;
    });

    res.setHeader('Content-Type', 'text/csv');
    res.setHeader('Content-Disposition', 'attachment; filename="Data_Potential_Partners.csv"');
    res.status(200).send(csvData);
  });
};

const exportMoUPDF = (req, res) => {
  db.query('SELECT m.id, p.nama_instansi, m.draft_isi, m.status, m.created_at FROM mou m JOIN potential_partners p ON m.potential_partner_id = p.id ORDER BY m.created_at DESC', (err, results) => {
    if (err) {
        console.error(err);
        return res.status(500).send("Gagal mengambil data laporan MoU");
    }

    res.render('mou/report_pdf', { mous: results });
  });
};

module.exports = { exportPartners, exportMoUPDF };