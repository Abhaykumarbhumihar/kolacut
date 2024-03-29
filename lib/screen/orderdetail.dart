import 'package:ezanimation/ezanimation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:untitled/model/ShopDetailPojo.dart';
import 'package:untitled/screen/HomeScreen.dart';
import 'package:untitled/screen/homebottombar.dart';
import 'package:untitled/screen/homepage.dart';
import 'package:untitled/utils/CommomDialog.dart';
import 'package:untitled/utils/Utils.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

import '../controller/BookingController.dart';
import '../controller/home_controller.dart';
import '../controller/shopdetain_controller.dart';
import 'coin.dart';
import 'yourbooking.dart';

class OrderDetail extends StatefulWidget {
  List<ServiceService> newarray;
  Data data;
  var selectEmpid = "";
  var selectDate = "";
  var selectDay = "";
  var selectSlot = "";
  var timeslot = "";

  // const OrderDetail(List<SubService> tempArray, Data a,  {Key? key}) : super(key: key){}

  OrderDetail(List<ServiceService> tempArray, Data a, String selectEmpid,
      String selectDate, String selectDay, String selectSlot, String timeSlot) {
    this.newarray = tempArray;
    this.data = a;
    this.selectDate = selectDate;
    this.selectEmpid = selectEmpid;
    this.selectDay = selectDay;
    this.selectSlot = selectSlot;
    this.timeslot = timeSlot;
  }

  @override
  State<OrderDetail> createState() => _OrderDetailState(
      newarray, data, selectDate, selectEmpid, selectDay, selectSlot, timeslot);
}

class _OrderDetailState extends State<OrderDetail> {
   Razorpay _razorpay;
  List resultList = [];
  var coin = 0;
  var applycoin = 0.0;
  var applycouponPrice = 0.0;
  var applycouponcode = "";
  var total_price = 0;
  var coupontype = "";
  TextEditingController _textFieldcoin = TextEditingController();
  EzAnimation ezAnimation = EzAnimation(50.0, 200.0, Duration(seconds: 5));
  BookingController bookingController = Get.put(BookingController());

  _OrderDetailState(
      tempArray, a, selectDate, selectEmpid, selectDay, selectSlot, timeslot);

  ShopDetailController salonControlller = Get.put(ShopDetailController());
   SharedPreferences sharedPreferences;

//shop_idd,employee_id,service_id,sub_service_id,date,
//       from_time,booking_day,to_time,amount

  var totalPrice = 0;
  var sub_serviceid = "";

  void bookService(BuildContext context) {
    salonControlller.bookserVice(
        context,
        widget.data.id.toString(),
        widget.selectEmpid.toString() + "",
        "3",
        resultList.join(","),
        widget.selectDate.toString(),
        widget.selectSlot.toString(),
        widget.selectDay.toString(),
        widget.timeslot.toString(),
        "$totalPrice",
        "Offline",
        "",
        0.0,
        "",
        "",
        "");
  }

  String getTimeString(int value) {
    final int hour = value ~/ 60;
    final int minutes = value % 60;
    return '${hour.toString().padLeft(2, "0")}:${minutes.toString().padLeft(2, "0")}';
  }

