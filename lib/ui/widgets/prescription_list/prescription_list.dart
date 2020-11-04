import 'dart:convert' as convert;

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:ilacini_unutma/models/prescriptions.dart';
import 'package:ilacini_unutma/ui/widgets/loading/loading.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../constants.dart';
import 'prescription_list_tile.dart';
import '../../../providers/prescriptions_provider.dart';

class PrescriptionList extends StatefulWidget {
  final LoadPrescription prescriptionIsReady;
  final List<DoctorPrescription> prescriptionsList;
  final int doctorUid;
  final int uid;
  final int type;

  PrescriptionList({
    this.prescriptionIsReady,
    this.prescriptionsList,
    this.doctorUid,
    this.uid,
    this.type,
  });

  @override
  _PrescriptionListState createState() => _PrescriptionListState();
}

class _PrescriptionListState extends State<PrescriptionList> {
  // List<dynamic> prescriptionsList = [];
  // // int prescriptionCount;
  // bool prescriptionIsReady = false;
  // int doctorUid;
  // int uid;
  // int type;
  //
  // @override
  // void initState() {
  //   getUserUidAndType();
  //   // getPrescriptions();
  //   super.initState();
  // }
  //
  // // getPrescriptions() async {
  // //   print("Uid = $uid");
  // //   print("DoctorUid = $doctorUid");
  // //   print("Type = $type");
  // //
  // //   if (type == 1) {
  // //     var url = "$apiUrl/prescriptions.php?"
  // //         "doctor_id=$uid";
  // //
  // //     var response = await http.get(url);
  // //     if (response.statusCode == 200) {
  // //       var jsonResponse = convert.jsonDecode(response.body);
  // //       prescriptionCount = int.parse(jsonResponse["count"].toString());
  // //       for (int i = 0; i < prescriptionCount; i++) {
  // //         print(jsonResponse["users"][i]["code"]);
  // //         setState(() {
  // //           prescriptionsList.add({
  // //             "prescriptionID": jsonResponse["users"][i]["id"],
  // //             "prescriptionCode": jsonResponse["users"][i]["code"],
  // //             "prescriptionPatientName": jsonResponse["users"][i]["name"],
  // //             "prescriptionPatientSurname": jsonResponse["users"][i]["surname"],
  // //             "prescriptionDate": jsonResponse["users"][i]["create_date"],
  // //           });
  // //         });
  // //         prescriptionIsReady = true;
  // //       }
  // //     } else {
  // //       print('Request failed with status: ${response.statusCode}.');
  // //     }
  // //   } else if (type == 2) {
  // //     var url = "$apiUrl/prescriptions.php?doctor_id=1&patient_id=$uid";
  // //
  // //     var response = await http.get(url);
  // //     if (response.statusCode == 200) {
  // //       var jsonResponse = convert.jsonDecode(response.body);
  // //       prescriptionCount = int.parse(jsonResponse["count"].toString());
  // //       for (int i = 0; i < prescriptionCount; i++) {
  // //         print(jsonResponse["users"][i]["code"]);
  // //         setState(() {
  // //           prescriptionsList.add({
  // //             "prescriptionID": jsonResponse["users"][i]["id"],
  // //             "prescriptionPatientName": jsonResponse["users"][i]["name"],
  // //             "prescriptionPatientSurname": jsonResponse["users"][i]["surname"],
  // //             "prescriptionCode": jsonResponse["users"][i]["code"],
  // //             "prescriptionDate": jsonResponse["users"][i]["create_date"],
  // //           });
  // //         });
  // //         prescriptionIsReady = true;
  // //       }
  // //     } else {
  // //       print('Request failed with status: ${response.statusCode}.');
  // //     }
  // //   }
  // // }
  //
  // getUserUidAndType() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   setState(() {
  //     uid = prefs.getInt("uid");
  //     doctorUid = prefs.getInt("doctorUid");
  //     type = prefs.getInt("type");
  //   });
  //   // getPrescriptions();
  // }

  @override
  Widget build(BuildContext context) {
    switch(widget.prescriptionIsReady) {
      case LoadPrescription.loaded:
        return Container(
          height: 500,
          child: ListView(
            children: widget.prescriptionsList.map((prescription) {
              return Container(
                height: 100,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: widget.type == 1
                    ? PrescriptionListTile(
                  prescriptionCode: prescription.code,
                  prescriptionPatientName:
                  prescription.name,
                  prescriptionPatientSurname:
                  prescription.surname,
                  prescriptionDate: prescription.createDate.toString(),
                  type: widget.type,
                )
                    : PrescriptionListTile(
                  prescriptionDoctorUid: widget.doctorUid,
                  prescriptionPatientUid: widget.uid,
                  prescriptionPatientName:
                  prescription.name,
                  prescriptionPatientSurname:
                  prescription.surname,
                  prescriptionCode: prescription.code,
                  prescriptionDate: prescription.createDate.toString(),
                  type: widget.type,
                ),
              );
            }).toList(),
          ),);
          break;
      case LoadPrescription.notLoaded:
        return Center(child: Text("Reçete bilgisi bulunamadı."),);
        break;
      case LoadPrescription.waiting:
        return Loading();
        break;
      default:
        return Loading();
        break;
    }
  }
}
