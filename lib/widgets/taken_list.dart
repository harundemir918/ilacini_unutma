import 'dart:convert' as convert;

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../constants.dart';
import 'taken_list_tile.dart';

class TakenList extends StatefulWidget {
  @override
  _TakenListState createState() => _TakenListState();
}

class _TakenListState extends State<TakenList> {
  List<dynamic> takenMedicinesList = [];
  int prescriptionCount;
  bool prescriptionIsReady = false;
  int doctorUid;
  int uid;
  int type;

  @override
  void initState() {
    getUserUidAndType();
    super.initState();
  }

  getTakenMedicines() async {
    print("Uid = $uid");
    print("DoctorUid = $doctorUid");
    print("Type = $type");

    if (type == 1) {
      var url = "$apiUrl/taken_medicines.php?"
          "doctor_id=$uid";

      var response = await http.get(url);
      if (response.statusCode == 200) {
        var jsonResponse = convert.jsonDecode(response.body);
        prescriptionCount = int.parse(jsonResponse["count"].toString());
        for (int i = 0; i < prescriptionCount; i++) {
          print(jsonResponse["users"][i]["code"]);
          setState(() {
            takenMedicinesList.add({
              "takenMedicinesID": jsonResponse["users"][i]["id"],
              "takenMedicinesPatientName": jsonResponse["users"][i]["name"],
              "takenMedicinesPatientSurname": jsonResponse["users"][i]["surname"],
              "takenMedicinesCode": jsonResponse["users"][i]["prescription_code"],
              "takenMedicinesMedicineName": jsonResponse["users"][i]["medicine_name"],
              "takenMedicinesTime": jsonResponse["users"][i]["time_to_take"],
            });
          });
          prescriptionIsReady = true;
        }
      } else {
        print('Request failed with status: ${response.statusCode}.');
      }
    } else if (type == 2) {
      // var url = "$apiUrl/prescriptions.php?doctor_id=1&patient_id=$uid";
      //
      // var response = await http.get(url);
      // if (response.statusCode == 200) {
      //   var jsonResponse = convert.jsonDecode(response.body);
      //   prescriptionCount = int.parse(jsonResponse["count"].toString());
      //   for (int i = 0; i < prescriptionCount; i++) {
      //     print(jsonResponse["users"][i]["code"]);
      //     setState(() {
      //       prescriptionsList.add({
      //         "prescriptionID": jsonResponse["users"][i]["id"],
      //         "prescriptionPatientName": jsonResponse["users"][i]["name"],
      //         "prescriptionPatientSurname": jsonResponse["users"][i]["surname"],
      //         "prescriptionCode": jsonResponse["users"][i]["code"],
      //         "prescriptionDate": jsonResponse["users"][i]["create_date"],
      //       });
      //     });
      //     prescriptionIsReady = true;
      //   }
      // } else {
      //   print('Request failed with status: ${response.statusCode}.');
      // }
    }
  }

  getUserUidAndType() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      uid = prefs.getInt("uid");
      doctorUid = prefs.getInt("doctorUid");
      type = prefs.getInt("type");
    });
    getTakenMedicines();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 500,
      child: prescriptionIsReady
          ? ListView(
              children: takenMedicinesList.map((takenMedicines) {
                return Container(
                  height: 100,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: type == 1
                      ? TakenListTile(
                    takenMedicinesPatientName:
                    takenMedicines["takenMedicinesPatientName"],
                    takenMedicinesPatientSurname:
                    takenMedicines["takenMedicinesPatientSurname"],
                          takenMedicinesCode: takenMedicines["takenMedicinesCode"],
                    takenMedicinesMedicineName: takenMedicines["takenMedicinesMedicineName"],
                          takenMedicinesTime: takenMedicines["takenMedicinesTime"],
                          type: type,
                        )
                      : TakenListTile(
                          // prescriptionDoctorUid: doctorUid,
                          // prescriptionPatientUid: uid,
                          // prescriptionPatientName:
                          //     prescription["prescriptionPatientName"],
                          // prescriptionPatientSurname:
                          //     prescription["prescriptionPatientSurname"],
                          // prescriptionCode: prescription["prescriptionCode"],
                          // prescriptionDate: prescription["prescriptionDate"],
                          type: type,
                        ),
                );
              }).toList(),
            )
          : Center(
              child: CircularProgressIndicator(
                backgroundColor: primaryColor,
                valueColor: AlwaysStoppedAnimation(
                  secondaryColor,
                ),
              ),
            ),
    );
  }
}
