const express = require('express');
const cors = require('cors');

const authRoutes = require('./routes/authRoutes');
const businessRoutes = require('./routes/businessRoutes');
const insightsRoutes = require('./routes/insightsRoutes');
const reviewsRoutes = require('./routes/reviewsRoutes');

const app = express();

app.use(cors());
app.use(express.json());

app.get('/', (req, res) => {
  res.json({ success: true, data: null, message: 'Business Insights API is running' });
});

app.use(authRoutes);
app.use(businessRoutes);
app.use(insightsRoutes);
app.use(reviewsRoutes);

app.use((req, res) => {
  res.status(404).json({ success: false, data: null, message: 'Route not found' });
});

app.use((err, req, res, next) => {
  if (err.type === 'entity.parse.failed') {
    return res.status(400).json({ success: false, data: null, message: 'Malformed JSON in request body' });
  }

  console.error(err);
  return res.status(500).json({ success: false, data: null, message: 'Internal server error' });
});

module.exports = app;
