-- Storage for per-slide background photos in the Draf TikTok slide editor
-- (drop an image, zoom/pan it to fit the 720x1280 frame). Same admin-only
-- lock as reference-photos/completed-photos — nothing here is ever public.

insert into storage.buckets (id, name, public)
values ('tiktok-slide-images', 'tiktok-slide-images', false)
on conflict (id) do nothing;

create policy "admin manages tiktok slide images"
  on storage.objects
  for all
  to authenticated
  using (
    bucket_id = 'tiktok-slide-images'
    and auth.uid() = '335d6341-a82d-4d51-bf8f-399dc9a0c3b5'::uuid
    and (auth.jwt()->>'aal') = 'aal2'
  )
  with check (
    bucket_id = 'tiktok-slide-images'
    and auth.uid() = '335d6341-a82d-4d51-bf8f-399dc9a0c3b5'::uuid
    and (auth.jwt()->>'aal') = 'aal2'
  );
