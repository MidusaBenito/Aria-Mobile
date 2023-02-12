import 'dart:convert';
import 'package:ariaquickpay/bills_profile.dart';
import 'package:ariaquickpay/models/billers.dart';
import 'package:ariaquickpay/models/category.dart';
import 'package:ariaquickpay/models/models.dart';
import 'package:ariaquickpay/utils.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';
import 'aria_providers.dart';
import 'urls.dart' as myurls;
import 'colors.dart' as mycolor;
import 'package:badges/badges.dart';
import 'my_widgets.dart';
import 'dart:io';

class AddBillers extends StatelessWidget {
  const AddBillers({Key? key, required this.client}) : super(key: key);
  final Client client;
  // ignore: prefer_typing_uninitialized_variables
  //static var billsList = [];

  //@override
  //State<AddBillers> createState() => _AddBillersState();
//}

//class _AddBillersState extends State<AddBillers> {

  //static final _formKey = GlobalKey<FormState>();
  //late Future<List> getAllBillersFuture;

  //void initState() {
  //super.initState();
  //getAllBillersFuture = getAllMyBillers();
  // }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      //create: (context) => changeDisplayBillers(),
      //builder: (context, child) {
      providers: [
        ChangeNotifierProvider(create: (BuildContext context) {
          return changeDisplayBillers();
        }),
        ChangeNotifierProvider(create: (BuildContext context) {
          return addBillers();
        }),
        ChangeNotifierProvider(create: (BuildContext context) {
          return showSearchedBillers();
        }),
      ],
      child: SafeArea(
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

                        Row(
                          children: [
                            SizedBox(
                              width: 15,
                            ),
                            Text("Add Billers"),
                            Expanded(child: Container()),
                            Consumer<addBillers>(
                                builder: (context, value, child) {
                              //print("added");
                              return billersTotal(
                                  UserSimplePreferences.getNumberOfBillers() ??
                                      0);
                            }),
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
                    //height: MediaQuery.of(context).size.height,
                    width: double.infinity,
                    alignment: Alignment.center,
                    //width: MediaQuery.of(context).size.width,
                    child: FutureBuilder<List>(
                      future: getAllMyBillers(),
                      builder: (context, snapshot) {
                        var all_billers = snapshot.data ?? [];
                        //print(all_billers.length);
                        switch (snapshot.connectionState) {
                          case ConnectionState.waiting:
                            return Center(
                              child: CircularProgressIndicator(),
                            );
                          default:
                            if (snapshot.hasError) {
                              return Center(
                                child: Text("Unable to load biller profile!"),
                              );
                            } else {
                              return Consumer<changeDisplayBillers>(
                                  builder: (context, value, child) {
                                return buildAllBillers(
                                    all_billers, value.displayIndex);
                              });
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
      ),
    );
  }
  //}

  //Method to get all biller categories and billers
  Future<List> getAllMyBillers() async {
    final url = myurls.AriaApiEndpoints.getAllBillers;
    final userToken = UserSimplePreferences.getUserToken() ?? '';
    List<Category> biller_category_response = [];
    //List<Billers> biller_list_response = [];
    if (userToken != '') {
      var getAllMyBillersResponse = await client.get(
        Uri.parse(url),
        headers: {
          HttpHeaders.authorizationHeader: 'Token $userToken',
        },
      );
      if (getAllMyBillersResponse.statusCode == 200) {
        var getAllMyBillersResponseJsons =
            json.decode(getAllMyBillersResponse.body);
        //print(getAllMyBillersResponse);
        for (var category in getAllMyBillersResponseJsons) {
          biller_category_response.add(Category.fromJson(category));
        }
        //billsList = biller_category_response;
        return biller_category_response;
      } else {
        //billsList = biller_category_response;
        return biller_category_response;
      }
    }
    //billsList = biller_category_response;
    return biller_category_response;
  }

  Future<List> getCategoryBillers(
      biller_category_response, String catId, String billId, billIndex) async {
    List<Category> get_category_response = [];
    final url = myurls.AriaApiEndpoints.addSingleBiller;
    final userToken = UserSimplePreferences.getUserToken() ?? '';
    //List<Category> biller_category_response = [];
    if (userToken != '') {
      var getAllMyBillersResponse = await client.post(
        Uri.parse(url),
        headers: {
          HttpHeaders.authorizationHeader: 'Token $userToken',
        },
        body: {
          'catId': catId,
          'billId': billId
          //'searchStatus': searchStatus,
          //'searchWord': searchWord
        },
      );
      if (getAllMyBillersResponse.statusCode == 200) {
        var getAllMyBillersResponseJsons =
            json.decode(getAllMyBillersResponse.body);
        int billNumbers = UserSimplePreferences.getNumberOfBillers() ?? 0;
        UserSimplePreferences.setNumberOfBillers(billNumbers + 1);
        //print(getAllMyBillersResponse);
        for (var category in getAllMyBillersResponseJsons) {
          get_category_response.add(Category.fromJson(category));
        }
        //return get_category_response[0].category_billers;
        var my_category_billers = get_category_response[0].category_billers;
        biller_category_response[billIndex].category_billers =
            my_category_billers;
        //billsList = biller_category_response;
        return biller_category_response;
      } else {
        //billsList = biller_category_response;
        return biller_category_response;
      }
    }
    //billsList = biller_category_response;
    return biller_category_response;
  }

  Future<List> searchBillers(biller_category_response, String catId,
      String searchWord, billIndex) async {
    List<Category> get_search_response = [];
    final url = myurls.AriaApiEndpoints.searchBillerUrl;
    final userToken = UserSimplePreferences.getUserToken() ?? '';
    if (userToken != '') {
      var searchBillersResponse = await client.post(
        Uri.parse(url),
        headers: {
          HttpHeaders.authorizationHeader: 'Token $userToken',
        },
        body: {
          'catId': catId,
          //'billId': billId
          'searchWord': searchWord
        },
      );
      if (searchBillersResponse.statusCode == 200) {
        var searchBillersResponseJsons =
            json.decode(searchBillersResponse.body);
        for (var category in searchBillersResponseJsons) {
          get_search_response.add(Category.fromJson(category));
        }
        var my_search_category_billers =
            get_search_response[0].category_billers;
        biller_category_response[billIndex].category_billers =
            my_search_category_billers;
        //billsList = biller_category_response;
        return biller_category_response;
      } else {
        //billsList = biller_category_response;
        return biller_category_response;
      }
    } else {
      //billsList = biller_category_response;
      return biller_category_response;
    }
  }

  Widget buildAllBillers(biller_category_response, displayIndex) {
    final TextEditingController _textEditingController =
        TextEditingController();
    //int displayIndex = 0;
    return Container(
      child: ListView.builder(
        padding: EdgeInsets.zero,
        physics: BouncingScrollPhysics(),
        itemCount: biller_category_response.length,
        itemBuilder: (context, index) {
          var category = biller_category_response[index];
          var cat_billers = category.category_billers;
          //print(category.category_name + ': ${cat_billers.length}');
          return Padding(
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 30),
            child: Column(
              children: [
                GestureDetector(
                  onTap: () {
                    //print(index);
                    context.read<changeDisplayBillers>().changeIndex(index);
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Color.fromARGB(255, 255, 255, 255),
                          Color.fromARGB(255, 255, 255, 255),
                        ],
                      ),
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(20.0),
                        topLeft: Radius.circular(20.0),
                      ),
                    ),
                    width: MediaQuery.of(context).size.width,
                    height: 40,
                    child: Row(
                      children: [
                        SizedBox(
                          width: 10,
                        ),
                        CircleAvatar(
                          backgroundColor: Color.fromARGB(255, 0, 0, 0),
                          radius: 12,
                          child: Icon(
                            const IconData(0xe047, fontFamily: 'MaterialIcons'),
                            color: Colors.white,
                            size: 14,
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          category.category_name,
                          style: TextStyle(
                            fontSize: 16,
                          ),
                        ),
                        Expanded(
                          child: Container(),
                        ),
                        Icon(
                          const IconData(0xee8a, fontFamily: 'MaterialIcons'),
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  child: Column(
                    //mainAxisAlignment: MainAxisAlignment.start,
                    children: index == displayIndex
                        ? [
                            SizedBox(
                              height: 10,
                            ),
                            TextFormField(
                              controller: _textEditingController,
                              onChanged: (value) async {
                                var searchResponse = await searchBillers(
                                  biller_category_response,
                                  category.category_id,
                                  value,
                                  displayIndex,
                                );
                                if (searchResponse.length >= 0) {
                                  //print(searchResponse);
                                  context
                                      .read<showSearchedBillers>()
                                      .showBillers();
                                }
                              },
                              style: TextStyle(
                                color: Color.fromARGB(255, 0, 0, 0),
                              ),
                              decoration: InputDecoration(
                                contentPadding:
                                    EdgeInsets.symmetric(vertical: 0),
                                filled: true,
                                fillColor: Color.fromRGBO(94, 167, 203, 1)
                                    .withOpacity(.2),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8.0),
                                  borderSide: BorderSide.none,
                                ),
                                hintText: "Search a biller in this category",
                                prefixIcon: Icon(Icons.search),
                                prefixIconColor: Colors.purple.shade900,
                                isDense: true, // important line
                                //contentPadding: EdgeInsets.fromLTRB(5, 0, 5, 0),
                              ),
                            ),
                            Consumer<showSearchedBillers>(
                                builder: (context, value, child) {
                              cat_billers =
                                  biller_category_response[displayIndex]
                                      .category_billers;
                              if (cat_billers.length > 0) {
                                return buildCatBillers(
                                    cat_billers,
                                    biller_category_response,
                                    category.category_id,
                                    displayIndex,
                                    context);
                              } else {
                                return noBillers();
                              }
                            }),
                          ]
                        : [],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  /// child: Column(),
  // );
  //}
  Widget buildCatBillers(cat_billers,
      [billler_category_response, catId, billIndex, mycontext]) {
    //print("rebuilding");
    //print(billler_category_response[billIndex].category_billers.length);
    return GridView.count(
      padding: EdgeInsets.only(top: 10),
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      crossAxisCount: 3,
      //padding: EdgeInsets.all(10),
      crossAxisSpacing: 5,
      mainAxisSpacing: 5,
      children: cat_billers
          .map<Widget>(
            (biller) => GestureDetector(
              onTap: () async {
                //print(biller.biller_name);
                var billerAddResponse = await getCategoryBillers(
                    billler_category_response,
                    catId,
                    biller.biller_id,
                    billIndex
                    //'false',
                    //''
                    );
                if (billerAddResponse.length >= 0) {
                  //print('done');
                  Provider.of<changeDisplayBillers>(mycontext, listen: false)
                      .changeIndex(billIndex);
                  Provider.of<addBillers>(mycontext, listen: false)
                      .updateNumber();
                  //mycontext
                  //.read<changeDisplayBillers>()
                  // .changeIndex(billIndex);
                }
              },
              child: Card(
                color: Colors.white,
                elevation: 2,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0)),
                child: Container(
                  height: 105,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5.0),
                    child: Column(children: [
                      SizedBox(
                        height: 5,
                      ),
                      biller.logo_url == 'no_media'
                          ? Image.asset(
                              "assets/images/no-image.png",
                              height: 65,
                              width: 75,
                              fit: BoxFit.fill,
                              alignment: Alignment.center,
                              repeat: ImageRepeat.noRepeat,
                            )
                          : Image.network(
                              myurls.AriaApiEndpoints
                                      .imageBase + //remember to sort it out on production
                                  biller.logo_url,
                              height: 65,
                              width: 75,
                              fit: BoxFit.fill,
                              alignment: Alignment.center,
                              repeat: ImageRepeat.noRepeat,
                            ),
                      Expanded(child: Container()),
                      Text(
                        biller.biller_name,
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            fontSize: 10,
                            color: Color.fromARGB(255, 2, 94, 30),
                            fontWeight: FontWeight.w500),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                    ]),
                  ),
                ),
              ),
            ),
          )
          .toList(),
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

  Widget noBillers() {
    return Column(
      children: [
        SizedBox(
          height: 20,
        ),
        Text(
          "0 billers found!",
          style: TextStyle(
              color: Color.fromARGB(255, 207, 2, 2),
              fontWeight: FontWeight.w600),
        ),
      ],
    );
  }
}
