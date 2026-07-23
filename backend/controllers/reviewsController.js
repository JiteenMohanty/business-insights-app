const Review = require('../models/Review');
const { success, error } = require('../utils/response');

async function getReviews(req, res) {
  try {
    const reviews = await Review.find();
    return success(res, reviews, 'Reviews fetched successfully');
  } catch (err) {
    return error(res, 'Internal server error', 500);
  }
}

module.exports = { getReviews };
