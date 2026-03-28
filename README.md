# SpaceHub India

> A two-sided marketplace for hourly rentals of unique spaces — private spas, creative studios, and event venues across India.

---
![space-hub.gif](space-hub.gif)
## Overview

SpaceHub is a Sharetribe-inspired transactional marketplace built with Ruby on Rails 8. It connects **hosts** who own unique spaces with **guests** looking to book them by the hour. The platform targets three premium verticals:

- **Wellness** — Private spas, yoga studios, meditation rooms
- **Creative Studios** — Photography studios, art spaces, podcast/recording rooms
- **Event Venues** — Private dining rooms, rooftop terraces, party halls

Built as a portfolio demo to showcase two-sided marketplace development capabilities for Upwork clients.

---

## Tech Stack

| Layer | Technology |
|-------|-----------|
| Framework | Ruby on Rails 8.0.5 |
| Database | PostgreSQL |
| Auth | Devise |
| Authorization | CanCanCan |
| Payments | Razorpay + Stripe (test mode) |
| File Storage | AWS S3 |
| AI | Gemini 2.5 Flash (Google) |
| Frontend | Bootstrap 5 + Hotwire (Turbo + Stimulus) |
| Search | Ransack |
| Pagination | Pagy |
| Background Jobs | Solid Queue |
| Deployment | Docker + Kamal |

---

## Features

### Guest (Buyer) Side
- Browse spaces by category (Wellness / Creative / Events)
- Advanced filters — city, price range (dual slider), capacity, date availability
- View detailed listing pages with photos, amenities, availability
- Hourly booking with real-time availability calendar
- Secure multi-gateway checkout — Razorpay (UPI, cards, wallets) + Stripe (international cards)
- Booking dashboard — upcoming, past, cancelled
- Leave reviews after completed bookings
- In-app notification bell with unread badge and dropdown preview

### Host (Seller) Side
- Host onboarding flow
- Create and manage listings with photos, pricing, amenities
- Set availability (open/close time slots)
- View and manage incoming bookings (confirm / complete / cancel)
- Earnings dashboard with revenue stats
- Payments page — full payment history with per-gateway filter and totals
- AI Price Suggestion — get Gemini-powered price recommendations by category, city, capacity, and amenities
- Public profile page visible to guests (`/hosts/:id`)

### Platform
- Indian city-based discovery (Mumbai, Delhi, Bangalore, Chennai, Hyderabad, Pune)
- Role-based authorization via CanCanCan (guest / host / admin)
- In-app notification system — booking lifecycle events trigger notifications for both host and guest
- SpaceBot AI chatbot — floating widget powered by Gemini 2.5 Flash with conversation history and suggestion chips
- Privacy policy, terms of service, and GDPR-compliant legal pages
- How It Works page for both hosts and guests
- Admin panel — manage users, listings, bookings
- Seed data with 15+ realistic Indian spaces, bookings, reviews, and notifications

---

## AI Features

### SpaceBot Chatbot
A floating chat widget (bottom-right) powered by **Gemini 2.5 Flash**. Guests can ask natural-language questions about SpaceHub — available spaces, how booking works, cancellation policy, and more.

- Maintains multi-turn conversation history (last 20 messages)
- Pre-loaded suggestion chips for common queries
- Renders on every page via the application layout
- Endpoint: `POST /chat/message`

### AI Price Suggestion (Hosts)
On the listing creation/edit form, hosts can click **"Suggest Price"** to get an AI-generated price recommendation.

- Returns: suggested price, min, max, and a human-readable reason
- Powered by Gemini 2.5 Flash with a structured JSON prompt
- Considers: category, city, capacity, and amenities
- Endpoint: `POST /ai/suggest_price`

---

## Getting Started

### Prerequisites

- Ruby 3.3.0
- PostgreSQL 14+
- Bundler

### Setup

```bash
# Clone the repo
git clone https://github.com/your-username/SpaceHub.git
cd SpaceHub

# Install dependencies
bundle install

# Setup database
rails db:create db:migrate db:seed

# Start the server
bin/dev
```

Visit `http://localhost:3000`

### Environment Variables

Create a `.env` file (or export in your shell) with the following:

```bash
# Razorpay — domestic payments (UPI, cards, wallets)
RAZORPAY_KEY_ID=rzp_test_...
RAZORPAY_KEY_SECRET=...
RAZORPAY_WEBHOOK_SECRET=...

# Stripe — international cards
STRIPE_PUBLISHABLE_KEY=pk_test_...
STRIPE_SECRET_KEY=sk_test_...
STRIPE_WEBHOOK_SECRET=...

# AWS S3 — file uploads (falls back to local disk in dev if unset)
AWS_ACCESS_KEY_ID=...
AWS_SECRET_ACCESS_KEY=...
AWS_REGION=ap-south-1
AWS_S3_BUCKET=spacehub-uploads

# Gemini AI — chatbot + price suggestion
GEMINI_API_KEY=...
```

**Test cards:**
- Razorpay: `4111 1111 1111 1111`
- Stripe: `4242 4242 4242 4242`

---

## Demo Accounts

After running `rails db:seed`:

