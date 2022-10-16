import 'dart:convert';
import 'dart:io';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:untitled/model/SlotPojo.dart';
import 'package:untitled/screen/coin.dart';
import 'package:untitled/screen/orderdetail.dart';
import 'package:untitled/screen/profile_update.dart';
import 'package:untitled/utils/CommomDialog.dart';
import 'package:untitled/utils/Utils.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:intl/intl.dart';
import 'package:date_picker_timeline/date_picker_timeline.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;
import '../controller/shopdetain_controller.dart';
import '../model/ShopDetailPojo.dart';
import '../utils/appconstant.dart';

class SaloonDetail extends StatefulWidget {
  var id = 0;

  SaloonDetail(int i, {Key? key}) : super(key: key) {
    this.id = i;
  }

  @override
  State<SaloonDetail> createState() => _SaloonDetailState(id);
}

class _SaloonDetailState extends State<SaloonDetail> {
  var shopid = 0;

  _SaloonDetailState(int id) {
    this.shopid = id;
  }

  int isSlotSelected = 1;
  var slotSelected = "";
  var timeSelected = "";
  var selectEmployeeId = "";
  var selectDate = "";
  var selectDay = "";
  int isSelected =
      -1; // changed bool to int and set value to -1 on first time if you don't select anything otherwise set 0 to set first one as selected.

  _isSelected(int index) {
    //pass the selected index to here and set to 'isSelected'
    setState(() {
      isSelected = index;
    });
  }

  _isSelectedSlot(int index) {
    //pass the selected index to here and set to 'isSelected'
    setState(() {
      print("CHUSDFSD");
      isSlotSelected = index;
    });
  }

  ShopDetailController salonControlller = Get.put(ShopDetailController());
  bool valuefirst = false;
  var time = 0;

  String durationToString(int minutes) {
    var d = Duration(minutes: minutes);
    List<String> parts = d.toString().split(':');
    return '${parts[0].padLeft(2, '0')}:${parts[1].padLeft(2, '0')}';
  }

  final List<DateTime> days = [];
  List<SamleClass> data = [];
  List<SlotPojo> slotPojo = [];
  List<String> userChecked = [];
  List<ServiceService> tempArray = [];
  var slotpojo = SlotPojo();
  var session = "";
  late SharedPreferences sharedPreferences;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getSlot("24");
    tempArray.clear();
    //a
    selectEmployeeId = "";
    selectDate = "";
    selectDay = "";
    timeSelected = "";
    final today = DateTime.now();
    final monthAgo = DateTime(today.year, today.month - 1, today.day);
    for (int i = 0; i <= today.difference(monthAgo).inDays; i++) {
      days.add(monthAgo.add(Duration(days: i)));
    }
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      salonControlller.getShopDetail(shopid.toString());
    });
  }

  void getSlot(slottime) async {
    slotSelected = "";
    isSlotSelected = 1;
    Map map = {
      "service_time": slottime,
    };

    print(map);
    var apiUrl = Uri.parse(AppConstant.BASE_URL + AppConstant.SLOT_TIME);
    print(apiUrl);
    print(map);
    final response = await http.post(
      apiUrl,
      body: map,
    );
    print(response);
    setState(() {
      slotpojo = slotPojoFromJson(response.body);
    });
    print(response.body);
  }

  @override
  Widget build(BuildContext context) {
    print(shopid);
    SharedPreferences.getInstance().then((SharedPreferences sp) {
      sharedPreferences = sp;

      var _sessss = sharedPreferences.getString("session");
      setState(() {
        if (_sessss != null) {
          session = _sessss;
        }
      });
    });
    salonControlller.shopId.value = shopid.toString();
    // for(int i=0;i<=days.length;i++){
    //  // debugPrint(days[i].day.toString()+"  "+days[i].month.toString()+" "+days[i].year.toString());
    //   debugPrint(DateFormat.E().format(days[i]));
    // }

    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    // WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
    //   salonControlller.getShopDetail("0EX03NjgPziSlCcTiZdxAi1c3aT1r1SA",shopid.toString());
    //
    // });
    return SafeArea(
      child: Scaffold(
          body: GetBuilder<ShopDetailController>(builder: (salonControlller) {
        if (salonControlller.lodaer) {
          return Container();
        } else {
          var a = salonControlller.shopDetailpojo.value.data;
          salonControlller.isFavourite = a!.isFavorite!;
          // print("${a.isFavorite.toString()}" + "sdfsdfsdfsd");
          return Container(
            width: width,
            height: height,
            color: Colors.white,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    width: width,
                    height: height * 0.5,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(4)),
                        image: DecorationImage(
                            image: NetworkImage(
                              a.logo.toString(),
                            ),
                            fit: BoxFit.cover)),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            GestureDetector(
                              onTap: () {
                                Navigator.pop(context);
                              },
                              child: Container(
                                margin: EdgeInsets.all(width * 0.05),
                                width: width * 0.1,
                                height: height * 0.1,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  image: const DecorationImage(
                                    image: AssetImage(
                                        'images/svgicons/whitecircle.png'),
                                  ),
                                ),
                                child: Icon(
                                  CupertinoIcons.arrow_left,
                                  color: Colors.black,
                                  size: 24,
                                ),
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                GestureDetector(
                                  onTap: () {
                                    if (session == null || session == "") {
                                      CommonDialog.showsnackbar(
                                          "Please login for use all features");
                                    } else {
                                      salonControlller
                                          .addRemoveFavourite(shopid);
                                    }

                                    //   print( salonControlller.isFavourite);
                                  },
                                  child: Container(
                                    margin: EdgeInsets.all(width * 0.05),
                                    width: width * 0.1,
                                    height: height * 0.1,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(12),
                                      image: const DecorationImage(
                                        image: AssetImage(
                                            'images/svgicons/whitecircle.png'),
                                      ),
                                    ),
                                    child: Center(
                                      child: Icon(
                                        salonControlller.isFavourite == 1
                                            ? CupertinoIcons.heart_fill
                                            : CupertinoIcons.heart,
                                        color: salonControlller.isFavourite == 1
                                            ? Colors.red
                                            : Colors.black,
                                        size: 24,
                                      ),
                                    ),
                                  ),
                                ),
                                InkWell(
                                  onTap: () async {
                                    Share.share(
                                        'check out my website https://example.com',
                                        subject: 'Look what I made!');
                                  },
                                  child: Container(
                                    margin: EdgeInsets.all(width * 0.05),
                                    width: width * 0.1,
                                    height: height * 0.1,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(12),
                                      image: const DecorationImage(
                                        image: AssetImage(
                                            'images/svgicons/whitecircle.png'),
                                      ),
                                    ),
                                    child: Icon(
                                      CupertinoIcons
                                          .arrowshape_turn_up_right_fill,
                                      color: Colors.black,
                                      size: 24,
                                    ),
                                  ),
                                )
                              ],
                            )
                          ],
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            const SizedBox(width: 12.0),
                            GestureDetector(
                              onTap: () {
                                //	30°44.177' N	76°47.304' E
                                openMap(context, 123456.0, 12345678.0);
                              },
                              child: Container(
                                margin: const EdgeInsets.only(
                                    bottom: 6, left: 6, right: 6),
                                width: width * 0.3,
                                height: height * 0.04,
                                decoration: const BoxDecoration(
                                    color: Colors.white,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(8))),
                                child: Center(
                                  child: Text(
                                    'View on map',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: Color(
                                          Utils.hexStringToHexInt('5E5E5E'),
                                        ),
                                        fontFamily: 'Poppins Regular',
                                        fontSize: width * 0.03),
                                  ),
                                ),
                              ),
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                  //name,address,ownerimage,ownername
                  profiledes(
                      context,
                      width,
                      height,
                      a.name.toString(),
                      a.address.toString(),
                      a.ownerProfileImage.toString(),
                      a.ownerName.toString(),
                      a.services,
                      a.rating),
                  Divider(
                    thickness: 1,
                    color: Color(Utils.hexStringToHexInt('E5E5E5')),
                  ),
                  SizedBox(
                    height: 3,
                  ),
                  description(context, width, height, a.description.toString(),
                      a.amenties.toString(), a.timeSlot),
                  Divider(
                    thickness: 1,
                    color: Color(Utils.hexStringToHexInt('E5E5E5')),
                  ),
                  SizedBox(
                    height: height * 0.02,
                  ),
