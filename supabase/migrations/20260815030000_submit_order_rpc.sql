-- Public order submission goes through this function instead of a direct
-- table grant, so we can safely return queue_number to the customer
-- without giving anon any SELECT access to the orders table at all.

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
  if p_reference_photo_path is null or btrim(p_reference_photo_path) = '' then
    raise exception 'reference_photo_path is required';
  end if;

  return query
  insert into public.orders (
    customer_name, email, phone, delivery_address,
    reference_photo_path, bookmark_size
  )
  values (
    btrim(p_customer_name), btrim(p_email), btrim(p_phone), btrim(p_delivery_address),
    p_reference_photo_path, nullif(btrim(p_bookmark_size), '')
  )
  returning orders.id, orders.queue_number;
end;
$$;

revoke all on function public.submit_order from public;
grant execute on function public.submit_order to anon;

-- Superseded by the RPC above: anon no longer needs (or gets) any direct grant/policy on the table.
revoke insert (
  customer_name, email, phone, delivery_address,
  reference_photo_path, bookmark_size
) on public.orders from anon;
drop policy if exists "public can submit orders" on public.orders;
