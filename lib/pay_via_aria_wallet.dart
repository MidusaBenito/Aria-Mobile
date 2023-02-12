import 'package:ariaquickpay/hero_dialog_route.dart';
import 'package:ariaquickpay/stripe_new_card.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'dart:convert';
import 'package:ariaquickpay/bills_profile.dart';
import 'package:ariaquickpay/models/billers.dart';
import 'package:ariaquickpay/models/category.dart';
import 'package:ariaquickpay/models/models.dart';
import 'package:ariaquickpay/utils.dart';
import 'package:flutter/material.dart' hide Badge;
import 'package:flutter_credit_card/credit_card_widget.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:provider/provider.dart';

import 'aria_providers.dart';
import 'custom_rect_tween.dart';
import 'urls.dart' as myurls;
import 'colors.dart' as mycolor;
import 'package:badges/badges.dart';
import 'my_widgets.dart';
import 'dart:io';

class payViaAriaWallet extends StatelessWidget {
  const payViaAriaWallet({
    Key? key,
    required this.client,
    required this.billingAccntNumber,
    required this.bill_id,
    required this.first_name,
    required this.last_name,
    required this.paidAmount,
    required this.billerName,
  }) : super(key: key);
  final Client client;
  final String billingAccntNumber;
  final String bill_id;
  final String first_name;
  final String last_name;
  final String paidAmount;
  final String billerName;
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
                      // height: 45,
                      //),
                      Row(
                        children: [
                          BackButton(
                            color: Colors.white,
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          ),
                          Text(
                            "Pay With Aria Wallet",
                            style: TextStyle(
                                color: Color.fromRGBO(238, 236, 236, 1),
                                fontSize: 16,
                                fontWeight: FontWeight.w500),
                          ),
                        ],
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
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30.0),
                  child: Column(
                    children: [
                      SizedBox(
                        height: 20,
                      ),
                      Card(
                        color: Colors.white,
                        elevation: 2.0,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5.0)),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15.0),
                          child: Column(
                            children: [
                              SizedBox(
                                height: 15,
                              ),
                              Row(
                                children: [
                                  Text(
                                    "Your Aria Wallet Balance is: ",
                                    style:
                                        TextStyle(fontWeight: FontWeight.w500),
                                  ),
                                  SizedBox(
                                    width: 20,
                                  ),
                                  walletBalance(
                                    client: client,
                                    colString: 'blue',
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 15,
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15.0),
                        child: Column(
                          children: [
                            SizedBox(
                              height: 15,
                            ),
                            Text(
                              billerName,
                              style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500,
                                  color: Color.fromARGB(255, 148, 27, 49)),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                primary: Color.fromARGB(255, 4, 86, 7),
                              ),
                              onPressed: () async {
                                final my_url =
                                    myurls.AriaApiEndpoints.payViaWallet;
                                final userToken =
                                    UserSimplePreferences.getUserToken() ?? '';
                                List<payViaWalletResponse>
                                    pay_via_wallet_response = [];
                                var walletPayResponse = await client.post(
                                  Uri.parse(my_url),
                                  headers: {
                                    HttpHeaders.authorizationHeader:
                                        'Token $userToken',
                                  },
                                  body: {
                                    'product_id': bill_id,
                                    'first_name': first_name,
                                    'last_name': last_name,
                                    'account_for_bill': billingAccntNumber,
                                    'amount_total': paidAmount,
                                  },
                                );
                                if (walletPayResponse.statusCode == 200) {
                                  var walletPayResponseJsons =
                                      json.decode(walletPayResponse.body);
                                  pay_via_wallet_response.add(
                                      payViaWalletResponse
                                          .fromJson(walletPayResponseJsons));
                                  if (pay_via_wallet_response[0].verdict ==
                                      'payment successful') {
                                    showDialog(
                                        context: context,
                                        builder: (_) => AlertDialog(
                                              content: Column(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Row(
                                                    children: const [
                                                      Icon(
                                                        Icons.check_circle,
                                                        color: Colors.green,
                                                      ),
                                                      Text(
                                                          "Bill Paid Successfully"),
                                                    ],
                                                  ),
                                                  SizedBox(
                                                    height: 10,
                                                  ),
                                                  Row(
                                                    children: [
                                                      Expanded(
                                                        child: Text(
                                                          "Please note that it may take up to 48 hours for the payment to reflect on your service provider's side",
                                                          style: TextStyle(
                                                              fontSize: 11),
                                                          softWrap: false,
                                                          maxLines: 3,
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            )).then((val) {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) {
                                            return BillsProfile(client: client);
                                          },
                                        ),
                                      );
                                    });
                                  } else {
                                    showDialog(
                                        context: context,
                                        builder: (_) => AlertDialog(
                                              content: Column(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Row(
                                                    children: const [
                                                      Icon(
                                                        Icons.close,
                                                        color: Colors.red,
                                                      ),
                                                      Expanded(
                                                        child: Text(
                                                            "Payment Unsuccessfull...Try Again!",
                                                            softWrap: false,
                                                            maxLines: 3,
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                            style: TextStyle(
                                                                fontSize: 11)),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ));
                                  }
                                } //end if
                              },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'Proceed to Pay',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  SizedBox(
                                    width: 1,
                                  ),
                                  Text(
                                    ' \$ $paidAmount',
                                    style: TextStyle(
                                      color: Color.fromARGB(255, 8, 152, 210),
                                      fontWeight: FontWeight.w900,
                                    ),
                                  ),
                                  SizedBox(
                                    width: 2,
                                  ),
                                  Text(
                                    'for this bill?',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              )),
            ],
          ),
        ),
      ),
    );
  }
}
