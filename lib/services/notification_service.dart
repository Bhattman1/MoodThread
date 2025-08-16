import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:permission_handler/permission_handler.dart';

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin _localNotifications = FlutterLocalNotificationsPlugin();
  // final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  Future<void> initialize() async {
    // Request permissions
    await _requestPermissions();
    
    // Initialize local notifications
    await _initializeLocalNotifications();
    
    // TODO: Re-enable Firebase messaging after fixing the white screen issue
    // Initialize Firebase messaging
    // await _initializeFirebaseMessaging();
    
    // Schedule daily notification
    await _scheduleDailyNotification();
  }

  Future<void> _requestPermissions() async {
    // Request notification permissions
    final status = await Permission.notification.request();
    if (status.isGranted) {
      // TODO: Re-enable FCM permissions after fixing the white screen issue
      // Request FCM permissions
      // await _firebaseMessaging.requestPermission(
      //   alert: true,
      //   badge: true,
      //   sound: true,
      // );
    }
  }

  Future<void> _initializeLocalNotifications() async {
    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );
    
    const initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );
    
    await _localNotifications.initialize(initSettings);
  }

  Future<void> _initializeFirebaseMessaging() async {
    // Get FCM token
    // final token = await _firebaseMessaging.getToken();
    // if (token != null) {
    //   print('FCM Token: $token');
    //   // TODO: Send token to backend
    // }
    
    // Handle background messages
    // FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
    
    // Handle foreground messages
    // FirebaseMessaging.onMessage.listen(_handleForegroundMessage);
    
    // Handle notification taps
    // FirebaseMessaging.onMessageOpenedApp.listen(_handleNotificationTap);
  }

  Future<void> _scheduleDailyNotification() async {
    // Cancel existing notifications
    await _localNotifications.cancelAll();
    
    // Schedule daily notification at 9 AM
    const androidDetails = AndroidNotificationDetails(
      'daily_prompt',
      'Daily Prompt',
      channelDescription: 'Daily emotional prompt notifications',
      importance: Importance.high,
      priority: Priority.high,
    );
    
    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );
    
    const details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );
    
    // Schedule for 9 AM daily
    await _localNotifications.periodicallyShow(
      0,
      'Your thread is open',
      'Tap to share how you feel today',
      RepeatInterval.daily,
      details,
    );
  }

  Future<void> showDailyPromptNotification(String prompt) async {
    const androidDetails = AndroidNotificationDetails(
      'daily_prompt',
      'Daily Prompt',
      channelDescription: 'Daily emotional prompt notifications',
      importance: Importance.high,
      priority: Priority.high,
    );
    
    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );
    
    const details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );
    
    await _localNotifications.show(
      1,
      'Your thread is open',
      'Today\'s prompt: $prompt',
      details,
    );
  }

  void _handleForegroundMessage(dynamic message) {
    // TODO: Re-enable after fixing the white screen issue
    // Handle foreground messages
    // if (message.data['type'] == 'daily_prompt') {
    //   final prompt = message.data['prompt'] ?? 'How are you feeling today?';
    //   showDailyPromptNotification(prompt);
    // }
  }

  void _handleNotificationTap(dynamic message) {
    // TODO: Re-enable after fixing the white screen issue
    // Handle notification taps
    // if (message.data['type'] == 'daily_prompt') {
    //   // Navigate to prompt screen
    //   // TODO: Implement navigation
    // }
  }

  Future<String?> getFCMToken() async {
    // return await _firebaseMessaging.getToken();
    return null; // Temporarily return null
  }

  Future<void> subscribeToTopic(String topic) async {
    // await _firebaseMessaging.subscribeToTopic(topic);
  }

  Future<void> unsubscribeFromTopic(String topic) async {
    // await _firebaseMessaging.unsubscribeFromTopic(topic);
  }
}

// Background message handler
// TODO: Re-enable after fixing the white screen issue
// Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
//   // Handle background messages
//   if (message.data['type'] == 'daily_prompt') {
//     // Show local notification
//     final notificationService = NotificationService();
//     await notificationService.showDailyPromptNotification(
//       message.data['prompt'] ?? 'How are you feeling today?',
//     );
//   }
// }
