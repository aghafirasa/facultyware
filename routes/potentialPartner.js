const express = require('express');
const router = express.Router();
const { index, create, store, edit, update, destroy } = require('../controllers/potentialPartnerControllerFriend');
const { isAuthenticated } = require('../middleware/auth');
const { isAdmin } = require('../middleware/acl');

router.get('/', isAuthenticated, isAdmin, index);
router.get('/create', isAuthenticated, isAdmin, create);
router.post('/store', isAuthenticated, isAdmin, store);
router.get('/edit/:id', isAuthenticated, isAdmin, edit);
router.post('/update/:id', isAuthenticated, isAdmin, update);
router.post('/delete/:id', isAuthenticated, isAdmin, destroy);

module.exports = router;