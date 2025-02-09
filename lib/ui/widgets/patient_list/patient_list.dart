import 'package:flutter/material.dart';

import '../../../constants.dart';
import 'patient_list_tile.dart';
import '../../../providers/patients_provider.dart';
import '../../../models/patients.dart';

class PatientList extends StatefulWidget {
  final LoadPatients patientIsReady;
  final List<DoctorPatient> patientsList;
  final int uid;
  final int type;

  PatientList({
    this.patientIsReady,
    this.patientsList,
    this.uid,
    this.type,
  });

  @override
  _PatientListState createState() => _PatientListState();
}

class _PatientListState extends State<PatientList> {
  @override
  Widget build(BuildContext context) {
    switch (widget.patientIsReady) {
      case LoadPatients.loaded:
        return Container(
          height: 500,
          child: ListView(
            children: widget.patientsList.map((patient) {
              return Container(
                height: 100,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: PatientListTile(
                  doctorUid: widget.uid,
                  patientUid: int.parse(patient.patientId),
                  patientName: patient.name,
                  patientSurname: patient.surname,
                  patientDevicePlayerId: patient.devicePlayerId,
                  patientPrescriptionCount:
                      int.parse(patient.prescriptionCount),
                  type: widget.type,
                ),
              );
            }).toList(),
          ),
        );
        break;
      case LoadPatients.notLoaded:
        return Center(child: Text("Hasta bilgisi bulunamadı"));
        break;
      case LoadPatients.waiting:
        return CircularProgressIndicator(
          valueColor: new AlwaysStoppedAnimation<Color>(
            secondaryColor,
          ),
        );
        break;
      default:
        return CircularProgressIndicator(
          valueColor: new AlwaysStoppedAnimation<Color>(
            secondaryColor,
          ),
        );
        break;
    }
  }
}
