create extension if not exists "pgcrypto";

create table if not exists public.projects (
  id uuid primary key default gen_random_uuid(),
  title text not null,
  slug text not null unique,
  category text,
  summary text,
  problem text,
  solution text,
  role text,
  technologies text[] not null default '{}',
  repository_url text,
  demo_url text,
  cover_image_url text,
  is_active boolean not null default true,
  sort_order integer not null default 0,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create table if not exists public.contact_messages (
  id uuid primary key default gen_random_uuid(),
  name text not null check (char_length(name) between 2 and 120),
  email text not null,
  subject text not null check (char_length(subject) between 2 and 160),
  message text not null check (char_length(message) between 10 and 5000),
  status text not null default 'new' check (status in ('new', 'read', 'replied', 'archived')),
  created_at timestamptz not null default now()
);

alter table public.projects enable row level security;
alter table public.contact_messages enable row level security;

create policy "Public can read active projects"
on public.projects for select
to anon, authenticated
using (is_active = true);

create policy "Public can submit contact messages"
on public.contact_messages for insert
to anon, authenticated
with check (true);

revoke select on public.contact_messages from anon, authenticated;
