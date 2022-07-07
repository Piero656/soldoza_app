import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';
// import 'firebase_options.dart';

class PushNotificationService {
  static FirebaseMessaging messaging = FirebaseMessaging.instance;

  static String? token;

  static Future _backgroundHandle(RemoteMessage message) async {
    print('background:  ${message.messageId}  ');

    sendNotification(
        title: message.notification?.title ?? 'No Tittle',
        body: message.notification?.body ?? 'No body');
  }

  static Future _onMessagedHandle(RemoteMessage message) async {
    print('_onMessagedHandle:  ${message.messageId}  ');

    sendNotification(
        title: message.notification?.title ?? 'No Tittle',
        body: message.notification?.body ?? 'No body');
  }

  static Future _onOpenApp(RemoteMessage message) async {
    print('_onOpenApp:  ${message.messageId}  ');
  }

  static Future initializeApp() async {
    await Firebase.initializeApp();
    token = await FirebaseMessaging.instance.getToken();

    FirebaseMessaging.onBackgroundMessage(_backgroundHandle);
    FirebaseMessaging.onMessage.listen(_onMessagedHandle);
    FirebaseMessaging.onMessageOpenedApp.listen(_onOpenApp);
  }

  static void sendNotification({String? title, String? body}) async {
    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
        FlutterLocalNotificationsPlugin();

    //Set the settings for various platform
    // initialise the plugin. app_icon needs to be a added as a drawable resource to the Android head project
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('codex_logo');
    const IOSInitializationSettings initializationSettingsIOS =
        IOSInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );
    const LinuxInitializationSettings initializationSettingsLinux =
        LinuxInitializationSettings(
      defaultActionName: 'hello',
    );
    const InitializationSettings initializationSettings =
        InitializationSettings(
            android: initializationSettingsAndroid,
            iOS: initializationSettingsIOS,
            linux: initializationSettingsLinux);
    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
    );

    const AndroidNotificationChannel channel = AndroidNotificationChannel(
        'channel id', 'channel name',
        description: "channel description",
        enableLights: true,
        enableVibration: true,
        importance: Importance.max);

    int id = await getNotiId();

    flutterLocalNotificationsPlugin.show(
      id,
      title,
      body,
      NotificationDetails(
        android: AndroidNotificationDetails(channel.id, channel.name,
            channelDescription: channel.description,
            icon: 'codex_logo',
            enableLights: channel.enableLights,
            enableVibration: channel.enableVibration,
            importance: Importance.max),
      ),
    );
  }

  static Future<int> getNotiId() async {
    final Future<SharedPreferences> prefs = SharedPreferences.getInstance();

    final SharedPreferences myPrefs = await prefs;

    int? notiId = myPrefs.getInt('notiId');

    if (notiId == null) {
      notiId = 0;
      await myPrefs.setInt('notiId', notiId);
    }
    notiId++;
    await myPrefs.setInt('notiId', notiId);
    return notiId;
  }
}
