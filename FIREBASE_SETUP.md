# Firebase Setup Guide for MoodThread

This guide will help you set up Firebase for the MoodThread app.

## Prerequisites

1. A Google account
2. Flutter SDK installed
3. Android Studio / Xcode for platform-specific setup

## Step 1: Create Firebase Project

1. Go to [Firebase Console](https://console.firebase.google.com/)
2. Click "Create a project"
3. Enter project name: `MoodThread`
4. Enable Google Analytics (recommended)
5. Choose analytics account or create new one
6. Click "Create project"

## Step 2: Add Android App

1. In Firebase console, click the Android icon
2. Enter Android package name: `com.example.moodthread`
3. Enter app nickname: `MoodThread`
4. Click "Register app"
5. Download `google-services.json`
6. Place `google-services.json` in `android/app/` directory

## Step 3: Add iOS App

1. In Firebase console, click the iOS icon
2. Enter iOS bundle ID: `com.example.moodthread`
3. Enter app nickname: `MoodThread`
4. Click "Register app"
5. Download `GoogleService-Info.plist`
6. Place `GoogleService-Info.plist` in `ios/Runner/` directory

## Step 4: Enable Authentication

1. In Firebase console, go to "Authentication"
2. Click "Get started"
3. Enable "Email/Password" sign-in method
4. Enable "Anonymous" sign-in method
5. Click "Save"

## Step 5: Enable Firestore Database

1. In Firebase console, go to "Firestore Database"
2. Click "Create database"
3. Choose "Start in test mode" (for development)
4. Select a location close to your users
5. Click "Done"

## Step 6: Enable Cloud Messaging

1. In Firebase console, go to "Cloud Messaging"
2. Click "Get started"
3. Note down the Server key (you'll need this for backend)

## Step 7: Set Up Security Rules

In Firestore Database > Rules, add these security rules:

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // Users can read/write their own data
    match /users/{userId} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
    }
    
    // Anyone can read prompts
    match /prompts/{promptId} {
      allow read: if true;
      allow write: if false; // Only admin can create prompts
    }
    
    // Users can create responses, read all responses
    match /thread_responses/{responseId} {
      allow read: if true;
      allow create: if request.auth != null;
      allow update: if false; // No editing responses
      allow delete: if false; // No deleting responses
    }
  }
}
```

## Step 8: Create Sample Data

After setting up the app, you can create sample prompts using the `createSamplePrompts()` method in `ThreadService`.

## Step 9: Test the Setup

1. Run `flutter pub get`
2. Ensure all Firebase dependencies are resolved
3. Run the app on a device/emulator
4. Test authentication flow
5. Test creating and reading data

## Troubleshooting

### Common Issues

1. **Build errors**: Ensure `google-services.json` and `GoogleService-Info.plist` are in correct locations
2. **Authentication errors**: Check if Email/Password and Anonymous auth are enabled
3. **Database errors**: Verify Firestore rules and database location
4. **Notification errors**: Check FCM configuration and device permissions

### Platform-Specific Issues

#### Android
- Ensure `minSdkVersion` is at least 21
- Check that `google-services.json` is in `android/app/`
- Verify Google Services plugin is applied in `build.gradle`

#### iOS
- Ensure `GoogleService-Info.plist` is in `ios/Runner/`
- Check that Firebase pods are properly installed
- Verify minimum iOS version is 12.0

## Next Steps

1. Set up Firebase Functions for automated prompt generation
2. Configure Cloud Functions for daily prompt rotation
3. Set up analytics events for user engagement
4. Configure crashlytics for error reporting

## Security Considerations

1. **Production Rules**: Update Firestore rules for production use
2. **API Keys**: Never commit Firebase config files to public repositories
3. **User Data**: Implement proper data retention policies
4. **Authentication**: Consider additional security measures for production

## Support

- [Firebase Documentation](https://firebase.google.com/docs)
- [Flutter Firebase Plugin](https://firebase.flutter.dev/)
- [Firebase Console](https://console.firebase.google.com/)
