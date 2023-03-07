import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:otp_text_field/style.dart';
import 'package:untitled/utils/Utils.dart';
import 'package:otp_text_field/otp_text_field.dart';

import '../controller/auth_controller.dart';

class VerifyOtpPage extends StatefulWidget {
  const VerifyOtpPage({Key key}) : super(key: key);

  @override
  State<VerifyOtpPage> createState() => _VerifyPageState();
}

class _VerifyPageState extends State<VerifyOtpPage> {
   TextEditingController emailcontroller;
  var otp = "";
  AuthControlller authControlller = Get.put(AuthControlller());

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    emailcontroller = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;

    var one = Get.arguments;
    print(one);
    var fistt=one.toString().substring(0, 2);
    var lastwp=one.toString().substring(one.length-2);
    final src = one;
    final result = src.split(' ').take(2).join(' ');
    var shophone=fistt+"*****"+lastwp;
    print(shophone);

    return SafeArea(
        child: Scaffold(
      body: Container(
        width: width,
        height: height,
        decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage('images/svgicons/dottedbackground.png'),
                fit: BoxFit.fill)),
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              SizedBox(
                height: height * 0.04,
              ),
              const Center(
                child: Text(
                  'Kolacut',
                  style: TextStyle(fontFamily: 'Poppins Regular'),
                ),
              ),
              SizedBox(
                height: height * 0.04,
              ),
              Container(
                width: width * 0.7 - width * 0.03,
                height: height * 0.4 - height * 0.03,
                decoration: const BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage('images/svgicons/logibar.png'),
                        fit: BoxFit.fill)),
              ),
              SizedBox(
                height: height * 0.03,
              ),
              Utils().titleTextsemibold('Verify', context),
              SizedBox(
                height: height * 0.03,
              ),
              Center(
                child: Text(
                  'Enter 4 digit code sent to '+shophone,
                  style: TextStyle(
                      color: Color(Utils.hexStringToHexInt('7E7E7E')),
                      fontFamily: 'Poppins Regular',
                      fontSize: width * 0.03),
                ),
              ),
              SizedBox(
                height: height * 0.02,
              ),
              Container(
                margin:
                    EdgeInsets.only(left: width * 0.04, right: width * 0.04),
                child: OTPTextField(
                  length: 4,
                  width: MediaQuery.of(context).size.width,
                  fieldWidth: width * 0.2 - width * 0.04,
                  style: TextStyle(fontSize: 17),
                  textFieldAlignment: MainAxisAlignment.spaceAround,
                  fieldStyle: FieldStyle.box,
                  outlineBorderRadius: 15,
                  onCompleted: (pin) {
                    print("Completed: " + pin);
                    otp = pin.toString();
                  },
                ),
              ),
              SizedBox(
                height: height * 0.03,
              ),
              InkWell(
                onTap: (){
                  authControlller.resendOtp();
                },
                child: Text(
                  'Resend the OTP',
                  style: TextStyle(
                      color: Color(Utils.hexStringToHexInt('77ACA2')),
                      fontFamily: 'Poppins Regular',
                      fontSize: width * 0.03),
                ),
              ),
              SizedBox(
                height: height * 0.03,
              ),
              GestureDetector(
                onTap: () {
                  authControlller.verifyOtp(otp);
                },
                child: Container(
                  width: width * 0.5,
                  height: height * 0.06,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(width * 0.08),
                      color: Color(Utils.hexStringToHexInt('77ACA2'))),
                  child: Center(
                    child: Text(
                      'Verify',
                      style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'Poppins Semibold',
                          fontSize: width * 0.04),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: height * 0.04,
              ),
            ],
          ),
        ),
      ),
    ));

  }


}
