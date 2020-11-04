import 'dart:convert' as convert;

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:ilacini_unutma/models/taken_medicines.dart';
import 'package:ilacini_unutma/ui/widgets/loading/loading.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../constants.dart';
import 'taken_list_tile.dart';
import '../../../providers/taken_medicines_provider.dart';

class TakenList extends StatefulWidget {
  final LoadTakenMedicines takenMedicineIsReady;
  final List<DoctorTakenMedicine> takenMedicinesList;
  final int type;

  TakenList({
    this.takenMedicineIsReady,
    this.takenMedicinesList,
    this.type,
  });

  @override
  _TakenListState createState() => _TakenListState();
}

class _TakenListState extends State<TakenList> {
  @override
  Widget build(BuildContext context) {
    switch (widget.takenMedicineIsReady) {
      case LoadTakenMedicines.loaded:
        return Container(
          height: 500,
          child: ListView(
            children: widget.takenMedicinesList.map((takenMedicines) {
              return Container(
                height: 100,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: widget.type == 1
                    ? TakenListTile(
                        takenMedicinesPatientName: takenMedicines.name,
                        takenMedicinesPatientSurname: takenMedicines.surname,
                        takenMedicinesCode:
                            takenMedicines.prescriptionCode.toString(),
                        takenMedicinesMedicineName: takenMedicines.medicineName,
                        takenMedicinesTime:
                            takenMedicines.timeToTake.toString(),
                        type: widget.type,
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
                        type: widget.type,
                      ),
              );
            }).toList(),
          ),
        );
        break;
      case LoadTakenMedicines.notLoaded:
        return Center(
          child: Text("İlaç alım bilgisi bulunamadı."),
        );
        break;
      case LoadTakenMedicines.waiting:
        return Center(
          child: CircularProgressIndicator(
            backgroundColor: primaryColor,
            valueColor: AlwaysStoppedAnimation(
              secondaryColor,
            ),
          ),
        );
        break;
      default:
        return Loading();
        break;
    }
  }
}
