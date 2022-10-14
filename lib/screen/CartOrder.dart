import 'package:ezanimation/ezanimation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:untitled/model/CartListPojo.dart';
import 'package:date_picker_timeline/date_picker_timeline.dart';
import 'package:untitled/utils/CommomDialog.dart';

import '../controller/BookingController.dart';
import '../controller/home_controller.dart';
import '../controller/shopdetain_controller.dart';
import '../model/SlotPojo.dart';
import '../utils/Utils.dart';
import '../utils/appconstant.dart';
import 'coin.dart';
import 'homepage.dart';
import 'package:http/http.dart' as http;

class CartOrder extends StatefulWidget {
  SlotDetail? slotDetail;

  //const CartOrder(SlotDetail slotDetail, {Key? key}) : super(key: key);
  CartOrder(SlotDetail slotDetail) {
    this.slotDetail = slotDetail;
  }

  @override
  State<CartOrder> createState() => _CartOrderState(slotDetail!);
}

class _CartOrderState extends State<CartOrder> {
  _CartOrderState(SlotDetail slotDetail);

  EzAnimation ezAnimation = EzAnimation(50.0, 200.0, Duration(seconds: 5));
  BookingController bookingController = Get.put(BookingController());

  TextEditingController _textFieldcoin = TextEditingController();
  late Razorpay _razorpay;
  ShopDetailController salonControlller = Get.put(ShopDetailController());
  List resultList = [];
  var slotSelected = "";
  var timeSelected = "";
  var selectDate = "";
  var selectDay = "";
  var total_price = 0;
  var slotpojo = SlotPojo();
  int isSlotSelected = 1;

