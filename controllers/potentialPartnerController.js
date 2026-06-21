const db = require('../lib/db');

// ============================================================
// Helpers
// ============================================================

/**
 * Validasi data potential partner di sisi server (tanpa library eksternal).
 * Returns array of error strings (kosong = valid).
 */
function validatePartnerData({ company_name, email, phone, partnership_type, status }) {
  const errors = [];

  // company_name — wajib, max 255 karakter
  if (!company_name || company_name.trim().length === 0) {
    errors.push('Nama perusahaan wajib diisi.');
  } else if (company_name.trim().length > 255) {
    errors.push('Nama perusahaan maksimal 255 karakter.');
  }

  // email — opsional, tapi harus valid jika diisi
  if (email && email.trim().length > 0) {
    const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
    if (!emailRegex.test(email.trim())) {
      errors.push('Format email tidak valid.');
    } else if (email.trim().length > 255) {
      errors.push('Email maksimal 255 karakter.');
    }
  }

  // phone — opsional, hanya angka/+/-/spasi/()/., max 50 karakter
  if (phone && phone.trim().length > 0) {
    const phoneRegex = /^[0-9+\-\s().]+$/;
    if (!phoneRegex.test(phone.trim())) {
      errors.push('Nomor telepon hanya boleh berisi angka dan karakter + - ( ) spasi.');
    } else if (phone.trim().length > 50) {
      errors.push('Nomor telepon maksimal 50 karakter.');
    }
  }

  // partnership_type — harus salah satu nilai enum jika diisi
  const validTypes = ['Academic', 'Industry', 'Research', 'Internship', 'Other'];
  if (partnership_type && partnership_type.trim().length > 0) {
    if (!validTypes.includes(partnership_type.trim())) {
      errors.push('Tipe partnership tidak valid.');
    }
  }

  // status — hanya untuk update, harus active atau inactive
  if (status !== undefined && status !== '') {
    if (!['active', 'inactive'].includes(status)) {
      errors.push('Status tidak valid.');
    }
  }

  return errors;
}

// ============================================================
// Controller
// ============================================================

