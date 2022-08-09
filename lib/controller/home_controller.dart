import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:untitled/model/ProfilePojo.dart';
import 'package:untitled/model/ShopDetailPojo.dart';
import 'package:untitled/model/ShopLIstPojo.dart';
import 'package:untitled/screen/profile.dart';

import '../model/AdminServicePojo.dart';
import '../services/ApiCall.dart';
import '../utils/CommomDialog.dart';
import '../utils/appconstant.dart';

class HomeController extends GetxController {
  var shopListPojo = ShopLIstPojo().obs;
  var serviceList = AdminServicePojo().obs;
  final box = GetStorage();
  var lodaer = true;
  var sessiooo="".obs;
  late SharedPreferences sharedPreferences;
  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();

  }

  @override
  void onReady() {
    //session_id
    super.onReady();
    print("SDLKFJKLSDFJDSprofile");

    SharedPreferences.getInstance().then((SharedPreferences sp) {
      sharedPreferences = sp;
      var  _testValue = sharedPreferences.getString("session");
      print(sharedPreferences.getString("session"));
      getShopList(_testValue);
      getServiceList(_testValue);

    });





   //  getShopList("TXKe48DXicKoAjkyEOgXWqU3VuVZqdHm");
   //  getServiceList("TXKe48DXicKoAjkyEOgXWqU3VuVZqdHm");
  }

  void getServiceList(session_id) async {
    Map map;
    map = {"session_id": "$session_id"};
    try {
     // CommonDialog.showLoading(title: "Please waitt...");
      lodaer=true;
      final response =
          await APICall().registerUrse(map, AppConstant.SERVICE_LIST);
      print(response);
      print("kjkjkljljlkjlkljkljkljhjgyuyyghgh");
      if (serviceList.value.message == "No Data found") {
     //   CommonDialog.hideLoading();
      //  CommonDialog.showsnackbar("No Data found");
      } else {
      //  CommonDialog.hideLoading();
        serviceList.value = adminServicePojoFromJson(response);

        update();
      //  lodaer = false;
      }
    } catch (error) {
      //CommonDialog.hideLoading();
    }
  }

  void getShopList(session_id) async {
    Map map;
    map = {"session_id": session_id};
    try {
     // CommonDialog.showLoading(title: "Please waitt...");
      lodaer=true;
      final response = await APICall().registerUrse(map, AppConstant.SHOP_LIST);
      Get.back();
      //print(response);
      if (shopListPojo.value.message == "No Data found") {
        CommonDialog.hideLoading();
        CommonDialog.showsnackbar("No Data found");
      } else {
       // Get.back();
        shopListPojo.value = shopLIstPojoFromJson(response);
        lodaer = false;
        update();

      }
    } catch (error) {
      lodaer = false;
      CommonDialog.hideLoading();
    }
  }
}
