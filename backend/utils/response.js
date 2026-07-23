function success(res, data, message = 'Success', statusCode = 200) {
  return res.status(statusCode).json({ success: true, data, message });
}

function error(res, message = 'Something went wrong', statusCode = 500) {
  return res.status(statusCode).json({ success: false, data: null, message });
}

module.exports = { success, error };
