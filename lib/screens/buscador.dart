import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:now_ui_flutter/api.dart';
import 'package:now_ui_flutter/constants/Theme.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class Buscador extends StatefulWidget {
  const Buscador({Key key}) : super(key: key);

  @override
  State<Buscador> createState() => _BuscadorState();
}

class _BuscadorState extends State<Buscador> {
  var tenantController = TextEditingController();
  String baseUrl = api.url;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        /* drawer: NowDrawer(currentPage: "Account"), */
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
                    child: Text("Buscar Empresa",
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
                    controller: tenantController,
                    decoration: InputDecoration(
                        contentPadding: const EdgeInsets.all(8.0),
                        labelText: 'ID de la empresa',
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
                OutlinedButton.icon(
                  style: OutlinedButton.styleFrom(
                    primary: Colors.white,
                    backgroundColor: NowUIColors.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(32.0),
                    ),
                  ),
                  onPressed: () {
                    buscador();
                  },
                  icon: Icon(Icons.login, color: Colors.white),
                  label: Text('Buscar',
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

  void buscador() async {
    if (tenantController.text.isNotEmpty) {
      var response = await http.post(Uri.parse('$baseUrl/api/tenantID'),
          body: ({"tenant": tenantController.text.toString()}));
      if (response.statusCode == 200) {
        final body = jsonDecode(response.body);
        print(body['tenant_id']);
        tenant(body);
      } else {
        print(response.body);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Error al buscar la empresa'),
        ));
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Ingrese el ID de la empresa'),
      ));
    }
  }

  void tenant(body) async {
    /* guardar el id del tenant */
    SharedPreferences tenant = await SharedPreferences.getInstance();
    await tenant.setString('tenantID', body['tenant_id']);
    /* ir a login */
    Navigator.pushNamed(context, '/login');
  }
}
