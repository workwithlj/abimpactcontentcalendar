-- ABiMPACT shoot calendar: run once in Supabase → SQL Editor.

-- One row per shoot. The whole shoot (guide, shot list, checklists) lives in "data".
create table public.shoots (
  id text primary key,
  data jsonb not null,
  updated_at timestamptz not null default now()
);

alter table public.shoots enable row level security;

-- Anyone with the link can view.
create policy "Anyone can view shoots"
  on public.shoots for select
  using (true);

-- Only work.ljcortez@gmail.com can add, change or delete.
create policy "Editor can add shoots"
  on public.shoots for insert to authenticated
  with check (lower(auth.jwt() ->> 'email') = 'work.ljcortez@gmail.com');

create policy "Editor can change shoots"
  on public.shoots for update to authenticated
  using (lower(auth.jwt() ->> 'email') = 'work.ljcortez@gmail.com')
  with check (lower(auth.jwt() ->> 'email') = 'work.ljcortez@gmail.com');

create policy "Editor can delete shoots"
  on public.shoots for delete to authenticated
  using (lower(auth.jwt() ->> 'email') = 'work.ljcortez@gmail.com');

-- Send live updates to open pages.
alter publication supabase_realtime add table public.shoots;
