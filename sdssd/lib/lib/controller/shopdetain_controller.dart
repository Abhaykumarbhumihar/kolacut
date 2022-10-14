import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:untitled/model/AddRemoveFavouritePojo.dart';
import 'package:untitled/model/ProfilePojo.dart';
import 'package:untitled/model/ShopDetailPojo.dart';
import 'package:untitled/screen/profile.dart';

import '../model/AddBookingPojo.dart';
import '../services/ApiCall.dart';
import '../utils/CommomDialog.dart';
import '../utils/appconstant.dart';

class ShopDetailController extends GetxController {
  var shopDetailpojo = ShopDetailPojo().obs;
  final box = GetStorage();
  var lodaer = true;
  var shopId = "".obs;
  var addRemoveFavourtePojo = AddRemoveFavouritePojo().obs;
  var addBookingPojo=AddBookingPojo().obs;
  var isFavourite = 0;

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    print("init init init iit");
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
    print(box.read('session'));
    // getShopDetail("0EX03NjgPziSlCcTiZdxAi1c3aT1r1SA",shopId);
  }

  void getShopDetail( shop_id) async {
    Map map;
    map = {"session_id":box.read('session'),

      "shop_id": shop_id.toString()};
    print("API HIT HIT HIT HIT");
    try {
      lodaer = true;
      CommonDialog.showLoading(title: "Please waitt...");
      final response =
          await APICall().registerUrse(map, AppConstant.SHOP_DETAIL);
      print("response  response   response   response  ");
      print(response);
      if (shopDetailpojo.value.message == "No Data found") {
        print(response);
        CommonDialog.hideLoading();
        CommonDialog.showsnackbar("No Data found");
      } else {
        CommonDialog.hideLoading();
        shopDetailpojo.value = shopDetailPojoFromJson(response);
        print(shopDetailpojo.value.data!.ifFavourite.toString()+" lllllllllll");
        update();
        lodaer = false;
      }
    } catch (error) {
      print(error);
      print("ERROR  ERROR   ERROR   ERROR  ");
      CommonDialog.hideLoading();
    }
  }

  void addRemoveFavourite( shop_id) async {
    //addRemoveFavourtePojo
    Map map;
    map = {"session_id": box.read('session'), "shop_id": shop_id.toString()};
   // map = {"session_id":"TXKe48DXicKoAjkyEOgXWqU3VuVZqdHm", "shop_id": shop_id.toString()};

    try {
      //lodaer = true;
      CommonDialog.showLoading(title: "Please waitt...");
      final response =
          await APICall().registerUrse(map, AppConstant.ADD_REMOVE_FAVOURITE);
      print("response  response   response   response  ");
      //print(response);
      addRemoveFavourtePojo.value=addRemoveFavouritePojoFromJson(response);
      if (addRemoveFavourtePojo.value.message ==
          "Item removed from favorite.") {
        isFavourite = 0;
        print(isFavourite);
        print(response);
        CommonDialog.hideLoading();
        //CommonDialog.showsnackbar("No Data found");
        update();
      } else if (addRemoveFavourtePojo.value.message.toString()==
          "Item added to favorite.") {
        isFavourite = 1;
        print(isFavourite);
        print(response);
        CommonDialog.hideLoading();
      //  CommonDialog.showsnackbar("No Data found");
        update();
      } else {
        CommonDialog.hideLoading();
        // addRemoveFavourtePojo.value = addRemoveFavouritePojoFromJson(response);
        update();
        // lodaer = false;
      }
    } catch (error) {
      print(error);
      print("ERROR  ERROR   ERROR   ERROR  ");
      CommonDialog.hideLoading();
    }
  }


  void bookserVice( shop_idd,employee_id,service_id,sub_service_id,date,
      from_time,booking_day,to_time,amount
       ) async {
    Map map;

    map = {"session_id":box.read('session'),
     "shop_id":shop_idd.toString()+"",
     "employee_id":employee_id.toString()+"",
     "service_id":service_id.toString()+"",
     "sub_service_id":sub_service_id.toString()+"",
     "date":date.toString()+"",
     "from_time":from_time+"",
     "booking_day":booking_day.toString()+"",
     "to_time":from_time+"",
     "amount":"200"};
    print("API HIT HIT HIT HIT");
    try {
      lodaer = true;
      CommonDialog.showLoading(title: "Please waitt...");
      final response =
      await APICall().registerUrse(map, AppConstant.BOOK_SERVICE);
      print("response  response   response   response  ");
      print(response);
      update();
      CommonDialog.hideLoading();
      lodaer = false;
      if(response!="null"){
        addBookingPojo.value=addBookingPojoFromJson(response);
        CommonDialog.showsnackbar(addBookingPojo.value.message);

      }else{
        CommonDialog.showsnackbar("Error");
      }
      // if (shopDetailpojo.value.message == "No Data found") {
      //   print(response);
      //   CommonDialog.hideLoading();
      //   CommonDialog.showsnackbar("No Data found");
      // } else {
      //   CommonDialog.hideLoading();
      // //  shopDetailpojo.value = shopDetailPojoFromJson(response);
      //
      // }
    } catch (error) {
      print(error);
      print("ERROR  ERROR   ERROR   ERROR  ");
      CommonDialog.hideLoading();
    }
  }
}