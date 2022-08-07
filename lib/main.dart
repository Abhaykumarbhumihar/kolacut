import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:untitled/model/ProfilePojo.dart';
import 'package:untitled/screen/HomeScreen.dart';
import 'package:untitled/screen/coin.dart';
import 'package:untitled/screen/homebottombar.dart';
import 'package:untitled/screen/homepage.dart';
import 'package:untitled/screen/login.dart';
import 'package:untitled/screen/orderdetail.dart';
import 'package:untitled/screen/profile.dart';
import 'package:untitled/screen/register.dart';
import 'package:untitled/screen/saloondetail.dart';
import 'package:untitled/screen/userprofile.dart';
import 'package:untitled/screen/verifyOtp.dart';
import 'package:untitled/screen/wishlish.dart';
import 'package:untitled/screen/yourbooking.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  final String? session = prefs.getString('session');
  runApp(MyApp(session: session));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key, this.session}) : super(key: key);
  final String? session;


  @override

  Widget build(BuildContext context) {
    print(session);
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      home: session == null ? const LoginPage() : const MainPage(),
    );
  }
}
// void main() {
//   runApp(MyApp());
// }
//
// class MyApp extends StatelessWidget {
//   var box = GetStorage();
//
//
//
//   @override
//   Widget build(BuildContext context) {
//     // late var a;
//     // if (box.read('session') == null) {
//     //   print(box.read("session"));
//     //   a = LoginPage();
//     // } else {
//     //   print(box.read("session"));
//     //   a = MainPage();
//     // }
//     //
//     // return GetMaterialApp(debugShowCheckedModeBanner: false, home: LoginPage());
//     var box = GetStorage();
//     String? session;
//     Future.delayed(const Duration(seconds: 5), () {
//       session = http://box.read('session');
//     });
//
//     return GetMaterialApp(
//       debugShowCheckedModeBanner: false,
//       home: session == null ? const LoginPage() : const MainPage(),
//     );
//   }
// }
