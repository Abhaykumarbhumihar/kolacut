import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:untitled/model/ProfilePojo.dart';
import 'package:untitled/screen/profile.dart';

import '../model/MyBookingPojo.dart';
import '../services/ApiCall.dart';
import '../utils/CommomDialog.dart';
import '../utils/appconstant.dart';
import 'home_controller.dart';

class ProfileController extends GetxController {
  var bookingPojo = MyBookingPojo().obs;

  var profilePojo = ProfilePojo().obs;
  final box = GetStorage();
  var lodaer = true;
  var message = "";
  var phoneno = "";

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
    print(box.read('session'));
    if (box.read('session') != null) {
      getProfile(box.read('session'));
      getBookingList();
    }

    //getProfile("TXKe48DXicKoAjkyEOgXWqU3VuVZqdHm");
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
  void getProfile(session_id) async {
    Map map;
    map = {"session_id": session_id};
    phoneno = session_id;
    try {
      CommonDialog.showLoading(title: "Please waitt...");
      final response =
          await APICall().registerUrse(map, AppConstant.GET_PROFILE);

      //print(response);

      if (profilePojo.value.message == "No Data found") {
        CommonDialog.hideLoading();
        CommonDialog.showsnackbar("No Data found");
      } else {
        CommonDialog.hideLoading();
        profilePojo.value = profilePojoFromJson(response);
        update();
        lodaer = false;
      }
    } catch (error) {
      CommonDialog.hideLoading();
    }
  }

  void getProfileupdate(session_id) async {
    Map map;
    map = {"session_id": session_id};
    phoneno = session_id;
    try {
      // CommonDialog.showLoading(title: "Please waitt...");
      final response =
          await APICall().registerUrse(map, AppConstant.GET_PROFILE);
      //CommonDialog.hideLoading();
     // print(response);

      if (profilePojo.value.message == "No Data found") {
        CommonDialog.showsnackbar("No Data found");
      } else {
        profilePojo.value = profilePojoFromJson(response);

        update();
        lodaer = false;
      }
    } catch (error) {
      if (kDebugMode) {
        print(error);
      }
      CommonDialog.hideLoading();
    }
  }

  void updateProfile(
      image, name, email, dob, gender, phone, device_type, device_token) async {
    CommonDialog.showLoading(title: "Please waitt...");
    final response = await APICall().registerUpdateProfileMulti(
        box.read('session') + "",
        image,
        name,
        email,
        dob,
        gender,
        phone,
        device_type,
        device_token);

    CommonDialog.hideLoading();
    Get.back();
    if (response != "null") {
      // CommonDialog.showsnackbar(response);
      print("kkjhjjhjkjkkjkj");
     // print(response);
      lodaer = false;
      getProfileupdate(box.read('session'));
      // getProfileupdate("TXKe48DXicKoAjkyEOgXWqU3VuVZqdHm");
      update();
    } else {
      CommonDialog.showsnackbar("Something error,Please try again...");
    }
  }
}
