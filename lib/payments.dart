import 'package:ariaquickpay/coming_soon.dart';
import 'package:ariaquickpay/proceed_to_plaid.dart';
import 'package:ariaquickpay/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart';
import 'urls.dart' as myurls;
import 'colors.dart' as mycolor;
import 'package:badges/badges.dart';
import 'my_widgets.dart';
//import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Payments extends StatefulWidget {
  const Payments({Key? key, required this.client}) : super(key: key);
  final Client client;
  @override
  State<Payments> createState() => _PaymentsState();
}

class _PaymentsState extends State<Payments> with TickerProviderStateMixin {
  //setting up userdetails
  //final bool isUserRegistered =
  //UserSimplePreferences.getUserRegistered() ?? false;
  final bool isEmailVerified =
      UserSimplePreferences.getUserEmailVerified() ?? false;
  //final String userEmail = UserSimplePreferences.getUserEmail() ?? '';
  List<dynamic> payment_history_response = [];
  double totalPaid = 0.00;
  double lastMonth = 0.00;

  Future<bool> _onWillPop() async {
    return (await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: new Text('Are you sure?'),
            content: new Text('Do you want to exit Ariaquickpay?'),
            actions: <Widget>[
              TextButton(
                onPressed: () =>
                    Navigator.of(context).pop(false), //<-- SEE HERE
                child: new Text('No'),
              ),
              TextButton(
                onPressed: () =>
                    //Navigator.of(context).pop(true), // <-- SEE HERE
                    SystemNavigator.pop(),
                child: new Text('Yes'),
              ),
            ],
          ),
        )) ??
        false;
  }

  @override
  Widget build(BuildContext context) {
    TabController _tabController = TabController(length: 2, vsync: this);
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        appBar: MyAppBar(
          client: widget.client,
        ),
        drawer: MyDrawer(
          client: widget.client,
        ),
        bottomNavigationBar: MyBottomBar(
          client: widget.client,
          typeOfB: "pay",
        ),
        body: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.white,
                Colors.white,
              ],
            ),
          ),
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
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(30.0),
                    topLeft: Radius.circular(30.0),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15.0),
                  child: TabBar(
                    controller: _tabController,
                    labelColor: Colors.white,
                    unselectedLabelColor: Colors.black,
                    labelStyle: TextStyle(fontSize: 13),
                    indicatorColor: Color.fromARGB(255, 238, 231, 231),
                    tabs: [
                      Tab(
                        text: "Payment Overview",
                      ),
                      Tab(
                        text: "Payment Methods",
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  //width: double.maxFinite,
                  //height: MediaQuery.of(context).size.height,
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Color.fromRGBO(238, 236, 236, 1),
                              Color.fromRGBO(238, 236, 236, 1),
                            ],
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15.0),
                          child: FutureBuilder<List>(
                            future: getPaymentHistory(widget.client),
                            builder: (context, snapshot) {
                              payment_history_response = snapshot.data ?? [];
                              switch (snapshot.connectionState) {
                                case ConnectionState.waiting:
                                  return Center(
                                    child: Column(
                                      children: [
                                        Expanded(child: Container()),
                                        CircularProgressIndicator(),
                                        Expanded(child: Container()),
                                      ],
                                    ),
                                  );
                                default:
                                  if (snapshot.hasError) {
                                    print(snapshot.error);
                                    return Column(
                                      children: [
                                        Expanded(
                                          child: Container(
                                            child: paymentOverview(
                                              client: widget.client,
                                              totalPaid: totalPaid,
                                              lastMonth: lastMonth,
                                              payment_history:
                                                  payment_history_response,
                                              last_month_history: [],
                                            ),
                                          ),
                                        ),
                                      ],
                                    );
                                  } else {
                                    List<dynamic> payment_history_last_month =
                                        [];
                                    var currMonth = DateTime.now().month;
                                    //print(currMonth - 1);
                                    totalPaid = 0.00;
                                    lastMonth = 0.00;
                                    for (var paymentItem
                                        in payment_history_response) {
                                      String paidAmnt = paymentItem.paid_amount;
                                      totalPaid += double.parse(paidAmnt);
                                      var paymentMonth =
                                          DateTime.parse(paymentItem.date_paid)
                                              .month;
                                      if (paymentMonth == currMonth - 1) {
                                        //print(lastMonth);
                                        payment_history_last_month
                                            .add(paymentItem);
                                        lastMonth += double.parse(paidAmnt);
                                      }
                                    }
                                    return Column(
                                      children: [
                                        Expanded(
                                          child: Container(
                                            child: paymentOverview(
                                              client: widget.client,
                                              totalPaid: totalPaid,
                                              lastMonth: lastMonth,
                                              payment_history:
                                                  payment_history_response,
                                              last_month_history:
                                                  payment_history_last_month,
                                            ),
                                          ),
                                        ),
                                      ],
                                    );
                                  }
                              }
                            },
                          ),
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Color.fromRGBO(238, 236, 236, 1),
                              Color.fromRGBO(238, 236, 236, 1),
                            ],
                          ),
                        ),
                        //payments method cards
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15.0),
                          child: Column(
                            children: [
                              SizedBox(
                                height: 10,
                              ),
                              Row(
                                children: [
                                  Text(
                                    "Set Up Your Payment Method",
                                    style: TextStyle(fontSize: 13),
                                  ),
                                ],
                              ),
                              //Expanded(child: Container()),
                              SizedBox(height: 20),
                              Card(
                                color: Colors.white,
                                elevation: 2.0,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20.0)),
                                child: Container(
                                  height: 120,
                                  width: MediaQuery.of(context).size.width,
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 15.0),
                                    child: Row(
                                      children: [
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            SizedBox(
                                              height: 20,
                                            ),
                                            Text(
                                              "Bank Accounts",
                                              style: TextStyle(
                                                fontWeight: FontWeight.w600,
                                                fontSize: 15,
                                              ),
                                            ),
                                            Text(
                                              "0 accounts",
                                              style: TextStyle(
                                                fontWeight: FontWeight.w800,
                                                fontSize: 20,
                                                color: Colors.blue,
                                              ),
                                            ),
                                            Expanded(child: Container()),
                                            GestureDetector(
                                              onTap: () {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) {
                                                      return proceedToPlaid(
                                                        client: widget.client,
                                                      );
                                                    },
                                                  ),
                                                );
                                              },
                                              child: Row(
                                                children: [
                                                  Icon(
                                                    const IconData(0xe047,
                                                        fontFamily:
                                                            'MaterialIcons'),
                                                  ),
                                                  SizedBox(
                                                    width: 5,
                                                  ),
                                                  Text(
                                                    "Add Bank Account",
                                                    style:
                                                        TextStyle(fontSize: 12),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            SizedBox(
                                              height: 20,
                                            ),
                                          ],
                                        ),
                                        Expanded(
                                          child: Container(),
                                        ),
                                        Column(
                                          children: [
                                            SizedBox(
                                              height: 20,
                                            ),
                                            Row(
                                              children: [
                                                CircleAvatar(
                                                  backgroundColor:
                                                      Color.fromRGBO(
                                                          94, 167, 203, 1),
                                                  radius: 15,
                                                  child: Icon(
                                                    const IconData(0xf04c3,
                                                        fontFamily:
                                                            'MaterialIcons'),
                                                    color: Colors.white,
                                                  ),
                                                ),
                                              ],
                                            )
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              //Expanded(child: Container()),
                              SizedBox(height: 20),
                              //second card
                              Card(
                                color: Colors.white,
                                elevation: 2.0,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20.0)),
                                child: Container(
                                  height: 120,
                                  width: MediaQuery.of(context).size.width,
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 15.0),
                                    child: Row(
                                      children: [
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            SizedBox(
                                              height: 20,
                                            ),
                                            Text(
                                              "Credit Cards",
                                              style: TextStyle(
                                                fontWeight: FontWeight.w600,
                                                fontSize: 15,
                                              ),
                                            ),
                                            Text(
                                              "0 Cards",
                                              style: TextStyle(
                                                fontWeight: FontWeight.w800,
                                                fontSize: 20,
                                                color: Colors.blue,
                                              ),
                                            ),
                                            Expanded(child: Container()),
                                            GestureDetector(
                                              onTap: () {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) {
                                                      return comingSoon();
                                                    },
                                                  ),
                                                );
                                              },
                                              child: Row(
                                                children: [
                                                  Icon(
                                                    const IconData(0xe047,
                                                        fontFamily:
                                                            'MaterialIcons'),
                                                  ),
                                                  SizedBox(
                                                    width: 5,
                                                  ),
                                                  Text(
                                                    "Add Credit Card",
                                                    style:
                                                        TextStyle(fontSize: 12),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            SizedBox(
                                              height: 20,
                                            ),
                                          ],
                                        ),
                                        Expanded(
                                          child: Container(),
                                        ),
                                        Column(
                                          children: [
                                            SizedBox(
                                              height: 20,
                                            ),
                                            Row(
                                              children: [
                                                CircleAvatar(
                                                  backgroundColor:
                                                      Color.fromRGBO(
                                                          94, 167, 203, 1),
                                                  radius: 15,
                                                  child: Icon(
                                                    const IconData(0xe19f,
                                                        fontFamily:
                                                            'MaterialIcons'),
                                                    color: Colors.white,
                                                  ),
                                                ),
                                              ],
                                            )
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              //Expanded(child: Container()),
                              SizedBox(height: 20),
                              //third card
                              Card(
                                color: Colors.white,
                                elevation: 2.0,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20.0)),
                                child: Container(
                                  height: 120,
                                  width: MediaQuery.of(context).size.width,
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 15.0),
                                    child: Row(
                                      children: [
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            SizedBox(
                                              height: 20,
                                            ),
                                            Text(
                                              "Debit Cards",
                                              style: TextStyle(
                                                fontWeight: FontWeight.w600,
                                                fontSize: 15,
                                              ),
                                            ),
                                            Text(
                                              "0 Cards",
                                              style: TextStyle(
                                                fontWeight: FontWeight.w800,
                                                fontSize: 20,
                                                color: Colors.blue,
                                              ),
                                            ),
                                            Expanded(child: Container()),
                                            GestureDetector(
                                              onTap: () {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) {
                                                      return comingSoon();
                                                    },
                                                  ),
                                                );
                                              },
                                              child: Row(
                                                children: [
                                                  Icon(
                                                    const IconData(0xe047,
                                                        fontFamily:
                                                            'MaterialIcons'),
                                                  ),
                                                  SizedBox(
                                                    width: 5,
                                                  ),
                                                  Text(
                                                    "Add Debit Card",
                                                    style:
                                                        TextStyle(fontSize: 12),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            SizedBox(
                                              height: 20,
                                            ),
                                          ],
                                        ),
                                        Expanded(
                                          child: Container(),
                                        ),
                                        Column(
                                          children: [
                                            SizedBox(
                                              height: 20,
                                            ),
                                            Row(
                                              children: [
                                                CircleAvatar(
                                                  backgroundColor:
                                                      Color.fromRGBO(
                                                          94, 167, 203, 1),
                                                  radius: 15,
                                                  child: Icon(
                                                    const IconData(0xe19f,
                                                        fontFamily:
                                                            'MaterialIcons'),
                                                    color: Colors.white,
                                                  ),
                                                ),
                                              ],
                                            )
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(child: Container()),
                            ],
                          ),
                        ),
                      ),
                    ],
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
