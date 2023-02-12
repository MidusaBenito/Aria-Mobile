import 'dart:convert';
import 'dart:io';

import 'package:ariaquickpay/aria_wallet.dart';
import 'package:ariaquickpay/calendar.dart';
import 'package:ariaquickpay/contact.dart';
import 'package:ariaquickpay/custom_rect_tween.dart';
import 'package:ariaquickpay/faqs.dart';
import 'package:ariaquickpay/hero_dialog_route.dart';
import 'package:ariaquickpay/how_it_works.dart';
import 'package:ariaquickpay/login_page.dart';
import 'package:ariaquickpay/logout_splash.dart';
import 'package:ariaquickpay/manage_profile.dart';
import 'package:ariaquickpay/overview_breakdown.dart';
import 'package:ariaquickpay/payments.dart';
import 'package:ariaquickpay/utils.dart';
import 'package:flutter/material.dart' hide Badge;
import 'package:badges/src/badge.dart' as badges;
import 'package:http/http.dart';
import 'urls.dart' as myurls;
import 'colors.dart' as mycolor;
import 'package:badges/badges.dart';
import 'bills_profile.dart';
import 'models/models.dart';

class MyAppBar extends StatelessWidget implements PreferredSizeWidget {
  const MyAppBar({Key? key, required this.client}) : super(key: key);
  final Client client;
  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0.0,
      backgroundColor: Colors.white,
      title: Image.asset(
        "assets/images/aria-1.png",
        height: 40,
        width: 40,
      ),
      iconTheme: IconThemeData(
        color: mycolor.AppColor.registerPageBackground,
        size: 35,
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.only(
            top: 8,
          ),
          child: badges.Badge(
            badgeContent: FutureBuilder<List>(
              future: getMyMessages(client, 'getCount'),
              builder: (context, snapshot) {
                List my_messages = snapshot.data ?? [];
                switch (snapshot.connectionState) {
                  case ConnectionState.waiting:
                    return Text(
                      '0',
                      style: TextStyle(
                          fontSize: 10.0, fontWeight: FontWeight.w500),
                    );
                  default:
                    if (snapshot.hasError) {
                      //print(snapshot.error);
                      return Text(
                        '0',
                        style: TextStyle(
                            fontSize: 10.0, fontWeight: FontWeight.w500),
                      );
                    } else {
                      var unreadMessageCount = 0;
                      my_messages.forEach((message) {
                        if (message.readStatus == 'false') {
                          unreadMessageCount += 1;
                        }
                      });
                      //var unreadMessageCount = my_messages.length;

                      return Text(
                        '$unreadMessageCount',
                        style: TextStyle(
                            fontSize: 10.0, fontWeight: FontWeight.w500),
                      );
                    }
                }
              },
            ),
            toAnimate: false,
            shape: BadgeShape.square,
            position: BadgePosition.topEnd(top: 0, end: -4),
            badgeColor: const Color.fromARGB(255, 70, 105, 199),
            borderRadius: BorderRadius.circular(8),
            child: IconButton(
              iconSize: 26.0,
              onPressed: () {
                Navigator.of(context).push(HeroDialogRoute(
                    builder: (context) {
                      return notificationCard(
                        client: client,
                        itemType: 'message',
                      );
                    },
                    settings: RouteSettings(arguments: 'message')));
              },
              icon: const Icon(Icons.email),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 8, right: 5),
          child: badges.Badge(
            badgeContent: FutureBuilder<List>(
              future: getMyNotifications(client, 'getCount'),
              builder: (context, snapshot) {
                List my_notifications = snapshot.data ?? [];
                switch (snapshot.connectionState) {
                  case ConnectionState.waiting:
                    return Text(
                      '0',
                      style: TextStyle(
                          fontSize: 10.0, fontWeight: FontWeight.w500),
                    );
                  default:
                    if (snapshot.hasError) {
                      print(snapshot.error);
                      return Text(
                        '0',
                        style: TextStyle(
                            fontSize: 10.0, fontWeight: FontWeight.w500),
                      );
                    } else {
                      var unreadNotificationsCount = 0;
                      my_notifications.forEach((notification) {
                        if (notification.readStatus == 'false') {
                          unreadNotificationsCount += 1;
                        }
                      });
                      //var unreadNotificationsCount = my_notifications.length;
                      return Text(
                        '$unreadNotificationsCount',
                        style: TextStyle(
                            fontSize: 10.0, fontWeight: FontWeight.w500),
                      );
                    }
                }
              },
            ),
            toAnimate: false,
            shape: BadgeShape.square,
            position: BadgePosition.topEnd(top: 0, end: 1),
            badgeColor: Colors.amber,
            borderRadius: BorderRadius.circular(8),
            child: IconButton(
              iconSize: 26.0,
              onPressed: () {
                Navigator.of(context).push(HeroDialogRoute(
                    builder: (context) {
                      return notificationCard(
                        client: client,
                        itemType: 'notification',
                      );
                    },
                    settings: RouteSettings(arguments: 'notification')));
              },
              icon: const Icon(Icons.notifications),
            ),
          ),
        ),
        SizedBox(
          width: 10,
        ),
      ],
      //bottom: PreferredSize(
      //preferredSize: const Size.fromHeight(48.0),
      //child: Container(),
      //),
    );
  }

  @override
  Size get preferredSize => new Size.fromHeight(kToolbarHeight);
}

