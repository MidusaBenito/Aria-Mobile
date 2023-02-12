import 'package:ariaquickpay/make_payments.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'dart:convert';
import 'package:ariaquickpay/bills_profile.dart';
import 'package:ariaquickpay/models/billers.dart';
import 'package:ariaquickpay/models/category.dart';
import 'package:ariaquickpay/models/models.dart';
import 'package:ariaquickpay/utils.dart';
import 'package:flutter/material.dart' hide Badge;
import 'package:http/http.dart';
import 'package:provider/provider.dart';
//import 'package:snippet_coder_utils/FormHelper.dart';
import 'aria_providers.dart';
import 'urls.dart' as myurls;
import 'colors.dart' as mycolor;
import 'package:badges/badges.dart';
import 'my_widgets.dart';
import 'dart:io';

class billCheckout extends StatefulWidget {
  const billCheckout({
    Key? key,
    required this.client,
    required this.billerName,
    required this.billerId,
    required this.billerLogo,
    required this.billerCat,
    required this.billingAccntNumber,
  }) : super(key: key);
  final Client client;
  final String billerName;
  final int billerId;
  final String billerLogo;
  final String billerCat;
  final String billingAccntNumber;

  @override
  State<billCheckout> createState() => _billCheckoutState();
}

class _billCheckoutState extends State<billCheckout> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        height: double.infinity,
        width: double.infinity,
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
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) {
                                  return makePayment(
                                    client: widget.client,
                                    billerName: widget.billerName,
                                    billerId: widget.billerId,
                                    billerLogo: widget.billerLogo,
                                    billerCat: widget.billerCat,
                                    billingAccntNumber:
                                        widget.billingAccntNumber,
                                  );
                                },
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                        SizedBox(
                          width: 15,
                        ),
                        Text(
                          widget.billerName,
                          overflow: TextOverflow.ellipsis,
                        ),
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
                //height: ,
                //alignment: Alignment.topCenter,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15.0),
                  child: Column(
                    children: [
                      SizedBox(
                        height: 10,
                      ),
                      Text("Hey")
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
