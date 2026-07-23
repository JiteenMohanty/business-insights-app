const express = require('express');
const { getBusiness } = require('../controllers/businessController');

const router = express.Router();

router.get('/business', getBusiness);

module.exports = router;
