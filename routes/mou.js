const express = require('express');
const router = express.Router();
const { index, create, store, edit, update, destroy, approve, reject } = require('../controllers/mouController');
const { isAuthenticated } = require('../middleware/auth');
const { isAdmin } = require('../middleware/acl');

router.get('/', isAuthenticated, isAdmin, index);
router.get('/create', isAuthenticated, isAdmin, create);
router.post('/store', isAuthenticated, isAdmin, store);
router.get('/edit/:id', isAuthenticated, isAdmin, edit);
router.post('/update/:id', isAuthenticated, isAdmin, update);
router.post('/delete/:id', isAuthenticated, isAdmin, destroy);
router.post('/approve/:id', isAuthenticated, isAdmin, approve);
router.post('/reject/:id', isAuthenticated, isAdmin, reject);

module.exports = router;