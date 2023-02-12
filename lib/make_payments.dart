import 'package:ariaquickpay/bill_checkout.dart';
import 'package:ariaquickpay/card_options.dart';
import 'package:ariaquickpay/pay_via_aria_wallet.dart';
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
import 'package:http/http.dart';
import 'package:provider/provider.dart';
//import 'package:snippet_coder_utils/FormHelper.dart';
import 'aria_providers.dart';
import 'urls.dart' as myurls;
import 'colors.dart' as mycolor;
import 'package:badges/badges.dart';
import 'my_widgets.dart';
import 'dart:io';
import 'custom_rect_tween.dart';
import 'hero_dialog_route.dart';

class makePayment extends StatefulWidget {
  const makePayment({
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
  State<makePayment> createState() => _makePaymentState();
}

class _makePaymentState extends State<makePayment> {
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  String payment_method = '';
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: SingleChildScrollView(
          child: Container(
            height: MediaQuery.of(context).size.height,
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
                        //height: 45,
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
                                      return BillsProfile(
                                          client: widget.client);
                                    },
                                  ),
                                );
                              },
                            ),
                          ],
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
                  alignment: Alignment.topCenter,
                  child: paymentWidget(),
                )),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget paymentWidget() {
    final payMentMethods = [
      'Choose preferred payment method',
      'Bank',
      'Card',
      'Aria Wallet',
    ];
    String? selectedFrequency = '';
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0),
      child: Column(
        children: [
          SizedBox(
            height: 10,
          ),
          Card(
            color: Colors.white,
            elevation: 2.0,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5.0)),
            child: Row(
              children: [
                SizedBox(
                  width: 15,
                ),
                widget.billerLogo == 'no_media'
                    ? Image.asset(
                        "assets/images/no-image.png",
                        height: 100,
                        width: 100,
                        fit: BoxFit.fill,
                        alignment: Alignment.center,
                        repeat: ImageRepeat.noRepeat,
                      )
                    : Image.network(
                        myurls.AriaApiEndpoints
                                .imageBase + //remember to sort it out on production
                            widget.billerLogo,
                        height: 100,
                        width: 100,
                        fit: BoxFit.fill,
                        alignment: Alignment.center,
                        repeat: ImageRepeat.noRepeat,
                      ),
                Expanded(child: Container()),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      'Biller:',
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    SizedBox(
                        width: 180,
                        child: Text(
                          widget.billerName,
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                            color: Color.fromRGBO(94, 167, 203, 1),
                          ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                        )),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      'Service Industry:',
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    SizedBox(
                      width: 180,
                      child: Text(
                        widget.billerCat,
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                          color: Color.fromRGBO(94, 167, 203, 1),
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                  ],
                ),
                SizedBox(
                  width: 15,
                ),
              ],
            ),
          ),
          SizedBox(
            height: 5,
          ),
          Card(
            color: Colors.white,
            elevation: 2.0,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5.0)),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: Form(
                key: _formKey,
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 20,
                      ),
                      Row(
                        children: [
                          Text(
                            "Payment Details",
                            style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text("Billing Account Number:"),
                      TextFormField(
                        initialValue: widget.billingAccntNumber,
                        maxLength: 20,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Enter billing account number!';
                          }
                          if (value.isNotEmpty &&
                              !RegExp(r"[0-9]").hasMatch(value)) {
                            return 'Account number must contain at least an integer!';
                          }
                          return null;
                        },
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text("First Name:"),
                      TextFormField(
                        controller: firstNameController,
                        maxLength: 20,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Enter your first name!';
                          }
                          if (value.isNotEmpty &&
                              !RegExp(r"[a-zA-Z]+|\s").hasMatch(value)) {
                            return 'Enter a valid name!';
                          }
                          return null;
                        },
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text("Last Name:"),
                      TextFormField(
                        controller: lastNameController,
                        maxLength: 20,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Enter your last name!';
                          }
                          if (value.isNotEmpty &&
                              !RegExp(r"[a-zA-Z]+|\s").hasMatch(value)) {
                            return 'Enter a valid name!';
                          }
                          return null;
                        },
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text("Payment Method:"),
                      DropdownButtonFormField(
                        validator: (value) {
                          if (value == null ||
                              value == 'Choose preferred payment method') {
                            return 'Payment method not selected!';
                          }
                          payment_method = value.toString();
                          //print(payment_method);
                          return null;
                        },
                        value: payMentMethods[0],
                        items: payMentMethods.map((e) {
                          return DropdownMenuItem(
                            child: Text(e),
                            value: e,
                          );
                        }).toList(),
                        onChanged: (val) {},
                        icon: const Icon(
                          Icons.arrow_drop_down_circle,
                          color: Color.fromRGBO(94, 167, 203, 1),
                        ),
                        //decoration: InputDecoration(
                        //labelText: "Billing Frequency:",
                        //),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Hero(
                            tag: 'Payment PopUp',
                            createRectTween: (begin, end) {
                              return CustomRectTween(begin: begin!, end: end!);
                            },
                            child: ElevatedButton(
                                onPressed: () {
                                  if (_formKey.currentState!.validate()) {
                                    Navigator.of(context).push(HeroDialogRoute(
                                        builder: (context) {
                                          return enterAmountCard(
                                            client: widget.client,
                                            billingAccntNumber:
                                                widget.billingAccntNumber,
                                            bill_id: widget.billerId.toString(),
                                            first_name:
                                                firstNameController.text,
                                            last_name: lastNameController.text,
                                            payment_method: payment_method,
                                            billerName: widget.billerName,
                                          );
                                        },
                                        settings: RouteSettings(
                                            arguments: widget.billerId)));
                                  }
                                },
                                child: Text("Pay this Bill")),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                    ]),
              ),
            ),
          )
        ],
      ),
    );
  }
}

