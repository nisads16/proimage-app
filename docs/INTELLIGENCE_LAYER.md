# Intelligence Layer

## Messy Inputs
- Raw phone photos: mixed lighting, cluttered backgrounds, soft focus
- No metadata on product type or intended platform
- User may not know which enhancements they need

## What Gets Auto-Structured
```json
{
  "enhancement_job_id": "uuid",
  "detected_issues": ["busy_background", "low_sharpness", "harsh_shadow"],
  "recommended_enhancements": ["background_removal", "sharpen", "shadow_removal"],
  "sharpness_score": { "value": 62, "source": "internal_scorer", "confidence": 0.88, "review_status": "unreviewed" },
  "output_url": { "value": "https://…/enhanced.png", "source": "removal.ai", "confidence": 0.95, "review_status": "unreviewed" }
}
```

## Events to Track
- Image uploaded
- Enhancement job started / completed / failed
- Sharpness score computed
- Output reviewed / approved
- Payment completed
- Download triggered

## Scoring Rules (v1 — rule-based)
- **Sharpness score** (0–100): computed via variance-of-Laplacian on server; <50 = flag low quality
- **Background complexity**: edge-density heuristic; high = recommend BG removal
- **Shadow detection**: brightness gradient; steep = recommend shadow removal

## What Gets Ranked
- Enhancement recommendations sorted by detected issue severity
- Change requests sorted by created_at (oldest first)

## v1 vs Later
| v1 | Later |
|---|---|
| Rule-based sharpness + edge scoring | ML model fine-tuned on product photos |
| Fixed enhancement menu | AI-suggested preset per product category |
| Manual review_status | Auto-approve high-confidence outputs |