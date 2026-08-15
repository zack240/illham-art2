-- Backoffice: orders table for illham.art custom bookmark orders

create extension if not exists pgcrypto;

create table if not exists public.orders (
  id uuid primary key default gen_random_uuid(),
  queue_number bigint generated always as identity,
  customer_name text not null,
  email text not null,
  phone text not null,
  delivery_address text not null,
  reference_photo_path text not null,
  bookmark_size text,
  price numeric(10,2),
  estimated_completion_date date,
  status text not null default 'baru'
    check (status in ('baru','dalam_lukisan','siap','dihantar')),
  payment_status text not null default 'belum_bayar'
    check (payment_status in ('belum_bayar','deposit','lunas')),
  completed_photo_path text,
  gallery_consent boolean not null default false,
  courier_tracking_number text,
  admin_notes text,
  is_archived boolean not null default false,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create index if not exists orders_status_idx on public.orders (status) where not is_archived;
create index if not exists orders_created_at_idx on public.orders (created_at desc);

-- keep updated_at current on every row change
create or replace function public.set_updated_at()
returns trigger
language plpgsql
as $$
begin
  new.updated_at = now();
  return new;
end;
$$;

drop trigger if exists orders_set_updated_at on public.orders;
create trigger orders_set_updated_at
  before update on public.orders
  for each row
  execute function public.set_updated_at();

-- Row Level Security
alter table public.orders enable row level security;

-- Public order form: anon can create a new order row, nothing else.
-- Column-level grant means anon literally cannot set status/price/payment_status/etc even in an insert payload.
revoke all on public.orders from anon;
grant insert (
  customer_name, email, phone, delivery_address,
  reference_photo_path, bookmark_size
) on public.orders to anon;

create policy "public can submit orders"
  on public.orders
  for insert
  to anon
  with check (true);

-- Admin backoffice: any logged-in (authenticated) user has full access.
-- Safe only because public signup must stay disabled in Supabase Auth settings
-- (single manually-created admin account for Bro) — see setup notes.
grant select, update, delete, insert on public.orders to authenticated;

create policy "admin full access"
  on public.orders
  for all
  to authenticated
  using (true)
  with check (true);

-- Storage: private buckets for reference photos (customer upload) and completed photos (admin upload)
insert into storage.buckets (id, name, public)
values ('reference-photos', 'reference-photos', false)
on conflict (id) do nothing;

insert into storage.buckets (id, name, public)
values ('completed-photos', 'completed-photos', false)
on conflict (id) do nothing;

create policy "anon can upload reference photos"
  on storage.objects
  for insert
  to anon
  with check (bucket_id = 'reference-photos');

create policy "admin can read reference photos"
  on storage.objects
  for select
  to authenticated
  using (bucket_id = 'reference-photos');

create policy "admin manages completed photos"
  on storage.objects
  for all
  to authenticated
  using (bucket_id = 'completed-photos')
  with check (bucket_id = 'completed-photos');
