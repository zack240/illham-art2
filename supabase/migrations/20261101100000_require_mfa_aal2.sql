-- Require a fully-verified TOTP (Google Authenticator) session for admin
-- backoffice access, on top of the existing UID lock. auth.jwt()->>'aal' is
-- 'aal2' only once the signed-in user has completed MFA verification for the
-- current session; a plain email+password sign-in alone stays at 'aal1'.
-- This closes the gap where someone with the admin password could otherwise
-- skip the 2FA prompt in admin.html and call the Supabase REST API directly.

drop policy if exists "admin full access" on public.orders;
create policy "admin full access"
  on public.orders
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

drop policy if exists "admin can read reference photos" on storage.objects;
create policy "admin can read reference photos"
  on storage.objects
  for select
  to authenticated
  using (
    bucket_id = 'reference-photos'
    and auth.uid() = '335d6341-a82d-4d51-bf8f-399dc9a0c3b5'::uuid
    and (auth.jwt()->>'aal') = 'aal2'
  );

drop policy if exists "admin manages completed photos" on storage.objects;
create policy "admin manages completed photos"
  on storage.objects
  for all
  to authenticated
  using (
    bucket_id = 'completed-photos'
    and auth.uid() = '335d6341-a82d-4d51-bf8f-399dc9a0c3b5'::uuid
    and (auth.jwt()->>'aal') = 'aal2'
  )
  with check (
    bucket_id = 'completed-photos'
    and auth.uid() = '335d6341-a82d-4d51-bf8f-399dc9a0c3b5'::uuid
    and (auth.jwt()->>'aal') = 'aal2'
  );
