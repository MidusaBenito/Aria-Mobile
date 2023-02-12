import 'dart:convert';
//import 'dart:html';
import 'dart:io';
import 'dart:ui';

import 'package:ariaquickpay/finger_print_auth.dart';
import 'package:ariaquickpay/registration_succesful.dart';
import 'package:ariaquickpay/utils.dart';
import 'package:flutter/material.dart' hide Badge;
import 'package:flutter/services.dart';
import 'package:http/http.dart';
import 'package:local_auth/local_auth.dart';
import 'package:local_auth_ios/local_auth_ios.dart';
import '/colors.dart' as mycolor;
import 'urls.dart' as myurls;
import 'models/models.dart';
import 'payments.dart';

class loginPage extends StatefulWidget {
  const loginPage({Key? key, required this.client}) : super(key: key);
  final Client client;
  @override
  State<loginPage> createState() => _loginPageState();
}

class _loginPageState extends State<loginPage> {
  bool isPasswordVisible = false;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  String loginError = "";
  final my_token = UserSimplePreferences.getUserToken() ?? '';

  //setting up userdetails
  final bool isUserRegistered =
      UserSimplePreferences.getUserRegistered() ?? false;
  //final bool isEmailVerified =
  //UserSimplePreferences.getUserEmailVerified() ?? false;
  //final String userEmail = UserSimplePreferences.getUserEmail() ?? '';

