# Architecture

## Stack
- **Frontend:** Next.js 14 (App Router) on Vercel
- **Database:** Supabase Postgres + Storage
- **Auth:** Supabase Auth (Sprint 5 only)
- **Payments:** Stripe Checkout + webhooks
- **AI/Enhancement APIs:** removal.ai (background), a sharpening + shadow pipeline via Sharp or a hosted API
- **Email:** Resend (receipts, onboarding)

## Now vs Later
| Now (v1) | Later |
|---|---|
| Upload → enhance → preview → pay → download | Saved image history, user dashboard |
| Single image per session | Batch upload (5 images) |
| Rule-based quality score | AI-suggested enhancement settings |
| Email capture pre-enhancement | Full auth + per-user RLS |

## Key User Action — Step by Step
1. User lands on homepage; sees live before/after of a demo product image
2. Drops their image → `images` row created in Supabase Storage + DB
3. Server calls enhancement API; `enhancement_job` row written with `status: processing`
4. Output URL returned; job updated to `status: completed`, `output_url` stored
5. Before/after slider shown; download button appears (gated)
6. User enters email → `lead` row created, `touchpoint: uploaded` logged
7. User clicks Buy → Stripe Checkout session created server-side
8. Stripe webhook fires → `payment` row written, `status: paid`
9. Download unlocked; file served from Supabase Storage

## Layer Plan
1. **Data first** — tables + RLS + seed data (Sprint 1)
2. **App logic** — upload, enhance, preview, pay, download (Sprints 2–3)
3. **Lead tracking** — email capture, touchpoints, change requests (Sprint 4)
4. **Smart features** — quality scoring, enhancement suggestions (Later)

## Core Without AI
If the enhancement API is down, the upload and lead capture still work. The job status stays `pending`; a retry button is shown. Payments and download of a previously processed image are unaffected.