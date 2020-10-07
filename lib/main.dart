import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

import 'screens/start_screens/splash_screen.dart';
import 'constants.dart';

void main() async {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String notifyContent;
  @override
  void initState() {
    configOneSignal();
    super.initState();
  }

  void configOneSignal() async {
    await OneSignal.shared.init("9b829111-16be-422d-908d-7f02d9238b98");
    OneSignal.shared.setInFocusDisplayType(OSNotificationDisplayType.notification);
    OneSignal.shared.setNotificationReceivedHandler((notification) {
      setState(() {
        notifyContent = notification.jsonRepresentation().replaceAll('\\n', '\n');
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    print(notifyContent);
    return MaterialApp(
      title: 'İlacını Unutma',
      theme: ThemeData(
        textTheme: GoogleFonts.montserratTextTheme(
          Theme.of(context).textTheme,
        ),
        scaffoldBackgroundColor: backgroundColor,
      ),
      home: SplashScreen(),
    );
  }
}
