import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:now_ui_flutter/api.dart';
import 'package:now_ui_flutter/screens/login.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class Logout extends StatefulWidget {
  const Logout({Key key}) : super(key: key);

  @override
  State<Logout> createState() => _LogoutState();
}

class _LogoutState extends State<Logout> {
  String token = '';
  String baseUrl = api.url;
  @override
  void initState() {
    super.initState();
    getCredential();
  }

  void getCredential() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    token = prefs.getString('login');
    logout();
  }

  void logout() async {
    SharedPreferences tenant = await SharedPreferences.getInstance();
    String tenantID = tenant.getString('tenantID');
    await http.post(
      Uri.parse('$baseUrl/api/$tenantID/logout'),
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer ${token}',
      },
    );

    SharedPreferences pref = await SharedPreferences.getInstance();
    /* SharedPreferences id_user = await SharedPreferences.getInstance();
    SharedPreferences id_trabajo = await SharedPreferences.getInstance(); */
    await pref.clear();
    await tenant.clear();
    /* await id_user.clear();
    await id_trabajo.clear(); */
    Navigator.pushNamed(context, '/buscador');
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
