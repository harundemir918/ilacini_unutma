import 'package:flutter/material.dart';

class PrescriptionListTile extends StatelessWidget {
  final String prescriptionCode;
  final String prescriptionPatientName;
  final String prescriptionPatientSurname;
  final String prescriptionDate;

  PrescriptionListTile({
    this.prescriptionCode,
    this.prescriptionPatientName,
    this.prescriptionPatientSurname,
    this.prescriptionDate,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        // Navigator.push(
        //   context,
        //   MaterialPageRoute(
        //     builder: (context) =>
        //         PanelDoctorPatientPrescriptionsScreen(
        //           uid: widget.uid,
        //           patientUid: int.parse(patient["patientID"]),
        //         ),
        //   ),
        // );
      },
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Container(
              margin: EdgeInsets.only(left: 10),
              width: 175,
              height: 100,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    prescriptionCode,
                    style: TextStyle(
                      fontSize: 18,
                    ),
                  ),
                  FittedBox(
                    fit: BoxFit.contain,
                    child: Text(
                      "$prescriptionPatientName $prescriptionPatientSurname",
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                  ),
                  Text(
                    prescriptionDate,
                    style: TextStyle(
                      color: Color(0xff797979),
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            IconButton(
              icon: Icon(Icons.arrow_forward),
              iconSize: 30,
              onPressed: () {},
            ),
          ],
        ),
      ),
    );
  }
}
