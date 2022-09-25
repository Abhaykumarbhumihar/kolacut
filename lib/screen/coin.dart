import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_circle_chart/flutter_circle_chart.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';
import 'package:untitled/controller/home_controller.dart';
import 'package:untitled/screen/homepage.dart';
import 'package:untitled/utils/Utils.dart';
import 'package:flutter_circular_slider/flutter_circular_slider.dart';
import 'dart:math';
import 'dart:math' as math;
import 'package:slider_button/slider_button.dart';
import 'package:swipebuttonflutter/swipebuttonflutter.dart';
import 'package:flutter_speedometer/flutter_speedometer.dart';
import '../utils/CommomDialog.dart';
import '../utils/appconstant.dart';
import 'login.dart';

class CoinPage extends StatefulWidget {
  const CoinPage({Key? key}) : super(key: key);

  @override
  State<CoinPage> createState() => _CoinPageState();
}

class _CoinPageState extends State<CoinPage> {
  var inBedTime;
  var outBedTime;
  late SharedPreferences sharedPreferences;
  var session;
  final box = GetStorage();

  void _updateLabels(int init, int end, int c) {
    setState(() {
      inBedTime = init;
      outBedTime = end;
      debugPrint(inBedTime);
    });
  }

  Widget controlIndicator() {
    return SleekCircularSlider(
        min: 0,
        max: 100,
        initialValue: 4,
        innerWidget: (value) {
          return Container();
        },
        appearance: CircularSliderAppearance(
            spinnerMode: false,
            animationEnabled: true,
            size: 250,
            customColors: CustomSliderColors(
                shadowColor: Colors.white,
                shadowMaxOpacity: 0.2,
                shadowStep: 5,
                progressBarColor: Colors.cyan,
                trackColor: Colors.grey),
            customWidths: CustomSliderWidths(
                trackWidth: 7, progressBarWidth: 12, handlerSize: 8)),
        onChange: (value) {
          // slider_value = value.round();
          print(value);
        });
  }

  var isLoading=true;
  Future<void> start() async {
    foo();
  }

  void foo() {
    Future.delayed(Duration(seconds: 3), () async {
      // do something here
      isLoading=false;
      // do stuff
    });
  }
  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    start();
    SharedPreferences.getInstance().then((SharedPreferences sp) {
      sharedPreferences = sp;
      var _testValue = sharedPreferences.getString("session");
      setState(() {
        session = _testValue;
      });
      print(sharedPreferences.getString("session"));
      if (_testValue != null) {
        // WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        //   Get.find<HomeController>().getCoin(_testValue);
        // });
      }
    });