class MyBottomBar extends StatelessWidget {
  const MyBottomBar({Key? key, required this.client, required this.typeOfB})
      : super(key: key);
  final Client client;
  final String typeOfB;
  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Container(
            padding: const EdgeInsets.all(.1),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: typeOfB == "pay"
                  ? Color.fromARGB(255, 101, 158, 149)
                  : Colors.white,
            ),
            child: IconButton(
              highlightColor: Color.fromARGB(255, 189, 57, 149),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return Payments(
                        client: client,
                      );
                    },
                  ),
                );
              },
              icon: Image.asset(
                "assets/images/pay.png",
                height: 25,
                width: 25,
              ),
              tooltip: "Payments",
            ),
          ),
          Container(
            padding: const EdgeInsets.all(.1),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: typeOfB == "wallet"
                  ? Color.fromARGB(255, 101, 158, 149)
                  : Colors.white,
            ),
            child: IconButton(
              highlightColor: Color.fromARGB(255, 189, 57, 149),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return ariaWallet(client: client);
                    },
                  ),
                );
              },
              icon: Image.asset(
                "assets/images/wallet.png",
                height: 22,
                width: 22,
              ),
              tooltip: "Aria Wallet",
            ),
          ),
          Container(
            padding: const EdgeInsets.all(.1),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: typeOfB == "bill"
                  ? Color.fromARGB(255, 101, 158, 149)
                  : Colors.white,
            ),
            child: IconButton(
              highlightColor: Color.fromARGB(255, 189, 57, 149),
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
              icon: Image.asset(
                "assets/images/bill.png",
                height: 24,
                width: 24,
              ),
              tooltip: "Bill Profile",
            ),
          ),
          Container(
            padding: const EdgeInsets.all(.1),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: typeOfB == "calendar"
                  ? Color.fromARGB(255, 101, 158, 149)
                  : Colors.white,
            ),
            child: IconButton(
              highlightColor: Color.fromARGB(255, 189, 57, 149),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return calendarBills(client: client);
                    },
                  ),
                );
              },
              icon: Image.asset(
                "assets/images/calendar.png",
                height: 24,
                width: 24,
              ),
              tooltip: "Calendar",
            ),
          ),
        ],
      ),
    );
  }
}

