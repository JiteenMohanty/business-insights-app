jest.mock('../models/User');

const request = require('supertest');
const app = require('../app');
const User = require('../models/User');

describe('POST /login', () => {
  afterEach(() => {
    jest.clearAllMocks();
  });

  it('returns 400 when email or password is missing', async () => {
    const res = await request(app).post('/login').send({ email: 'owner@abcsalon.com' });

    expect(res.status).toBe(400);
    expect(res.body.success).toBe(false);
  });

  it('returns 401 for invalid credentials', async () => {
    User.findOne.mockResolvedValue(null);

    const res = await request(app)
      .post('/login')
      .send({ email: 'owner@abcsalon.com', password: 'wrong' });

    expect(res.status).toBe(401);
    expect(res.body.success).toBe(false);
  });

  it('returns 200 for valid credentials', async () => {
    User.findOne.mockResolvedValue({ email: 'owner@abcsalon.com', password: 'password123' });

    const res = await request(app)
      .post('/login')
      .send({ email: 'owner@abcsalon.com', password: 'password123' });

    expect(res.status).toBe(200);
    expect(res.body.success).toBe(true);
    expect(res.body.data.email).toBe('owner@abcsalon.com');
  });
});
