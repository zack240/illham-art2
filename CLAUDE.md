# illham.art — panduan Claude Code

> Fail ini PUBLIC (repo public + dihidang oleh GitHub Pages). Jangan tulis key, token, password, lokasi fail rahsia, butiran polisi keselamatan DB, atau data pelanggan di sini. Itu semua simpan dalam `CLAUDE.local.md` (tidak di-commit) atau memori Claude device sendiri.

## Bahasa & gaya
- Balas dalam Bahasa Melayu. Panggil pengguna "Bro".
- Ringkas dan terus. Jangan tanya "nak push?" untuk tukar wording/label kecil, edit dan push terus.

## Projek
Laman jualan bookmark potret lukisan tangan: https://illham.art

| Fail | Fungsi |
|---|---|
| `index.html` | Laman utama (hero, proses, about) |
| `gallery.html` | Galeri hasil kerja |
| `order.html` | Borang tempahan (wizard 5 langkah) |
| `admin.html` | Backoffice (login wajib) |
| `supabase/migrations/` | Skema DB, ikut urutan tarikh nama fail |
| `.github/workflows/` | Workflow GitHub Actions |
| `TASKS.md` | Log kerja bersama antara device |

- Laman statik HTML/CSS/JS biasa. Tiada build step, tiada framework.
- Warna jenama (CSS var dalam `index.html`): `--cream:#F5F0E8`, `--ink:#2C2420`, `--charcoal:#4A3F38`, `--mauve:#C4B0B8`, `--white:#FAF8F5`.

## Deploy
- Hos: **GitHub Pages** (repo `zack240/illham-art2`, branch `main`). Push ke `main` = live dalam ~1 minit.
- **Jangan guna Netlify** untuk projek ini.
- Semak status deploy: `gh run list --repo zack240/illham-art2 --limit 3`.
- Kalau deploy gagal ("Deployment failed, try again later"), jangan `gh run rerun` (boleh tersangkut). Guna `gh api -X POST repos/zack240/illham-art2/pages/builds`.
- CDN boleh tunjuk versi lama beberapa minit. Minta Bro hard-refresh di browser sebelum anggap deploy rosak.

## Peraturan kod
- Bila kandungan gambar bertukar tapi nama fail sama, naikkan `?v=` pada SEMUA rujukan (contoh `illham-logo.png?v=2`, `favicon.png?v=3`).
- Sebelum percaya sesuatu CSS rule berfungsi, grep HTML untuk pastikan class tu memang wujud (pernah ada selector mati).
- Perubahan layout/CSS/mobile: semak visual dulu (viewport telefon) sebelum push. Tukar teks biasa: tak perlu.
- Bug visual tanpa screenshot: minta screenshot dulu, jangan teka bahagian mana.
- Perubahan DB: tambah fail migration baru dalam `supabase/migrations/`, jangan ubah migration lama.

## Kerja merentas device (PC office, laptop MSI, laptop HP)
1. Mula: `git pull --ff-only origin main`, kemudian baca `TASKS.md`.
2. Tamat / tukar device: kemas kini `TASKS.md`, commit, push.
3. Jangan sekali-kali commit `.env`, `supabase_details.txt` atau apa-apa yang ada dalam `.gitignore`.
