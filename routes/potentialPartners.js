var express = require('express');
var router  = express.Router();

const potentialPartnerController = require('../controllers/potentialPartnerController');
const { isAuthenticated }        = require('../middlewares/auth');
const { checkPermission }        = require('../middlewares/acl');

const apiController = require('../controllers/apiController');

// ------------------------------------------------------------------
// REST API — harus sebelum route lain agar tidak konflik dengan /:id
// GET & POST /potential-partners/api
// ------------------------------------------------------------------
router.get('/api', apiController.getPotentialPartners);
router.post('/api', apiController.postPotentialPartners);

// ------------------------------------------------------------------
// Export CSV
// GET /potential-partners/export/csv
// ------------------------------------------------------------------
router.get('/export/csv',
  isAuthenticated,
  checkPermission('potential-partner.export'),
  potentialPartnerController.exportCsv
);

// ------------------------------------------------------------------
// Export Excel
// GET /potential-partners/export/excel
// ------------------------------------------------------------------
router.get('/export/excel',
  isAuthenticated,
  checkPermission('potential-partner.export'),
  potentialPartnerController.exportExcel
);

// ------------------------------------------------------------------
// Export PDF
// GET /potential-partners/export/pdf
// ------------------------------------------------------------------
router.get('/export/pdf',
  isAuthenticated,
  checkPermission('potential-partner.export'),
  potentialPartnerController.exportPdf
);

// ------------------------------------------------------------------
// List — tampilkan semua potential partner (dengan search & pagination)
// GET /potential-partners
// ------------------------------------------------------------------
router.get('/',
  isAuthenticated,
  checkPermission('potential-partner.view'),
  potentialPartnerController.list
);

// ------------------------------------------------------------------
// Detail — tampilkan detail informasi
// GET /potential-partners/detail/:id
// ------------------------------------------------------------------
router.get('/detail/:id',
  isAuthenticated,
  checkPermission('potential-partner.view'),
  potentialPartnerController.detail
);

// ------------------------------------------------------------------
// Add — tampilkan form tambah
// GET /potential-partners/add
// ------------------------------------------------------------------
router.get('/add',
  isAuthenticated,
  checkPermission('potential-partner.create'),
  potentialPartnerController.add
);

// ------------------------------------------------------------------
// Store — proses simpan data baru
// POST /potential-partners/store
// ------------------------------------------------------------------
router.post('/store',
  isAuthenticated,
  checkPermission('potential-partner.create'),
  potentialPartnerController.store
);

// ------------------------------------------------------------------
// Edit — tampilkan form edit
// GET /potential-partners/edit/:id
// ------------------------------------------------------------------
router.get('/edit/:id',
  isAuthenticated,
  checkPermission('potential-partner.edit'),
  potentialPartnerController.edit
);

// ------------------------------------------------------------------
// Update — proses simpan perubahan
// POST /potential-partners/update/:id
// ------------------------------------------------------------------
router.post('/update/:id',
  isAuthenticated,
  checkPermission('potential-partner.edit'),
  potentialPartnerController.update
);

// ------------------------------------------------------------------
// Approve — setujui kemitraan
// POST /potential-partners/approve/:id
// ------------------------------------------------------------------
router.post('/approve/:id',
  isAuthenticated,
  checkPermission('potential-partner.edit'),
  potentialPartnerController.approve
);

// ------------------------------------------------------------------
// Reject — tolak kemitraan
// POST /potential-partners/reject/:id
// ------------------------------------------------------------------
router.post('/reject/:id',
  isAuthenticated,
  checkPermission('potential-partner.edit'),
  potentialPartnerController.reject
);

// ------------------------------------------------------------------
// Delete — hapus data
// POST /potential-partners/delete/:id
// ------------------------------------------------------------------
router.post('/delete/:id',
  isAuthenticated,
  checkPermission('potential-partner.delete'),
  potentialPartnerController.delete
);

module.exports = router;
