import 'dart:convert' as convert;

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../models/taken_medicines.dart';
import '../constants.dart';

enum LoadTakenMedicines {
  loaded,
  notLoaded,
  waiting,
}

class TakenMedicinesProvider with ChangeNotifier {
  List<DoctorTakenMedicine> _takenMedicines;
  LoadTakenMedicines _takenMedicineIsReady;

  List<DoctorTakenMedicine> get takenMedicinesList => _takenMedicines;

  LoadTakenMedicines get isTakenMedicinesReady => _takenMedicineIsReady;

  set takenMedicinesList(List<DoctorTakenMedicine> val) {
    _takenMedicines = val;
    notifyListeners();
  }

  set isTakenMedicinesReady(LoadTakenMedicines val) {
    _takenMedicineIsReady = val;
    notifyListeners();
  }

  Future<LoadTakenMedicines> fetchTakenMedicines({
    int doctorUid,
    int type,
  }) async {
    try {
      if (type == 1) {
        var response =
        await http.get("$apiUrl/taken_medicines.php?doctor_id=$doctorUid");
        if (response.statusCode == 200) {
          var mapResponse = convert.jsonDecode(response.body);
          List takenMedicines = mapResponse["users"].cast<Map<String, dynamic>>();
          print(takenMedicines);
          List<DoctorTakenMedicine> allTakenMedicines =
          takenMedicines.map<DoctorTakenMedicine>((json) {
            return DoctorTakenMedicine.fromJson(json);
          }).toList();
          takenMedicinesList = allTakenMedicines;
          isTakenMedicinesReady = LoadTakenMedicines.loaded;
        } else {
          isTakenMedicinesReady = LoadTakenMedicines.notLoaded;
        }
      }
    } catch(e) {
      isTakenMedicinesReady = LoadTakenMedicines.notLoaded;
      debugPrint(e.toString());
    }
    return isTakenMedicinesReady;
  }
}