class MyDrawer extends StatelessWidget {
  const MyDrawer({Key? key, required this.client}) : super(key: key);
  final Client client;
  @override
  Widget build(BuildContext context) {
    var userEmail = UserSimplePreferences.getUserEmail() ?? '';
    return Drawer(
      child: SafeArea(
        child: SingleChildScrollView(
            child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: 10.0,
          ),
          child: Column(
            children: [
              SizedBox(height: 5),
              Row(
                children: [
                  Icon(
                    const IconData(0xe043, fontFamily: 'MaterialIcons'),
                    size: 55,
                    color: Color.fromRGBO(94, 167, 203, 1),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Column(
                    children: [
                      Text(
                        userEmail,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) {
                                return manageProfile(
                                  client: client,
                                );
                              },
                            ),
                          );
                        },
                        child: Row(
                          children: [
                            Icon(
                              const IconData(0xe21a,
                                  fontFamily: 'MaterialIcons'),
                              size: 15,
                              color: Color.fromRGBO(94, 167, 203, 1),
                            ),
                            Text(
                              'Manage Profile',
                              style: TextStyle(
                                fontSize: 13,
                                color: Color.fromRGBO(94, 167, 203, 1),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const Divider(
                height: 10,
                thickness: 1,
                indent: 0,
                endIndent: 0,
                color: Colors.grey,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 15.0,
                ),
                child: Container(
                  height: MediaQuery.of(context).size.height - 150,
                  child: Column(
                    children: [
                      SizedBox(
                        height: 10,
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) {
                                return Faqs();
                              },
                            ),
                          );
                        },
                        child: Row(
                          children: [
                            Icon(
                              const IconData(0xe4fa,
                                  fontFamily: 'MaterialIcons'),
                              size: 20,
                              color: Color.fromRGBO(94, 167, 203, 1),
                            ),
                            SizedBox(
                              width: 20,
                            ),
                            Text('FAQs'),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) {
                                return howItWorks();
                              },
                            ),
                          );
                        },
                        child: Row(
                          children: [
                            Icon(
                              const IconData(0xf56b,
                                  fontFamily: 'MaterialIcons'),
                              size: 20,
                              color: Color.fromRGBO(94, 167, 203, 1),
                            ),
                            SizedBox(
                              width: 20,
                            ),
                            Text('How it Works'),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) {
                                return Support();
                              },
                            ),
                          );
                        },
                        child: Row(
                          children: [
                            Icon(
                              const IconData(0xe18c,
                                  fontFamily: 'MaterialIcons'),
                              size: 20,
                              color: Color.fromRGBO(94, 167, 203, 1),
                            ),
                            SizedBox(
                              width: 20,
                            ),
                            Text('Support'),
                          ],
                        ),
                      ),
                      Expanded(child: Container()),
                      GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) {
                                return logOutSplash(
                                  client: client,
                                );
                              },
                            ),
                          );
                        },
                        child: Row(
                          children: [
                            Icon(
                              const IconData(0xe3b3,
                                  fontFamily: 'MaterialIcons'),
                              size: 20,
                              color: Color.fromRGBO(94, 167, 203, 1),
                            ),
                            SizedBox(
                              width: 20,
                            ),
                            Text('Logout'),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        )),
      ),
    );
  }
}

class walletBalance extends StatelessWidget {
  walletBalance({Key? key, required this.client, required this.colString})
      : super(key: key);
  final Client client;
  final String colString;

  @override
  Widget build(BuildContext context) {
    //balanceWallet = getWalletBalance(client);
    return FutureBuilder<String>(
        future: getWalletBalance(client),
        builder: (context, snapshot) {
          String balanceWallet = snapshot.data ?? '0.00';
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return Text("0.00",
                  style: TextStyle(
                      fontSize: colString == 'blue' ? 18 : 15,
                      fontWeight: FontWeight.w500,
                      color: colString == 'blue'
                          ? Color.fromRGBO(94, 167, 203, 1)
                          : Color.fromARGB(255, 255, 255, 255)));
            default:
              if (snapshot.hasError) {
                //print(snapshot.error);
                return Text("00.00",
                    style: TextStyle(
                        fontSize: colString == 'blue' ? 18 : 15,
                        fontWeight: FontWeight.w500,
                        color: colString == 'blue'
                            ? Color.fromRGBO(94, 167, 203, 1)
                            : Color.fromARGB(255, 255, 255, 255)));
              } else {
                return Text(
                  "\$ $balanceWallet",
                  style: TextStyle(
                      fontSize: colString == 'blue' ? 18 : 15,
                      fontWeight: FontWeight.w500,
                      color: colString == 'blue'
                          ? Color.fromRGBO(94, 167, 203, 1)
                          : Color.fromARGB(255, 255, 255, 255)),
                );
              }
          }
        });
  }
}

Future<String> getWalletBalance(client) async {
  final url = myurls.AriaApiEndpoints.getWalletBalance;
  final userToken = UserSimplePreferences.getUserToken() ?? '';
  List<mywalletBalance> wallet_balance_response = [];
  if (userToken != '') {
    var getWalletBalanceResponse = await client.get(
      Uri.parse(url),
      headers: {
        HttpHeaders.authorizationHeader: 'Token $userToken',
      },
    );
    if (getWalletBalanceResponse.statusCode == 200) {
      var getWalletBalanceResponseJsons =
          json.decode(getWalletBalanceResponse.body);
      wallet_balance_response
          .add(mywalletBalance.fromJson(getWalletBalanceResponseJsons));
    } //end if
    ///print("Wallet ${wallet_balance_response[0].wallet_balance}");
    return wallet_balance_response[0].wallet_balance;
  } //end if
  return "0.00";
} //end of future function

Future<List> getPaymentHistory(client) async {
  final url = myurls.AriaApiEndpoints.getPaymentHistory;
  final userToken = UserSimplePreferences.getUserToken() ?? '';
  List<paymentHistory> payment_history_response = [];
  if (userToken != '') {
    var getPaymentHistoryResponse = await client.get(
      Uri.parse(url),
      headers: {
        HttpHeaders.authorizationHeader: 'Token $userToken',
      },
    );
    if (getPaymentHistoryResponse.statusCode == 200) {
      var getPaymentHistoryResponseJsons =
          json.decode(getPaymentHistoryResponse.body);
      getPaymentHistoryResponseJsons =
          getPaymentHistoryResponseJsons['payment_history'];
      for (var paymentItem in getPaymentHistoryResponseJsons) {
        payment_history_response.add(paymentHistory.fromJson(paymentItem));
      }
    } //end if
  } //end if
  return payment_history_response;
} //end if

