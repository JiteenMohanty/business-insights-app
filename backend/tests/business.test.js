jest.mock('../models/Business');

const request = require('supertest');
const app = require('../app');
const Business = require('../models/Business');

describe('GET /business', () => {
  afterEach(() => {
    jest.clearAllMocks();
  });

  it('returns business details', async () => {
    Business.findOne.mockResolvedValue({
      name: 'ABC Salon',
      category: 'Beauty Salon',
      address: 'Hyderabad',
      phone: '9876543210',
      rating: 4.2,
      total_reviews: 120,
    });

    const res = await request(app).get('/business');

    expect(res.status).toBe(200);
    expect(res.body.success).toBe(true);
    expect(res.body.data.name).toBe('ABC Salon');
  });

  it('returns 404 when no business is seeded', async () => {
    Business.findOne.mockResolvedValue(null);

    const res = await request(app).get('/business');

    expect(res.status).toBe(404);
    expect(res.body.success).toBe(false);
  });
});
