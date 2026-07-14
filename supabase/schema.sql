-- Supabase project: vastet-freshfood
-- Public nutrition data remains static JSON served from Vercel CDN.

create table subscribers (
  id uuid primary key default gen_random_uuid(),
  email text unique not null,
  source text default 'freshfood_calculator',
  lang text default 'zh',
  created_at timestamptz default now()
);
alter table subscribers enable row level security;
create policy "anon insert only" on subscribers for insert to anon with check (true);

create table saved_formulas (
  id uuid primary key default gen_random_uuid(),
  share_token text unique default encode(gen_random_bytes(9),'base64'),
  species text, breed text, weight_kg numeric,
  life_stage text, neutered boolean, activity text, health_mode text,
  cook_mode text default '連湯',
  ingredients jsonb, daily_kcal numeric,
  created_at timestamptz default now()
);
alter table saved_formulas enable row level security;
create policy "anon insert" on saved_formulas for insert to anon with check (true);
create policy "read by token" on saved_formulas for select to anon using (true);
