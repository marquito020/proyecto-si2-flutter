import 'dart:convert';

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

// import 'package:now_ui_flutter/screens/product.dart';

final Map<String, Map<String, String>> homeCards = {
  "Ice Cream": {
    "title": "Society has put up so many boundaries",
    "image":
        "https://images.unsplash.com/photo-1506744038136-46273834b3fb?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=750&q=80"
  },
  "Makeup": {
    "title": "Is makeup one of your daily esse …",
    "image":
        "https://images.unsplash.com/photo-1519368358672-25b03afee3bf?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=2004&q=80"
  },
  "Coffee": {
    "title": "Many limitations on what’s right",
    "image":
        "https://raw.githubusercontent.com/creativetimofficial/public-assets/master/now-ui-pro-react-native/bg40.jpg"
  },
  "Fashion": {
    "title": "Why would anyone pick blue over?",
    "image":
        "https://images.unsplash.com/photo-1536686763189-829249e085ac?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=705&q=80"
  },
  "Argon": {
    "title": "Pink is obviously a better color",
    "image":
        "https://raw.githubusercontent.com/creativetimofficial/public-assets/master/now-ui-pro-react-native/project21.jpg"
  }
};

class Home extends StatefulWidget {
  @override
  _Home createState() => _Home();
}

class _Home extends State<Home> {
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
      Uri.parse('$baseUrl/api/$tenantID/solicitudesGet'),
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

  // final GlobalKey _scaffoldKey = new GlobalKey();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Navbar(
        title: "Solicitudes",
        /* searchBar: true,
        categoryOne: "Trending",
        categoryTwo: "Fashion", */
      ),
      backgroundColor: NowUIColors.bgColorScreen,
      // key: _scaffoldKey,
      drawer: NowDrawer(currentPage: "Home"),
      body: getBody(),
      /* body: Container(
          padding: EdgeInsets.only(left: 16.0, right: 16.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 16.0),
                  child: CardHorizontal(
                      cta: "View article",
                      title: homeCards["Ice Cream"]['title'],
                      img: homeCards["Ice Cream"]['image'],
                      tap: () {
                        Navigator.pushNamed(context, '/pro');
                      }),
                ),
                SizedBox(height: 8.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CardSmall(
                        cta: "View article",
                        title: homeCards["Makeup"]['title'],
                        img: homeCards["Makeup"]['image'],
                        tap: () {}),
                    CardSmall(
                        cta: "View article",
                        title: homeCards["Coffee"]['title'],
                        img: homeCards["Coffee"]['image'],
                        tap: () {
                          Navigator.pushNamed(context, '/pro');
                        })
                  ],
                ),
                SizedBox(height: 8.0),
                CardHorizontal(
                    cta: "View article",
                    title: homeCards["Fashion"]['title'],
                    img: homeCards["Fashion"]['image'],
                    tap: () {
                      Navigator.pushNamed(context, '/pro');
                    }),
                SizedBox(height: 8.0),
                Padding(
                  padding: const EdgeInsets.only(bottom: 32.0),
                  child: CardSquare(
                      cta: "View article",
                      title: homeCards["Argon"]['title'],
                      img: homeCards["Argon"]['image'],
                      tap: () {
                        Navigator.pushNamed(context, '/pro');
                      }),
                )
              ],
            ),
          ),
        ) */
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
    var fullName = 'Estado: ' +
            item['estado']
                .toString() /* +
        " " +
        item['id_formulario_cliente'].toString() +
        " " +
        item['formulario']['hora'].toString() */
        ;
    /* var email = item['email'];
    var profileUrl = item['picture']['large']; */
    return Card(
      elevation: 1.5,
      child: Padding(
        padding: const EdgeInsets.all(10.0),
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
                      width: MediaQuery.of(context).size.width - 140,
                      child: Text(
                        fullName,
                        style: TextStyle(fontSize: 17),
                      )),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    /* email.toString(), */
                    'Cliente ' + item['cliente'].toString(),
                    style: TextStyle(color: Colors.grey),
                  ),
                  Text(
                    /* email.toString(), */
                    'Estado ' + item['estado'].toString(),
                    style: TextStyle(color: Colors.grey),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
