import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:untitled/screen/orderdetail.dart';

import '../utils/Utils.dart';

class SideNavigatinPage extends StatelessWidget {
  const SideNavigatinPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return SafeArea(
        child: Scaffold(
      backgroundColor: Colors.transparent,
      resizeToAvoidBottomInset: true,
      body: Container(
        width: MediaQuery.of(context).size.width * 0.8,
        height: MediaQuery.of(context).size.height,
        child: SingleChildScrollView(
          child: Container(
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(width * 0.06),
                  topRight: Radius.circular(width * 0.06),
                  bottomRight: Radius.circular(width * 0.06),
                )),
            child: Column(
              children: <Widget>[
                Container(
                  width: width,
                  height: height * 0.3,
                  decoration: BoxDecoration(
                      color: Color(Utils.hexStringToHexInt('77ACA2')),
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(width * 0.06),
                        topRight: Radius.circular(width * 0.06),
                        bottomRight: Radius.circular(width * 0.06),
                      )),
                ),
                Container(
                  margin:
                      EdgeInsets.only(top: height * 0.03, left: width * 0.04),
                  child: Column(
                    children: <Widget>[
                      GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                          // Navigator.push(
                          //   context,
                          //   MaterialPageRoute(
                          //       builder: (context) => OrderDetail()),
                          // );
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Container(
                              width: width * 0.07,
                              height: height * 0.07,
                              child: SvgPicture.asset(
                                "images/svgicons/booking.svg",
                                width: width * 0.02,
                                height: height * 0.02,
                                fit: BoxFit.contain,
                                color: Color(Utils.hexStringToHexInt('A3A2A2')),
                              ),
                            ),
                            Text('  Bookings',
                                style: TextStyle(
                                    fontSize: width * 0.04,
                                    fontFamily: 'Poppins Regular',
                                    color: Color(
                                        Utils.hexStringToHexInt('A4A4A4'))),
                                textAlign: TextAlign.center),
                          ],
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            width: width * 0.07,
                            height: height * 0.07,
                            child: SvgPicture.asset(
                              "images/svgicons/newhrt.svg",
                              width: width * 0.02,
                              height: height * 0.02,
                              fit: BoxFit.contain,
                              color: Color(Utils.hexStringToHexInt('A3A2A2')),
                            ),
                          ),
                          Text('  Wishlist',
                              style: TextStyle(
                                  fontSize: width * 0.04,
                                  fontFamily: 'Poppins Regular',
                                  color:
                                      Color(Utils.hexStringToHexInt('A4A4A4'))),
                              textAlign: TextAlign.center),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            width: width * 0.07,
                            height: height * 0.07,
                            child: SvgPicture.asset(
                              "images/svgicons/blog.svg",
                              width: width * 0.02,
                              height: height * 0.02,
                              fit: BoxFit.contain,
                              color: Color(Utils.hexStringToHexInt('A3A2A2')),
                            ),
                          ),
                          Text('  Blogs',
                              style: TextStyle(
                                  fontSize: width * 0.04,
                                  fontFamily: 'Poppins Regular',
                                  color:
                                      Color(Utils.hexStringToHexInt('A4A4A4'))),
                              textAlign: TextAlign.center),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            width: width * 0.07,
                            height: height * 0.07,
                            child: SvgPicture.asset(
                              "images/svgicons/invitefriends.svg",
                              width: width * 0.02,
                              height: height * 0.02,
                              fit: BoxFit.contain,
                              color: Color(Utils.hexStringToHexInt('A3A2A2')),
                            ),
                          ),
                          Text('  INvite Friends',
                              style: TextStyle(
                                  fontSize: width * 0.04,
                                  fontFamily: 'Poppins Regular',
                                  color:
                                      Color(Utils.hexStringToHexInt('A4A4A4'))),
                              textAlign: TextAlign.center),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            width: width * 0.07,
                            height: height * 0.07,
                            child: SvgPicture.asset(
                              "images/svgicons/share.svg",
                              width: width * 0.02,
                              height: height * 0.02,
                              fit: BoxFit.contain,
                              color: Color(Utils.hexStringToHexInt('A3A2A2')),
                            ),
                          ),
                          Text('  Share & Earn',
                              style: TextStyle(
                                  fontSize: width * 0.04,
                                  fontFamily: 'Poppins Regular',
                                  color:
                                      Color(Utils.hexStringToHexInt('A4A4A4'))),
                              textAlign: TextAlign.center),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            width: width * 0.07,
                            height: height * 0.07,
                            child: SvgPicture.asset(
                              "images/svgicons/needhelp.svg",
                              width: width * 0.02,
                              height: height * 0.02,
                              fit: BoxFit.contain,
                              color: Color(Utils.hexStringToHexInt('A3A2A2')),
                            ),
                          ),
                          Text('  Need Help ?',
                              style: TextStyle(
                                  fontSize: width * 0.04,
                                  fontFamily: 'Poppins Regular',
                                  color:
                                      Color(Utils.hexStringToHexInt('A4A4A4'))),
                              textAlign: TextAlign.center),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            width: width * 0.07,
                            height: height * 0.07,
                            child: SvgPicture.asset(
                              "images/svgicons/about.svg",
                              width: width * 0.02,
                              height: height * 0.02,
                              fit: BoxFit.contain,
                              color: Color(Utils.hexStringToHexInt('A3A2A2')),
                            ),
                          ),
                          Text('  About',
                              style: TextStyle(
                                  fontSize: width * 0.04,
                                  fontFamily: 'Poppins Regular',
                                  color:
                                      Color(Utils.hexStringToHexInt('A4A4A4'))),
                              textAlign: TextAlign.center),
                        ],
                      ),
                      SizedBox(
                        height: height * 0.03,
                      ),
                      Divider(
                        thickness: 2,
                        color: Color(Utils.hexStringToHexInt('C4C4C4')),
                      ),
                      SizedBox(
                        height: height * 0.02,
                      ),
                      Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                              'V 1.2.3',
                              style: TextStyle(
                                  fontFamily: 'Poppins Regular',
                                  fontSize: width * 0.04,
                                  color:
                                      Color(Utils.hexStringToHexInt('8D8D8D'))),
                            ),
                            SvgPicture.asset(
                              "images/svgicons/logoutt.svg",
                              width: width * 0.05,
                              height: height * 0.05,
                              fit: BoxFit.contain,
                              color: Color(Utils.hexStringToHexInt('A3A2A2')),
                            )
                          ],
                        ),
                      ),
                      SizedBox(
                        height: height * 0.03,
                      ),
                      Center(
                        child: Text(
                          'Terms & Conditions',
                          style: TextStyle(
                              color: Color(Utils.hexStringToHexInt('C4C4C4')),
                              fontFamily: 'Poppins Semibold',
                              fontSize: width * 0.03),
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    ));
  }
}
