import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'panel_doctor_patients_screen.dart';
import 'panel_doctor_prescriptions_screen.dart';
import '../../../widgets/app_bar_with_logout_button.dart';
import '../../../widgets/blue_square_button.dart';

class PanelMainScreen extends StatefulWidget {
  // final int id;
  // final String user;
  // final int type;
  //
  // PanelMainScreen({this.id, this.user, this.type});

  @override
  _PanelMainScreenState createState() => _PanelMainScreenState();
}

class _PanelMainScreenState extends State<PanelMainScreen> {
  int uid;
  String user;
  int type;

  @override
  void initState() {
    _getUserData();
    super.initState();
  }

  _getUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    setState(() {
      uid = prefs.getInt('uid');
      user = prefs.getString('user');
      type = prefs.getInt('type');
    });
  }

  void getPanelDoctorPatientsScreen(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => PanelDoctorPatientsScreen(uid: uid, type: type),
      ),
    );
  }

  void getPanelDoctorPrescriptionsScreen(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => PanelDoctorPrescriptionsScreen(uid: uid),
      ),
    );
  }

  Widget _buildDoctorPanel(BuildContext context) {
    return Column(
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
    );
  }

  Widget _buildPatientPanel(BuildContext context) {
    return Column(
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
                  title: "Reçetelerim",
                  function: () =>
                      getPanelDoctorPrescriptionsScreen(context),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 30),
          child: type == 1 ? _buildDoctorPanel(context) : _buildPatientPanel(context),
        ),
      ),
    );
  }
}
