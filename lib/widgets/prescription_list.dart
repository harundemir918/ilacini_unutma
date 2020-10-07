import 'dart:convert' as convert;

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'prescription_list_tile.dart';

class PrescriptionList extends StatefulWidget {
  final int uid;

  PrescriptionList({this.uid});

  @override
  _PrescriptionListState createState() => _PrescriptionListState();
}

class _PrescriptionListState extends State<PrescriptionList> {
  List<dynamic> prescriptionsList = [];
  int prescriptionCount;
  bool prescriptionIsReady = false;

  @override
  void initState() {
    getPrescriptions();
    super.initState();
  }

  getPrescriptions() async {
    print("${widget.uid}");
    var url = "http://api.harundemir.org/ilacini_unutma/prescriptions.php?"
        "doctor_id=${widget.uid}";

    var response = await http.get(url);
    if (response.statusCode == 200) {
      var jsonResponse = convert.jsonDecode(response.body);
      prescriptionCount = int.parse(jsonResponse["count"].toString());
      for (int i = 0; i < prescriptionCount; i++) {
        print(jsonResponse["users"][i]["code"]);
        setState(() {
          prescriptionsList.add({
            "prescriptionID": jsonResponse["users"][i]["id"],
            "prescriptionCode": jsonResponse["users"][i]["code"],
            "prescriptionPatientName": jsonResponse["users"][i]["name"],
            "prescriptionPatientSurname": jsonResponse["users"][i]["surname"],
            "prescriptionDate": jsonResponse["users"][i]["create_date"],
          });
        });
        prescriptionIsReady = true;
      }
    } else {
      print('Request failed with status: ${response.statusCode}.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 500,
      child: prescriptionIsReady
          ? ListView(
              children: prescriptionsList.map((prescription) {
                return Container(
                  height: 100,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: PrescriptionListTile(
                    prescriptionCode: prescription["prescriptionCode"],
                    prescriptionPatientName:
                        prescription["prescriptionPatientName"],
                    prescriptionPatientSurname:
                        prescription["prescriptionPatientSurname"],
                    prescriptionDate: prescription["prescriptionDate"],
                  ),
                );
              }).toList(),
            )
          : Center(
              child: CircularProgressIndicator(
                backgroundColor: Color(0xff247b7b),
                valueColor: AlwaysStoppedAnimation(
                  Color(0xff2fa3a3),
                ),
              ),
            ),
    );
  }
}
