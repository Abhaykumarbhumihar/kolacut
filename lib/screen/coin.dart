import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:untitled/utils/Utils.dart';
import 'package:flutter_circular_slider/flutter_circular_slider.dart';

class CoinPage extends StatefulWidget {
  const CoinPage({Key? key}) : super(key: key);

  @override
  State<CoinPage> createState() => _CoinPageState();
}

class _CoinPageState extends State<CoinPage> {
  var inBedTime;
  var outBedTime;

  void _updateLabels(int init, int end, int c) {
    setState(() {
      inBedTime = init;
      outBedTime = end;
      debugPrint(inBedTime);
    });
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
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
            Navigator.pop(context);
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
      body: Container(
        width: width,
        color: Color(Utils.hexStringToHexInt('#fcfcfc')),
        height: height,
        child: Container(
          margin: EdgeInsets.only(left: width * 0.03, right: width * 0.03),
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
                      color: Color(Utils.hexStringToHexInt('C4C4C4'))),
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
                      ' 10000',
                      style: TextStyle(
                          color: Colors.black,
                          fontFamily: 'Poppins Medium',
                          fontSize: width * 0.05),
                    ),
                  ],
                ),
                Text(
                  ' View Details',
                  style: TextStyle(
                      fontFamily: 'Poppins Medium',
                      fontSize: width * 0.03,
                      color: Color(Utils.hexStringToHexInt('77ACA2'))),
                ),
                Center(
                  child: Container(
                      child: SingleCircularSlider(
                    100,
                    10,
                    width: width * 0.8,
                    height: height * 0.5,
                    primarySectors: 4,
                    secondarySectors: 4,
                    showHandlerOutter: true,
                    showRoundedCapInSelection: true,
                    child: Center(
                      child: Container(
                        width: width * 0.8,
                        height: height * 0.3,
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              '₹ 100',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: width * 0.07,
                                  fontFamily: 'Poppins Medium'),
                            ),
                            Text(
                              '100 coins',
                              style: TextStyle(
                                  fontFamily: 'Poppins Regular',
                                  fontSize: width * 0.04,
                                  color:
                                      Color(Utils.hexStringToHexInt('C4C4C4'))),
                            ),
                            Container(
                              width: width * 0.5,
                              height: 34,
                              margin: EdgeInsets.only(top: height * 0.03),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                      color: Color(
                                          Utils.hexStringToHexInt('77ACA2')),
                                      width: 1)),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: <Widget>[
                                  Text(
                                    '',
                                    style: TextStyle(
                                        fontSize: width * 0.03,
                                        fontFamily: 'Poppins Light',
                                        color: Color(
                                            Utils.hexStringToHexInt('77ACA2'))),
                                  ),
                                  Text(
                                    'Conversion Rate 1%',
                                    style: TextStyle(
                                        fontSize: width * 0.02,
                                        fontFamily: 'Poppins Light',
                                        color: Color(
                                            Utils.hexStringToHexInt('77ACA2'))),
                                  ),
                                  Icon(
                                    Icons.arrow_forward_ios,
                                    size: width * 0.04,
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    onSelectionChange: (a, b, c) => {
                      setState(() {
                        outBedTime = b;
                      })
                    },
                    baseColor: Color(Utils.hexStringToHexInt('#d6dfe9')),
                    selectionColor: Color(Utils.hexStringToHexInt('77ACA2')),
                  )),
                ),
                SizedBox(
                  height: height * 0.03,
                ),
                Container(
                  width: width,
                  height: height * 0.06,
                  decoration: BoxDecoration(
                      color: Color(Utils.hexStringToHexInt('77ACA2')),
                      borderRadius: BorderRadius.circular(width * 0.07)),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Container(
                        width: 44,
                        height: 44,
                        margin: EdgeInsets.all(2),
                        decoration: const BoxDecoration(
                            image: DecorationImage(
                                image: AssetImage(
                                    'images/svgicons/circleback.png'),
                                fit: BoxFit.fill)),
                        child: Center(
                          child: Icon(
                            Icons.arrow_right_alt_outlined,
                            color: Color(Utils.hexStringToHexInt('77ACA2')),
                          ),
                        ),
                      ),
                      Text(
                        'Swipe to Add Money',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Colors.white,
                            fontFamily: 'Poppins Medium',
                            fontSize: width * 0.03),
                      ),
                      Text(
                        '',
                        style: TextStyle(
                            color: Colors.white,
                            fontFamily: 'Poppins Medium',
                            fontSize: width * 0.04),
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: height * 0.02,
                ),
                Center(
                  child: Text(
                    'Want to earn more coins?',
                    style: TextStyle(
                        fontFamily: 'Poppins Regular',
                        fontSize: width * 0.03,
                        color: Color(Utils.hexStringToHexInt('77ACA2'))),
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
