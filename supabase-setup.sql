-- ─────────────────────────────────────────────────────────────
-- Setup de tablas para "Cenas Ligeras"
-- Ejecutar en: Supabase Dashboard → proyecto real-oviedo-tracker
--              → SQL Editor → New query → pegar y RUN
-- Las tablas usan prefijo `cenas_` para no chocar con las de
-- Real Oviedo Tracker.
-- ─────────────────────────────────────────────────────────────

-- 1. Ingredientes de la despensa
create table if not exists cenas_ingredients (
  id         bigserial primary key,
  name       text not null,
  created_at timestamptz default now()
);

-- 2. Menú semanal (1 fila por día de lunes a viernes)
create table if not exists cenas_weekly_menu (
  id         bigserial primary key,
  day        text not null unique,
  p1a text, p1b text, p1c text,
  p2a text, p2b text, p2c text,
  updated_at timestamptz default now()
);

-- 3. Historial de cenas
create table if not exists cenas_dinner_history (
  id         bigserial primary key,
  dinner     text not null,
  lunch      text,
  created_at timestamptz default now()
);

-- ─────────────────────────────────────────────────────────────
-- Row Level Security
-- La `anon key` se incrusta en el HTML público, así que CUALQUIERA
-- con la URL de la app puede leer/escribir en estas tablas.
-- Las políticas se aplican SOLO a estas 3 tablas — el resto del
-- proyecto (Real Oviedo Tracker) sigue protegido.
-- ─────────────────────────────────────────────────────────────

alter table cenas_ingredients     enable row level security;
alter table cenas_weekly_menu     enable row level security;
alter table cenas_dinner_history  enable row level security;

drop policy if exists "anon full access" on cenas_ingredients;
drop policy if exists "anon full access" on cenas_weekly_menu;
drop policy if exists "anon full access" on cenas_dinner_history;

create policy "anon full access" on cenas_ingredients
  for all to anon using (true) with check (true);

create policy "anon full access" on cenas_weekly_menu
  for all to anon using (true) with check (true);

create policy "anon full access" on cenas_dinner_history
  for all to anon using (true) with check (true);
