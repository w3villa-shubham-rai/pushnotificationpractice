



import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:pushnotification_functionality/firebase_options.dart';
import 'package:pushnotification_functionality/home_screen.dart';
import 'package:pushnotification_functionality/notification_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
);
 
NotificationService notificationService = NotificationService();
FirebaseMessaging.onBackgroundMessage(notificationService.firebaseMessagingBackgroundHandler);

 await NotificationService.initialize();
 await NotificationService().getDeviceToken();
 
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
     NotificationService().firebaseInit( context);
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: HomeScreen(),
    );
  }
}

