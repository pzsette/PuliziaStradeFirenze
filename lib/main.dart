import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:provider/provider.dart';
import 'package:pulizia_strade/Providers/ConnectivityProvider.dart';
import 'package:pulizia_strade/Providers/DataProvider.dart';
import 'package:pulizia_strade/Providers/ParkProvider.dart';
import 'package:pulizia_strade/Providers/SettingsProvider.dart';
import 'package:pulizia_strade/Repository/favourites_db.dart';
import 'package:pulizia_strade/Repository/shared_preferences.dart';
import 'package:pulizia_strade/home.dart';
import 'dart:io' show Platform;

import 'CustomWidgets/NotificationBadge.dart';
import 'Models/PushNotification.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await sharedPrefs.init();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<DataProvider>(
            create: (context) => DataProvider(DBHelper.instance), lazy: false),
        ChangeNotifierProvider<ParkProvider>(
            create: (context) => ParkProvider(), lazy: false),
        ChangeNotifierProvider(create: (context) => ConnectivityProvider()),
        ChangeNotifierProvider<SettingsProvider>(
            create: (context) => SettingsProvider()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  FirebaseMessaging _firebaseMessaging;

  int _totalNotifications;
  PushNotification _notificationInfo;

  @override
  void initState() {
    registerNotification();
    checkForInitialMessage();
    super.initState();
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return OverlaySupport(
      child: MaterialApp(
        theme: ThemeData(
            primarySwatch: Colors.blue,
            scaffoldBackgroundColor: Colors.white,
            canvasColor: Colors.transparent),
        home: Home(),
      ),
    );
  }

  void registerNotification() async {
    // 1. Initialize the Firebase app
    await Firebase.initializeApp();

    print("ehiehei");
    // 2. Instantiate Firebase Messaging
    _firebaseMessaging = FirebaseMessaging.instance;

    // 3. On iOS, this helps to take the user permissions
    NotificationSettings settings = await _firebaseMessaging.requestPermission(
      alert: true,
      badge: true,
      provisional: false,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        if (_notificationInfo != null) {
          // For displaying the notification as an overlay
          showSimpleNotification(
            Text(_notificationInfo.title),
            leading: NotificationBadge(totalNotifications: _totalNotifications),
            subtitle: Text(_notificationInfo.body),
            background: Colors.cyan.shade700,
            duration: Duration(seconds: 2),
          );
        }
      });
    } else {
      print('User declined or has not accepted permission');
    }
  }

  // For handling notification when the app is in terminated state
  checkForInitialMessage() async {
    await Firebase.initializeApp();
    RemoteMessage initialMessage =
        await FirebaseMessaging.instance.getInitialMessage();
    if (initialMessage != null) {
      PushNotification notification = PushNotification(
        title: initialMessage.notification?.title,
        body: initialMessage.notification?.body,
      );
      setState(() {
        _notificationInfo = notification;
        _totalNotifications++;
      });
    }
  }
}
