import 'dart:convert';
import 'dart:ui';
import 'package:flutter/material.dart';
//import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'urls.dart' as myurls;
import 'colors.dart' as mycolor;
import 'login_page.dart';
import 'models/models.dart';
import 'registration_succesful.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'utils.dart';

class registerPage extends StatefulWidget {
  const registerPage({Key? key, required this.client}) : super(key: key);
  final Client client;

  @override
  State<registerPage> createState() => _registerPageState();
}

class _registerPageState extends State<registerPage> {
  bool isPasswordVisible = false;
  bool isConfirmPasswordVisible = false;
  bool _isEmailValid = false;
  bool _isPass1Valid = false;
  bool _isPass2Valid = false;
  final _formKey = GlobalKey<FormState>();

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordOneController = TextEditingController();
  final TextEditingController passwordTwoController = TextEditingController();
  String signUpError = "";
  String userEmail = '';

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          height: double.infinity,
          width: double.infinity,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                mycolor.AppColor.registerPageBackground,
                mycolor.AppColor.registerPageHeaderColor1,
              ],
            ),
          ),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  SizedBox(
                    height: 30,
                  ),
                  CircleAvatar(
                    backgroundColor: Colors.white,
                    radius: 50,
                    child: Image.asset(
                      "assets/images/aria-1.png",
                      height: 50,
                      width: 50,
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  showAlert(),
                  SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 30)
                        .copyWith(bottom: 10),
                    child: TextFormField(
                      controller: emailController,
                      keyboardType: TextInputType.emailAddress,
                      style: TextStyle(color: Colors.white, fontSize: 14.5),
                      decoration: InputDecoration(
                          prefixIconConstraints: BoxConstraints(minWidth: 45),
                          prefixIcon: Icon(
                            Icons.email,
                            color: Colors.white70,
                            size: 22,
                          ),
                          border: InputBorder.none,
                          hintText: 'Enter Email',
                          hintStyle:
                              TextStyle(color: Colors.white60, fontSize: 14.5),
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(100)
                                  .copyWith(bottomRight: Radius.circular(0)),
                              borderSide: BorderSide(color: Colors.white38)),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(100)
                                  .copyWith(bottomRight: Radius.circular(0)),
                              borderSide: BorderSide(color: Colors.white70))),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Email cannot be empty!';
                        }
                        if (value.isNotEmpty &&
                            !RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                .hasMatch(value)) {
                          return 'Enter a valid email address!';
                        }
                        return null;
                      },
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 30)
                        .copyWith(bottom: 10),
                    child: TextFormField(
                      controller: passwordOneController,
                      style: TextStyle(color: Colors.white, fontSize: 14.5),
                      obscureText: isPasswordVisible ? false : true,
                      decoration: InputDecoration(
                          prefixIconConstraints: BoxConstraints(minWidth: 45),
                          prefixIcon: Icon(
                            Icons.lock,
                            color: Colors.white70,
                            size: 22,
                          ),
                          suffixIconConstraints:
                              BoxConstraints(minWidth: 45, maxWidth: 46),
                          suffixIcon: GestureDetector(
                            onTap: () {
                              setState(() {
                                isPasswordVisible = !isPasswordVisible;
                              });
                            },
                            child: Icon(
                              isPasswordVisible
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                              color: Colors.white70,
                              size: 22,
                            ),
                          ),
                          border: InputBorder.none,
                          hintText: 'Enter Password',
                          hintStyle:
                              TextStyle(color: Colors.white60, fontSize: 14.5),
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(100)
                                  .copyWith(bottomRight: Radius.circular(0)),
                              borderSide: BorderSide(color: Colors.white38)),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(100)
                                  .copyWith(bottomRight: Radius.circular(0)),
                              borderSide: BorderSide(color: Colors.white70))),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'You have not entered a password!';
                        } else {
                          if (value.length < 8) {
                            return "Password too short. Must be at least 8 characters";
                          } else {
                            if (!RegExp(r"(?=.*\d)(?=.*[a-z])(?=.*\W)")
                                .hasMatch(value)) {
                              return "Password must contain at least a special character e.g '@'";
                            }
                          }
                        }

                        return null;
                      },
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 30)
                        .copyWith(bottom: 10),
                    child: TextFormField(
                      controller: passwordTwoController,
                      style: TextStyle(color: Colors.white, fontSize: 14.5),
                      obscureText: isConfirmPasswordVisible ? false : true,
                      decoration: InputDecoration(
                          prefixIconConstraints: BoxConstraints(minWidth: 45),
                          prefixIcon: Icon(
                            Icons.lock,
                            color: Colors.white70,
                            size: 22,
                          ),
                          suffixIconConstraints:
                              BoxConstraints(minWidth: 45, maxWidth: 46),
                          suffixIcon: GestureDetector(
                            onTap: () {
                              setState(() {
                                isConfirmPasswordVisible =
                                    !isConfirmPasswordVisible;
                              });
                            },
                            child: Icon(
                              isConfirmPasswordVisible
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                              color: Colors.white70,
                              size: 22,
                            ),
                          ),
                          border: InputBorder.none,
                          hintText: 'Confirm Password',
                          hintStyle:
                              TextStyle(color: Colors.white60, fontSize: 14.5),
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(100)
                                  .copyWith(bottomRight: Radius.circular(0)),
                              borderSide: BorderSide(color: Colors.white38)),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(100)
                                  .copyWith(bottomRight: Radius.circular(0)),
                              borderSide: BorderSide(color: Colors.white70))),
                      validator: (value) {
                        if (value!.trim() !=
                            passwordOneController.text.trim()) {
                          return 'The passwords do not match!';
                        }
                      },
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  GestureDetector(
                    onTap: () async {
                      FocusManager.instance.primaryFocus?.unfocus();
                      if (_formKey.currentState!.validate()) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text('Processing Data'),
                              duration: Duration(milliseconds: 300)),
                        );
                        //Client client = http.Client();
                        var response = await widget.client.post(
                            Uri.parse(myurls.AriaApiEndpoints.registrationUrl),
                            body: {
                              'username': emailController.text,
                              'email': emailController.text,
                              'password': passwordTwoController.text
                            });
                        //print('Response status: ${response.statusCode}');
                        //print('Response body: ${response.body}');

                        List<UserRegistrationResponse>
                            user_registration_response = [];
                        if (response.statusCode == 200) {
                          var responseJsons = json.decode(response.body);
                          //for (var responseJson in responseJsons) {
                          user_registration_response.add(
                              UserRegistrationResponse.fromJson(responseJsons));
                          //}
                          print(user_registration_response[0].errorMessage);
                          if (user_registration_response[0].errorMessage ==
                              "false") {
                            //setting values on shared preferences
                            await UserSimplePreferences.setUserEmail(
                                emailController.text);
                            await UserSimplePreferences.setUserRegistered(true);
                            print(user_registration_response[0].userPrimaryKey);
                            await UserSimplePreferences.setUserPk(
                                user_registration_response[0].userPrimaryKey);
                            //print('Registration was successful');
                            userEmail = emailController.text;
                            emailController.clear();
                            passwordOneController.clear();
                            passwordTwoController.clear();
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) {
                                  return registrationSuccessful(
                                    emailAddress: userEmail,
                                    client: widget.client,
                                  );
                                },
                              ),
                            );
                          } else {
                            //print('Registration was not successful');
                            setState(() {
                              signUpError =
                                  user_registration_response[0].errorMessage;
                            });
                          }
                        }
                      }
                    },
                    child: Container(
                      height: 53,
                      width: double.infinity,
                      margin: EdgeInsets.symmetric(horizontal: 30),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                                blurRadius: 4,
                                color: Colors.black12.withOpacity(.2),
                                offset: Offset(2, 2))
                          ],
                          borderRadius: BorderRadius.circular(100)
                              .copyWith(bottomRight: Radius.circular(0)),
                          gradient: LinearGradient(colors: [
                            Color.fromARGB(255, 10, 75, 92),
                            Color.fromARGB(255, 10, 75, 92)
                          ])),
                      child: Text('Register',
                          style: TextStyle(
                              color: Colors.white.withOpacity(1),
                              fontSize: 15,
                              fontWeight: FontWeight.bold)),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 10, bottom: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Already Have an Account?  ",
                          style: TextStyle(color: Colors.white),
                        ),
                        GestureDetector(
                          child: Text(
                            "Login Now",
                            style: TextStyle(
                                color: Color(0xFF48CAEE),
                                fontWeight: FontWeight.w500),
                          ),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) {
                                  return loginPage(
                                    client: widget.client,
                                  );
                                },
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget showAlert() {
    if (signUpError != "") {
      return Container(
        color: Colors.amberAccent,
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.all(8.0),
        child: Row(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: Icon(Icons.error_outline),
            ),
            Expanded(
              child: Text(
                signUpError,
                maxLines: 3,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: IconButton(
                icon: Icon(Icons.close),
                onPressed: () {
                  setState(() {
                    signUpError = "";
                  });
                },
              ),
            )
          ],
        ),
      );
    }
    return SizedBox(
      height: 0,
    );
  }
}
