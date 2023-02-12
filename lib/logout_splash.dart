import 'dart:ui';

import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:ariaquickpay/login_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:http/http.dart';
import 'package:page_transition/page_transition.dart';

class logOutSplash extends StatelessWidget {
  const logOutSplash({Key? key, required this.client}) : super(key: key);
  final Client client;
  @override
  Widget build(BuildContext context) {
    return AnimatedSplashScreen(
      backgroundColor: Color.fromRGBO(94, 167, 203, 1),
      splash: Column(
        children: [
          Expanded(child: Container()),
          CircularProgressIndicator(
            color: Colors.white,
          ),
          SizedBox(
            height: 5,
          ),
          Text(
            'Logging you out...',
            style: TextStyle(color: Colors.white),
          ),
          Expanded(child: Container()),
        ],
      ),
      nextScreen: loginPage(
        client: client,
      ),
      duration: 2500,
      splashTransition: SplashTransition.slideTransition,
      pageTransitionType: PageTransitionType.leftToRightWithFade,
      animationDuration: Duration(milliseconds: 1500),
    );
  }
}
