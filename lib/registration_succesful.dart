import 'dart:convert';
import 'dart:io';

import 'package:ariaquickpay/utils.dart';
import 'package:flutter/material.dart';
import 'dart:ui';
import '/colors.dart' as mycolor;
//import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'urls.dart' as myurls;
import 'utils.dart';
import 'models/models.dart';
import 'login_page.dart';

class registrationSuccessful extends StatelessWidget {
  const registrationSuccessful(
      {Key? key, required this.emailAddress, required this.client})
      : super(key: key);
  final String emailAddress;
  final Client client;
  //String userPK = '';
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          height: double.infinity,
          width: double.infinity,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                mycolor.AppColor.registerPageBackground,
                mycolor.AppColor.registerPageHeaderColor1,
              ],
            ),
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Card(
                  color: Colors.white,
                  child: Container(
                    height: 200,
                    width: MediaQuery.of(context).size.width,
                    child: Column(
                      children: [
                        SizedBox(
                          height: 20,
                        ),
                        Row(
                          children: [
                            SizedBox(
                              width: 20,
                            ),
                            Text(
                              "Registration Successful",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Row(
                          children: [
                            SizedBox(
                              width: 20,
                            ),
                            Text(
                              "A link was sent to your email address at \n${emailAddress}. Click the link to verify \nyour email before you can login to your \n Ariaquickpay account.",
                            ),
                          ],
                        ),
                        Expanded(
                          child: Container(),
                        ),
                        Row(
                          children: [
                            SizedBox(
                              width: 20,
                            ),
                            GestureDetector(
                                child: Text(
                                  "Resend link?",
                                  style: TextStyle(color: Colors.blue),
                                ),
                                onTap: () {}),
                            Expanded(
                              child: Container(),
                            ),
                            GestureDetector(
                                child: Text(
                                  "Got It",
                                  style: TextStyle(color: Colors.blue),
                                ),
                                onTap: () async {
                                  //print("clicked");
                                  String userToken =
                                      UserSimplePreferences.getUserToken() ??
                                          '';
                                  //print(userToken);
                                  if (userToken != '') {
                                    var verificationResponse =
                                        await client.post(
                                      Uri.parse(myurls
                                          .AriaApiEndpoints.confirmStatus),
                                      body: {
                                        'email': UserSimplePreferences
                                            .getUserEmail(),
                                      },
                                      headers: {
                                        HttpHeaders.authorizationHeader:
                                            'Token $userToken',
                                      },
                                    );
                                    List<UserVerificationandPkResponse>
                                        verification_response = [];
                                    if (verificationResponse.statusCode ==
                                        200) {
                                      var verificationResponsejsons = json
                                          .decode(verificationResponse.body);
                                      verification_response.add(
                                          UserVerificationandPkResponse
                                              .fromJson(
                                                  verificationResponsejsons));
                                      if (verification_response[0]
                                              .emailVerified ==
                                          "true") {
                                        await UserSimplePreferences
                                            .setUserEmailVerified(true);
                                        await UserSimplePreferences.setUserPk(
                                            verification_response[0].PkUser);
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) {
                                              return loginPage(
                                                client: client,
                                              );
                                            },
                                          ),
                                        );
                                      }
                                    }
                                  }
                                }),
                            SizedBox(
                              width: 20,
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 30,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
