# Architecture

## Overview

Single-tenant demo app: one business, one insights snapshot, a list of reviews, and a
small set of login users. The mobile app is a thin client over four REST endpoints
backed by MongoDB Atlas.

```
Flutter app  --HTTP/JSON-->  Express API  --Mongoose-->  MongoDB Atlas
```

There is no multi-tenancy and no auth token — `GET /business` and `GET /insights`
each return the single document in their collection (`findOne()`), which matches the
assignment's scope (one demo business, "ABC Salon").

## Database Collections

All four collections live in a single MongoDB Atlas database. Fields below are exact —
no extra fields are added beyond what the assignment specifies.

### `users`

| Field      | Type   | Notes                                  |
|------------|--------|------------------------------------------|
| `email`    | String | unique, used as login identifier         |
| `password` | String | plain-text compare — see Known Simplifications in README |

### `business`

| Field           | Type   | Notes                        |
|-----------------|--------|-------------------------------|
| `name`          | String | e.g. "ABC Salon"              |
| `category`      | String | e.g. "Beauty Salon"           |
| `address`       | String | e.g. "Hyderabad"               |
| `phone`         | String | kept as String (not Number) to preserve leading zeros / formatting |
| `rating`        | Number | e.g. 4.2                      |
| `total_reviews` | Number | e.g. 120                      |

### `insights`

| Field                | Type   | Notes |
|----------------------|--------|-------|
| `profile_views`      | Number | |
| `search_views`       | Number | |
| `website_clicks`     | Number | |
| `phone_calls`        | Number | |
| `direction_requests` | Number | |

### `reviews`

| Field     | Type   | Notes                                             |
|-----------|--------|----------------------------------------------------|
| `name`    | String | reviewer name                                       |
| `rating`  | Number | 1–5                                                  |
| `comment` | String | |
| `date`    | String | kept as String (e.g. `"2026-03-20"`) to match the assignment's literal sample data and avoid timezone conversion in the API response |

## API Contract

All responses use a consistent envelope:

```json
{
  "success": true,
  "data": {},
  "message": "..."
}
```

On error, `data` is `null` and `message` describes the problem. Status codes used:
`200` success, `400` bad request (e.g. missing login fields), `401` invalid
credentials, `404` resource not found, `500` server error.

### `POST /login`

User login. Checks `email` + `password` directly against the `users` collection
(no JWT / session token — see README's Known Simplifications).

**Request body**

```json
{
  "email": "owner@abcsalon.com",
  "password": "secret123"
}
```

**Response — 200 success**

```json
{
  "success": true,
  "data": { "email": "owner@abcsalon.com" },
  "message": "Login successful"
}
```

**Response — 401 invalid credentials**

```json
{
  "success": false,
  "data": null,
  "message": "Invalid email or password"
}
```

**Response — 400 missing fields**

```json
{
  "success": false,
  "data": null,
  "message": "Email and password are required"
}
```

### `GET /business`

Returns the single business document.

**Response — 200**

```json
{
  "success": true,
  "data": {
    "name": "ABC Salon",
    "category": "Beauty Salon",
    "address": "Hyderabad",
    "phone": "9876543210",
    "rating": 4.2,
    "total_reviews": 120
  },
  "message": "Business details fetched successfully"
}
```

**Response — 404 (no business document seeded)**

```json
{
  "success": false,
  "data": null,
  "message": "Business not found"
}
```

### `GET /insights`

Returns the single insights document.

**Response — 200**

```json
{
  "success": true,
  "data": {
    "profile_views": 1200,
    "search_views": 800,
    "website_clicks": 150,
    "phone_calls": 60,
    "direction_requests": 40
  },
  "message": "Insights fetched successfully"
}
```

### `GET /reviews`

Returns the list of reviews.

**Response — 200**

```json
{
  "success": true,
  "data": [
    {
      "name": "Ravi",
      "rating": 5,
      "comment": "Good service",
      "date": "2026-03-20"
    },
    {
      "name": "Priya",
      "rating": 4,
      "comment": "Nice experience",
      "date": "2026-03-18"
    }
  ],
  "message": "Reviews fetched successfully"
}
```

## Design Notes

- **No JWT.** Explicitly optional per the assignment; a direct email/password check
  keeps the login endpoint's scope proportional to the rest of the app.
- **`findOne()` for business/insights.** There is exactly one business in this demo,
  so no route/query parameter is needed to select it. Adding one would be scope beyond
  what's asked.
- **Seed script (`backend/seed.js`, built in Phase 2)** populates all four collections
  with the assignment's sample dummy data (ABC Salon, the given insight numbers, and
  the Ravi/Priya reviews) so the deployed app is demoable immediately.
