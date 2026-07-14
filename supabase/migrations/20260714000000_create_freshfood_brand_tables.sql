-- VASTET freshfood brand data layer.
-- Do not run this migration against the legacy 毛孩找吃的 Supabase project (nqadvdjrkollatfldctj).

create extension if not exists pgcrypto;

create table if not exists subscribers (
  id uuid primary key default gen_random_uuid(),
  email text unique not null,
  source text default 'freshfood_calculator',
  lang text default 'zh',
  created_at timestamptz default now()
);

alter table subscribers enable row level security;

drop policy if exists "anon insert only" on subscribers;
create policy "anon insert only"
  on subscribers for insert
  to anon
  with check (true);

create table if not exists saved_formulas (
  id uuid primary key default gen_random_uuid(),
  share_token text unique default encode(gen_random_bytes(9), 'base64'),
  species text,
  breed text,
  weight_kg numeric,
  life_stage text,
  neutered boolean,
  activity text,
  health_mode text,
  cook_mode text default '連湯',
  ingredients jsonb,
  daily_kcal numeric,
  created_at timestamptz default now()
);

alter table saved_formulas enable row level security;

drop policy if exists "anon insert" on saved_formulas;
create policy "anon insert"
  on saved_formulas for insert
  to anon
  with check (true);

drop policy if exists "read by token" on saved_formulas;
create policy "read by token"
  on saved_formulas for select
  to anon
  using (true);
