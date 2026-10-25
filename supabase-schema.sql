-- Panchakshara Entertainment streaming MVP
-- Run in Supabase Dashboard -> SQL Editor. Public media means uploaded video URLs are publicly reachable.

create extension if not exists pgcrypto;

create table if not exists public.admins (
  user_id uuid primary key references auth.users(id) on delete cascade,
  created_at timestamptz not null default now()
);

alter table public.admins enable row level security;
drop policy if exists "Admins can read their own admin row" on public.admins;
create policy "Admins can read their own admin row" on public.admins
  for select to authenticated using (user_id = auth.uid());

create table if not exists public.titles (
  id uuid primary key default gen_random_uuid(),
  title text not null check (char_length(title) between 1 and 90),
  kind text not null default 'Movie',
  access text not null default 'Free' check (access in ('Free','Premium')),
  creator text,
  genre text,
  language text,
  year integer,
  duration text,
  cast text,
  crew text,
  description text,
  video_url text not null,
  video_path text not null,
  poster_url text,
  poster_path text,
  published boolean not null default false,
  created_by uuid references auth.users(id) on delete set null,
  created_at timestamptz not null default now()
);

alter table public.titles enable row level security;
drop policy if exists "Visitors can read published titles" on public.titles;
create policy "Visitors can read published titles" on public.titles
  for select to anon, authenticated using (published = true or exists (select 1 from public.admins a where a.user_id = auth.uid()));
drop policy if exists "Admins can insert titles" on public.titles;
create policy "Admins can insert titles" on public.titles
  for insert to authenticated with check (exists (select 1 from public.admins a where a.user_id = auth.uid()) and created_by = auth.uid());
drop policy if exists "Admins can delete titles" on public.titles;
create policy "Admins can delete titles" on public.titles
  for delete to authenticated using (exists (select 1 from public.admins a where a.user_id = auth.uid()));

-- Public buckets support simple HTML5 video playback. Do NOT use this setup for confidential/licensed premium-only content.
insert into storage.buckets (id, name, public, file_size_limit, allowed_mime_types)
values ('videos', 'videos', true, 2147483648, array['video/mp4','video/webm','video/quicktime','video/x-m4v','application/octet-stream'])
on conflict (id) do update set public = true, file_size_limit = excluded.file_size_limit, allowed_mime_types = excluded.allowed_mime_types;
insert into storage.buckets (id, name, public, file_size_limit, allowed_mime_types)
values ('posters', 'posters', true, 10485760, array['image/jpeg','image/png','image/webp','image/avif'])
on conflict (id) do update set public = true, file_size_limit = excluded.file_size_limit, allowed_mime_types = excluded.allowed_mime_types;

drop policy if exists "Public can view video objects" on storage.objects;
create policy "Public can view video objects" on storage.objects for select to anon, authenticated using (bucket_id in ('videos','posters'));
drop policy if exists "Admins can upload media" on storage.objects;
create policy "Admins can upload media" on storage.objects for insert to authenticated with check (bucket_id in ('videos','posters') and exists (select 1 from public.admins a where a.user_id = auth.uid()));
drop policy if exists "Admins can delete media" on storage.objects;
create policy "Admins can delete media" on storage.objects for delete to authenticated using (bucket_id in ('videos','posters') and exists (select 1 from public.admins a where a.user_id = auth.uid()));

-- After creating the admin user in Authentication -> Users, run this statement with that exact email:
-- insert into public.admins (user_id) select id from auth.users where email = 'YOUR_ADMIN_EMAIL_HERE' on conflict do nothing;
