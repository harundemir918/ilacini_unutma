import 'dart:convert' as convert;

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:ilacini_unutma/constants.dart';
import 'package:ilacini_unutma/widgets/add_prescription_modal_sheet.dart';

import '../../../widgets/app_bar_with_back_button.dart';

class PanelDoctorPatientPrescriptionsScreen extends StatefulWidget {
  final int doctorUid;
  final int patientUid;
  final String patientName;
  final String patientSurname;

  PanelDoctorPatientPrescriptionsScreen({
    this.doctorUid,
    this.patientUid,
    this.patientName,
    this.patientSurname,
  });

  @override
  _PanelDoctorPatientPrescriptionsScreenState createState() =>
      _PanelDoctorPatientPrescriptionsScreenState();
}

class _PanelDoctorPatientPrescriptionsScreenState
    extends State<PanelDoctorPatientPrescriptionsScreen> {
  String name;
  String surname;
  int prescriptionCount;
  bool prescriptionIsReady = false;
  List<dynamic> prescriptionsList = [];
  List<String> prescriptionCodeList = [];

  @override
  void initState() {
    getPatients();
    super.initState();
  }

  getPatients() async {
    print("${widget.doctorUid} ${widget.patientUid}");
    var url = "http://api.harundemir.org/ilacini_unutma/prescriptions.php?"
        "doctor_id=${widget.doctorUid}&"
        "patient_id=${widget.patientUid}";
    var response = await http.get(url);
    if (response.statusCode == 200) {
      var jsonResponse = convert.jsonDecode(response.body);
      prescriptionCount = int.parse(jsonResponse["count"].toString());
      name = jsonResponse["users"][0]["name"];
      surname = jsonResponse["users"][0]["surname"];
      for (int i = 0; i < prescriptionCount; i++) {
        print(jsonResponse["users"][i]["code"]);
        setState(() {
          prescriptionsList.add({
            "prescriptionID": jsonResponse["users"][i]["id"],
            "prescriptionCode": jsonResponse["users"][i]["code"],
            "prescriptionMedicineName": jsonResponse["users"][i]
                ["medicine_name"],
          });
          if (!prescriptionCodeList
              .contains(jsonResponse["users"][i]["code"])) {
            prescriptionCodeList.add(jsonResponse["users"][i]["code"]);
          }
        });
      }
      print(prescriptionCodeList);
      prescriptionIsReady = true;
    } else {
      print('Request failed with status: ${response.statusCode}.');
    }
  }

  void _addNewPrescription(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (_) {
        return AddPrescriptionModalSheet(
          doctorUid: widget.doctorUid,
          patientUid: widget.patientUid,
        );
      },
    );
  }

  refresh() async {
    prescriptionsList.clear();
    prescriptionCodeList.clear();
    getPatients();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () => refresh(),
          child: SingleChildScrollView(
            physics: AlwaysScrollableScrollPhysics(),
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 30),
              child: Column(
                children: [
                  AppBarWithBackButton(),
                  Container(
                    width: 250,
                    height: 100,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "${widget.patientName} ${widget.patientSurname}",
                          style: TextStyle(
                            fontSize: 25,
                          ),
                        ),
                        Text(
                          "${prescriptionCodeList.length} reçete",
                          style: TextStyle(
                            color: lightGrayColor,
                            fontSize: 18,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        margin: EdgeInsets.symmetric(vertical: 30),
                        child: Text(
                          "Reçeteler",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Container(
                    height: 375,
                    child: prescriptionIsReady
                        ? ListView(
                            children: prescriptionsList.map((prescription) {
                              return Container(
                                child: Card(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Container(
                                    margin: EdgeInsets.symmetric(horizontal: 30),
                                    padding: EdgeInsets.symmetric(vertical: 20),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          prescription["prescriptionCode"],
                                          style: TextStyle(
                                            fontSize: 20,
                                          ),
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Text(
                                          prescription[
                                              "prescriptionMedicineName"],
                                          style: TextStyle(
                                            color: lightGrayColor,
                                            fontSize: 16,
                                          ),
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Text(
                                          "Sabah: 0 Tane",
                                          style: TextStyle(
                                            color: lightGrayColor,
                                            fontSize: 16,
                                          ),
                                        ),
                                        Text(
                                          "Öğle: 0 Tane",
                                          style: TextStyle(
                                            color: lightGrayColor,
                                            fontSize: 16,
                                          ),
                                        ),
                                        Text(
                                          "Akşam: 0 Tane",
                                          style: TextStyle(
                                            color: lightGrayColor,
                                            fontSize: 16,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            }).toList(),
                          )
                        : Center(
                            child: Text(
                              "Reçete bilgisi bulunamadı.",
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                          ),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 10),
                    child: FloatingActionButton.extended(
                      backgroundColor: secondaryColor,
                      label: Row(
                        children: [
                          Text("Reçete Ekle"),
                          Icon(Icons.add),
                        ],
                      ),
                      onPressed: () => _addNewPrescription(context),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
