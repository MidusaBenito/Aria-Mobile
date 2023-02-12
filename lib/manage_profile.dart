import 'package:flutter/gestures.dart';
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
//import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:flag/flag.dart';

class manageProfile extends StatelessWidget {
  manageProfile({Key? key, required this.client}) : super(key: key);

  final Client client;

  //final TextEditingController _timezoneEditingController =
  //TextEditingController();
  final _formKey = GlobalKey<FormState>();
  String phoneNumber = '';
  //String initialCountry = 'US';
  //PhoneNumber number = PhoneNumber(isoCode: 'US');

  final timeZoneList = [
    {"value": "Hawaii", "display": "(GMT-10:00) Hawaii"},
    {"value": "Alaska", "display": "(GMT-09:00) Alaska"},
    {
      "value": "Pacific_Time",
      "display": "(GMT-08:00) Pacific Time (US & Canada)"
    },
    {"value": "Arizona", "display": "(GMT-07:00) Arizona"},
    {
      "value": "Mountain_Time",
      "display": "(GMT-07:00) Mountain Time (US & Canada)"
    },
    {
      "value": "Central_Time",
      "display": "(GMT-07:00) Mountain Time (US & Canada)"
    },
    {
      "value": "Eastern_Time",
      "display": "(GMT-05:00) Eastern_Time (US & Canada)"
    },
    {"value": "Indiana", "display": "(GMT-05:00) Indiana (East)"},
  ];
  //String? selectedFrequency = '';
  //final list =

