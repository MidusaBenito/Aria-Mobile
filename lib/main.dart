import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'splash_page.dart';
import 'utils.dart';
import 'login_page.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Stripe.publishableKey =
      "pk_live_51KhALyCldFfAXs7mYAyFcVHpAAx1vx5SA9UNazLXUR4CXgxzKWtfXsxsnGPqqN4TsswTQz4Y7Byjt7Eftlaicwat00Pt21ygLq";
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  await UserSimplePreferences.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: myAnimatedScreen(),
    );
  }
}