class paymentOverview extends StatelessWidget {
  const paymentOverview(
      {Key? key,
      required this.client,
      required this.totalPaid,
      required this.lastMonth,
      required this.payment_history,
      required this.last_month_history})
      : super(key: key);
  final Client client;
  final double totalPaid;
  final double lastMonth;
  final List<dynamic> payment_history;
  final List<dynamic> last_month_history;
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          SizedBox(
            height: 10,
          ),
          Row(
            children: [
              Text("Overview", style: TextStyle(fontSize: 13)),
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
                padding: const EdgeInsets.symmetric(horizontal: 15.0),
                child: Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 20,
                        ),
                        Text(
                          "Total Paid",
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 15,
                          ),
                        ),
                        Text(
                          "\$ $totalPaid",
                          style: TextStyle(
                            fontWeight: FontWeight.w800,
                            fontSize: 20,
                            color: Colors.blue,
                          ),
                        ),
                        //
                        Expanded(child: Container()),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) {
                                  return overviewBreakdown(
                                    payment_history: payment_history,
                                    screenTitle: 'Payment History',
                                    paymentDescription: 'All Payments',
                                  );
                                },
                              ),
                            );
                          },
                          child: Row(
                            children: [
                              Icon(const IconData(0xf845,
                                  fontFamily: 'MaterialIcons',
                                  matchTextDirection: true)),
                              SizedBox(
                                width: 5,
                              ),
                              Text(
                                "View",
                                style: TextStyle(fontSize: 12),
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
                              backgroundColor: Color.fromRGBO(94, 167, 203, 1),
                              radius: 15,
                              child: Icon(
                                const IconData(0xe156,
                                    fontFamily: 'MaterialIcons'),
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            CircleAvatar(
                              backgroundColor: Color.fromRGBO(94, 167, 203, 1),
                              radius: 15,
                              child: Icon(
                                const IconData(0xe156,
                                    fontFamily: 'MaterialIcons'),
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
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
                padding: const EdgeInsets.symmetric(horizontal: 15.0),
                child: Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 20,
                        ),
                        Text(
                          "Last Month",
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 15,
                          ),
                        ),
                        Text(
                          "\$ $lastMonth",
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
                                  return overviewBreakdown(
                                    payment_history: last_month_history,
                                    screenTitle: 'Payment History',
                                    paymentDescription: 'Last Month',
                                  );
                                },
                              ),
                            );
                          },
                          child: Row(
                            children: [
                              Icon(const IconData(0xf845,
                                  fontFamily: 'MaterialIcons',
                                  matchTextDirection: true)),
                              SizedBox(
                                width: 5,
                              ),
                              Text(
                                "View",
                                style: TextStyle(fontSize: 12),
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
                              backgroundColor: Color.fromRGBO(94, 167, 203, 1),
                              radius: 15,
                              child: Icon(
                                const IconData(0xe156,
                                    fontFamily: 'MaterialIcons'),
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
                padding: const EdgeInsets.symmetric(horizontal: 15.0),
                child: Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 20,
                        ),
                        Text(
                          "Pending Bills",
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 15,
                          ),
                        ),
                        Text(
                          "\$ 0.00",
                          style: TextStyle(
                            fontWeight: FontWeight.w800,
                            fontSize: 20,
                            color: Colors.blue,
                          ),
                        ),
                        Expanded(child: Container()),
                        GestureDetector(
                          onTap: () {},
                          child: Row(
                            children: [
                              Icon(const IconData(0xf845,
                                  fontFamily: 'MaterialIcons',
                                  matchTextDirection: true)),
                              SizedBox(
                                width: 5,
                              ),
                              Text(
                                "View",
                                style: TextStyle(fontSize: 12),
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
                              backgroundColor: Color.fromRGBO(94, 167, 203, 1),
                              radius: 15,
                              child: Icon(
                                const IconData(0xe072,
                                    fontFamily: 'MaterialIcons'),
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
    );
  }
}

Future<List> getMyMessages(client, action) async {
  final url = myurls.AriaApiEndpoints.getMessages;
  final userToken = UserSimplePreferences.getUserToken() ?? '';
  List<myMessagesResponse> my_messages_response = [];
  if (userToken != '') {
    var getMyMessagesResponse = await client.post(Uri.parse(url), headers: {
      HttpHeaders.authorizationHeader: 'Token $userToken',
    }, body: {
      'action': action,
    });
    if (getMyMessagesResponse.statusCode == 200) {
      var getMyMessagesResponseJsons = json.decode(getMyMessagesResponse.body);
      getMyMessagesResponseJsons = getMyMessagesResponseJsons['my_messages'];
      for (var messageItem in getMyMessagesResponseJsons) {
        my_messages_response.add(myMessagesResponse.fromJson(messageItem));
      }
    } //end if
  } //end if
  return my_messages_response;
}

Future<List> getMyNotifications(client, action) async {
  final url = myurls.AriaApiEndpoints.getNotifications;
  final userToken = UserSimplePreferences.getUserToken() ?? '';
  List<myNotificationsResponse> my_notifications_response = [];
  if (userToken != '') {
    var getMyNotificationsResponse =
        await client.post(Uri.parse(url), headers: {
      HttpHeaders.authorizationHeader: 'Token $userToken',
    }, body: {
      'action': action,
    });
    if (getMyNotificationsResponse.statusCode == 200) {
      var getMyNotificationsResponseJsons =
          json.decode(getMyNotificationsResponse.body);
      getMyNotificationsResponseJsons =
          getMyNotificationsResponseJsons['my_notifications'];
      for (var notificationItem in getMyNotificationsResponseJsons) {
        my_notifications_response
            .add(myNotificationsResponse.fromJson(notificationItem));
      }
    } //end if
  } //end if
  return my_notifications_response;
}

class notificationCard extends StatefulWidget {
  const notificationCard(
      {Key? key, required this.itemType, required this.client})
      : super(key: key);
  final String itemType;
  final Client client;

  @override
  State<notificationCard> createState() => _notificationCardState();
}

class _notificationCardState extends State<notificationCard> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Hero(
        tag: 'Payment PopUp',
        createRectTween: (begin, end) {
          return CustomRectTween(begin: begin!, end: end!);
        },
        child: Material(
          color: Colors.white,
          elevation: 2,
          borderRadius: BorderRadius.all(Radius.circular(10.0)),
          child: Container(
            height: MediaQuery.of(context).size.height * .70,
            width: MediaQuery.of(context).size.width * .90,
            child: FutureBuilder<List>(
              future: widget.itemType == 'message'
                  ? getMyMessages(widget.client, 'display')
                  : getMyNotifications(widget.client, 'display'),
              builder: (context, snapshot) {
                var ItemsToDisplay = snapshot.data ?? [];
                return Column(
                  children: [
                    Expanded(
                        child: ListView.builder(
                      padding: const EdgeInsets.only(top: 0),
                      physics: BouncingScrollPhysics(),
                      itemCount: ItemsToDisplay.length,
                      itemBuilder: (context, index) {
                        var notificationItem = ItemsToDisplay[index];
                        switch (snapshot.connectionState) {
                          case ConnectionState.waiting:
                            return Column(
                              children: [
                                Expanded(child: Container()),
                                Center(
                                  child: CircularProgressIndicator(),
                                ),
                                Expanded(child: Container()),
                              ],
                            );
                          default:
                            if (snapshot.hasError) {
                              return Column(
                                children: [
                                  Expanded(child: Container()),
                                  Center(
                                    child: Text('Error loading messages!'),
                                  ),
                                  Expanded(child: Container()),
                                ],
                              );
                            } else {
                              return Card(
                                color: Colors.white,
                                elevation: 2.0,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5.0)),
                                child: Container(
                                  width: MediaQuery.of(context).size.width,
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 15.0,
                                      vertical: 20,
                                    ),
                                    child: Row(children: [
                                      Expanded(
                                        child: widget.itemType == 'message'
                                            ? Text(
                                                notificationItem.myMessages,
                                                style: TextStyle(
                                                  color: notificationItem
                                                              .readStatus ==
                                                          'false'
                                                      ? Color.fromARGB(
                                                          255, 2, 83, 123)
                                                      : Colors.black54,
                                                ),
                                              )
                                            : Text(
                                                notificationItem
                                                    .myNotifications,
                                                style: TextStyle(
                                                  color: notificationItem
                                                              .readStatus ==
                                                          'false'
                                                      ? Colors.amber
                                                      : Colors.black54,
                                                ),
                                              ),
                                      ),
                                    ]),
                                  ),
                                ),
                              );
                            }
                        }
                      },
                    )),
                  ],
                );
                //);
              },
            ),
          ),
        ),
      ),
    );
  }
}
