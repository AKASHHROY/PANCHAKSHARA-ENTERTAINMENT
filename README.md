# Panchakshara Entertainment — Cloud Upload & Playback MVP

This updates the existing static OTT site to use Supabase for remote catalogue metadata, poster storage, video storage, admin sign-in, publishing and deletion. Because the Android app loads the hosted GitHub Pages site, published catalogue items will also appear in the Android app after the site is updated.

## Before starting

- You need a Supabase project and its Project URL + **anon/public key**.
- Never put the `service_role` key in website JavaScript or commit it to GitHub.
- This starter uses public video URLs for the first MVP. **Premium labels are not access control**; anyone with the media URL can view a public-bucket video. Only upload content you own or have distribution rights for. Do not upload paywalled/licensed premium content until private storage + signed playback URLs and subscription checks are implemented.
- Large video delivery and transcoding at scale should move to a dedicated streaming service (e.g. Cloudflare Stream) or resumable uploads/CDN. This starter uses a straightforward Storage upload and is intended for a controlled MVP/test.

## Setup

1. Create a project at https://supabase.com/ and wait for it to finish provisioning.
2. In Supabase Dashboard, open **Project Settings → API** (or API Keys) and copy the Project URL and `anon` / publishable public key.
3. Edit `supabase-config.js` and replace both placeholder values. Use the anon/publishable key only; never use a service-role/secret key.
4. Open **SQL Editor** in Supabase and run the entire `supabase-schema.sql` file.
5. In **Authentication → Users**, create an admin user with an email and strong password. This MVP intentionally has no public sign-up screen.
6. Back in SQL Editor, run the admin grant statement, replacing the email:

   ```sql
   insert into public.admins (user_id)
   select id from auth.users where email = 'your-real-admin-email@example.com'
   on conflict do nothing;
   ```

7. Replace the website files in your existing GitHub repo with `index.html`, `supabase-config.js`, and the `assets/` folder. Commit and push to `main`; keep the files at the repository root so the relative asset paths work with GitHub Pages.
8. Wait for GitHub Pages to deploy, then hard-refresh the website. Open Creator Studio and sign in with the admin email/password.
9. Upload an MP4 test clip and poster. Once published, it should appear in the site catalogue and play in the player. The Android WebView uses the same live site, so it should also see the title when refreshed/reopened.

## Recommended test

Use a short MP4 you own (H.264 video + AAC audio), ideally under 50 MB for the first test. Test upload, reload the website, check the title remains in the catalogue, play/seek the video, and open the Android app on a connected phone.

## Important limitations

- Public bucket media is public. `Premium` is only a label in this starter and does not restrict playback.
- The simple upload call is not resumable; unstable connections or large files can fail. For production, implement TUS/resumable uploads and a streaming/transcoding provider.
- This does not yet include payments, subscriber accounts, DRM, adaptive bitrate transcoding, moderation workflows, analytics, or Play Store publishing.
- Supabase has usage and storage quotas/billing. Review your plan and storage limits before uploading a catalogue of full-length films.
