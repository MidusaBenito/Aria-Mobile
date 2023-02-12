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
//import 'package:snippet_coder_utils/FormHelper.dart';
import 'aria_providers.dart';
import 'urls.dart' as myurls;
import 'colors.dart' as mycolor;
import 'package:badges/badges.dart';
import 'my_widgets.dart';
import 'dart:io';

class EditBiller extends StatelessWidget {
  EditBiller({
    Key? key,
    required this.client,
    required this.billerName,
    required this.billerId,
  }) : super(key: key);
  final Client client;
  final String billerName;
  final int billerId;
  final frequencyList = [
    'Monthly',
    'Every 2 Months',
    'Every 3 Months',
    'Every 4 Months',
    'Every 6 Months',
    'Every 12 Months'
  ];
  String? selectedFrequency = '';

  String accntNo = '';
  String dateDue = '';
  String frequencyBill = '';
  String payAuto = 'false';
  String reminderSend = 'false';
  //bool autoPay = false;
  final TextEditingController _accntEditingController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (BuildContext context) {
          return updateNewDate();
        }),
        ChangeNotifierProvider(create: (BuildContext context) {
          return updateAutoPayCheckbox();
        }),
        ChangeNotifierProvider(create: (BuildContext context) {
          return updateReminderCheckbox();
        }),
        ChangeNotifierProvider(create: (BuildContext context) {
          return controlCalendarWarning();
        }),
        ChangeNotifierProvider(create: (BuildContext context) {
          return controlAccntWarning();
        }),
      ],
      child: Scaffold(
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
                                    return BillsProfile(client: client);
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
                          Text(billerName),
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
                  child: FutureBuilder<List>(
                    future: getBillerPaymentDetails(billerId),
                    builder: (context, snapshot) {
                      var biller_details = snapshot.data ?? [];
                      switch (snapshot.connectionState) {
                        case ConnectionState.waiting:
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        default:
                          if (snapshot.hasError) {
                            return Center(
                              child: Text("Unable to load biller details!"),
                            );
                          } else {
                            return Container(
                              child: Column(
                                children: [
                                  Expanded(
                                    child: Column(
                                      children: [
                                        SizedBox(
                                          height: 20,
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 30),
                                          child: Form(
                                              key: _formKey,
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text('Bill Due On: '),
                                                  SizedBox(
                                                    height: 20,
                                                  ),
                                                  GestureDetector(
                                                    onTap: () => myCalendar(
                                                        context,
                                                        biller_details[0]
                                                            .next_due_date,
                                                        biller_details),
                                                    child: Row(
                                                      children: [
                                                        Consumer<updateNewDate>(
                                                            builder: (context,
                                                                value, child) {
                                                          return Text(
                                                              biller_details[0]
                                                                  .next_due_date);
                                                        }),
                                                        Icon(
                                                          const IconData(
                                                              0xf06ae,
                                                              fontFamily:
                                                                  'MaterialIcons'),
                                                          color: Colors.blue,
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  Consumer<
                                                          controlCalendarWarning>(
                                                      builder: (context, value,
                                                          child) {
                                                    if (value.showWarning ==
                                                        true) {
                                                      return validateBillerCalendar();
                                                    }
                                                    return Container();
                                                  }),
                                                  SizedBox(
                                                    height: 20,
                                                  ),
                                                  Text(
                                                      "Billing Account Number:"),
                                                  TextFormField(
                                                    //controller:
                                                    // _accntEditingController,
                                                    initialValue: biller_details[
                                                            0]
                                                        .billing_account_number,
                                                    maxLength: 20,
                                                    onChanged: (value) {
                                                      biller_details[0]
                                                              .billing_account_number =
                                                          value;
                                                      context
                                                          .read<
                                                              controlAccntWarning>()
                                                          .updateWarningStatus(
                                                              false);
                                                    },
                                                  ),
                                                  Consumer<controlAccntWarning>(
                                                      builder: (context, value,
                                                          child) {
                                                    if (value.showWarning ==
                                                        true) {
                                                      return validateBillerAccnt();
                                                    }
                                                    return Container();
                                                  }),
                                                  SizedBox(
                                                    height: 20,
                                                  ),
                                                  Text("Billing Frequency:"),
                                                  DropdownButtonFormField(
                                                    value: biller_details[0]
                                                        .billing_frequency,
                                                    items:
                                                        frequencyList.map((e) {
                                                      return DropdownMenuItem(
                                                        child: Text(e),
                                                        value: e,
                                                      );
                                                    }).toList(),
                                                    onChanged: (val) {
                                                      biller_details[0]
                                                              .billing_frequency =
                                                          val;
                                                    },
                                                    icon: const Icon(
                                                      Icons
                                                          .arrow_drop_down_circle,
                                                      color: Color.fromRGBO(
                                                          94, 167, 203, 1),
                                                    ),
                                                    //decoration: InputDecoration(
                                                    //labelText: "Billing Frequency:",
                                                    //),
                                                  ),
                                                  SizedBox(
                                                    height: 20,
                                                  ),
                                                  Consumer<
                                                          updateAutoPayCheckbox>(
                                                      builder: (context, value,
                                                          child) {
                                                    return CheckboxListTile(
                                                      contentPadding:
                                                          EdgeInsets.symmetric(
                                                              horizontal: 0.0),
                                                      value: biller_details[0]
                                                          .automatic_payments,
                                                      onChanged: (val) {
                                                        biller_details[0]
                                                                .automatic_payments =
                                                            val;
                                                        context
                                                            .read<
                                                                updateAutoPayCheckbox>()
                                                            .updateCheckBox(
                                                                biller_details,
                                                                val);
                                                      },
                                                      title: Text(
                                                        'Activate Automatic Payments for this Bill: ',
                                                        textAlign:
                                                            TextAlign.start,
                                                      ),
                                                      activeColor:
                                                          Color.fromRGBO(
                                                              94, 167, 203, 1),
                                                    );
                                                  }),
                                                  Consumer<
                                                          updateReminderCheckbox>(
                                                      builder: (context, value,
                                                          child) {
                                                    return CheckboxListTile(
                                                      contentPadding:
                                                          EdgeInsets.symmetric(
                                                              horizontal: 0.0),
                                                      value: biller_details[0]
                                                          .send_email_reminder,
                                                      onChanged: (val) {
                                                        biller_details[0]
                                                                .send_email_reminder =
                                                            val;
                                                        context
                                                            .read<
                                                                updateReminderCheckbox>()
                                                            .updateCheckBox(
                                                                biller_details,
                                                                val);
                                                      },
                                                      title: Text(
                                                        'Send Me Email Reminders for this Bill: ',
                                                        textAlign:
                                                            TextAlign.start,
                                                      ),
                                                      activeColor:
                                                          Color.fromRGBO(
                                                              94, 167, 203, 1),
                                                    );
                                                  }),
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      ElevatedButton(
                                                          onPressed: () async {
                                                            bool saveAction_1 =
                                                                false;
                                                            bool saveAction_2 =
                                                                false;
                                                            if (biller_details[
                                                                        0]
                                                                    .next_due_date ==
                                                                'Not Set') {
                                                              context
                                                                  .read<
                                                                      controlCalendarWarning>()
                                                                  .updateWarningStatus(
                                                                      true);
                                                            }
                                                            if (biller_details[
                                                                        0]
                                                                    .next_due_date !=
                                                                'Not Set') {
                                                              context
                                                                  .read<
                                                                      controlCalendarWarning>()
                                                                  .updateWarningStatus(
                                                                      false);
                                                              saveAction_1 =
                                                                  true;
                                                            }
                                                            if (biller_details[
                                                                        0]
                                                                    .billing_account_number ==
                                                                '') {
                                                              context
                                                                  .read<
                                                                      controlAccntWarning>()
                                                                  .updateWarningStatus(
                                                                      true);
                                                            }
                                                            if (biller_details[
                                                                        0]
                                                                    .billing_account_number !=
                                                                '') {
                                                              context
                                                                  .read<
                                                                      controlAccntWarning>()
                                                                  .updateWarningStatus(
                                                                      false);
                                                              saveAction_2 =
                                                                  true;
                                                            }
                                                            if (saveAction_1 ==
                                                                    true &&
                                                                saveAction_2 ==
                                                                    true) {
                                                              accntNo =
                                                                  biller_details[
                                                                          0]
                                                                      .billing_account_number;

                                                              dateDue =
                                                                  biller_details[
                                                                          0]
                                                                      .next_due_date;

                                                              frequencyBill =
                                                                  biller_details[
                                                                          0]
                                                                      .billing_frequency;

                                                              if (biller_details[
                                                                          0]
                                                                      .automatic_payments ==
                                                                  true) {
                                                                payAuto =
                                                                    'true';
                                                              }

                                                              if (biller_details[
                                                                          0]
                                                                      .send_email_reminder ==
                                                                  true) {
                                                                reminderSend =
                                                                    'true';
                                                              }

                                                              final userToken =
                                                                  UserSimplePreferences
                                                                          .getUserToken() ??
                                                                      '';
                                                              final url =
                                                                  '${myurls.AriaApiEndpoints.postBillerPaymentDetails}$billerId/';

                                                              var response =
                                                                  await client
                                                                      .post(
                                                                Uri.parse(url),
                                                                headers: {
                                                                  HttpHeaders
                                                                          .authorizationHeader:
                                                                      'Token $userToken',
                                                                },
                                                                body: {
                                                                  'billing_frequency':
                                                                      frequencyBill,
                                                                  'automatic_payments':
                                                                      payAuto,
                                                                  'send_email_reminder':
                                                                      reminderSend,
                                                                  'next_due':
                                                                      dateDue,
                                                                  'billing_accnt_number':
                                                                      accntNo,
                                                                },
                                                              );
                                                              List<postBiller>
                                                                  post_bill_response =
                                                                  [];
                                                              if (response
                                                                      .statusCode ==
                                                                  200) {
                                                                ScaffoldMessenger.of(
                                                                        context)
                                                                    .showSnackBar(
                                                                  const SnackBar(
                                                                      content: Text(
                                                                          'Saving...'),
                                                                      duration: Duration(
                                                                          milliseconds:
                                                                              300)),
                                                                );
                                                                var responseJsons =
                                                                    json.decode(
                                                                        response
                                                                            .body);
                                                                post_bill_response
                                                                    .add(postBiller
                                                                        .fromJson(
                                                                            responseJsons));
                                                                if (post_bill_response[
                                                                            0]
                                                                        .editResponse ==
                                                                    'Ok') {
                                                                  Navigator
                                                                      .push(
                                                                    context,
                                                                    MaterialPageRoute(
                                                                      builder:
                                                                          (context) {
                                                                        return BillsProfile(
                                                                            client:
                                                                                client);
                                                                      },
                                                                    ),
                                                                  );
                                                                }
                                                                if (post_bill_response[
                                                                            0]
                                                                        .editResponse ==
                                                                    'Failed') {}
                                                              }
                                                            }
                                                          },
                                                          child: Text("Save")),
                                                    ],
                                                  )
                                                ],
                                              )),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            );
                            //return buildAllBillers(all_billers);
                          }
                      }
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<List> getBillerPaymentDetails(int billId) async {
    final userToken = UserSimplePreferences.getUserToken() ?? '';
    final url = '${myurls.AriaApiEndpoints.getBillerPaymentDetails}$billId/';
    List<BillerPaymentsDetails> biller_payment_details_response = [];
    if (userToken != '') {
      var getBillerPaymentDetailsResponse = await client.get(
        Uri.parse(url),
        headers: {
          HttpHeaders.authorizationHeader: 'Token $userToken',
        },
      );
      if (getBillerPaymentDetailsResponse.statusCode == 200) {
        var getBillerPaymentDetailsResponseJsons =
            json.decode(getBillerPaymentDetailsResponse.body);
        biller_payment_details_response.add(BillerPaymentsDetails.fromJson(
            getBillerPaymentDetailsResponseJsons));

        return biller_payment_details_response;
      }
      return biller_payment_details_response;
    }

    return biller_payment_details_response;
  }

  Future myCalendar(BuildContext context, next_due_date, biller_details) async {
    final initialDate = next_due_date == 'Not Set'
        ? DateTime.now()
        : DateTime.parse(next_due_date);
    final newDate = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(DateTime.now().year - 5),
      lastDate: DateTime(DateTime.now().year + 5),
    );
    if (newDate == null) return;
    context.read<updateNewDate>().showNewDate(biller_details, newDate);
    context.read<controlCalendarWarning>().updateWarningStatus(false);
  }

  Widget validateBillerCalendar() {
    return Text(
      'You have not selected a date!',
      style: TextStyle(color: Colors.redAccent),
    );
  }

  Widget validateBillerAccnt() {
    return Text(
      'Enter Billing Account Number for this Bill!',
      style: TextStyle(color: Colors.redAccent),
    );
  }
}
