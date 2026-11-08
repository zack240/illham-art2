-- Alamat penghantaran kini pilihan (customer mungkin belum tahu alamat
-- semasa order, admin akan follow-up). Sebelum ini delivery_address was
-- NOT NULL dan wajib di RPC, menyekat submission tanpa alamat.

alter table public.orders
  alter column delivery_address drop not null;

create or replace function public.submit_order(
  p_customer_name text,
  p_email text,
  p_phone text,
  p_delivery_address text,
  p_reference_photo_path text,
  p_bookmark_size text default null
)
returns table (id uuid, queue_number bigint)
language plpgsql
security definer
set search_path = ''
as $$
begin
  if p_customer_name is null or btrim(p_customer_name) = '' then
    raise exception 'customer_name is required';
  end if;
  if p_email is null or btrim(p_email) = '' then
    raise exception 'email is required';
  end if;
  if p_phone is null or btrim(p_phone) = '' then
    raise exception 'phone is required';
  end if;
  if btrim(coalesce(p_bookmark_size, '')) is distinct from 'Lukis Sahaja'
     and (p_reference_photo_path is null or btrim(p_reference_photo_path) = '') then
    raise exception 'reference_photo_path is required';
  end if;

  return query
  insert into public.orders (
    customer_name, email, phone, delivery_address,
    reference_photo_path, bookmark_size
  )
  values (
    btrim(p_customer_name), btrim(p_email), btrim(p_phone),
    nullif(btrim(coalesce(p_delivery_address, '')), ''),
    nullif(btrim(coalesce(p_reference_photo_path, '')), ''), nullif(btrim(p_bookmark_size), '')
  )
  returning orders.id, orders.queue_number;
end;
$$;
