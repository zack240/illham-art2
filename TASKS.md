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
- 2026-11-01 (WFH laptop): file created, then rebased on top of 28 commits pushed from elsewhere (likely the office PC) between 2026-08-15 and now that this laptop hadn't pulled yet — this laptop's memory of this repo was stale. Worth re-checking `git log` for real state before assuming where things left off, going forward. Repo now clean, `main` up to date with `origin/main`, last commit `ceec355`.

## Done (recent)
- `ceec355` Add estimated size note to hero description
- `d27fd5e` Change wording from budi bicara anda to budi bicara sesama
- `a8cf182` Change Kemasan step wording from disegel to berlamina
- `b53e69b` Round sharp button/image corners site-wide; make Tanya di WA buttons WhatsApp green
- `ae2f50d` Add email notification for new orders via Resend + pg_net trigger
- `ed199d4` feat: tukar order.html jadi wizard step-by-step (5 langkah)
- (full history: `git log --oneline`)
