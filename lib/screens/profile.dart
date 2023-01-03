import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:now_ui_flutter/api.dart';
import 'package:now_ui_flutter/constants/Theme.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
//widgets
import 'package:now_ui_flutter/widgets/navbar.dart';
import 'package:now_ui_flutter/widgets/drawer.dart';
import 'package:now_ui_flutter/widgets/photo-album.dart';
import 'package:shared_preferences/shared_preferences.dart';
/* api */
import 'package:http/http.dart' as http;
import 'dart:convert';

List<String> imgArray = [
  "assets/imgs/album-1.jpg",
  "assets/imgs/album-2.jpg",
  "assets/imgs/album-3.jpg",
  "assets/imgs/album-4.jpg",
  "assets/imgs/album-5.jpg",
  "assets/imgs/album-6.jpg"
];

class Profile extends StatefulWidget {
  @override
  _Profile createState() => _Profile();
}

class _Profile extends State<Profile> {
  String token;
  String baseUrl = api.url;
  String nombre;
  String email;
  String telefono;
  String departamentoNombre;
  String departamentoDescripcion;

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
      Uri.parse('$baseUrl/api/$tenantID/perfilGet'),
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer ${token}',
      },
    );
    var data = json.decode(responde.body);
    nombre = data["usuario"]["name"];
    email = data['usuario']['email'];
    telefono = data['usuario']['telefono'];
    departamentoNombre = data['departamento']['nombre'];
    departamentoDescripcion = data['departamento']['descripcion'];
    print(departamentoDescripcion);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        extendBodyBehindAppBar: true,
        appBar: Navbar(
          title: "Perfil",
          transparent: true,
        ),
        backgroundColor: NowUIColors.bgColorScreen,
        drawer: NowDrawer(currentPage: "Profile"),
        body: Stack(
          children: <Widget>[
            Column(
              children: [
                Flexible(
                  flex: 1,
                  child: Container(
                      decoration: BoxDecoration(
                          image: DecorationImage(
                              image: AssetImage("assets/imgs/bg-profile.png"),
                              fit: BoxFit.cover)),
                      child: Stack(
                        children: <Widget>[
                          SafeArea(
                            bottom: false,
                            right: false,
                            left: false,
                            child: Padding(
                              padding: const EdgeInsets.only(left: 0, right: 0),
                              child: Column(
                                children: [
                                  CircleAvatar(
                                      backgroundImage: AssetImage(
                                          "assets/imgs/profile-img.jpg"),
                                      radius: 65.0),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 24.0),
                                    child: Text("$nombre",
                                        style: TextStyle(
                                            color: NowUIColors.white,
                                            fontWeight: FontWeight.w600,
                                            fontSize: 22)),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 8.0),
                                    child: Text("$email",
                                        style: TextStyle(
                                            color: NowUIColors.white
                                                .withOpacity(0.85),
                                            fontSize: 15,
                                            fontWeight: FontWeight.w600)),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 8.0),
                                    child: Text("Telefono: " + "$telefono",
                                        style: TextStyle(
                                            color: NowUIColors.white
                                                .withOpacity(0.85),
                                            fontSize: 15,
                                            fontWeight: FontWeight.w600)),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        top: 24.0, left: 42, right: 32),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      mainAxisSize: MainAxisSize.max,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )
                        ],
                      )),
                ),
                Flexible(
                  flex: 1,
                  child: Container(
                      child: SingleChildScrollView(
                          child: Padding(
                    padding: const EdgeInsets.only(
                        left: 32.0, right: 32.0, top: 30.0),
                    child: Column(children: [
                      Text("Departamento:",
                          style: TextStyle(
                              color: NowUIColors.text,
                              fontWeight: FontWeight.w600,
                              fontSize: 17.0)),
                      SizedBox(height: 10),
                      Text("$departamentoNombre",
                          style: TextStyle(
                              color: NowUIColors.text,
                              fontWeight: FontWeight.w600,
                              fontSize: 17.0)),
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 24.0, right: 24, top: 30, bottom: 24),
                        child: Text("$departamentoDescripcion",
                            textAlign: TextAlign.center,
                            style: TextStyle(color: NowUIColors.time)),
                      ),
                    ]),
                  ))),
                ),
              ],
            ),
          ],
        ));
  }
}
