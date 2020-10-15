import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'services/notification_service.dart';

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
  NotificationService notificationService = NotificationService();
  String notifyContent;

  @override
  void initState() {
    notificationService.configOneSignal();
    super.initState();
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
        scaffoldBackgroundColor: primaryColor,
      ),
      home: SplashScreen(),
    );
  }
}
