create table if not exists leads (
  id uuid primary key default gen_random_uuid(),
  user_id uuid,
  email text not null,
  name text,
  status text not null default 'new',
  created_at timestamptz not null default now()
);

alter table leads enable row level security;
drop policy if exists "leads_v1_read" on leads;
create policy "leads_v1_read" on leads for select using (true);
drop policy if exists "leads_v1_write" on leads;
create policy "leads_v1_write" on leads for all using (true) with check (true);

create table if not exists images (
  id uuid primary key default gen_random_uuid(),
  user_id uuid,
  lead_id uuid,
  original_url text not null,
  file_name text,
  file_size_kb numeric,
  product_category text,
  created_at timestamptz not null default now()
);

alter table images enable row level security;
drop policy if exists "images_v1_read" on images;
create policy "images_v1_read" on images for select using (true);
drop policy if exists "images_v1_write" on images;
create policy "images_v1_write" on images for all using (true) with check (true);

create table if not exists enhancement_jobs (
  id uuid primary key default gen_random_uuid(),
  user_id uuid,
  image_id uuid,
  status text not null default 'pending',
  enhancement_types text[] not null default '{}',
  input_url text not null,
  output_url text,
  output_url_source text,
  output_url_confidence numeric,
  output_url_review_status text default 'unreviewed',
  sharpness_score numeric,
  sharpness_score_source text,
  sharpness_score_confidence numeric,
  sharpness_score_review_status text default 'unreviewed',
  background_removed boolean default false,
  shadow_removed boolean default false,
  highlight_applied boolean default false,
  error_message text,
  processing_ms numeric,
  created_at timestamptz not null default now()
);

alter table enhancement_jobs enable row level security;
drop policy if exists "enhancement_jobs_v1_read" on enhancement_jobs;
create policy "enhancement_jobs_v1_read" on enhancement_jobs for select using (true);
drop policy if exists "enhancement_jobs_v1_write" on enhancement_jobs;
create policy "enhancement_jobs_v1_write" on enhancement_jobs for all using (true) with check (true);

create table if not exists payments (
  id uuid primary key default gen_random_uuid(),
  user_id uuid,
  lead_id uuid,
  stripe_session_id text,
  stripe_payment_intent_id text,
  amount_cents integer not null,
  currency text not null default 'usd',
  plan text not null default 'pay_per_image',
  status text not null default 'pending',
  created_at timestamptz not null default now()
);

alter table payments enable row level security;
drop policy if exists "payments_v1_read" on payments;
create policy "payments_v1_read" on payments for select using (true);
drop policy if exists "payments_v1_write" on payments;
create policy "payments_v1_write" on payments for all using (true) with check (true);

create table if not exists touchpoints (
  id uuid primary key default gen_random_uuid(),
  user_id uuid,
  lead_id uuid,
  event text not null,
  metadata jsonb,
  created_at timestamptz not null default now()
);

alter table touchpoints enable row level security;
drop policy if exists "touchpoints_v1_read" on touchpoints;
create policy "touchpoints_v1_read" on touchpoints for select using (true);
drop policy if exists "touchpoints_v1_write" on touchpoints;
create policy "touchpoints_v1_write" on touchpoints for all using (true) with check (true);

create table if not exists change_requests (
  id uuid primary key default gen_random_uuid(),
  user_id uuid,
  lead_id uuid,
  enhancement_job_id uuid,
  description text not null,
  status text not null default 'open',
  created_at timestamptz not null default now()
);

alter table change_requests enable row level security;
drop policy if exists "change_requests_v1_read" on change_requests;
create policy "change_requests_v1_read" on change_requests for select using (true);
drop policy if exists "change_requests_v1_write" on change_requests;
create policy "change_requests_v1_write" on change_requests for all using (true) with check (true);

insert into leads (id, email, name, status) values
  ('a1000000-0000-0000-0000-000000000001', 'sara@bloomcakes.co', 'Sara Bloom', 'paid'),
  ('a1000000-0000-0000-0000-000000000002', 'james@urbancraft.io', 'James Rowe', 'trial'),
  ('a1000000-0000-0000-0000-000000000003', 'priya@luxeleather.com', 'Priya Nair', 'new'),
  ('a1000000-0000-0000-0000-000000000004', 'tom@peakcycles.nz', 'Tom Hale', 'paid')
