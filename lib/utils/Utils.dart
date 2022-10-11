import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Utils {
  static final String SESSION_ID = "Poppins BlackItalic";
static String SESSION="";
  static hexStringToHexInt(String hex) {
    hex = hex.replaceFirst('#', '');
    hex = hex.length == 6 ? 'ff' + hex : hex;
    int val = int.parse(hex, radix: 16);
    return val;
  }

  Widget titleText(text, context) {
    return Text(
      text,
      style: TextStyle(
          fontFamily: 'Poppins Regular',
          fontSize: MediaQuery.of(context).size.height * 0.03,
          color: Colors.black),
    );
  }

  Widget titleText1(text, context) {
    return Text(
      text,
      style: TextStyle(
          fontFamily: 'Poppins Regular',
          fontSize: MediaQuery.of(context).size.height * 0.02,
          color: Colors.black),
    );
  }

  Widget titleTextsemibold(text, context) {
    return Text(
      text,
      style: TextStyle(
          fontFamily: 'Poppins Semibold',
          fontSize: MediaQuery.of(context).size.height * 0.03,
          color: Colors.black),
    );
  }

  static showErrorDialog1(
      width,context,
      {String title = "Oops Error",
        String description = "Something went wrong "}) {
    Get.dialog(
      Dialog(
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10.0))),
        child: Padding(
          padding: const EdgeInsets.all(4.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.end,
              //   children: <Widget>[
              //     GestureDetector(
              //       onTap: () {
              //         if (Get.isDialogOpen!) Get.back();
              //
              //       },
              //       child: Container(
              //         margin: EdgeInsets.all(width * 0.06),
              //         child: IconButton(
              //           iconSize: 34,
              //           icon: Icon(
              //             Icons.close,
              //             color: Color(Utils.hexStringToHexInt('77ACA2')),
              //           ),
              //           // the method which is called
              //           // when button is pressed
              //           onPressed: () {
              //             Navigator.pop(context);
              //
              //           },
              //         ),
              //       ),
              //     )
              //   ],
              // ),
              Text(
                title,
                style:TextStyle(
                    color: Colors.black,
                    fontFamily: 'Poppins Medium',
                    fontSize: MediaQuery.of(context).size.width * 0.04),
              ),
              const SizedBox(
                height: 15,
              ),
              Flexible(
                child: Text(
                  description,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Colors.black,
                      fontFamily: 'Poppins Medium',
                      fontSize: MediaQuery.of(context).size.width * 0.04),
                ),
              ),

              ElevatedButton(
                onPressed: () {
                  if (Get.isDialogOpen!) Get.back();
                },
                child: const Text("Okay"),
              ),
            ],
          ),
        ),
      ),
      barrierDismissible: false,
    );
  }

}

