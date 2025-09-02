<div align="center">

# Planner 🏋️‍♂️

Personal fitness & workout planning app built with Flutter.

</div>

## ✨ Overview
Planner helps users browse categorized exercises, mark favorites, create custom exercise categories, and receive a daily reminder notification to stay consistent. Firebase Authentication powers user accounts and favorites sync; all other logic is handled locally with Provider for state management.

## 🚀 Features
- **Multi-platform Authentication** via Firebase Auth:
  - Email / password authentication
  - Google Sign-In integration
  - Facebook Login support
- **Beautiful Glassmorphic UI** with enhanced social authentication buttons
- Exercise library with images & (external) video links
- Favorites (persisted per user in Firebase Realtime Database endpoints via REST)
- Custom exercise categories & user‑defined exercises
- Daily reminder local notification (time selectable, exact alarm toggle, timezone aware, fallback safety timer)
- Light / dark theme (via theme provider)
- **Enhanced Error Handling** for network operations and authentication
- Simple, maintainable Provider architecture

## 🧩 Architecture
Layered by responsibility:
- `models/` Plain Dart data classes (e.g. Exercise, Category, User)
- `data.dart` Static seed data (exercise catalog, categories, scheduled maps)
- `providers/` Business & persistence logic (favorites sync, custom exercises, notifications)
- `screens/` UI pages (auth, exercise lists, detail, favorites, settings, notification settings, etc.)
- `widgets/` Reusable UI components

