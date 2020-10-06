import 'package:flutter/material.dart';

class AppBarWithLogoutButton extends StatelessWidget {
  void goBack(BuildContext context) {
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // SizedBox(width: 45,),
        Image.asset(
          "assets/images/horizontal_logo.png",
          width: 200,
          height: 50,
        ),
        // IconButton(
        //   icon: Icon(
        //     Icons.logout,
        //     color: Colors.white,
        //     size: 25,
        //   ),
        //   onPressed: () => goBack(context),
        // ),
      ],
    );
  }
}
