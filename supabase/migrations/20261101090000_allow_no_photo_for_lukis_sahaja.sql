-- "Lukis Sahaja" orders don't need a reference photo (customer wants an
-- original piece, not a copy of a photo), but every other bookmark_size
-- still requires one. Previously reference_photo_path was NOT NULL and
-- unconditionally required, which blocked "Lukis Sahaja" submissions.

alter table public.orders
  alter column reference_photo_path drop not null;

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
  if p_delivery_address is null or btrim(p_delivery_address) = '' then
    raise exception 'delivery_address is required';
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
    btrim(p_customer_name), btrim(p_email), btrim(p_phone), btrim(p_delivery_address),
    nullif(btrim(coalesce(p_reference_photo_path, '')), ''), nullif(btrim(p_bookmark_size), '')
  )
  returning orders.id, orders.queue_number;
end;
$$;
