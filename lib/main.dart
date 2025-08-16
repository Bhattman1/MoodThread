import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:moodthread/services/auth_service.dart';
// import 'package:moodthread/services/notification_service.dart';
import 'package:moodthread/screens/splash_screen.dart';
import 'package:moodthread/utils/app_theme.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:moodthread/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // TODO: Re-enable Firebase after fixing the white screen issue
  // Initialize Firebase
  // await Firebase.initializeApp(
  //   options: DefaultFirebaseOptions.currentPlatform,
  // );
  
  // TODO: Re-enable notification service after fixing the white screen issue
  // Initialize notification service
  // await NotificationService().initialize();
  
  runApp(const MoodThreadApp());
}

class MoodThreadApp extends StatelessWidget {
  const MoodThreadApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthService()),
      ],
      child: MaterialApp(
        title: 'MoodThread',
        theme: AppTheme.lightTheme,
        home: const SplashScreen(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
