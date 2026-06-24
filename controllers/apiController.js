const db = require('../lib/db');

// GET /potential-partners API
const getPotentialPartners = async (req, res) => {
  console.log(`\x1b[36m[REST API] GET ${req.originalUrl} - Request received from ${req.ip}\x1b[0m`);
  
  try {
    const query = 'SELECT id, nama_instansi, bidang, kontak_person, email, telepon, alamat, status, created_at FROM potential_partners ORDER BY created_at DESC';
    const [results] = await db.query(query);
    
    console.log(`\x1b[32m[REST API SUCCESS] GET ${req.originalUrl} - Returned ${results.length} records\x1b[0m`);
    res.status(200).json({ success: true, total_data: results.length, data: results });
  } catch (err) {
    console.error(`\x1b[31m[REST API ERROR] GET ${req.originalUrl} failed: ${err.message}\x1b[0m`);
    res.status(500).json({ success: false, message: "Gagal mengambil data partner.", error: err.message });
  }
};

// POST /potential-partners API
const postPotentialPartners = async (req, res) => {
  console.log(`\x1b[36m[REST API] POST ${req.originalUrl} - Request received from ${req.ip}\x1b[0m`);
  console.log(`[REST API] Payload:`, req.body);

  const { nama_instansi, bidang, kontak_person, email, telepon, alamat, status } = req.body;

  if (!nama_instansi || nama_instansi.trim().length === 0) {
    console.error(`\x1b[31m[REST API ERROR] POST ${req.originalUrl} - Nama instansi is required\x1b[0m`);
    return res.status(400).json({ success: false, message: "nama_instansi wajib diisi." });
  }

  // Map 'bidang' ('Academic', 'Industry', 'Research', 'Other') to 'partnership_type' ('university', 'company', 'government', 'ngo', 'other')
  const partnerType = bidang === 'Academic' ? 'university' :
                      bidang === 'Industry' ? 'company' :
                      bidang === 'Research' ? 'government' : 'other';

  try {
    // 1. Insert into partners
    const [partnerResult] = await db.query(
      'INSERT INTO partners (name, type, email, phone, address, contact_person, created_at) VALUES (?, ?, ?, ?, ?, ?, NOW())',
      [nama_instansi.trim(), partnerType, email || null, telepon || null, alamat || null, kontak_person || null]
    );
    const partnerId = partnerResult.insertId;

    // 2. Insert into partner_potentials
    const ppStatus = status === 'nonaktif' ? 'rejected' : 'identified';
    const [ppResult] = await db.query(
      'INSERT INTO partner_potentials (partner_id, title, description, status, created_at) VALUES (?, ?, ?, ?, NOW())',
      [partnerId, nama_instansi.trim(), 'Ditambahkan via REST API', ppStatus]
    );
    const potentialId = ppResult.insertId;

    // 3. Insert into potential_partners
    await db.query(
      'INSERT INTO potential_partners (id, nama_instansi, bidang, kontak_person, email, telepon, alamat, status, created_at) VALUES (?, ?, ?, ?, ?, ?, ?, ?, NOW())',
      [potentialId, nama_instansi.trim(), bidang || 'Other', kontak_person || null, email || null, telepon || null, alamat || null, status || 'aktif']
    );

    console.log(`\x1b[32m[REST API SUCCESS] POST ${req.originalUrl} - Created ID ${potentialId}\x1b[0m`);
    res.status(201).json({
      success: true,
      message: "Data partner potensial berhasil ditambahkan.",
      data: {
        id: potentialId,
        nama_instansi: nama_instansi.trim(),
        bidang: bidang || 'Other',
        kontak_person,
        email,
        telepon,
        alamat,
        status: status || 'aktif'
      }
    });
  } catch (err) {
    console.error(`\x1b[31m[REST API ERROR] POST ${req.originalUrl} failed: ${err.message}\x1b[0m`);
    res.status(500).json({ success: false, message: "Gagal menyimpan data partner.", error: err.message });
  }
};

// GET /mou API
const getMou = async (req, res) => {
  console.log(`\x1b[36m[REST API] GET ${req.originalUrl} - Request received from ${req.ip}\x1b[0m`);
  
  try {
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
    const [results] = await db.query(query);
    
    console.log(`\x1b[32m[REST API SUCCESS] GET ${req.originalUrl} - Returned ${results.length} records\x1b[0m`);
    res.status(200).json({ success: true, total_data: results.length, data: results });
  } catch (err) {
    console.error(`\x1b[31m[REST API ERROR] GET ${req.originalUrl} failed: ${err.message}\x1b[0m`);
    res.status(500).json({ success: false, message: "Gagal mengambil data kerjasama.", error: err.message });
  }
};

// POST /mou API
const postMou = async (req, res) => {
  console.log(`\x1b[36m[REST API] POST ${req.originalUrl} - Request received from ${req.ip}\x1b[0m`);
  console.log(`[REST API] Payload:`, req.body);

  const { potential_partner_id, draft_isi, created_by } = req.body;

  if (!potential_partner_id || !draft_isi || draft_isi.trim().length === 0) {
    console.error(`\x1b[31m[REST API ERROR] POST ${req.originalUrl} - partner ID and draft_isi are required\x1b[0m`);
    return res.status(400).json({ success: false, message: "potential_partner_id dan draft_isi wajib diisi." });
  }

  try {
    // Check if partner exists
    const [results] = await db.query('SELECT id FROM potential_partners WHERE id = ?', [potential_partner_id]);
    if (results.length === 0) {
      console.error(`\x1b[31m[REST API ERROR] Partner ID ${potential_partner_id} not found\x1b[0m`);
      return res.status(404).json({ success: false, message: `Mitra dengan ID ${potential_partner_id} tidak ditemukan.` });
    }

    // Insert into mou
    const [mouResult] = await db.query(
      'INSERT INTO mou (potential_partner_id, draft_isi, status, created_by, created_at) VALUES (?, ?, ?, ?, NOW())',
      [potential_partner_id, draft_isi.trim(), 'diajukan', created_by || 1]
    );

    const mouId = mouResult.insertId;
    console.log(`\x1b[32m[REST API SUCCESS] POST ${req.originalUrl} - Created ID ${mouId}\x1b[0m`);
    res.status(201).json({
      success: true,
      message: "Draft MoU berhasil ditambahkan.",
      data: {
        id: mouId,
        potential_partner_id,
        draft_isi: draft_isi.trim(),
        status: 'diajukan',
        created_by: created_by || 1
      }
    });
  } catch (err) {
    console.error(`\x1b[31m[REST API ERROR] POST ${req.originalUrl} failed: ${err.message}\x1b[0m`);
    res.status(500).json({ success: false, message: "Gagal menyimpan data MoU.", error: err.message });
  }
};

module.exports = {
  getPotentialPartners,
  postPotentialPartners,
  getMou,
  postMou
};