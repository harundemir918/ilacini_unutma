import 'package:flutter/material.dart';

import '../../widgets/app_bar_with_back_button.dart';
import '../../widgets/search_bar.dart';
import '../../widgets/patient_list.dart';

class PanelDoctorPatientsScreen extends StatefulWidget {
  @override
  _PanelDoctorPatientsScreenState createState() =>
      _PanelDoctorPatientsScreenState();
}

class _PanelDoctorPatientsScreenState extends State<PanelDoctorPatientsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 30),
            width: double.infinity,
            child: Column(
              children: [
                AppBarWithBackButton(),
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: SearchBar(
                    hintText: "Hasta arayın",
                  ),
                ),
                SizedBox(
                  height: 50,
                ),
                PatientList(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
