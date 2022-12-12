import 'package:dio/dio.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:wuzzufy/providers/BaseProvider.dart';
import 'package:wuzzufy/utils/Config.dart';

class NotificationsProvider extends BaseProvider {
  String allTopics = "all";
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  NotificationsProvider(context) {
    FirebaseMessaging.instance.subscribeToTopic(allTopics);
    addFcmToken();
  }


  init(context) async {

    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('ic_notifications');
    final InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);

    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onSelectNotification: (payload) async {
        selectNotification(context, payload);
      },
    );

    // get message when app opened from terminated
    FirebaseMessaging.instance.getInitialMessage().then((value) {
      if (value != null) {
        //EasyLoading.showInfo(value.notification.title + " test");
        goToJob(context, value.data["id"]);
      }
    });

    // get message on foreground and send notification
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print("new message : " + message.toString());
      showNotification(message.notification.title, message.notification.body,
          message.data["id"]);
    });

    // get message from app opened from background
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      //EasyLoading.showInfo(message.notification.title);
      print("app opend : " + message.notification.title);
      print(message.data);

      goToJob(context, message.data["id"]);
    });

    FirebaseMessaging.onBackgroundMessage(myBackgroundMessageHandler);
  }

  showNotification(title, body, id) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails('0', 'fcm', 'fcm notifications',
            importance: Importance.max,
            priority: Priority.high,
            showWhen: false);

    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin
        .show(0, title, body, platformChannelSpecifics, payload: id);
  }

  Future selectNotification(context, String payload) async {
    //EasyLoading.showInfo(payload);
    goToJob(context, payload);
  }
}

Future<void> myBackgroundMessageHandler(RemoteMessage message) async {
  print("background : " + message.notification.title);
}
