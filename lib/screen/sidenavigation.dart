import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:untitled/screen/TermconditiionPage.dart';
import 'package:untitled/screen/cartlist.dart';
import 'package:untitled/screen/coin.dart';
import 'package:untitled/screen/wishlish.dart';
import 'package:untitled/utils/CommomDialog.dart';
import 'dart:convert';
import 'package:flutter/services.dart';

import '../controller/home_controller.dart';
import '../utils/Utils.dart';
import '../utils/appconstant.dart';
import 'login.dart';
import 'profile.dart';

class SideNavigatinPage extends StatefulWidget {
  var s = "", s1 = "", s2 = "", s3 = "";

  SideNavigatinPage(String s, String s1, String s2, String s3, {Key? key}) {
    this.s = s;
    this.s1 = s1;
    this.s2 = s2;
    this.s3 = s3;
  }

  @override
  State<SideNavigatinPage> createState() =>
      _SideNavigatinPageState(s, s1, s2, s3);
}

class _SideNavigatinPageState extends State<SideNavigatinPage> {
  late SharedPreferences sharedPreferences;
  final box = GetStorage();

  _SideNavigatinPageState(String s, String s1, String s2, String s3);

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  TextEditingController _textFieldControllerupdateAmenities =
      TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return SafeArea(
        child: Scaffold(
      backgroundColor: Colors.transparent,
      resizeToAvoidBottomInset: false,
      body: Container(
        width: MediaQuery.of(context).size.width * 0.8,
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(width * 0.06),
              bottomRight: Radius.circular(width * 0.06),
            )),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Column(
              children: [
                Container(
                    width: width,
                    height: height * 0.3-height*0.09,
                    decoration: BoxDecoration(
                        color: Color(Utils.hexStringToHexInt('77ACA2')),
                        borderRadius: BorderRadius.only(
                          topRight: Radius.circular(width * 0.06),
                          bottomRight: Radius.circular(width * 0.06),
                        )),
                    child: Stack(
                      children: <Widget>[
                        InkWell(
                          onTap: (){
                            Navigator.pop(context);
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => ProfilePage()),
                            );
                          },
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Center(
                                child: Row(
                                  children: [
                                    Container(
                                      margin:
                                          EdgeInsets.only(left: 6.0, right: 6.0),
                                      height: height * 0.1,
                                      child: Center(
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Center(
                                                child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(10.0),
                                              child: SizedBox.fromSize(
                                                size: Size.fromRadius(35),
                                                child: Image.network(
                                                  "${widget.s1}",
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                            )),
                                            SizedBox(
                                              width: 4.0,
                                            ),
                                            Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: <Widget>[
                                                Text(
                                                  "${widget.s}",
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: width * 0.05,
                                                    fontFamily: 'Poppins Regular',
                                                  ),
                                                ),
                                                Text(
                                                  "${widget.s2}",
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: width * 0.03,
                                                    fontFamily: 'Poppins Regular',
                                                  ),
                                                ),
                                                Text(
                                                  "${widget.s3}",
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: width * 0.03,
                                                    fontFamily: 'Poppins Regular',
                                                  ),
                                                )
                                              ],
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 8.0, left: 4.0),
                                              child: Image.asset(
                                                'images/svgicons/edit.png',
                                                width: 12,
                                                height: 12,
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        Align(
                          alignment: Alignment.topRight,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: <Widget>[
                              IconButton(
                                iconSize: 30,
                                icon: const Icon(
                                  Icons.close,
                                  color: Colors.white,
                                ),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                              ),
                            ],
                          ),
                        )
                      ],
                    )),
                Column(
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    ListTile(
                      leading: Icon(
                        Icons.favorite,
                        color: Color(Utils.hexStringToHexInt('77ACA2')),
                      ),
                      title: const Text(' Wishlist '),
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => Wishlist()),
                        );
                      },
                      trailing: const Icon(Icons.keyboard_arrow_right),
                    ),
                    const Divider(
                      height: 1.0,
                      color: Colors.grey,
                    ),

                    ListTile(
                      leading: Icon(
                        CupertinoIcons.cart,
                        color: Color(Utils.hexStringToHexInt('77ACA2')),
                      ),
                      title: const Text(' My Cart '),
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => MyCartList()),
                        );
                      },
                      trailing: const Icon(Icons.keyboard_arrow_right),
                    ), //flutter build apk --release --no-sound-null-safety
                    const Divider(
                      height: 1.0,
                      color: Colors.grey,
                    ),
                    ListTile(
                      leading: Icon(
                        Icons.share,
                        color: Color(Utils.hexStringToHexInt('77ACA2')),
                      ),
                      title: const Text(' Refer To Earn '),
                      // subtitle: const Text(
                      //     ' You will get 50 coin on first order of your firend '),
                      onTap: () async {
                        Navigator.pop(context);
                        // CommonDialog.showLoading(title: "Please wait");
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => CoinPage()),
                        );
                        // Map map = {
                        //   "session_id": box.read('session'),
                        // };
                        // print(map);
                        // var apiUrl = Uri.parse(
                        //     AppConstant.BASE_URL + AppConstant.REFER_TO_FRIEND);
                        // print(apiUrl);
                        // print(map);
                        // final response = await http.post(
                        //   apiUrl,
                        //   body: map,
                        // );
                        // print(response.body);
                        // var data = response.body;
                        // final body = json.decode(response.body);
                        // setState(() {
                        //   if (body['message'] != "") {
                        //     CommonDialog.showsnackbar(body['message'] +
                        //         "your code is \n" +
                        //         body['referel_code']);
                        //     showLoaderDialog(context, body['referel_code']);
                        //   }
                        // });

                        // showDialog(
                        //   context: context,
                        //   builder: (BuildContext context) {
                        //     var valueName = "";
                        //     var valuePrice = "";
                        //     return AlertDialog(
                        //       title: Row(
                        //         mainAxisAlignment:
                        //             MainAxisAlignment.spaceBetween,
                        //         children: <Widget>[
                        //           const Text(
                        //             'Refer to your friend',
                        //             style: TextStyle(fontSize: 12.0),
                        //           ),
                        //           IconButton(
                        //             onPressed: () => Navigator.pop(context),
                        //             icon: Icon(Icons.cancel_outlined),
                        //           ),
                        //         ],
                        //       ),
                        //       content: Container(
                        //         width: 200,
                        //         child: SingleChildScrollView(
                        //           child: Column(
                        //             mainAxisAlignment: MainAxisAlignment.start,
                        //             crossAxisAlignment:
                        //                 CrossAxisAlignment.center,
                        //             children: <Widget>[
                        //               SizedBox(
                        //                 height: height * 0.03,
                        //               ),
                        //               SizedBox(
                        //                 height: 10,
                        //               ),
                        //               FlatButton(
                        //                 color: Color(
                        //                     Utils.hexStringToHexInt('77ACA2')),
                        //                 textColor: Colors.white,
                        //                 child: Text('OK'),
                        //                 onPressed: () async {
                        //                   showLoaderDialog(context);
                        //                   // Map map = {
                        //                   //   "session_id": box.read('session'),
                        //                   // };
                        //                   // print(map);
                        //                   // var apiUrl = Uri.parse(
                        //                   //     AppConstant.BASE_URL +
                        //                   //         AppConstant.REFER_TO_FRIEND);
                        //                   // print(apiUrl);
                        //                   // print(map);
                        //                   // final response = await http.post(
                        //                   //   apiUrl,
                        //                   //   body: map,
                        //                   // );
                        //                   // print(response.body);
                        //                   // var data = response.body;
                        //                   // final body =
                        //                   //     json.decode(response.body);
                        //                   // CommonDialog.showsnackbar(
                        //                   //     body['message'] +
                        //                   //         "your code is \n" +
                        //                   //         body['referel_code']);
                        //                   // Navigator.pop(context);
                        //                   //
                        //                   // showLoaderDialog(context);
                        //                   // Share.share(
                        //                   //     'Intall this app and get benifits ${body['referel_code']}',
                        //                   //     subject: 'Kolacut!');
                        //                 },
                        //               ),
                        //             ],
                        //           ),
                        //         ),
                        //       ),
                        //       actions: <Widget>[],
                        //     );
                        //   },
                        // );
                        // Navigator.pop(context);
                      },
                      trailing: const Icon(Icons.keyboard_arrow_right),
                    ),
                    const Divider(
                      height: 1.0,
                      color: Colors.grey,
                    ),
                    ListTile(
                      leading: Icon(
                        Icons.delete,
                        color: Color(Utils.hexStringToHexInt('77ACA2')),
                      ),
                      title: const Text(' Delete Account '),

                      onTap: () async {
                        _showDialog(context);
                      },
                      trailing: const Icon(Icons.keyboard_arrow_right),
                    ),
                    Divider(
                      height: 1.0,
                      color: Colors.grey,
                    ),
                  ],
                ),
              ],
            ),
            Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Container(
                  child: Align(
                    alignment: FractionalOffset.bottomCenter,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          margin: EdgeInsets.only(left: 4.0),
                          width: width - width * 0.2,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text(
                                'V 1.2.3',
                                style: TextStyle(
                                    fontFamily: 'Poppins Regular',
                                    fontSize: width * 0.04,
                                    color: Color(
                                        Utils.hexStringToHexInt('8D8D8D'))),
                              ),
                              InkWell(
                                onTap: () async {
                                  Navigator.pop(context);
                                  SharedPreferences prefrences =
                                      await SharedPreferences.getInstance();
                                  await prefrences.remove("session");
                                  box.remove('session');
                                  Get.offAll(LoginPage());
                                },
                                child: SvgPicture.asset(
                                  "images/svgicons/logoutt.svg",
                                  width: width * 0.04,
                                  height: height * 0.04,
                                  fit: BoxFit.contain,
                                  color:
                                      Color(Utils.hexStringToHexInt('A3A2A2')),
                                ),
                              )
                            ],
                          ),
                        ),
                        SizedBox(
                          height: height * 0.01,
                        ),
                        Center(
                          child: InkWell(
                            onTap: (){
                              Navigator.of(context).pop();
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => TermConditionPage()),
                              );
                            },
                            child: Text(
                              'Terms & Conditions',
                              style: TextStyle(
                                  color: Color(Utils.hexStringToHexInt('77ACA2')),
                                  fontFamily: 'Poppins Semibold',
                                  fontSize: width * 0.03),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: height * 0.05)
              ],
            )
          ],
        ),
      ),
    ));
  }
  _showDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Expanded(
          child: AlertDialog(
            title: Text('Delet Account!'),
            content: Text('Do you want to delete your account?'),
            actions: [
              TextButton(
                onPressed: () async {
                  Navigator.of(context).pop();
                  Map map = {
                    "session_id": box.read('session'),
                  };
                  print(map);
                  var apiUrl = Uri.parse(
                      AppConstant.BASE_URL + AppConstant.DELET_ACCOUNT);
                  print(apiUrl);
                  print(map);
                  final response = await http.post(
                    apiUrl,
                    body: map,
                  );
                  print(response.body);
                  var data = response.body;
                  final body = json.decode(response.body);
                  setState(()async {
                    if (body['message'] != "") {
                      CommonDialog.showsnackbar(body['message']);
                      SharedPreferences prefrences =
                          await SharedPreferences.getInstance();
                      await prefrences.remove("session");
                      box.remove('session');
                      Get.offAll(LoginPage());
                      //showLoaderDialog(context, body['referel_code']);
                    }
                  });
                },
                child: Text('YES', style: TextStyle(color: Colors.black),),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('NO', style: TextStyle(color: Colors.black),),
              ),
            ],
          ),
        );
      },
    );
  }
  showLoaderDialog(BuildContext context, code) {
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
                        Navigator.pop(context);
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
}
