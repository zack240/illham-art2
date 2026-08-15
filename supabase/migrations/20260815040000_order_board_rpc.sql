-- Public status board: lets any customer see the queue/status of all
-- active orders without any PII (no name/email/phone/address/photo).
-- Kept as a security-definer function, same pattern as submit_order,
-- so anon still gets zero direct grants on the orders table.

create or replace function public.get_order_board()
returns table (queue_number bigint, status text, estimated_completion_date date)
language plpgsql
security definer
set search_path = ''
stable
as $$
begin
  return query
  select o.queue_number, o.status, o.estimated_completion_date
  from public.orders o
  where not o.is_archived
  order by o.queue_number asc;
end;
$$;

revoke all on function public.get_order_board from public;
grant execute on function public.get_order_board to anon;
