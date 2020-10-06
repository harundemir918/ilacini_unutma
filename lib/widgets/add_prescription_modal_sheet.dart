import 'dart:convert' as convert;

import 'package:flutter/material.dart';
import 'package:random_string/random_string.dart';
import 'package:http/http.dart' as http;

class AddPrescriptionModalSheet extends StatefulWidget {
  final int doctorUid;
  final int patientUid;

  AddPrescriptionModalSheet({
    this.doctorUid,
    this.patientUid,
  });

  @override
  _AddPrescriptionModalSheetState createState() =>
      _AddPrescriptionModalSheetState();
}

class _AddPrescriptionModalSheetState extends State<AddPrescriptionModalSheet> {
  String code = randomAlphaNumeric(8).toUpperCase();
  List<dynamic> _prescriptions = [];
  List<dynamic> _medicines = [];
  List<DropdownMenuItem> items = [];
  int _count = 1;
  int _value;
  bool medicineIsReady = false;

  @override
  void initState() {
    getMedicines();
    super.initState();
  }

  getMedicines() async {
    var url = "http://yuztemeleserozet.harundemir.org/ilacini_unutma/medicines.php";
    var response = await http.get(url);
    if (response.statusCode == 200) {
      var jsonResponse = convert.jsonDecode(response.body);
      int count = int.parse(jsonResponse["count"].toString());
      print(jsonResponse["medicines"][0]["id"]);
      print(jsonResponse["medicines"][0]["name"]);
      for (int i = 0; i < count; i++) {
        setState(() {
          _medicines.add({
            "medicineID": jsonResponse["medicines"][i]["id"],
            "medicineName": jsonResponse["medicines"][i]["name"],
          });
          items.add(
            DropdownMenuItem(
              child: Text(jsonResponse["medicines"][i]["name"]),
              value: int.parse(jsonResponse["medicines"][i]["id"]),
            ),
          );
        });
      }
      medicineIsReady = true;
    } else {
      print('Request failed with status: ${response.statusCode}.');
    }
  }

  createPrescription({
    String doctorUid,
    String patientUid,
    String medicineUid,
    String code,
  }) async {
    var url = "http://yuztemeleserozet.harundemir.org/ilacini_unutma/prescriptions.php";
    var response = await http.post(url, body: {
      'doctor_id': doctorUid,
      'patient_id': patientUid,
      'medicine_id': medicineUid,
      'code': code
    });
    if (response.statusCode == 201) {
      print("Ekleme başarılı.");
    } else {
      print("Hata.");
    }
  }

  Widget _buildMedicine() {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Container(
            width: 200,
            child: DropdownButtonFormField(
              hint: Text("İlaç seçin"),
              decoration: InputDecoration(
                border: InputBorder.none,
              ),
              // items: [
              //   DropdownMenuItem(
              //     child: Text("Doktor Kaydı"),
              //     value: 1,
              //   ),
              //   DropdownMenuItem(
              //     child: Text("Hasta Kaydı"),
              //     value: 2,
              //   ),
              // ],
              items: medicineIsReady ? items : [],
              onChanged: (value) {
                setState(() {
                  _value = value;
                });
              },
            ),
          ),
          GestureDetector(
            child: Container(
              decoration: BoxDecoration(
                color: Color(0xff2fa3a3),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.add,
                color: Colors.white,
                size: 30,
              ),
            ),
            onTap: () => _addNewMedicine(
                doctorUid: widget.doctorUid,
                patientUid: widget.patientUid,
                medicineUid: _value,
                code: code),
          )
        ],
      ),
    );
  }

  void _addNewMedicine(
      {int doctorUid, int patientUid, int medicineUid, String code}) {
    setState(() {
      _prescriptions.add({
        "doctor_id": doctorUid,
        "patient_id": patientUid,
        "medicine_id": medicineUid,
        "code": code,
      });
      _count = _count + 1;
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> _medicines =
        new List.generate(_count, (int i) => _buildMedicine());
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
      child: Column(
        children: [
          Text(
            "Yeni reçete oluştur",
            style: TextStyle(
              fontSize: 20,
            ),
          ),
          Text("Reçete kodu: $code"),
          Container(
            height: 200,
            child: ListView(
              children: _medicines,
            ),
          ),
          SizedBox(
            height: 30,
          ),
          RaisedButton(
            color: Color(0xff2fa3a3),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              "Ekle",
              style: TextStyle(color: Colors.white),
            ),
            onPressed: () {
              setState(() {
                _prescriptions.forEach(
                  (prescription) {
                    print(prescription);
                    createPrescription(
                      doctorUid: prescription["doctor_id"].toString(),
                      patientUid: prescription["patient_id"].toString(),
                      medicineUid: prescription["medicine_id"].toString(),
                      code: prescription["code"],
                    );
                  },
                );
              });
              Navigator.pop(context);
            },
          ),
          // DatePicker yazılacak
        ],
      ),
    );
  }
}
