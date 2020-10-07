import 'dart:convert' as convert;

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'patient_list_tile.dart';

class PatientList extends StatefulWidget {
  final int uid;
  final int type;

  PatientList({this.uid, this.type});

  @override
  _PatientListState createState() => _PatientListState();
}

class _PatientListState extends State<PatientList> {
  List<dynamic> patientsList = [];
  bool patientIsReady = false;

  @override
  void initState() {
    getPatients();
    super.initState();
  }

  getPatients() async {
    var url =
        "http://api.harundemir.org/ilacini_unutma/patient.php?doctor_id=${widget.uid}";
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
                    doctorUid: widget.uid,
                    patientUid: int.parse(patient["patientID"]),
                    type: widget.type,
                    patientName: patient["patientName"],
                    patientSurname: patient["patientSurname"],
                    patientPrescriptionCount:
                        int.parse(patient["patientPrescriptionCount"]),
                  ),
                );
              }).toList(),
            ),
          )
        : CircularProgressIndicator(
            valueColor: new AlwaysStoppedAnimation<Color>(
              Color(0xff2fa3a3),
            ),
          );
  }
}
