# Tasks & Sprints

## Sprint 1 — Database & demo seed
**Goal:** Schema live, demo data visible, no login required.
- [ ] Run migration SQL in Supabase (leads, images, enhancement_jobs, payments, touchpoints, change_requests)
- [ ] Verify seed rows (4 leads, 4 images, 4 jobs, 2 payments) readable via anon key
- [ ] Confirm RLS v1 permissive policies active on all tables
- [ ] Create Supabase Storage bucket `product-images` (public read)

**Done when:** `select * from enhancement_jobs` returns 4 rows with output_urls in Supabase dashboard.

---

## Sprint 2 — Core engine: upload → enhance → preview ✅ v1 functional milestone
**Goal:** The one workflow works end-to-end without login.
- [ ] Homepage shows before/after slider with seeded demo image (not a login page)
- [ ] Drag-and-drop upload component; stores file to Supabase Storage, writes `images` row
- [ ] Server Route Handler calls enhancement API; writes `enhancement_job` row (status: processing → completed)
- [ ] Before/after slider rendered with real output_url
- [ ] Download button shown (ungated for first image, gated after)
- [ ] Loading state: spinner + "Enhancing your image…"
- [ ] Error state: "Enhancement failed — Retry" button; job status set to failed
- [ ] Empty state: "Drop your product photo here"

**Done when:** A real uploaded photo is enhanced, previewed, and the output_url is in the DB.

---

## Sprint 3 — Stripe checkout and paid download
**Goal:** Tool can take a real payment.
- [ ] Pricing page (free: 1 image preview; paid: $9.90 download or $29/mo unlimited)
- [ ] Route Handler: `POST /api/checkout` creates Stripe Checkout session (secret server-side)
- [ ] Stripe webhook `POST /api/webhooks/stripe`: verify signature, write `payments` row, log touchpoint
- [ ] Download button checks payment status before serving file
- [ ] Test with Stripe test card 4242 4242 4242 4242
- [ ] No Stripe keys in frontend bundle (verify via network tab)

**Done when:** Test payment completes, `payments.status = paid`, download works.

---

## Sprint 4 — Lead capture & basic CRM
**Goal:** Builder can see who is using the tool.
- [ ] Email capture modal before first free enhancement; writes `leads` row
- [ ] Touchpoints logged: uploaded, enhanced, viewed_pricing, paid, downloaded
- [ ] `/admin/leads` page (no auth yet): table of leads with last touchpoint and status
- [ ] Change request form on output screen; writes `change_requests` row
- [ ] Change requests list on `/admin/requests`

**Done when:** A test run from upload to payment appears as a full journey in the leads table.

---

## Sprint 5 — Lock it down (auth + per-user RLS)
**Goal:** Real users' data is private.
- [ ] Enable Supabase Auth (magic link + email/password)
- [ ] Sign-up/login pages; redirect after free trial use
- [ ] Backfill `user_id` from `auth.uid()` on all write operations
- [ ] Replace v1 RLS policies with owner-scoped (`auth.uid() = user_id`) on all tables
- [ ] User dashboard: their images, enhancement history, download access, billing status
- [ ] Seed demo rows marked with a `is_demo` flag remain publicly visible

**Done when:** User A cannot see User B's images in any query.

---

## Sprint 6 — Polish & launch
**Goal:** Production-ready.
- [ ] Enhancement presets: E-commerce (white BG + sharpen), Instagram (vivid + highlight), LinkedIn (clean + neutral BG)
- [ ] Batch upload: up to 5 images queued as separate enhancement_jobs
- [ ] Email receipt via Resend on payment; onboarding email 10 min after signup
- [ ] Sentry error monitoring on enhancement job failures
- [ ] Vercel production deploy, custom domain, SSL
- [ ] Smoke test: upload → enhance → pay → download on production

**Done when:** Live URL works, real payment taken, Sentry shows no critical errors.

---

## Gantt (sprint → feature)
```
Sprint 1  |████| DB schema + seed
Sprint 2  |████████| Upload + enhance + preview  ← v1 functional
Sprint 3  |████████| Stripe checkout + paid download
Sprint 4  |████| Lead capture + admin CRM
Sprint 5  |████| Auth + RLS lock-down
Sprint 6  |████| Presets + batch + launch
```