# Shared shoot calendar: Supabase setup

After this setup, every shoot you add is saved online. Anyone who opens the site sees the same shoots, and your changes appear on their screen within a few seconds without refreshing. Only you can edit.

It takes about 15 minutes. Supabase's free plan is enough.

---

## 1. Create a Supabase project

1. Go to **https://supabase.com** and sign up (signing in with GitHub or Google works).
2. Click **New project**.
3. Name it `abimpact-shoots`. Set a database password and save it in your password manager (the app doesn't need it).
4. Pick the region closest to you (e.g. **Southeast Asia (Singapore)**), then click **Create new project**.
5. Wait a minute or two while it sets up.

## 2. Create the shoots table and security rules

1. In the left sidebar, open **SQL Editor** and click **New query**.
2. Paste in everything below. **Replace `you@example.com` with your own email** (it's in 3 places).
3. Click **Run**. You should see "Success. No rows returned".

```sql
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

-- Only your account can add, change or delete.
create policy "Editor can add shoots"
  on public.shoots for insert to authenticated
  with check (lower(auth.jwt() ->> 'email') = lower('you@example.com'));

create policy "Editor can change shoots"
  on public.shoots for update to authenticated
  using (lower(auth.jwt() ->> 'email') = lower('you@example.com'))
  with check (lower(auth.jwt() ->> 'email') = lower('you@example.com'));

create policy "Editor can delete shoots"
  on public.shoots for delete to authenticated
  using (lower(auth.jwt() ->> 'email') = lower('you@example.com'));

-- Send live updates to open pages.
alter publication supabase_realtime add table public.shoots;
```

## 3. Add yourself as the only user

1. In the left sidebar, open **Authentication → Users**.
2. Click **Add user → Create new user**.
3. Enter **the same email** you used in step 2, set any password, and tick **Auto Confirm User**. Click **Create user**.
4. Open **Authentication → Sign In / Providers**. Under **User Signups**, turn off **Allow new users to sign up**, then click **Save**. This stops anyone else from creating an account.

## 4. Tell Supabase where your site lives

The sign-in link in your email must point back to your site.

1. Open **Authentication → URL Configuration**.
2. Set **Site URL** to your site's address, e.g. `https://abimpact.netlify.app/shootplan.html`.
3. Under **Redirect URLs**, click **Add URL** and add the same address. If you open the calendar from more than one address (e.g. your own domain as well), add each one.

## 5. Connect the app

1. Open **Project Settings → API** (or **Data API**). Copy the:
   - **Project URL** (looks like `https://abcdefghijkl.supabase.co`)
   - **anon public** key (a long text starting with `eyJ`). This key is safe to put in the site. The security rules from step 2 do the protecting.
   - Do **not** use the `service_role` key. It bypasses every rule.
2. Open `config.js` in this folder and fill in all three values:

```js
window.AB_CONFIG = {
  SUPABASE_URL: 'https://abcdefghijkl.supabase.co',
  SUPABASE_ANON_KEY: 'eyJhbGciOi...',
  EDITOR_EMAIL: 'you@example.com'
};
```

3. Upload the whole `abimpact` folder to your website as usual, including `config.js`.

## 6. Sign in and bring over your existing shoot

1. Open the calendar **on the site where you originally added your shoot**. That's the only place your browser saved it.
2. Click **Sign in to edit**, enter your email, and click **Email me a sign-in link**.
3. Open the email **in the same browser** and click the link. You'll come back to the calendar signed in, with the **New shoot** button showing.
4. Click **Data → Upload 1 shoot saved in this browser**. The status next to it changes to **Saving…**, then **Saved**.

If the upload option doesn't appear, that browser has no saved shoots. Try the browser or site where you first added it, or add the shoot again.

## 7. Share with your head editor

Send them the site link. They don't need an account. They'll see:

- every shoot, guide and shot list, with no edit buttons
- **Live** next to the Data button, meaning your changes appear on their screen automatically

---

## Troubleshooting

| What you see | What to do |
|---|---|
| **Not saved** or **Offline** next to the Data button | Check that `config.js` has the right Project URL and anon key, then check your internet connection. |
| "That email is not set up as an editor." | The email in the sign-in box doesn't match the user from step 3. |
| The sign-in link opens a page that doesn't exist | The site address in step 4 is wrong or missing. Add the exact address you open the calendar from. |
| Signed in, but no **New shoot** button | `EDITOR_EMAIL` in `config.js` doesn't match the email you signed in with. |
| "Not saved: new row violates row-level security policy" | The email in the SQL rules (step 2) doesn't match your sign-in email. Open **Authentication → Policies**, edit the three editor policies, and correct the email. |
| Your head editor doesn't see changes live | Check the last line of the SQL in step 2 ran. Run it again on its own if needed. Changes still appear when they refresh. |

## Going back

The previous version (saving in each browser only) is in `_backup-localstorage/`. If you clear the values in `config.js`, the app also goes back to saving in the browser only.
