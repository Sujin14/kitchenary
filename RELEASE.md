# Release checklist

Work through this before putting Kitchenary on the Play Store. Items marked
**blocker** must be done; Play (or TheMealDB) will reject or remove the app
without them.

## 1. TheMealDB (blocker)

- The free key `1` is for development and education only. TheMealDB's own
  pages say you must become a supporter to release publicly on an app store,
  and that free users may not publish to app stores. Sign up as a supporter
  (see themealdb.com/api.php), get your upgraded key, and **re-read their Terms
  of Service the day you submit** in case they changed.
- Build with the key, never commit it:
  `flutter build appbundle --release --dart-define=MEALDB_API_KEY=YOUR_KEY`
  (the key still ends up inside the app, which is normal for this kind of key).
- Credit TheMealDB as the data source inside the app (their terms ask for
  this). The About and Privacy screens already name it; confirm it is clearly
  visible, for example under Profile.
- Recipe photos and text belong to TheMealDB and its contributors. Do not
  pass them off as your own and do not re-sell them.

## 2. Legal and contact (blocker)

- Replace `AppConstants.supportEmail` with an inbox you read.
- Have the Privacy Policy and Terms (`lib/core/constants/legal_content.dart`)
  reviewed by a lawyer.
- Publish the Privacy Policy at a public web address (for example GitHub
  Pages) and paste that address into Play Console. The in-app copy alone is
  not enough.
- Re-read the policy against the final app: storage, notifications, the
  grocery store links, TheMealDB requests.

## 3. App identity

- Application ID is `app.kitchenary.kitchenary` (from `flutter create --org`).
  It can never change after the first upload. Change it now if you want
  another one (android/app/build.gradle.kts and the Kotlin package folder).
- Check the launcher icon on a real phone. The files are in `assets/images/`;
  if the default Flutter icon still shows, add `flutter_launcher_icons`.
- Version lives in `pubspec.yaml` (`1.0.0+1`). The number after `+` must go up
  by one for every upload. Keep `AppConstants.appVersion` in step.

## 4. Signing (blocker)

1. Create a keystore once and **back it up in two places** (losing it means
   you cannot update the app):
   `keytool -genkey -v -keystore kitchenary-upload.jks -keyalg RSA -keysize 2048 -validity 10000 -alias upload`
2. Put it outside the repo. Create `android/key.properties` (gitignored):
   `storePassword=...`, `keyPassword=...`, `keyAlias=upload`,
   `storeFile=C:/path/to/kitchenary-upload.jks`
3. Make `android/app/build.gradle.kts` read `key.properties` and use a
   `release` signing config instead of the debug one (see the Flutter docs,
   "Build and release an Android app").
4. Turn on Play App Signing when creating the app in Play Console.
5. Check `.gitignore` covers `key.properties` and `*.jks`.

## 5. Permissions (decide)

- `SCHEDULE_EXACT_ALARM` (precise timer alerts). Play restricts exact alarms
  to apps whose main purpose is alarms or calendars and asks you to declare
  the reason. Kitchenary is a recipe app, so this may be questioned. Options:
  declare it honestly (cooking timers), or drop it and accept that timers can
  ring a little late when the phone is dozing. The code already falls back to
  the less precise alarm if exact ones are refused.
- `POST_NOTIFICATIONS`, `VIBRATE`, `RECEIVE_BOOT_COMPLETED`, `INTERNET`:
  fine, and listed in the privacy policy.
- Consider `android:allowBackup="false"` if you do not want Google backups
  restoring saved recipes onto a new phone.

## 6. Test the release build (not just debug)

Run `flutter build apk --release` and install it on your phone, then check:

- Home feed, search, random recipe, details, saved, history, own recipes.
- Cooking mode, timers (app open, app in background, screen off), alarm sound.
- Shopping list, guided order, each of the four store links (their address
  formats are not confirmed, see `grocery_stores.dart`).
- Airplane mode: feeds and recipes you opened before should still load, with
  the offline notice on Home.
- Dark mode on every screen, large phone text (Settings > Font size), a small
  phone. Rotate once.
- Erase my data, then reopen the app.

## 7. Play Console

- Developer account (one-time fee). New personal accounts may be required to
  run a closed test with a minimum number of testers for a minimum number of
  days before production: check the current rule in Play Console.
- App details: name `Kitchenary`, category Food & Drink, no ads, free.
- Store listing: short description (80 characters), full description (4000),
  icon 512x512, feature graphic 1024x500, at least two phone screenshots.
- Content rating questionnaire, target audience (choose adults/general, not
  children, to stay out of the Families policy).
- Data safety form: the app has no accounts and no analytics. Items typed into
  the search box are sent to TheMealDB, and a grocery item name is sent to the
  store you pick. Read Google's definitions of "collected" and "shared" and
  answer for those two cases; if unsure, ask Play support.
- Target API level: Play's minimum rises every year. If Play Console warns
  about it, update Flutter and rebuild.
- Upload the `.aab` from `build/app/outputs/bundle/release/`.

## 8. After launch

- Watch Play Console crash and ANR reports.
- Re-check the grocery store links every few months.
