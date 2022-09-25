import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:untitled/model/MyBookingPojo.dart';
import 'package:untitled/model/ProfilePojo.dart';
import 'package:untitled/model/ShopDetailPojo.dart';
import 'package:untitled/model/WishlistPojo.dart';
import 'package:untitled/screen/profile.dart';

import '../services/ApiCall.dart';
import '../utils/CommomDialog.dart';
import '../utils/appconstant.dart';
import 'home_controller.dart';

class BookingController extends GetxController {
  var bookingPojo = MyBookingPojo().obs;
  var wihlistlpojo = WishlistPojo().obs;
  final box = GetStorage();
  var lodaer = true;
  var shopId = "".obs;

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
  }

  @override
  void onReady() {
    //session_id
    super.onReady();
    //print("SDLKFJKLSDFJDSprofile");
    //print(box.read('session'));
    if (box.read('session') != null) {
      getBookingList();
    }
  }

  void getBookingList() async {
    Map map;
    map = {"session_id": box.read('session')};
    //map = {"session_id": "TXKe48DXicKoAjkyEOgXWqU3VuVZqdHm"};
    //print("API HIT HIT HIT HIT");
    try {
      CommonDialog.showLoading(title: "Please waitt...");
      final response =
          await APICall().registerUrse(map, AppConstant.ALL_BOOKINGS);
      // print(response);
      if (bookingPojo.value.message == "No Data found") {
        //   print(response);
        CommonDialog.hideLoading();
        CommonDialog.showsnackbar("No Data found");
      } else {
        CommonDialog.hideLoading();
        bookingPojo.value = myBookingPojoFromJson(response);
        lodaer = false;
        update();
      }
      lodaer = false;
      update();
    } catch (error) {
      //print(error);
      CommonDialog.hideLoading();
    }
  }

  void getBookingList1(context) async {
    Map map;
    map = {"session_id": box.read('session')};
    //map = {"session_id": "TXKe48DXicKoAjkyEOgXWqU3VuVZqdHm"};
    //print("API HIT HIT HIT HIT");
    try {
      //CommonDialog.showLoading(title: "Please waitt...");
      final response =
      await APICall().registerUrse(map, AppConstant.ALL_BOOKINGS);
      // print(response);
      //Navigator.pop(context);
      if (bookingPojo.value.message == "No Data found") {
        //   print(response);
        CommonDialog.showsnackbar("No Data found");
      } else {
        bookingPojo.value = myBookingPojoFromJson(response);
        lodaer = false;
        Get.find<HomeController>().getCoin1(box.read('session'));

        update();
      }
      lodaer = false;
      update();
    } catch (error) {
      //print(error);
     // CommonDialog.hideLoading();
    }
  }
}
