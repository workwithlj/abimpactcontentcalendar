# Prompt: Build My Content Guide Landing Page

Copy everything below the line into your AI tool or hand it to a developer. Fill in the `[brackets]` first. Delete any you don't need.

---

## Role and goal

You are a senior front-end designer and developer. Build a single-page website called **[Content Guide name, e.g. "Shoot Book"]** that works as my personal content production guide. It should look and feel like a polished landing page, but it is a working tool I open before and during shoots.

The page answers three questions at a glance:

1. **When** am I shooting? (interactive calendar)
2. **How** should each shoot look and run? (shoot guide)
3. **What** exactly do I need to capture? (shot list)

## About me and my content

- **Who I am:** [e.g. freelance videographer / content creator / social media manager at ABImpact]
- **Clients or brands I shoot for:** [e.g. SBN, personal brand, café client]
- **Platforms:** [e.g. Instagram Reels, TikTok, YouTube, LinkedIn]
- **Main formats:** [e.g. 9:16 vertical reels, 16:9 interviews, photo carousels]
- **Gear I usually bring:** [e.g. Sony A7 IV, 24-70mm, gimbal, wireless lavs, 2 LED panels]

## Page structure

Build the page in this order. Use a sticky top nav with anchor links to each section: **Calendar · Shoot Guide · Shot List**.

### 1. Hero

- Page title and a one-line purpose, e.g. "Everything I need before I hit record."
- A "Next up" card showing the nearest upcoming shoot: title, date, call time, location, client, and a countdown ("in 3 days").
- Two buttons: **View calendar** and **Open shot list** (both scroll to their sections).
- Keep the hero compact. It should not fill the whole screen.

### 2. Interactive calendar

- Month view by default, with **previous / next month** arrows and a **Today** button.
- A toggle to switch to a **list view** (upcoming shoots in date order), which is the default on phones.
- Each day cell shows colored chips for the shoots on that day. Color each chip by **shoot type** (e.g. Reel, Interview, Product, Event, BTS) with a small legend above the calendar.
- Today is clearly highlighted. Past days are dimmed.
- Clicking a shoot chip selects that shoot and:
  - scrolls to (or opens) its Shoot Guide and Shot List below, and
  - updates both sections to show that shoot's details.
- Clicking an empty day opens an **Add shoot** form prefilled with that date.
- Filters above the calendar: by client and by shoot type.
- Show a status on each shoot: **Planned**, **Confirmed**, **Shot**, **Delivered**.

### 3. Shoot guide (for the selected shoot)

Show the guide as a clean brief, grouped like this:

- **Overview:** title, client, date, call time, wrap time, location (with a "Open in Maps" link), status.
- **Concept:** one-paragraph idea, goal of the content, target platform and aspect ratio.
- **Look and feel:** mood words, color palette swatches, lighting notes, reference links (shown as link cards, not embedded).
- **Talent and crew:** names, roles, and a contact number shown as copyable text.
- **Wardrobe and props:** checklist.
- **Gear list:** checklist I can tick off while packing.
- **Run of show:** a simple timeline (time → activity), e.g. 9:00 Arrive & set up, 9:30 Lighting, 10:00 Interview.
- **Notes:** free text, e.g. parking, permits, client preferences.

### 4. Shot list (for the selected shoot)

- A table (cards on mobile) with these columns:
  - **#**, **Scene / location**, **Shot description**, **Shot type** (Wide, Medium, Close-up, Detail, B-roll, Talking head), **Camera movement** (Static, Pan, Tilt, Push-in, Gimbal walk, Handheld), **Lens / framing**, **Duration (s)**, **Audio** (Yes/No), **Priority** (Must-have / Nice-to-have), **Done** checkbox.
- A progress bar at the top: "12 of 18 shots captured".
- Filter by priority and by done / not done.
- Add, edit, delete and **drag to reorder** shots.
- A **Copy shot list** button that copies it as plain text so I can paste it into notes or a message.

## Data and saving

- Store shoots as structured data so the calendar, guide and shot list all read from the same source. Use this shape:

