# ProImage — Product Requirements Document

## Problem
SME owners need professional-looking product photos for social media but can't afford photographers or complex tools. Raw phone photos with distracting backgrounds, shadows, and poor sharpness kill conversions.

## Target User
Small business owners selling physical products (food, fashion, homewares, sporting goods) who manage their own social media marketing.

## Core Objects
- **Image** — original upload from the user
- **EnhancementJob** — one processing run; tracks which enhancements applied, input/output URLs, status
- **Lead** — email-captured visitor, linked to their images and payments
- **Payment** — Stripe transaction record; gates download access
- **Touchpoint** — every meaningful event (upload, enhance, view pricing, pay)
- **ChangeRequest** — post-enhancement tweak request

## MVP Must-Haves
- [ ] Upload a product image (drag-and-drop)
- [ ] Apply at least 2 enhancements: background removal + sharpen (shadow removal + highlight in same call if API supports)
- [ ] Before/after slider preview in-browser
- [ ] Capture email before first free enhancement
- [ ] Download gated behind Stripe payment (pay-per-image or monthly)
- [ ] Real Stripe Checkout working in test mode
- [ ] App renders with demo data — no login required to see the product

## Non-Goals (v1)
- Team/multi-user workspaces
- Batch uploads
- Social platform publishing
- Mobile native app
- Admin analytics dashboard

## Success Criteria
A user lands on the homepage, sees an enhanced demo product image, uploads their own photo, receives the enhanced version, enters their email, clicks Buy ($9.90), completes Stripe Checkout, and downloads their file — all within 3 minutes, no account required.