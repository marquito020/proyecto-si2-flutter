import 'dart:convert';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:now_ui_flutter/api.dart';

import 'package:now_ui_flutter/constants/Theme.dart';
import 'package:now_ui_flutter/screens/home.dart';

//widgets
import 'package:now_ui_flutter/widgets/navbar.dart';
import 'package:now_ui_flutter/widgets/input.dart';

import 'package:now_ui_flutter/widgets/drawer.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:http/http.dart' as http;

import 'package:now_ui_flutter/api.dart';

class Login extends StatefulWidget {
  const Login({Key key}) : super(key: key);
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  var emailController = TextEditingController();
  var passwordController = TextEditingController();

  String baseUrl = api.url;

  @override
  void initState() {
    super.initState();
    // checkLoginStatus();
    chechLoginStatus();
  }

  void chechLoginStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('login');
    if (token != null) {
      /* Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => Home()),
          (Route<dynamic> route) => false); */
      Navigator.pushNamed(context, '/home');
      /* Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => DashBoard())); */
    }
  }

  /* final double width = window.physicalSize.width;

  final double height = window.physicalSize.height; */

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        /* appBar: Navbar(
          transparent: true,
          title: "",
          reverseTextcolor: true,
        ),
        extendBodyBehindAppBar: true, */
        drawer: NowDrawer(currentPage: "Account"),
        body: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage("assets/imgs/onboarding-free.png"),
                      fit: BoxFit.cover)),
            ),
            SafeArea(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Center(
                        child: Text("Login",
                            style: TextStyle(
                                fontSize: 30,
                                fontWeight: FontWeight.w600,
                                color: Colors.white))),
                    SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: TextFormField(
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                        controller: emailController,
                        decoration: InputDecoration(
                            contentPadding: const EdgeInsets.all(8.0),
                            labelText: 'Correo',
                            labelStyle: TextStyle(color: Colors.white),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(32.0),
                              /* borderSide: BorderSide(
                                color: Colors.white,
                              ), */
                            ),
                            /* suffixIcon: Icon(Icons.email), */
                            prefixIcon: Icon(
                              Icons.email,
                              size: 20,
                              color: Colors.white,
                            )),
                      ),
                    ),
                    /* SizedBox(height: 20), */
                    Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: TextFormField(
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                          controller: passwordController,
                          obscureText: true,
                          decoration: InputDecoration(
                              contentPadding: const EdgeInsets.all(8.0),
                              labelText: 'Contraseña',
                              labelStyle: TextStyle(color: Colors.white),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(32.0),
                              ),
                              prefixIcon: Icon(Icons.lock,
                                  size: 20, color: Colors.white))),
                    ),
                    /* SizedBox(height: 20), */
                    OutlinedButton.icon(
                      style: OutlinedButton.styleFrom(
                        primary: Colors.white,
                        backgroundColor: NowUIColors.primary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(32.0),
                        ),
                      ),
                      onPressed: () {
                        login();
                      },
                      icon: Icon(Icons.login, color: Colors.white),
                      label: Text('Login',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          )),
                    ),
                  ],
                ),
              ),
            )
          ],
        ));
  }

  void login() async {
    SharedPreferences tenant = await SharedPreferences.getInstance();
    String tenantID = tenant.getString('tenantID');
    if (passwordController.text.isNotEmpty && emailController.text.isNotEmpty) {
      var response = await http.post(Uri.parse('$baseUrl/api/$tenantID/login'),
          body: ({
            "email": emailController.text,
            "password": passwordController.text,
          }));
      if (response.statusCode == 200) {
        final body = jsonDecode(response.body);
        /* print('Login Success ' + body["token"]); */
        /* ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Login Success ' + body["token"]),
        )); */
        /* ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Id User: ' + body["user"]["id"].toString()),
        )); */
        /* page Route */
        pageRoute(body);
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Invalid Credentials')));
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Please enter email and password')));
    }
  }

  void pageRoute(body) async {
    //Guardar el token en el dispositivo
    SharedPreferences prefs = await SharedPreferences.getInstance();
    /* SharedPreferences id_user = await SharedPreferences.getInstance(); */
    await prefs.setString('login', body["token"]);
    /* Guardar Token de notificacion */
    notification();
    /* await id_user.setInt('id', body["user"]["id"]); */
  }

  void notification() async {
    SharedPreferences tokenNotifications =
        await SharedPreferences.getInstance();
    String tokenNotification = tokenNotifications.getString('notification');
    SharedPreferences tenant = await SharedPreferences.getInstance();
    String tenantID = tenant.getString('tenantID');
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('login');
    var response = await http.post(
      Uri.parse('$baseUrl/api/$tenantID/notificacionToken'),
      body: ({
        "tokenNotification": tokenNotification.toString(),
      }),
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer ${token}',
      },
    );
    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);
      /* print('Login Success ' + body["token"]); */
      /* ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Login Success ' + body["token"]),
        )); */
      /* ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Id User: ' + body["user"]["id"].toString()),
        )); */
      /* page Route */
      /* pageRoute(body); */
      print(body);
      /* Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => Home()),
          (Route<dynamic> route) => false); */
      Navigator.pushNamed(context, '/home');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('No se guardo Token de notificacion')));
    }
  }
}
