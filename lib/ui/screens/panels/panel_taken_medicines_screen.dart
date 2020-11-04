import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../widgets/app_bar/app_bar_with_back_button.dart';
import '../../widgets/search_bar.dart';
import '../../widgets/taken_list/taken_list.dart';
import '../../widgets/loading/loading.dart';
import '../../../providers/taken_medicines_provider.dart';

class PanelTakenMedicinesScreen extends StatefulWidget {
  @override
  _PanelTakenMedicinesScreenState createState() =>
      _PanelTakenMedicinesScreenState();
}

class _PanelTakenMedicinesScreenState extends State<PanelTakenMedicinesScreen> {
  int prescriptionCount;
  LoadTakenMedicines takenMedicineIsReady;
  int doctorUid;
  int uid;
  int type;
  TakenMedicinesProvider provider;

  @override
  void didChangeDependencies() {
    final provider = Provider.of<TakenMedicinesProvider>(context);
    if (this.provider != provider) {
      this.provider = provider;
      Future.microtask(() async {
        takenMedicineIsReady = await provider.fetchTakenMedicines(
          doctorUid: uid,
          type: type,
        );
      });
    }
    super.didChangeDependencies();
  }

  @override
  void initState() {
    getUserUidAndType();
    super.initState();
  }

  getUserUidAndType() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      uid = prefs.getInt("uid");
      doctorUid = prefs.getInt("doctorUid");
      type = prefs.getInt("type");
    });
  }

  @override
  Widget build(BuildContext context) {
    TakenMedicinesProvider takenMedicinesProvider =
        Provider.of<TakenMedicinesProvider>(context);
    final takenMedicinesList = takenMedicinesProvider.takenMedicinesList;

    return Scaffold(
      body: SafeArea(
        child: takenMedicineIsReady != null
            ? SingleChildScrollView(
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 30),
                  width: double.infinity,
                  child: Column(
                    children: [
                      AppBarWithBackButton(),
                      Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: SearchBar(
                          hintText: "Reçete arayın",
                        ),
                      ),
                      SizedBox(
                        height: 50,
                      ),
                      TakenList(
                        takenMedicineIsReady: takenMedicineIsReady,
                        takenMedicinesList: takenMedicinesList,
                        type: type,
                      ),
                    ],
                  ),
                ),
              )
            : Loading(),
      ),
    );
  }
}
