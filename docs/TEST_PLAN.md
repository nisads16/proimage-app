# Test Plan

## v1 Success Scenario (manual walkthrough)
1. Open homepage — before/after demo slider visible without login
2. Drop a JPG product photo onto the upload zone
3. Confirm loading spinner appears and `enhancement_jobs` row shows `status: processing`
4. Wait for completion — before/after slider updates with real output image
5. Click Download — email capture modal appears
6. Enter test email → confirm `leads` row created, `touchpoint: uploaded` logged
7. Download button now shows pricing — click Buy ($9.90)
8. Confirm redirect to Stripe Checkout with correct amount
9. Enter test card `4242 4242 4242 4242`, complete payment
10. Confirm redirect back to app; `payments.status = paid`; download unlocks
11. Click Download — file downloads successfully
12. Check `/admin/leads` — lead row shows full journey: uploaded → enhanced → paid → downloaded

## Empty State Tests
- No image uploaded: upload zone shows "Drop your product photo here"
- `/admin/leads` with no leads: shows "No leads yet"

## Error State Tests
- Simulate enhancement API failure: job status = `failed`; "Enhancement failed — Retry" button visible; retry creates new job
- Stripe webhook with invalid signature: returns 400, no payment row written
- Upload file > 20 MB: client-side error "File too large (max 20 MB)"
- Network drop mid-upload: error toast "Upload failed — please try again"

## Permission Tests (post Sprint 5)
- User A logs in; cannot fetch User B's images via direct Supabase query
- Anon user can view seeded demo rows but cannot write new rows
- `/admin/leads` requires builder session; redirects to login otherwise

## Payment Security Test
- Open browser DevTools Network tab during checkout — confirm no `STRIPE_SECRET_KEY` in any request payload or response