  @override
  Widget build(BuildContext context) {
    var userEmail = UserSimplePreferences.getUserEmail() ?? '';
    List<timeZones> timeZone_list = [];
    for (var timezone in timeZoneList) {
      timeZone_list.add(timeZones.fromJson(timezone));
    }
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (BuildContext context) {
          return controlZipCodeWarning();
        }),
        ChangeNotifierProvider(create: (BuildContext context) {
          return controlPhoneNumberWarning();
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
                          ],
                        ),
                        Row(
                          children: [
                            SizedBox(
                              width: 15,
                            ),
                            Text(
                              'Manage Your Profile',
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
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 30.0),
                            child: Column(
                              children: [
                                SizedBox(height: 10),
                                Icon(
                                  const IconData(0xe043,
                                      fontFamily: 'MaterialIcons'),
                                  size: 90,
                                  color: Color.fromRGBO(94, 167, 203, 1),
                                ),
                                SizedBox(height: 5),
                                Text(
                                  userEmail,
                                  style: TextStyle(fontWeight: FontWeight.w500),
                                ),
                                SizedBox(height: 10),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        SizedBox(
                                          width: 5,
                                        ),
                                        Text(
                                          "Edit Profile",
                                          style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w500,
                                              color: Color.fromARGB(
                                                  255, 7, 79, 9)),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 15,
                                    ),
                                    FutureBuilder<List>(
                                      future: getProfile(),
                                      builder: (context, snapshot) {
                                        switch (snapshot.connectionState) {
                                          case ConnectionState.waiting:
                                            return Center(
                                              child:
                                                  CircularProgressIndicator(),
                                            );
                                          default:
                                            if (snapshot.hasError) {
                                              return Center(
                                                child: Text(
                                                    "Unable to load payment details!"),
                                              );
                                            } else {
                                              var profile_details =
                                                  snapshot.data ?? [];
                                              //print(profile_details[0].phone);
                                              if (profile_details != null &&
                                                  profile_details[0]
                                                          .phone
                                                          .length >
                                                      0) {
                                                //print('okay yeah');
                                                phoneNumber =
                                                    profile_details[0].phone;
                                                phoneNumber = phoneNumber
                                                    .replaceAll('+', '')
                                                    .substring(1);
                                              }
                                              final TextEditingController
                                                  _phoneEditingController =
                                                  TextEditingController(
                                                      text: phoneNumber);
                                              final TextEditingController
                                                  _zipEditingController =
                                                  TextEditingController(
                                                      text: profile_details[0]
                                                          .zip_code);
                                              return Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 5),
                                                child: Form(
                                                  key: _formKey,
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        "Mobile Number:",
                                                        style: TextStyle(
                                                            fontSize: 12),
                                                      ),
                                                      Row(children: [
                                                        Flag.fromCode(
                                                          FlagsCode.US,
                                                          height: 18,
                                                          width: 30,
                                                          fit: BoxFit.fill,
                                                        ),
                                                        SizedBox(
                                                          width: 10,
                                                        ),
                                                        Text(
                                                          "+1",
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600),
                                                        ),
                                                        SizedBox(
                                                          width: 40,
                                                        ),
                                                        Expanded(
                                                            child: Container(
                                                          child: Column(
                                                            children: [
                                                              SizedBox(
                                                                height: 10,
                                                              ),
                                                              TextFormField(
                                                                controller:
                                                                    _phoneEditingController,
                                                                //initialValue:
                                                                //phoneNumber,
                                                                maxLength: 10,
                                                                keyboardType:
                                                                    TextInputType
                                                                        .number,
                                                                smartDashesType:
                                                                    SmartDashesType
                                                                        .enabled,
                                                              ),
                                                            ],
                                                          ),
                                                        ))
                                                      ]),
                                                      Consumer<
                                                              controlPhoneNumberWarning>(
                                                          builder: (context,
                                                              value, child) {
                                                        if (value.showWarning ==
                                                            true) {
                                                          return validatePhoneNumber();
                                                        }
                                                        return Container();
                                                      }),
                                                      SizedBox(
                                                        height: 20,
                                                      ),
                                                      Text(
                                                        "Zip Code:",
                                                        style: TextStyle(
                                                            fontSize: 12),
                                                      ),
                                                      TextFormField(
                                                        controller:
                                                            _zipEditingController,
                                                        //initialValue:
                                                        //profile_details[0]
                                                        //.zip_code,
                                                        maxLength: 5,
                                                        keyboardType:
                                                            TextInputType
                                                                .number,
                                                      ),
                                                      Consumer<
                                                              controlZipCodeWarning>(
                                                          builder: (context,
                                                              value, child) {
                                                        if (value.showWarning ==
                                                            true) {
                                                          return validateZipCode();
                                                        }
                                                        return Container();
                                                      }),
                                                      SizedBox(height: 20),
                                                      Text(
                                                        "Time Zone:",
                                                        style: TextStyle(
                                                            fontSize: 12),
                                                      ),
                                                      DropdownButtonFormField(
                                                        value:
                                                            profile_details[0]
                                                                .time_zone,
                                                        items: timeZone_list
                                                            .map((e) {
                                                          return DropdownMenuItem(
                                                            child: Text(
                                                              e.zoneDisplay,
                                                              maxLines: 2,
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                              style: TextStyle(
                                                                  fontSize: 12),
                                                            ),
                                                            value: e.zoneValue,
                                                          );
                                                        }).toList(),
                                                        onChanged: (val) {
                                                          profile_details[0]
                                                              .time_zone = val;
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
                                                      Center(
                                                        child: ElevatedButton(
                                                            onPressed:
                                                                () async {
                                                              //print(
                                                              //'pressed $phoneNumber');
                                                              bool
                                                                  phoneEntered =
                                                                  false;
                                                              bool
                                                                  zipCodeEntered =
                                                                  false;
                                                              if (_phoneEditingController
                                                                      .text
                                                                      .length ==
                                                                  10) {
                                                                phoneEntered =
                                                                    true;
                                                                context
                                                                    .read<
                                                                        controlPhoneNumberWarning>()
                                                                    .updateWarningStatus(
                                                                        false);
                                                              }
                                                              if (_phoneEditingController
                                                                      .text
                                                                      .length <
                                                                  10) {
                                                                phoneEntered =
                                                                    false;
                                                                context
                                                                    .read<
                                                                        controlPhoneNumberWarning>()
                                                                    .updateWarningStatus(
                                                                        true);
                                                              }
                                                              if (_zipEditingController
                                                                      .text
                                                                      .length ==
                                                                  5) {
                                                                zipCodeEntered =
                                                                    true;
                                                                context
                                                                    .read<
                                                                        controlZipCodeWarning>()
                                                                    .updateWarningStatus(
                                                                        false);
                                                              }
                                                              if (_zipEditingController
                                                                      .text
                                                                      .length <
                                                                  5) {
                                                                zipCodeEntered =
                                                                    false;
                                                                context
                                                                    .read<
                                                                        controlZipCodeWarning>()
                                                                    .updateWarningStatus(
                                                                        true);
                                                              }
                                                              if (phoneEntered ==
                                                                      true &&
                                                                  zipCodeEntered ==
                                                                      true) {
                                                                //print('true');
                                                                final userToken =
                                                                    UserSimplePreferences
                                                                            .getUserToken() ??
                                                                        '';
                                                                final url = myurls
                                                                    .AriaApiEndpoints
                                                                    .editMyProfile;
                                                                phoneNumber =
                                                                    "+1${_phoneEditingController.text}";
                                                                //print(phoneNumber);
                                                                var response =
                                                                    await client
                                                                        .post(
                                                                  Uri.parse(
                                                                      url),
                                                                  headers: {
                                                                    HttpHeaders
                                                                            .authorizationHeader:
                                                                        'Token $userToken',
                                                                  },
                                                                  body: {
                                                                    'phone_number':
                                                                        phoneNumber,
                                                                    'time_zone':
                                                                        profile_details[0]
                                                                            .time_zone,
                                                                    'customer_zip_code':
                                                                        _zipEditingController
                                                                            .text,
                                                                  },
                                                                );
                                                                List<postProfile>
                                                                    post_profile_response =
                                                                    [];
                                                                if (response
                                                                        .statusCode ==
                                                                    200) {
                                                                  ScaffoldMessenger.of(
                                                                          context)
                                                                      .showSnackBar(
                                                                    const SnackBar(
                                                                        content:
                                                                            Text(
                                                                                'Saving...'),
                                                                        duration:
                                                                            Duration(milliseconds: 200)),
                                                                  );
                                                                  var responseJsons =
                                                                      json.decode(
                                                                          response
                                                                              .body);
                                                                  post_profile_response.add(
                                                                      postProfile
                                                                          .fromJson(
                                                                              responseJsons));
                                                                  if (post_profile_response[
                                                                              0]
                                                                          .editResponse ==
                                                                      'ok') {
                                                                    showDialog(
                                                                        context:
                                                                            context,
                                                                        builder: (_) =>
                                                                            AlertDialog(
                                                                              content: Column(
                                                                                mainAxisSize: MainAxisSize.min,
                                                                                children: [
                                                                                  Row(
                                                                                    children: const [
                                                                                      Icon(
                                                                                        Icons.check_circle,
                                                                                        color: Colors.green,
                                                                                      ),
                                                                                      SizedBox(
                                                                                        width: 2,
                                                                                      ),
                                                                                      Text(
                                                                                        "Profile Updated Successfully!",
                                                                                        style: TextStyle(fontSize: 11),
                                                                                      ),
                                                                                    ],
                                                                                  ),
                                                                                ],
                                                                              ),
                                                                            )).then(
                                                                        (val) {
                                                                      Navigator.pop(
                                                                          context);
                                                                    });
                                                                  } else {
                                                                    //print(
                                                                    //'something wrong');
                                                                  }
                                                                } else {
                                                                  //print(response
                                                                  // .statusCode);
                                                                  showDialog(
                                                                      context:
                                                                          context,
                                                                      builder:
                                                                          (_) =>
                                                                              AlertDialog(
                                                                                content: Column(
                                                                                  mainAxisSize: MainAxisSize.min,
                                                                                  children: [
                                                                                    Row(
                                                                                      children: const [
                                                                                        Icon(
                                                                                          Icons.close,
                                                                                          color: Color.fromARGB(255, 227, 15, 15),
                                                                                        ),
                                                                                        SizedBox(
                                                                                          width: 2,
                                                                                        ),
                                                                                        Text(
                                                                                          "Error updating profile. Please try again!",
                                                                                          style: TextStyle(fontSize: 11),
                                                                                        ),
                                                                                      ],
                                                                                    ),
                                                                                  ],
                                                                                ),
                                                                              ));
                                                                }
                                                              }
                                                            },
                                                            child:
                                                                Text('Save')),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              );
                                            }
                                        }
                                      },
                                      //child:
                                    ),
                                  ],
                                ),
                              ],
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
      ),
    );
  }

  Future<List> getProfile() async {
    final userToken = UserSimplePreferences.getUserToken() ?? '';
    final url = myurls.AriaApiEndpoints.getMyProfile;
    List<profileData> profile_data_response = [];
    if (userToken != '') {
      var getProfileDataResponse = await client.get(
        Uri.parse(url),
        headers: {
          HttpHeaders.authorizationHeader: 'Token $userToken',
        },
      );
      if (getProfileDataResponse.statusCode == 200) {
        //print('Okay');
        var getProfileDataResponseJsons =
            json.decode(getProfileDataResponse.body);
        profile_data_response
            .add(profileData.fromJson(getProfileDataResponseJsons));
        return profile_data_response;
      }
      //print('not okay');
      return profile_data_response;
    }
    return profile_data_response;
  }

  Widget validatePhoneNumber() {
    return Text(
      'Enter a valid mobile number!',
      style: TextStyle(color: Colors.redAccent),
    );
  }

  Widget validateZipCode() {
    return Text(
      'Enter a valid Zip Code!',
      style: TextStyle(color: Colors.redAccent),
    );
  }
}