  List priceList = [];
  late SharedPreferences sharedPreferences;
  var coin = 0;
  var applycoin = 0.0;
  var applycouponPrice = 0.0;
  var applycouponCode = "";
  var serviceTime = 0;
  var coupontype = "";

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
      print(sharedPreferences.getString("session"));
      // WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      //   Get.find<HomeController>().getCoin(_testValue);
      // });
    });
    print("COIN IS ${Get.find<HomeController>().coin}");
    coin = Get.find<HomeController>().coin;
    widget.slotDetail?.service!.forEach((element) {
      serviceTime += int.parse(element.time!);
      //totalPrice = totalPrice + int.parse(element.price.toString());
      total_price += int.parse(element.price.toString());
      //  print(element.name.toString() + "  " + element.price.toString());
      resultList.add(element.id);
    });
    Future.delayed(const Duration(milliseconds: 800), () {
      getSlot(serviceTime);
    });
  }

  _isSelectedSlot(int index) {
    //pass the selected index to here and set to 'isSelected'
    setState(() {
      print("CHUSDFSD");
      isSlotSelected = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    //  print("COIN IS ${HomeController().coinPojo.value.coin}");
    return SafeArea(
        child: Scaffold(
      resizeToAvoidBottomInset: false,
      //  backgroundColor: Colors.white,
      body: ListView(
        shrinkWrap: true,
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(left: 12.0, right: 12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(
                      height: height * 0.02,
                    ),
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
                              '${widget.slotDetail!.shopName.toString()}',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: width * 0.04,
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
                            width: 24,
                            height: 24,
                            child: SvgPicture.asset(
                              "images/svgicons/mappin.svg",
                            ),
                          ),
                          Text(' ${widget.slotDetail!.userName}',
                              style: TextStyle(
                                  fontSize: width * 0.03,
                                  fontFamily: 'Poppins Regular',
                                  color: Color(
                                      Utils.hexStringToHexInt('#77ACA2'))),
                              textAlign: TextAlign.center),
                        ],
                      ),
                    ),
                    //////
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        DatePicker(
                          DateTime.now(),
                          height: 100,
                          daysCount: 30,
                          initialSelectedDate: DateTime.now(),
                          selectionColor:
                              Color(Utils.hexStringToHexInt('77ACA2')),
                          selectedTextColor: Colors.black,
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
                    SizedBox(
                      height: 6,
                    ),
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
                    slotpojo != null
                        ? SizedBox(
                            width: width,
                            height: 40,
                            child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                shrinkWrap: true,
                                itemCount:
                                    slotpojo.notificationDetail?[0] != null
                                        ? slotpojo.notificationDetail![0]
                                            .morning!.length
                                        : 0,
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
                                              color: Color(
                                                  Utils.hexStringToHexInt(
                                                      '#8D8D8D')),
                                              width: 1)),
                                      child: Center(
                                        child: Text(
                                          '${slotpojo.notificationDetail![0].morning![position]}',
                                          style: TextStyle(
                                            fontSize: width * 0.03,
                                            color: slotSelected == "Morning" &&
                                                    isSlotSelected == position
                                                ? Colors.white
                                                : Colors.black,
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                }),
                          )
                        : SizedBox(),
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

                    slotpojo != null
                        ? SizedBox(
                            width: width,
                            height: 40,
                            child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                shrinkWrap: true,
                                itemCount:
                                    slotpojo.notificationDetail?[0] != null
                                        ? slotpojo.notificationDetail![0]
                                            .afternoon!.length
                                        : 0,
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
                                              color: Color(
                                                  Utils.hexStringToHexInt(
                                                      '#8D8D8D')),
                                              width: 1)),
                                      child: Center(
                                        child: Text(
                                          '${slotpojo.notificationDetail![0].afternoon![position]}',
                                          style: TextStyle(
                                            fontSize: width * 0.03,
                                            color: slotSelected ==
                                                        "Afternoon" &&
                                                    isSlotSelected == position
                                                ? Colors.white
                                                : Colors.black,
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                }),
                          )
                        : SizedBox(),
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

                    slotpojo != null
                        ? SizedBox(
                            width: width,
                            height: 40,
                            child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                shrinkWrap: true,
                                itemCount:
                                    slotpojo.notificationDetail?[0] != null
                                        ? slotpojo.notificationDetail![0]
                                            .evening!.length
                                        : 0,
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
                                              color: Color(
                                                  Utils.hexStringToHexInt(
                                                      '#8D8D8D')),
                                              width: 1)),
                                      child: Center(
                                        child: Text(
                                          '${slotpojo.notificationDetail![0].evening![position]}',
                                          style: TextStyle(
                                            fontSize: width * 0.03,
                                            color: slotSelected == "Evening" &&
                                                    isSlotSelected == position
                                                ? Colors.white
                                                : Colors.black,
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                }),
                          )
                        : SizedBox(),
                    ///////
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
                    SizedBox(height: height * 0.02),
                    Material(
                      elevation: 0,
                      color: Colors.white,
                      child: Column(
                        children: <Widget>[
                          SizedBox(
                            height: height * 0.02,
                          ),
                          SizedBox(
                            width: width,
                            child: ListView.builder(
                                physics: const NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: widget.slotDetail!.service!.length,
                                itemBuilder: (context, position) {
                                  return Container(
                                    margin: EdgeInsets.only(
                                        right: width * 0.03,
                                        bottom: 3.0,
                                        top: 3.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        Row(
                                          children: <Widget>[
                                            Container(
                                              width: width * 0.08,
                                              height: height * 0.04,
                                              child: SvgPicture.asset(
                                                "images/svgicons/checktick.svg",
                                              ),
                                            ),
                                            Container(
                                              margin: EdgeInsets.only(
                                                  left: width * 0.03),
                                              child: Text(
                                                  '${widget.slotDetail!.service![position].name}',
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: width * 0.04,
                                                      fontFamily:
                                                          'Poppins Regular')),
                                            )
                                          ],
                                        ),
                                        Container(
                                          margin: EdgeInsets.only(
                                              right: width * 0.03),
                                          child: Text(
                                              'Rs. ${widget.slotDetail!.service![position].price}',
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: width * 0.03,
                                                  fontFamily:
                                                      'Poppins Regular')),
                                        )
                                      ],
                                    ),
                                  );
                                }),
                          ),
                          // SizedBox(
                          //   height: height * 0.05,
                          // ),
                          // Row(
                          //   mainAxisAlignment: MainAxisAlignment.start,
                          //   children: [
                          //     SvgPicture.asset(
                          //       'images/svgicons/addmoreservices.svg',
                          //       width: width * 0.01,
                          //       height: height * 0.02,
                          //     ),
                          //   ],
                          // ),
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
                                  ListView.builder(
                                      shrinkWrap: true,
                                      itemCount:
                                          widget.slotDetail!.coupon!.length,
                                      scrollDirection: Axis.vertical,
                                      itemBuilder: (context, position) {
                                        return Container(
                                            width: width * 0.4 + width * 0.05,
                                            height: height * 0.12,
                                            margin: EdgeInsets.all(6),
                                            decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(8)),
                                                border: Border.all(
                                                    color: Colors.grey,
                                                    width: 1)),
                                            child: Stack(
                                              children: <Widget>[
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
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
                                                          '  ${widget.slotDetail!.coupon![position].couponName.toString()}',
                                                          style: TextStyle(
                                                              fontFamily:
                                                                  'Poppins Regular',
                                                              fontSize: MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .height *
                                                                  0.02,
                                                              color:
                                                                  Colors.black),
                                                        ),
                                                        SizedBox(
                                                          height: 8,
                                                        ),
                                                        Text(
                                                          '  Upto ${widget.slotDetail!.coupon![position].percentage}% off via UPI',
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
                                                          padding: EdgeInsets
                                                              .symmetric(
                                                                  vertical: 2.0,
                                                                  horizontal:
                                                                      10.0),
                                                          color: Color(Utils
                                                              .hexStringToHexInt(
                                                                  '#46D0D9')),
                                                          child: Text(
                                                            '${widget.slotDetail!.coupon![position].couponCode.toString()}',
                                                            style: TextStyle(
                                                              fontFamily:
                                                                  'Poppins Light',
                                                              fontSize: MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .width *
                                                                  0.03,
                                                              color:
                                                                  Colors.white,
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
                                                      tooltip: "Applied coupon",
                                                      onPressed: () {
                                                        var percentPrice = int
                                                            .parse(total_price
                                                            .toString()) *
                                                            (1.0 / 100.0) *
                                                            int.parse(widget
                                                                .slotDetail!
                                                                .coupon![
                                                            position]
                                                                .percentage
                                                                .toString());
                                                        print(percentPrice
                                                            .toString() +
                                                            " =======ppp");
                                                        if (int.parse(widget
                                                            .slotDetail!
                                                            .coupon![
                                                        position]
                                                            .price
                                                            .toString()) >
                                                            percentPrice) {
                                                          applycouponPrice =
                                                              percentPrice;
                                                        }
                                                        else {
                                                          applycouponPrice =
                                                              double.parse(widget
                                                                  .slotDetail!
                                                                  .coupon![
                                                              position]
                                                                  .price
                                                                  .toString());
                                                        }
                                                        print(widget
                                                            .slotDetail!
                                                            .coupon![position]
                                                            .price
                                                            .toString());
                                                        coupontype =
                                                            "Shop Coupon";


                                                        applycouponCode =
                                                            applycouponCode =
                                                                widget
                                                                    .slotDetail!
                                                                    .coupon![
                                                                        position]
                                                                    .couponCode
                                                                    .toString();
                                                        double.parse(widget
                                                            .slotDetail!
                                                            .coupon![position]
                                                            .price
                                                            .toString());
                                                        Navigator.pop(context);
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
                        height: height * 0.09,
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
                                                            '  ${Get.find<HomeController>().adminCouponList.value.couponDetail![position].couponName}',
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
                                                            '  Upto ${Get.find<HomeController>().adminCouponList.value.couponDetail![position].couponName}% off via UPI',
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
                                                              '${Get.find<HomeController>().adminCouponList.value.couponDetail![position].couponCode}',
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
                                                              .couponDetail![
                                                          position]
                                                              .price
                                                              .toString());
                                                          var percentPrice = int.parse(total_price.toString()) * (1.0 / 100.0) *
                                                              int.parse(Get.find<HomeController>().adminCouponList.value.couponDetail![position].percentage.toString());
                                                          print(percentPrice
                                                              .toString() +
                                                              " =======ppp");
                                                          if (int.parse(Get.find<
                                                              HomeController>()
                                                              .adminCouponList
                                                              .value
                                                              .couponDetail![
                                                          position]
                                                              .price
                                                              .toString()) >
                                                              percentPrice) {
                                                            applycouponPrice =
                                                                percentPrice;
                                                          } else {
                                                            applycouponPrice =
                                                                double.parse(Get.find<
                                                                    HomeController>()
                                                                    .adminCouponList
                                                                    .value
                                                                    .couponDetail![
                                                                position]
                                                                    .price
                                                                    .toString());
                                                          }
                                                          // applycouponPrice = double
                                                          //     .parse(Get.find<
                                                          //             HomeController>()
                                                          //         .adminCouponList
                                                          //         .value
                                                          //         .couponDetail![
                                                          //             position]
                                                          //         .price
                                                          //         .toString());
                                                          applycouponCode = Get
                                                              .find<
                                                              HomeController>()
                                                              .adminCouponList
                                                              .value
                                                              .couponDetail![
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
                                  ' Use Kolacut Coupons',
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
                                        /*100 coin =10 rupees*/
                                        /*ek baar me only 25% coin use kr skta hai*/

                                        if (Get.find<HomeController>().coin >
                                            100) {
                                          // applycoin = Get.find<HomeController>().coin - 100;
                                          applycoin = 10;
                                        } else {
                                          CommonDialog.showsnackbar(
                                              "Need minimum 100 coin for use");
                                        }
                                        // applycoin = double.parse(
                                        //     "${Get.find<HomeController>().coin * 0.25}");
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
                        height: height * 0.09,
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
                                  //TODO--services ka total price
                                  child: Text('Rs. ${total_price}',
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
                                  //TODO---services ka total price
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
                          SizedBox(
                            height: height * 0.02,
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

                    /*TODO---Add to cart start from here*/
                    //TODO--bookin
                    // Container(
                    //   margin: EdgeInsets.only(right: width * 0.03),
                    //   child: Row(
                    //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //     children: <Widget>[
                    //       Row(
                    //         children: <Widget>[
                    //           Container(
                    //             margin:
                    //                 EdgeInsets.only(left: width * 0.03),
                    //             child: Text('Grand Total',
                    //                 style: TextStyle(
                    //                     color: Colors.black,
                    //                     fontSize: width * 0.05,
                    //                     fontFamily: 'Poppins Medium')),
                    //           )
                    //         ],
                    //       ),
                    //       Container(
                    //         margin: EdgeInsets.only(right: width * 0.03),
                    //         child: Text('Rs. ${totalPrice}',
                    //             style: TextStyle(
                    //                 color: Colors.black,
                    //                 fontSize: width * 0.05,
                    //                 fontFamily: 'Poppins Medium')),
                    //       ),
                    //       ElevatedButton(
                    //           onPressed: () {
                    //             bookService();
                    //           },
                    //           child: Text("Book service"))
                    //     ],
                    //   ),
                    // ),

                    // Container(
                    //     width: width,
                    //     margin: EdgeInsets.only(bottom: 10),
                    //     decoration: BoxDecoration(
                    //         color: Colors.white,
                    //         borderRadius:
                    //         BorderRadius.all(Radius.circular(18))),
                    //     child: Row(
                    //       mainAxisAlignment: MainAxisAlignment.center,
                    //       children: <Widget>[
                    //         GestureDetector(
                    //           onTap: () {
                    //             print(resultList.join(","));
                    //
                    //             // salonControlller.addTocart(
                    //             //     context,
                    //             //     widget.data!.id.toString(),
                    //             //     resultList.join(","));
                    //           },
                    //           child: Container(
                    //             width: width - width * 0.2,
                    //             padding: EdgeInsets.all(10),
                    //             decoration: BoxDecoration(
                    //                 borderRadius: BorderRadius.all(
                    //                     Radius.circular(12)),
                    //                 border: Border.all(
                    //                     color: Color(
                    //                         Utils.hexStringToHexInt(
                    //                             '77ACA2')),
                    //                     width: 2)),
                    //             child: Center(
                    //               child: Column(
                    //                 mainAxisAlignment:
                    //                 MainAxisAlignment.center,
                    //                 children: <Widget>[
                    //                   Text(
                    //                     'Add to cart',
                    //                     style: TextStyle(
                    //                         color: Color(
                    //                             Utils.hexStringToHexInt(
                    //                                 '77ACA2')),
                    //                         fontFamily: 'Poppins Regular',
                    //                         fontSize: width * 0.03),
                    //                   ),
                    //                 ],
                    //               ),
                    //             ),
                    //           ),
                    //         ),
                    //       ],
                    //     )),
                    /*TODO---Add to cart end  here*/
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
                                  'Bill Total',
                                  style: TextStyle(
                                      color: Color(
                                          Utils.hexStringToHexInt('A3A2A2')),
                                      fontSize: width * 0.04,
                                      fontFamily: 'Poppins Regular'),
                                ),
                                //TODO--total price yaha pe change krna hai
/*TODO--${int.parse(total_price.toString()) - (applycouponPrice + applycoin)}*/
                                Text(
                                  " ₹${int.parse(total_price.toString())}",
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
                                      widget.slotDetail!.service!
                                          .forEach((element) {
                                        description = description +
                                            "," +
                                            "${element.name.toString() + " " + element.price.toString()}";
                                        print(description);
                                      });
                                      //TODO--checkout screen

                                      // bookServiceOnline(context,"898899887", applycoin,
                                      //     applycouponCode);

                                      // Future.delayed(
                                      //     const Duration(milliseconds: 2000),
                                      //     () {
                                      //   setState(() {
                                      //     if (salonControlller.sendData() ==
                                      //         "Booking added successfully") {
                                      //       bookingController
                                      //           .getBookingList1(context);
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
                                      openCheckout(
                                        widget.slotDetail!.shopName.toString(),
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
                                            'Save ₹ ${(applycouponPrice + applycoin)}',
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

  Widget chooseyourslot(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Utils().titleText1(' Choose your Slot', context),
        Text(
          '',
          style: TextStyle(
              fontFamily: 'Poppins Regular',
              fontSize: MediaQuery.of(context).size.height * 0.02,
              color: Color(Utils.hexStringToHexInt('#77aca2'))),
        )
      ],
    );
  }

  void getSlot(slottime) async {
    slotSelected = "";
    isSlotSelected = 1;
    Map map = {
      "service_time": slottime.toString(),
    };

    print(map);
    var apiUrl = Uri.parse(AppConstant.BASE_URL + AppConstant.SLOT_TIME);
    print(apiUrl);
    print(map);
    final response = await http.post(
      apiUrl,
      body: map,
    );
    setState(() {
      slotpojo = slotPojoFromJson(response.body);
    });
    print(response.body);
  }

  @override
  void dispose() {
    super.dispose();
    _razorpay.clear();
  }

  void openCheckout(shopname, description) async {
    var newprice =
        double.parse(total_price.toString()) - (applycouponPrice + applycoin);

    var options = {
      'key': 'rzp_test_XyJKvJNHhYN1ax',
      'amount': newprice * 100,
      'name': '${widget.slotDetail!.shopName}',
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
        context, "${response.paymentId}", applycoin, applycouponCode);
    /*Fluttertoast.showToast(
        msg: "SUCCESS: " + response.paymentId!,
        toastLength: Toast.LENGTH_SHORT); */
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    print('Error Response: $response');
    CommonDialog.showsnackbar(
        "ERROR: " + response.code.toString() + " - " + response.message!);
    /* Fluttertoast.showToast(
        msg: "ERROR: " + response.code.toString() + " - " + response.message!,
        toastLength: Toast.LENGTH_SHORT); */
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    print('External SDK Response: $response');
    /* Fluttertoast.showToast(
        msg: "EXTERNAL_WALLET: " + response.walletName!,
        toastLength: Toast.LENGTH_SHORT); */
  }

  void bookService(BuildContext context) {
    if (selectDay == "") {
      CommonDialog.showsnackbar("Please select date");
    } else if (slotSelected == "") {
      CommonDialog.showsnackbar("Please select slot");
    } else {
      salonControlller.bookserVicecart(
          widget.slotDetail!.id.toString(),
          context,
          widget.slotDetail!.shopId.toString(),
          "",
          "3",
          resultList.join(","),
          selectDate,
          slotSelected,
          selectDay,
          timeSelected,
          "$total_price",
          "Offline",
          "",
          0.0,
          "",
          "",
          "");
    }
  }

  void bookServiceOnline(BuildContext context, transactionID, coin, coupon) {
    if (selectDay == "") {
      CommonDialog.showsnackbar("Please select date");
    } else if (slotSelected == "") {
      CommonDialog.showsnackbar("Please select slot");
    } else {
      salonControlller.bookserVicecart(
          widget.slotDetail!.id.toString(),
          context,
          widget.slotDetail!.shopId.toString(),
          widget.slotDetail!.employeeId.toString() + "",
          "3",
          resultList.join(","),
          selectDate,
          slotSelected,
          selectDay,
          timeSelected,
          "${int.parse(total_price.toString()) - (applycouponPrice + applycoin)}",
          "Online",
          transactionID,
          coin,
          coupon + "",
          coupontype + "",
          total_price.toString());
    }
  }
}
