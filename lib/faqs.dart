import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'dart:convert';
import 'package:ariaquickpay/bills_profile.dart';
import 'package:ariaquickpay/models/billers.dart';
import 'package:ariaquickpay/models/category.dart';
import 'package:ariaquickpay/models/models.dart';
import 'package:ariaquickpay/utils.dart';
import 'package:ariaquickpay/faqs_contents.dart';
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

class Faqs extends StatefulWidget {
  const Faqs({
    Key? key,
  }) : super(key: key);

  @override
  State<Faqs> createState() => _FaqsState();
}

class _FaqsState extends State<Faqs> {
  var answerIndex = 0;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
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
                        ],
                      ),

                      Row(
                        children: [
                          SizedBox(
                            width: 15,
                          ),
                          Text(
                            'FAQS',
                            style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.w500,
                                color: Colors.white),
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
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30.0),
                    child: Column(
                      children: [
                        SizedBox(
                          height: 10,
                        ),
                        Expanded(
                          child: Container(
                            child: ListView.builder(
                              padding: EdgeInsets.zero,
                              physics: BouncingScrollPhysics(),
                              itemCount: frequently_asked_questions.length,
                              itemBuilder: (context, index) {
                                var faq = frequently_asked_questions[index];

                                //var quizColor = Color.fromARGB(255, 2, 83, 123);
                                return Column(
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          answerIndex = index;
                                          //print(answerIndex);
                                        });
                                      },
                                      child: Card(
                                        color: Colors.white,
                                        elevation: 2.0,
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(5.0)),
                                        child: Container(
                                          width:
                                              MediaQuery.of(context).size.width,
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 15.0,
                                              vertical: 20,
                                            ),
                                            child: Row(children: [
                                              Expanded(
                                                child: Text(
                                                  faq['question'],
                                                  style: TextStyle(
                                                    color: answerIndex == index
                                                        ? Colors.black
                                                        : Color.fromARGB(
                                                            255, 2, 83, 123),
                                                  ),
                                                ),
                                              ),
                                            ]),
                                          ),
                                        ),
                                      ),
                                    ),
                                    answerIndex == index
                                        ? Card(
                                            margin: EdgeInsets.only(
                                              top: 0.0,
                                              bottom: 10.0,
                                            ),
                                            color: Color.fromARGB(
                                                255, 234, 235, 236),
                                            elevation: 2.0,
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(5.0)),
                                            child: Container(
                                              width: MediaQuery.of(context)
                                                  .size
                                                  .width,
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                  horizontal: 15.0,
                                                  vertical: 20,
                                                ),
                                                child: Row(children: [
                                                  Expanded(
                                                    child: Text(
                                                      faq['answer'],
                                                      style: TextStyle(
                                                          color: Color.fromARGB(
                                                              255, 0, 0, 0),
                                                          fontWeight:
                                                              FontWeight.w300),
                                                    ),
                                                  ),
                                                ]),
                                              ),
                                            ),
                                          )
                                        : Container(),
                                  ],
                                );
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
