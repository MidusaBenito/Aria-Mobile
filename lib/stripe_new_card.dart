import 'dart:convert';
//import 'package:ariaquickpay/stripe_new_card.dart';
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
import 'urls.dart' as myurls;
import 'colors.dart' as mycolor;
import 'package:badges/badges.dart';
import 'my_widgets.dart';
import 'dart:io';
import 'package:flutter_stripe/flutter_stripe.dart';

Map<String, dynamic>? paymentIntent;
String SECRET_KEY =
    "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";

Future<void> makePaymentFunction(context, client, bill_id, first_name,
    last_name, billing_account_number, paidAmnt) async {
  try {
    paymentIntent = await createPaymentIntent(paidAmnt, 'USD', bill_id,
        last_name, first_name, billing_account_number);
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
    displayPaymentSheet(context, client, bill_id, first_name, last_name,
        billing_account_number, paidAmnt);
  } catch (e, s) {
    //print('exception:$e$s');
  }
}

displayPaymentSheet(context, client, bill_id, first_name, last_name,
    billing_account_number, paidAmnt) async {
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
                          Text("Payment Successfull",
                              style: TextStyle(fontSize: 11)),
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
      } //end if
      // ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("paid successfully")));

      paymentIntent = null;
    }).onError((error, stackTrace) {
      //print('Error is:--->$error $stackTrace');
    });
  } on StripeException catch (e) {
    //print('Error is:---> $e');
    showDialog(
        context: context,
        builder: (_) => const AlertDialog(
              content: Text("Cancelled "),
            ));
  } catch (e) {
    //print('$e');
  }
}

//  Future<Map<String, dynamic>>
createPaymentIntent(String amount, String currency, bill_id, last_name,
    first_name, billing_account_number) async {
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
    //print('Payment Intent Body->>> ${response.body.toString()}');
    return jsonDecode(response.body);
  } catch (err) {
    // ignore: avoid_print
    //print('err charging user: ${err.toString()}');
  }
}

calculateAmount(String amount) {
  final calculatedAmount = ((double.parse(amount)) * 100).toInt();
  return calculatedAmount.toString();
}
