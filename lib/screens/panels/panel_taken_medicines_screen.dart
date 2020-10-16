import 'package:flutter/material.dart';

import '../../widgets/app_bar_with_back_button.dart';
import '../../widgets/search_bar.dart';
import '../../widgets/taken_list.dart';

class PanelTakenMedicinesScreen extends StatefulWidget {
  @override
  _PanelTakenMedicinesScreenState createState() =>
      _PanelTakenMedicinesScreenState();
}

class _PanelTakenMedicinesScreenState
    extends State<PanelTakenMedicinesScreen> {
  @override
  Widget build(BuildContext context) {
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
                TakenList(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
