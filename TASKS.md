# TASKS

Shared progress log between the WFH laptop and the 10camp office PC. Update this file before switching machines — `git pull` carries it over, no separate sync needed.

## How to use
1. Before starting work, `git pull --ff-only origin main` and read this file.
2. While working, jot what you're doing under **In progress**.
3. Before switching machines (or ending a session), move finished items to **Done**, note anything the other machine needs to know under **Handoff notes**, and `git add TASKS.md && git commit && git push`.

## In progress
- (nothing — add here when starting new work)

## Up next
- (nothing queued)

## Handoff notes
- 2026-11-12 (laptop HP → PC office): **Laptop HP ProBook 430 G7 kini device ke-3** (selain PC office & laptop MSI).
  - Repo di-clone di `C:\Users\zack\Projects\illham-art2`, sama dengan `origin/main` (`9ae72a7`). Tiada perubahan kod dibuat dari HP.
  - Tools di HP: Git, Node 24, gh CLI, Chrome. Belum ada: VS Code, Python sebenar.
  - `CLAUDE.local.md` **sengaja tak dipindah** ke HP (keputusan 12 Nov). HP untuk kerja frontend/wording sahaja; kerja DB/backend/secrets buat di PC office. (Pembetulan: masa nota ni ditulis, PC office pun belum ada fail tu; sekarang dah ada di PC office.)
  - HP tiada `.env` dan tak jalankan task keep-alive Supabase (PC office + MSI dah jalankan).
  - Draf Threads harian disimpan dalam artifact claude.ai, bukan dalam repo ni. Link ada dalam memori Claude, sengaja tak ditulis sini sebab repo public.
  - Peringatan: buka `claude` dalam folder repo (bukan Desktop) supaya `CLAUDE.md` dimuatkan.
- 2026-11-01 (WFH laptop): file created, then rebased on top of 28 commits pushed from elsewhere (likely the office PC) between 2026-08-15 and now that this laptop hadn't pulled yet — this laptop's memory of this repo was stale. Worth re-checking `git log` for real state before assuming where things left off, going forward. Repo now clean, `main` up to date with `origin/main`, last commit `ceec355`.

## Done (recent)
- `f9079d0` Tab "Sebut Harga" di admin.html (dari laptop HP): jana quotation, cetak/PDF, hantar WhatsApp, salin teks. Frontend sahaja, draf dalam localStorage browser (tiada DB). Kalau nak simpan sejarah quotation dalam DB, buat di PC office (table + migration baru).
- `ceec355` Add estimated size note to hero description
- `d27fd5e` Change wording from budi bicara anda to budi bicara sesama
- `a8cf182` Change Kemasan step wording from disegel to berlamina
- `b53e69b` Round sharp button/image corners site-wide; make Tanya di WA buttons WhatsApp green
- `ae2f50d` Add email notification for new orders via Resend + pg_net trigger
- `ed199d4` feat: tukar order.html jadi wizard step-by-step (5 langkah)
- (full history: `git log --oneline`)