  void bookServiceOnline(
    BuildContext context,
    transactionid,
    coin,
    coupone,
  ) {
    salonControlller.bookserVice(
        context,
        widget.data.id.toString(),
        widget.selectEmpid.toString() + "",
        "3",
        resultList.join(","),
        widget.selectDate.toString(),
        widget.selectSlot.toString(),
        widget.selectDay.toString(),
        widget.timeslot.toString(),
        "${int.parse(totalPrice.toString()) - (applycouponPrice + applycoin)}",
        "Online",
        transactionid,
        coin,
        coupone + "",
        coupontype + "",
        totalPrice.toString());
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
    SharedPreferences.getInstance().then((SharedPreferences sp) {
      sharedPreferences = sp;
      var _testValue = sharedPreferences.getString("session");
      // print(sharedPreferences.getString("session"));
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        Get.find<HomeController>().getCoin1(_testValue);
        //  Get.find<HomeController>().getAdminCouponList(_testValue);
      });
    });
    print("COIN IS ${Get.find<HomeController>().coin}");
    coin = Get.find<HomeController>().coin;
    print(widget.data.name.toString());
    print(widget.selectEmpid + "EMP");
    print(widget.selectDay + " day");
    print(widget.selectDate + " date");
    widget.newarray.forEach((element) {
      total_price += int.parse(element.price.toString());
      totalPrice = totalPrice + int.parse(element.price.toString());
      print(element.name.toString() + "  " + element.price.toString());
      resultList.add(element.id);
    });
  }

  @override
  void dispose() {
    super.dispose();
    _razorpay.clear();
  }

  void openCheckout(shopname, description) async {
    var newprice =
        double.parse(totalPrice.toString()) - (applycouponPrice + applycoin);
    print(newprice);
    var options = {
      'key': 'rzp_test_XyJKvJNHhYN1ax',
      'amount': newprice * 100,
      'name': '${shopname}',
      'description': '${description}',
      'retry': {'enabled': true, 'max_count': 1},
      'send_sms_hash': true,
      'prefill': {'contact': '8888888888', 'email': 'test@razorpay.com'},
      'external': {
        'wallets': ['paytm']
      }
    };

    try {
      print(options);
      _razorpay.open(options);
    } catch (e) {
      debugPrint('Error: e');
    }
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    print('Success Response: $response');
    print("${response.paymentId} " + " SDF SDF SDF SDF ");
    bookServiceOnline(
        context, "${response.paymentId}", applycoin, applycouponcode);
    /*Fluttertoast.showToast(
        msg: "SUCCESS: " + response.paymentId,
        toastLength: Toast.LENGTH_SHORT); */
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    print('Error Response: $response');
    CommonDialog.showsnackbar(
        "ERROR: " + response.code.toString() + " - " + response.message);
    /* Fluttertoast.showToast(
        msg: "ERROR: " + response.code.toString() + " - " + response.message,
        toastLength: Toast.LENGTH_SHORT); */
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    print('External SDK Response: $response');
    /* Fluttertoast.showToast(
        msg: "EXTERNAL_WALLET: " + response.walletName,
        toastLength: Toast.LENGTH_SHORT); */
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;

    return SafeArea(
        child: Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.white,
      body: ListView(
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(
                height: height * 0.02,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 12.0, right: 12.0),
                child: Column(
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            GestureDetector(
                              onTap: () {
                                Navigator.pop(context);
                              },
                              child: Icon(
                                CupertinoIcons.arrow_left,
                                color: Colors.black,
                              ),
                            ),
                            Text(
                              '${widget.data.name.toString()}',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: width * 0.06,
                                  fontFamily: 'Poppins Regular'),
                            )
                          ],
                        ),
                        // SvgPicture.asset(
                        //   'images/svgicons/appcupon.svg',
                        //   fit: BoxFit.contain,
                        //   width: 24,
                        //   height: 24,
                        // )
                      ],
                    ),
                    SizedBox(
                      height: height * 0.01,
                    ),
                    Container(
                      alignment: Alignment.topLeft,
                      color: Colors.white,
                      child: Row(
                        children: <Widget>[
                          Container(
                            width: 20,
                            height: 20,
                            child: SvgPicture.asset(
                              "images/svgicons/mappin.svg",
                            ),
                          ),
                          Text(' ${widget.data.address.toString()}',
                              style: TextStyle(
                                  fontSize: width * 0.04,
                                  fontFamily: 'Poppins Regular',
                                  color: Color(
                                      Utils.hexStringToHexInt('#77ACA2'))),
                              textAlign: TextAlign.center),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: height * 0.04,
                    ),
                    Row(
                      children: <Widget>[
                        Container(
                          width: 24,
                          height: 24,
                          child: SvgPicture.asset(
                            "images/svgicons/lock.svg",
                          ),
                        ),
                        Text(
                          '  Your Order',
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: width * 0.04,
                              fontFamily: 'Poppins Semibold'),
                        )
                      ],
                    ),
                    SizedBox(
                      height: height * 0.02,
                    ),
                    Container(
                      margin: EdgeInsets.only(
                          left: width * 0.1 + width * 0.04,
                          right: width * 0.03),
                      width: width,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            '  Services',
                            style: TextStyle(
                                color: Color(Utils.hexStringToHexInt('5E5E5E')),
                                fontSize: width * 0.03,
                                fontFamily: 'Poppins Regular'),
                          ),
                          Text(
                            '  Prices      ',
                            style: TextStyle(
                                color: Color(Utils.hexStringToHexInt('5E5E5E')),
                                fontSize: width * 0.03,
                                fontFamily: 'Poppins Regular'),
                          )
                        ],
                      ),
                    ),
                    SizedBox(height: height * 0.01),
                    Material(
                      elevation: 0,
                      color: Colors.white,
                      child: Column(
                        children: <Widget>[
                          SizedBox(
                            width: width,
                            child: ListView.builder(
                                shrinkWrap: true,
                                itemCount: widget.newarray.length,
                                itemBuilder: (context, position) {
                                  return Container(
                                    margin: EdgeInsets.only(
                                        right: width * 0.03, bottom: 3.0),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        Row(
                                          children: <Widget>[
                                            InkWell(
                                              onTap: () {
                                                setState(() {
                                                  widget.newarray
                                                      .removeAt(position);
                                                  resultList.clear();
                                                  total_price = 0;
                                                  totalPrice = 0;
                                                  widget.newarray
                                                      .forEach((element) {
                                                    total_price += int.parse(
                                                        element.price
                                                            .toString());
                                                    totalPrice = totalPrice +
                                                        int.parse(element.price
                                                            .toString());
                                                    print(element.name
                                                            .toString() +
                                                        "  " +
                                                        element.price
                                                            .toString());
                                                    resultList.add(element.id);
                                                  });
                                                });
                                              },
                                              child: Container(
                                                width: width * 0.09,
                                                height: height * 0.05,
                                                child: SvgPicture.asset(
                                                  "images/svgicons/checktick.svg",
                                                ),
                                              ),
                                            ),
                                            Container(
                                              margin: EdgeInsets.only(
                                                  left: width * 0.03,
                                                  bottom: 1.0),
                                              child: Text(
                                                  '${widget.newarray[position].name}',
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: width * 0.05,
                                                      fontFamily:
                                                          'Poppins Regular')),
                                            )
                                          ],
                                        ),
                                        Container(
                                          margin: EdgeInsets.only(
                                              right: width * 0.03),
                                          child: Text(
                                              'Rs. ${widget.newarray[position].price}',
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: width * 0.04,
                                                  fontFamily:
                                                      'Poppins Regular')),
                                        )
                                      ],
                                    ),
                                  );
                                }),
                          ),
                          SizedBox(
                            height: height * 0.05,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  Navigator.pop(context);
                                },
                                child: SvgPicture.asset(
                                  'images/svgicons/addmoreservices.svg',
                                  width: width * 0.01,
                                  height: height * 0.02,
                                ),
                              ),
                            ],
                          ),
                          Divider(
                            thickness: 2,
                            color: Color(Utils.hexStringToHexInt('E5E5E5')),
                          ),
                          SizedBox(
                            height: 4,
                          ),
                          Row(
                            children: <Widget>[
                              SvgPicture.asset(
                                'images/svgicons/questionmark.svg',
                                fit: BoxFit.contain,
                                width: 18,
                                height: 18,
                              ),
                              Text(
                                ' Do you have any query?',
                                style: TextStyle(
                                    fontFamily: 'Poppins Light',
                                    fontSize: width * 0.02,
                                    color: Color(
                                        Utils.hexStringToHexInt('8D8D8D'))),
                              )
                            ],
                          ),
                          SizedBox(
                            height: height * 0.02,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              // SizedBox(
              //   height: 10,
              // ),
              // InkWell(
              //   onTap: () {
              //     showDialog(
              //       context: context,
              //       builder: (BuildContext context) {
              //         bool showSublist =
              //             false; // Declare your variable outside the builder
              //
              //         bool showmainList = true;
              //
              //         return AlertDialog(
              //           title: Row(
              //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //             children: <Widget>[
              //               Text(
              //                 'Use shop coupon',
              //                 style: TextStyle(
              //                   fontSize: width * 0.04,
              //                   color: Colors.black,
              //                   fontFamily: 'Poppins Medium',
              //                 ),
              //               ),
              //               IconButton(
              //                 onPressed: () => {Navigator.pop(context)},
              //                 icon: Icon(Icons.cancel_outlined),
              //               ),
              //             ],
              //           ),
              //           content: StatefulBuilder(
              //             // You need this, notice the parameters below:
              //             builder:
              //                 (BuildContext context, StateSetter setState) {
              //               return Container(
              //                 width: width,
              //                 height: 250,
              //                 child: Column(
              //                   mainAxisAlignment: MainAxisAlignment.start,
              //                   children: [
              //                     Flexible(
              //                       child: ListView.builder(
              //                           shrinkWrap: true,
              //                           itemCount: widget.data.coupon.length,
              //                           scrollDirection: Axis.vertical,
              //                           itemBuilder: (context, position) {
              //                             return Container(
              //                                 width: width * 0.4 + width * 0.05,
              //                                 height: height * 0.12,
              //                                 margin: EdgeInsets.all(6),
              //                                 decoration: BoxDecoration(
              //                                     color: Colors.white,
              //                                     borderRadius:
              //                                         BorderRadius.all(
              //                                             Radius.circular(8)),
              //                                     border: Border.all(
              //                                         color: Colors.grey,
              //                                         width: 1)),
              //                                 child: Stack(
              //                                   children: <Widget>[
              //                                     Column(
              //                                       crossAxisAlignment:
              //                                           CrossAxisAlignment
              //                                               .start,
              //                                       mainAxisAlignment:
              //                                           MainAxisAlignment
              //                                               .spaceAround,
              //                                       children: <Widget>[
              //                                         Column(
              //                                           crossAxisAlignment:
              //                                               CrossAxisAlignment
              //                                                   .start,
              //                                           children: <Widget>[
              //                                             Text(
              //                                               '  ${widget.data.coupon[position].couponName.toString()}',
              //                                               style: TextStyle(
              //                                                   fontFamily:
              //                                                       'Poppins Regular',
              //                                                   fontSize: MediaQuery.of(
              //                                                               context)
              //                                                           .size
              //                                                           .height *
              //                                                       0.02,
              //                                                   color: Colors
              //                                                       .black),
              //                                             ),
              //                                             SizedBox(
              //                                               height: 8,
              //                                             ),
              //                                             Text(
              //                                               '  ${widget.data.coupon[position].percentage}% off upto ${widget.data.coupon[position].price} Rupees',
              //                                               // '  Upto ${widget.data.coupon[position].percentage}% off via UPI',
              //                                               style: TextStyle(
              //                                                   fontFamily:
              //                                                       'Poppins Light',
              //                                                   fontSize: MediaQuery.of(
              //                                                               context)
              //                                                           .size
              //                                                           .width *
              //                                                       0.03,
              //                                                   color: Color(Utils
              //                                                       .hexStringToHexInt(
              //                                                           'A4A4A4'))),
              //                                             ),
              //                                           ],
              //                                         ),
              //                                         Row(
              //                                           children: <Widget>[
              //                                             Text(
              //                                               '  Use Code ',
              //                                               style: TextStyle(
              //                                                   fontFamily:
              //                                                       'Poppins Light',
              //                                                   fontSize: MediaQuery.of(
              //                                                               context)
              //                                                           .size
              //                                                           .width *
              //                                                       0.03,
              //                                                   color: Color(Utils
              //                                                       .hexStringToHexInt(
              //                                                           'A4A4A4'))),
              //                                             ),
              //                                             Container(
              //                                               padding: EdgeInsets
              //                                                   .symmetric(
              //                                                       vertical:
              //                                                           2.0,
              //                                                       horizontal:
              //                                                           10.0),
              //                                               color: Color(Utils
              //                                                   .hexStringToHexInt(
              //                                                       '#46D0D9')),
              //                                               child: Text(
              //                                                 '${widget.data.coupon[position].couponCode.toString()}',
              //                                                 style: TextStyle(
              //                                                   fontFamily:
              //                                                       'Poppins Light',
              //                                                   fontSize: MediaQuery.of(
              //                                                               context)
              //                                                           .size
              //                                                           .width *
              //                                                       0.03,
              //                                                   color: Colors
              //                                                       .white,
              //                                                 ),
              //                                               ),
              //                                             )
              //                                           ],
              //                                         )
              //                                       ],
              //                                     ),
              //                                     Align(
              //                                       alignment:
              //                                           Alignment.centerRight,
              //                                       child: IconButton(
              //                                           tooltip:
              //                                               "Applied coupon",
              //                                           onPressed: () {
              //                                             //${int.parse(totalPrice.toString())}
              //                                             var percentPrice = int
              //                                                     .parse(totalPrice
              //                                                         .toString()) *
              //                                                 (1.0 / 100.0) *
              //                                                 int.parse(widget
              //                                                     .data
              //                                                     .coupon[
              //                                                         position]
              //                                                     .percentage
              //                                                     .toString());
              //                                             print(percentPrice
              //                                                     .toString() +
              //                                                 " =======ppp");
              //                                             if (int.parse(widget
              //                                                     .data
              //                                                     .coupon[
              //                                                         position]
              //                                                     .price
              //                                                     .toString()) >
              //                                                 percentPrice) {
              //                                               applycouponPrice =
              //                                                   percentPrice;
              //                                             } else {
              //                                               applycouponPrice =
              //                                                   double.parse(widget
              //                                                       .data
              //                                                       .coupon[
              //                                                           position]
              //                                                       .price
              //                                                       .toString());
              //                                             }
              //                                             coupontype =
              //                                                 "Shop Coupon";
              //                                             print(widget
              //                                                 .data
              //                                                 .coupon[position]
              //                                                 .price
              //                                                 .toString());
              //
              //                                             applycouponcode =
              //                                                 widget
              //                                                     .data
              //                                                     .coupon[
              //                                                         position]
              //                                                     .couponCode
              //                                                     .toString();
              //                                             Navigator.pop(
              //                                                 context);
              //                                           },
              //                                           icon: Icon(
              //                                             CupertinoIcons
              //                                                 .tag_circle,
              //                                             size: width * 0.05,
              //                                             color: Colors.cyan,
              //                                           )),
              //                                     ),
              //                                   ],
              //                                 ));
              //                           }),
              //                     ),
              //                   ],
              //                 ),
              //               );
              //             },
              //           ),
              //         );
              //       },
              //     );
              //   },
              //   child: SizedBox(
              //     width: width,
              //     height: height * 0.07,
              //     child: Material(
              //       color: Color(Utils.hexStringToHexInt('#dbe8e5')),
              //       child: Container(
              //           width: width,
              //           height: height * 0.07,
              //           padding: EdgeInsets.only(
              //               left: width * 0.03, right: width * 0.03),
              //           color: Color(Utils.hexStringToHexInt('#dbe8e5')),
              //           child: Row(
              //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //             children: <Widget>[
              //               Row(
              //                 children: <Widget>[
              //                   SvgPicture.asset(
              //                     'images/svgicons/bigoffer.svg',
              //                     fit: BoxFit.contain,
              //                     width: width * 0.06,
              //                     height: height * 0.04,
              //                   ),
              //                   Text(
              //                     ' Use Coupons',
              //                     style: TextStyle(
              //                         color: Color(
              //                             Utils.hexStringToHexInt('77ACA2')),
              //                         fontFamily: 'Poppins Medium',
              //                         fontSize: width * 0.04),
              //                   )
              //                 ],
              //               ),
              //               Icon(
              //                 Icons.arrow_forward_ios_outlined,
              //                 color: Color(Utils.hexStringToHexInt('77ACA2')),
              //               )
              //             ],
              //           )),
              //     ),
              //   ),
              // ),
              // SizedBox(
              //   height: 10,
              // ),
              InkWell(
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      bool showSublist =
                          false; // Declare your variable outside the builder

                      bool showmainList = true;

                      return AlertDialog(
                        title: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                              'Use coupon',
                              style: TextStyle(
                                fontSize: width * 0.04,
                                color: Colors.black,
                                fontFamily: 'Poppins Medium',
                              ),
                            ),
                            IconButton(
                              onPressed: () => {Navigator.pop(context)},
                              icon: Icon(Icons.cancel_outlined),
                            ),
                          ],
                        ),
                        content: StatefulBuilder(
                          // You need this, notice the parameters below:
                          builder:
                              (BuildContext context, StateSetter setState) {
                            return Container(
                              width: width,
                              height: 250,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Flexible(
                                    child: ListView.builder(
                                        shrinkWrap: true,
                                        itemCount: Get.find<HomeController>()
                                            .adminCouponList
                                            .value
                                            .couponDetail
                                            ?.length,
                                        scrollDirection: Axis.vertical,
                                        itemBuilder: (context, position) {
                                          return Container(
                                              width: width * 0.4 + width * 0.05,
                                              height: height * 0.12,
                                              margin: EdgeInsets.all(6),
                                              decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  borderRadius:
                                                      const BorderRadius.all(
                                                          Radius.circular(8)),
                                                  border: Border.all(
                                                      color: Colors.grey,
                                                      width: 1)),
                                              child: Stack(
                                                children: <Widget>[
                                                  Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceAround,
                                                    children: <Widget>[
                                                      Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: <Widget>[
                                                          Text(
                                                            '  ${Get.find<HomeController>().adminCouponList.value.couponDetail[position].couponName}',
                                                            style: TextStyle(
                                                                fontFamily:
                                                                    'Poppins Regular',
                                                                fontSize: MediaQuery.of(
                                                                            context)
                                                                        .size
                                                                        .height *
                                                                    0.02,
                                                                color: Colors
                                                                    .black),
                                                          ),
                                                          const SizedBox(
                                                            height: 8,
                                                          ),
                                                          Text(
                                                            '  ${Get.find<HomeController>().adminCouponList.value.couponDetail[position].percentage}% off upto ${Get.find<HomeController>().adminCouponList.value.couponDetail[position].price} Rupees',
                                                            //'  Upto ${Get.find<HomeController>().adminCouponList.value.couponDetail[position].couponName}% off via UPI',
                                                            style: TextStyle(
                                                                fontFamily:
                                                                    'Poppins Light',
                                                                fontSize: MediaQuery.of(
                                                                            context)
                                                                        .size
                                                                        .width *
                                                                    0.03,
                                                                color: Color(Utils
                                                                    .hexStringToHexInt(
                                                                        'A4A4A4'))),
                                                          ),
                                                        ],
                                                      ),
                                                      Row(
                                                        children: <Widget>[
                                                          Text(
                                                            '  Use Code ',
                                                            style: TextStyle(
                                                                fontFamily:
                                                                    'Poppins Light',
                                                                fontSize: MediaQuery.of(
                                                                            context)
                                                                        .size
                                                                        .width *
                                                                    0.03,
                                                                color: Color(Utils
                                                                    .hexStringToHexInt(
                                                                        'A4A4A4'))),
                                                          ),
                                                          Container(
                                                            padding:
                                                                const EdgeInsets
                                                                        .symmetric(
                                                                    vertical:
                                                                        2.0,
                                                                    horizontal:
                                                                        10.0),
                                                            color: Color(Utils
                                                                .hexStringToHexInt(
                                                                    '#46D0D9')),
                                                            child: Text(
                                                              '${Get.find<HomeController>().adminCouponList.value.couponDetail[position].couponCode}',
                                                              style: TextStyle(
                                                                fontFamily:
                                                                    'Poppins Light',
                                                                fontSize: MediaQuery.of(
                                                                            context)
                                                                        .size
                                                                        .width *
                                                                    0.03,
                                                                color: Colors
                                                                    .white,
                                                              ),
                                                            ),
                                                          )
                                                        ],
                                                      )
                                                    ],
                                                  ),
                                                  Align(
                                                    alignment:
                                                        Alignment.centerRight,
                                                    child: IconButton(
                                                        tooltip:
                                                            "Applied coupon",
                                                        onPressed: () {
                                                          coupontype =
                                                              "Kolacut Coupon";
                                                          print(Get.find<
                                                                  HomeController>()
                                                              .adminCouponList
                                                              .value
                                                              .couponDetail[
                                                                  position]
                                                              .price
                                                              .toString());
                                                          var percentPrice = int
                                                                  .parse(totalPrice
                                                                      .toString()) *
                                                              (1.0 / 100.0) *
                                                              int.parse(Get.find<
                                                                      HomeController>()
                                                                  .adminCouponList
                                                                  .value
                                                                  .couponDetail[
                                                                      position]
                                                                  .percentage
                                                                  .toString());
                                                          print(percentPrice
                                                                  .toString() +
                                                              " =======ppp");
                                                          if (int.parse(Get.find<
                                                                      HomeController>()
                                                                  .adminCouponList
                                                                  .value
                                                                  .couponDetail[
                                                                      position]
                                                                  .price
                                                                  .toString()) >
                                                              percentPrice) {
                                                            applycouponPrice =
                                                                percentPrice;
                                                          } else {
                                                            applycouponPrice =
                                                                double.parse(Get
                                                                        .find<
                                                                            HomeController>()
                                                                    .adminCouponList
                                                                    .value
                                                                    .couponDetail[
                                                                        position]
                                                                    .price
                                                                    .toString());
                                                          }
                                                          // applycouponPrice = double
                                                          //     .parse(Get.find<
                                                          //             HomeController>()
                                                          //         .adminCouponList
                                                          //         .value
                                                          //         .couponDetail[
                                                          //             position]
                                                          //         .price
                                                          //         .toString());
                                                          applycouponcode = Get
                                                                  .find<
                                                                      HomeController>()
                                                              .adminCouponList
                                                              .value
                                                              .couponDetail[
                                                                  position]
                                                              .couponCode
                                                              .toString();
                                                          Navigator.pop(
                                                              context);
                                                        },
                                                        icon: Icon(
                                                          CupertinoIcons
                                                              .tag_circle,
                                                          size: width * 0.05,
                                                          color: Colors.cyan,
                                                        )),
                                                  ),
                                                ],
                                              ));
                                        }),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      );
                    },
                  );
                },
                child: SizedBox(
                  width: width,
                  height: height * 0.07,
                  child: Material(
                    color: Color(Utils.hexStringToHexInt('#dbe8e5')),
                    child: Container(
                        width: width,
                        height: height * 0.07,
                        padding: EdgeInsets.only(
                            left: width * 0.03, right: width * 0.03),
                        color: Color(Utils.hexStringToHexInt('#dbe8e5')),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                SvgPicture.asset(
                                  'images/svgicons/bigoffer.svg',
                                  fit: BoxFit.contain,
                                  width: width * 0.06,
                                  height: height * 0.04,
                                ),
                                Text(
                                  ' Use Coupons',
                                  style: TextStyle(
                                      color: Color(
                                          Utils.hexStringToHexInt('77ACA2')),
                                      fontFamily: 'Poppins Medium',
                                      fontSize: width * 0.04),
                                )
                              ],
                            ),
                            Icon(
                              Icons.arrow_forward_ios_outlined,
                              color: Color(Utils.hexStringToHexInt('77ACA2')),
                            )
                          ],
                        )),
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              InkWell(
                onTap: () {
                  var Totalcoin = Get.find<HomeController>().coin * 0.10;
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      var valueName = "";
                      var valuePrice = "";
                      return AlertDialog(
                        title: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                              'Use coin',
                              style: TextStyle(
                                fontSize: width * 0.04,
                                color: Colors.black,
                                fontFamily: 'Poppins Medium',
                              ),
                            ),
                            IconButton(
                              onPressed: () => Navigator.pop(context),
                              icon: Icon(Icons.cancel_outlined),
                            ),
                          ],
                        ),
                        content: Container(
                          width: 200,
                          height: height * 0.3,
                          child: SingleChildScrollView(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  'You have ${Get.find<HomeController>().coin} coins',
                                  style: TextStyle(
                                    fontSize: width * 0.03,
                                    color: Color(
                                        Utils.hexStringToHexInt('77ACA2')),
                                    fontFamily: 'Poppins Medium',
                                  ),
                                ),
                                // Text(
                                //   'You can only use 5% of your total coin ${Get.find<HomeController>().coin * 0.05}',
                                //   style: TextStyle(
                                //     fontSize: 8.0,
                                //     color: Color(
                                //         Utils.hexStringToHexInt('77ACA2')),
                                //     fontFamily: 'Poppins Medium',
                                //   ),
                                // ),
                                Text(
                                  ' ${Get.find<HomeController>().coin > 100 ? 100 : 00} coin applied  .',
                                  style: TextStyle(
                                    fontSize: 8.0,
                                    color: Color(
                                        Utils.hexStringToHexInt('77ACA2')),
                                    fontFamily: 'Poppins Medium',
                                  ),
                                ),
                                SizedBox(
                                  height: height * 0.03,
                                ),

                                // SizedBox(
                                //   width: width,
                                //   height: height * 0.1,
                                //   child: TextField(
                                //     textCapitalization:
                                //     TextCapitalization.sentences,
                                //     onChanged: (value) {
                                //       setState(() {
                                //         var Totalcoin =
                                //             Get.find<HomeController>().coin *
                                //                 0.05;
                                //         valueName = value;
                                //         if (int.parse(value) > Totalcoin) {
                                //           print("SDFDFDFDF ${value}");
                                //           CommonDialog.showsnackbar(
                                //               "You can not use coin more then ${Totalcoin}");
                                //         } else {
                                //           print(value);
                                //           applycoin = double.parse(value);
                                //         }
                                //       });
                                //     },
                                //     keyboardType: TextInputType.number,
                                //     controller: _textFieldcoin,
                                //     decoration: const InputDecoration(
                                //         border: OutlineInputBorder(),
                                //         hintText: "Enter coin here.."),
                                //   ),
                                // ),

                                AnimatedBuilder(
                                    animation: ezAnimation,
                                    builder: (context, snapshot) {
                                      return Center(
                                        child: Container(
                                          width: width * 0.3,
                                          height: height * 0.1,
                                          child: Image.asset(
                                            "images/svgicons/coin.png",
                                            fit: BoxFit.fill,
                                          ),
                                        ),
                                      );
                                    }),

                                SizedBox(
                                  height: 6,
                                ),

                                Center(
                                  child: FlatButton(
                                    color: Color(
                                        Utils.hexStringToHexInt('77ACA2')),
                                    textColor: Colors.white,
                                    child: Text('Use coin'),
                                    onPressed: () async {
                                      setState(() {
                                        if (Get.find<HomeController>().coin >
                                            100) {
                                          // applycoin = Get.find<HomeController>().coin - 100;
                                          applycoin = 10;
                                        } else {
                                          CommonDialog.showsnackbar(
                                              "Need minimum 100 coin for use");
                                        }
                                        // applycoin = double.parse(
                                        //     "${Get.find<HomeController>().coin * 0.10}");
                                      });
                                      Navigator.pop(context);
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        actions: <Widget>[],
                      );
                    },
                  );
                },
                child: SizedBox(
                  width: width,
                  height: height * 0.07,
                  child: Material(
                    color: Color(Utils.hexStringToHexInt('#dbe8e5')),
                    child: Container(
                        width: width,
                        height: height * 0.07,
                        padding: EdgeInsets.only(
                            left: width * 0.03, right: width * 0.03),
                        color: Color(Utils.hexStringToHexInt('#dbe8e5')),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                SvgPicture.asset(
                                  'images/svgicons/bigoffer.svg',
                                  fit: BoxFit.contain,
                                  width: width * 0.06,
                                  height: height * 0.04,
                                ),
                                Text(
                                  ' Use Coin',
                                  style: TextStyle(
                                      color: Color(
                                          Utils.hexStringToHexInt('77ACA2')),
                                      fontFamily: 'Poppins Medium',
                                      fontSize: width * 0.04),
                                )
                              ],
                            ),
                            Icon(
                              Icons.arrow_forward_ios_outlined,
                              color: Color(Utils.hexStringToHexInt('77ACA2')),
                            )
                          ],
                        )),
                  ),
                ),
              ),
              SizedBox(
                height: height * 0.02,
              ),
              SizedBox(
                height: height * 0.02,
              ),
              Material(
                color: Colors.white,
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(left: 12.0, right: 12.0),
                      child: Column(
                        children: <Widget>[
                          Container(
                            margin: EdgeInsets.only(right: width * 0.03),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Row(
                                  children: <Widget>[
                                    Container(
                                      margin:
                                          EdgeInsets.only(left: width * 0.03),
                                      child: Text('Services total',
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: width * 0.05,
                                              fontFamily: 'Poppins Regular')),
                                    )
                                  ],
                                ),
                                Container(
                                  margin: EdgeInsets.only(right: width * 0.03),
                                  child: Text('Rs. ${totalPrice.toString()}',
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: width * 0.05,
                                          fontFamily: 'Poppins Regular')),
                                )
                              ],
                            ),
                          ),
                          Container(
                            margin:
                                EdgeInsets.only(right: width * 0.03, top: 6.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Row(
                                  children: <Widget>[
                                    Container(
                                      margin:
                                          EdgeInsets.only(left: width * 0.03),
                                      child: Text('Taxes & Charges',
                                          style: TextStyle(
                                              color: Color(
                                                  Utils.hexStringToHexInt(
                                                      '5E5E5E')),
                                              fontSize: width * 0.03,
                                              fontFamily: 'Poppins Regular')),
                                    ),
                                    Icon(
                                      Icons.arrow_drop_down_sharp,
                                      size: width * 0.06,
                                    )
                                  ],
                                ),
                                Container(
                                  margin: EdgeInsets.only(right: width * 0.03),
                                  child: Text('Rs. 0.0',
                                      style: TextStyle(
                                          color: Color(Utils.hexStringToHexInt(
                                              '5E5E5E')),
                                          fontSize: width * 0.04,
                                          fontFamily: 'Poppins Regular')),
                                )
                              ],
                            ),
                          ),
                          Container(
                            margin:
                                EdgeInsets.only(right: width * 0.03, top: 10.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Row(
                                  children: <Widget>[
                                    Container(
                                      margin:
                                          EdgeInsets.only(left: width * 0.03),
                                      child: Text('Coupon Discount',
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: width * 0.05,
                                              fontFamily: 'Poppins Regular')),
                                    )
                                  ],
                                ),
                                Container(
                                  margin: EdgeInsets.only(right: width * 0.03),
                                  child: Text(
                                      applycouponPrice != 0.0
                                          ? "-" + "${applycouponPrice}"
                                          : "N/A",
                                      style: TextStyle(
                                          color: Color(Utils.hexStringToHexInt(
                                              '5E5E5E')),
                                          fontSize: width * 0.04,
                                          fontFamily: 'Poppins Regular')),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            margin:
                                EdgeInsets.only(right: width * 0.03, top: 10.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Row(
                                  children: <Widget>[
                                    Container(
                                      margin:
                                          EdgeInsets.only(left: width * 0.03),
                                      child: Text('Coin Applied',
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: width * 0.05,
                                              fontFamily: 'Poppins Regular')),
                                    )
                                  ],
                                ),
                                Container(
                                  margin: EdgeInsets.only(right: width * 0.03),
                                  child: Text(
                                      applycoin != 0
                                          ? "-" + "${applycoin}"
                                          : "N/A",
                                      style: TextStyle(
                                          color: Color(Utils.hexStringToHexInt(
                                              '5E5E5E')),
                                          fontSize: width * 0.04,
                                          fontFamily: 'Poppins Regular')),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Divider(
                      color: Color(Utils.hexStringToHexInt('5E5E5E')),
                      thickness: 0.5,
                    ),
                    SizedBox(
                      height: height * 0.02,
                    ),
                    Container(
                        width: width,
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
                                print(resultList.join(","));

                                salonControlller.addTocart(
                                    context,
                                    widget.data.id.toString(),
                                    resultList.join(","),
                                    "");
                              },
                              child: Container(
                                width: width - width * 0.2,
                                padding: EdgeInsets.all(20),
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
                                        'Add to cart',
                                        style: TextStyle(
                                            color: Color(
                                                Utils.hexStringToHexInt(
                                                    '77ACA2')),
                                            fontFamily: 'Poppins Regular',
                                            fontSize: width * 0.03),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        )),
                    Card(
                      elevation: 12,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      child: Container(
                        width: width,
                        height: height * 0.1,
                        margin: EdgeInsets.only(bottom: 10.0),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius:
                                BorderRadius.all(Radius.circular(18))),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Text(
                                  ' Bill Total',
                                  style: TextStyle(
                                      color: Color(
                                          Utils.hexStringToHexInt('A3A2A2')),
                                      fontSize: width * 0.04,
                                      fontFamily: 'Poppins Regular'),
                                ),
                                /*TODO--${int.parse(totalPrice.toString()) - (applycouponPrice + applycoin)}*/
                                Text(
                                  " ₹${int.parse(totalPrice.toString()) - (applycouponPrice + applycoin)}",
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: width * 0.05,
                                      fontFamily: 'Poppins Medium'),
                                )
                              ],
                            ),
                            Row(
                              children: <Widget>[
                                GestureDetector(
                                  onTap: () {
                                    /*TODO---- offline payment (no coupon allied no coin applied)*/
                                    bookService(context);

                                    // Future.delayed(
                                    //     const Duration(milliseconds: 2000), () {
                                    //   setState(() {
                                    //     if (salonControlller.sendData() ==
                                    //         "Booking added successfully") {
                                    //       bookingController
                                    //           .getBookingList1(context);
                                    //       // Navigator.pushReplacement(
                                    //       //   context,
                                    //       //   MaterialPageRoute(
                                    //       //       builder: (context) =>
                                    //       //           TableBasicsExample()),
                                    //       // );
                                    //
                                    //       Navigator.of(context)
                                    //           .pushAndRemoveUntil(
                                    //               MaterialPageRoute(
                                    //                   builder: (context) =>
                                    //                       HomePage()),
                                    //               (Route<dynamic> route) =>
                                    //                   false);
                                    //     }
                                    //   });
                                    // });
                                  },
                                  child: Container(
                                    width: width * 0.3,
                                    height: height * 0.08,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(12)),
                                        border: Border.all(
                                            color: Color(
                                                Utils.hexStringToHexInt(
                                                    '77ACA2')),
                                            width: 2)),
                                    child: Center(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: <Widget>[
                                          Text(
                                            'Pay Later',
                                            style: TextStyle(
                                                color: Color(
                                                    Utils.hexStringToHexInt(
                                                        '77ACA2')),
                                                fontFamily: 'Poppins Regular',
                                                fontSize: width * 0.03),
                                          ),
                                          Text(
                                            'No Discount',
                                            style: TextStyle(
                                                color: Color(
                                                    Utils.hexStringToHexInt(
                                                        '77ACA2')),
                                                fontFamily: 'Poppins Regular',
                                                fontSize: width * 0.02),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  width: 6,
                                ),
                                /*TODO---pass from here*/

                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      var description = "";
                                      widget.newarray.forEach((element) {
                                        description = description +
                                            "," +
                                            "${element.name.toString() + " " + element.price.toString()}";
                                        print(description);
                                      });
                                      // bookServiceOnline(context,"898899887", applycoin,
                                      //     applycouponcode);
                                      // Future.delayed(
                                      //     const Duration(milliseconds: 2000),
                                      //     () {
                                      //   setState(() {
                                      //     if (salonControlller.sendData() ==
                                      //         "Booking added successfully") {
                                      //       bookingController
                                      //           .getBookingList1(context);
                                      //       // Navigator.pushReplacement(
                                      //       //   context,
                                      //       //   MaterialPageRoute(
                                      //       //       builder: (context) =>
                                      //       //           TableBasicsExample()),
                                      //       // );
                                      //
                                      //       Navigator.of(context)
                                      //           .pushAndRemoveUntil(
                                      //               MaterialPageRoute(
                                      //                   builder: (context) =>
                                      //                       HomePage()),
                                      //               (Route<dynamic> route) =>
                                      //                   false);
                                      //     }
                                      //   });
                                      // });
//applycouponPrice + applycoin
                                      // var newPrice=double.parse(totalPrice.toString())-(applycouponPrice + applycoin);
                                      openCheckout(
                                        widget.data.name.toString(),
                                        description,
                                      );
                                    });
                                  },
                                  child: Container(
                                    width: width * 0.3,
                                    height: height * 0.08,
                                    margin: EdgeInsets.only(right: 5.0),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(12)),
                                        color: Color(
                                            Utils.hexStringToHexInt('77ACA2'))),
                                    child: Center(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: <Widget>[
                                          Text(
                                            'Pay now',
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontFamily: 'Poppins Regular',
                                                fontSize: width * 0.03),
                                          ),
                                          Text(
                                            'Save ₹ ${applycouponPrice + applycoin}',
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontFamily: 'Poppins Regular',
                                                fontSize: width * 0.02),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10.0,
                    )
                  ],
                ),
              )
            ],
          ),
        ],
      ),
    ));
  }
}
