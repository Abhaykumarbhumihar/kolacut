import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_exif_rotation/flutter_exif_rotation.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:untitled/screen/homebottombar.dart';
import 'package:untitled/screen/homepage.dart';
import 'package:untitled/utils/CommomDialog.dart';
import 'package:untitled/utils/Utils.dart';
import 'package:intl/intl.dart';
import '../controller/auth_controller.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key key}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  AuthControlller authControlller = Get.put(AuthControlller());
   TextEditingController emailcontroller,
      _nameController,
      _dobController,
      _phonecontroller,_refferalcontroller;
  String date = "";

  // Initial Selected Value
  String dropdownvalue = 'Male';
  final list = ['Male', 'Female'];

  var imageFile;
  DateTime selectedDate = DateTime.now();
  var genderSelect = "";
  var dob = "";
  var dropdown;
  var showselectGender = "";

  List<DropdownMenuItem<String>> _createList() {
    return list
        .map<DropdownMenuItem<String>>(
          (e) => DropdownMenuItem(
            value: e,
            child: Text(e),
          ),
        )
        .toList();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    emailcontroller = TextEditingController();
    _nameController = TextEditingController();
    _dobController = TextEditingController();
    _phonecontroller = TextEditingController();
    _refferalcontroller=TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
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
              ///////
              Container(
                width: width * 0.5,
                height: height * 0.2,
                child: Stack(
                  children: <Widget>[
                    Container(
                      width: width * 0.5,
                      height: height * 0.2,
                      child: imageFile == null
                          ? Container(
                              width: width * 0.5,
                              height: height * 0.2,
                              decoration: const BoxDecoration(
                                  image: DecorationImage(
                                      image: AssetImage(
                                          'images/svgicons/profilehoto.png'),
                                      fit: BoxFit.contain)),
                            )
                          : Container(
                              width: width * 0.5,
                              height: height * 0.2,
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  image: DecorationImage(
                                      image: FileImage(imageFile),
                                      fit: BoxFit.fill)),
                            ),
                    ),
                    Positioned(
                      top: height * 0.1 + height * 0.04,
                      right: width * 0.06,
                      child: GestureDetector(
                        onTap: () {
                          _showImageChooser(context);
                        },
                        child: Container(
                          width: width * 0.1,
                          height: height * 0.06,
                          decoration: const BoxDecoration(
                              image: DecorationImage(
                                  image: AssetImage(
                                      'images/svgicons/circleaddback.png'),
                                  fit: BoxFit.contain)),
                          child: Center(
                            child: SvgPicture.asset(
                              'images/svgicons/adddd.svg',
                              width: width * 0.02,
                              height: height * 0.02,

                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(
                height: height * 0.02,
              ),
              Text("Add profile Photo",
                  style: TextStyle(
                    color: Color(Utils.hexStringToHexInt('77ACA2')),
                    fontSize: width * 0.05,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Poppins Regular',
                  ),
                  textAlign: TextAlign.end),
              SizedBox(
                height: height * 0.08,
              ),
              Utils().titleTextsemibold('Register Now', context),
              SizedBox(
                height: height * 0.02,
              ),
              Center(
                child: Text(
                  'Please enter the details below to continue',
                  textAlign: TextAlign.center,
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
                    EdgeInsets.only(left: width * 0.09, right: width * 0.09),
                child: Column(
                  children: <Widget>[
                    Container(
                      width: width - 5,
                      height: height * 0.1 - height * 0.05,
                      padding: const EdgeInsets.only(left: 6),
                      decoration: BoxDecoration(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(4)),
                        color: Color(Utils.hexStringToHexInt('F4F4F4')),
                      ),
                      //alignment: Alignment.topCenter,
                      child: Align(
                        //alignment: Alignment.topCenter,
                        child: TextField(
                            style: const TextStyle(
                              color: Colors.black,
                            ),
                            textAlign: TextAlign.left, // Align horizontally
                            textAlignVertical: TextAlignVertical.center, // Align vertically
                            controller: _nameController,
                            decoration: InputDecoration(
                                contentPadding: EdgeInsets.zero,
                                isDense: true,
                                hintText: 'Name',
                                hintStyle: TextStyle(
                                    color:
                                        Color(Utils.hexStringToHexInt('A4A4A4')),
                                    fontFamily: 'Poppins Regular',
                                    fontSize: width * 0.03),
                                border: InputBorder.none)),
                      ),
                    ),
                    Container(
                      width: width - 5,
                      height: height * 0.1 - height * 0.05,
                      margin: const EdgeInsets.only(top: 6),
                      padding: const EdgeInsets.only(left: 6),
                      decoration: BoxDecoration(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(4)),
                        color: Color(Utils.hexStringToHexInt('F4F4F4')),
                      ),
                      child: Align(
                        child: TextField(
                            style: const TextStyle(
                              color: Colors.black,
                            ),
                            //textAlignVertical: TextAlignVertical.center,
                            textAlign: TextAlign.left,
                            controller: emailcontroller,
                            decoration: InputDecoration(
                                contentPadding: EdgeInsets.zero,
                                isDense: true,
                                hintText: 'Email',
                                hintStyle: TextStyle(
                                    color:
                                        Color(Utils.hexStringToHexInt('A4A4A4')),
                                    fontFamily: 'Poppins Regular',
                                    fontSize: width * 0.03),
                                border: InputBorder.none)),
                      ),
                    ),
                    Container(
                      width: width - 5,
                      height: height * 0.1 - height * 0.05,
                      margin: const EdgeInsets.only(top: 6),
                      padding: const EdgeInsets.only(left: 6),
                      decoration: BoxDecoration(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(4)),
                        color: Color(Utils.hexStringToHexInt('F4F4F4')),
                      ),
                      child: Align(
                        child: TextField(
                            style: const TextStyle(
                              color: Colors.black,
                            ),
                           // textAlignVertical: TextAlignVertical.center,
                            textAlign: TextAlign.left,
                            controller: _phonecontroller,
                            decoration: InputDecoration(
                                contentPadding: EdgeInsets.zero,
                                isDense: true,
                                hintText: 'Phone',
                                hintStyle: TextStyle(
                                    color:
                                        Color(Utils.hexStringToHexInt('A4A4A4')),
                                    fontFamily: 'Poppins Regular',
                                    fontSize: width * 0.03),
                                border: InputBorder.none)),
                      ),
                    ),
                    Row(
                      children: <Widget>[
                        Expanded(
                          flex: 1,
                          child: GestureDetector(
                            onTap: () {
                              _selectDate(context);
                            },
                            child: Container(
                              width: width - 5,
                              height: height * 0.1 - height * 0.05,
                              margin: const EdgeInsets.only(top: 6),
                              padding: const EdgeInsets.only(left: 6),
                              decoration: BoxDecoration(
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(4)),
                                color: Color(Utils.hexStringToHexInt('F4F4F4')),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Text(
                                    dob == "" ? "Date of birth" : dob,
                                    style: TextStyle(
                                        color: Color(
                                            Utils.hexStringToHexInt('A4A4A4')),
                                        fontFamily: 'Poppins Regular',
                                        fontSize: width * 0.03),
                                  ),
                                  Container(
                                    width: 20,
                                    height: 20,
                                    margin: EdgeInsets.only(right: 4.0),
                                    decoration: BoxDecoration(
                                      image: DecorationImage(
                                        image: AssetImage('images/svgicons/dobn.png')
                                      )
                                    ),
                                    // child: const Icon(
                                    //
                                    //   Icons.calendar_today,
                                    //   color: Colors.black,
                                    //   size:18,
                                    // ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 6,
                        ),
                        Expanded(
                          flex: 1,
                          child: Container(
                            width: width - 5,
                            height: height * 0.1 - height * 0.05,
                            margin: const EdgeInsets.only(top: 6),
                            padding: const EdgeInsets.only(left: 6),
                            decoration: BoxDecoration(
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(4)),
                              color: Color(Utils.hexStringToHexInt('F4F4F4')),
                            ),
                            child:
                            DropdownButton(
                              icon: Container(
                                  margin: EdgeInsets.only(left: width*0.1+8),
                                  child: const Icon(Icons.keyboard_arrow_down)),
                              hint: Text(
                                "${showselectGender == "" ? "Gender" : showselectGender}",
                                style: TextStyle(
                                    color: Color(
                                        Utils.hexStringToHexInt('A4A4A4')),
                                    fontFamily: 'Poppins Regular',
                                    fontSize: width * 0.03),
                              ),
                              underline: SizedBox(),
                              isExpanded: false,
                              items: _createList(),
                              onChanged: (value) {
                                setState(() {
                                  showselectGender = value.toString();
                                  if (value == "Male") {
                                    genderSelect = "1";
                                    print(genderSelect);
                                  } else if (value == "Female") {
                                    genderSelect = "2";
                                    print(genderSelect);
                                  }
                                });
                              },
                            ),
                          ),
                        )
                      ],
                    ),
                    Container(
                      width: width - 5,
                      height: height * 0.1 - height * 0.05,
                      margin: const EdgeInsets.only(top: 6),
                      padding: const EdgeInsets.only(left: 6),
                      decoration: BoxDecoration(
                        borderRadius:
                        const BorderRadius.all(Radius.circular(4)),
                        color: Color(Utils.hexStringToHexInt('F4F4F4')),
                      ),
                      child: Align(
                        child: TextField(
                            style: const TextStyle(
                              color: Colors.black,
                            ),
                            //textAlignVertical: TextAlignVertical.center,
                            textAlign: TextAlign.left,
                            controller: _refferalcontroller,
                            decoration: InputDecoration(
                                contentPadding: EdgeInsets.zero,
                                isDense: true,
                                hintText: 'Enter code if you have',
                                hintStyle: TextStyle(
                                    color:
                                    Color(Utils.hexStringToHexInt('A4A4A4')),
                                    fontFamily: 'Poppins Regular',
                                    fontSize: width * 0.03),
                                border: InputBorder.none)),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: height * 0.04,
              ),
              GestureDetector(
                onTap: () {
                  if (validate()) {
                    authControlller.registerUser(
                        imageFile,
                        _nameController.text.toString(),
                        emailcontroller.text.toString(),
                        dob,
                        genderSelect,
                        _phonecontroller.text.toString(),
                        "android",
                        "sdfsdfsdfsdf",
                    "",
                    context);
                  }
                },
                child: Container(
                  width: width * 0.5,
                  height: height * 0.06,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(width * 0.08),
                      color: Color(Utils.hexStringToHexInt('77ACA2'))),
                  child: Center(
                    child: Text(
                      'Register',
                      style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'Poppins Semibold',
                          fontSize: width * 0.04),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: height * 0.03,
              ),
              SizedBox(
                height: height * 0.02,
              ),
              Center(
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const MainPage()),
                    );
                  },
                  child: Container(
                    child: Text("Skip",
                        style: TextStyle(
                          color: Color(Utils.hexStringToHexInt('77ACA2')),
                          fontSize: width * 0.04,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Poppins Semibold',
                        ),
                        textAlign: TextAlign.end),
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

  Future _showImageChooser(BuildContext contextt) {
    return showDialog(
        barrierDismissible: false,
        context: contextt,
        builder: (BuildContext) {
          return Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            elevation: 0,
            backgroundColor: Colors.transparent,
            child: contentBox(context),
          );
        });
  }

  contentBox(context) {
    return Stack(
      children: <Widget>[
        Container(
          width: MediaQuery.of(context).size.width,
          padding:
              const EdgeInsets.only(left: 10, top: 10, right: 10, bottom: 10),
          margin: const EdgeInsets.only(top: 10),
          decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              boxShadow: const [
                BoxShadow(
                    color: Colors.black, offset: Offset(0, 10), blurRadius: 10),
              ]),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              const Padding(
                padding: EdgeInsets.only(top: 12.0),
                child: Text("Make a choice !",
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Libre Baskervillelight',
                    ),
                    textAlign: TextAlign.center),
              ),
              const SizedBox(
                height: 35,
              ),
              RaisedButton.icon(
                  onPressed: () async {
                    _openGallery(context);
                  },
                  icon: const Icon(
                    Icons.drive_file_move_outline,
                    color: Colors.blue,
                  ),
                  label: const Text('Select from gallery',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Libre Baskervillelight',
                      ))),
              const SizedBox(
                height: 15.0,
              ),
              RaisedButton.icon(
                  onPressed: () {
                    _openCame(context);
                  },
                  icon: const Icon(
                    Icons.camera_alt_outlined,
                    color: Colors.blue,
                  ),
                  label: const Text('Capture from camera',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Libre Baskervillelight',
                      ))),
            ],
          ),
        ),
        Positioned(
            top: 10,
            right: 2.0,
            child: GestureDetector(
              onTap: () {
                Navigator.of(context).maybePop();
              },
              child: CircleAvatar(
                backgroundColor: Colors.transparent,
                radius: 10,
                child: Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: ClipRRect(
                    borderRadius: const BorderRadius.all(Radius.circular(10)),
                    child: SvgPicture.asset(
                      "images/svgicons/002-error.svg",
                      width: 44,
                      height: 44,
                    ),
                  ),
                ),
              ),
            )),
      ],
    );
  }

  _openCame(BuildContext context) async {
    // ignore: deprecated_member_use
    final ImagePicker _picker = ImagePicker();
    var image = await _picker.pickImage(source: ImageSource.camera);
    setState(() async {
      Navigator.of(context).maybePop();
      imageFile = image;
      if (image != null) {
        /*todo---this is for use image rotation stop*/
        File rotatedImage =
            await FlutterExifRotation.rotateAndSaveImage(path: image.path);

        setState(() {
          imageFile = rotatedImage;
        });
      }
    });
  }

  _openGallery(BuildContext context) async {
    final ImagePicker _picker = ImagePicker();
    var picture = await _picker.pickImage(
        source: ImageSource.gallery, maxHeight: 400, maxWidth: 400);

    if (picture != null) {
      File rotatedImage =
          await FlutterExifRotation.rotateAndSaveImage(path: picture.path);
      setState(() {
        imageFile = rotatedImage;
        print(imageFile);
      });
      Navigator.of(context).maybePop();
    }
  }

  _selectDate(BuildContext context) async {
    final DateTime selected = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(1975),
      lastDate: DateTime.now(),
    );
    if (selected != null && selected != "") {
      setState(() {
        var outputFormat = DateFormat('yyyy-MM-dd');
        dob = outputFormat.format(selected);
      });
    } else {
      print(selected);
    }
  }

  bool validate() {
    var email = emailcontroller.text.toString();
    var name = _nameController.text.toString();
    var phone = _phonecontroller.text.toString();
    bool isValidPhoneNumber(String value) =>
        RegExp(r'(^[\+]?[(]?[0-9]{3}[)]?[-\s\.]?[0-9]{3}[-\s\.]?[0-9]{4,6}$)').hasMatch(value ?? '');
    if (name == "") {
      CommonDialog.showsnackbar("Please enter name.");
      return false;
    } else if (email == "" || email == null) {
      CommonDialog.showsnackbar("Please enter email");
      return false;
    } else if (!isEmail(email)) {
      CommonDialog.showsnackbar("Please enter valid email ");
      return false;
    } else if (phone == "" || phone == null) {
      CommonDialog.showsnackbar("Please enter phone no. ");
      return false;
    } else if (isValidPhoneNumber(emailcontroller.text.toString())) {
      CommonDialog.showsnackbar("Please enter valid mobile no");
    } else if (imageFile == null) {
      CommonDialog.showsnackbar("Please choose image.");
      return false;
    } else if (dob == "") {
      CommonDialog.showsnackbar("Please select dob.");
      return false;
    } else if (showselectGender == "") {
      CommonDialog.showsnackbar("Please select gender.");
      return false;
    }
    return true;
  }

  bool isEmail(String em) {
    String p =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regExp = new RegExp(p);
    return regExp.hasMatch(em);
  }
}
