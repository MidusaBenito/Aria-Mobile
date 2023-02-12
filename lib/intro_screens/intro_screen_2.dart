import 'package:flutter/material.dart';
import '/colors.dart' as mycolor;

class introScreenTwo extends StatelessWidget {
  const introScreenTwo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: mycolor.AppColor.splashPageBackground2,
      //height: MediaQuery.of(context).size.height,
      //width: MediaQuery.of(context).size.width,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          children: [
            Expanded(child: Container()),
            Center(
              child: Opacity(
                opacity: 1,
                child: Image.asset(
                  "assets/images/payments.gif",
                  height: 300,
                  width: 300,
                ),
              ),
            ),
            Row(
              children: [
                Text(
                  "View All Your Bills on Your Phone",
                  style: TextStyle(
                    fontSize: 16,
                    color: Color.fromARGB(255, 17, 6, 6),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Text(
                  "And Make Payments on Time. Pay from Your Bank, Card \n\ and E-wallets. You Can Also Pay from Aria Wallet.",
                  style: TextStyle(
                    fontSize: 13,
                    color: Color.fromARGB(255, 17, 6, 6),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            Expanded(child: Container()),
          ],
        ),
      ),
    );
  }
}
