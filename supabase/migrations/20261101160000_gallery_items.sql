-- Gallery items: curated showcase of completed customer artwork for the
-- "Semua Karya" grid on gallery.html. Kept independent of the orders table
-- so admin can pick the best photo + a display title without exposing any
-- customer PII, and so the image bucket can safely be public.

create table if not exists public.gallery_items (
  id uuid primary key default gen_random_uuid(),
  title text not null,
  category text not null check (category in ('bookmark', 'portrait', 'gift_set')),
  image_path text not null,
  display_order integer not null default 0,
  created_at timestamptz not null default now()
);

create index if not exists gallery_items_display_order_idx on public.gallery_items (display_order);

alter table public.gallery_items enable row level security;

-- Public gallery page: anyone can read, nothing else.
grant select on public.gallery_items to anon, authenticated;
create policy "public can read gallery items"
  on public.gallery_items
  for select
  to anon, authenticated
  using (true);

-- Admin backoffice: only the admin UID with a fully-verified 2FA session can manage.
grant insert, update, delete on public.gallery_items to authenticated;
create policy "admin manages gallery items"
  on public.gallery_items
  for all
  to authenticated
  using (
    auth.uid() = '335d6341-a82d-4d51-bf8f-399dc9a0c3b5'::uuid
    and (auth.jwt()->>'aal') = 'aal2'
  )
  with check (
    auth.uid() = '335d6341-a82d-4d51-bf8f-399dc9a0c3b5'::uuid
    and (auth.jwt()->>'aal') = 'aal2'
  );

-- Public bucket for gallery photos (safe to expose: admin-curated, no customer PII).
insert into storage.buckets (id, name, public)
values ('gallery-photos', 'gallery-photos', true)
on conflict (id) do nothing;

create policy "public can read gallery photos"
  on storage.objects
  for select
  to anon, authenticated
  using (bucket_id = 'gallery-photos');

create policy "admin manages gallery photos"
  on storage.objects
  for all
  to authenticated
  using (
    bucket_id = 'gallery-photos'
    and auth.uid() = '335d6341-a82d-4d51-bf8f-399dc9a0c3b5'::uuid
    and (auth.jwt()->>'aal') = 'aal2'
  )
  with check (
    bucket_id = 'gallery-photos'
    and auth.uid() = '335d6341-a82d-4d51-bf8f-399dc9a0c3b5'::uuid
    and (auth.jwt()->>'aal') = 'aal2'
  );