const potentialPartnerController = {

  // ----------------------------------------------------------
  // LIST — tampilkan semua data dengan search & pagination
  // ----------------------------------------------------------
  list: async (req, res) => {
    try {
      const page   = Math.max(1, parseInt(req.query.page) || 1);
      const limit  = 10;
      const offset = (page - 1) * limit;
      const search = req.query.search ? req.query.search.trim() : '';
      const filterStatus = req.query.status || '';

      const conditions = [];
      const params     = [];

      if (search) {
        conditions.push('(company_name LIKE ? OR contact_person LIKE ? OR email LIKE ? OR phone LIKE ?)');
        params.push(`%${search}%`, `%${search}%`, `%${search}%`, `%${search}%`);
      }
      if (filterStatus && ['active', 'inactive'].includes(filterStatus)) {
        conditions.push('status = ?');
        params.push(filterStatus);
      }

      const where = conditions.length > 0 ? 'WHERE ' + conditions.join(' AND ') : '';

      // Hitung total data untuk pagination
      const [countRows] = await db.query(
        `SELECT COUNT(*) AS total FROM potential_partners ${where}`,
        params
      );
      const total      = countRows[0].total;
      const totalPages = Math.max(1, Math.ceil(total / limit));

      // Ambil data dengan LIMIT & OFFSET
      const [rows] = await db.query(
        `SELECT * FROM potential_partners ${where} ORDER BY created_at DESC LIMIT ? OFFSET ?`,
        [...params, limit, offset]
      );

      const messages = req.session.flash || {};
      req.session.flash = {};

      res.render('potential-partners/index', {
        potentialPartners : rows,
        title             : 'Potential Partner',
        search,
        filterStatus,
        currentPage  : page,
        totalPages,
        total,
        messages,
        user: req.session.username || 'Admin',
      });
    } catch (err) {
      console.error('[PP list]', err);
      req.session.flash = { error: 'Gagal mengambil data: ' + err.message };
      res.redirect('/');
    }
  },

  // ----------------------------------------------------------
  // ADD — tampilkan form tambah
  // ----------------------------------------------------------
  add: (req, res) => {
    const messages = req.session.flash || {};
    req.session.flash = {};
    res.render('potential-partners/add', {
      title    : 'Tambah Potential Partner',
      errors   : messages.errors || [],
      oldInput : messages.oldInput || {},
      messages,
      user: req.session.username || 'Admin',
    });
  },

  // ----------------------------------------------------------
  // STORE — proses simpan data baru
  // ----------------------------------------------------------
  store: async (req, res) => {
    const {
      company_name, contact_person, email, phone,
      address, partnership_type, description
    } = req.body;

    // Validasi server-side
    const errors = validatePartnerData({ company_name, email, phone, partnership_type });

    if (errors.length > 0) {
      req.session.flash = {
        errors,
        oldInput: { company_name, contact_person, email, phone, address, partnership_type, description },
      };
      return res.redirect('/potential-partners/add');
    }

    try {
      await db.query(
        `INSERT INTO potential_partners
           (company_name, contact_person, email, phone, address, partnership_type, description, status, created_at)
         VALUES (?, ?, ?, ?, ?, ?, ?, 'active', NOW())`,
        [
          company_name.trim(),
          contact_person ? contact_person.trim() || null : null,
          email          ? email.trim()          || null : null,
          phone          ? phone.trim()           || null : null,
          address        ? address.trim()         || null : null,
          partnership_type && partnership_type.trim() ? partnership_type.trim() : null,
          description    ? description.trim()     || null : null,
        ]
      );

      req.session.flash = { success: `Data "${company_name.trim()}" berhasil ditambahkan.` };
      res.redirect('/potential-partners');
    } catch (err) {
      console.error('[PP store]', err);
      req.session.flash = {
        errors  : ['Gagal menyimpan data ke database: ' + err.message],
        oldInput: { company_name, contact_person, email, phone, address, partnership_type, description },
      };
      res.redirect('/potential-partners/add');
    }
  },

  // ----------------------------------------------------------
  // EDIT — tampilkan form edit
  // ----------------------------------------------------------
  edit: async (req, res) => {
    const { id } = req.params;

    if (!id || isNaN(parseInt(id))) {
      req.session.flash = { error: 'ID tidak valid.' };
      return res.redirect('/potential-partners');
    }

    try {
      const [results] = await db.query(
        'SELECT * FROM potential_partners WHERE id = ?', [id]
      );

      if (results.length === 0) {
        req.session.flash = { error: 'Data potential partner tidak ditemukan.' };
        return res.redirect('/potential-partners');
      }

      const messages = req.session.flash || {};
      req.session.flash = {};

      res.render('potential-partners/edit', {
        potentialPartner : results[0],
        title            : 'Edit Potential Partner',
        errors           : messages.errors || [],
        messages,
        user: req.session.username || 'Admin',
      });
    } catch (err) {
      console.error('[PP edit]', err);
      req.session.flash = { error: 'Gagal memuat data: ' + err.message };
      res.redirect('/potential-partners');
    }
  },

  // ----------------------------------------------------------
  // UPDATE — proses simpan perubahan
  // ----------------------------------------------------------
  update: async (req, res) => {
    const { id } = req.params;
    const {
      company_name, contact_person, email, phone,
      address, partnership_type, description, status
    } = req.body;

    if (!id || isNaN(parseInt(id))) {
      req.session.flash = { error: 'ID tidak valid.' };
      return res.redirect('/potential-partners');
    }

    // Validasi server-side
    const errors = validatePartnerData({ company_name, email, phone, partnership_type, status });

    if (errors.length > 0) {
      req.session.flash = { errors };
      return res.redirect(`/potential-partners/edit/${id}`);
    }

    try {
      // Cek data exists
      const [check] = await db.query(
        'SELECT id FROM potential_partners WHERE id = ?', [id]
      );
      if (check.length === 0) {
        req.session.flash = { error: 'Data potential partner tidak ditemukan.' };
        return res.redirect('/potential-partners');
      }

      await db.query(
        `UPDATE potential_partners
         SET company_name = ?, contact_person = ?, email = ?, phone = ?,
             address = ?, partnership_type = ?, description = ?, status = ?, updated_at = NOW()
         WHERE id = ?`,
        [
          company_name.trim(),
          contact_person ? contact_person.trim() || null : null,
          email          ? email.trim()          || null : null,
          phone          ? phone.trim()           || null : null,
          address        ? address.trim()         || null : null,
          partnership_type && partnership_type.trim() ? partnership_type.trim() : null,
          description    ? description.trim()     || null : null,
          status || 'active',
          id,
        ]
      );

      req.session.flash = { success: `Data "${company_name.trim()}" berhasil diperbarui.` };
      res.redirect('/potential-partners');
    } catch (err) {
      console.error('[PP update]', err);
      req.session.flash = { errors: ['Gagal memperbarui data: ' + err.message] };
      res.redirect(`/potential-partners/edit/${id}`);
    }
  },

  // ----------------------------------------------------------
  // DELETE — hapus data
  // ----------------------------------------------------------
  delete: async (req, res) => {
    const { id } = req.params;

    if (!id || isNaN(parseInt(id))) {
      req.session.flash = { error: 'ID tidak valid.' };
      return res.redirect('/potential-partners');
    }

    try {
      const [check] = await db.query(
        'SELECT company_name FROM potential_partners WHERE id = ?', [id]
      );
      if (check.length === 0) {
        req.session.flash = { error: 'Data potential partner tidak ditemukan.' };
        return res.redirect('/potential-partners');
      }

      const companyName = check[0].company_name;
      await db.query('DELETE FROM potential_partners WHERE id = ?', [id]);

      req.session.flash = { success: `Data "${companyName}" berhasil dihapus.` };
      res.redirect('/potential-partners');
    } catch (err) {
      console.error('[PP delete]', err);
      req.session.flash = { error: 'Gagal menghapus data: ' + err.message };
      res.redirect('/potential-partners');
    }
  },

  // ----------------------------------------------------------
  // REST API — GET /potential-partners/api
  // ----------------------------------------------------------
  apiList: async (req, res) => {
    try {
      const page   = Math.max(1, parseInt(req.query.page) || 1);
      const limit  = Math.min(100, Math.max(1, parseInt(req.query.limit) || 10));
      const offset = (page - 1) * limit;
      const search = req.query.search ? req.query.search.trim() : '';
      const status = req.query.status || '';

      const conditions = [];
      const params     = [];

      if (search) {
        conditions.push('(company_name LIKE ? OR contact_person LIKE ? OR email LIKE ?)');
        params.push(`%${search}%`, `%${search}%`, `%${search}%`);
      }
      if (status && ['active', 'inactive'].includes(status)) {
        conditions.push('status = ?');
        params.push(status);
      }

      const where = conditions.length > 0 ? 'WHERE ' + conditions.join(' AND ') : '';

      const [countRows] = await db.query(
        `SELECT COUNT(*) AS total FROM potential_partners ${where}`, params
      );
      const total = countRows[0].total;

      const [rows] = await db.query(
        `SELECT id, company_name, contact_person, email, phone, address,
                partnership_type, description, status, created_at, updated_at
         FROM potential_partners ${where}
         ORDER BY created_at DESC LIMIT ? OFFSET ?`,
        [...params, limit, offset]
      );

      res.json({
        success    : true,
        data       : rows,
        pagination : {
          page,
          limit,
          total,
          totalPages: Math.max(1, Math.ceil(total / limit)),
        },
        meta: {
          timestamp: new Date().toISOString(),
          endpoint : '/potential-partners/api',
        },
      });
    } catch (err) {
      console.error('[PP apiList]', err);
      res.status(500).json({
        success : false,
        message : 'Internal server error',
        error   : err.message,
      });
    }
  },

  // ----------------------------------------------------------
  // EXPORT CSV — GET /potential-partners/export/csv
  // ----------------------------------------------------------
  exportCsv: async (req, res) => {
    try {
      const [rows] = await db.query(
        `SELECT id, company_name, contact_person, email, phone, address,
                partnership_type, description, status, created_at
         FROM potential_partners ORDER BY created_at DESC`
      );

      // Escape CSV field
      const esc = (val) => {
        if (val === null || val === undefined) return '';
        const s = String(val);
        return s.includes(',') || s.includes('"') || s.includes('\n')
          ? '"' + s.replace(/"/g, '""') + '"'
          : s;
      };

      const headers = [
        'ID', 'Nama Perusahaan', 'Contact Person', 'Email',
        'Telepon', 'Alamat', 'Tipe Partnership', 'Deskripsi', 'Status', 'Dibuat Pada'
      ];

      const lines = [headers.join(',')];
      rows.forEach(r => {
        lines.push([
          esc(r.id),
          esc(r.company_name),
          esc(r.contact_person),
          esc(r.email),
          esc(r.phone),
          esc(r.address),
          esc(r.partnership_type),
          esc(r.description),
          esc(r.status),
          esc(r.created_at ? new Date(r.created_at).toLocaleString('id-ID') : ''),
        ].join(','));
      });

      const filename = `potential-partners-${new Date().toISOString().slice(0, 10)}.csv`;
      res.setHeader('Content-Type', 'text/csv; charset=utf-8');
      res.setHeader('Content-Disposition', `attachment; filename="${filename}"`);
      // BOM agar Excel bisa baca UTF-8 dengan benar
      res.send('\uFEFF' + lines.join('\r\n'));
    } catch (err) {
      console.error('[PP exportCsv]', err);
      req.session.flash = { error: 'Gagal mengekspor data: ' + err.message };
      res.redirect('/potential-partners');
    }
  },

  // ----------------------------------------------------------
  // EXPORT EXCEL — GET /potential-partners/export/excel
  // ----------------------------------------------------------
  exportExcel: async (req, res) => {
    try {
      const xlsx = require('xlsx');
      const [rows] = await db.query(
        `SELECT id, company_name, contact_person, email, phone, address,
                partnership_type, description, status, created_at
         FROM potential_partners ORDER BY created_at DESC`
      );

      // Map rows to a cleaner format with localized labels
      const data = rows.map((r, index) => ({
        'No': index + 1,
        'Nama Perusahaan': r.company_name,
        'Contact Person': r.contact_person || '-',
        'Email': r.email || '-',
        'Telepon': r.phone || '-',
        'Alamat': r.address || '-',
        'Tipe Partnership': r.partnership_type || '-',
        'Deskripsi': r.description || '-',
        'Status': r.status === 'active' ? 'Aktif' : 'Nonaktif',
        'Tanggal Dibuat': r.created_at ? new Date(r.created_at).toLocaleDateString('id-ID') : '-'
      }));

      const worksheet = xlsx.utils.json_to_sheet(data);
      const workbook = xlsx.utils.book_new();
      xlsx.utils.book_append_sheet(workbook, worksheet, 'Potential Partners');

      // Calculate automated column widths for a clean look
      const maxLens = {};
      data.forEach(row => {
        Object.keys(row).forEach(key => {
          const valStr = String(row[key] || '');
          maxLens[key] = Math.max(maxLens[key] || 10, valStr.length, key.length);
        });
      });
      worksheet['!cols'] = Object.keys(maxLens).map(key => ({ wch: maxLens[key] + 3 }));

      // Write to buffer
      const buffer = xlsx.write(workbook, { type: 'buffer', bookType: 'xlsx' });

      const filename = `potential-partners-${new Date().toISOString().slice(0, 10)}.xlsx`;
      res.setHeader('Content-Type', 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet');
      res.setHeader('Content-Disposition', `attachment; filename="${filename}"`);
      res.send(buffer);
    } catch (err) {
      console.error('[PP exportExcel]', err);
      req.session.flash = { error: 'Gagal mengekspor data Excel: ' + err.message };
      res.redirect('/potential-partners');
    }
  },

  // ----------------------------------------------------------
  // EXPORT PDF — GET /potential-partners/export/pdf
  // ----------------------------------------------------------
  exportPdf: async (req, res) => {
    try {
      const PDFDocument = require('pdfkit');
      const [rows] = await db.query(
        `SELECT id, company_name, contact_person, email, phone,
                partnership_type, status, created_at
         FROM potential_partners ORDER BY created_at DESC`
      );

      // Create a document in Landscape A4 orientation
      const doc = new PDFDocument({ size: 'A4', layout: 'landscape', margin: 40, bufferPages: true });

      const filename = `potential-partners-${new Date().toISOString().slice(0, 10)}.pdf`;
      res.setHeader('Content-Type', 'application/pdf');
      res.setHeader('Content-Disposition', `attachment; filename="${filename}"`);
      doc.pipe(res);

      // 1. Draw Kop Surat / Header
      doc.fontSize(10).font('Helvetica-Bold').fillColor('#0f172a').text('KEMENTERIAN PENDIDIKAN, KEBUDAYAAN, RISET, DAN TEKNOLOGI', { align: 'center' });
      doc.fontSize(12).text('UNIVERSITAS FACULTYWARE INDONESIA', { align: 'center' });
      doc.fontSize(10).font('Helvetica').text('FAKULTAS TEKNOLOGI INFORMASI DAN ILMU KOMPUTER', { align: 'center' });
      doc.fontSize(8).text('Jl. Raya Sains & Enterprise No. 100, Jakarta | Telp: (021) 555-0199 | Email: info@facultyware.ac.id', { align: 'center' });
      
      // Draw double horizontal line
      doc.moveDown(0.5);
      doc.lineWidth(1.5).moveTo(40, doc.y).lineTo(doc.page.width - 40, doc.y).stroke();
      doc.moveDown(0.1);
      doc.lineWidth(0.5).moveTo(40, doc.y).lineTo(doc.page.width - 40, doc.y).stroke();
      
      doc.moveDown(1.5);
      
      // 2. Document Title
      doc.fontSize(14).font('Helvetica-Bold').text('LAPORAN DATA MITRA POTENSIAL (POTENTIAL PARTNER)', { align: 'center' });
      doc.fontSize(9).font('Helvetica-Oblique').text(`Tanggal Unduh: ${new Date().toLocaleString('id-ID')}`, { align: 'center' });
      doc.moveDown(1.5);

      // 3. Draw Table Headers
      const startX = 40;
      let startY = doc.y;
      const columns = [
        { name: 'No', width: 30, align: 'center' },
        { name: 'Nama Perusahaan', width: 180, align: 'left' },
        { name: 'Contact Person', width: 120, align: 'left' },
        { name: 'Email', width: 140, align: 'left' },
        { name: 'Telepon', width: 100, align: 'left' },
        { name: 'Tipe', width: 90, align: 'center' },
        { name: 'Status', width: 60, align: 'center' }
      ];

      // Draw header background
      doc.rect(startX, startY, doc.page.width - 80, 20).fill('#f1f5f9');
      
      doc.fillColor('#0f172a').font('Helvetica-Bold').fontSize(9);
      let currentX = startX;
      columns.forEach(col => {
        doc.text(col.name, currentX, startY + 5, { width: col.width, align: col.align });
        currentX += col.width;
      });

      // Draw border under header
      doc.lineWidth(0.5).strokeColor('#cbd5e1');
      doc.moveTo(startX, startY + 20).lineTo(doc.page.width - 40, startY + 20).stroke();

      // 4. Draw Rows
      let currentY = startY + 20;
      doc.font('Helvetica').fontSize(8.5);

      rows.forEach((r, idx) => {
        // Check page overflow (Landscape A4 height is 595. Margins: 40 bottom, active space ends at 520)
        if (currentY > 500) {
          doc.addPage();
          currentY = 40;
          
          // Re-draw Headers
          doc.rect(startX, currentY, doc.page.width - 80, 20).fill('#f1f5f9');
          doc.fillColor('#0f172a').font('Helvetica-Bold');
          let tempX = startX;
          columns.forEach(col => {
            doc.text(col.name, tempX, currentY + 5, { width: col.width, align: col.align });
            tempX += col.width;
          });
          doc.moveTo(startX, currentY + 20).lineTo(doc.page.width - 40, currentY + 20).stroke();
          currentY += 20;
          doc.font('Helvetica');
        }

        // Zebra striping
        if (idx % 2 === 1) {
          doc.rect(startX, currentY, doc.page.width - 80, 20).fill('#f8fafc');
        }

        doc.fillColor('#334155');
        
        let rowX = startX;
        
        // No
        doc.text(String(idx + 1), rowX, currentY + 5, { width: columns[0].width, align: columns[0].align });
        rowX += columns[0].width;

        // Company Name
        doc.fillColor('#0f172a').font('Helvetica-Bold');
        doc.text(r.company_name, rowX, currentY + 5, { width: columns[1].width, align: columns[1].align, ellipsis: true });
        doc.fillColor('#334155').font('Helvetica');
        rowX += columns[1].width;

        // Contact Person
        doc.text(r.contact_person || '-', rowX, currentY + 5, { width: columns[2].width, align: columns[2].align, ellipsis: true });
        rowX += columns[2].width;

        // Email
        doc.text(r.email || '-', rowX, currentY + 5, { width: columns[3].width, align: columns[3].align, ellipsis: true });
        rowX += columns[3].width;

        // Phone
        doc.text(r.phone || '-', rowX, currentY + 5, { width: columns[4].width, align: columns[4].align, ellipsis: true });
        rowX += columns[4].width;

        // Type
        doc.text(r.partnership_type || '-', rowX, currentY + 5, { width: columns[5].width, align: columns[5].align });
        rowX += columns[5].width;

        // Status
        const statusText = r.status === 'active' ? 'Aktif' : 'Nonaktif';
        if (r.status === 'active') {
          doc.fillColor('#16a34a');
        } else {
          doc.fillColor('#dc2626');
        }
        doc.text(statusText, rowX, currentY + 5, { width: columns[6].width, align: columns[6].align });
        
        currentY += 20;

        // Draw line bottom
        doc.lineWidth(0.3).strokeColor('#e2e8f0');
        doc.moveTo(startX, currentY).lineTo(doc.page.width - 40, currentY).stroke();
      });

      // 5. Draw Footer
      const pages = doc.bufferedPageRange();
      for (let i = 0; i < pages.count; i++) {
        doc.switchToPage(i);
        
        doc.fillColor('#94a3b8').fontSize(7.5).font('Helvetica');
        doc.text(
          `Dokumen ini diterbitkan secara elektronik oleh Sistem Informasi Akademik Facultyware. Halaman ${i + 1} dari ${pages.count}`,
          40,
          doc.page.height - 30,
          { align: 'left', width: doc.page.width - 80 }
        );
      }

      doc.end();
    } catch (err) {
      console.error('[PP exportPdf]', err);
      req.session.flash = { error: 'Gagal mengekspor data PDF: ' + err.message };
      res.redirect('/potential-partners');
    }
  },
};

module.exports = potentialPartnerController;
