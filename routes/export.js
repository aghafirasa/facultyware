const express = require('express');
const router = express.Router();
const { exportPartners, exportMoUPDF } = require('../controllers/exportController');
const { isAuthenticated } = require('../middleware/auth');
const { isAdmin } = require('../middleware/acl');

router.get('/partners', isAuthenticated, isAdmin, exportPartners);
router.get('/mou', isAuthenticated, isAdmin, exportMoUPDF);

module.exports = router;