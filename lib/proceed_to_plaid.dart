import 'package:ariaquickpay/choose_existing_cards.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'dart:convert';
import 'package:ariaquickpay/bills_profile.dart';
import 'package:ariaquickpay/models/billers.dart';
import 'package:ariaquickpay/models/category.dart';
import 'package:ariaquickpay/models/models.dart';
import 'package:ariaquickpay/utils.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';
import 'package:plaid_flutter/plaid_flutter.dart';
//import 'package:snippet_coder_utils/FormHelper.dart';
import 'aria_providers.dart';
import 'urls.dart' as myurls;
import 'colors.dart' as mycolor;
import 'package:badges/badges.dart';
import 'my_widgets.dart';
import 'dart:io';

class proceedToPlaid extends StatelessWidget {
  proceedToPlaid({
    Key? key,
    required this.client,
  }) : super(key: key);
  final Client client;
  late LinkTokenConfiguration _linkTokenConfiguration;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          alignment: Alignment.center,
          child: Column(
            children: [
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Color.fromRGBO(94, 167, 203, 1),
                      Color.fromRGBO(94, 167, 203, 1),
                    ],
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15.0),
                  child: Column(
                    children: [
                      //SizedBox(
                      //height: 45,
                      //),
                      Row(
                        children: [
                          BackButton(
                            color: Colors.white,
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          ),
                        ],
                      ),

                      Row(
                        children: [
                          SizedBox(
                            width: 15,
                          ),
                          //Text(billerName),
                          Expanded(child: Container()),
                          //Text('Bill Due On: '),
                          SizedBox(
                            width: 15,
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                  child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Color.fromRGBO(238, 236, 236, 1),
                      Color.fromRGBO(238, 236, 236, 1),
                    ],
                  ),
                ),
                width: double.infinity,
                alignment: Alignment.topCenter,
                padding: const EdgeInsets.symmetric(horizontal: 30.0),
                child: Column(
                  children: [
                    SizedBox(
                      height: 15,
                    ),
                    Text(
                      "Link bank account to Ariaquickpay",
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Card(
                      color: Colors.black,
                      elevation: 2.0,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5.0)),
                      child: Row(
                        children: [
                          SizedBox(
                            width: 30,
                            child: Container(
                                decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  Color.fromARGB(255, 0, 0, 0),
                                  Color.fromARGB(255, 0, 0, 0),
                                ],
                              ),
                            )),
                          ),
                          Expanded(
                              //width: 363,
                              child: Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  Color.fromARGB(255, 255, 255, 255),
                                  Color.fromARGB(255, 255, 255, 255),
                                ],
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(
                                  20.0, 8.0, 20.0, 8.0),
                              child: Text(
                                "View your bank account balance in real time and conveniently pay your bills directly from the app.",
                                style: TextStyle(
                                  fontSize: 15,
                                ),
                              ),
                            ),
                          )),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Card(
                      color: Colors.black,
                      elevation: 2.0,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5.0)),
                      child: Row(
                        children: [
                          SizedBox(
                            width: 30,
                            child: Container(
                                decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  Color.fromARGB(255, 0, 0, 0),
                                  Color.fromARGB(255, 0, 0, 0),
                                ],
                              ),
                            )),
                          ),
                          Expanded(
                              //width: 363,
                              child: Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  Color.fromARGB(255, 255, 255, 255),
                                  Color.fromARGB(255, 255, 255, 255),
                                ],
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(
                                  20.0, 8.0, 20.0, 8.0),
                              child: Text(
                                "Please note that Ariaquickpay uses Plaid to securely link your bank account. The security of your data is therefore guaranteed.",
                                style: TextStyle(
                                  fontSize: 15,
                                ),
                              ),
                            ),
                          )),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Card(
                      color: Colors.black,
                      elevation: 2.0,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5.0)),
                      child: Row(
                        children: [
                          SizedBox(
                            width: 30,
                            child: Container(
                                decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  Color.fromARGB(255, 0, 0, 0),
                                  Color.fromARGB(255, 0, 0, 0),
                                ],
                              ),
                            )),
                          ),
                          Expanded(
                              //width: 363,
                              child: Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  Color.fromARGB(255, 255, 255, 255),
                                  Color.fromARGB(255, 255, 255, 255),
                                ],
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(
                                  20.0, 8.0, 20.0, 8.0),
                              child: Text(
                                "By clicking on the button below, you agree to link your bank account with Ariaquickpay. You will be redirected to an external page to complete the process.",
                                style: TextStyle(
                                  fontSize: 15,
                                ),
                              ),
                            ),
                          )),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        final userToken =
                            UserSimplePreferences.getUserToken() ?? '';
                        final url = myurls.AriaApiEndpoints.getPlaidToken;
                        List<plaidToken> plaid_link_token = [];
                        if (userToken != '') {
                          var getPlaidLinkTokenResponse = await client.get(
                            Uri.parse(url),
                            headers: {
                              HttpHeaders.authorizationHeader:
                                  'Token $userToken',
                            },
                          );
                          if (getPlaidLinkTokenResponse.statusCode == 200) {
                            var getPlaidLinkTokenResponseJsons =
                                json.decode(getPlaidLinkTokenResponse.body);
                            plaid_link_token.add(plaidToken
                                .fromJson(getPlaidLinkTokenResponseJsons));
                            String myPlaidLinkToken =
                                plaid_link_token[0].linkToken;
                            if (myPlaidLinkToken ==
                                "error creating link token") {
                            } else {
                              _linkTokenConfiguration = LinkTokenConfiguration(
                                token: myPlaidLinkToken,
                              );
                              PlaidLink.onSuccess(_onSuccessCallback);
                              PlaidLink.onEvent(_onEventCallback);
                              PlaidLink.onExit(_onExitCallback);
                              PlaidLink.open(
                                  configuration: _linkTokenConfiguration);
                            }
                          }
                        } //end if
                      },
                      child: Text("Proceed to Link Bank Account"),
                    ),
                  ],
                ),
              )),
            ],
          ),
        ),
      ),
    );
  }

  void _onSuccessCallback(String publicToken, LinkSuccessMetadata metadata) {
    //print("onSuccess: $publicToken, metadata: ${metadata.description()}");
    //print('why');
    print('This is: ${metadata.toString()}');
    //print('is it');
    //metadata.accounts.forEach((account) {
    //print("Account Id: ${account.id}");
    //print("Account Name: ${account.name}");
    //print("Account Mask: ${account.mask}");
    //print("Account Subtype: ${account.subtype}");
    //print('account number': ${account.officialName});
    //});
  }

  void _onEventCallback(String event, LinkEventMetadata metadata) {
    //print("onEvent: $event, metadata: ${metadata.description()}");
  }

  void _onExitCallback(LinkError? error, LinkExitMetadata metadata) {
    //print("onExit metadata: ${metadata.description()}");

    if (error != null) {
      //print("onExit error: ${error.description()}");
    }
  }
}
