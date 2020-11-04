import 'dart:convert' as convert;

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../models/prescriptions.dart';
import '../constants.dart';

enum LoadPrescription {
  loaded,
  notLoaded,
  waiting,
}

class PrescriptionsProvider with ChangeNotifier {
  List<Prescription> _prescriptions;
  List<DoctorPrescription> _doctorPrescriptions;
  List<PatientPrescription> _patientPrescriptions;
  List<String> _prescriptionCodes = [];
  int _prescriptionCodeCount;
  int _prescriptionCount;
  LoadPrescription _prescriptionIsReady;

  List<Prescription> get prescriptionsList => _prescriptions;
  List<DoctorPrescription> get doctorPrescriptionsList => _doctorPrescriptions;
  List<PatientPrescription> get patientPrescriptionsList => _patientPrescriptions;
  List<String> get prescriptionCodesList => _prescriptionCodes;
  int get prescriptionCodeListCount => _prescriptionCodeCount;
  int get prescriptionCount => _prescriptionCount;
  LoadPrescription get isPrescriptionReady => _prescriptionIsReady;

  set prescriptionsList(List<Prescription> val) {
    _prescriptions = val;
    notifyListeners();
  }

  set doctorPrescriptionsList(List<DoctorPrescription> val) {
    _doctorPrescriptions = val;
    notifyListeners();
  }

  set patientPrescriptionsList(List<PatientPrescription> val) {
    _patientPrescriptions = val;
    notifyListeners();
  }

  set prescriptionCodesList(List<String> val) {
    _prescriptionCodes = val;
    notifyListeners();
  }

  set isPrescriptionReady(LoadPrescription val) {
    _prescriptionIsReady = val;
    notifyListeners();
  }

  set prescriptionCodeListCount(int val) {
    _prescriptionCodeCount = val;
    notifyListeners();
  }

  set prescriptionCount(int val) {
    _prescriptionCount = val;
    notifyListeners();
  }

  Future<LoadPrescription> fetchPatientPrescriptions(
      {int doctorUid, int patientUid}) async {
    try {
      var response = await http.get(
          "$apiUrl/prescriptions.php?doctor_id=$doctorUid&patient_id=$patientUid");
      if (response.statusCode == 200) {
        var mapResponse = convert.jsonDecode(response.body);
        List patients = mapResponse["users"].cast<Map<String, dynamic>>();
        print(patients);
        List<PatientPrescription> allPrescriptions =
            patients.map<PatientPrescription>((json) {
          return PatientPrescription.fromJson(json);
        }).toList();
        patientPrescriptionsList = allPrescriptions;
        for (var prescription in patientPrescriptionsList) {
          if (!prescriptionCodesList.contains(prescription.code)) {
            prescriptionCodesList.add(prescription.code);
          }
        }
        prescriptionCodeListCount = prescriptionCodesList.length;
        prescriptionCount = patientPrescriptionsList.length;
        isPrescriptionReady = LoadPrescription.loaded;
      } else {
        isPrescriptionReady = LoadPrescription.notLoaded;
      }
    } catch (e) {
      isPrescriptionReady = LoadPrescription.notLoaded;
      debugPrint(e.toString());
    }
    return isPrescriptionReady;
  }

  Future<LoadPrescription> fetchPrescriptions({
    int doctorUid,
    int uid,
    int type,
  }) async {
    try {
      if (type == 1) {
        var response =
            await http.get("$apiUrl/prescriptions.php?doctor_id=$uid");
        if (response.statusCode == 200) {
          var mapResponse = convert.jsonDecode(response.body);
          List doctorPrescriptions = mapResponse["users"].cast<Map<String, dynamic>>();
          print(doctorPrescriptions);
          List<DoctorPrescription> allDoctorPrescriptions = doctorPrescriptions.map<DoctorPrescription>((json) {
            return DoctorPrescription.fromJson(json);
          }).toList();
          doctorPrescriptionsList = allDoctorPrescriptions;
          isPrescriptionReady = LoadPrescription.loaded;
        } else {
          isPrescriptionReady = LoadPrescription.notLoaded;
        }
      } else if (type == 2) {
        var response = await http.get(
            "$apiUrl/prescriptions.php?doctor_id=$doctorUid&patient_id=$uid");
        if (response.statusCode == 200) {
          var mapResponse = convert.jsonDecode(response.body);
          List patientPrescriptions = mapResponse["users"].cast<Map<String, dynamic>>();
          print(patientPrescriptions);
          List<PatientPrescription> allPatientPrescriptions = patientPrescriptions.map<PatientPrescription>((json) {
            return PatientPrescription.fromJson(json);
          }).toList();
          patientPrescriptionsList = allPatientPrescriptions;
          isPrescriptionReady = LoadPrescription.loaded;
        } else {
          isPrescriptionReady = LoadPrescription.notLoaded;
        }
      }

    } catch (e) {
      isPrescriptionReady = LoadPrescription.notLoaded;
      debugPrint(e.toString());
    }
    return isPrescriptionReady;
  }
}