  Future<bool> _onWillPop() async {
    return (await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: new Text('Are you sure?'),
            content: new Text('Do you want to exit Ariaquickpay?'),
            actions: <Widget>[
              TextButton(
                onPressed: () =>
                    Navigator.of(context).pop(false), //<-- SEE HERE
                child: new Text('No'),
              ),
              TextButton(
                onPressed: () =>
                    //Navigator.of(context).pop(true), // <-- SEE HERE
                    SystemNavigator.pop(),
                child: new Text('Yes'),
              ),
            ],
          ),
        )) ??
        false;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: SafeArea(
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          body: Container(
            height: double.infinity,
            width: double.infinity,
            alignment: Alignment.center,
            color: mycolor.AppColor.loginPageBackground,
            child: Padding(
              padding: EdgeInsets.only(
                left: 20,
                right: 20,
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    Expanded(child: Container()),
                    Stack(
                      children: [
                        Container(
                          margin: const EdgeInsets.only(top: 50),
                          //color: Colors.white,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.all(Radius.circular(20)),
                          ),
                          child: Column(
                            children: [
                              SizedBox(
                                height: 52,
                              ),
                              Text(
                                "Hello",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Text("Sign Into Your Account",
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                  )),
                              SizedBox(
                                height: 20,
                              ),
                              showAlert(),
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 30)
                                    .copyWith(bottom: 10),
                                child: TextFormField(
                                  controller: emailController,
                                  style: TextStyle(
                                      color: Color.fromARGB(255, 0, 0, 0),
                                      fontSize: 14.5),
                                  decoration: InputDecoration(
                                      prefixIconConstraints:
                                          BoxConstraints(minWidth: 45),
                                      prefixIcon: Icon(
                                        Icons.email,
                                        color: Color.fromRGBO(2, 47, 78, 1),
                                        size: 22,
                                      ),
                                      border: InputBorder.none,
                                      hintText: 'Enter Email',
                                      hintStyle: TextStyle(
                                          color: Color.fromRGBO(32, 31, 31, 1),
                                          fontSize: 13),
                                      enabledBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(100)
                                              .copyWith(
                                                  bottomRight:
                                                      Radius.circular(0)),
                                          borderSide: BorderSide(
                                              color: Color.fromRGBO(
                                                  8, 6, 6, 0.384))),
                                      focusedBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(100)
                                              .copyWith(
                                                  bottomRight:
                                                      Radius.circular(0)),
                                          borderSide: BorderSide(
                                              color: Color.fromARGB(
                                                  179, 3, 127, 155)))),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Email cannot be empty!';
                                    }
                                    if (value.isNotEmpty &&
                                        !RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                            .hasMatch(value)) {
                                      return 'Enter a valid email address!';
                                    }
                                    return null;
                                  },
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 30)
                                    .copyWith(bottom: 10),
                                child: TextFormField(
                                  controller: passwordController,
                                  style: TextStyle(
                                      color: Color.fromRGBO(0, 0, 0, 1),
                                      fontSize: 14.5),
                                  obscureText: isPasswordVisible ? false : true,
                                  decoration: InputDecoration(
                                      prefixIconConstraints:
                                          BoxConstraints(minWidth: 45),
                                      prefixIcon: Icon(
                                        Icons.lock,
                                        color: Color.fromRGBO(2, 47, 78, 1),
                                        size: 22,
                                      ),
                                      suffixIconConstraints: BoxConstraints(
                                          minWidth: 45, maxWidth: 46),
                                      suffixIcon: GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            isPasswordVisible =
                                                !isPasswordVisible;
                                          });
                                        },
                                        child: Icon(
                                          isPasswordVisible
                                              ? Icons.visibility
                                              : Icons.visibility_off,
                                          color: Color.fromRGBO(2, 47, 78, 1),
                                          size: 22,
                                        ),
                                      ),
                                      border: InputBorder.none,
                                      hintText: 'Enter Password',
                                      hintStyle: TextStyle(
                                          color: Color.fromRGBO(32, 31, 31, 1),
                                          fontSize: 13),
                                      enabledBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(100)
                                              .copyWith(
                                                  bottomRight:
                                                      Radius.circular(0)),
                                          borderSide: BorderSide(
                                              color: Color.fromRGBO(
                                                  8, 6, 6, 0.384))),
                                      focusedBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(100)
                                                  .copyWith(
                                                      bottomRight:
                                                          Radius.circular(0)),
                                          borderSide: BorderSide(
                                              color:
                                                  Color.fromARGB(179, 3, 127, 155)))),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Enter your password!';
                                    }
                                    return null;
                                  },
                                ),
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              GestureDetector(
                                onTap: () async {
                                  FocusManager.instance.primaryFocus?.unfocus();
                                  if (_formKey.currentState!.validate()) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                          content: Text('Logging in...'),
                                          duration:
                                              Duration(milliseconds: 300)),
                                    );
                                    var response = await widget.client.post(
                                      Uri.parse(
                                          myurls.AriaApiEndpoints.loginUrl),
                                      body: {
                                        'username': emailController.text,
                                        'password': passwordController.text
                                      },
                                    );
                                    List<UserLoggedIn> user_logged_in_response =
                                        [];
                                    //List<UserLoggedError> user_logged_error = [];
                                    if (response.statusCode == 200) {
                                      var responseJsons =
                                          json.decode(response.body);
                                      user_logged_in_response.add(
                                          UserLoggedIn.fromJson(responseJsons));
                                      if (user_logged_in_response[0]
                                              .Token
                                              .length >
                                          1) {
                                        await UserSimplePreferences
                                            .setUserEmail(emailController.text);

                                        await UserSimplePreferences
                                            .setUserRegistered(true);
                                        await UserSimplePreferences
                                            .setUserToken(
                                                user_logged_in_response[0]
                                                    .Token);
                                        //print(user_logged_in_response[0].Token);
                                        //emailController.clear();
                                        //passwordController.clear();
                                        var verificationResponse =
                                            await widget.client.post(
                                          Uri.parse(myurls
                                              .AriaApiEndpoints.confirmStatus),
                                          body: {
                                            'email': UserSimplePreferences
                                                .getUserEmail(),
                                          },
                                          headers: {
                                            HttpHeaders.authorizationHeader:
                                                'Token ${user_logged_in_response[0].Token}',
                                          },
                                        );
                                        List<UserVerificationandPkResponse>
                                            verification_response = [];
                                        if (verificationResponse.statusCode ==
                                            200) {
                                          var verificationResponsejsons =
                                              json.decode(
                                                  verificationResponse.body);
                                          verification_response.add(
                                              UserVerificationandPkResponse
                                                  .fromJson(
                                                      verificationResponsejsons));
                                          if (verification_response[0]
                                                  .emailVerified ==
                                              "true") {
                                            await UserSimplePreferences
                                                .setUserEmailVerified(true);
                                            await UserSimplePreferences
                                                .setUserPk(
                                                    verification_response[0]
                                                        .PkUser);
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) {
                                                  return Payments(
                                                    client: widget.client,
                                                  );
                                                },
                                              ),
                                            );
                                          }
                                          if (verification_response[0]
                                                  .emailVerified ==
                                              "false") {
                                            var userEmail =
                                                UserSimplePreferences
                                                        .getUserEmail() ??
                                                    '';
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) {
                                                  return registrationSuccessful(
                                                    emailAddress: userEmail,
                                                    client: widget.client,
                                                  );
                                                },
                                              ),
                                            );
                                          }
                                        }
                                      }
                                    } else {
                                      setState(() {
                                        //passwordController.clear();
                                        loginError =
                                            "Unable to login. Your email or password may be incorrect";
                                      });
                                    }
                                  }
                                },
                                child: Container(
                                  height: 53,
                                  width: double.infinity,
                                  margin: EdgeInsets.symmetric(horizontal: 30),
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                      boxShadow: [
                                        BoxShadow(
                                            blurRadius: 4,
                                            color:
                                                Colors.black12.withOpacity(.2),
                                            offset: Offset(2, 2))
                                      ],
                                      borderRadius: BorderRadius.circular(100)
                                          .copyWith(
                                              bottomRight: Radius.circular(0)),
                                      gradient: LinearGradient(colors: [
                                        Color.fromARGB(255, 10, 75, 92),
                                        Color.fromARGB(255, 10, 75, 92)
                                      ])),
                                  child: Text('Login',
                                      style: TextStyle(
                                          color: Colors.white.withOpacity(1),
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold)),
                                ),
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              my_token != ''
                                  ? Column(
                                      children: [
                                        Text("OR"),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        GestureDetector(
                                          onTap: () async {
                                            final biometrics =
                                                await LocalAuthApi
                                                    .getBiometrics();
                                            bool hasFingerPrint = false;
                                            //biometrics.contains(
                                            // BiometricType.strong);
                                            if (biometrics.contains(
                                                    BiometricType.strong) ||
                                                biometrics.contains(
                                                    BiometricType.weak)) {
                                              hasFingerPrint = true;
                                            }
                                            //print(biometrics);
                                            //print(
                                            //"fingerprint: $hasFingerPrint");
                                            if (hasFingerPrint == true) {
                                              final isAuthenticated =
                                                  await LocalAuthApi
                                                      .authenticate();
                                              if (isAuthenticated) {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) {
                                                      return Payments(
                                                        client: widget.client,
                                                      );
                                                    },
                                                  ),
                                                );
                                              }
                                            } else {
                                              showDialog(
                                                  context: context,
                                                  builder: (_) => AlertDialog(
                                                        content: Text(
                                                          'Fingerprint authentication is not supported on your device!',
                                                          style: TextStyle(
                                                            fontSize: 13,
                                                            color:
                                                                Color.fromARGB(
                                                                    255,
                                                                    224,
                                                                    17,
                                                                    17),
                                                          ),
                                                        ),
                                                      ));
                                              //print('fingerprint not supported!');
                                            }
                                          },
                                          child: Column(
                                            children: [
                                              Icon(
                                                Icons.fingerprint,
                                                size: 45,
                                              ),
                                              SizedBox(
                                                height: 10,
                                              ),
                                              Text(
                                                "USE TOUCH ID",
                                                style: TextStyle(
                                                  fontWeight: FontWeight.w400,
                                                  fontSize: 13,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        SizedBox(
                                          height: 40,
                                        ),
                                      ],
                                    )
                                  : Container(),
                            ],
                          ),
                        ),
                        Container(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CircleAvatar(
                                backgroundColor: Colors.white,
                                radius: 50,
                                child: Image.asset(
                                  "assets/images/aria-1.png",
                                  height: 50,
                                  width: 50,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Expanded(child: Container()),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget showAlert() {
    if (loginError != "") {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          color: Colors.amberAccent,
          width: MediaQuery.of(context).size.width,
          padding: EdgeInsets.all(8.0),
          child: Row(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: Icon(Icons.error_outline),
              ),
              Expanded(
                child: Text(
                  loginError,
                  maxLines: 3,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: IconButton(
                  icon: Icon(Icons.close),
                  onPressed: () {
                    setState(() {
                      loginError = "";
                    });
                  },
                ),
              )
            ],
          ),
        ),
      );
    }
    return SizedBox(
      height: 0,
    );
  }
}
