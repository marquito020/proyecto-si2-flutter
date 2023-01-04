import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:now_ui_flutter/screens/buscador.dart';
import 'package:now_ui_flutter/screens/creditos.dart';
import 'package:now_ui_flutter/screens/login.dart';
import 'package:now_ui_flutter/screens/logout.dart';

// screens
import 'package:now_ui_flutter/screens/onboarding.dart';
import 'package:now_ui_flutter/screens/pro.dart';
import 'package:now_ui_flutter/screens/home.dart';
import 'package:now_ui_flutter/screens/profile.dart';
import 'package:now_ui_flutter/screens/settings.dart';
import 'package:now_ui_flutter/screens/register.dart';
import 'package:now_ui_flutter/screens/articles.dart';
import 'package:now_ui_flutter/screens/components.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'firebase_options.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  await Firebase.initializeApp();

  print("Handling a background message: ${message.messageId}");
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  /* messagin */
  messaging.getToken().then((value) => print(value));
  /* Token Notification */
  SharedPreferences tokenNotifications = await SharedPreferences.getInstance();
  await tokenNotifications.setString('notification', await messaging.getToken());

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    print('Got a message whilst in the foreground!');
    print('Message data: ${message.data}');

    if (message.notification != null) {
      print('Message also contained a notification: ${message.notification}');
    }
  });
  runApp(MyApp());
}
/* void main() => runApp(MyApp()); */

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Now UI PRO Flutter',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(fontFamily: 'Montserrat'),
        initialRoute: '/buscador',
        routes: <String, WidgetBuilder>{
          '/home': (BuildContext context) => new Home(),
          '/login': (BuildContext context) => new Login(),
          '/logout': (BuildContext context) => new Logout(),
          '/buscador': (BuildContext context) => new Buscador(),
          '/creditos': (BuildContext context) => new Creditos(),
          '/settings': (BuildContext context) => new Settings(),
          "/onboarding": (BuildContext context) => new Onboarding(),
          "/pro": (BuildContext context) => new Pro(),
          "/profile": (BuildContext context) => new Profile(),
          "/articles": (BuildContext context) => new Articles(),
          "/components": (BuildContext context) => new Components(),
          "/account": (BuildContext context) => new Register(),
        });
  }
}
