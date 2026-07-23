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

Requires the Flutter SDK (3.29+) with the Android toolchain. Confirm your setup with
`flutter doctor`.

```bash
cd mobile
flutter pub get
flutter run              # runs on a connected device or emulator
```

**Point the app at the right backend.** The API base URL lives in one place —
[mobile/lib/config/app_config.dart](mobile/lib/config/app_config.dart):

- `useLocalApi = true` (default) → talks to a locally running backend. On the **Android
  emulator**, the host machine's `localhost` is reachable at `http://10.0.2.2:5000`
  (already the default). On a **physical device**, set `localBaseUrl` to your computer's
  LAN IP (e.g. `http://192.168.1.5:5000`) and keep the phone on the same Wi-Fi network.
- `useLocalApi = false` → talks to the deployed backend. Set `prodBaseUrl` to your live
  Render URL first.

> Cleartext HTTP is allowed only for `localhost`/`10.0.2.2` (see
> `mobile/android/app/src/main/res/xml/network_security_config.xml`); the Render backend
> is served over HTTPS.

**Demo login credentials** (seeded by the backend's `npm run seed`):

- Email: `owner@abcsalon.com`
- Password: `password123`

(The login screen also has a **Fill demo credentials** button.)

Run the mobile widget tests:

```bash
flutter test
```

#### Build the release APK

```bash
cd mobile
flutter build apk --release
```

The APK is written to:

```
mobile/build/app/outputs/flutter-apk/app-release.apk
```

> For the submission APK, set `useLocalApi = false` and `prodBaseUrl` to the live Render
> URL in `app_config.dart` **before** running the build, so the installed app talks to
> the deployed API rather than localhost.

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
├── backend/                # Node.js + Express API
│   ├── config/             # Mongoose connection
│   ├── controllers/        # request handlers (auth, business, insights, reviews)
│   ├── models/             # Mongoose schemas (User, Business, Insight, Review)
│   ├── routes/             # Express routers
│   ├── utils/              # shared JSON response helpers
│   ├── tests/              # Jest + Supertest endpoint tests
│   ├── seed.js             # inserts the sample dummy data
│   ├── app.js              # Express app (middleware + routes)
│   └── server.js           # entry point (connects DB, starts server)
├── mobile/                 # Flutter app
│   └── lib/
│       ├── config/         # app_config.dart — the one place to set the API URL
│       ├── core/           # theme + formatters
│       ├── data/           # ApiClient + models (the network layer)
│       ├── logic/          # BLoC/Cubits per feature (business, insights, reviews)
│       ├── controllers/    # GetX controllers (auth, bottom-nav)
│       ├── routes/         # GetX route table
│       ├── screens/        # Login, Home, Dashboard, Business, Reviews
│       └── widgets/        # reusable UI (cards, chart, star rating, states)
├── postman/                # Postman collection (all four endpoints)
├── docs/                   # ARCHITECTURE.md (data model + API contract)
├── README.md
└── .gitignore
```

## Submission Artifacts

| Deliverable            | Where |
|------------------------|-------|
| GitHub repo (FE + BE)  | this repository |
| Backend API            | `backend/` — deploy to Render (see above) |
| Live API URL           | _add your Render URL here after deploying_ |
| Release APK            | `mobile/build/app/outputs/flutter-apk/app-release.apk` (built locally) |
| Postman collection     | [postman/business-insights.postman_collection.json](postman/business-insights.postman_collection.json) |
| Architecture / API doc | [docs/ARCHITECTURE.md](docs/ARCHITECTURE.md) |
