-- Email notification (via Resend) whenever a new order is submitted through order.html.
-- The Resend API key itself lives in Supabase Vault (secret name 'resend_api_key'),
-- set up out-of-band — never committed to this repo.

create extension if not exists pg_net;
create extension if not exists supabase_vault;

create or replace function public.notify_new_order()
returns trigger
language plpgsql
security definer
set search_path = ''
as $$
declare
  v_api_key text;
  v_queue text;
begin
  select decrypted_secret into v_api_key
  from vault.decrypted_secrets
  where name = 'resend_api_key';

  if v_api_key is null then
    return new; -- vault secret not configured; skip silently rather than block the order
  end if;

  v_queue := lpad(new.queue_number::text, 4, '0');

  perform net.http_post(
    url := 'https://api.resend.com/emails',
    headers := jsonb_build_object(
      'Authorization', 'Bearer ' || v_api_key,
      'Content-Type', 'application/json'
    ),
    body := jsonb_build_object(
      'from', 'illham.art <onboarding@resend.dev>',
      'to', jsonb_build_array('zakwanmahalli@gmail.com'),
      'subject', 'Tempahan baru #' || v_queue,
      'html',
        '<p>Ada tempahan baru masuk di illham.art:</p>' ||
        '<ul>' ||
        '<li><b>No. Giliran:</b> ' || v_queue || '</li>' ||
        '<li><b>Nama:</b> ' || coalesce(new.customer_name, '-') || '</li>' ||
        '<li><b>Telefon:</b> ' || coalesce(new.phone, '-') || '</li>' ||
        '<li><b>Emel:</b> ' || coalesce(new.email, '-') || '</li>' ||
        '<li><b>Alamat:</b> ' || coalesce(new.delivery_address, '-') || '</li>' ||
        '<li><b>Jenis Karya:</b> ' || coalesce(new.bookmark_size, '-') || '</li>' ||
        '</ul>' ||
        '<p><a href="https://illham.art/admin.html">Lihat di Admin</a></p>'
    )
  );

  return new;
end;
$$;

drop trigger if exists on_new_order_notify on public.orders;

create trigger on_new_order_notify
after insert on public.orders
for each row
execute function public.notify_new_order();
