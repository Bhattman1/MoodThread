# MoodThread Project Structure

This document provides an overview of the MoodThread Flutter project structure and architecture.

## 📁 Project Overview

```
MoodThread/
├── android/                 # Android-specific configuration
├── ios/                    # iOS-specific configuration
├── lib/                    # Main Flutter source code
├── assets/                 # Images, icons, and fonts
├── test/                   # Unit and widget tests
├── pubspec.yaml            # Flutter dependencies
├── README.md               # Project documentation
├── FIREBASE_SETUP.md       # Firebase setup guide
└── PROJECT_STRUCTURE.md    # This file
```

## 🏗️ Architecture

MoodThread follows a **Service-Oriented Architecture** with **Provider** for state management:

```
┌─────────────────┐    ┌─────────────────┐    ┌─────────────────┐
│   UI Layer      │    │  Service Layer  │    │  Data Layer     │
│   (Screens)     │◄──►│   (Services)    │◄──►│   (Firebase)    │
└─────────────────┘    └─────────────────┘    └─────────────────┘
         │                       │                       │
         │                       │                       │
         ▼                       ▼                       ▼
┌─────────────────┐    ┌─────────────────┐    ┌─────────────────┐
│   Models        │    │   Providers     │    │   Utils         │
│   (Data)        │    │   (State)       │    │   (Helpers)     │
└─────────────────┘    └─────────────────┘    └─────────────────┘
```

## 📱 Core Features Implementation

### 1. Daily Prompt System
- **Location**: `lib/services/thread_service.dart`
- **Models**: `lib/models/prompt_model.dart`
- **UI**: `lib/screens/home_screen.dart`
- **Key Features**:
  - Daily prompt rotation
  - One response per day
  - Time-based thread closure

### 2. Authentication System
- **Location**: `lib/services/auth_service.dart`
- **Models**: `lib/models/user_model.dart`
- **UI**: `lib/screens/auth_screen.dart`
- **Key Features**:
  - Anonymous login
  - Email/password authentication
  - User profile management

### 3. Thread Feed
- **Location**: `lib/screens/thread_feed_screen.dart`
- **Models**: `lib/models/thread_response_model.dart`
- **Key Features**:
  - Real-time response feed
  - Anonymous by default
  - "Same" reactions

### 4. Notification System
- **Location**: `lib/services/notification_service.dart`
- **Key Features**:
  - Daily prompt reminders
  - Push notifications
  - Local notifications

## 🔧 Services Layer

### AuthService
- Handles user authentication
- Manages user sessions
- Provides user data management

### ThreadService
- Manages daily prompts
- Handles user responses
- Provides thread feed data

### NotificationService
- Manages push notifications
- Handles local notifications
- Configures FCM

### FirebaseService
- Firebase initialization
- Configuration management
- Helper methods

## 📊 Data Models

### UserModel
```dart
{
  id: String,
  email: String?,
  username: String?,
  avatar: String?,
  createdAt: DateTime,
  isAnonymous: bool,
  lastActive: DateTime?
}
```

### PromptModel
```dart
{
  id: String,
  text: String,
  date: DateTime,
  isActive: bool,
  responseCount: int,
  createdAt: DateTime
}
```

### ThreadResponseModel
```dart
{
  id: String,
  userId: String,
  promptId: String,
  response: String,
  createdAt: DateTime,
  isAnonymous: bool,
  username: String?,
  avatar: String?,
  sameCount: int
}
```

## 🎨 UI Components

### Screens
1. **SplashScreen**: App introduction and loading
2. **AuthScreen**: Authentication and registration
3. **HomeScreen**: Daily prompt and response input
4. **ThreadFeedScreen**: Community responses feed

### Design System
- **Location**: `lib/utils/app_theme.dart`
- **Colors**: Minimal and soft palette
- **Typography**: SF Pro Display (iOS), Roboto (Android)
- **Components**: Material Design 3 with custom styling

