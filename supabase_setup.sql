-- PLAYZONE Supabase setup
-- Run this entire script in Supabase Dashboard -> SQL Editor -> New query.
-- Create a PUBLIC Storage bucket named game-videos separately (Storage -> New bucket).
-- Set its allowed MIME types to video/mp4, video/webm, video/quicktime and file size to 50 MB.

create table if not exists public.videos (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users(id) on delete cascade,
  title text not null check (char_length(title) between 1 and 100),
  category text not null default 'Other',
  creator text not null default 'Creator',
  video_url text not null,
  storage_path text not null,
  status text not null default 'published' check (status in ('published','removed')),
  created_at timestamptz not null default now()
);

alter table public.videos enable row level security;

drop policy if exists "Anyone can view published videos" on public.videos;
create policy "Anyone can view published videos"
on public.videos for select to anon, authenticated
using (status = 'published');

drop policy if exists "Signed-in users can publish their own videos" on public.videos;
create policy "Signed-in users can publish their own videos"
on public.videos for insert to authenticated
with check (auth.uid() = user_id);

drop policy if exists "Creators can update their own videos" on public.videos;
create policy "Creators can update their own videos"
on public.videos for update to authenticated
using (auth.uid() = user_id)
with check (auth.uid() = user_id);

drop policy if exists "Creators can delete their own videos" on public.videos;
create policy "Creators can delete their own videos"
on public.videos for delete to authenticated
using (auth.uid() = user_id);

-- Public video reads; uploads restricted to a folder named with the uploader's auth UID.
drop policy if exists "Anyone can watch public gaming videos" on storage.objects;
create policy "Anyone can watch public gaming videos"
on storage.objects for select to anon, authenticated
using (bucket_id = 'game-videos');

drop policy if exists "Users upload into their own folder" on storage.objects;
create policy "Users upload into their own folder"
on storage.objects for insert to authenticated
with check (
  bucket_id = 'game-videos'
  and (storage.foldername(name))[1] = auth.uid()::text
);

drop policy if exists "Users delete files in their own folder" on storage.objects;
create policy "Users delete files in their own folder"
on storage.objects for delete to authenticated
using (
  bucket_id = 'game-videos'
  and (storage.foldername(name))[1] = auth.uid()::text
);

-- IMPORTANT:
-- Never put a Supabase service_role key in browser code.
-- Public bucket URLs are accessible to anyone who has the URL.
-- For a real production service, add report/takedown/moderation workflows and rate limits.
