import 'package:flutter/material.dart';
import 'package:now_ui_flutter/screens/buscador.dart';
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

void main() => runApp(MyApp());

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