## 🔐 Security Features

### Authentication
- Firebase Auth integration
- Anonymous user support
- Secure user data storage

### Data Protection
- Firestore security rules
- User data isolation
- Anonymous response options

## 📱 Platform Support

### Android
- **Min SDK**: 21 (Android 5.0)
- **Target SDK**: Latest stable
- **Permissions**: Internet, Notifications, Wake Lock

### iOS
- **Min Version**: 12.0
- **Capabilities**: Push Notifications, Background Modes
- **Frameworks**: Firebase, UserNotifications

## 🚀 Getting Started

### Prerequisites
1. Flutter SDK (latest stable)
2. Firebase project setup
3. Android Studio / Xcode
4. Device or emulator

### Setup Steps
1. Clone the repository
2. Run `flutter pub get`
3. Configure Firebase (see `FIREBASE_SETUP.md`)
4. Add platform-specific config files
5. Run `flutter run`

## 🧪 Testing

### Test Structure
```
test/
├── unit/           # Unit tests
├── widget/         # Widget tests
└── integration/    # Integration tests
```

### Running Tests
```bash
# Unit tests
flutter test test/unit/

# Widget tests
flutter test test/widget/

# All tests
flutter test
```

## 📦 Dependencies

### Core Flutter
- `flutter`: Core Flutter framework
- `cupertino_icons`: iOS-style icons

### Firebase
- `firebase_core`: Firebase initialization
- `firebase_auth`: Authentication
- `cloud_firestore`: Database
- `firebase_messaging`: Push notifications
- `firebase_analytics`: Analytics

### State Management
- `provider`: State management solution

### UI & Navigation
- `flutter_local_notifications`: Local notifications

### Utilities
- `intl`: Internationalization
- `shared_preferences`: Local storage
- `permission_handler`: Permission management

## 🔄 State Management

### Provider Pattern
- **AuthService**: User authentication state
- **ThreadService**: Thread and prompt data
- **NotificationService**: Notification state

### State Flow
```
User Action → Service Method → State Update → UI Rebuild
```

## 📈 Performance Considerations

### Optimization Strategies
1. **Lazy Loading**: Load data on demand
2. **Caching**: Firestore offline persistence
3. **Image Optimization**: Efficient asset loading
4. **Memory Management**: Proper disposal of controllers

### Monitoring
- Firebase Analytics integration
- Performance profiling
- Memory usage tracking

## 🚀 Deployment

### Android
1. Build APK: `flutter build apk`
2. Build App Bundle: `flutter build appbundle`
3. Sign with release keystore
4. Upload to Google Play Console

### iOS
1. Build: `flutter build ios`
2. Archive in Xcode
3. Upload to App Store Connect

## 🔮 Future Enhancements

### Planned Features
1. **Monetization**: Premium subscription features
2. **Analytics**: Emotional insights and trends
3. **Social Features**: Close circle threads
4. **Customization**: Personal prompt preferences

### Technical Improvements
1. **Offline Support**: Enhanced offline capabilities
2. **Performance**: Optimized rendering and data loading
3. **Security**: Enhanced authentication and data protection
4. **Testing**: Comprehensive test coverage

## 📚 Resources

### Documentation
- [Flutter Documentation](https://flutter.dev/docs)
- [Firebase Documentation](https://firebase.google.com/docs)
- [Provider Package](https://pub.dev/packages/provider)

### Community
- [Flutter Community](https://flutter.dev/community)
- [Firebase Community](https://firebase.google.com/community)
- [Stack Overflow](https://stackoverflow.com/questions/tagged/flutter)

## 🤝 Contributing

### Development Guidelines
1. Follow Flutter best practices
2. Maintain consistent code style
3. Write comprehensive tests
4. Document new features
5. Follow semantic versioning

### Code Style
- Use meaningful variable names
- Add comments for complex logic
- Follow Flutter linting rules
- Maintain consistent formatting
