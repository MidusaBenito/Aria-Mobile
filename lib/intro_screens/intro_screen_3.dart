import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:http/http.dart' as http;
import '/colors.dart' as mycolor;

class introScreenThree extends StatelessWidget {
  const introScreenThree({Key? key}) : super(key: key);
  //final Client client;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: mycolor.AppColor.splashPageBackground3,
      //height: MediaQuery.of(context).size.height,
      //width: MediaQuery.of(context).size.width,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          children: [
            Expanded(
              child: Container(),
            ),
            Center(
              child: Image.asset(
                "assets/images/due_date.png",
                height: 250,
                width: 250,
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Center(
              child: Text(
                "No missed or Late Payments",
                style: TextStyle(
                  fontSize: 18,
                  color: Color.fromARGB(255, 17, 6, 6),
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Center(
              child: Text(
                "Get Timely Reminders on When a \n\ Bill is Due for a Spotless Credit \n\ Score",
                style: TextStyle(
                  fontSize: 15,
                  color: Color.fromARGB(255, 17, 6, 6),
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
            Expanded(
              child: Container(),
            ),
          ],
        ),
      ),
    );
  }
}