class enterAmountCard extends StatefulWidget {
  enterAmountCard({
    Key? key,
    required this.client,
    required this.billingAccntNumber,
    required this.bill_id,
    required this.first_name,
    required this.last_name,
    required this.payment_method,
    required this.billerName,
  }) : super(key: key);
  final Client client;
  final String billingAccntNumber;
  final String bill_id;
  final String first_name;
  final String last_name;
  final String payment_method;
  final String billerName;
  @override
  State<enterAmountCard> createState() => _enterAmountCardState();
}

class _enterAmountCardState extends State<enterAmountCard> {
  String paymentAmount = '';

  final _myformKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Hero(
            tag: 'Payment PopUp',
            createRectTween: (begin, end) {
              return CustomRectTween(begin: begin!, end: end!);
            },
            child: Material(
              color: Colors.white,
              elevation: 2,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(32)),
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(32.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        "Please Enter Amount to Pay",
                        style: TextStyle(
                            color: Colors.black, fontWeight: FontWeight.w500),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Form(
                        key: _myformKey,
                        child: Column(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                color: Color.fromARGB(30, 121, 120, 120),
                                borderRadius: new BorderRadius.circular(10.0),
                              ),
                              child: Padding(
                                padding: EdgeInsets.only(
                                    left: 15, right: 15, top: 5),
                                child: TextFormField(
                                  style: TextStyle(fontWeight: FontWeight.w600),
                                  keyboardType: TextInputType.number,
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    labelText: '\$',
                                  ),
                                  //maxLength: 20,
                                  validator: (value) {
                                    if (value != null && value.isNotEmpty) {
                                      value = value.replaceAll(',', '');
                                      value = value.replaceAll('-', '');
                                      value = value.replaceAll(' ', '');
                                      try {
                                        paymentAmount = value;
                                        //print(paymentAmount);
                                      } catch (err) {
                                        print(err);
                                      }
                                    }
                                  },
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            primary: Colors.blueAccent,
                          ),
                          onPressed: () {
                            if (_myformKey.currentState!.validate()) {
                              if (widget.payment_method == 'Card') {
                                Navigator.pop(context);
                                makePaymentFunction(
                                  context,
                                  widget.client,
                                  widget.bill_id,
                                  widget.first_name,
                                  widget.last_name,
                                  widget.billingAccntNumber,
                                  paymentAmount,
                                );
                              } //end if
                              if (widget.payment_method == 'Aria Wallet') {
                                Navigator.pop(context);
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) {
                                      return payViaAriaWallet(
                                        client: widget.client,
                                        billingAccntNumber:
                                            widget.billingAccntNumber,
                                        bill_id: widget.bill_id,
                                        first_name: widget.first_name,
                                        last_name: widget.last_name,
                                        paidAmount: paymentAmount,
                                        billerName: widget.billerName,
                                      );
                                    },
                                  ),
                                );
                              } //end if
                            } //end if
                          },
                          child: Text(
                            'Proceed to Checkout',
                            style: TextStyle(color: Colors.white),
                          ))
                    ],
                  ),
                ),
              ),
            )),
      ),
    );
  }
}
