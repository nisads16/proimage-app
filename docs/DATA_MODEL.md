# Data Model

## leads
| Field | Type | Notes |
|---|---|---|
| id | uuid PK | |
| user_id | uuid nullable | linked at auth lock-down |
| email | text | captured pre-enhancement |
| name | text nullable | |
| status | text | new / trial / paid / churned |
| created_at | timestamptz | |

## images
| Field | Type | Notes |
|---|---|---|
| id | uuid PK | |
| user_id | uuid nullable | |
| lead_id | uuid nullable → leads | |
| original_url | text | Supabase Storage URL |
| file_name | text | |
| file_size_kb | numeric | |
| product_category | text | user-selected or AI-inferred |
| created_at | timestamptz | |

## enhancement_jobs
| Field | Type | Notes |
|---|---|---|
| id | uuid PK | |
| user_id | uuid nullable | |
| image_id | uuid → images | |
| status | text | pending / processing / completed / failed |
| enhancement_types | text[] | background_removal, sharpen, shadow_removal, highlight |
| input_url | text | |
| output_url | text | **AI field** |
| output_url_source | text | e.g. removal.ai |
| output_url_confidence | numeric | 0–1 |
| output_url_review_status | text | unreviewed / approved / rejected |
| sharpness_score | numeric | **AI field** 0–100 |
| sharpness_score_source | text | |
| sharpness_score_confidence | numeric | |
| sharpness_score_review_status | text | |
| background_removed | boolean | |
| shadow_removed | boolean | |
| highlight_applied | boolean | |
| error_message | text nullable | |
| processing_ms | numeric | |
| created_at | timestamptz | |

## payments
| Field | Type | Notes |
|---|---|---|
| id | uuid PK | |
| user_id | uuid nullable | |
| lead_id | uuid nullable → leads | |
| stripe_session_id | text | |
| stripe_payment_intent_id | text | |
| amount_cents | integer | |
| currency | text | |
| plan | text | pay_per_image / monthly |
| status | text | pending / paid / failed / refunded |
| created_at | timestamptz | |

## touchpoints
| Field | Type | Notes |
|---|---|---|
| id | uuid PK | |
| user_id | uuid nullable | |
| lead_id | uuid nullable → leads | |
| event | text | uploaded / enhanced / viewed_pricing / paid / downloaded |
| metadata | jsonb | related IDs, amounts |
| created_at | timestamptz | |

## change_requests
| Field | Type | Notes |
|---|---|---|
| id | uuid PK | |
| user_id | uuid nullable | |
| lead_id | uuid nullable → leads | |
| enhancement_job_id | uuid → enhancement_jobs | |
| description | text | |
| status | text | open / in_progress / resolved |
| created_at | timestamptz | |

## RLS
- All tables: v1 permissive (read + write open) for demo
- Sprint 5: replace with `auth.uid() = user_id` owner policies