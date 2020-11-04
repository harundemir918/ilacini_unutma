import 'dart:convert' as convert;

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../models/patients.dart';
import '../constants.dart';

enum LoadPatients {
  loaded,
  notLoaded,
  waiting,
}

class PatientsProvider with ChangeNotifier {
  List<DoctorPatient> _patients;
  LoadPatients _patientIsReady;

  List<DoctorPatient> get patientsList => _patients;
  LoadPatients get isPatientReady => _patientIsReady;

  set patientsList(List<DoctorPatient> val) {
    _patients = val;
    notifyListeners();
  }

  set isPatientReady(LoadPatients val) {
    _patientIsReady = val;
    notifyListeners();
  }

  Future<LoadPatients> fetchPatients(int doctorUid) async {
    try {
      var response = await http.get("$apiUrl/patient.php?doctor_id=$doctorUid");
      if (response.statusCode == 200) {
        var mapResponse = convert.jsonDecode(response.body);
        List patients = mapResponse["users"].cast<Map<String, dynamic>>();
        print(patients);
        List<DoctorPatient> allPatients = patients.map<DoctorPatient>((json) {
          return DoctorPatient.fromJson(json);
        }).toList();
        patientsList = allPatients;
        isPatientReady = LoadPatients.loaded;
      } else {
        isPatientReady = LoadPatients.notLoaded;
      }
    } catch(e) {
      isPatientReady = LoadPatients.notLoaded;
      debugPrint(e.toString());
    }

    return isPatientReady;
  }
}