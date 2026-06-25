# Security

## Secret Handling
- `STRIPE_SECRET_KEY`, `REMOVAL_AI_KEY`, `SUPABASE_SERVICE_ROLE_KEY` — server-side environment variables only (Vercel secrets)
- Frontend receives only `NEXT_PUBLIC_SUPABASE_URL` and `NEXT_PUBLIC_SUPABASE_ANON_KEY`
- Stripe Checkout session created in a Next.js Route Handler — secret never touches the browser
- Webhook signature verified with `STRIPE_WEBHOOK_SECRET` before processing any payment event

## Permission Model (v1 → lock-down)
- **v1:** RLS permissive policies — all tables readable/writable without login (demo mode)
- **Sprint 5 lock-down:** Policies replaced with `auth.uid() = user_id`; unauthenticated users can only see seeded demo rows via a public demo flag
- Agent tools inherit the session's permission level — no elevated access without explicit approval

## Approved-Tools Rule
- Agents may only call named tools in the approved list (`enhance_image`, `create_stripe_checkout`, `log_touchpoint`, `score_image_quality`, `send_email`)
- No `run_any`, `eval`, or raw SQL execution from agent context
- Every agent action writes a touchpoint or enhancement_job update — nothing happens silently

## Audit Principle
- Every meaningful state change (upload, enhance, pay, download, refund) creates a `touchpoints` row
- Enhancement job history is append-only — no deletes without human-only approval
- Stripe events are stored verbatim before processing