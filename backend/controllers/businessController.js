const Business = require('../models/Business');
const { success, error } = require('../utils/response');

async function getBusiness(req, res) {
  try {
    const business = await Business.findOne();

    if (!business) {
      return error(res, 'Business not found', 404);
    }

    return success(res, business, 'Business details fetched successfully');
  } catch (err) {
    return error(res, 'Internal server error', 500);
  }
}

module.exports = { getBusiness };
