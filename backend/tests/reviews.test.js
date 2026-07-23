jest.mock('../models/Review');

const request = require('supertest');
const app = require('../app');
const Review = require('../models/Review');

describe('GET /reviews', () => {
  afterEach(() => {
    jest.clearAllMocks();
  });

  it('returns the list of reviews', async () => {
    Review.find.mockResolvedValue([
      { name: 'Ravi', rating: 5, comment: 'Good service', date: '2026-03-20' },
      { name: 'Priya', rating: 4, comment: 'Nice experience', date: '2026-03-18' },
    ]);

    const res = await request(app).get('/reviews');

    expect(res.status).toBe(200);
    expect(res.body.success).toBe(true);
    expect(res.body.data).toHaveLength(2);
    expect(res.body.data[0].name).toBe('Ravi');
  });

  it('returns an empty array when there are no reviews', async () => {
    Review.find.mockResolvedValue([]);

    const res = await request(app).get('/reviews');

    expect(res.status).toBe(200);
    expect(res.body.data).toEqual([]);
  });
});
