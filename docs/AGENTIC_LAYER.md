# Agentic Layer

## Risk Levels & Actions

### Low — Auto-execute (no approval)
- Tag uploaded image with detected product category
- Compute sharpness score and store with confidence
- Set `enhancement_types[]` based on detected issues
- Update `enhancement_job.status` to processing / completed / failed
- Log touchpoint events

### Medium — Light approval (builder confirms in UI)
- Re-run enhancement job with different parameters
- Mark a change request as `in_progress` and assign
- Flag a low-confidence output for manual review

### High — Always requires approval
- Issue a refund via Stripe (builder clicks Approve in leads table)
- Send a re-engagement email to a lead

### Critical — Human-only
- Delete an image or enhancement output from storage
- Issue full account deletion
- Any legal or compliance action

## Named Tools (approved list)
- `enhance_image(image_id, types[])` — calls removal.ai + sharpen pipeline
- `create_stripe_checkout(lead_id, plan)` — server-side session creation
- `log_touchpoint(lead_id, event, metadata)` — writes touchpoints row
- `score_image_quality(image_id)` — runs Laplacian sharpness scorer
- `send_email(to, template_id, vars)` — Resend only, approved templates

## Audit Log Fields (on touchpoints + enhancement_jobs)
- `event` — what happened
- `metadata` — related IDs and values
- `created_at` — timestamp
- Agent actions additionally record: `tool_used`, `triggered_by`, `approved_by`

## v1 vs Later
| v1 | Later |
|---|---|
| Auto-tag + score only | Full recommendation pipeline |
| Manual refund by builder | Semi-automated refund with approval UI |
| No outbound email agent | Lead re-engagement agent (medium risk) |