/*Todo-----best offer view*/
                  Container(
                      margin: EdgeInsets.only(left: 4.0),
                      child: bestoffer(context, a)),

                  SizedBox(
                    width: width,
                    height: height * 0.1 + height * 0.03,
                    child: ListView.builder(
                        itemCount: a.coupon!.length,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, position) {
                          return Container(
                            width: width * 0.4 + width * 0.02,
                            height: height * 0.2,
                            margin: EdgeInsets.all(8),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(6)),
                                border: Border.all(
                                    color: Colors.grey.shade100, width: 1)),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: <Widget>[
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(
                                      ' ${a.coupon![position].couponName}',
                                      style: TextStyle(
                                          fontFamily: 'Poppins Regular',
                                          fontSize: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.02,
                                          color: Colors.black),
                                    ),
                                    //50% off upto 50 Rupees
                                    Text(
                                      '   ${a.coupon![position].percentage}% off upto ${a.coupon![position].price} Rupees',
                                      style: TextStyle(
                                          fontFamily: 'Poppins Light',
                                          fontSize: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.03,
                                          color: Color(Utils.hexStringToHexInt(
                                              'A4A4A4'))),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Row(
                                  children: <Widget>[
                                    Text(
                                      '  Use Code ',
                                      style: TextStyle(
                                          fontFamily: 'Poppins Light',
                                          fontSize: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.03,
                                          color: Color(Utils.hexStringToHexInt(
                                              'A4A4A4'))),
                                    ),
                                    Container(
                                      padding: EdgeInsets.symmetric(
                                          vertical: 2.0, horizontal: 10.0),
                                      color: Color(
                                          Utils.hexStringToHexInt('#46D0D9')),
                                      child: Text(
                                        '${a.coupon![position].couponCode}',
                                        style: TextStyle(
                                          fontFamily: 'Poppins Light',
                                          fontSize: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.03,
                                          color: Colors.white,
                                        ),
                                      ),
                                    )
                                  ],
                                )
                              ],
                            ),
                          );
                        }),
                  ),

                  Divider(
                    thickness: 1,
                    color: Color(Utils.hexStringToHexInt('E5E5E5')),
                  ),
                  const SizedBox(
                    height: 4,
                  ),
                  Container(
                      margin: EdgeInsets.only(left: 6.0),
                      child: seeall(context)),

                  // Container(
                  //   margin: EdgeInsets.only(left: 10, right: 6),
                  //   child: GridView.count(
                  //     crossAxisCount: 3,
                  //     crossAxisSpacing: 10.0,
                  //     mainAxisSpacing: 10.0,
                  //     shrinkWrap: true,
                  //     physics: new NeverScrollableScrollPhysics(),
                  //    // mainAxisSpacing: 10.0,
                  //     children: List.generate(
                  //      // a.services!.length,
                  //       8,
                  //       (index) {
                  //         return Center(
                  //           child: GestureDetector(
                  //             onTap: () {
                  //               showDialog(
                  //                 barrierDismissible: false,
                  //                 context: context,
                  //                 builder: (BuildContext context) {
                  //                   return WillPopScope(
                  //                     onWillPop: () async {
                  //                       return false;
                  //                     },
                  //                     child: AlertDialog(
                  //                       insetPadding: EdgeInsets.symmetric(
                  //                         horizontal: 50.0,
                  //                         vertical: 100.0,
                  //                       ),
                  //                       title: Row(
                  //                         mainAxisAlignment:
                  //                             MainAxisAlignment.spaceBetween,
                  //                         children: <Widget>[
                  //                           Text(
                  //                             "Select your services ",
                  //                             style: TextStyle(
                  //                                 fontSize: width * 0.03),
                  //                           ),
                  //                           IconButton(
                  //                             onPressed: () {
                  //                               var time = 0;
                  //                               tempArray.forEach((element) {
                  //                                 time +=
                  //                                     int.parse(element.time!);
                  //                               });
                  //                               print(time);
                  //                               Navigator.pop(context);
                  //                               getSlot(time.toString() + "");
                  //                             },
                  //                             icon: Icon(Icons.cancel_outlined),
                  //                           ),
                  //                         ],
                  //                       ),
                  //                       content: StatefulBuilder(
                  //                         // You need this, notice the parameters below:
                  //                         builder: (BuildContext context,
                  //                             StateSetter setState) {
                  //                           return Container(
                  //                             width: width,
                  //                             height: 200,
                  //                             child: Column(
                  //                               mainAxisAlignment:
                  //                                   MainAxisAlignment.start,
                  //                               children: [
                  //                                 Flexible(
                  //                                   child: ListView.builder(
                  //                                       shrinkWrap: true,
                  //                                       itemCount: a
                  //                                           .services![index]
                  //                                           .service!
                  //                                           .length,
                  //                                       itemBuilder: (context,
                  //                                           position) {
                  //                                         return InkWell(
                  //                                           onTap: () {
                  //                                             setState(() {
                  //                                               if (tempArray.contains(a
                  //                                                       .services![
                  //                                                           index]
                  //                                                       .service![
                  //                                                   position])) {
                  //                                                 print(
                  //                                                     "SDF SDF SDF DSF ");
                  //                                                 tempArray.remove(a
                  //                                                     .services![
                  //                                                         index]
                  //                                                     .service![position]);
                  //                                               } else {
                  //                                                 print(
                  //                                                     "sdfsdfsdfsdfsdfsd ");
                  //                                                 tempArray.add(a
                  //                                                     .services![
                  //                                                         index]
                  //                                                     .service![position]);
                  //                                               }
                  //
                  //                                               for (var i = 0;
                  //                                                   i <
                  //                                                       tempArray
                  //                                                           .length;
                  //                                                   i++) {
                  //                                                 print(tempArray[
                  //                                                             i]
                  //                                                         .name
                  //                                                         .toString() +
                  //                                                     "  " +
                  //                                                     tempArray[
                  //                                                             i]
                  //                                                         .price
                  //                                                         .toString());
                  //                                               }
                  //                                             });
                  //                                           },
                  //                                           child: Container(
                  //                                             margin:
                  //                                                 const EdgeInsets
                  //                                                         .only(
                  //                                                     left: 6.0,
                  //                                                     right:
                  //                                                         6.0,
                  //                                                     top: 2.0,
                  //                                                     bottom:
                  //                                                         1.0),
                  //                                             child: Card(
                  //                                               child:
                  //                                                   Container(
                  //                                                 padding:
                  //                                                     EdgeInsets
                  //                                                         .all(
                  //                                                             4.0),
                  //                                                 child: Row(
                  //                                                   mainAxisAlignment:
                  //                                                       MainAxisAlignment
                  //                                                           .spaceBetween,
                  //                                                   children: [
                  //                                                     Column(
                  //                                                       crossAxisAlignment:
                  //                                                           CrossAxisAlignment.start,
                  //                                                       mainAxisAlignment:
                  //                                                           MainAxisAlignment.center,
                  //                                                       children: <
                  //                                                           Widget>[
                  //                                                         Text(
                  //                                                           a.services![index].service![position].name.toString(),
                  //                                                           style: TextStyle(
                  //                                                               fontSize: width * 0.03,
                  //                                                               fontFamily: "Poppins Semibold",
                  //                                                               color: Colors.black),
                  //                                                         ),
                  //                                                         Text(
                  //                                                             "Price: " + a.services![index].service![position].price.toString(),
                  //                                                             style: TextStyle(fontSize: width * 0.03, fontFamily: "Poppins Semibold", color: Colors.black)),
                  //                                                         Text(
                  //                                                             "Time :" + a.services![index].service![position].time.toString(),
                  //                                                             style: TextStyle(fontSize: width * 0.03, fontFamily: "Poppins Semibold", color: Colors.black))
                  //                                                       ],
                  //                                                     ),
                  //                                                     Icon(tempArray.contains(a.services![index].service![
                  //                                                             position])
                  //                                                         ? Icons
                  //                                                             .remove_circle_outline
                  //                                                         : Icons
                  //                                                             .add),
                  //                                                   ],
                  //                                                 ),
                  //                                               ),
                  //                                             ),
                  //                                           ),
                  //                                         );
                  //                                       }),
                  //                                 )
                  //                               ],
                  //                             ),
                  //                           );
                  //                         },
                  //                       ),
                  //                     ),
                  //                   );
                  //                 },
                  //               );
                  //             },
                  //             child:
                  //             Container(
                  //               width: width*0.3,
                  //               height: height*0.3,
                  //               color: Colors.blueAccent,
                  //               child: Column(
                  //                 crossAxisAlignment: CrossAxisAlignment.start,
                  //                 mainAxisAlignment:
                  //                     MainAxisAlignment.spaceBetween,
                  //                 children: <Widget>[
                  //                   Container(
                  //                     padding: EdgeInsets.all(2.0),
                  //                     decoration: BoxDecoration(
                  //                       borderRadius: BorderRadius.circular(8.0),
                  //                       border: Border.all(
                  //                         color: Colors.grey.shade200
                  //                       )
                  //                     ),
                  //                     child: Flexible(
                  //                       child: Column(
                  //                         children: <Widget>[
                  //                           Row(
                  //                             mainAxisAlignment: MainAxisAlignment.start,
                  //                             children: [
                  //                               Image.asset(
                  //                                 'images/svgicons/bx_checkbox.png',
                  //                                 width: 20,
                  //                                 height: 20,
                  //                                 fit: BoxFit.fill,
                  //                               ),
                  //                             ],
                  //                           ),
                  //                           Center(
                  //                               child: Image.network(
                  //                                 '${a.services![0].serviceImage}',
                  //                                 width: width * 0.2,
                  //                                 height: height * 0.1-25,
                  //                                 fit: BoxFit.fill,
                  //                               )),
                  //                           SizedBox(height: 10,)
                  //                         ],
                  //                       ),
                  //                     ),
                  //
                  //                   ),
                  //                   Container(
                  //                     child: Center(
                  //                       child: Text(
                  //                         a.services![0].serviceTitle
                  //                             .toString(),
                  //                         style: TextStyle(
                  //                             fontFamily: 'Poppins Regular',
                  //                             color: Colors.black,
                  //                             fontSize: width * 0.04),
                  //                       ),
                  //                     ),
                  //                   )
                  //                 ],
                  //               ),
                  //             ),
                  //           ),
                  //         );
                  //       },
                  //     ),
                  //   ),
                  // ),
             GridView.builder(
                 shrinkWrap: true,
                 itemCount: a.services!.length,
                 physics: new NeverScrollableScrollPhysics(),
                 gridDelegate:
             SliverGridDelegateWithFixedCrossAxisCount(
                 crossAxisCount: 3,
                 crossAxisSpacing: 10,
                 mainAxisSpacing: 10,

                 mainAxisExtent: 130), itemBuilder:
             (context, index){
                return Center(
                 child: GestureDetector(
                   onTap: () {
                     showDialog(
                       barrierDismissible: false,
                       context: context,
                       builder: (BuildContext context) {
                         return WillPopScope(
                           onWillPop: () async {
                             return false;
                           },
                           child: AlertDialog(
                             insetPadding: EdgeInsets.symmetric(
                               horizontal: 50.0,
                               vertical: 100.0,
                             ),
                             title: Row(
                               mainAxisAlignment:
                               MainAxisAlignment.spaceBetween,
                               children: <Widget>[
                                 Text(
                                   "Select your services ",
                                   style: TextStyle(
                                       fontSize: width * 0.03),
                                 ),
                                 IconButton(
                                   onPressed: () {
                                     var time = 0;
                                     tempArray.forEach((element) {
                                       time +=
                                           int.parse(element.time!);
                                     });
                                     print(time);
                                     Navigator.pop(context);
                                     getSlot(time.toString() + "");
                                   },
                                   icon: Icon(Icons.cancel_outlined),
                                 ),
                               ],
                             ),
                             content: StatefulBuilder(
                               // You need this, notice the parameters below:
                               builder: (BuildContext context,
                                   StateSetter setState) {
                                 return Container(
                                   width: width,
                                   height: 200,
                                   child: Column(
                                     mainAxisAlignment:
                                     MainAxisAlignment.start,
                                     children: [
                                       Flexible(
                                         child: ListView.builder(
                                             shrinkWrap: true,
                                             itemCount: a
                                                 .services![index]
                                                 .service!
                                                 .length,
                                             itemBuilder: (context,
                                                 position) {
                                               return InkWell(
                                                 onTap: () {
                                                   setState(() {
                                                     if (tempArray.contains(a
                                                         .services![
                                                     index]
                                                         .service![
                                                     position])) {
                                                       print(
                                                           "SDF SDF SDF DSF ");
                                                       tempArray.remove(a
                                                           .services![
                                                       index]
                                                           .service![position]);
                                                     } else {
                                                       print(
                                                           "sdfsdfsdfsdfsdfsd ");
                                                       tempArray.add(a
                                                           .services![
                                                       index]
                                                           .service![position]);
                                                     }

                                                     for (var i = 0;
                                                     i <
                                                         tempArray
                                                             .length;
                                                     i++) {
                                                       print(tempArray[
                                                       i]
                                                           .name
                                                           .toString() +
                                                           "  " +
                                                           tempArray[
                                                           i]
                                                               .price
                                                               .toString());
                                                     }
                                                   });
                                                 },
                                                 child: Container(
                                                   margin:
                                                   const EdgeInsets
                                                       .only(
                                                       left: 6.0,
                                                       right:
                                                       6.0,
                                                       top: 2.0,
                                                       bottom:
                                                       1.0),
                                                   child: Card(
                                                     child:
                                                     Container(
                                                       padding:
                                                       EdgeInsets
                                                           .all(
                                                           4.0),
                                                       child: Row(
                                                         mainAxisAlignment:
                                                         MainAxisAlignment
                                                             .spaceBetween,
                                                         children: [
                                                           Column(
                                                             crossAxisAlignment:
                                                             CrossAxisAlignment.start,
                                                             mainAxisAlignment:
                                                             MainAxisAlignment.center,
                                                             children: <
                                                                 Widget>[
                                                               Text(
                                                                 a.services![index].service![position].name.toString(),
                                                                 style: TextStyle(
                                                                     fontSize: width * 0.03,
                                                                     fontFamily: "Poppins Semibold",
                                                                     color: Colors.black),
                                                               ),
                                                               Text(
                                                                   "Price: " + a.services![index].service![position].price.toString(),
                                                                   style: TextStyle(fontSize: width * 0.03, fontFamily: "Poppins Semibold", color: Colors.black)),
                                                               Text(
                                                                   "Time :" + a.services![index].service![position].time.toString(),
                                                                   style: TextStyle(fontSize: width * 0.03, fontFamily: "Poppins Semibold", color: Colors.black))
                                                             ],
                                                           ),
                                                           Icon(tempArray.contains(a.services![index].service![
                                                           position])
                                                               ? Icons
                                                               .remove_circle_outline
                                                               : Icons
                                                               .add),
                                                         ],
                                                       ),
                                                     ),
                                                   ),
                                                 ),
                                               );
                                             }),
                                       )
                                     ],
                                   ),
                                 );
                               },
                             ),
                           ),
                         );
                       },
                     );
                   },
                   child:
                   Container(
                     width: width*0.3,
                     height: height*0.3,
                     color: Colors.white,
                     child: Column(
                       crossAxisAlignment: CrossAxisAlignment.start,
                       mainAxisAlignment:
                       MainAxisAlignment.spaceBetween,
                       children: <Widget>[
                         Container(
                           padding: EdgeInsets.all(2.0),
                           decoration: BoxDecoration(
                               borderRadius: BorderRadius.circular(8.0),
                               border: Border.all(
                                   color: Colors.grey.shade200
                               )
                           ),
                           child: Flexible(
                             child: Column(
                               children: <Widget>[
                                 Row(
                                   mainAxisAlignment: MainAxisAlignment.start,
                                   children: [
                                     Image.asset(
                                       'images/svgicons/bx_checkbox.png',
                                       width: 22,
                                       height: 22,
                                       fit: BoxFit.fill,
                                     ),
                                   ],
                                 ),
                                 Center(
                                     child: Image.network(
                                       '${a.services![index].serviceImage}',
                                       width: width * 0.2,
                                       height: height * 0.1-25,
                                       fit: BoxFit.fill,
                                     )),
                                 SizedBox(height: 22,)
                               ],
                             ),
                           ),

                         ),
                         Container(
                           child: Center(
                             child: Text(
                               a.services![index].serviceTitle
                                   .toString(),
                               style: TextStyle(
                                   fontFamily: 'Poppins Regular',
                                   color: Colors.black,
                                   fontSize: width * 0.04),
                             ),
                           ),
                         )
                       ],
                     ),
                   ),
                 ),
               );
             }),
                  Divider(
                    thickness: 1,
                    color: Color(Utils.hexStringToHexInt('E5E5E5')),
                  ),
                  Container(
                      margin: EdgeInsets.only(left: 6.0),
                      child: seeallbarbaer(context)),

                  Container(
                    margin: EdgeInsets.only(left: 6.0, right: 4.0),
                    height: a.emploeyee!.length > 0
                        ? height * 0.3 - height * 0.02
                        : 0.0,
                    child: ListView.builder(
                        shrinkWrap: true,
                        //customerRegList == null ? 0 : customerRegList.length
                        scrollDirection: Axis.horizontal,
                        itemCount:
                            a.emploeyee == null ? 0 : a.emploeyee!.length,
                        itemBuilder: (context, position) {
                          print(a.emploeyee!.length);
                          return GestureDetector(
                            onTap: () {
                              _isSelected(position);
                              selectEmployeeId =
                                  a.emploeyee![position].id.toString();
                            },
                            child: Stack(
                              clipBehavior: Clip.none,
                              children: <Widget>[
                                Container(
                                  margin: EdgeInsets.only(
                                      top: 12, left: width * 0.02),
                                  child: Card(
                                    elevation: 20,
                                    shadowColor: Colors.transparent,
                                    child: Container(
                                      width: width * 0.4 - width * 0.03,
                                      // height: height * 0.3,
                                      padding: EdgeInsets.only(
                                          top: height * 0.02,
                                          bottom: height * 0.02),
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(12)),
                                          border: Border.all(
                                              color: isSelected != null &&
                                                      isSelected == position
                                                  ? Colors.grey.shade100
                                                  : Colors.transparent,
                                              width: 2)),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: <Widget>[
                                          SizedBox(
                                            height: 8,
                                          ),
                                          CircleAvatar(
                                            radius: width * 0.1 + width * 0.03,
                                            backgroundColor: Colors.yellow,
                                            child: CircleAvatar(
                                              radius:
                                                  width * 0.1 + width * 0.02,
                                              backgroundImage: NetworkImage(a
                                                  .emploeyee![position]
                                                  .profileImage
                                                  .toString()),
                                            ),
                                          ),
                                          SizedBox(
                                            height: 4,
                                          ),
                                          Text(
                                            a.emploeyee![position].name
                                                .toString(),
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.04,
                                                fontFamily: 'Poppins Regular'),
                                          ),
                                          SizedBox(
                                            height: 2,
                                          ),
                                          Text(
                                            a.emploeyee![position].experience
                                                .toString(),
                                            style: TextStyle(
                                                color: Color(
                                                    Utils.hexStringToHexInt(
                                                        '8D8D8D')),
                                                fontSize: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.03,
                                                fontFamily: 'Poppins Regular'),
                                          ),
                                          SizedBox(
                                            height: 2,
                                          ),
                                          // RatingBarIndicator(
                                          //   rating: 2.75,
                                          //   itemBuilder: (context, index) =>
                                          //       Icon(
                                          //     Icons.star,
                                          //     color: Colors.amber,
                                          //   ),
                                          //   itemCount: 5,
                                          //   itemSize: 18.0,
                                          //   direction: Axis.horizontal,
                                          // )
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                // isSelected != null &&
                                //                         //         isSelected ==
                                //                         //             position
                                Visibility(
                                    visible: isSelected != null &&
                                            isSelected == position
                                        ? true
                                        : false,
                                    child: Positioned(
                                        right: 10,
                                        top: 1.0,
                                        child: Container(
                                          width: 34,
                                          height: 34,
                                          color: Colors.white,
                                          child: Image.asset(
                                            'images/svgicons/circletick.png',
                                          ),
                                        ))),
                              ],
                            ),
                          );
                        }),
                  ),

                  const SizedBox(
                    height: 4,
                  ),
                  Divider(
                    thickness: 1,
                    color: Color(Utils.hexStringToHexInt('E5E5E5')),
                  ),
                  SizedBox(
                    height: 4,
                  ),
                  Container(
                      margin: EdgeInsets.only(left: width * 0.03),
                      child: chooseyourslot(context)),
/*Todo--- Calendar  list*/

                  Container(
                    margin: EdgeInsets.only(left: width * 0.03),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        DatePicker(
                          DateTime.now(),
                          height: 100,
                          daysCount: 30,
                          initialSelectedDate: DateTime.now(),
                          selectionColor:
                              Color(Utils.hexStringToHexInt('77ACA2')),
                          selectedTextColor: Colors.white,
                          monthTextStyle: TextStyle(
                            color: Color(Utils.hexStringToHexInt('8D8D8D')),
                            fontSize: width * 0.04,
                            fontFamily: 'Poppins Medium',
                          ),
                          dateTextStyle: TextStyle(
                            color: Color(Utils.hexStringToHexInt('8D8D8D')),
                            fontSize: width * 0.04,
                            fontFamily: 'Poppins Medium',
                          ),
                          dayTextStyle: TextStyle(
                            color: Color(Utils.hexStringToHexInt('8D8D8D')),
                            fontSize: width * 0.04,
                            fontFamily: 'Poppins Medium',
                          ),
                          onDateChange: (date) {
                            // New date selected
                            setState(() {
                              selectDate = date.day.toString() +
                                  "-" +
                                  date.month.toString() +
                                  "-" +
                                  date.year.toString();
                              selectDay = date.day.toString();
                              if (date.weekday.toString() == "1") {
                                selectDay = "Monday";
                              } else if (date.weekday.toString() == "2") {
                                selectDay = "Tuesday";
                              } else if (date.weekday.toString() == "3") {
                                selectDay = "Wednesday";
                              } else if (date.weekday.toString() == "4") {
                                selectDay = "Thrusday";
                              } else if (date.weekday.toString() == "5") {
                                selectDay = "Friday";
                              } else if (date.weekday.toString() == "6") {
                                selectDay = "Saturday";
                              } else if (date.weekday.toString() == "7") {
                                selectDay = "Sunday";
                              }

                              print(selectDay);
                              // _selectedValue = date;
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 6,
                  ),
                  //===========
                  Container(
                    margin: EdgeInsets.only(
                        left: width * 0.03, right: width * 0.03),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          ' Morning',
                          style: TextStyle(
                              fontFamily: 'Poppins Regular',
                              color: Color(Utils.hexStringToHexInt('#A3A2A2')),
                              fontSize: width * 0.04),
                        ),
                        SizedBox(
                          height: height * 0.01,
                        ),
                        SizedBox(
                          width: width,
                          height: 32,
                          child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              shrinkWrap: true,
                              itemCount: slotpojo
                                  .notificationDetail![0].morning!.length,
                              itemBuilder: (context, position) {
                                return InkWell(
                                  onTap: () {
                                    setState(() {
                                      slotSelected = "Morning";
                                      timeSelected =
                                          "${slotpojo.notificationDetail![0].morning![position]}";
                                      _isSelectedSlot(position);
                                    });
                                  },
                                  child: Container(
                                    width: width * 0.3,
                                    margin: EdgeInsets.only(
                                        left: width * 0.02,
                                        right: width * 0.02),
                                    padding: EdgeInsets.only(
                                        left: width * 0.02,
                                        right: width * 0.02,
                                        top: width * 0.02,
                                        bottom: width * 0.02),
                                    decoration: BoxDecoration(
                                        color: slotSelected == "Morning" &&
                                                isSlotSelected == position
                                            ? Color(Utils.hexStringToHexInt(
                                                '77ACA2'))
                                            : Colors.white,
                                        border: Border.all(
                                            //color: Color(Utils.hexStringToHexInt('#8D8D8D')),
                                            color: Colors.grey.shade100,
                                            width: 1)),
                                    child: Center(
                                      child: Text(
                                        '${slotpojo.notificationDetail![0].morning![position]}',
                                        style: TextStyle(
                                          fontFamily: 'Poppins Regular',
                                          fontSize: width * 0.04,
                                          color: slotSelected == "Morning" &&
                                                  isSlotSelected == position
                                              ? Colors.white
                                              : Color(Utils.hexStringToHexInt(
                                                  '#8D8D8D')),
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              }),
                        ),
                        SizedBox(
                          height: height * 0.01,
                        ),
                        Text(
                          ' Afternoon',
                          style: TextStyle(
                              fontFamily: 'Poppins Regular',
                              color: Color(Utils.hexStringToHexInt('#A3A2A2')),
                              fontSize: width * 0.04),
                        ),
                        SizedBox(
                          height: height * 0.01,
                        ),
                        SizedBox(
                          width: width,
                          height: 32,
                          child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              shrinkWrap: true,
                              itemCount: slotpojo
                                  .notificationDetail![0].afternoon!.length,
                              itemBuilder: (context, position) {
                                return InkWell(
                                  onTap: () {
                                    setState(() {
                                      slotSelected = "Afternoon";
                                      timeSelected =
                                          "${slotpojo.notificationDetail![0].morning![position]}";
                                      _isSelectedSlot(position);
                                    });
                                  },
                                  child: Container(
                                    width: width * 0.3,
                                    margin: EdgeInsets.only(
                                        left: width * 0.02,
                                        right: width * 0.02),
                                    padding: EdgeInsets.only(
                                        left: width * 0.02,
                                        right: width * 0.02,
                                        top: width * 0.02,
                                        bottom: width * 0.02),
                                    decoration: BoxDecoration(
                                        color: slotSelected == "Afternoon" &&
                                                isSlotSelected == position
                                            ? Color(Utils.hexStringToHexInt(
                                                '77ACA2'))
                                            : Colors.white,
                                        border: Border.all(
                                            //color: Color(Utils.hexStringToHexInt('#8D8D8D')),
                                            color: Colors.grey.shade100,
                                            width: 1)),
                                    child: Center(
                                      child: Text(
                                        '${slotpojo.notificationDetail![0].afternoon![position]}',
                                        style: TextStyle(
                                          fontSize: width * 0.04,
                                          fontFamily: 'Poppins Regular',
                                          color: slotSelected == "Afternoon" &&
                                                  isSlotSelected == position
                                              ? Colors.white
                                              : Color(Utils.hexStringToHexInt(
                                                  '#8D8D8D')),
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              }),
                        ),
                        SizedBox(
                          height: height * 0.01,
                        ),
                        Text(
                          ' Evening',
                          style: TextStyle(
                              fontFamily: 'Poppins Regular',
                              color: Color(Utils.hexStringToHexInt('#A3A2A2')),
                              fontSize: width * 0.04),
                        ),
                        SizedBox(
                          height: 6,
                        ),
                        SizedBox(
                          width: width,
                          height: 32,
                          child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              shrinkWrap: true,
                              itemCount: slotpojo
                                  .notificationDetail![0].evening!.length,
                              itemBuilder: (context, position) {
                                return InkWell(
                                  onTap: () {
                                    setState(() {
                                      slotSelected = "Evening";
                                      timeSelected =
                                          "${slotpojo.notificationDetail![0].evening![position]}";
                                      _isSelectedSlot(position);
                                    });
                                  },
                                  child: Container(
                                    width: width * 0.3,
                                    margin: EdgeInsets.only(
                                        left: width * 0.02,
                                        right: width * 0.02),
                                    padding: EdgeInsets.only(
                                        left: width * 0.02,
                                        right: width * 0.02,
                                        top: width * 0.02,
                                        bottom: width * 0.02),
                                    decoration: BoxDecoration(
                                        color: slotSelected == "Evening" &&
                                                isSlotSelected == position
                                            ? Color(Utils.hexStringToHexInt(
                                                '77ACA2'))
                                            : Colors.white,
                                        border: Border.all(
                                            //color: Color(Utils.hexStringToHexInt('#8D8D8D')),
                                            color: Colors.grey.shade100,
                                            width: 1)),
                                    child: Center(
                                      child: Text(
                                        '${slotpojo.notificationDetail![0].evening![position]}',
                                        style: TextStyle(
                                          fontSize: width * 0.04,
                                          fontFamily: 'Poppins Regular',
                                          color: slotSelected == "Evening" &&
                                                  isSlotSelected == position
                                              ? Colors.white
                                              : Color(Utils.hexStringToHexInt(
                                                  '#8D8D8D')),
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              }),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(
                    height: 12,
                  ),
                  Card(
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    child: Container(
                        width: width,
                        height: height * 0.1 - height * 0.03,
                        margin: EdgeInsets.only(bottom: 10),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius:
                                BorderRadius.all(Radius.circular(18))),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            GestureDetector(
                              onTap: () {
                                if (session == null || session == "") {
                                  CommonDialog.showsnackbar(
                                      "Please login for use all features");
                                } else if (tempArray.isEmpty) {
                                  CommonDialog.showsnackbar(
                                      "Please select your services");
                                } else if (slotSelected == "") {
                                  CommonDialog.showsnackbar(
                                      "Please select  slot");
                                } else if (selectDate == "") {
                                  CommonDialog.showsnackbar(
                                      "Please select  date");
                                } else {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => OrderDetail(
                                            tempArray,
                                            a,
                                            selectEmployeeId.toString() + "",
                                            selectDate + "",
                                            selectDay + "",
                                            slotSelected + "",
                                            timeSelected + "")),
                                  );
                                }
                              },
                              child: Container(
                                width: width - width * 0.2,
                                height: height * 0.08,
                                decoration: BoxDecoration(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(12)),
                                    border: Border.all(
                                        color: Color(
                                            Utils.hexStringToHexInt('77ACA2')),
                                        width: 2)),
                                child: Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Text(
                                        'Next',
                                        style: TextStyle(
                                            color: Color(
                                                Utils.hexStringToHexInt(
                                                    '77ACA2')),
                                            fontFamily: 'Poppins Regular',
                                            fontSize: width * 0.05),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        )),
                  ),
                  const SizedBox(
                    height: 18,
                  ),
                ],
              ),
            ),
          );
        }
      })),
    );
  }

  void openn(width, height) {
    bool _value = false;
    showModalBottomSheet<void>(
        context: context,
        enableDrag: false,
        backgroundColor: Color(Utils.hexStringToHexInt('77ACA2')),
        isScrollControlled: false,
        isDismissible: false,
        builder: (BuildContext context) {
          return Container(
            width: width,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SizedBox(
                  height: height * 0.03,
                ),
                Center(
                    child: Image.asset(
                  'images/svgicons/hairdressing.png',
                  width: 70,
                  height: 70,
                  color: Colors.white,
                )),
                Container(
                  margin:
                      EdgeInsets.only(left: width * 0.08, right: width * 0.08),
                  child: Divider(
                    color: Colors.white,
                    thickness: 1,
                  ),
                ),
                Container(
                  margin:
                      EdgeInsets.only(left: width * 0.08, right: width * 0.08),
                  child: Text(
                    'Choose your category',
                    textAlign: TextAlign.left,
                    style: TextStyle(
                        fontFamily: 'Poppins Regular',
                        fontSize: MediaQuery.of(context).size.height * 0.02,
                        color: Colors.white),
                  ),
                ),
                SizedBox(
                  width: width,
                  height: height * 0.2,
                  child: ListView.builder(
                      itemCount: 8,
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      itemBuilder: (context, i) {
                        return Row(
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                Checkbox(
                                  value: _value,
                                  onChanged: (value) {
                                    setState(() {
                                      _value = value!;
                                      print(_value);
                                    });
                                  },
                                ),
                                Text("SDFDFDDF"),
                              ],
                            ),
                            Text("SDFF")
                          ],
                        );
                      }),
                ),
                SizedBox(
                  height: height * 0.03,
                ),
                ElevatedButton(onPressed: null, child: Text("click here"))
              ],
            ),
          );
        });
  }

  void _onSelected(bool selected, String dataName) {
    if (selected == true) {
      setState(() {
        userChecked.add(dataName);
      });
    } else {
      setState(() {
        userChecked.remove(dataName);
      });
    }
  }

  Widget profiledes(BuildContext context, width, height, name, address,
      ownerimage, ownername, List<DataService>? services, rating) {
    return Container(
        width: width,
        height: height * 0.2 + height * 0.05,
        color: Colors.white,
        margin: EdgeInsets.only(
            left: width * 0.04, top: height * 0.02, right: 12.0),
        child: Stack(
          children: <Widget>[
            Row(
              children: <Widget>[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      name,
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: MediaQuery.of(context).size.height * 0.05,
                          fontFamily: 'Poppins Regular'),
                    ),
                    Container(
                      alignment: Alignment.topLeft,
                      color: Colors.white,
                      child: Row(
                        children: <Widget>[
                          Container(
                            width: width * 0.05,
                            height: height * 0.04,
                            child: SvgPicture.asset(
                              "images/svgicons/mappin.svg",
                              fit: BoxFit.contain,
                            ),
                          ),
                          Text(" " + address,
                              style: TextStyle(
                                  fontSize: width * 0.05,
                                  fontFamily: 'Poppins Regular',
                                  color: Color(
                                      Utils.hexStringToHexInt('#77ACA2'))),
                              textAlign: TextAlign.center),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: height * 0.01,
                    ),
                    Row(
                      children: <Widget>[
                        CircleAvatar(
                          radius: width * 0.03,
                          backgroundImage: NetworkImage(ownerimage),
                          backgroundColor: Colors.transparent,
                        ),
                        Text(
                          " " + ownername,
                          style: TextStyle(
                              color: Color(Utils.hexStringToHexInt('#5E5E5E')),
                              fontSize:
                                  MediaQuery.of(context).size.width * 0.04,
                              fontFamily: 'Poppins Light'),
                        )
                      ],
                    ),
                    SizedBox(
                      height: height * 0.02,
                    ),
                    Text(
                      'Services',
                      style: TextStyle(
                          fontFamily: 'Poppins Regular',
                          fontSize: MediaQuery.of(context).size.width * 0.05,
                          color: Colors.black),
                    ),
                    SizedBox(
                      height: height * 0.01,
                    ),
                    Flexible(
                      child: ListView.builder(
                          // customerRegList == null ? 0 : customerRegList.length,
                          itemCount: services == null ? 0 : services.length,
                          scrollDirection: Axis.horizontal,
                          shrinkWrap: true,
                          primary: true,
                          itemBuilder: (context, position) {
                            return Wrap(
                              children: <Widget>[
                                Container(
                                  margin: EdgeInsets.only(left: 3, right: 3),
                                  padding: EdgeInsets.only(
                                      left: 10, right: 10, top: 4, bottom: 4),
                                  decoration: BoxDecoration(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(24)),
                                      color: Color(
                                          Utils.hexStringToHexInt('E5E5E5'))),
                                  child: Center(
                                      child: Text(
                                    services![position].serviceTitle.toString(),
                                    style: TextStyle(
                                        color: Color(
                                          Utils.hexStringToHexInt('77ACA2'),
                                        ),
                                        fontFamily: 'Poppins Light',
                                        fontSize: width * 0.03),
                                  )),
                                )
                              ],
                            );
                          }),
                    ),
                  ],
                ),
              ],
            ),
            Align(
              alignment: Alignment.topRight,
              child: Container(
                margin: EdgeInsets.only(top: 3),
                width: width * 0.4 - width * 0.08,
                height: height * 0.1 - 9,
                decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(
                      color: Color(Utils.hexStringToHexInt('#C4C4C4')),
                      width: 2,
                    ),
                    borderRadius: BorderRadius.all(Radius.circular(8))),
              ),
            ),
            Stack(
              children: <Widget>[
                Positioned(
                  top: 6,
                  right: width * 0.2 + 10,
                  // alignment: Alignment.topLeft,
                  child: Text(
                    '${rating}',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: width * 0.08,
                        fontFamily: 'Poppins Medium'),
                  ),
                ),
                Positioned(
                  top: height * 0.02,
                  left: width * 0.7,
                  // alignment: Alignment.topLeft,
                  child: Text(
                    '/5',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: width * 0.05,
                        fontFamily: 'Poppins Medium'),
                  ),
                ),
                Positioned(
                  top: height * 0.02,
                  left: width * 0.8 - 6,
                  // alignment: Alignment.topLeft,
                  child: Text(
                    '10',
                    style: TextStyle(
                        color: Color(Utils.hexStringToHexInt('A3A2A2')),
                        fontSize: width * 0.03,
                        fontFamily: 'Poppins Medium'),
                  ),
                ),
                Positioned(
                  top: height * 0.03,
                  left: width * 0.8 - 6,
                  // alignment: Alignment.topLeft,
                  child: Text(
                    'opnions',
                    style: TextStyle(
                        color: Color(Utils.hexStringToHexInt('A3A2A2')),
                        fontSize: width * 0.03,
                        fontFamily: 'Poppins Medium'),
                  ),
                ),
                /* TODO---Rating*/
                Positioned(
                  top: height * 0.06,
                  left: width * 0.6 + width * 0.07,
                  // alignment: Alignment.topLeft,
                  child: RatingBarIndicator(
                    rating: rating != null ? rating!.toDouble() : 1.0,
                    itemBuilder: (context, index) => Icon(
                      Icons.star,
                      color: Colors.amber,
                    ),
                    itemCount: 5,
                    itemSize: 14.0,
                    direction: Axis.horizontal,
                  ),
                ),
              ],
            ),
          ],
        ));
  }

  Widget description(BuildContext context, width, height, description,
      aminities, List<TimeSlot>? timeSlot) {
    return Container(
      margin: const EdgeInsets.only(bottom: 6, left: 12, right: 12),
      width: width,
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            'Description',
            style: TextStyle(
                fontSize: width * 0.05,
                color: Colors.black,
                fontFamily: 'Poppins Regular'),
          ),
          AutoSizeText(
            "$description",
            style: TextStyle(
                fontSize: width * 0.02,
                color: Color(Utils.hexStringToHexInt('#8D8D8D')),
                fontFamily: 'Poppins Light'),
            maxLines: 5,
          ),
          SizedBox(
            height: height * 0.01,
          ),
          Text(
            'Amenties',
            style: TextStyle(
                fontSize: width * 0.05,
                color: Colors.black,
                fontFamily: 'Poppins Regular'),
          ),
          AutoSizeText(
            "$aminities",
            style: TextStyle(
                fontSize: width * 0.02,
                color: Color(Utils.hexStringToHexInt('#8D8D8D')),
                fontFamily: 'Poppins Light'),
            maxLines: 5,
          ),
          SizedBox(
            height: height * 0.01,
          ),
          Text(
            "Timings",
            style: TextStyle(
                fontSize: width * 0.05,
                color: Colors.black,
                fontFamily: 'Poppins Regular'),
          ),
          //Utils().titleText('Timings ', context),
          SizedBox(
            height: 4,
          ),
          Row(
            children: <Widget>[
              Text(
                'Opening Time',
                style: TextStyle(
                    color: Color(Utils.hexStringToHexInt('5E5E5E')),
                    fontFamily: 'Poppins Light',
                    fontSize: width * 0.04),
              ),
              SizedBox(
                width: width * 0.09,
              ),
              Text(
                'Closing Time',
                style: TextStyle(
                    color: Color(Utils.hexStringToHexInt('5E5E5E')),
                    fontFamily: 'Poppins Light',
                    fontSize: width * 0.04),
              )
            ],
          ),
          SizedBox(
            height: height * 0.001,
          ),
          Row(
            children: <Widget>[
              Text(
                timeSlot!.length > 0
                    ? " " + timeSlot[0].openingTime.toString()
                    : "",
                style: TextStyle(
                    color: Colors.black,
                    fontFamily: 'Poppins Regular',
                    fontSize: width * 0.04),
              ),
              SizedBox(
                width: width * 0.2,
              ),
              //  " " + timeSlot![0].closingTime.toString()
              Text(
                timeSlot.length > 0
                    ? " " + timeSlot[0].closingTime.toString()
                    : "",
                style: TextStyle(
                    color: Colors.black,
                    fontFamily: 'Poppins Regular',
                    fontSize: width * 0.04),
              )
            ],
          )
        ],
      ),
    );
  }

  Future _duratin(BuildContext contextt, width, height) {
    bool _value = false;
    return showDialog(
        barrierDismissible: false,
        context: contextt,
        builder: (BuildContext) {
          return SimpleDialog(
            contentPadding: EdgeInsets.symmetric(horizontal: 10),
            title: Row(
              children: <Widget>[
                SizedBox(width: 10),
                Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      SizedBox(
                        height: height * 0.03,
                      ),
                      Center(
                          child: Image.asset(
                        'images/svgicons/hairdressing.png',
                        width: 70,
                        height: 70,
                      )),
                      Container(
                        child: Divider(
                          color: Colors.white,
                          thickness: 1,
                        ),
                      ),
                      Container(
                        child: Text(
                          'Choose your category',
                          textAlign: TextAlign.left,
                          style: TextStyle(
                              fontFamily: 'Poppins Regular',
                              fontSize:
                                  MediaQuery.of(context).size.height * 0.02,
                              color: Colors.white),
                        ),
                      ),
                      SizedBox(
                        width: width,
                        height: height * 0.2,
                        child: ListView.builder(
                            itemCount: 8,
                            scrollDirection: Axis.vertical,
                            shrinkWrap: true,
                            itemBuilder: (context, i) {
                              return Row(
                                children: <Widget>[
                                  Row(
                                    children: <Widget>[
                                      Checkbox(
                                        value: _value,
                                        onChanged: (value) {
                                          setState(() {
                                            _value = value!;
                                            print(_value);
                                          });
                                        },
                                      ),
                                      Text(
                                        "SDFDFDDF",
                                        style:
                                            TextStyle(fontSize: width * 0.03),
                                      ),
                                    ],
                                  ),
                                  Text(
                                    "SDFF",
                                    style: TextStyle(fontSize: width * 0.03),
                                  )
                                ],
                              );
                            }),
                      ),
                      SizedBox(
                        height: height * 0.03,
                      ),
                      ElevatedButton(onPressed: null, child: Text("click here"))
                    ],
                  ),
                )
              ],
            ),
            children: <Widget>[
              SizedBox(height: 20),
              Row(
                children: <Widget>[
                  MaterialButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text(
                      "OK",
                      style: TextStyle(color: Theme.of(context).accentColor),
                    ),
                  ),
                ],
                mainAxisAlignment: MainAxisAlignment.end,
              ),
              SizedBox(height: 10),
            ],
          );
        });
  }

  Widget seeallbarbaer(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        // Utils().titleText('Choose your barber', context),
        Text(
          "  Choose your barber",
          style: TextStyle(
              fontFamily: 'Poppins Regular',
              fontSize: MediaQuery.of(context).size.width * 0.05,
              color: Colors.black),
        ),
        // Text(
        //   'See all ',
        //   style: TextStyle(
        //       fontFamily: 'Poppins Regular',
        //       fontSize: MediaQuery.of(context).size.height * 0.02,
        //       color: Color(Utils.hexStringToHexInt('#77aca2'))),
        // )
      ],
    );
  }

  Widget bestoffer(BuildContext context, a) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text(
          '  Best Offers for you',
          style: TextStyle(
              fontFamily: 'Poppins Regular',
              fontSize: MediaQuery.of(context).size.height * 0.02,
              color: Colors.black),
        ),
        Text(
          '${a.coupon!.length} offers    ',
          style: TextStyle(
              fontFamily: 'Poppins Regular',
              fontSize: MediaQuery.of(context).size.width * 0.03,
              color: Color(Utils.hexStringToHexInt('#77aca2'))),
        )
      ],
    );
  }

  Widget seeall(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        // Utils().titleText('Choose services', context),
        Text(
          "  Choose services",
          style: TextStyle(
              fontFamily: 'Poppins Regular',
              fontSize: MediaQuery.of(context).size.width * 0.05,
              color: Colors.black),
        ),
        // Text(
        //   'See all ',
        //   style: TextStyle(
        //       fontFamily: 'Poppins Regular',
        //       fontSize: MediaQuery.of(context).size.height * 0.02,
        //       color: Color(Utils.hexStringToHexInt('#77aca2'))),
        // )
      ],
    );
  }

  Widget chooseyourslot(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Utils().titleText2(' Choose your Slot', context),
        Text(
          '',
          style: TextStyle(
              fontFamily: 'Poppins Regular',
              fontSize: MediaQuery.of(context).size.width * 0.05,
              color: Color(Utils.hexStringToHexInt('#77aca2'))),
        )
      ],
    );
  }

  Widget barberlist(BuildContext context, width, height, Emploeyee emploeyee) {
    return Stack(
      clipBehavior: Clip.none,
      children: <Widget>[
        Container(
          margin: EdgeInsets.only(top: 12, left: width * 0.02),
          child: Card(
            elevation: 20,
            child: Container(
              width: width * 0.4 + width * 0.04,
              //   height: height * 0.4 - height * 0.04,
              padding:
                  EdgeInsets.only(top: height * 0.02, bottom: height * 0.02),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(12)),
                  border: Border.all(color: Colors.grey, width: 2)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  SizedBox(
                    height: 12,
                  ),
                  CircleAvatar(
                    radius: width * 0.14,
                    backgroundColor: Colors.yellow,
                    child: CircleAvatar(
                      radius: width * 0.13,
                      backgroundImage:
                          NetworkImage(emploeyee.profileImage.toString()),
                    ),
                  ),
                  SizedBox(
                    height: 4,
                  ),
                  Text(
                    emploeyee.name.toString(),
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: MediaQuery.of(context).size.width * 0.04,
                        fontFamily: 'Poppins Regular'),
                  ),
                  SizedBox(
                    height: 2,
                  ),
                  Text(
                    emploeyee.experience.toString(),
                    style: TextStyle(
                        color: Color(Utils.hexStringToHexInt('8D8D8D')),
                        fontSize: MediaQuery.of(context).size.width * 0.03,
                        fontFamily: 'Poppins Regular'),
                  ),
                  SizedBox(
                    height: 2,
                  ),
                  RatingBarIndicator(
                    rating: 2.75,
                    itemBuilder: (context, index) => Icon(
                      Icons.star,
                      color: Colors.amber,
                    ),
                    itemCount: 5,
                    itemSize: 18.0,
                    direction: Axis.horizontal,
                  )
                ],
              ),
            ),
          ),
        ),
        // isSelected != null &&
        //                         //         isSelected ==
        //                         //             position
        // Visibility(
        //     visible:  isSelected != null &&isSelected ==position?true:false,
        //     child:  Positioned(
        //     right: 10,
        //     top: -1.0,
        //     child: Container(
        //       width: 34,
        //       height: 34,
        //       color: Colors.white,
        //       child: Image.asset(
        //         'images/svgicons/circletick.png',
        //       ),
        //     )))
      ],
    );
  }
}

Future<void> openMap(BuildContext context, double lat, double lng) async {
  String url = '';
  String urlAppleMaps = '';
  if (Platform.isAndroid) {
    url = 'https://www.google.com/maps/search/?api=1&query=$lat,$lng';
  } else {
    urlAppleMaps = 'https://maps.apple.com/?q=$lat,$lng';
    url = 'comgooglemaps://?saddr=&daddr=$lat,$lng&directionsmode=driving';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  if (await canLaunch(url)) {
    await launch(url);
  } else if (await canLaunch(urlAppleMaps)) {
    await launch(urlAppleMaps);
  } else {
    throw 'Could not launch $url';
  }
}

void _launchUrl(latitude, longitude) async {
  const _url =
      'https://www.google.com/maps/dir/?api=1&origin=43.7967876,-79.5331616&destination=43.5184049,-79.8473993&waypoints=43.1941283,-79.59179|43.7991083,-79.5339667|43.8387033,-79.3453417|43.836424,-79.3024487&travelmode=driving&dir_action=navigate';
  Uri _uri = Uri.parse(_url);

  if (!await launchUrl(_uri)) throw 'Could not launch $_url';
}

class SamleClass {
  var check = false;
  var title = "";

  SamleClass(this.check, this.title);
}
