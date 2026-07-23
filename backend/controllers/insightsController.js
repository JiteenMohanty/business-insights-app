const Insight = require('../models/Insight');
const { success, error } = require('../utils/response');

async function getInsights(req, res) {
  try {
    const insights = await Insight.findOne();

    if (!insights) {
      return error(res, 'Insights not found', 404);
    }

    return success(res, insights, 'Insights fetched successfully');
  } catch (err) {
    return error(res, 'Internal server error', 500);
  }
}

module.exports = { getInsights };
