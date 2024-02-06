
import 'dart:math';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService{

final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin=FlutterLocalNotificationsPlugin();



// ++++++++++++++++++++++++++++++++++++++++++intialize notification property here ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

 static Future<void> initialize() async{
   NotificationSettings settings= await FirebaseMessaging.instance.requestPermission();
   if(settings.authorizationStatus==AuthorizationStatus.authorized){
    debugPrint("Notification initialized+++++++++++++++++++++++++++++++++++++++++==");
   }
  }


// ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++get token for each device++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
// +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
String? token;
Future<String> getDeviceToken() async {
  token = await FirebaseMessaging.instance.getToken();
  if (token == null) {
    isTokenRefresh();
    throw Exception('Unable to get token');
  }
  else{
    debugPrint("token of device here ________________________________________________  $token");
    return token!;
  }
  
  
}
// +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++refresh token+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
// ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
void isTokenRefresh()async{
  FirebaseMessaging.instance.onTokenRefresh.listen((newToken) {
    debugPrint("Token refreshed: $newToken");
    token=newToken;
  });
}





Future<void>  firebaseInit()async{
  FirebaseMessaging.onMessage.listen((mesage) {

    debugPrint(mesage.notification!.title.toString());
    debugPrint(mesage.notification!.body.toString()); 
    initLocalNotification(mesage) ;
    showNotification(mesage);
  });
  
}


//+++++++++++++++++++++++++++++++++++++++++++ show notifiaction on screen++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
// ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++



void initLocalNotification( RemoteMessage message) async {
  print("Initializing local notifications...");

  var androidInitializationSettings = const AndroidInitializationSettings('@mipmap/ic_launcher');
  var iosInitializationSettings = const DarwinInitializationSettings();

  var initializationSettings = InitializationSettings(
    android: androidInitializationSettings,
    iOS: iosInitializationSettings,
  );

  await _flutterLocalNotificationsPlugin.initialize(
    initializationSettings,
    onDidReceiveNotificationResponse: (payload) {
      print("Received notification response: $payload");
      // You can add additional handling logic here if needed
    },
  );

  print("Local notifications initialized successfully.");
}




Future<void> showNotification(RemoteMessage message) async {
  // Create AndroidNotificationChannel
  AndroidNotificationChannel channel = AndroidNotificationChannel(
    Random.secure().nextInt(100000).toString(),
    "hight high",
    importance: Importance.max,
  );

  // Create AndroidNotificationDetails
  AndroidNotificationDetails androidNotificationDetails = AndroidNotificationDetails(
    channel.id.toString(),
    channel.name.toString(),
    channelDescription: 'your channel',
    importance: Importance.high,
    priority: Priority.high,
    ticker: 'ticker',
  );

  // Create DarwinNotificationDetails for iOS (no changes needed)
  DarwinNotificationDetails darwinNotificationDetails = const DarwinNotificationDetails(
    presentAlert: true,
    presentBadge: true,
    presentSound: true,
  );

  // Create NotificationDetails
  NotificationDetails notificationDetails = NotificationDetails(
    android: androidNotificationDetails,
    iOS: darwinNotificationDetails,
  );

  // Debug statements to verify values
  print("Channel ID: ${channel.id}");
  print("Channel Name: ${channel.name}");
  print("Notification Title: ${message.notification!.title}");
  print("Notification Body: ${message.notification!.body}");

  // Show notification using FlutterLocalNotificationsPlugin
  Future.delayed(Duration.zero, () {
    _flutterLocalNotificationsPlugin.show(
      0,
      message.notification!.title.toString(),
      message.notification!.body.toString(),
      notificationDetails,
    );
  });
}




}