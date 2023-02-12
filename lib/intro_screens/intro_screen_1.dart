import 'package:flutter/material.dart';
import '/colors.dart' as mycolor;

class introScreenOne extends StatelessWidget {
  const introScreenOne({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: mycolor.AppColor.splashPageBackground,
      //height: MediaQuery.of(context).size.height,
      //width: MediaQuery.of(context).size.width,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          children: [
            Expanded(child: Container()),
            Row(
              children: [
                Text(
                  "Access, Pay & Store",
                  style: TextStyle(
                    fontSize: 25,
                    color: Colors.white,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),
            Row(
              children: [
                Text(
                  "Your Bills Online",
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 40,
            ),
            Center(
              child: Opacity(
                opacity: .8,
                child: Image.asset(
                  "assets/images/hero.png",
                  height: 350,
                  width: 350,
                ),
              ),
            ),
            Expanded(child: Container()),
          ],
        ),
      ),
    );
  }
}
