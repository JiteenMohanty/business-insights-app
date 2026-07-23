# Business Insights Mobile App

A Business Insights Dashboard app (in the spirit of Google Business Profile) that shows
business details, engagement insights, and customer reviews. Built as a technical
assignment covering mobile development, backend API design, database usage, and
deployment.

## Overview

The app simulates a small business owner's dashboard: after logging in, the owner can
view their business profile, a set of engagement insights (profile views, search views,
website clicks, phone calls, direction requests), and a list of customer reviews.

## Tech Stack

| Layer               | Technology                        |
|---------------------|------------------------------------|
| Mobile app          | Flutter (BLoC + GetX — see below)  |
| Backend             | Node.js + Express                  |
| Database            | MongoDB Atlas (via Mongoose)       |
| Backend deployment  | Render                             |
| API testing         | Postman                            |
| Mobile build        | Release APK                        |

### State management split (Flutter)

- **GetX** — navigation/routing between screens, and simple reactive UI state
  (loading spinners, active bottom-nav tab).
- **BLoC** — the data layer. One Bloc/Cubit per feature (business profile, insights,
  reviews), each with explicit loading/success/error states.

This split is intentional, not inconsistent: GetX handles lightweight UI/navigation
concerns, BLoC owns everything that touches the API.

## Screens

1. Login
2. Dashboard (Insights) — cards for all 5 metrics + a chart
3. Business Profile
4. Reviews

## API Reference

Full request/response examples are in [docs/ARCHITECTURE.md](docs/ARCHITECTURE.md). All
responses use the envelope `{ success, data, message }`.

| Method | Path        | Description          |
|--------|-------------|-----------------------|
| POST   | `/login`    | User login            |
| GET    | `/business` | Get business details  |
| GET    | `/insights` | Get business insights |
| GET    | `/reviews`  | Get reviews list      |

A ready-to-import Postman collection is at
[postman/business-insights.postman_collection.json](postman/business-insights.postman_collection.json)
(covers all four endpoints with example request bodies and saved example responses).
Update its `baseUrl` collection variable to point at the deployed Render URL to test
the live API.

## Setup Instructions

### Backend

Requires Node.js 18+ and a MongoDB Atlas cluster (or any MongoDB connection string).

```bash
cd backend
npm install
cp .env.example .env   # then fill in MONGO_URI (and PORT if you want something other than 5000)
npm run seed            # inserts the sample business/insights/reviews/user documents
npm run dev              # starts the API on http://localhost:PORT with nodemon
```

Run the backend's test suite (a handful of endpoint tests with the Mongoose models
mocked, so no live database is needed to run them):

```bash
npm test
```

**Demo login credentials** (inserted by `npm run seed`):

- Email: `owner@abcsalon.com`
- Password: `password123`

### Mobile

TBD (Phase 3)

## Deployment (Render)

The backend is Render-ready: `package.json` declares an `engines.node` constraint and a
`start` script (`node server.js`), and it reads its config from environment variables
only — no code changes are needed to deploy.

Steps to deploy from the Render dashboard:

1. **New → Web Service**, connect this GitHub repository.
2. **Root Directory:** `backend` (the service lives in the `backend/` subfolder of this repo).
3. **Runtime:** Node.
4. **Build Command:** `npm install`
5. **Start Command:** `npm start`
6. **Environment Variables** (Render dashboard → Environment):
   - `MONGO_URI` — your MongoDB Atlas connection string
   - `PORT` — Render sets this automatically; you don't need to add it yourself (the
     app reads `process.env.PORT` and falls back to `5000` only for local dev)
7. Deploy, then run the seed script once against the same `MONGO_URI` (e.g. locally
   with `.env` pointed at the Atlas cluster, `npm run seed`) so the live API has data
   to serve immediately.
8. Confirm the live API works by hitting `GET /business` on the Render URL, or by
   pointing the Postman collection's `baseUrl` variable at it.

## Known Simplifications

- **Login has no JWT / session token.** It checks email/password directly against the
  `users` collection. This is an intentional simplicity choice — the assignment marks
  JWT authentication as optional, and adding it would be scope beyond what a 2–3 day
  assignment needs.

## Project Structure

```
business-insights-app/
├── backend/          # Node.js + Express API
├── mobile/           # Flutter app
├── postman/          # Postman collection
├── docs/             # architecture notes
├── README.md
└── .gitignore
```