| Role | Email | Password |
|------|-------|----------|
| Admin | admin@spacehub.in | password123 |
| Host 1 | host@spacehub.in | password123 |
| Host 2 | host2@spacehub.in | password123 |
| Host 3 | host3@spacehub.in | password123 |
| Host 4 | host4@spacehub.in | password123 |
| Guest | guest@spacehub.in | password123 |
| Guest 2 | guest2@spacehub.in | password123 |
| Guest 3 | guest3@spacehub.in | password123 |
| Guest 4 | guest4@spacehub.in | password123 |

---

## Data Models

```
User
├── has_many :listings (as host)
├── has_many :bookings (as guest)
├── has_many :reviews (as reviewer)
├── has_many :gateway_configs
└── has_many :notifications

Listing
├── belongs_to :user (host)
├── has_many :availabilities
├── has_many :bookings
├── has_many :reviews
└── has_many_attached :photos (→ AWS S3)

Booking
├── belongs_to :listing
├── belongs_to :user (guest)
└── has_one :review
   payment_gateway, payment_id stored on booking

GatewayConfig
├── belongs_to :user (host)
└── gateway: razorpay | stripe (active flag)

Notification
├── belongs_to :user
├── message, link, kind, read
└── scopes: .unread, .recent

Review
├── belongs_to :booking
├── belongs_to :listing
└── belongs_to :user
```

---

## Project Structure

```
app/
├── controllers/
│   ├── listings_controller.rb        # Browse, search, advanced filters
│   ├── bookings_controller.rb        # Create bookings
│   ├── payments_controller.rb        # Razorpay + Stripe checkout
│   ├── webhooks_controller.rb        # Payment webhooks
│   ├── reviews_controller.rb         # Submit reviews
│   ├── notifications_controller.rb   # Bell index, mark_read, mark_all_read
│   ├── hosts_controller.rb           # Public host profile (/hosts/:id)
│   ├── chat_controller.rb            # SpaceBot chatbot endpoint
│   ├── ai_controller.rb              # AI price suggestion endpoint
│   ├── host/
│   │   ├── dashboard_controller.rb   # Earnings, stats
│   │   ├── listings_controller.rb    # Listing CRUD
│   │   ├── availabilities_controller.rb
│   │   ├── bookings_controller.rb    # Confirm / complete
│   │   └── payments_controller.rb    # Payment history with filters
│   ├── guest/
│   │   ├── dashboard_controller.rb
│   │   └── bookings_controller.rb    # View, cancel
│   └── admin/
│       ├── dashboard_controller.rb
│       ├── users_controller.rb
│       ├── listings_controller.rb
│       └── bookings_controller.rb
├── models/
│   ├── ability.rb         # CanCanCan rules
│   ├── user.rb
│   ├── listing.rb
│   ├── availability.rb
│   ├── booking.rb
│   ├── review.rb
│   ├── gateway_config.rb
│   └── notification.rb
├── services/
│   ├── gemini_service.rb              # Gemini 2.5 Flash API (chat + price suggestion)
│   └── booking_notification_service.rb  # Wraps mailer + notification calls
└── views/
    ├── layouts/         # Navbar (with bell), footer, chatbot widget
    ├── pages/           # Landing, about, how-it-works, legal
    ├── listings/        # Browse (with filter sidebar) + detail pages
    ├── notifications/   # Notifications index
    ├── hosts/           # Public host profile
    ├── host/
    ├── guest/
    └── admin/
```

---

## Notification System

Booking lifecycle events automatically trigger in-app notifications:

| Event | Who gets notified | Where it links |
|-------|-------------------|----------------|
| Booking created | Host | Host booking detail |
| Booking confirmed | Guest | Guest booking detail |
| Booking completed | Guest | Guest booking detail |
| Booking cancelled | Both | Respective booking detail |

The navbar bell icon shows an unread badge count. Clicking it opens a dropdown with the 5 most recent notifications and a link to the full notifications page. Clicking a notification marks it read and redirects to the linked page.

---

## Marketplace Flow

```
1. Host creates listing  →  sets category, price/hour, availability
2. Guest browses         →  filters by city / category / price / date / capacity
3. Guest selects listing →  picks date + time slot
4. Guest pays via Razorpay or Stripe  →  booking confirmed
                         →  host + guest receive notifications
5. Space is used         →  booking marked completed
                         →  guest receives "time to review" notification
6. Guest leaves review   →  listing rating updated
```

---

## Cold-Start Strategy

The platform ships with seed data simulating a live marketplace:

- 15+ realistic Indian space listings across 3 verticals
- 23 bookings with varied statuses (pending, confirmed, completed, cancelled)
- Reviews and ratings already populated
- Host profiles with bios and response rates
- Sample notifications across all demo accounts

Recommended real-world launch approach:
1. Manually onboard 5–10 premium hosts before public launch
2. Offer first 3 bookings at 50% discount to generate early reviews
3. Grow supply via direct outreach to co-working spaces, studios, boutique hotels
4. Drive demand via Google Ads targeting city + category intent keywords

---

## License

MIT License — free to use for demo and portfolio purposes.

---

*Built with Rails 8 · Gemini AI · Sharetribe-inspired · Made for India*