```json
{
  "id": "shoot-001",
  "title": "SBN Founder Interview",
  "client": "SBN",
  "type": "Interview",
  "status": "Confirmed",
  "date": "2026-10-16",
  "callTime": "09:00",
  "wrapTime": "13:00",
  "location": "SBN Office, Makati",
  "concept": "Founder shares the origin story for the brand's anniversary reel.",
  "platform": "Instagram Reels",
  "aspectRatio": "9:16",
  "mood": ["warm", "honest", "documentary"],
  "palette": ["#2F3A4A", "#D9A441", "#F2EDE4"],
  "lighting": "Key light at 45°, window as fill, practical lamp in background.",
  "references": [{ "label": "Reference reel", "url": "https://..." }],
  "crew": [{ "name": "Jeth", "role": "DP / Editor", "phone": "+63 ..." }],
  "wardrobe": [{ "item": "Navy polo, no logos", "done": false }],
  "gear": [{ "item": "Wireless lav x2", "done": false }],
  "runOfShow": [{ "time": "09:00", "activity": "Arrive and set up" }],
  "notes": "Basement parking, ask guard for slot B2.",
  "shots": [
    {
      "id": "s1",
      "scene": "Office desk",
      "description": "Founder introduces themself, looking slightly off-camera",
      "shotType": "Talking head",
      "movement": "Static",
      "lens": "50mm, medium close-up",
      "duration": 20,
      "audio": true,
      "priority": "Must-have",
      "done": false
    }
  ]
}
```

- Store all shoots in an online database (**Supabase**, free tier), not in browser storage. Every device, browser and website the app is opened on must see the same shoots. Do not use localStorage for shoot data (only as an optional offline cache).
- Save every change (new shoots, edits, ticked checkboxes) to the database immediately.
- Add **Export JSON** and **Import JSON** buttons so I can back up my data.
- Include step-by-step Supabase setup instructions written for a non-developer (create project, create table, copy the URL and public key into the app, set security rules).

## Sharing with my head editor

My head editor opens the same link and sees exactly what I see: every shoot, guide and shot list.

- There is one shared set of shoots. No per-client links and no hidden or internal fields.
- Anyone who opens the site can view everything, with no sign-in.
- Editing requires a simple sign-in (Supabase Auth, email magic link), so a stranger with the link can't change anything. Allow [me only / me and my head editor] to edit.
- **Live updates:** when I add or change a shoot, it appears on my head editor's open page within a few seconds without refreshing (Supabase Realtime).
- **Security rules:** Supabase Row Level Security with public read and signed-in write.
- Load the page with 4–6 realistic **example shoots** spread across this month and next, clearly marked as examples, so it never opens empty.

## Design direction

- **Mood:** [e.g. clean and cinematic / bold and editorial / soft and minimal]
- **Brand colors:** [hex codes, or "pick a palette inspired by film production: slate, clapperboard black, tungsten amber"]
- **Fonts:** [e.g. a condensed display face for headings + a readable sans for body + a mono face for timecodes and shot numbers] (Google Fonts only.)
- Use film-production details as real content, not decoration: timecode-style times (09:00), shot numbers (SH-01), slate-style shoot headers (SCENE / TAKE / ROLL).
- Avoid generic AI-template looks: no purple-to-blue gradients, no emoji section icons, no identical shadowed cards everywhere.
- Support **light and dark mode**, following the system setting, with a manual toggle.
- Fully responsive: works on my phone on set (one column, large tap targets, list view calendar) and on a laptop when planning.

## Technical requirements

- Single `index.html` with inline CSS and JS, or [React + Vite / Next.js] if preferred.
- No paid libraries. If a calendar library is used, pick a lightweight one (e.g. FullCalendar), otherwise build it with CSS Grid.
- Accessible: keyboard navigation for the calendar, visible focus states, labels on all inputs, enough color contrast, respects reduced-motion.
- No horizontal scrolling on mobile.
- Dates and times in [timezone, e.g. Asia/Manila].

## Nice-to-have (optional)

- **Print / PDF view** of a single shoot's guide and shot list for on-set use.
- **Add to Google Calendar** link for each shoot.
- **Duplicate shoot** button to reuse a past shoot as a template.
- A **"Day of"** mode: big text, only today's shoot, run of show, and shot list with large checkboxes.
- Weather note for the shoot date and location.

## Acceptance checklist

The page is done when:

- [ ] Opening it shows the hero with the next upcoming shoot and a filled calendar.
- [ ] Clicking any shoot on the calendar updates the Shoot Guide and Shot List to that shoot.
- [ ] I can add, edit and delete shoots and shots, and changes persist after a reload.
- [ ] A shoot I add appears when the app is opened on another device, browser or website.
- [ ] My head editor opens the link without signing in and sees my latest changes without refreshing.
- [ ] Checking off shots updates the progress bar.
- [ ] The page looks good and works on a 375px-wide phone and a 1440px laptop, in both light and dark mode.
- [ ] I can export my data to JSON and import it back.
