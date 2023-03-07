import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_circular_slider/flutter_circular_slider.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';
import 'package:untitled/controller/home_controller.dart';
import 'package:untitled/screen/homepage.dart';
import 'package:untitled/utils/Utils.dart';

import 'package:swipebuttonflutter/swipebuttonflutter.dart';
import '../utils/CommomDialog.dart';
import '../utils/appconstant.dart';
import 'login.dart';
import 'sidenavigation.dart';

class CoinPage extends StatefulWidget {
  const CoinPage({Key key}) : super(key: key);

  @override
  State<CoinPage> createState() => _CoinPageState();
}

class _CoinPageState extends State<CoinPage> {
  var inBedTime;
  var outBedTime;
   SharedPreferences sharedPreferences;
  final box = GetStorage();
  var session = "";
  var name = "";
  var email = "";
  var phone = "";
  var iamge = "";
  GlobalKey<ScaffoldState> scaffolKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;

    SharedPreferences.getInstance().then((SharedPreferences sp) {
      sharedPreferences = sp;
      var _testValue = sharedPreferences.getString("session");
      var _testValuess = sharedPreferences.getString("name");
      var emailValue = sharedPreferences.getString("email");
      var _imageValue = sharedPreferences.getString("image");
      var _phoneValue = sharedPreferences.getString("phoneno");
      var _sessss = sharedPreferences.getString("session");
      setState(() {
        session = _testValue;
        if (_sessss != null) {
          session = _sessss;
          name = _testValuess;
          email = emailValue;
          phone = _phoneValue;
          iamge = _imageValue;
        }
        else {
          name = "";
          email = "";
          phone = "";
          iamge = "";
        }
      });
      // print(sharedPreferences.getString("session"));
      if (_testValue != null) {
        // WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        //   Get.find<HomeController>().getCoin(_testValue);
        // });
      }
    });
    return SafeArea(

        child: Scaffold(
            key: scaffolKey,
            drawer: session == null||session==""
                ? Container()
                : SideNavigatinPage(
                "${name}", "${iamge}", "${email}", "${phone}"),
            backgroundColor: Color(Utils.hexStringToHexInt('#fcfcfc')),
            appBar: AppBar(
              backgroundColor: Color(Utils.hexStringToHexInt('77ACA2')),
              elevation: 0.0,
              automaticallyImplyLeading: false,
              titleSpacing: 0,
              centerTitle: false,
              leading: InkWell(
                onTap: () {
                  session != ""
                      ? scaffolKey.currentState.openDrawer()
                      : null;
                },
                child: Icon(
                  Icons.menu,
                  color: Colors.white,
                ),
              ),
              // leading: GestureDetector(
              //   onTap: () {
              //
              //     Navigator.maybePop(context);
              //   },
              //   child: Navigator.canPop(context)?Icon(
              //     Icons.arrow_back,
              //     color: Colors.black,
              //   ):SizedBox(),
              // ),
              title: Text(
                'Your Balance',
                style: TextStyle(
                    color: Colors.white,
                    fontFamily: 'Poppins Medium',
                    fontSize: width * 0.04),
              ),
            ),
            body: session == null || session == ""
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
                                      fontSize: width * 0.04,
                                      color: Color(
                                          Utils.hexStringToHexInt('C4C4C4'))),
                                ),
                                SizedBox(
                                  height: height * 0.02,
                                ),
                                Row(
                                  children: <Widget>[
                                    Image.asset(
                                      'images/svgicons/coin.png',
                                      width: width * 0.05,
                                      height: height * 0.04,
                                      fit: BoxFit.contain,
                                    ),
                                    Text(
                                      ' ${homecontroller.coinPojo.value.coin}',
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontFamily: 'Poppins Medium',
                                          fontSize: width * 0.06),
                                    ),
                                  ],
                                ),
                                InkWell(
                                  onTap: () {
                                    Utils.showErrorDialog1(width, context,
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


                                Center(
                                  child: SizedBox(
                                    width: width*0.7,
                                      child: Center(child: _getRadialGauge(homecontroller.coinPojo.value.coin))),
                                ),





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

                                SizedBox(
                                  height: height * 0.02,
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }
                  })));
  }

  Widget _getRadialGauge(value) {
    return SfRadialGauge(
        title: GaugeTitle(
            text: '',
            textStyle:
                const TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold)),
        axes: <RadialAxis>[
          RadialAxis(minimum: 0, maximum: 1000, ranges: <GaugeRange>[
            GaugeRange(
                startValue: 0,
                endValue: 1000,
                color: Color(Utils.hexStringToHexInt('77ACA2')),
                startWidth: 10,
                endWidth: 10),
            // GaugeRange(
            //     startValue: 50,
            //     endValue: 100,
            //     color: Colors.orange,
            //     startWidth: 10,
            //     endWidth: 10),
            // GaugeRange(
            //     startValue: 100,
            //     endValue: 150,
            //     color: Colors.red,
            //     startWidth: 10,
            //     endWidth: 10)
          ], pointers: <GaugePointer>[
            NeedlePointer(
                value: double.parse(value.toString()),
                needleLength: 0.65,
                enableAnimation: true,
                animationType: AnimationType.slowMiddle,
                needleStartWidth: 1.5,
                needleEndWidth: 8,
                needleColor: Colors.red.shade300,
                knobStyle: KnobStyle(knobRadius: 0.09,borderColor: Colors.red))
          ], annotations: <GaugeAnnotation>[
            GaugeAnnotation(
                widget: Container(
                    child:  Text('${value}',
                        style: TextStyle(
                            fontSize: 25, fontWeight: FontWeight.bold))),
                angle: 90,
                positionFactor: 0.5)
          ])
        ]);
  }

  Widget _getLinearGauge() {
    return Container(
      child: SfLinearGauge(
          minimum: 0.0,
          maximum: 100.0,
          orientation: LinearGaugeOrientation.horizontal,
          majorTickStyle: LinearTickStyle(length: 20),
          axisLabelStyle: TextStyle(fontSize: 12.0, color: Colors.black),
          axisTrackStyle: LinearAxisTrackStyle(
              color: Colors.cyan,
              edgeStyle: LinearEdgeStyle.bothFlat,
              thickness: 15.0,
              borderColor: Colors.grey)),
      margin: EdgeInsets.all(10),
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
                height: height*0.6,
                decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: Colors.grey, width: 2),
                    borderRadius: BorderRadius.circular(
                        MediaQuery.of(context).size.width * 0.04)),
                child: ListView(
                  children: <Widget>[
                    Column(
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
                                          MediaQuery.of(context).size.width *
                                              0.04),
                                ),
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(bottom: width * 0.01),
                              child: Text(
                                'Invite your friends using your referral\ncode givn below and earn more\ncoins',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: Colors.black,
                                    fontFamily: 'Poppins Regular',
                                    fontSize:
                                        MediaQuery.of(context).size.width *
                                            0.03),
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
                                          color: Color(Utils.hexStringToHexInt(
                                              '77ACA2')),

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
                                        color: Color(
                                            Utils.hexStringToHexInt('77ACA2')),
                                        borderRadius: BorderRadius.only(
                                          topRight: Radius.circular(12),
                                          bottomRight: Radius.circular(12.0),
                                        ),
                                        border: Border.all(
                                          color: Color(Utils.hexStringToHexInt(
                                              '77ACA2')),

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
                                  color:
                                      Color(Utils.hexStringToHexInt('77ACA2')),
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
                            Text(
                              'How it work?',
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                  color: Colors.black,
                                  fontFamily: 'Poppins Medium',
                                  fontSize:
                                      MediaQuery.of(context).size.width * 0.04),
                            ),
                            Row(
                              children: <Widget>[
                                Center(
                                  child: IconButton(
                                    iconSize: 34,
                                    icon: Icon(
                                      Icons.share,
                                      color: Color(
                                          Utils.hexStringToHexInt('77ACA2')),
                                    ),
                                    // the method which is called
                                    // when button is pressed
                                    onPressed: () {
                                      // Navigator.pop(context);
                                    },
                                  ),
                                ),
                                Flexible(
                                  child: Text(
                                    'Share the referral link with your friends and family.',
                                    textAlign: TextAlign.start,
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontFamily: 'Poppins Medium',
                                        fontSize:
                                            MediaQuery.of(context).size.width *
                                                0.04),
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: <Widget>[
                                Center(
                                  child: IconButton(
                                    iconSize: 34,
                                    icon: Icon(
                                      Icons.account_circle_rounded,
                                      color: Color(
                                          Utils.hexStringToHexInt('77ACA2')),
                                    ),
                                    // the method which is called
                                    // when button is pressed
                                    onPressed: () {
                                      // Navigator.pop(context);
                                    },
                                  ),
                                ),
                                Flexible(
                                  child: Text(
                                    'Your friend sign up with the same link',
                                    textAlign: TextAlign.start,
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontFamily: 'Poppins Medium',
                                        fontSize:
                                            MediaQuery.of(context).size.width *
                                                0.04),
                                  ),
                                ),
                              ],
                            ),

                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Center(
                                  child: IconButton(
                                    iconSize: 34,
                                    icon: Icon(
                                      Icons.card_giftcard_outlined,
                                      color: Color(
                                          Utils.hexStringToHexInt('77ACA2')),
                                    ),
                                    // the method which is called
                                    // when button is pressed
                                    onPressed: () {
                                      // Navigator.pop(context);
                                    },
                                  ),
                                ),
                                Flexible(
                                  child: Text(
                                    'Your friend gets 500 coins on sign up. you get 500 coins after completion of service within 30 days.'
                                    'You can earn upto 500 coins which will be converted into rupees',
                                    textAlign: TextAlign.start,
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontFamily: 'Poppins Medium',
                                        fontSize:
                                            MediaQuery.of(context).size.width *
                                                0.04),
                                  ),
                                ),
                              ],
                            ),
                            // Text(
                            //   'How it work?',
                            //   textAlign: TextAlign.center,
                            //   style: TextStyle(
                            //       color: Colors.black,
                            //       fontFamily: 'Poppins Medium',
                            //       fontSize: MediaQuery.of(context).size.width * 0.04),
                            // ),
                            // Row(
                            //   children: <Widget>[
                            //
                            //     Center(
                            //       child: IconButton(
                            //         iconSize: 34,
                            //         icon: Icon(
                            //           Icons.account_circle_rounded,
                            //           color: Color(Utils.hexStringToHexInt('77ACA2')),
                            //         ),
                            //         // the method which is called
                            //         // when button is pressed
                            //         onPressed: () {
                            //           // Navigator.pop(context);
                            //
                            //         },
                            //       ),
                            //     ),
                            //     Text(
                            //       'Your firend sign up with the same link',
                            //       textAlign: TextAlign.center,
                            //       style: TextStyle(
                            //           color: Colors.black,
                            //           fontFamily: 'Poppins Medium',
                            //           fontSize: MediaQuery.of(context).size.width * 0.04),
                            //     ),
                            //   ],
                            // ),
                            // Row(
                            //   children: <Widget>[
                            //
                            //     Center(
                            //       child: IconButton(
                            //         iconSize: 34,
                            //         icon: Icon(
                            //           Icons.share,
                            //           color: Color(Utils.hexStringToHexInt('77ACA2')),
                            //         ),
                            //         // the method which is called
                            //         // when button is pressed
                            //         onPressed: () {
                            //           // Navigator.pop(context);
                            //
                            //         },
                            //       ),
                            //     ),
                            //     Text(
                            //       'How it work?',
                            //       textAlign: TextAlign.center,
                            //       style: TextStyle(
                            //           color: Colors.black,
                            //           fontFamily: 'Poppins Medium',
                            //           fontSize: MediaQuery.of(context).size.width * 0.04),
                            //     ),
                            //   ],
                            // ),
                            // Row(
                            //   crossAxisAlignment: CrossAxisAlignment.start,
                            //   children: <Widget>[
                            //
                            //     Center(
                            //       child: IconButton(
                            //         iconSize: 34,
                            //         icon: Icon(
                            //           Icons.card_giftcard_outlined,
                            //           color: Color(Utils.hexStringToHexInt('77ACA2')),
                            //         ),
                            //         // the method which is called
                            //         // when button is pressed
                            //         onPressed: () {
                            //           // Navigator.pop(context);
                            //         },
                            //       ),
                            //     ),
                            //     Flexible(
                            //       child: Text(
                            //         'Your fried gets 500 coins on sign up.you get 500 coins after completion of service within 30 days.'
                            //             'You can earn uptp 5000 coins which will be converted into rupees',
                            //         textAlign: TextAlign.start,
                            //         style: TextStyle(
                            //             color: Colors.black,
                            //             fontFamily: 'Poppins Medium',
                            //             fontSize: MediaQuery.of(context).size.width * 0.04),
                            //       ),
                            //     ),
                            //   ],
                            // )
                          ],
                        )
                      ],
                    ),
                  ],
                )),
          ),
        );
      },
    );
  }
}
