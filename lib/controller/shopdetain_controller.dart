import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:untitled/model/AddRemoveFavouritePojo.dart';
import 'package:untitled/model/ProfilePojo.dart';
import 'package:untitled/model/ShopDetailPojo.dart';
import 'package:untitled/screen/profile.dart';
import 'dart:convert';

import '../model/AddBookingPojo.dart';
import '../screen/homepage.dart';
import '../screen/yourbooking.dart';
import '../services/ApiCall.dart';
import '../utils/CommomDialog.dart';
import '../utils/appconstant.dart';
import 'BookingController.dart';
import 'home_controller.dart';

class ShopDetailController extends GetxController {
  var shopDetailpojo = ShopDetailPojo().obs;
  final box = GetStorage();
  var lodaer = true;
  var shopId = "".obs;
  var addRemoveFavourtePojo = AddRemoveFavouritePojo().obs;
  var addBookingPojo = AddBookingPojo().obs;
  var isFavourite = 0.obs;
  var bookingMessage = "";
  BookingController bookingController = Get.put(BookingController());
  HomeController homeController = Get.put(HomeController());

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    print("init init init iit");
  }
   favourite(data){
    if(data==1){
      isFavourite.value=1;

      update();
    }else{
      isFavourite.value=0;

      update();
    }
   }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  void onReady() {
    //session_id
    super.onReady();
    print("SDLKFJKLSDFJDSprofile");
   // print(box.read('session'));
    // getShopDetail("0EX03NjgPziSlCcTiZdxAi1c3aT1r1SA",shopId);
  }

  String sendData() {
    // print(message);
    return bookingMessage;
  }

  void getShopDetail(shop_id) async {
    Map map;

    if(box.read('session')!=null&&box.read('session')!=""){
      map = {"shop_id": shop_id.toString(),
        "session_id": box.read('session')};
    }else{
      map = {"shop_id": shop_id.toString()};
    }

    print("API HIT HIT HIT HIT");
    try {
      lodaer = true;
      CommonDialog.showLoading(title: "Please waitt...");
      final response =
          await APICall().registerUrse(map, AppConstant.SHOP_DETAIL);
     // print("response  response   response   response  ");
      //print(response);
      shopDetailpojo.value.data=null;
      update();
      if (shopDetailpojo.value.message == "No Data found") {
        //print(response);
        CommonDialog.hideLoading();
        CommonDialog.showsnackbar("No Data found");
      } else {
        CommonDialog.hideLoading();
        shopDetailpojo.value = shopDetailPojoFromJson(response);
        favourite(shopDetailpojo.value.data.isFavorite);
        print(shopDetailpojo.value.data.isFavorite.toString()+" ABHAY ABHAY ABHAY");
        lodaer = false;
        update();

      }
    } catch (error) {
      print(error);
      print("ERROR  ERROR   ERROR   ERROR  ");
      CommonDialog.hideLoading();
    }
  }

  void addRemoveFavourite(shop_id) async {
    //addRemoveFavourtePojo
    Map map;
    map = {"session_id": box.read('session'), "shop_id": shop_id.toString()};
    // map = {"session_id":"TXKe48DXicKoAjkyEOgXWqU3VuVZqdHm", "shop_id": shop_id.toString()};
    favourite(0);
    try {
      //lodaer = true;
     // CommonDialog.showLoading(title: "Please waitt...");
      final response =
          await APICall().registerUrse(map, AppConstant.ADD_REMOVE_FAVOURITE);
      print("response  response   response   response  ");
      //print(response);
      addRemoveFavourtePojo.value = addRemoveFavouritePojoFromJson(response);
    //  CommonDialog.hideLoading();
      if (addRemoveFavourtePojo.value.message ==
          "Item removed from favorite.") {
        favourite(0);
        print(isFavourite);
        print(response);
       // CommonDialog.hideLoading();
        //CommonDialog.showsnackbar("No Data found");
        update();
      } else if (addRemoveFavourtePojo.value.message.toString() ==
          "Item added to favorite.") {
        favourite(1);
        print(isFavourite);
        print(response);
       // CommonDialog.hideLoading();
        //  CommonDialog.showsnackbar("No Data found");
        update();
      } else {
       // CommonDialog.hideLoading();

        // addRemoveFavourtePojo.value = addRemoveFavouritePojoFromJson(response);
        update();
        // lodaer = false;
      }
     // getShopDetail(shopId.value);
      update();
    } catch (error) {
      print(error);
      print("ERROR  ERROR   ERROR   ERROR  ");
     // CommonDialog.hideLoading();
    }
  }

  void addTocart(
      BuildContext context, shop_id, sub_service_id, employee_id) async {
    Map map;
    //session_id:a9z55MMZSJKtxESDbbGlAgIOVRdxY9Pa
    // shop_id:1
    // sub_service_id:1,2
    map = {
      "session_id": box.read('session'),
      "shop_id": shop_id.toString() + "",
      "sub_service_id": sub_service_id.toString() + "",
      "employee_id": "1"
    };
    lodaer = true;
    CommonDialog.showLoading(title: "Please waitt...");
    final response = await APICall().registerUrse(map, AppConstant.ADD_TO_CART);
    final body = json.decode(response);
    print("SDF SDF SDF SDF SDF SDF ");
    print(response);
    print("SDF SDF SDF SDF SDF SDF ");
    update();
    CommonDialog.hideLoading();
    if (body['message'] == "Data added successfully") {
      CommonDialog.showsnackbar(body['message']);
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => HomePage()),
          (route) => false);
     // bookingController.get(context);
      Get.find<HomeController>().getCartList(box.read('session'));
    } else {
      CommonDialog.showsnackbar(body['message']);
    }
  }

  void bookserVice(
      context,
      shop_idd,
      employee_id,
      service_id,
      sub_service_id,
      date,
      from_time,
      booking_day,
      to_time,
      amount,
      payment_type,
      transaction_id,
      coin,
      coupon_code,
      coupon_type,
      total_priecwithutdedcution) async {
    Map map;
    print("SDFSDFDSFDSFD");
    print(coin);

    map = {
      "session_id": box.read('session'),
      "shop_id": shop_idd.toString() + "",
      "employee_id": employee_id.toString() + "",
      "service_id": service_id.toString() + "",
      "coupon_type":coupon_type+"",
      "total_price":total_priecwithutdedcution,
      "sub_service_id": sub_service_id.toString() + "",
      "date": date.toString() + "",
      "from_time": from_time + "",
      "booking_day": booking_day.toString() + "",
      "to_time": to_time + "",
      "amount": amount,
      "payment_type": "$payment_type",
      "coin": "${coin == 0.0 ? 0.0 : coin}",
      "coupon_code": "$coupon_code",
      "transaction_id": "$transaction_id"
    };
    print("API HIT HIT HIT HIT");
    try {
      bookingMessage = "";
      lodaer = true;
      CommonDialog.showLoading(title: "Please waitt...");
      final response =
          await APICall().registerUrse(map, AppConstant.BOOK_SERVICE);
      print("response  response   response   response  ");
      print(response);
      update();
      CommonDialog.hideLoading();
      lodaer = false;
      if (response != "null") {
        addBookingPojo.value = addBookingPojoFromJson(response);
        bookingMessage = addBookingPojo.value.message;
        update();
        CommonDialog.showsnackbar(addBookingPojo.value.message);

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => TableBasicsExample()),
        );
        bookingController.getBookingList1(context);



      } else {
        CommonDialog.showsnackbar("Error");
      }

    } catch (error) {
      print(error);
      print("ERROR  ERROR   ERROR   ERROR  ");
      CommonDialog.hideLoading();
    }
  }

  void bookserVicecart(
      cartid,
      context,
      shop_idd,
      employee_id,
      service_id,
      sub_service_id,
      date,
      from_time,
      booking_day,
      to_time,
      amount,
      payment_type,
      transaction_id,
      coin,
      coupon_code,
      coupon_type,
      total_priecwithutdedcution
      ) async {
    Map map;
    print("SDFSDFDSFDSFD");
    print(coin);

    map = {
      "cart_id":cartid+"",
      "session_id": box.read('session'),
      "shop_id": shop_idd.toString() + "",
      "employee_id": employee_id.toString() + "",
      "service_id": service_id.toString() + "",
      "sub_service_id": sub_service_id.toString() + "",
      "date": date.toString() + "",
      "from_time": from_time + "",
      "booking_day": booking_day.toString() + "",
      "coupon_type":coupon_type+"",
      "total_price":total_priecwithutdedcution,
      "to_time": to_time + "",
      "amount": amount,
      "payment_type": "$payment_type",
      "coin": "${coin == 0.0 ? 0.0 : coin}",
      "coupon_code": "$coupon_code",
      "transaction_id": "$transaction_id"
    };
    print("API HIT HIT HIT HIT");
    try {
      bookingMessage = "";
      lodaer = true;
      CommonDialog.showLoading(title: "Please waitt...");
      final response =
      await APICall().registerUrse(map, AppConstant.BOOK_SERVICE);
      print("response  response   response   response  ");
      print(response);
      update();
      CommonDialog.hideLoading();
      lodaer = false;
      if (response != "null") {
        addBookingPojo.value = addBookingPojoFromJson(response);
        bookingMessage = addBookingPojo.value.message;
        update();
        CommonDialog.showsnackbar(addBookingPojo.value.message);

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => TableBasicsExample()),
        );
        bookingController.getBookingList1(context);
        homeController.getCartList(box.read('session'));

      } else {
        CommonDialog.showsnackbar("Error");
      }

    } catch (error) {
      print(error);
      print("ERROR  ERROR   ERROR   ERROR  ");
      CommonDialog.hideLoading();
    }
  }

}
