-- Lock search_path on the trigger function per Supabase security advisor
-- (function_search_path_mutable) to prevent search_path hijacking.

create or replace function public.set_updated_at()
returns trigger
language plpgsql
set search_path = ''
as $$
begin
  new.updated_at = now();
  return new;
end;
$$;
