import 'package:flutter/material.dart';
import 'package:ilacini_unutma/widgets/blue_square_button.dart';

import 'auth_doctor_sign_in_screen.dart';
import 'auth_patient_sign_in_screen.dart';
import 'auth_register_screen.dart';

class AuthChooseScreen extends StatelessWidget {
  void getAuthDoctorSignInScreen(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => AuthDoctorSignInScreen(),
      ),
    );
  }

  void getAuthPatientSignInScreen(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => AuthPatientSignInScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 30),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Container(
                margin: EdgeInsets.only(
                  top: 50,
                ),
                child: Image.asset("assets/images/splash_logo.png"),
              ),
              Container(
                margin: EdgeInsets.only(bottom: 100),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    BlueSquareButton(
                      title: "Doktor Girişi",
                      function: () => getAuthDoctorSignInScreen(context),
                    ),
                    BlueSquareButton(
                      title: "Hasta Girişi",
                      function: () => getAuthPatientSignInScreen(context),
                    ),
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Hesabınız yok mu?",
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  FlatButton(
                    child: Text(
                      "Kayıt olun.",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => AuthRegisterScreen(),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
