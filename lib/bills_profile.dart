import 'dart:convert';
import 'package:ariaquickpay/add_billers.dart';
import 'package:ariaquickpay/make_payments.dart';
import 'package:ariaquickpay/models/models.dart';
import 'package:ariaquickpay/utils.dart';
import 'package:flutter/material.dart' hide Badge;
import 'package:http/http.dart';
import 'package:provider/provider.dart';
import 'edit_biller.dart';
import 'urls.dart' as myurls;
import 'colors.dart' as mycolor;
import 'package:badges/badges.dart';
import 'my_widgets.dart';
import 'dart:io';
import 'aria_providers.dart';

class BillsProfile extends StatelessWidget {
  const BillsProfile({Key? key, required this.client}) : super(key: key);
  final Client client;
  //final BuildContext my_context;
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (BuildContext context) {
          return deleteBillers();
        }),
        //ChangeNotifierProvider(create: (BuildContext context) {
        // return numberOfBillers();
        //}),
      ],
      child: Scaffold(
        appBar: MyAppBar(
          client: client,
        ),
        drawer: MyDrawer(
          client: client,
        ),
        bottomNavigationBar: MyBottomBar(
          client: client,
          typeOfB: "bill",
        ),
        body: Container(
          height: MediaQuery.of(context).size.height,
          width: double.infinity,
          alignment: Alignment.center,
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
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15.0),
                child: Column(
                  children: [
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                        Container(
                          child: Text(
                            "Biller Profile",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                              fontSize: 17,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Container(),
                        ),
                        Container(
                          child: Column(
                            children: [
                              //ValueListenableBuilder(
                              //valueListenable: number_of_billers,
                              // builder: (BuildContext context,
                              //  mynumberOfBillers, child) {
                              // print('this place is hit!!');
                              //return billersTotal(mynumberOfBillers);
                              //}),
                              Consumer<deleteBillers>(
                                  builder: (context, value, child) {
                                return billersTotal(UserSimplePreferences
                                        .getNumberOfBillers() ??
                                    0);
                              }),
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) {
                                        return AddBillers(client: client);
                                      },
                                    ),
                                  );
                                },
                                child: Row(
                                  children: [
                                    Icon(
                                      const IconData(0xe047,
                                          fontFamily: 'MaterialIcons'),
                                      color: Colors.white,
                                    ),
                                    Text(
                                      "Add",
                                      style: TextStyle(
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Container(
                  //height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
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
                    child: Column(
                      children: [
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          children: [
                            Text("My Billers"),
                          ],
                        ),
                        Expanded(
                          child: Container(
                            child: Column(
                              children: [
                                SizedBox(
                                  height: 20,
                                ),
                                Row(
                                  children: [
                                    SizedBox(
                                      width: 90,
                                      child: Text(
                                        'Biller',
                                        style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.w500),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 90,
                                      child: Text(
                                        'Category',
                                        style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.w500),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 70,
                                      child: Text(
                                        'Next Due',
                                        style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.w500),
                                      ),
                                    ),
                                  ],
                                ),
                                Container(
                                  child: FutureBuilder<List>(
                                    future: getMyBillers(),
                                    builder: (context, snapshot) {
                                      var billers = snapshot.data ?? [];
                                      switch (snapshot.connectionState) {
                                        case ConnectionState.waiting:
                                          return Center(
                                            child: CircularProgressIndicator(),
                                          );
                                        default:
                                          if (snapshot.hasError) {
                                            //print(snapshot.error);
                                            return Center(
                                              child: Column(
                                                children: [
                                                  SizedBox(height: 10),
                                                  Text(
                                                      "Unable to load biller profile. Try Again!"),
                                                  SizedBox(height: 10),
                                                ],
                                              ),
                                            );
                                          } else {
                                            //return buildBillers(billers);
                                            return Consumer<deleteBillers>(
                                                builder:
                                                    (context, value, child) {
                                              //print("doing it now now!");
                                              //number_of_billers
                                              //.refreshNumberOfBillers();
                                              return buildBillers(billers);
                                            });
                                          }
                                      }
                                    },
                                  ),
                                ),
                                //testing
                                SizedBox(
                                  height: 40,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      TextButton(
                                          onPressed: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) {
                                                  return AddBillers(
                                                      client: client);
                                                },
                                              ),
                                            );
                                          },
                                          child: Text("Add Biller"))
                                    ],
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
              ),
            ],
          ),
        ),
      ),
    );
  }

  //Method to get bill profile
  Future<List> getMyBillers() async {
    final url = myurls.AriaApiEndpoints.billProfile;
    final userToken = UserSimplePreferences.getUserToken() ?? '';
    List<MyBillers> biller_list_response = [];
    //List<String> biller_date_response = [];
    if (userToken != '') {
      var getBillerResponse = await client.get(
        Uri.parse(url),
        headers: {
          HttpHeaders.authorizationHeader: 'Token $userToken',
        },
      );

      if (getBillerResponse.statusCode == 200) {
        var getBillerResponseJsons = json.decode(getBillerResponse.body);
        for (var bill in getBillerResponseJsons) {
          biller_list_response.add(MyBillers.fromJson(bill));
        }
        await UserSimplePreferences.setNumberOfBillers(
            biller_list_response.length);
        return biller_list_response;
      } else {
        return biller_list_response;
      }
    }

    return biller_list_response;
  }

  Widget buildBillers(biller_list_response) {
    //number_of_billers.refreshNumberOfBillers();
    return Expanded(
      child: ListView.builder(
        physics: BouncingScrollPhysics(),
        itemCount: biller_list_response.length,
        itemBuilder: (context, index) {
          var biller = biller_list_response[index];
          return Padding(
            padding: EdgeInsets.symmetric(vertical: 10),
            child: Container(
              width: MediaQuery.of(context).size.width,
              child: Row(
                children: [
                  SizedBox(
                    width: 90,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        biller.biller_logo_url == 'no_media'
                            ? Image.asset(
                                "assets/images/no-image.png",
                                height: 45,
                                width: 45,
                                fit: BoxFit.fill,
                                alignment: Alignment.center,
                                repeat: ImageRepeat.noRepeat,
                              )
                            : Image.network(
                                myurls.AriaApiEndpoints
                                        .imageBase + //remember to sort it out on production
                                    biller.biller_logo_url,
                                height: 45,
                                width: 45,
                                fit: BoxFit.fill,
                                alignment: Alignment.center,
                                repeat: ImageRepeat.noRepeat,
                              ),
                        Text(
                          biller.biller_name,
                          style: TextStyle(fontSize: 10),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                      width: 90,
                      child: Text(
                        biller.biller_category,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(fontSize: 12),
                      )),
                  SizedBox(
                      width: 70,
                      child: biller.next_due == 'Not Set'
                          ? GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) {
                                      return EditBiller(
                                        client: client,
                                        billerName: biller.biller_name,
                                        billerId: biller.biller_id,
                                      );
                                    },
                                  ),
                                );
                              },
                              child: Row(
                                children: [
                                  Icon(
                                    const IconData(0xf06ae,
                                        fontFamily: 'MaterialIcons'),
                                    color: Colors.blue,
                                  ),
                                  Text(
                                    "Set Date",
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Color.fromARGB(255, 1, 40, 57),
                                    ),
                                  ),
                                ],
                              ),
                            )
                          : GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) {
                                      return EditBiller(
                                        client: client,
                                        billerName: biller.biller_name,
                                        billerId: biller.biller_id,
                                      );
                                    },
                                  ),
                                );
                              },
                              child: Text(
                                biller.next_due,
                                style: TextStyle(fontSize: 12),
                              ))),
                  Expanded(
                    child: Container(
                      //width: MediaQuery.of(context).size.width,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Expanded(
                              child: TextButton(
                                  onPressed: () {
                                    {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) {
                                            return makePayment(
                                              client: client,
                                              billerName: biller.biller_name,
                                              billerId: biller.biller_id,
                                              billerLogo:
                                                  biller.biller_logo_url,
                                              billerCat: biller.biller_category,
                                              billingAccntNumber:
                                                  biller.billing_account_number,
                                            );
                                          },
                                        ),
                                      );
                                    }
                                  },
                                  child: Text("Pay",
                                      style: TextStyle(fontSize: 12)))),
                          Expanded(
                            child: IconButton(
                              onPressed: () {
                                String biller_id = biller.biller_id.toString();

                                context.read<deleteBillers>().billDelete(
                                      client,
                                      biller_id,
                                      biller_list_response,
                                      biller,
                                    );
                                //print(biller.biller_id);
                                //number_of_billers.refreshNumberOfBillers();
                              },
                              icon: Icon(
                                const IconData(0xe1b9,
                                    fontFamily: 'MaterialIcons'),
                              ),
                              iconSize: 15.0,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget billersTotal(totalBillers) {
    //int totalBillers = 0;
    if (totalBillers == 1) {
      return Text(
        "$totalBillers Biller",
        style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
      );
    } else {
      return Text(
        "$totalBillers Billers",
        style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
      );
    }
  }
}