on conflict (id) do nothing;

insert into images (id, lead_id, original_url, file_name, file_size_kb, product_category) values
  ('b1000000-0000-0000-0000-000000000001', 'a1000000-0000-0000-0000-000000000001', 'https://placehold.co/800x800?text=Cake+Original', 'birthday-cake.jpg', 342, 'food'),
  ('b1000000-0000-0000-0000-000000000002', 'a1000000-0000-0000-0000-000000000002', 'https://placehold.co/800x800?text=Wallet+Original', 'leather-wallet.jpg', 518, 'fashion'),
  ('b1000000-0000-0000-0000-000000000003', 'a1000000-0000-0000-0000-000000000003', 'https://placehold.co/800x800?text=Bag+Original', 'tote-bag.jpg', 290, 'fashion'),
  ('b1000000-0000-0000-0000-000000000004', 'a1000000-0000-0000-0000-000000000004', 'https://placehold.co/800x800?text=Bike+Original', 'peak-cycle.jpg', 670, 'sporting goods')
on conflict (id) do nothing;

insert into enhancement_jobs (id, image_id, status, enhancement_types, input_url, output_url, output_url_source, output_url_confidence, output_url_review_status, sharpness_score, sharpness_score_source, sharpness_score_confidence, sharpness_score_review_status, background_removed, shadow_removed, highlight_applied) values
  ('c1000000-0000-0000-0000-000000000001', 'b1000000-0000-0000-0000-000000000001', 'completed', '{"background_removal","sharpen","highlight"}', 'https://placehold.co/800x800?text=Cake+Original', 'https://placehold.co/800x800?text=Cake+Enhanced', 'removal.ai', 0.97, 'approved', 92, 'internal_scorer', 0.91, 'approved', true, false, true),
  ('c1000000-0000-0000-0000-000000000002', 'b1000000-0000-0000-0000-000000000002', 'completed', '{"background_removal","shadow_removal","sharpen"}', 'https://placehold.co/800x800?text=Wallet+Original', 'https://placehold.co/800x800?text=Wallet+Enhanced', 'removal.ai', 0.95, 'approved', 88, 'internal_scorer', 0.89, 'approved', true, true, false),
  ('c1000000-0000-0000-0000-000000000003', 'b1000000-0000-0000-0000-000000000003', 'completed', '{"background_removal","sharpen"}', 'https://placehold.co/800x800?text=Bag+Original', 'https://placehold.co/800x800?text=Bag+Enhanced', 'removal.ai', 0.93, 'unreviewed', 85, 'internal_scorer', 0.87, 'unreviewed', true, false, false),
  ('c1000000-0000-0000-0000-000000000004', 'b1000000-0000-0000-0000-000000000004', 'failed', '{"background_removal","highlight"}', 'https://placehold.co/800x800?text=Bike+Original', null, null, null, 'unreviewed', null, null, null, 'unreviewed', false, false, false)
on conflict (id) do nothing;

insert into payments (id, lead_id, amount_cents, currency, plan, status) values
  ('d1000000-0000-0000-0000-000000000001', 'a1000000-0000-0000-0000-000000000001', 990, 'usd', 'pay_per_image', 'paid'),
  ('d1000000-0000-0000-0000-000000000002', 'a1000000-0000-0000-0000-000000000004', 2900, 'usd', 'monthly', 'paid')
on conflict (id) do nothing;

insert into touchpoints (lead_id, event, metadata) values
  ('a1000000-0000-0000-0000-000000000001', 'uploaded', '{"image_id":"b1000000-0000-0000-0000-000000000001"}'),
  ('a1000000-0000-0000-0000-000000000001', 'enhanced', '{"job_id":"c1000000-0000-0000-0000-000000000001"}'),
  ('a1000000-0000-0000-0000-000000000001', 'paid', '{"payment_id":"d1000000-0000-0000-0000-000000000001"}'),
  ('a1000000-0000-0000-0000-000000000002', 'uploaded', '{"image_id":"b1000000-0000-0000-0000-000000000002"}'),
  ('a1000000-0000-0000-0000-000000000002', 'viewed_pricing', '{}'),
  ('a1000000-0000-0000-0000-000000000004', 'paid', '{"payment_id":"d1000000-0000-0000-0000-000000000002"}');