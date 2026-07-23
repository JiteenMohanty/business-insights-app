require('dotenv').config();

const mongoose = require('mongoose');
const User = require('./models/User');
const Business = require('./models/Business');
const Insight = require('./models/Insight');
const Review = require('./models/Review');

const users = [{ email: 'owner@abcsalon.com', password: 'password123' }];

const business = {
  name: 'ABC Salon',
  category: 'Beauty Salon',
  address: 'Hyderabad',
  phone: '9876543210',
  rating: 4.2,
  total_reviews: 120,
};

const insights = {
  profile_views: 1200,
  search_views: 800,
  website_clicks: 150,
  phone_calls: 60,
  direction_requests: 40,
};

const reviews = [
  { name: 'Ravi', rating: 5, comment: 'Good service', date: '2026-03-20' },
  { name: 'Priya', rating: 4, comment: 'Nice experience', date: '2026-03-18' },
];

async function seed() {
  const uri = process.env.MONGO_URI;

  if (!uri) {
    throw new Error('MONGO_URI is not set in the environment');
  }

  await mongoose.connect(uri);
  console.log('Connected to MongoDB for seeding');

  await Promise.all([
    User.deleteMany({}),
    Business.deleteMany({}),
    Insight.deleteMany({}),
    Review.deleteMany({}),
  ]);

  await User.insertMany(users);
  await Business.create(business);
  await Insight.create(insights);
  await Review.insertMany(reviews);

  console.log('Seed data inserted successfully');
  await mongoose.disconnect();
}

seed().catch((err) => {
  console.error('Seeding failed:', err);
  process.exit(1);
});
