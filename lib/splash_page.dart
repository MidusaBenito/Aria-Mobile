import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:http/http.dart' as http;
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:page_transition/page_transition.dart';
//import 'colors.dart' as mycolor;
import 'intro_screens/intro_screen_1.dart';
import 'intro_screens/intro_screen_2.dart';
import 'intro_screens/intro_screen_3.dart';
import 'register_page.dart';
import 'utils.dart';
import 'login_page.dart';
import 'registration_succesful.dart';

class splashPage extends StatefulWidget {
  const splashPage({Key? key, required this.client}) : super(key: key);
  final Client client;

  @override
  State<splashPage> createState() => _splashPageState();
}

class _splashPageState extends State<splashPage> {
  //controller to keep track of what page we are on
  PageController _controller = PageController();

  //keep track if we are on the last page or not
  bool onLastPage = false;
  bool onFirstPage = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PageView(
            controller: _controller,
            onPageChanged: (index) {
              setState(() {
                onLastPage = (index == 2);
                onFirstPage = (index == 0);
              });
            },
            children: [
              introScreenOne(),
              introScreenTwo(),
              introScreenThree(),
            ],
          ),
          Container(
              alignment: Alignment(0, 0.8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  //skip or back
                  onLastPage
                      ? GestureDetector(
                          onTap: () {
                            onFirstPage = false;
                            _controller.jumpToPage(1);
                          },
                          child: Text(
                            'back',
                            style: TextStyle(
                                fontSize: 15, fontWeight: FontWeight.w500),
                          ),
                        )
                      : onFirstPage
                          ? GestureDetector(
                              onTap: () {
                                _controller.jumpToPage(2);
                              },
                              child: Text(
                                'skip',
                                style: TextStyle(
                                    fontSize: 15, fontWeight: FontWeight.w500),
                              ),
                            )
                          : GestureDetector(
                              onTap: () {
                                _controller.jumpToPage(0);
                              },
                              child: Text(
                                'back',
                                style: TextStyle(
                                    fontSize: 15, fontWeight: FontWeight.w500),
                              ),
                            ),
                  //dot indicators
                  SmoothPageIndicator(controller: _controller, count: 3),

                  //next or done
                  onLastPage
                      ? GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) {
                                  return registerPage(
                                    client: widget.client,
                                  );
                                },
                              ),
                            );
                          },
                          child: Text(
                            'start',
                            style: TextStyle(
                                fontSize: 15, fontWeight: FontWeight.w500),
                          ),
                        )
                      : GestureDetector(
                          onTap: () {
                            _controller.nextPage(
                              duration: Duration(milliseconds: 500),
                              curve: Curves.easeIn,
                            );
                          },
                          child: Text(
                            'next',
                            style: TextStyle(
                                fontSize: 15, fontWeight: FontWeight.w500),
                          ),
                        ),
                ],
              )),
        ],
      ),
    );
  }
}

class myAnimatedScreen extends StatelessWidget {
  myAnimatedScreen({Key? key}) : super(key: key);

  //@override
  //void initState()
  Client client = http.Client();
  final bool isUserRegistered =
      UserSimplePreferences.getUserRegistered() ?? false;
  final bool isEmailVerified =
      UserSimplePreferences.getUserEmailVerified() ?? false;
  final String userEmail = UserSimplePreferences.getUserEmail() ?? '';

  @override
  Widget build(BuildContext context) {
    return AnimatedSplashScreen(
      backgroundColor: Colors.white,
      splash: Column(
        children: [
          Expanded(
            child: Image.asset(
              "assets/images/aria-1.png",
              height: 400,
            ),
          ),
          Text(
            "Welcome to Ariaquickpay",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Colors.black,
            ),
          ),
          // CircularProgressIndicator(),
        ],
      ),
      //nextScreen: isUserRegistered == true ? loginPage() : splashPage(),
      nextScreen: isUserRegistered == true && isEmailVerified == true
          ? loginPage(
              client: client,
            )
          : isUserRegistered == true && isEmailVerified == false
              ? registrationSuccessful(
                  emailAddress: userEmail,
                  client: client,
                )
              : splashPage(
                  client: client,
                ),
      //splashIconSize: 100,
      duration: 3000,
      splashTransition: SplashTransition.scaleTransition,
      pageTransitionType: PageTransitionType.leftToRightWithFade,
      animationDuration: Duration(milliseconds: 1500),
    );
  }
}
