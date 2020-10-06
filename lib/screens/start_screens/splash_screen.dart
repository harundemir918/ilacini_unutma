import 'package:flutter/material.dart';
import 'package:custom_splash/custom_splash.dart';
import 'package:ilacini_unutma/screens/start_screens/onboarding_screen.dart';

import '../../constants.dart';

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    return CustomSplash(
      imagePath: "assets/images/splash_logo.png",
      backGroundColor: backgroundColor,
      animationEffect: "fade-in",
      logoSize: 200,
      home: OnBoardingScreen(), // wrapper yazılacak
      duration: 2000,
      type: CustomSplashType.StaticDuration,
    );
  }
}
