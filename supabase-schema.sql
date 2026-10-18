-- Gincana SNCT 2026 — Equipe Roxa
-- Execute no Supabase: SQL Editor > New query > Run.
create extension if not exists pgcrypto;

create table if not exists public.people (
  id uuid primary key default gen_random_uuid(),
  name text not null unique check (length(trim(name)) between 1 and 90),
  created_at timestamptz not null default now()
);

create table if not exists public.signups (
  id uuid primary key default gen_random_uuid(),
  activity_id text not null,
  person_id uuid not null references public.people(id) on delete cascade,
  created_at timestamptz not null default now(),
  unique (activity_id, person_id)
);

alter table public.people enable row level security;
alter table public.signups enable row level security;

-- ATENÇÃO: configuração simples para uma turma, sem login.
-- Qualquer pessoa com o link poderá ver, cadastrar nomes e alterar inscrições.
-- Para uma página pública de organização escolar, isso é prático, mas não oferece
-- proteção contra alterações mal-intencionadas. Não use dados sensíveis.
create policy "public can read people" on public.people for select to anon using (true);
create policy "public can add people" on public.people for insert to anon with check (true);
create policy "public can read signups" on public.signups for select to anon using (true);
create policy "public can add signups" on public.signups for insert to anon with check (true);
create policy "public can remove signups" on public.signups for delete to anon using (true);

grant usage on schema public to anon;
grant select, insert on public.people to anon;
grant select, insert, delete on public.signups to anon;
