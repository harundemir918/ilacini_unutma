import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:http/http.dart' as http;
import '../constants.dart';

class NotificationService {
  void configOneSignal() async {
    await OneSignal.shared.init("9b829111-16be-422d-908d-7f02d9238b98");
    OneSignal.shared
        .setInFocusDisplayType(OSNotificationDisplayType.notification);
    OneSignal.shared.setNotificationReceivedHandler((notification) {
      print(notification.jsonRepresentation().replaceAll('\\n', '\n'));
    });
    notificationOpened();
  }

  void notificationOpened() {
    OneSignal.shared
        .setNotificationOpenedHandler((OSNotificationOpenedResult result) {
      print(result.notification.jsonRepresentation().replaceAll("\\n", "\n"));
      if (result.action.actionId == "yes") {
        print(result.notification.payload.additionalData["doctorUid"]);
        print(result.notification.payload.additionalData["doctorUid"]);
        print(result.notification.payload.additionalData["medicineUid"]);
        print(result.notification.payload.additionalData["code"]);
        updateTakenMedicines(
          doctorUid: result.notification.payload.additionalData["doctorUid"],
          patientUid: result.notification.payload.additionalData["patientUid"],
          medicineUid:
              result.notification.payload.additionalData["medicineUid"],
          code: result.notification.payload.additionalData["code"],
        );
      }
    });
  }

  void sendNotification({
    String doctorUid,
    String patientUid,
    String patientDevicePlayerId,
    String medicineUid,
    String medicineName,
    String image,
    String time,
    String code,
  }) async {
    var playerId = patientDevicePlayerId;

    await OneSignal.shared.postNotification(OSCreateNotification(
      playerIds: [playerId],
      content: "$medicineName ilacınızı aldınız mı?",
      heading: "İlacını Unutma",
      buttons: [
        OSActionButton(text: "Aldım", id: "taken"),
      ],
      delayedOption: OSCreateNotificationDelayOption.timezone,
      deliveryTimeOfDay: time,
      bigPicture: image,
      additionalData: {
        "doctorUid": "1",
        "patientUid": "3",
        "medicineUid": "5",
        "code": "ABCD1234",
      },
    ));
  }

  updateTakenMedicines({
    String doctorUid,
    String patientUid,
    String medicineUid,
    String code,
  }) async {
    var url = "$apiUrl/taken_medicines.php";
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
}
