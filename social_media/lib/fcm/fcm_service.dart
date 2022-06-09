import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

const localNotificationChannel = 'high_importance_channel';
const localNotificationChannelTitle = 'High Importance Channel';
const localNotifiacationChannelDescription =
    'This Channel is used for important notification';

class FCMService {
  static final FCMService _singleton = FCMService._internal();

  factory FCMService() {
    return _singleton;
  }

  FCMService._internal();

  ///Firebase Messaging Instance
  FirebaseMessaging messaging = FirebaseMessaging.instance;

  /// Android Notification Channel
  AndroidNotificationChannel channel = const AndroidNotificationChannel(
      localNotificationChannel, localNotificationChannelTitle,
      description: localNotifiacationChannelDescription,
      importance: Importance.max);

  /// Flutter Notification Plugin
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  /// Android Initializaion Settings
  AndroidInitializationSettings initializationSettingsAndroid =
      const AndroidInitializationSettings('ic_launcher');

  void listenForNotification() async {
    await requestNotificationPermissionForIOS();
    await turnOnIOSForegroundNotification();

    await initFlutterLocalNotification();
    await registerChannel();

    messaging
        .getToken()
        .then((fcmToken) => print('FCM TOKEN FOR DEVICE ====> $fcmToken'));

    FirebaseMessaging.onMessage.listen((remoteMessage) {
      print('FOREGROUND NOTIFICATION');
      RemoteNotification? notification = remoteMessage.notification;
      AndroidNotification? androidNotification =
          remoteMessage.notification?.android;

      if (notification != null && androidNotification != null) {
        flutterLocalNotificationsPlugin.show(
            notification.hashCode,
            notification.title,
            notification.body,
            NotificationDetails(
              android: AndroidNotificationDetails(channel.id, channel.name,
                  channelDescription: channel.description,
                  icon: androidNotification.smallIcon),
            ),
            payload: remoteMessage.data['post_id'].toString());
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((remoteMessage) {
      print('User Preesed Notificaion ${remoteMessage.data['post_id']}');
    });

    messaging.getInitialMessage().then((remoteMessage) {
      print('App Launch Notificaion ${remoteMessage?.data['post_id']}');
    });
  }

  Future requestNotificationPermissionForIOS() {
    return messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );
  }

  Future turnOnIOSForegroundNotification() {
    return messaging.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
  }

  Future initFlutterLocalNotification() {
    final InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: null,
      macOS: null,
    );

    return flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: (payLoad) {
      print('Local Notification Data =====> $payLoad');
    });
  }

  Future? registerChannel() {
    return flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);
  }
}
