import 'package:flutter/material.dart';
import 'package:ilacini_unutma/widgets/blue_square_button.dart';

import '../../../constants.dart';
import 'panel_doctor_patients_screen.dart';
import 'panel_doctor_prescriptions_screen.dart';
import '../../../widgets/app_bar_with_logout_button.dart';

class PanelMainScreen extends StatelessWidget {
  final int id;
  final String user;
  final int type;

  PanelMainScreen({this.id, this.user, this.type});

  void getPanelDoctorPatientsScreen(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => PanelDoctorPatientsScreen(uid: id, type: type),
      ),
    );
  }

  void getPanelDoctorPrescriptionsScreen(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => PanelDoctorPrescriptionsScreen(uid: id),
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppBarWithLogoutButton(),
              Container(
                margin: EdgeInsets.symmetric(vertical: 75),
                child: Text(
                  "Merhaba, $user.",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                  ),
                ),
              ),
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      BlueSquareButton(
                        title: "Hastalarım",
                        function: () => getPanelDoctorPatientsScreen(context),
                      ),
                      BlueSquareButton(
                        title: "Reçetelerim",
                        function: () =>
                            getPanelDoctorPrescriptionsScreen(context),
                      ),
                    ],
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
