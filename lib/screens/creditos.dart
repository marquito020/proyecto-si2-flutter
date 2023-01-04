import 'dart:convert';
import 'dart:ui';

import 'package:flutter/material.dart';
/* api */
import 'package:flutter/material.dart';
import 'package:now_ui_flutter/api.dart';

import 'package:now_ui_flutter/constants/Theme.dart';

//widgets
import 'package:now_ui_flutter/widgets/navbar.dart';
import 'package:now_ui_flutter/widgets/card-horizontal.dart';
import 'package:now_ui_flutter/widgets/card-small.dart';
import 'package:now_ui_flutter/widgets/card-square.dart';
import 'package:now_ui_flutter/widgets/drawer.dart';
/* api */
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class Creditos extends StatefulWidget {
  @override
  State<Creditos> createState() => _CreditosState();
}

class _CreditosState extends State<Creditos> {
  List solicitudes = [];
  bool isLoading = false;
  String token;
  String baseUrl = api.url;

  @override
  void initState() {
    super.initState();
    /* this.fetchUser(); */
    this.getPerfil();
  }

  getPerfil() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    SharedPreferences tenant = await SharedPreferences.getInstance();
    String tenantID = tenant.getString('tenantID');
    token = prefs.getString('login');
    var responde = await http.get(
      Uri.parse('$baseUrl/api/$tenantID/creditosGet'),
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer ${token}',
      },
    );
    var data = json.decode(responde.body);
    setState(() {
      solicitudes = data;
      isLoading = false;
    });
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Navbar(
        title: "Creditos",
        /* searchBar: true,
        categoryOne: "Trending",
        categoryTwo: "Fashion", */
      ),
      backgroundColor: NowUIColors.bgColorScreen,
      // key: _scaffoldKey,
      drawer: NowDrawer(currentPage: "Creditos"),
      body: getBody(),
    );
  }

  Widget getBody() {
    if (solicitudes.contains(null) || solicitudes.length < 0 || isLoading) {
      return Center(
        child: CircularProgressIndicator(
          valueColor: new AlwaysStoppedAnimation<Color>(
            Colors.blue,
          ),
        ),
      );
    }
    return ListView.builder(
        itemCount: solicitudes.length,
        itemBuilder: (context, index) {
          return getCard(solicitudes[index]);
        });
  }

  Widget getCard(item) {
    var fullName = 'Nombre: ' +
            item['nombre']
                .toString() /* +
        " " +
        item['id_formulario_cliente'].toString() +
        " " +
        item['formulario']['hora'].toString() */
        ;
    /* var email = item['email'];
    var profileUrl = item['picture']['large']; */
    return Card(
      /* elevation: 1.5, */

      /* padding: const EdgeInsets.all(10.0), */
      child: ListTile(
        title: Row(
          children: <Widget>[
            /* Container(
                width: 60,
                height: 60,
              ), */
            /* SizedBox(
                width: 20,
              ), */
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SizedBox(
                    /* width: 200,
                      height: 31, */
                    child: Text(
                  fullName,
                  style: TextStyle(fontSize: 17),
                )),
                SizedBox(
                  height: 10,
                ),
                /* Text(
                  /* email.toString(), */
                  'Cliente ' + item['descripcion'].toString(),
                  style: TextStyle(color: Colors.grey),
                ), */
              ],
            )
          ],
        ),
      ),
    );
  }
}
