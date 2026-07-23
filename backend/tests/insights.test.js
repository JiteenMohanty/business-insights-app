jest.mock('../models/Insight');

const request = require('supertest');
const app = require('../app');
const Insight = require('../models/Insight');

describe('GET /insights', () => {
  afterEach(() => {
    jest.clearAllMocks();
  });

  it('returns insights data', async () => {
    Insight.findOne.mockResolvedValue({
      profile_views: 1200,
      search_views: 800,
      website_clicks: 150,
      phone_calls: 60,
      direction_requests: 40,
    });

    const res = await request(app).get('/insights');

    expect(res.status).toBe(200);
    expect(res.body.success).toBe(true);
    expect(res.body.data.profile_views).toBe(1200);
  });

  it('returns 404 when no insights are seeded', async () => {
    Insight.findOne.mockResolvedValue(null);

    const res = await request(app).get('/insights');

    expect(res.status).toBe(404);
    expect(res.body.success).toBe(false);
  });
});
