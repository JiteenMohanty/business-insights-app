const User = require('../models/User');
const { success, error } = require('../utils/response');

async function login(req, res) {
  try {
    const { email, password } = req.body;

    if (typeof email !== 'string' || typeof password !== 'string' || !email || !password) {
      return error(res, 'Email and password are required', 400);
    }

    const user = await User.findOne({ email });

    if (!user || user.password !== password) {
      return error(res, 'Invalid email or password', 401);
    }

    return success(res, { email: user.email }, 'Login successful');
  } catch (err) {
    return error(res, 'Internal server error', 500);
  }
}

module.exports = { login };
