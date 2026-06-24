const express = require('express');
const router = express.Router();
const apiController = require('../controllers/apiController');

const potentialPartnerPaths = [
  '/potential-partners',
  '/potential-partner',
  '/potentialpartners',
  '/potentialpartner'
];

// GET potential partners
router.get(potentialPartnerPaths, apiController.getPotentialPartners);

// POST potential partners
router.post(potentialPartnerPaths, apiController.postPotentialPartners);

// GET MoU
router.get('/mou', apiController.getMou);

// POST MoU
router.post('/mou', apiController.postMou);

module.exports = router;