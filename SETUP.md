# Fitenne Setup

Fitenne is a Flutter fitness app with Firebase Auth (email verification required), Firestore calorie history, workout plans, and Firebase AI Logic (Gemini) for food analysis and chat.

## Prerequisites

- Flutter SDK 3.41+
- Firebase CLI: `npx -y firebase-tools@latest login`
- FlutterFire CLI: `dart pub global activate flutterfire_cli`

## 1. Create or select a Firebase project

```powershell
npx -y firebase-tools@latest projects:create fitenne-app --display-name "Fitenne"
npx -y firebase-tools@latest use fitenne-app
```

Or use an existing project:

```powershell
npx -y firebase-tools@latest use YOUR_PROJECT_ID
```

## 2. Register Android and iOS apps

Bundle IDs used by this project:

- Android: `fitness.app`
- iOS: `fitness-app-60844`

Configure FlutterFire (generates `lib/firebase_options.dart` and platform config files):

```powershell
cd fitenne
flutterfire configure
```

## 3. Enable Firebase services

```powershell
npx -y firebase-tools@latest init ailogic
npx -y firebase-tools@latest deploy --only auth,firestore
```

This enables:

- Email/password auth
- Firestore rules in `firestore.rules`
- Firebase AI Logic (Gemini Developer API)

## 4. Run the app

```powershell
cd fitenne
flutter pub get
flutter run
```

For iOS, run `pod install` inside `ios/` on macOS before building.

## Features

| Tab | Description |
|-----|-------------|
| **Calories** | Describe meals; Gemini estimates calories and saves to Firestore |
| **Exercises** | Weekly gym/home plans with day-of-week scheduling |
| **History** | Past days grouped with total calories per day |
| **AI Coach** | Floating chat popup powered by Firebase AI Logic |

## Auth flow

1. User signs up with email/password
2. Verification email is sent; user is signed out
3. User verifies email via link
4. User signs in (blocked until `emailVerified == true`)

## Security notes

- Firestore rules require verified email (`request.auth.token.email_verified`)
- For production, enable [Firebase App Check](https://firebase.google.com/docs/app-check) before shipping AI features

## Troubleshooting

- **`PERMISSION_DENIED` on AI calls**: Run `npx -y firebase-tools@latest init ailogic`
- **Firestore permission denied**: Deploy rules with `npx -y firebase-tools@latest deploy --only firestore:rules`
- **Android build errors**: Ensure `google-services.json` exists in `android/app/`
- **iOS build errors**: Ensure `GoogleService-Info.plist` is linked in Xcode Runner target
