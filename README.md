# MoodThread

**"BeReal for emotions — one sentence, once a day"**

A minimalist mobile app that uses the same core mechanic as BeReal, but for sharing feelings instead of photos.

## 🧠 Key Concept

- **BeReal**: take a photo when the app says so
- **MoodThread**: say how you feel when the app asks you
- **Both**: one shot per day, no edits, no feed scrolling, no likes — just honest signal

## 🖼 Core Features

### 1. Daily Prompt System
- Every 24h, app sends a push notification
- User has 1 text box to respond (limit: 1 sentence / 200 characters)
- After submitting, user cannot edit or delete
- Must post to unlock the thread (just like BeReal)

### 2. Thread Feed
- After submitting, user sees a scrollable feed of everyone else's answers
- Posts are anonymous by default (or toggle to show username)
- Chronologically ordered
- No likes, comments, DMs — optionally allow anonymous "same" reactions

### 3. Design System
- Minimal and soft color palette
- System fonts only (SF Pro for iOS, Roboto for Android)
- Ultra-simple, 1 action per screen, frictionless UX

### 4. User System
- Anonymous or email login via Firebase Auth
- Optional username + avatar (emoji or initials)
- Daily entries tied to unique user ID

## 🛠 Tech Stack

- **Frontend**: Flutter (cross-platform)
- **Backend**: Firebase (Firestore for data, Functions for prompts + reset logic)
- **Auth**: Firebase Auth (anonymous + email)
- **Push Notifications**: Firebase Cloud Messaging
- **Prompt Logic**: Daily prompt selected from backend pool (curated)

## 🚀 Getting Started

### Prerequisites
- Flutter SDK (latest stable version)
- Dart SDK
- Firebase project setup
- iOS Simulator / Android Emulator or physical device

### Installation

1. Clone the repository
2. Install dependencies:
   ```bash
   flutter pub get
   ```

3. Configure Firebase:
   - Add `google-services.json` (Android) and `GoogleService-Info.plist` (iOS)
   - Update Firebase configuration in `lib/services/firebase_service.dart`

4. Run the app:
   ```bash
   flutter run
   ```

## 📱 Key Behaviors

- ❗ You must post to see others
- 🧠 You only get one post per day
- 🕰️ Once time expires, the thread closes
- 🔄 Every day is a reset — new prompt, new thread
- 📱 Built for daily emotional connection, not scrolling addiction

## 💬 Example Prompts

- "What's keeping you going?"
- "What are you trying to accept?"
- "What do you wish someone knew?"
- "How would you describe today in one sentence?"
- "What are you pretending is fine?"

## ✅ Success Criteria

You get a ping → you write a sentence → you unlock the emotional thread of the world → you feel seen

**No likes. No feeds. Just truth — once a day.**