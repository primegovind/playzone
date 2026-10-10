# PLAYZONE live setup (Android-friendly)

This starter kit contains:
- `index.html` — responsive PLAYZONE front end with email sign-up/login and upload UI.
- `supabase_setup.sql` — database and access policies.

## Before you start
You'll need accounts at Supabase and Vercel. A Supabase Free project has a 50 MB maximum file-size ceiling; this starter checks for 50 MB uploads. Gaming videos can be large, so compress them or budget for storage/bandwidth before opening the site to many users.

## 1. Create the backend
1. Open https://supabase.com in Chrome and create a project.
2. Open SQL Editor -> New query, paste all of `supabase_setup.sql`, and run it.
3. Open Storage -> New bucket. Name it exactly `game-videos`; set it to **Public**.
4. Set allowed MIME types to `video/mp4`, `video/webm`, `video/quicktime` and maximum file size to 50 MB.
5. Open Project Settings -> API (or Connect). Copy the Project URL and the publishable key / legacy anon key. Never copy a `service_role` or secret key into the website.

## 2. Connect the website
1. Open `index.html` in a code editor on a computer, or use a browser-based editor that can edit/upload text files.
2. Find this line near the bottom:
   `const CONFIG={url:"",anonKey:""};`
3. Put your Project URL in `url` and the publishable/anon key in `anonKey`. Keep the quotes. Example shape:
   `const CONFIG={url:"https://YOUR-PROJECT.supabase.co",anonKey:"YOUR-PUBLISHABLE-KEY"};`
4. Save the file. The publishable/anon key is intended for browser use only when Row Level Security is correctly enabled; do not expose service-role secrets.

## 3. Publish from your phone
1. Create/sign in to GitHub and make a new repository called `playzone`.
2. Upload `index.html` to the repository root. Keep the file name exactly `index.html`.
3. Open https://vercel.com, sign in with GitHub, tap Add New -> Project, import `playzone`, and deploy with the default settings.
4. Vercel will provide a public URL. Open it on your phone and test account registration, email confirmation, login, upload, and public playback.
5. Optional: buy a domain later and connect it in Vercel project settings.

## Important limitations / production checklist
- The page currently supports email/password auth and public video listing/upload. Email confirmation settings depend on your Supabase Auth configuration.
- Uploads are limited to 50 MB in this starter. Use a resumable upload setup and an appropriate storage/bandwidth budget for large files.
- A public bucket means anyone who obtains a video URL can watch that file. Only upload content you own or have permission to distribute.
- Add admin moderation, report/takedown tools, rate limiting, abuse monitoring, privacy policy, terms, and a content deletion process before promoting publicly.
- Do not add a service-role/secret key to `index.html`.
