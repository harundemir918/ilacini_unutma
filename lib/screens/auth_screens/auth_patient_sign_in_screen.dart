import 'dart:convert' as convert;

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:crypto/crypto.dart' as crypto;
import 'package:shared_preferences/shared_preferences.dart';

import '../../constants.dart';
import '../panels/panel_doctor/panel_main_screen.dart';

class AuthPatientSignInScreen extends StatefulWidget {
  @override
  _AuthPatientSignInScreenState createState() =>
      _AuthPatientSignInScreenState();
}

class _AuthPatientSignInScreenState extends State<AuthPatientSignInScreen> {
  final _formKey = GlobalKey<FormState>();

  String username = "";
  String password = "";
  int _value = 2;

  setLoggedInTrue({int uid, String user, int type}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      prefs.setBool('loggedIn', true);
      prefs.setInt('uid', uid);
      prefs.setString('user', user);
      prefs.setInt('type', type);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            SizedBox(
              height: 50,
            ),
            Image.asset(
              "assets/images/splash_logo.png",
              width: 200,
              height: 150,
            ),
            SizedBox(
              height: 50,
            ),
            Text(
              "Hasta Girişi",
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 40),
              child: Card(
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Form(
                  key: _formKey,
                  child: Container(
                    margin: EdgeInsets.symmetric(
                      horizontal: 20,
                    ),
                    child: Column(
                      children: [
                        SizedBox(
                          height: 25,
                        ),
                        TextFormField(
                          decoration: InputDecoration(
                            fillColor: Colors.grey[300],
                            filled: true,
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(
                                color: Colors.white,
                                width: 2,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: primaryColor,
                                width: 2,
                              ),
                            ),
                            hintText: "Kullanıcı Adı",
                          ),
                          onChanged: (val) {
                            setState(() {
                              username = val;
                            });
                          },
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        TextFormField(
                          obscureText: true,
                          decoration: InputDecoration(
                            fillColor: Colors.grey[300],
                            filled: true,
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(
                                color: Colors.white,
                                width: 2,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: primaryColor,
                                width: 2,
                              ),
                            ),
                            hintText: "Şifre",
                          ),
                          onChanged: (val) {
                            setState(() {
                              password = val;
                            });
                          },
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Container(
                          width: double.infinity,
                          child: RaisedButton(
                            child: Text(
                              "Giriş Yap",
                              style: TextStyle(color: Colors.white),
                            ),
                            color: primaryColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                            onPressed: () async {
                              var url = "$apiUrl/users.php?type=$_value";
                              var response = await http.get(url);
                              if (response.statusCode == 200) {
                                var jsonResponse =
                                    convert.jsonDecode(response.body);
                                int count =
                                    int.parse(jsonResponse["count"].toString());
                                for (int i = 0; i < count; i++) {
                                  var passMD5 = crypto.md5
                                      .convert(convert.utf8.encode(password))
                                      .toString();
                                  print("$username $password $passMD5 $_value");
                                  if (username ==
                                          jsonResponse["users"][i]
                                              ["username"] &&
                                      passMD5 ==
                                          jsonResponse["users"][i]
                                              ["password"]) {
                                    int uid = int.parse(jsonResponse["users"][i]
                                            ["id"]
                                        .toString());
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => PanelMainScreen(
                                            /*id: uid, user: username, type: _value*/),
                                      ),
                                    );
                                    setLoggedInTrue(
                                        uid: uid, user: username, type: _value);
                                  }
                                }
                              } else {
                                print(
                                    'Request failed with status: ${response.statusCode}.');
                              }
                            },
                          ),
                        ),
                        SizedBox(
                          height: 25,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
