# VYBE+ OTT MVP — prototype 0.1

A responsive front-end prototype for an independent OTT platform.

## Run it
- Open `index.html` in a modern browser, or upload the folder to a static host such as GitHub Pages.
- Click **Creator Studio** to add a title, choose Free/Premium label, and optionally select a poster and video file.
- Click a title to open the player modal.

## Important prototype limitations
- This is a front-end demo. It does NOT securely upload videos to a server.
- Creator uploads use browser object URLs and may disappear on reload.
- There is no real login, creator approval, database, payment gateway, or subscription enforcement.
- The Premium label is only a UI demo and does not block access.
- Use only videos you own or are licensed to distribute.

## Suggested production MVP
1. Front end: this design, hosted on GitHub Pages or a similar static host.
2. Authentication + database: Supabase Auth/Postgres for accounts, creator roles, catalogue and watchlists.
3. Video pipeline: Cloudflare Stream for upload, encoding and adaptive playback; create upload URLs server-side and use signed playback for premium titles.
4. Payments: integrate a supported payment provider and verify payment server-side before granting entitlement.
5. Creator workflow: admin invites/approves creators; creators can draft titles; admin reviews and publishes.
6. Safety: report button, content rights confirmation, moderation queue, privacy policy, terms, age ratings, takedown contact and secure admin permissions.

## Suggested database entities
- profiles: id, display_name, role (viewer/creator/admin)
- titles: id, creator_id, title, synopsis, content_type, access_tier, status, poster_url, stream_uid, published_at
- episodes: id, title_id, season_number, episode_number, stream_uid
- entitlements: id, user_id, title_id or plan_id, status, expires_at
- watch_progress: user_id, title_id, seconds_watched, updated_at

## Real video hosting cost note
Streaming costs depend on stored video duration and minutes watched. Review current provider pricing before launching publicly.