State management: [provider](https://pub.dev/packages/provider). Each provider exposes change‑notifier backed state; `MultiProvider` wires them up in `main.dart`.

Notifications: Implemented with `flutter_local_notifications` + `timezone`. A single persisted daily reminder is scheduled; a lightweight fallback periodic check ensures the notification still fires if OEM scheduling is throttled.

## 🔔 Daily Reminder Notification
Implemented in `providers/notification_api.dart`:
- Uses timezone initialization for correct local scheduling.
- Persists selected hour/minute & enabled flag via `SharedPreferences`.
- Allows toggling "Exact" mode (Android exact alarm permission) when you need stricter timing.
- Fallback foreground timer re-schedules if a day passes without a fire event.

### Changing / Disabling
Visit the Notification Settings screen: pick a time or toggle off. Disabling cancels the scheduled zoned alarm and clears persistence keys.

## 🎥 Exercise Media Strategy
Currently each exercise stores a `videoUrl` (YouTube). The detail screen shows an image; tapping a "play" (future enhancement) could open an embedded player or local asset.

Planned improvements:
1. Replace external launch with in-app playback using `video_player` for self‑hosted MP4s or `youtube_player_flutter` for embedded YouTube (if licensing permits).
2. Optional offline mode: bundle short demo clips (compressed MP4 / WebM) under `assets/videos/` and reference them via an enum / path map.
3. Add a lightweight caching layer (e.g. `flutter_cache_manager`) for remote media.

Compliance note: Ensure you have rights to redistribute any hosted videos. For public YouTube content you generally should not download and redistribute; prefer embedding with the official player.

## 🗄️ Data Persistence
- Favorites & custom exercises sync per user (Firebase Realtime DB REST endpoints – logic inside providers)
- Local notification preferences & reminder time (SharedPreferences)
- Static exercise list bootstraps the catalog; could be replaced by backend API later.

## 🛠️ Tech Stack
| Concern | Package / Tool |
|---------|----------------|
| Core UI | Flutter (Material) with Glassmorphic Design |
| State | provider |
| Auth | firebase_auth, google_sign_in, flutter_facebook_auth |
| Backend Init | firebase_core |
| HTTP | http |
| Local Storage | shared_preferences |
| Notifications | flutter_local_notifications, timezone |
| Media | video_player, url_launcher (current) |
| Web Views | flutter_inappwebview (future embedded player options) |

## 📦 Project Setup
1. Prerequisites: Flutter SDK (>= 3.8.0), Dart, Android Studio / Xcode toolchains.
2. Clone repo:
	`git clone <your-fork-url>`
3. Install dependencies:
	`flutter pub get`
4. **Firebase setup:**
	- Create Firebase project
	- Enable Email/Password auth
	- **Enable Google Sign-In** in Authentication > Sign-in method
	- **Enable Facebook Login** in Authentication > Sign-in method
	- Add Android app: download `google-services.json` into `android/app/`
	- (If adding iOS) add `GoogleService-Info.plist` to `ios/Runner/`
5. **Google Sign-In setup:**
	- Get SHA-1 fingerprint: `./gradlew signingReport` (from android folder)
	- Add SHA-1 to Firebase Console > Project Settings > Your Apps
6. **Facebook Login setup:**
	- Create Facebook App in [Facebook Developers Console](https://developers.facebook.com/)
	- Configure Facebook Login product with your package name and SHA-1
	- Update `android/app/src/main/res/values/strings.xml` with your Facebook App ID and Client Token
	- Add Facebook App ID and App Secret to Firebase Console
7. Run:
	`flutter run`

### Environment Notes
No additional `.env` file required. All Firebase config comes from the generated options file (`firebase_options.dart`) via FlutterFire CLI or manual config.

## 🧪 Testing
Add widget / provider tests under `test/`. (Currently minimal.) Suggested areas:
- Notification scheduling logic (time calculation)
- Favorites toggle / persistence
- Custom exercise CRUD

## 🔐 Security & Privacy
- **Multi-factor Authentication** supported via Firebase Auth with social providers
- **Google Sign-In** uses secure OAuth 2.0 flow with SHA-1 fingerprint validation
- **Facebook Login** implements secure OAuth with App Secret validation
- Exercise and favorites data is lightweight; all sensitive authentication is handled by trusted providers
- **Enhanced error handling** prevents exposure of internal system details

## 🚧 Roadmap / Future Ideas
- In-app embedded video player screen (no external app jump)
- Offline media cache / downloadable packs
- **Apple Sign-In integration** for iOS users
- Progress tracking & workout plans history
- Multiple reminders & custom schedules
- **Biometric authentication** support
- Localization / i18n
- Unit & widget test coverage expansion
- **Enhanced UI animations** and micro-interactions
- Dark mode refinements & adaptive layouts

## 🗂️ Repository Structure (excerpt)
```
lib/
  data.dart            # Seed exercises & categories
  main.dart            # App bootstrap, providers, Firebase init
  models/              # Data classes
  providers/           # Business logic (notifications, favorites, custom)
  screens/             # UI screens
  widgets/             # Shared UI components
```

## 🤝 Contributing
1. Fork & create feature branch
2. Keep changes focused / small
3. Run `flutter analyze` & ensure no new warnings
4. Open PR describing rationale & screenshots for UI changes

## 📝 License
Add your chosen license (e.g. MIT) here. Example:
```
MIT License © 2024 Your Name
```

## 📄 Changelog
Maintain notable changes in a `CHANGELOG.md` once versioning begins.

## ❓ FAQ
**Q: Why are notifications local only?**  
A: Simpler, privacy friendly, and reliable for a single daily reminder without server infrastructure.

**Q: How do I change the reminder time?**  
A: Open Notification Settings screen, tap the time picker, choose new time.

**Q: Videos open externally; can I embed them?**  
A: Yes—replace the launcher screen with a `youtube_player_flutter` widget or host local MP4s and use `video_player`.

**Q: I'm getting "Google Sign-In failed" errors. What should I do?**  
A: Ensure you've added the correct SHA-1 fingerprint to Firebase Console. Run `./gradlew signingReport` from the android folder to get your fingerprint.

**Q: Facebook Login shows "App not active" error?**  
A: Your Facebook app is in development mode. Add yourself as a test user or developer in Facebook Developers Console, or make your app live for production use.

**Q: How do I get my SHA-1 fingerprint?**  
A: Navigate to the android folder and run `./gradlew signingReport`. Look for the SHA1 value in the output.

---
Feel free to customize this README further to reflect branding or deployment specifics.