    return SafeArea(
        child: Scaffold(
            backgroundColor: Color(Utils.hexStringToHexInt('#fcfcfc')),
            appBar: AppBar(
              backgroundColor: Color(Utils.hexStringToHexInt('#fcfcfc')),
              elevation: 0.0,
              automaticallyImplyLeading: false,
              titleSpacing: 0,
              centerTitle: false,
              leading: GestureDetector(
                onTap: () {
                  Navigator.maybePop(context);
                },
                child: Icon(
                  Icons.arrow_back,
                  color: Colors.black,
                ),
              ),
              title: Text(
                'Your Balance',
                style: TextStyle(
                    color: Colors.black,
                    fontFamily: 'Poppins Medium',
                    fontSize: width * 0.04),
              ),
            ),
            body: session == null
                ? Center(
                    child: Container(
                    width: width,
                    height: height,
                    child: Center(
                        child: Container(
                      child: InkWell(
                        onTap: () {

                          Get.offAll(LoginPage());
                        },
                        child: Container(
                          height: width * 0.2,
                          width: height * 0.3,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12.0),
                            color: Color(Utils.hexStringToHexInt('77ACA2')),
                          ),
                          child: Center(
                            child: Text(
                              "Continue with login",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: width * 0.05,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Poppins Semibold',
                              ),
                            ),
                          ),
                        ),
                      ),
                    )),
                  ))
                : GetBuilder<HomeController>(builder: (homecontroller) {
                    if (homecontroller.lodaer) {
                      return Container();
                    } else {
                      return Container(
                        width: width,
                        color: Color(Utils.hexStringToHexInt('#fcfcfc')),
                        height: height,
                        child: Container(
                          margin: EdgeInsets.only(
                              left: width * 0.03, right: width * 0.03),
                          child: SingleChildScrollView(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                SizedBox(
                                  height: height * 0.02,
                                ),
                                Text(
                                  'Available Balance',
                                  style: TextStyle(
                                      fontFamily: 'Poppins Regular',
                                      fontSize: width * 0.03,
                                      color: Color(
                                          Utils.hexStringToHexInt('C4C4C4'))),
                                ),
                                SizedBox(
                                  height: height * 0.04,
                                ),
                                Row(
                                  children: <Widget>[
                                    Image.asset(
                                      'images/svgicons/coin.png',
                                      width: width * 0.05,
                                      height: height * 0.04,
                                      fit: BoxFit.fill,
                                    ),
                                    Text(
                                      ' ${homecontroller.coinPojo.value.coin}',
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontFamily: 'Poppins Medium',
                                          fontSize: width * 0.05),
                                    ),
                                  ],
                                ),
                                InkWell(
                                  onTap: () {
                                    CommonDialog.showErrorDialog1(
                                        title: "Coins Detail",
                                        description:
                                            "You have earn coin with app refer, you can use only 100 coin at a time.");
                                  },
                                  child: Text(
                                    ' View Details',
                                    style: TextStyle(
                                        fontFamily: 'Poppins Medium',
                                        fontSize: width * 0.03,
                                        color: Color(
                                            Utils.hexStringToHexInt('77ACA2'))),
                                  ),
                                ),
                                isLoading?Container():   Center(
                                  child: Speedometer(
                                    backgroundColor: Colors.white,
                                    size: 250,
                                    minValue: 0,
                                    maxValue: 1000,
                                    currentValue:
                                        homecontroller.coinPojo.value.coin,
                                    warningValue: 150,
                                    displayText: 'Coins',
                                    meterColor: Color(
                                        Utils.hexStringToHexInt('77ACA2')),
                                    warningColor: Color(
                                        Utils.hexStringToHexInt('77ACA2')),
                                    kimColor: Colors.amberAccent,
                                    //                             width: 1)),,
                                    //                             width: 1)),,
                                  ),
                                ),
                                // Center(
                                //   child: SleekCircularSlider(
                                //       min: 0,
                                //       max: 10000,
                                //       innerWidget: (double value) {
                                //         return Center(
                                //           child: Center(
                                //             child: Container(
                                //               width: width * 0.8,
                                //               height: height * 0.3,
                                //               decoration: const BoxDecoration(
                                //                 color: Colors.white,
                                //                 shape: BoxShape.circle,
                                //               ),
                                //               child: Column(
                                //                 crossAxisAlignment:
                                //                     CrossAxisAlignment.center,
                                //                 mainAxisAlignment:
                                //                     MainAxisAlignment.center,
                                //                 children: <Widget>[
                                //                   Text(
                                //                     '₹ ${homecontroller.coinPojo.value.coin}',
                                //                     style: TextStyle(
                                //                         color: Colors.black,
                                //                         fontSize: width * 0.07,
                                //                         fontFamily:
                                //                             'Poppins Medium'),
                                //                   ),
                                //                   Text(
                                //                     '100 coins',
                                //                     style: TextStyle(
                                //                         fontFamily:
                                //                             'Poppins Regular',
                                //                         fontSize: width * 0.04,
                                //                         color: Color(Utils
                                //                             .hexStringToHexInt(
                                //                                 'C4C4C4'))),
                                //                   ),
                                //                   Container(
                                //                     width: width * 0.5,
                                //                     height: 34,
                                //                     margin: EdgeInsets.only(
                                //                         top: height * 0.03),
                                //                     decoration: BoxDecoration(
                                //                         borderRadius:
                                //                             BorderRadius
                                //                                 .circular(12),
                                //                         border: Border.all(
                                //                             color: Color(Utils
                                //                                 .hexStringToHexInt(
                                //                                     '77ACA2')),
                                //                             width: 1)),
                                //                     child: Row(
                                //                       mainAxisAlignment:
                                //                           MainAxisAlignment
                                //                               .spaceEvenly,
                                //                       children: <Widget>[
                                //                         Text(
                                //                           '',
                                //                           style: TextStyle(
                                //                               fontSize:
                                //                                   width * 0.03,
                                //                               fontFamily:
                                //                                   'Poppins Light',
                                //                               color: Color(Utils
                                //                                   .hexStringToHexInt(
                                //                                       '77ACA2'))),
                                //                         ),
                                //                         Text(
                                //                           'Conversion Rate 1%',
                                //                           style: TextStyle(
                                //                               fontSize:
                                //                                   width * 0.02,
                                //                               fontFamily:
                                //                                   'Poppins Light',
                                //                               color: Color(Utils
                                //                                   .hexStringToHexInt(
                                //                                       '77ACA2'))),
                                //                         ),
                                //                         Icon(
                                //                           Icons
                                //                               .arrow_forward_ios,
                                //                           size: width * 0.04,
                                //                         )
                                //                       ],
                                //                     ),
                                //                   )
                                //                 ],
                                //               ),
                                //             ),
                                //           ),
                                //         );
                                //       },
                                //       initialValue: homecontroller
                                //           .coinPojo.value.coin!
                                //           .toDouble(),
                                //       appearance: CircularSliderAppearance(
                                //           size: width * 0.8,
                                //           customColors: CustomSliderColors(
                                //               dotColor: Colors.amber,
                                //               trackColor: Color(
                                //                   Utils.hexStringToHexInt(
                                //                       '#d6dfe9')),
                                //               progressBarColor: Color(
                                //                   Utils.hexStringToHexInt(
                                //                       '77ACA2'))),
                                //           customWidths: CustomSliderWidths(
                                //               progressBarWidth: 10,
                                //               handlerSize: 10,
                                //               trackWidth: 10)),
                                //       onChange: (double value) {
                                //         print(value);
                                //       }),
                                // ),

                                // Center(
                                //   child: Container(
                                //       child: SingleCircularSlider(
                                //     300,
                                //     10,
                                //     width: width * 0.8,
                                //     height: height * 0.5,
                                //     primarySectors: 4,
                                //     secondarySectors: 4,
                                //     showHandlerOutter: true,
                                //     showRoundedCapInSelection: true,
                                //     child: Center(
                                //       child: Container(
                                //         width: width * 0.8,
                                //         height: height * 0.3,
                                //         decoration: const BoxDecoration(
                                //           color: Colors.white,
                                //           shape: BoxShape.circle,
                                //         ),
                                //         child: Column(
                                //           crossAxisAlignment:
                                //               CrossAxisAlignment.center,
                                //           mainAxisAlignment: MainAxisAlignment.center,
                                //           children: <Widget>[
                                //             Text(
                                //               '₹ 100',
                                //               style: TextStyle(
                                //                   color: Colors.black,
                                //                   fontSize: width * 0.07,
                                //                   fontFamily: 'Poppins Medium'),
                                //             ),
                                //             Text(
                                //               '100 coins',
                                //               style: TextStyle(
                                //                   fontFamily: 'Poppins Regular',
                                //                   fontSize: width * 0.04,
                                //                   color: Color(
                                //                       Utils.hexStringToHexInt(
                                //                           'C4C4C4'))),
                                //             ),
                                //             Container(
                                //               width: width * 0.5,
                                //               height: 34,
                                //               margin:
                                //                   EdgeInsets.only(top: height * 0.03),
                                //               decoration: BoxDecoration(
                                //                   borderRadius:
                                //                       BorderRadius.circular(12),
                                //                   border: Border.all(
                                //                       color: Color(
                                //                           Utils.hexStringToHexInt(
                                //                               '77ACA2')),
                                //                       width: 1)),
                                //               child: Row(
                                //                 mainAxisAlignment:
                                //                     MainAxisAlignment.spaceEvenly,
                                //                 children: <Widget>[
                                //                   Text(
                                //                     '',
                                //                     style: TextStyle(
                                //                         fontSize: width * 0.03,
                                //                         fontFamily: 'Poppins Light',
                                //                         color: Color(
                                //                             Utils.hexStringToHexInt(
                                //                                 '77ACA2'))),
                                //                   ),
                                //                   Text(
                                //                     'Conversion Rate 1%',
                                //                     style: TextStyle(
                                //                         fontSize: width * 0.02,
                                //                         fontFamily: 'Poppins Light',
                                //                         color: Color(
                                //                             Utils.hexStringToHexInt(
                                //                                 '77ACA2'))),
                                //                   ),
                                //                   Icon(
                                //                     Icons.arrow_forward_ios,
                                //                     size: width * 0.04,
                                //                   )
                                //                 ],
                                //               ),
                                //             )
                                //           ],
                                //         ),
                                //       ),
                                //     ),
                                //     onSelectionChange: (a, b, c) => {
                                //       setState(() {
                                //         outBedTime = b;
                                //       })
                                //     },
                                //     baseColor:
                                //         Color(Utils.hexStringToHexInt('#d6dfe9')),
                                //     selectionColor:
                                //         Color(Utils.hexStringToHexInt('77ACA2')),
                                //   )),
                                // ),
                                SizedBox(
                                  height: height * 0.03,
                                ),
                                // Center(
                                //     child: SliderButton(
                                //   dismissible: true,
                                //   buttonColor:
                                //       Color(Utils.hexStringToHexInt('77ACA2')),
                                //   backgroundColor:
                                //       Color(Utils.hexStringToHexInt('77ACA2')),
                                //   vibrationFlag: true,
                                //   action: () {
                                //     ///Do something here
                                //     // Navigator.of(context).pop();
                                //   },
                                //   label: Text(
                                //     'Want to earn more coins?',
                                //     textAlign: TextAlign.center,
                                //     style: TextStyle(
                                //         color: Colors.white,
                                //         fontFamily: 'Poppins Medium',
                                //         fontSize: width * 0.03),
                                //   ),
                                //   icon: Container(
                                //     width: 74,
                                //     height: 74,
                                //     margin: EdgeInsets.all(2),
                                //     decoration: const BoxDecoration(
                                //         image: DecorationImage(
                                //             image: AssetImage(
                                //                 'images/svgicons/circleback.png'),
                                //             fit: BoxFit.fill)),
                                //     child: Center(
                                //       child: Icon(
                                //         Icons.arrow_right_alt_outlined,
                                //         color:
                                //             Color(Utils.hexStringToHexInt('77ACA2')),
                                //       ),
                                //     ),
                                //   ),
                                // )),
                                // FlatButton(onPressed: ()async
                                // {
                                //   print("Called back");
                                //   Map map = {
                                //     "session_id": box.read('session'),
                                //   };
                                //   print(map);
                                //   var apiUrl = Uri.parse(
                                //       AppConstant.BASE_URL +
                                //           AppConstant.REFER_TO_FRIEND);
                                //   print(apiUrl);
                                //   print(map);
                                //   final response = await http.post(
                                //     apiUrl,
                                //     body: map,
                                //   );
                                //   print(response.body);
                                //   var data = response.body;
                                //   final body = json.decode(response.body);
                                //   if (body['message'] != "") {
                                //     CommonDialog.showsnackbar(
                                //         body['message'] +
                                //             "your code is \n" +
                                //             body['referel_code']);
                                //     showLoaderDialog(
                                //         context, body['referel_code']);
                                //   }
                                // }, child: Text("Want to earn more coin")),
                                Center(
                                  child: SwipingButton(
                                    height: height * 0.06,
                                    iconColor: Color(
                                        Utils.hexStringToHexInt('77ACA2')),
                                    swipeButtonColor: Colors.white,
                                    backgroundColor: Color(
                                        Utils.hexStringToHexInt('77ACA2')),
                                    buttonTextStyle: TextStyle(
                                        color: Colors.white,
                                        fontFamily: 'Poppins Medium',
                                        fontSize: width * 0.03),
                                    text: "Want to earn more coins?",
                                    onSwipeCallback: () async {
                                      print("Called back");
                                      Map map = {
                                        "session_id": box.read('session'),
                                      };
                                      print(map);
                                      var apiUrl = Uri.parse(
                                          AppConstant.BASE_URL +
                                              AppConstant.REFER_TO_FRIEND);
                                      print(apiUrl);
                                      print(map);
                                      final response = await http.post(
                                        apiUrl,
                                        body: map,
                                      );
                                      print(response.body);
                                      var data = response.body;
                                      final body = json.decode(response.body);
                                      if (body['message'] != "") {
                                        Navigator.pop(context);
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => CoinPage()),
                                        );
                                        showLoaderDialog(
                                            context, body['referel_code']);
                                      }
                                    },
                                  ),
                                ),
                                // Container(
                                //   width: width,
                                //   height: height * 0.06,
                                //   decoration: BoxDecoration(
                                //       color: Color(Utils.hexStringToHexInt('77ACA2')),
                                //       borderRadius:
                                //           BorderRadius.circular(width * 0.07)),
                                //   child: Row(
                                //     crossAxisAlignment: CrossAxisAlignment.center,
                                //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                //     children: <Widget>[
                                //       Container(
                                //         width: 44,
                                //         height: 44,
                                //         margin: EdgeInsets.all(2),
                                //         decoration: const BoxDecoration(
                                //             image: DecorationImage(
                                //                 image: AssetImage(
                                //                     'images/svgicons/circleback.png'),
                                //                 fit: BoxFit.fill)),
                                //         child: Center(
                                //           child: Icon(
                                //             Icons.arrow_right_alt_outlined,
                                //             color: Color(
                                //                 Utils.hexStringToHexInt('77ACA2')),
                                //           ),
                                //         ),
                                //       ),
                                //       Text(
                                //         'Swipe to Add Money',
                                //         textAlign: TextAlign.center,
                                //         style: TextStyle(
                                //             color: Colors.white,
                                //             fontFamily: 'Poppins Medium',
                                //             fontSize: width * 0.03),
                                //       ),
                                //       Text(
                                //         '',
                                //         style: TextStyle(
                                //             color: Colors.white,
                                //             fontFamily: 'Poppins Medium',
                                //             fontSize: width * 0.04),
                                //       )
                                //     ],
                                //   ),
                                // ),
                                SizedBox(
                                  height: height * 0.02,
                                ),
                                // Center(
                                //   child: Text(
                                //     'Want to earn more coins?',
                                //     style: TextStyle(
                                //         fontFamily: 'Poppins Regular',
                                //         fontSize: width * 0.03,
                                //         color: Color(
                                //             Utils.hexStringToHexInt('77ACA2'))),
                                //   ),
                                // )
                              ],
                            ),
                          ),
                        ),
                      );
                    }
                  })));
  }

  showLoaderDialog1(BuildContext context, code) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;

    AlertDialog alert = AlertDialog(
      contentPadding: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30),
      ),
      content: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height * 0.5 - height * 0.05,
        decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: Colors.grey, width: 2),
            borderRadius: BorderRadius.circular(
                MediaQuery.of(context).size.width * 0.04)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Column(
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    GestureDetector(
                      onTap: () {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (BuildContext context) => HomePage()));
                      },
                      child: Container(
                        margin: EdgeInsets.all(width * 0.06),
                        child: SvgPicture.asset(
                            'images/svgicons/eva_close-circle-fill.svg'),
                      ),
                    )
                  ],
                ),
                Container(
                  margin: EdgeInsets.only(bottom: width * 0.03),
                  child: Center(
                    child: Text(
                      'Refer and Earn.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Colors.black,
                          fontFamily: 'Poppins Medium',
                          fontSize: MediaQuery.of(context).size.width * 0.04),
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(bottom: width * 0.01),
                  child: Text(
                    'Invite your firends using your referral\ncode givn below and earn more\ncoins',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Colors.black,
                        fontFamily: 'Poppins Regular',
                        fontSize: MediaQuery.of(context).size.width * 0.03),
                  ),
                ),
                Center(
                  child: Container(
                    width: width,
                    height: height * 0.1,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          width: width - width * 0.5,
                          height: 38,
                          decoration: BoxDecoration(
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(12),
                              bottomLeft: Radius.circular(12.0),
                            ),
                            border: Border.all(
                              color: Color(Utils.hexStringToHexInt('77ACA2')),

                              //                   <--- border color
                              width: 1.0,
                            ),
                          ),
                          child: Center(
                            child: Text(
                              "$code",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontFamily: 'Poppins Medium'),
                            ),
                          ),
                        ),
                        Container(
                          width: 78,
                          height: 38,
                          decoration: BoxDecoration(
                            color: Color(Utils.hexStringToHexInt('77ACA2')),
                            borderRadius: BorderRadius.only(
                              topRight: Radius.circular(12),
                              bottomRight: Radius.circular(12.0),
                            ),
                            border: Border.all(
                              color: Color(Utils.hexStringToHexInt('77ACA2')),

                              //                   <--- border color
                              width: 1.0,
                            ),
                          ),
                          child: Center(
                            child: InkWell(
                              onTap: () {
                                Clipboard.setData(ClipboardData(text: "$code"));
                              },
                              child: Text(
                                "COPY",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontFamily: 'Poppins Medium'),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(left: 12, right: 12),
                  child: Padding(
                    padding: EdgeInsets.all(4.0),
                    child: Row(
                      children: const [
                        Expanded(
                          child: Divider(
                            color: Colors.black,
                            thickness: 1,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text('OR'),
                        ),
                        Expanded(
                          child: Divider(
                            color: Colors.black,
                            thickness: 1,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Center(
                  child: IconButton(
                    iconSize: 34,
                    icon: Icon(
                      Icons.share,
                      color: Color(Utils.hexStringToHexInt('77ACA2')),
                    ),
                    // the method which is called
                    // when button is pressed
                    onPressed: () {
                      // Navigator.pop(context);
                      Share.share('Intall this app and get benifits $code',
                          subject: 'Kolacut!');
                    },
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  showLoaderDialog(BuildContext context, code) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return WillPopScope(
          onWillPop: () async => false,
          child: AlertDialog(
            contentPadding: EdgeInsets.zero,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
            content: Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height * 0.5 - height * 0.05,
              decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Colors.grey, width: 2),
                  borderRadius: BorderRadius.circular(
                      MediaQuery.of(context).size.width * 0.04)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                              // Navigator.pushReplacement(
                              //     context,
                              //     MaterialPageRoute(
                              //         builder: (BuildContext context) => HomePage()));
                            },
                            child: Container(
                              margin: EdgeInsets.all(width * 0.06),
                              child: SvgPicture.asset(
                                  'images/svgicons/eva_close-circle-fill.svg'),
                            ),
                          )
                        ],
                      ),
                      Container(
                        margin: EdgeInsets.only(bottom: width * 0.03),
                        child: Center(
                          child: Text(
                            'Refer and Earn.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Colors.black,
                                fontFamily: 'Poppins Medium',
                                fontSize:
                                    MediaQuery.of(context).size.width * 0.04),
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(bottom: width * 0.01),
                        child: Text(
                          'Invite your firends using your referral\ncode givn below and earn more\ncoins',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Colors.black,
                              fontFamily: 'Poppins Regular',
                              fontSize:
                                  MediaQuery.of(context).size.width * 0.03),
                        ),
                      ),
                      Center(
                        child: Container(
                          width: width,
                          height: height * 0.1,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Container(
                                width: width - width * 0.5,
                                height: 38,
                                decoration: BoxDecoration(
                                  borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(12),
                                    bottomLeft: Radius.circular(12.0),
                                  ),
                                  border: Border.all(
                                    color: Color(
                                        Utils.hexStringToHexInt('77ACA2')),

                                    //                   <--- border color
                                    width: 1.0,
                                  ),
                                ),
                                child: Center(
                                  child: Text(
                                    "$code",
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontFamily: 'Poppins Medium'),
                                  ),
                                ),
                              ),
                              Container(
                                width: 78,
                                height: 38,
                                decoration: BoxDecoration(
                                  color:
                                      Color(Utils.hexStringToHexInt('77ACA2')),
                                  borderRadius: BorderRadius.only(
                                    topRight: Radius.circular(12),
                                    bottomRight: Radius.circular(12.0),
                                  ),
                                  border: Border.all(
                                    color: Color(
                                        Utils.hexStringToHexInt('77ACA2')),

                                    //                   <--- border color
                                    width: 1.0,
                                  ),
                                ),
                                child: Center(
                                  child: InkWell(
                                    onTap: () {
                                      Clipboard.setData(
                                          ClipboardData(text: "$code"));
                                    },
                                    child: Text(
                                      "COPY",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontFamily: 'Poppins Medium'),
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 12, right: 12),
                        child: Padding(
                          padding: EdgeInsets.all(4.0),
                          child: Row(
                            children: const [
                              Expanded(
                                child: Divider(
                                  color: Colors.black,
                                  thickness: 1,
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Text('OR'),
                              ),
                              Expanded(
                                child: Divider(
                                  color: Colors.black,
                                  thickness: 1,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Center(
                        child: IconButton(
                          iconSize: 34,
                          icon: Icon(
                            Icons.share,
                            color: Color(Utils.hexStringToHexInt('77ACA2')),
                          ),
                          // the method which is called
                          // when button is pressed
                          onPressed: () {
                            // Navigator.pop(context);
                            Share.share(
                                'Intall this app and get benifits $code',
                                subject: 'Kolacut!');
                          },
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
