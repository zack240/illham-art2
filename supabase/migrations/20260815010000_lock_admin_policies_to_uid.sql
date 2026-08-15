-- Lock admin RLS policies to Bro's specific admin UID instead of trusting
-- the whole "authenticated" role. Belt-and-suspenders alongside disabled
-- public signup: even if another account is ever created, it gets no
-- access to customer orders/photos unless it matches this UID.

drop policy if exists "admin full access" on public.orders;
create policy "admin full access"
  on public.orders
  for all
  to authenticated
  using (auth.uid() = '335d6341-a82d-4d51-bf8f-399dc9a0c3b5'::uuid)
  with check (auth.uid() = '335d6341-a82d-4d51-bf8f-399dc9a0c3b5'::uuid);

drop policy if exists "admin can read reference photos" on storage.objects;
create policy "admin can read reference photos"
  on storage.objects
  for select
  to authenticated
  using (
    bucket_id = 'reference-photos'
    and auth.uid() = '335d6341-a82d-4d51-bf8f-399dc9a0c3b5'::uuid
  );

drop policy if exists "admin manages completed photos" on storage.objects;
create policy "admin manages completed photos"
  on storage.objects
  for all
  to authenticated
  using (
    bucket_id = 'completed-photos'
    and auth.uid() = '335d6341-a82d-4d51-bf8f-399dc9a0c3b5'::uuid
  )
  with check (
    bucket_id = 'completed-photos'
    and auth.uid() = '335d6341-a82d-4d51-bf8f-399dc9a0c3b5'::uuid
  );
