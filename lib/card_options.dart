import 'package:ariaquickpay/choose_existing_cards.dart';
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

class cardOptions extends StatelessWidget {
  const cardOptions({
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
                    // ),
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
                          "SELECT CARD METHOD",
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
                child: ListView.separated(
                    itemBuilder: (context, index) {
                      Icon icon;
                      Text text;
                      switch (index) {
                        case 0:
                          icon = Icon(Icons.add_circle, color: Colors.green);
                          text = Text('ADD CARD');
                          break;
                        case 1:
                          icon = Icon(Icons.credit_card, color: Colors.green);
                          text = Text('PAY WITH EXISTING CARD');
                          break;
                        default:
                          {
                            icon = Icon(Icons.credit_card, color: Colors.green);
                            text = Text('Select');
                          }
                          break;
                      }
                      return InkWell(
                        onTap: () {
                          onItemPress(context,
                              index); //called to select the function to call depending on the method chosen
                        },
                        child: ListTile(
                          title: text,
                          leading: icon,
                        ),
                      );
                    },
                    separatorBuilder: (context, index) => Divider(
                          color: Colors.green,
                        ),
                    itemCount: 2),
              ),
            ),
          ],
        ),
      ),
    );
  }

  onItemPress(BuildContext context, int index) async {
    switch (index) {
      case 0:
        //addNewCard(context); // call pay via new card function
        break;
      case 1:
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) {
              return selectCards(
                client: client,
                paidAmnt: paidAmnt,
                billing_account_number: billing_account_number,
                bill_id: bill_id,
                first_name: first_name,
                last_name: last_name,
              );
            },
          ),
        ); //calls the list of cards screen
        break;
    }
  }
}
