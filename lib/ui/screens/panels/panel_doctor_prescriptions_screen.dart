import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../widgets/app_bar/app_bar_with_back_button.dart';
import '../../widgets/search_bar.dart';
import '../../widgets/prescription_list/prescription_list.dart';
import '../../../providers/prescriptions_provider.dart';

class PanelDoctorPrescriptionsScreen extends StatefulWidget {
  @override
  _PanelDoctorPrescriptionsScreenState createState() =>
      _PanelDoctorPrescriptionsScreenState();
}

class _PanelDoctorPrescriptionsScreenState
    extends State<PanelDoctorPrescriptionsScreen> {
  LoadPrescription prescriptionIsReady;
  PrescriptionsProvider provider;
  int doctorUid;
  int uid;
  int type;

  @override
  void didChangeDependencies() {
    final provider = Provider.of<PrescriptionsProvider>(context);
    if (this.provider != provider) {
      this.provider = provider;
      Future.microtask(() async {
        prescriptionIsReady = await provider.fetchPrescriptions(
          doctorUid: doctorUid,
          uid: uid,
          type: type,
        );
      });
    }
    super.didChangeDependencies();
  }

  @override
  void initState() {
    getUserUidAndType();
    // getPrescriptions();
    super.initState();
  }

  getUserUidAndType() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      uid = prefs.getInt("uid");
      doctorUid = prefs.getInt("doctorUid");
      type = prefs.getInt("type");
    });
    // getPrescriptions();
  }

  @override
  Widget build(BuildContext context) {
    PrescriptionsProvider prescriptionsProvider =
        Provider.of<PrescriptionsProvider>(context);
    final prescriptionsList = prescriptionsProvider.doctorPrescriptionsList;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
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
                PrescriptionList(
                  prescriptionIsReady: prescriptionIsReady,
                  prescriptionsList: prescriptionsList,
                  doctorUid: doctorUid,
                  uid: uid,
                  type: type,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
