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

_Filled in as endpoints are built in Phase 2 — see [docs/ARCHITECTURE.md](docs/ARCHITECTURE.md) for the full contract._

| Method | Path        | Description          |
|--------|-------------|-----------------------|
| POST   | `/login`    | User login            |
| GET    | `/business` | Get business details  |
| GET    | `/insights` | Get business insights |
| GET    | `/reviews`  | Get reviews list      |

## Setup Instructions

_Placeholder — backend setup steps land in Phase 2, mobile setup steps in Phase 3._

### Backend

TBD (Phase 2)

### Mobile

TBD (Phase 3)

## Deployment

TBD (Phase 2 — Render deployment steps)

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
