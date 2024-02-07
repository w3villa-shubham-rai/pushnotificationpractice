import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:pushnotification_functionality/notification_service.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: TextButton(
          onPressed: () {
            NotificationService().getDeviceToken().then((value) async {
              var data = {
                //  'to':'ewIbkA8CTM-uORbELfJCvu:APA91bFPB-eKAwHHiXMQV2Z4VGyCSyuuvM6mRSTKcwEBfnyiZP--pjAjIqDaByl2qQ3gLzDokTa9dRgE9AFxv33K1OmSJyJj6QX2JHoELkXKh1fcXnrmryn-wzF5N6VZ9phzhPGBxNhG',
                'to': value.toString(),
                'priority' : 'high' ,
                'notification': {
                  'title': 'Kivo.ai',
                  'body': 'Please Update the app',
                },
                'data':{
                  'type':'message from Firebase',
                  'id':'99999',
                }
              };

              try {
                var response = await http.post(
                  Uri.parse('https://fcm.googleapis.com/fcm/send'),
                  body: jsonEncode(data),
                  headers: {
                    'Content-Type': 'application/json; charset=UTF-8',
                    'Authorization':'key=AAAAFsrl_7A:APA91bEiRiEpdjNk4-3QBJBKFflBGjgkVIOmdezlbukuDxqWdq-WIWHONkWHPJcgeZotaDWFWa_Ml5w6afWODZnKct0czBqpM-ZwfAM873vec1x464DPYL627XE9LSTo3Sq9qUDXFw3t'
                  },
                );

                if (response.statusCode == 200) {
                  print('Notification sent successfully');
                } else {
                  print(
                      'Failed to send notification: ${response.statusCode}');
                      print('Failed to send notification: ${response.statusCode}');
                     print('Response body: ${response.body}');
                }
              } catch (error) {
                print('Error sending notification: $error');
              }
            });
          },
          child: Text('Send Notification'),
        ),
      ),
    );
  }
}
