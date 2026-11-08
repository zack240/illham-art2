-- Internal-only content planning tool: draft TikTok carousel posts (slide
-- images, not video) and a reusable "word bank" of suggested
-- hooks/CTAs/openers/hashtags for the admin to click-insert while drafting.
-- Neither table is ever read by the public site — same admin-UID + aal2
-- lock as gallery_items/orders, no public policies at all.

create table if not exists public.tiktok_drafts (
  id uuid primary key default gen_random_uuid(),
  title text not null default '',
  status text not null default 'draf' check (status in ('draf', 'siap', 'posted')),
  scheduled_date date,
  caption text,
  hashtags text,
  slides jsonb not null default '[]'::jsonb,
  display_order integer not null default 0,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create index if not exists tiktok_drafts_display_order_idx on public.tiktok_drafts (display_order);
create index if not exists tiktok_drafts_scheduled_date_idx on public.tiktok_drafts (scheduled_date);

alter table public.tiktok_drafts enable row level security;

grant select, insert, update, delete on public.tiktok_drafts to authenticated;
create policy "admin manages tiktok drafts"
  on public.tiktok_drafts
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

drop trigger if exists tiktok_drafts_set_updated_at on public.tiktok_drafts;
create trigger tiktok_drafts_set_updated_at
  before update on public.tiktok_drafts
  for each row execute function public.set_updated_at();

create table if not exists public.word_bank (
  id uuid primary key default gen_random_uuid(),
  category text not null check (category in ('hook', 'cta', 'opener', 'hashtag')),
  text text not null,
  display_order integer not null default 0,
  created_at timestamptz not null default now()
);

create index if not exists word_bank_category_idx on public.word_bank (category, display_order);

alter table public.word_bank enable row level security;

grant select, insert, update, delete on public.word_bank to authenticated;
create policy "admin manages word bank"
  on public.word_bank
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

-- Starter word bank, brand voice matching illham.art's existing copy.
-- Guarded so re-running this migration by accident doesn't duplicate rows.
do $$
begin
  if not exists (select 1 from public.word_bank) then
    insert into public.word_bank (category, text, display_order) values
      ('hook', 'Korang pernah tak nak hadiah yang betul-betul personal?', 0),
      ('hook', 'Ni bukan just bookmark biasa...', 1),
      ('hook', 'POV: kau baru dapat hadiah yang buat kau nangis sikit 🥹', 2),
      ('hook', 'Setiap garisan ni ada cerita di sebaliknya.', 3),
      ('hook', 'Kalau nak hadiah yang ''dia'' takkan jumpa kat mana-mana lagi...', 4),
      ('hook', 'Proses lukis ni ambil masa lebih 2 jam — korang nak tengok?', 5),

      ('cta', 'DM / WhatsApp untuk tempah sekarang 📩', 0),
      ('cta', 'Link kat bio untuk borang tempahan.', 1),
      ('cta', 'Save post ni untuk nanti bila dah decide 🔖', 2),
      ('cta', 'Share dengan member yang perlukan hadiah ni!', 3),
      ('cta', 'Komen "NAK" kalau berminat, kami DM details.', 4),
      ('cta', 'Follow untuk tengok proses lukis setiap hari.', 5),

      ('opener', 'Setiap bookmark bermula dengan satu wajah yang disayangi...', 0),
      ('opener', 'Hadiah yang bukan sekadar hadiah.', 1),
      ('opener', 'Dibuat khas, bukan automatik.', 2),
      ('opener', 'Seni tangan, bukan AI.', 3),
      ('opener', 'Dari ilham ke tanganmu — macam biasa.', 4),
      ('opener', 'Siapa lagi nak wajah dia di atas bookmark sendiri?', 5),

      ('hashtag', '#illhamart', 0),
      ('hashtag', '#bookmarklukisan', 1),
      ('hashtag', '#hadiahpersonal', 2),
      ('hashtag', '#potretcustom', 3),
      ('hashtag', '#sokonglocal', 4),
      ('hashtag', '#handmademalaysia', 5),
      ('hashtag', '#giftideamalaysia', 6),
      ('hashtag', '#seniskets', 7);
  end if;
end;
$$;
