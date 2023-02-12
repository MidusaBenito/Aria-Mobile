import 'package:ariaquickpay/stripe_new_card.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'dart:convert';
import 'package:ariaquickpay/bills_profile.dart';
import 'package:ariaquickpay/models/billers.dart';
import 'package:ariaquickpay/models/category.dart';
import 'package:ariaquickpay/models/models.dart';
import 'package:ariaquickpay/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_credit_card/credit_card_widget.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:provider/provider.dart';

import 'aria_providers.dart';
import 'urls.dart' as myurls;
import 'colors.dart' as mycolor;
import 'package:badges/badges.dart';
import 'my_widgets.dart';
import 'dart:io';
import 'package:flutter_stripe/flutter_stripe.dart';

class selectCards extends StatelessWidget {
  selectCards({
    Key? key,
    required this.client,
    required this.paidAmnt,
    required this.billing_account_number,
    required this.bill_id,
    required this.first_name,
    required this.last_name,
  }) : super(key: key);
  final Client client;
  final String paidAmnt;
  final String billing_account_number;
  final String bill_id;
  final String first_name;
  final String last_name;
  final List cards = [
    {
      'cardNumber': '4242424242434242',
      'expiryDate': '10/22',
      'cardHolderName': 'Kaura Jerim',
      'cvvCode': '424',
      'showBackView': false,
    },
    {
      'cardNumber': '55555345966554444',
      'expiryDate': '02/25',
      'cardHolderName': 'Jerim Kaura',
      'cvvCode': '123',
      'showBackView': false,
    }
  ];

  Map<String, dynamic>? paymentIntent;
  String SECRET_KEY =
      "sk_test_51KhALyCldFfAXs7m9rWzmtbH4Eoz4dQDoUj7aJFp8dOgTNcR5IwOf8UnH8j4SAAPm6rbUn7Tw6YNg835GbquFTZt00k7WxXoBe";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          "CHOOSE CARD",
                          style: TextStyle(
                              color: Color.fromRGBO(238, 236, 236, 1),
                              fontSize: 16,
                              fontWeight: FontWeight.w500),
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
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 18.0),
                  child: ListView.builder(
                      itemCount: cards.length,
                      itemBuilder: (BuildContext context, int index) {
                        var card = cards[index];
                        return InkWell(
                          onTap: () {
                            //choseExistingCard(context, card);
                            makePayment(context);
                          },
                          child: CreditCardWidget(
                            cardNumber: card['cardNumber'],
                            expiryDate: card['expiryDate'],
                            cardHolderName: card['cardHolderName'],
                            cvvCode: card['cvvCode'],
                            showBackView: false,
                            onCreditCardWidgetChange: (CreditCardBrand) {},
                          ),
                        );
                      }),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> makePayment(context) async {
    try {
      paymentIntent = await createPaymentIntent(paidAmnt, 'USD');
      //Payment Sheet
      await Stripe.instance
          .initPaymentSheet(
              paymentSheetParameters: SetupPaymentSheetParameters(
            paymentIntentClientSecret: paymentIntent!['client_secret'],
            // applePay: PaymentSheetApplePay(
            //merchantCountryCode: 'US',
            // ),
            googlePay: PaymentSheetGooglePay(
              merchantCountryCode: 'US',
              testEnv: true,
            ),
            style: ThemeMode.dark,
            merchantDisplayName: 'Ariaquickpay',
            allowsDelayedPaymentMethods: true,
          ))
          .then((value) {});

      ///now finally display payment sheeet
      displayPaymentSheet(context);
    } catch (e, s) {
      print('exception:$e$s');
    }
  }

  displayPaymentSheet(context) async {
    try {
      await Stripe.instance.presentPaymentSheet().then((value) async {
        //print(value);

        //save payment details
        final my_url = myurls.AriaApiEndpoints.savePaymentDetailsCard;
        final userToken = UserSimplePreferences.getUserToken() ?? '';
        var saveResponse = await client.post(
          Uri.parse(my_url),
          headers: {
            HttpHeaders.authorizationHeader: 'Token $userToken',
          },
          body: {
            'product_id': bill_id,
            'first_name': first_name,
            'last_name': last_name,
            'account_for_bill': billing_account_number,
            'paid_amount': paidAmnt,
          },
        );
        if (saveResponse.statusCode == 200) {
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
                            Text("Payment Successfull"),
                          ],
                        ),
                      ],
                    ),
                  ));
        } //end if
        // ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("paid successfully")));

        paymentIntent = null;
      }).onError((error, stackTrace) {
        print('Error is:--->$error $stackTrace');
      });
    } on StripeException catch (e) {
      print('Error is:---> $e');
      showDialog(
          context: context,
          builder: (_) => const AlertDialog(
                content: Text("Cancelled "),
              ));
    } catch (e) {
      print('$e');
    }
  }

  //  Future<Map<String, dynamic>>
  createPaymentIntent(String amount, String currency) async {
    try {
      String userEmail = UserSimplePreferences.getUserEmail() ?? '';
      Map<String, dynamic> body = {
        'amount': calculateAmount(amount),
        'currency': currency,
        'payment_method_types[]': 'card',
        'description': 'Paying bill using card from aria mobile app',
        //'email': userEmail,
        //"payment_method_options": "",
        'metadata[email]': userEmail,
        'metadata[product_id]': bill_id,
        'metadata[last_name]': last_name,
        'metadata[first_name]': first_name,
        'metadata[account_billed_to]': billing_account_number,
        'metadata[payment_method]': 'card',
        'metadata[payment_type]': 'card_bill_pay',

        //'payment_method_types': ['card'],
      };

      var response = await http.post(
        Uri.parse('https://api.stripe.com/v1/payment_intents'),
        headers: {
          'Authorization': 'Bearer $SECRET_KEY',
          'Content-Type': 'application/x-www-form-urlencoded'
        },
        body: body,
      );
      // ignore: avoid_print
      print('Payment Intent Body->>> ${response.body.toString()}');
      return jsonDecode(response.body);
    } catch (err) {
      // ignore: avoid_print
      print('err charging user: ${err.toString()}');
    }
  }

  calculateAmount(String amount) {
    final calculatedAmount = ((double.parse(amount)) * 100).toInt();
    return calculatedAmount.toString();
  }
}
