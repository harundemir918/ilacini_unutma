import 'dart:convert' as convert;

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../constants.dart';
import 'patient_list_tile.dart';

class PatientList extends StatefulWidget {
  @override
  _PatientListState createState() => _PatientListState();
}

class _PatientListState extends State<PatientList> {
  int uid;
  int type;
  List<dynamic> patientsList = [];
  bool patientIsReady = false;

  @override
  void initState() {
    _getUserUidAndType();
    super.initState();
  }

  _getUserUidAndType() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      uid = prefs.getInt("uid");
      type = prefs.getInt("type");
    });
    getPatients();
  }

  getPatients() async {
    var url = "$apiUrl/patient.php?doctor_id=$uid";
    var response = await http.get(url);
    if (response.statusCode == 200) {
      var jsonResponse = convert.jsonDecode(response.body);
      int count = int.parse(jsonResponse["count"].toString());
      for (int i = 0; i < count; i++) {
        print(jsonResponse["users"][i]["patient_id"]);
        print(jsonResponse["users"][i]["name"]);
        print(jsonResponse["users"][i]["surname"]);
        setState(() {
          patientsList.add({
            "patientID": jsonResponse["users"][i]["patient_id"],
            "patientName": jsonResponse["users"][i]["name"],
            "patientSurname": jsonResponse["users"][i]["surname"],
            "patientDevicePlayerId": jsonResponse["users"][i]
                ["device_player_id"],
            "patientPrescriptionCount": jsonResponse["users"][i]
                ["prescription_count"]
          });
        });
      }
      patientIsReady = true;
    } else {
      print('Request failed with status: ${response.statusCode}.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return patientIsReady
        ? Container(
            height: 500,
            child: ListView(
              children: patientsList.map((patient) {
                return Container(
                  height: 100,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: PatientListTile(
                    doctorUid: uid,
                    patientUid: int.parse(patient["patientID"]),
                    patientName: patient["patientName"],
                    patientSurname: patient["patientSurname"],
                    patientDevicePlayerId: patient["patientDevicePlayerId"],
                    patientPrescriptionCount:
                    int.parse(patient["patientPrescriptionCount"]),
                    type: type,
                  ),
                );
              }).toList(),
            ),
          )
        : CircularProgressIndicator(
            valueColor: new AlwaysStoppedAnimation<Color>(
              secondaryColor,
            ),
          );
  }
}
