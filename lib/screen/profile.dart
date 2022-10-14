import 'dart:io';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_exif_rotation/flutter_exif_rotation.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:untitled/controller/profile_controllet.dart';
import 'package:untitled/screen/login.dart';
import 'package:untitled/screen/profile_update.dart';
import 'package:untitled/model/MyBookingPojo.dart';
import 'package:sticky_grouped_list/sticky_grouped_list.dart';
import 'package:http/http.dart' as http;
import '../utils/CommomDialog.dart';
import '../utils/Utils.dart';
import '../utils/appconstant.dart';
import 'sidenavigation.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  ProfileController profileController = Get.put(ProfileController());
  late TextEditingController emailcontroller,
      _nameController,
      _dobController,
      _phonecontroller;
  String date = "";
  var session="";

  // Initial Selected Value
  String dropdownvalue = 'Male';
  final list = ['Male', 'Female'];

  var imageFile;
  DateTime selectedDate = DateTime.now();
  var genderSelect = "";
  var dob = "";
  var dropdown;
  var showselectGender = "";
  var name = "";
  var email = "";
  var phone = "";
  var iamge = "";
  late SharedPreferences sharedPreferences;
  GlobalKey<ScaffoldState> scaffolKey = GlobalKey<ScaffoldState>();

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
    _nameController = TextEditingController();
    emailcontroller = TextEditingController();
    _phonecontroller = TextEditingController();
    _dobController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    SharedPreferences.getInstance().then((SharedPreferences sp) {
      sharedPreferences = sp;
      var _testValue = sharedPreferences.getString("name");
      var emailValue = sharedPreferences.getString("email");
      var _imageValue = sharedPreferences.getString("image");
      var _phoneValue = sharedPreferences.getString("phoneno");
      var _sessss = sharedPreferences.getString("session");

      setState(() {
        if (_sessss != null) {
          session = _sessss;
          name = _testValue!;
          email = emailValue!;
          phone = _phoneValue!;
          iamge = _imageValue!;
        }
        else {
          name = "";
          email = "";
          phone = "";
          iamge = "";
        }
        //  print(name+" "+email+" "+phone+" "+_imageValue);
      });
      // will be null if never previously saved
      // print("SDFKLDFKDKLFKDLFKLDFKL  " + "${_testValue}");
    });
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    List<SlotDetail> _element = [];
    return SafeArea(
      child: Container(
        width: width,
        height: height,
        decoration: const BoxDecoration(
            color: Colors.white,

            image: DecorationImage(
                image: AssetImage('images/svgicons/profilebackgound.png'),
                fit: BoxFit.fill)),
        child: Scaffold(
            resizeToAvoidBottomInset: true,
            key: scaffolKey,
            drawer: session == null||session==""
                ? Container()
                : SideNavigatinPage(
                    "${name}", "${iamge}", "${email}", "${phone}"),
            appBar: AppBar(
              centerTitle: false,
              elevation: 0.0,
              backgroundColor: Color(Utils.hexStringToHexInt('77ACA2')),
              leading: InkWell(
                onTap: () {
                  session != ""
                      ? scaffolKey.currentState!.openDrawer()
                      : null;
                },
                child: Icon(
                  Icons.menu,
                  color: Colors.white,
                ),
              ),
              titleSpacing: 0,
              title: Text(
                'Profile',
                style: TextStyle(
                    fontFamily: 'Poppins Regular',
                    color: Colors.white,
                    fontSize: width * 0.04),
              ),
              actions: <Widget>[
                Container(
                  margin: EdgeInsets.only(right: width * 0.01),
                  child: SvgPicture.asset(
                    "images/svgicons/dissabledisco.svg",
                  ),
                )
              ],
            ),
            backgroundColor: Colors.transparent,
            body: session == null||session==""
                ? Center(
                    child: Container(
                    width: width,
                    height: height,
                    child: Center(
                        child: Container(
                      child: InkWell(
                        onTap: (){
                          Get.offAll(LoginPage());

                        },
                        child: Container(
                          height: width*0.2,
                          width: height*0.3,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12.0),
                            color: Color(Utils.hexStringToHexInt('77ACA2')),
                          ),
                          child: Center(
                            child: Text("Continue with login",
                              style: TextStyle(
                                color:
                               Colors.white,
                                fontSize: width * 0.05,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Poppins Semibold',
                              ),),
                          ),
                        ),
                      ),
                    )),
                  ))
                : GetBuilder<ProfileController>(builder: (profileController) {
                    if (profileController.lodaer) {
                      return Container();
                    } else {
                      for (var i = 0;
                      i < profileController.bookingPojo.value.slotDetail!.length;
                      i++) {
                        _element
                            .add(profileController.bookingPojo.value.slotDetail![i]);
                      }
                      return SingleChildScrollView(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            SizedBox(
                              height: height * 0.07,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                CircleAvatar(
                                  radius: width * 0.2 - width * 0.06,
                                  backgroundImage: NetworkImage(
                                      profileController.profilePojo.value.data!
                                          .profileImage!),
                                )
                              ],
                            ),
                            SizedBox(
                              height: height * 0.04,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Container(
                                  margin: EdgeInsets.only(left: width * 0.06),
                                  child: Text(
                                    'Personal Details',
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: width * 0.03,
                                        fontFamily: 'Poppins Medium'),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    Get.to(ProfileUpdate());

                                    //  _profileUpdate(context,width,height);
                                  },
                                  child: Container(
                                    margin:
                                        EdgeInsets.only(right: width * 0.02),
                                    width: width * 0.2,
                                    height: height * 0.03,
                                    decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(width * 0.01),
                                        color: Color(Utils.hexStringToHexInt(
                                            '#ecfafb'))),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: <Widget>[
                                        Center(
                                          child: SvgPicture.asset(
                                            "images/svgicons/modify.svg",
                                          ),
                                        ),
                                        Text(
                                          'Modify',
                                          style: TextStyle(
                                              fontSize: width * 0.02,
                                              fontFamily: 'Poppins Regular',
                                              color: Color(
                                                  Utils.hexStringToHexInt(
                                                      '46D0D9'))),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Container(
                              margin: EdgeInsets.only(left: width * 0.06),
                              child: SizedBox(
                                width: width * 0.09,
                                child: Divider(
                                  thickness: 3,
                                  color:
                                      Color(Utils.hexStringToHexInt('77ACA2')),
                                ),
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(left: width * 0.06),
                              width: width,
                              child: Column(
                                children: <Widget>[
                                  Row(
                                    children: <Widget>[
                                      Text(
                                        'Name',
                                        textAlign: TextAlign.left,
                                        style: TextStyle(
                                            color: Color(
                                                Utils.hexStringToHexInt(
                                                    'A3A2A2')),
                                            fontFamily: 'Poppins Regular',
                                            fontSize: width * 0.03),
                                      ),
                                      SizedBox(
                                        width: width * 0.06,
                                      ),
                                      Text(
                                        profileController.profilePojo.value
                                                        .data!.name
                                                        .toString() +
                                                    "" !=
                                                ""
                                            ? profileController.profilePojo
                                                    .value.data!.name
                                                    .toString() +
                                                ""
                                            : "N/A",
                                        textAlign: TextAlign.left,
                                        style: TextStyle(
                                            color: Color(
                                                Utils.hexStringToHexInt(
                                                    'A3A2A2')),
                                            fontFamily: 'Poppins Regular',
                                            fontSize: width * 0.04),
                                      )
                                    ],
                                  ),
                                  SizedBox(
                                    height: height * 0.01,
                                  ),
                                  Row(
                                    children: <Widget>[
                                      Text(
                                        'Email',
                                        textAlign: TextAlign.left,
                                        style: TextStyle(
                                            color: Color(
                                                Utils.hexStringToHexInt(
                                                    'A3A2A2')),
                                            fontFamily: 'Poppins Regular',
                                            fontSize: width * 0.03),
                                      ),
                                      SizedBox(
                                        width: width * 0.06,
                                      ),
                                      Text(
                                        profileController.profilePojo.value
                                                        .data!.email
                                                        .toString() +
                                                    "" !=
                                                ""
                                            ? profileController.profilePojo
                                                    .value.data!.email
                                                    .toString() +
                                                ""
                                            : "N/A",
                                        textAlign: TextAlign.left,
                                        style: TextStyle(
                                            color: Color(
                                                Utils.hexStringToHexInt(
                                                    'A3A2A2')),
                                            fontFamily: 'Poppins Regular',
                                            fontSize: width * 0.04),
                                      )
                                    ],
                                  ),
                                  SizedBox(
                                    height: height * 0.01,
                                  ),
                                  Row(
                                    children: <Widget>[
                                      Text(
                                        'Contact',
                                        textAlign: TextAlign.left,
                                        style: TextStyle(
                                            color: Color(
                                                Utils.hexStringToHexInt(
                                                    'A3A2A2')),
                                            fontFamily: 'Poppins Regular',
                                            fontSize: width * 0.03),
                                      ),
                                      SizedBox(
                                        width: width * 0.04,
                                      ),
                                      Text(
                                        profileController.profilePojo.value
                                                        .data!.phone
                                                        .toString() +
                                                    "" !=
                                                ""
                                            ? profileController.profilePojo
                                                    .value.data!.phone
                                                    .toString() +
                                                ""
                                            : "N/A",
                                        textAlign: TextAlign.left,
                                        style: TextStyle(
                                            color: Color(
                                                Utils.hexStringToHexInt(
                                                    'A3A2A2')),
                                            fontFamily: 'Poppins Regular',
                                            fontSize: width * 0.04),
                                      )
                                    ],
                                  ),
                                  SizedBox(
                                    height: height * 0.01,
                                  ),
                                  Row(
                                    children: <Widget>[
                                      Text(
                                        'DOB',
                                        textAlign: TextAlign.left,
                                        style: TextStyle(
                                            color: Color(
                                                Utils.hexStringToHexInt(
                                                    'A3A2A2')),
                                            fontFamily: 'Poppins Regular',
                                            fontSize: width * 0.03),
                                      ),
                                      SizedBox(
                                        width: width * 0.06,
                                      ),
                                      Text(
                                        " " +
                                                    profileController
                                                        .profilePojo
                                                        .value
                                                        .data!
                                                        .dob
                                                        .toString() +
                                                    "" !=
                                                ""
                                            ? "  " +
                                                "${DateFormat.yMMMMd().format(DateTime.parse(profileController.profilePojo.value.data!.dob.toString()))}" +
                                                ""
                                            : "N/A",
                                        textAlign: TextAlign.left,
                                        style: TextStyle(
                                            color: Color(
                                                Utils.hexStringToHexInt(
                                                    'A3A2A2')),
                                            fontFamily: 'Poppins Regular',
                                            fontSize: width * 0.04),
                                      )
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: height * 0.02,
                            ),
                            Divider(
                              thickness: 1,
                            ),

                            Container(
                                margin: EdgeInsets.only(left: width * 0.06),
                                child: Utils().titleText('My Bookings', context)),
                            ConstrainedBox(
                              constraints: BoxConstraints(
                                minHeight: 0.2,
                                maxHeight: height * 0.5,
                              ),
                              child:
                              StickyGroupedListView<SlotDetail, DateTime>(
                                elements: _element,
                                order: StickyGroupedListOrder.ASC,
                                groupBy: (SlotDetail element) => DateTime(
                                  element.date!.year,
                                  element.date!.month,
                                  element.date!.day,
                                ),
                                groupComparator:
                                    (DateTime value1, DateTime value2) =>
                                    value2.compareTo(value1),
                                itemComparator: (SlotDetail element1,
                                    SlotDetail element2) =>
                                    element1.date!.compareTo(element2.date!),
                                floatingHeader: false,
                                groupSeparatorBuilder: _getGroupSeparator,
                                itemBuilder: _getItem,
                              ),
                            ),


                          ],
                        ),
                      );
                    }
                  })),
      ),
    );
  }


  Widget _getGroupSeparator(SlotDetail element) {
    return SizedBox(
      height: 50,
      child: Align(
        alignment: Alignment.center,
        child: Container(
          width: 120,
          decoration: BoxDecoration(
            color: Colors.blue[300],
            border: Border.all(
              color: Colors.blue[300]!,
            ),
            borderRadius: const BorderRadius.all(Radius.circular(20.0)),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              '${element.date!.day}- ${element.date!.month}- ${element.date!.year}',
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }

  Widget recentleavelistbottom(width, height, contet, List<SlotDetail>? slotDetail) {
    return ListView.builder(
        scrollDirection: Axis.vertical,
        itemCount: slotDetail!.length,
        shrinkWrap: true,
        itemBuilder: (context, position) {
          return Container(
            width: width,
            padding: EdgeInsets.all(width * 0.03),
            margin: EdgeInsets.all(width * 0.01),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(width * 0.02)),
                border: Border.all(color: Colors.black26, width: 2)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    IntrinsicHeight(
                      child: Row(
                        children: <Widget>[
                          Container(
                            width: width * 0.2,
                            child: Text(
                              '${slotDetail[position].toTime}',
                              style: TextStyle(
                                  color: Color(Utils.hexStringToHexInt('26578C')),
                                  fontFamily: 'Poppins Semibold',
                                  fontSize: width * 0.03),
                            ),
                          ),
                          SizedBox(
                            width: width * 0.02,
                          ),
                          Container(
                            width: 1,
                            height: height * 0.06,
                            color: Colors.black,
                            padding: const EdgeInsets.only(left: 12, right: 12),
                          ),
                          SizedBox(
                            width: width * 0.02,
                          )
                        ],
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          '${slotDetail[position].shopName}',
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: width * 0.03,
                              fontFamily: 'Poppins Regular'),
                        ),
                        Text('${slotDetail[position].bookingId}',
                            style: TextStyle(
                                fontSize: width * 0.02,
                                fontFamily: 'Poppins Regular',
                                color: Color(Utils.hexStringToHexInt('6B6868'))),
                            textAlign: TextAlign.center),
                      ],
                    )
                  ],
                ),
                slotDetail[position].status == "Accepted"
                    ? InkWell(
                  onTap: () async {},
                  child: Container(
                    width: width * 0.2,
                    height: 28,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(6.0),
                        color: Colors.cyan),
                    child: const Center(
                      child: Text(
                        "Accepted",
                        style: TextStyle(color: Colors.white, fontSize: 12),
                      ),
                    ),
                  ),
                )
                    : slotDetail[position].status == "Pending"
                    ? InkWell(
                  onTap: () async {},
                  child: Container(
                    width: width * 0.2,
                    height: 28,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(6.0),
                        color: Colors.cyan),
                    child: const Center(
                      child: Text(
                        "Confirm",
                        style:
                        TextStyle(color: Colors.white, fontSize: 12),
                      ),
                    ),
                  ),
                )
                    : slotDetail[position].status == "Completed"
                    ? InkWell(
                  onTap: () async {
                    setState(() {
                      _show(context, slotDetail[position].id!);
                    });
                  },
                  child: Container(
                    height: 28,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(6.0),
                        color: Colors.lightGreen),
                    child: const Center(
                      child: Padding(
                        padding: EdgeInsets.all(4.0),
                        child: Text(
                          "Give Feedback",
                          style: TextStyle(
                              color: Colors.white, fontSize: 12),
                        ),
                      ),
                    ),
                  ),
                )
                    : InkWell(
                  onTap: () async {},
                  child: Container(
                    width: width * 0.2,
                    height: 28,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(6.0),
                        color: Colors.red),
                    child: const Center(
                      child: const Text(
                        "Rejected",
                        style: const TextStyle(
                            color: Colors.white, fontSize: 12),
                      ),
                    ),
                  ),
                )
              ],
            ),
          );
        });
  }
  Widget _getItem(context, SlotDetail slotDetail) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return InkWell(
      onTap: () {
        var width = MediaQuery.of(context).size.width;
        var height = MediaQuery.of(context).size.height;
        showDialog(
          context: context,
          builder: (BuildContext context) {
            List<Service> tempArray = [];

            return AlertDialog(
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    "Order detail of ${slotDetail.bookingId}",
                    style: TextStyle(
                        fontFamily: 'Poppins Regular',
                        color: Colors.black,
                        fontSize: width * 0.03),
                  ),
                  IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: const Icon(
                        Icons.close,
                      ))
                ],
              ),
              content: StatefulBuilder(
                // You need this, notice the parameters below:
                builder: (BuildContext context, StateSetter setState) {
                  return Container(
                      width: width,
                      height: height * 0.5,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text(
                                "Name",
                                style: TextStyle(
                                    fontFamily: 'Poppins Regular',
                                    color: Color(
                                        Utils.hexStringToHexInt('C4C4C4')),
                                    fontSize: width * 0.03),
                              ),
                              Text(
                                "${slotDetail.userName}",
                                style: TextStyle(
                                    fontFamily: 'Poppins Regular',
                                    color: Color(
                                        Utils.hexStringToHexInt('C4C4C4')),
                                    fontSize: width * 0.03),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text(
                                "BookingID",
                                style: TextStyle(
                                    fontFamily: 'Poppins Regular',
                                    color: Color(
                                        Utils.hexStringToHexInt('C4C4C4')),
                                    fontSize: width * 0.03),
                              ),
                              Text(
                                "${slotDetail.bookingId}",
                                style: TextStyle(
                                    fontFamily: 'Poppins Regular',
                                    color: Color(
                                        Utils.hexStringToHexInt('C4C4C4')),
                                    fontSize: width * 0.03),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text(
                                "Booking Date",
                                style: TextStyle(
                                    fontFamily: 'Poppins Regular',
                                    color: Color(
                                        Utils.hexStringToHexInt('C4C4C4')),
                                    fontSize: width * 0.03),
                              ),
                              Text(
                                  "${slotDetail.date!.day}-${slotDetail.date!.month}-${slotDetail.date!.year}",
                                  style: TextStyle(
                                      fontFamily: 'Poppins Regular',
                                      color: Color(
                                          Utils.hexStringToHexInt('C4C4C4')),
                                      fontSize: width * 0.03)),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text(
                                "Payment Mode",
                                style: TextStyle(
                                    fontFamily: 'Poppins Regular',
                                    color: Color(
                                        Utils.hexStringToHexInt('C4C4C4')),
                                    fontSize: width * 0.03),
                              ),
                              Text(
                                  "${slotDetail.payment_type == null ? "" : slotDetail.payment_type}",
                                  style: TextStyle(
                                      fontFamily: 'Poppins Regular',
                                      color: Color(
                                          Utils.hexStringToHexInt('C4C4C4')),
                                      fontSize: width * 0.03)),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text(
                                "Transaction id",
                                style: TextStyle(
                                    fontFamily: 'Poppins Regular',
                                    color: Color(
                                        Utils.hexStringToHexInt('C4C4C4')),
                                    fontSize: width * 0.03),
                              ),
                              Text("${slotDetail.transaction_id}",
                                  style: TextStyle(
                                      fontFamily: 'Poppins Regular',
                                      color: Color(
                                          Utils.hexStringToHexInt('C4C4C4')),
                                      fontSize: width * 0.03)),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text(
                                "Coupon Code",
                                style: TextStyle(
                                    fontFamily: 'Poppins Regular',
                                    color: Color(
                                        Utils.hexStringToHexInt('C4C4C4')),
                                    fontSize: width * 0.03),
                              ),
                              Text(
                                  "${slotDetail.coupon_code == null ? "N/A" : slotDetail.coupon_code}",
                                  style: TextStyle(
                                      fontFamily: 'Poppins Regular',
                                      color: Color(
                                          Utils.hexStringToHexInt('C4C4C4')),
                                      fontSize: width * 0.03)),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text(
                                "Coin ",
                                style: TextStyle(
                                    fontFamily: 'Poppins Regular',
                                    color: Color(
                                        Utils.hexStringToHexInt('C4C4C4')),
                                    fontSize: width * 0.03),
                              ),
                              Text(
                                  "${slotDetail.coin == null ? "N/A" : slotDetail.coin} (100 coins = ₹ 1)",
                                  style: TextStyle(
                                      fontFamily: 'Poppins Regular',
                                      color: Color(
                                          Utils.hexStringToHexInt('C4C4C4')),
                                      fontSize: width * 0.03)),
                            ],
                          ),
                          LimitedBox(
                            maxHeight: height * 0.3,
                            child: ListView.builder(
                                itemCount: slotDetail.service!.length,
                                itemBuilder: (context, position) {
                                  return Container(
                                    height: height * 0.03,
                                    margin: const EdgeInsets.only(
                                        left: 4, right: 4),
                                    child: Container(
                                      width: width,
                                      child: Row(
                                        mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          Column(
                                            mainAxisAlignment:
                                            MainAxisAlignment.center,
                                            crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                            children: <Widget>[
                                              Text(
                                                "${slotDetail.service![position].name}",
                                                style: const TextStyle(
                                                    fontSize: 8.0),
                                              ),
                                            ],
                                          ),
                                          Text(
                                            "${slotDetail.service![position].price}",
                                            style:
                                            const TextStyle(fontSize: 8.0),
                                          )
                                        ],
                                      ),
                                    ),
                                  );
                                }),
                          )
                        ],
                      ));
                },
              ),
            );
          },
        );
      },
      child:
      Container(
        width: width,
        padding: EdgeInsets.all(width * 0.03),
        margin: EdgeInsets.all(width * 0.03),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(width * 0.02)),
            border: Border.all(color: Colors.black26, width: 2)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Row(
              children: <Widget>[
                IntrinsicHeight(
                  child: Row(
                    children: <Widget>[
                      Container(
                        width: width * 0.2-width*0.03,
                        child: Text(
                          '${slotDetail.toTime}',
                          style: TextStyle(
                              color: Color(Utils.hexStringToHexInt('26578C')),
                              fontFamily: 'Poppins Semibold',
                              fontSize: width * 0.03),
                        ),
                      ),
                      SizedBox(
                        width: width * 0.02,
                      ),
                      Container(
                        width: 1,
                        height: height * 0.06,
                        color: Colors.black,
                        padding: const EdgeInsets.only(left: 12, right: 12),
                      ),
                      SizedBox(
                        width: width * 0.02,
                      )
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      '${slotDetail.shopName}',
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: width * 0.03,
                          fontFamily: 'Poppins Regular'),
                    ),
                    Text('${slotDetail.bookingId}',
                        style: TextStyle(
                            fontSize: width * 0.02,
                            fontFamily: 'Poppins Regular',
                            color: Color(Utils.hexStringToHexInt('6B6868'))),
                        textAlign: TextAlign.center),
                  ],
                )
              ],
            ),
            slotDetail.status == "Accepted"
                ? InkWell(
              onTap: () async {},
              child: Container(
                width: width * 0.2,
                height: 28,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(6.0),
                    color: Colors.cyan),
                child: const Center(
                  child: Text(
                    "Accepted",
                    style: TextStyle(color: Colors.white, fontSize: 12),
                  ),
                ),
              ),
            )
                : slotDetail.status == "Pending"
                ? InkWell(
              onTap: () async {},
              child: Container(
                width: width * 0.2,
                height: 28,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(6.0),
                    color: Colors.cyan),
                child: const Center(
                  child: Text(
                    "Confirm",
                    style:
                    TextStyle(color: Colors.white, fontSize: 12),
                  ),
                ),
              ),
            )
                : slotDetail.status == "Completed"
                ? InkWell(
              onTap: () async {
                setState(() {
                  _show(context, slotDetail.id!);
                });
              },
              child: Container(
                height: 28,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(6.0),
                    color: Colors.lightGreen),
                child: const Center(
                  child: Padding(
                    padding: EdgeInsets.all(4.0),
                    child: Text(
                      "Give Feedback",
                      style: TextStyle(
                          color: Colors.white, fontSize: 12),
                    ),
                  ),
                ),
              ),
            )
                : InkWell(
              onTap: () async {},
              child: Container(
                width: width * 0.2,
                height: 28,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(6.0),
                    color: Colors.red),
                child: const Center(
                  child: const Text(
                    "Rejected",
                    style: const TextStyle(
                        color: Colors.white, fontSize: 12),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  void _show(BuildContext ctx, bookingid) {
    var ratingg = 0.0;
    var width = MediaQuery.of(ctx).size.width;
    var height = MediaQuery.of(ctx).size.height;
    showModalBottomSheet(
        shape: const RoundedRectangleBorder(
          // <-- SEE HERE
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(35.0),
          ),
        ),
        elevation: 10,
        backgroundColor: Colors.transparent,
        context: ctx,
        builder: (ctx) => Container(
          width: 300,
          height: 600,
          color: Colors.white,
          alignment: Alignment.center,
          child: Column(
            children: <Widget>[
              SizedBox(
                height: height * 0.05,
              ),
              Text(
                "Rate this booking",
                style: TextStyle(
                    color: Colors.black,
                    fontFamily: 'Poppins Medium',
                    fontSize: width * 0.06),
              ),
              SizedBox(
                height: height * 0.05,
              ),
              SizedBox(
                width: width,
                child: Padding(
                  padding: const EdgeInsets.only(left: 18.0, right: 18),
                  child: TextField(
                    textCapitalization: TextCapitalization.sentences,
                    onChanged: (value) {
                      setState(() {});
                    },
                    keyboardType: TextInputType.multiline,
                    maxLines: 1,
                    controller: _nameController,
                    style: TextStyle(
                        color: Colors.black,
                        fontFamily: 'Poppins Medium',
                        fontSize: width * 0.05),
                    decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: "Enter you feedback here..."),
                  ),
                ),
              ),
              SizedBox(
                height: height * 0.03,
              ),
              RatingBar.builder(
                initialRating: 1,
                itemCount: 5,
                itemSize: 54,
                itemBuilder: (context, index) {
                  switch (index) {
                    case 0:
                      return const Icon(
                        Icons.sentiment_very_dissatisfied,
                        color: Colors.red,
                        size: 26,
                      );
                    case 1:
                      return const Icon(
                        Icons.sentiment_dissatisfied,
                        color: Colors.redAccent,
                        size: 26,
                      );
                    case 2:
                      return const Icon(
                        Icons.sentiment_neutral,
                        color: Colors.amber,
                        size: 26,
                      );
                    case 3:
                      return const Icon(
                        Icons.sentiment_satisfied,
                        color: Colors.lightGreen,
                        size: 26,
                      );
                    case 4:
                      return const Icon(
                        Icons.sentiment_very_satisfied,
                        color: Colors.green,
                        size: 26,
                      );
                  }
                  return Container();
                },
                onRatingUpdate: (rating) {
                  print(rating);
                  ratingg = rating;
                },
              ),
              SizedBox(
                height: height * 0.03,
              ),
              FlatButton(
                padding: EdgeInsets.all(6.0),
                color: Color(Utils.hexStringToHexInt('46D0D9')),
                textColor: Colors.white,
                child: Text('OK'),
                onPressed: () async {
                  Map map = {
                    "session_id": session,
                    "comment": _nameController.text.toString(),
                    "booking_id": "$bookingid",
                    "rating": ratingg.toString() + ""
                  };
                  print(map);
                  var apiUrl = Uri.parse(
                      AppConstant.BASE_URL + "public/api/rate-shop");
                  print(apiUrl);
                  print(map);
                  final response = await http.post(
                    apiUrl,
                    body: map,
                  );
                  print(response.body);
                  // _textFieldControllerupdateABout
                  //     .clear();
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        ));
  }
  void openDiaolog(width, height) {
    Get.bottomSheet(
      Container(
        width: width,
        height: height,
        color: Colors.red,
        child: Column(
          children: <Widget>[
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
                                fit: BoxFit.fill)),
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
            Text("Update profile Photo",
                style: TextStyle(
                  color: Color(Utils.hexStringToHexInt('77ACA2')),
                  fontSize: width * 0.05,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Poppins Medium',
                ),
                textAlign: TextAlign.end),
            SizedBox(
              height: height * 0.1,
            ),
            Utils().titleTextsemibold('Update profile', context),
            SizedBox(
              height: height * 0.02,
            ),
            Center(
              child: Text(
                'Please enter the details below to update your profile.',
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
              margin: EdgeInsets.only(left: width * 0.08, right: width * 0.08),
              child: Column(
                children: <Widget>[
                  Container(
                    width: width - 5,
                    height: height * 0.1 - height * 0.04,
                    padding: const EdgeInsets.only(left: 6),
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(Radius.circular(4)),
                      color: Color(Utils.hexStringToHexInt('F4F4F4')),
                    ),
                    child:
                    TextField(
                        style: const TextStyle(
                          color: Colors.black,
                        ),
                        textAlignVertical: TextAlignVertical.center,
                        textAlign: TextAlign.left,
                        controller: _nameController,
                        decoration: InputDecoration(
                            hintText: 'Name',
                            hintStyle: TextStyle(
                                color: Color(Utils.hexStringToHexInt('A4A4A4')),
                                fontFamily: 'Poppins Regular',
                                fontSize: width * 0.03),
                            border: InputBorder.none)),
                  ),
                  Container(
                    width: width - 5,
                    height: height * 0.1 - height * 0.04,
                    margin: const EdgeInsets.only(top: 6),
                    padding: const EdgeInsets.only(left: 6),
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(Radius.circular(4)),
                      color: Color(Utils.hexStringToHexInt('F4F4F4')),
                    ),
                    child: TextField(
                        style: const TextStyle(
                          color: Colors.black,
                        ),
                        textAlignVertical: TextAlignVertical.center,
                        textAlign: TextAlign.left,
                        controller: emailcontroller,
                        decoration: InputDecoration(
                            hintText: 'Email',
                            hintStyle: TextStyle(
                                color: Color(Utils.hexStringToHexInt('A4A4A4')),
                                fontFamily: 'Poppins Regular',
                                fontSize: width * 0.03),
                            border: InputBorder.none)),
                  ),
                  Container(
                    width: width - 5,
                    height: height * 0.1 - height * 0.04,
                    margin: const EdgeInsets.only(top: 6),
                    padding: const EdgeInsets.only(left: 6),
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(Radius.circular(4)),
                      color: Color(Utils.hexStringToHexInt('F4F4F4')),
                    ),
                    child: TextField(
                        style: const TextStyle(
                          color: Colors.black,
                        ),
                        textAlignVertical: TextAlignVertical.center,
                        textAlign: TextAlign.left,
                        controller: _phonecontroller,
                        decoration: InputDecoration(
                            hintText: 'Phone',
                            hintStyle: TextStyle(
                                color: Color(Utils.hexStringToHexInt('A4A4A4')),
                                fontFamily: 'Poppins Regular',
                                fontSize: width * 0.03),
                            border: InputBorder.none)),
                  ),
                  Row(
                    children: <Widget>[
                      GestureDetector(
                        onTap: () {
                          _selectDate(context);
                        },
                        child: Container(
                          width: width - 5,
                          height: height * 0.1 - height * 0.04,
                          margin: const EdgeInsets.only(top: 6),
                          padding: const EdgeInsets.only(left: 6),
                          decoration: BoxDecoration(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(4)),
                            color: Color(Utils.hexStringToHexInt('F4F4F4')),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text(
                                dob == "" ? "Date of birth" : dob,
                                style: TextStyle(
                                    color: Color(
                                        Utils.hexStringToHexInt('A4A4A4')),
                                    fontFamily: 'Poppins Regular',
                                    fontSize: width * 0.03),
                              ),
                              const Icon(
                                Icons.calendar_today,
                                color: Colors.black,
                              )
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 6,
                      ),
                      Container(
                        width: width - 5,
                        height: height * 0.1 - height * 0.04,
                        margin: const EdgeInsets.only(top: 6),
                        padding: const EdgeInsets.only(left: 6),
                        decoration: BoxDecoration(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(4)),
                          color: Color(Utils.hexStringToHexInt('F4F4F4')),
                        ),
                        child: DropdownButton(
                          icon: const Icon(Icons.keyboard_arrow_down),
                          hint: Text(
                            "${showselectGender == "" ? "Gender" : showselectGender}",
                            style: TextStyle(
                                color: Color(Utils.hexStringToHexInt('A4A4A4')),
                                fontFamily: 'Poppins Regular',
                                fontSize: width * 0.03),
                          ),
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
                      )
                    ],
                  )
                ],
              ),
            ),
            SizedBox(
              height: height * 0.04,
            ),
            GestureDetector(
              onTap: () {
                CommonDialog.showsnackbar(date);

                // authControlller.registerUser(
                //     imageFile,
                //     _nameController.text.toString(),
                //     emailcontroller.text.toString(),
                //     dob,
                //     showselectGender,
                //     _phonecontroller.text.toString(),
                //     "android",
                //     "sdfsdfsdfsdf");
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
    );
  }

  Future _profileUpdate(BuildContext context, width, height) {
    return showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext) {
          return SimpleDialog(
            contentPadding: EdgeInsets.symmetric(horizontal: 10),
            title: Text("Profile update"),
            children: <Widget>[
              Container(
                width: width,
                height: height,
                color: Colors.red,
                child: Column(
                  children: <Widget>[
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
                                        fit: BoxFit.fill)),
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
                    Text("Update profile Photo",
                        style: TextStyle(
                          color: Color(Utils.hexStringToHexInt('77ACA2')),
                          fontSize: width * 0.05,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Poppins Medium',
                        ),
                        textAlign: TextAlign.end),
                    SizedBox(
                      height: height * 0.1,
                    ),
                    Utils().titleTextsemibold('Update profile', context),
                    SizedBox(
                      height: height * 0.02,
                    ),
                    Center(
                      child: Text(
                        'Please enter the details below to update your profile.',
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
                      margin: EdgeInsets.only(
                          left: width * 0.08, right: width * 0.08),
                      child: Column(
                        children: <Widget>[
                          Container(
                            width: width - 5,
                            height: height * 0.1 - height * 0.04,
                            padding: const EdgeInsets.only(left: 6),
                            decoration: BoxDecoration(
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(4)),
                              color: Color(Utils.hexStringToHexInt('F4F4F4')),
                            ),
                            child: TextField(
                                style: const TextStyle(
                                  color: Colors.black,
                                ),
                                textAlignVertical: TextAlignVertical.center,
                                textAlign: TextAlign.left,
                                controller: _nameController,
                                decoration: InputDecoration(
                                    hintText: 'Name',
                                    hintStyle: TextStyle(
                                        color: Color(
                                            Utils.hexStringToHexInt('A4A4A4')),
                                        fontFamily: 'Poppins Regular',
                                        fontSize: width * 0.03),
                                    border: InputBorder.none)),
                          ),
                          Container(
                            width: width - 5,
                            height: height * 0.1 - height * 0.04,
                            margin: const EdgeInsets.only(top: 6),
                            padding: const EdgeInsets.only(left: 6),
                            decoration: BoxDecoration(
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(4)),
                              color: Color(Utils.hexStringToHexInt('F4F4F4')),
                            ),
                            child: TextField(
                                style: const TextStyle(
                                  color: Colors.black,
                                ),
                                textAlignVertical: TextAlignVertical.center,
                                textAlign: TextAlign.left,
                                controller: emailcontroller,
                                decoration: InputDecoration(
                                    hintText: 'Email',
                                    hintStyle: TextStyle(
                                        color: Color(
                                            Utils.hexStringToHexInt('A4A4A4')),
                                        fontFamily: 'Poppins Regular',
                                        fontSize: width * 0.03),
                                    border: InputBorder.none)),
                          ),
                          Container(
                            width: width - 5,
                            height: height * 0.1 - height * 0.04,
                            margin: const EdgeInsets.only(top: 6),
                            padding: const EdgeInsets.only(left: 6),
                            decoration: BoxDecoration(
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(4)),
                              color: Color(Utils.hexStringToHexInt('F4F4F4')),
                            ),
                            child: TextField(
                                style: const TextStyle(
                                  color: Colors.black,
                                ),
                                textAlignVertical: TextAlignVertical.center,
                                textAlign: TextAlign.left,
                                controller: _phonecontroller,
                                decoration: InputDecoration(
                                    hintText: 'Phone',
                                    hintStyle: TextStyle(
                                        color: Color(
                                            Utils.hexStringToHexInt('A4A4A4')),
                                        fontFamily: 'Poppins Regular',
                                        fontSize: width * 0.03),
                                    border: InputBorder.none)),
                          ),
                          Row(
                            children: <Widget>[
                              GestureDetector(
                                onTap: () {
                                  _selectDate(context);
                                },
                                child: Container(
                                  width: width - 5,
                                  height: height * 0.1 - height * 0.04,
                                  margin: const EdgeInsets.only(top: 6),
                                  padding: const EdgeInsets.only(left: 6),
                                  decoration: BoxDecoration(
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(4)),
                                    color: Color(
                                        Utils.hexStringToHexInt('F4F4F4')),
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Text(
                                        dob == "" ? "Date of birth" : dob,
                                        style: TextStyle(
                                            color: Color(
                                                Utils.hexStringToHexInt(
                                                    'A4A4A4')),
                                            fontFamily: 'Poppins Regular',
                                            fontSize: width * 0.03),
                                      ),
                                      const Icon(
                                        Icons.calendar_today,
                                        color: Colors.black,
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(
                                width: 6,
                              ),
                              Container(
                                width: width - 5,
                                height: height * 0.1 - height * 0.04,
                                margin: const EdgeInsets.only(top: 6),
                                padding: const EdgeInsets.only(left: 6),
                                decoration: BoxDecoration(
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(4)),
                                  color:
                                      Color(Utils.hexStringToHexInt('F4F4F4')),
                                ),
                                child: DropdownButton(
                                  icon: const Icon(Icons.keyboard_arrow_down),
                                  hint: Text(
                                    "${showselectGender == "" ? "Gender" : showselectGender}",
                                    style: TextStyle(
                                        color: Color(
                                            Utils.hexStringToHexInt('A4A4A4')),
                                        fontFamily: 'Poppins Regular',
                                        fontSize: width * 0.03),
                                  ),
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
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      height: height * 0.04,
                    ),
                    GestureDetector(
                      onTap: () {
                        CommonDialog.showsnackbar(date);

                        // authControlller.registerUser(
                        //     imageFile,
                        //     _nameController.text.toString(),
                        //     emailcontroller.text.toString(),
                        //     dob,
                        //     showselectGender,
                        //     _phonecontroller.text.toString(),
                        //     "android",
                        //     "sdfsdfsdfsdf");
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
            ],
          );
        });
  }

  AppBar appBarr(BuildContext context, width, height) {
    return AppBar(
      centerTitle: true,
      backgroundColor: Color(Utils.hexStringToHexInt('46D0D9')),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            margin: EdgeInsets.only(top: height * 0.05),
            child: Text(' Crossing Republick, Ghaziabad',
                style: TextStyle(
                    fontSize: width * 0.03,
                    fontFamily: 'Poppins Regular',
                    color: Colors.black),
                textAlign: TextAlign.center),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                width: width * 0.03,
                height: height * 0.03,
                child: SvgPicture.asset(
                  "images/svgicons/mappin.svg",
                ),
              ),
              Text(' Crossing Republick, Ghaziabad',
                  style: TextStyle(
                      fontSize: width * 0.02,
                      fontFamily: 'Poppins Regular',
                      color: Colors.black),
                  textAlign: TextAlign.center),
              IconButton(
                icon: Icon(
                  Icons.keyboard_arrow_down_sharp,
                  size: width * 0.05,
                  color: Colors.black,
                ),
                tooltip: 'Comment Icon',
                onPressed: () {},
              )
            ],
          ),
        ],
      ),
      actions: <Widget>[
        //IconButton
        IconButton(
          iconSize: width * 0.07,
          icon: const Icon(
            CupertinoIcons.bell,
            color: Colors.blue,
          ),
          tooltip: 'Setting Icon',
          onPressed: () {},
        ), //IconButton
      ],
      //<Widget>[]

      elevation: 0.0,
      leading: Builder(
        builder: (context) => IconButton(
          icon: const Icon(
            Icons.menu,
            color: Colors.black,
          ),
          tooltip: 'Menu Icon',
          onPressed: () => Scaffold.of(context).openDrawer(),
        ),
      ),
      brightness: Brightness.dark,
    );
  }

  Widget updateProfileView(width, height) {
    print("DF SDF SDF SDF SDF SDF SDF SDF SDF 00");
    return SizedBox(
      width: width,
      height: height,
      child: Container(
        child: Column(
          children: <Widget>[
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
                                fit: BoxFit.fill)),
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
            Text("Update profile Photo",
                style: TextStyle(
                  color: Color(Utils.hexStringToHexInt('77ACA2')),
                  fontSize: width * 0.05,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Poppins Medium',
                ),
                textAlign: TextAlign.end),
            SizedBox(
              height: height * 0.1,
            ),
            Utils().titleTextsemibold('Update profile', context),
            SizedBox(
              height: height * 0.02,
            ),
            Center(
              child: Text(
                'Please enter the details below to update your profile.',
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
              margin: EdgeInsets.only(left: width * 0.08, right: width * 0.08),
              child: Column(
                children: <Widget>[
                  Container(
                    width: width - 5,
                    height: height * 0.1 - height * 0.04,
                    padding: const EdgeInsets.only(left: 6),
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(Radius.circular(4)),
                      color: Color(Utils.hexStringToHexInt('F4F4F4')),
                    ),
                    child: TextField(
                        style: const TextStyle(
                          color: Colors.black,
                        ),
                        textAlignVertical: TextAlignVertical.center,
                        textAlign: TextAlign.left,
                        controller: _nameController,
                        decoration: InputDecoration(
                            hintText: 'Name',
                            hintStyle: TextStyle(
                                color: Color(Utils.hexStringToHexInt('A4A4A4')),
                                fontFamily: 'Poppins Regular',
                                fontSize: width * 0.03),
                            border: InputBorder.none)),
                  ),
                  Container(
                    width: width - 5,
                    height: height * 0.1 - height * 0.04,
                    margin: const EdgeInsets.only(top: 6),
                    padding: const EdgeInsets.only(left: 6),
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(Radius.circular(4)),
                      color: Color(Utils.hexStringToHexInt('F4F4F4')),
                    ),
                    child: TextField(
                        style: const TextStyle(
                          color: Colors.black,
                        ),
                        textAlignVertical: TextAlignVertical.center,
                        textAlign: TextAlign.left,
                        controller: emailcontroller,
                        decoration: InputDecoration(
                            hintText: 'Email',
                            hintStyle: TextStyle(
                                color: Color(Utils.hexStringToHexInt('A4A4A4')),
                                fontFamily: 'Poppins Regular',
                                fontSize: width * 0.03),
                            border: InputBorder.none)),
                  ),
                  Container(
                    width: width - 5,
                    height: height * 0.1 - height * 0.04,
                    margin: const EdgeInsets.only(top: 6),
                    padding: const EdgeInsets.only(left: 6),
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(Radius.circular(4)),
                      color: Color(Utils.hexStringToHexInt('F4F4F4')),
                    ),
                    child: TextField(
                        style: const TextStyle(
                          color: Colors.black,
                        ),
                        textAlignVertical: TextAlignVertical.center,
                        textAlign: TextAlign.left,
                        controller: _phonecontroller,
                        decoration: InputDecoration(
                            hintText: 'Phone',
                            hintStyle: TextStyle(
                                color: Color(Utils.hexStringToHexInt('A4A4A4')),
                                fontFamily: 'Poppins Regular',
                                fontSize: width * 0.03),
                            border: InputBorder.none)),
                  ),
                  Row(
                    children: <Widget>[
                      GestureDetector(
                        onTap: () {
                          _selectDate(context);
                        },
                        child: Container(
                          width: width - 5,
                          height: height * 0.1 - height * 0.04,
                          margin: const EdgeInsets.only(top: 6),
                          padding: const EdgeInsets.only(left: 6),
                          decoration: BoxDecoration(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(4)),
                            color: Color(Utils.hexStringToHexInt('F4F4F4')),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text(
                                dob == "" ? "Date of birth" : dob,
                                style: TextStyle(
                                    color: Color(
                                        Utils.hexStringToHexInt('A4A4A4')),
                                    fontFamily: 'Poppins Regular',
                                    fontSize: width * 0.03),
                              ),
                              const Icon(
                                Icons.calendar_today,
                                color: Colors.black,
                              )
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 6,
                      ),
                      Container(
                        width: width - 5,
                        height: height * 0.1 - height * 0.04,
                        margin: const EdgeInsets.only(top: 6),
                        padding: const EdgeInsets.only(left: 6),
                        decoration: BoxDecoration(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(4)),
                          color: Color(Utils.hexStringToHexInt('F4F4F4')),
                        ),
                        child: DropdownButton(
                          icon: const Icon(Icons.keyboard_arrow_down),
                          hint: Text(
                            "${showselectGender == "" ? "Gender" : showselectGender}",
                            style: TextStyle(
                                color: Color(Utils.hexStringToHexInt('A4A4A4')),
                                fontFamily: 'Poppins Regular',
                                fontSize: width * 0.03),
                          ),
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
                      )
                    ],
                  )
                ],
              ),
            ),
            SizedBox(
              height: height * 0.04,
            ),
            GestureDetector(
              onTap: () {
                CommonDialog.showsnackbar(date);

                // authControlller.registerUser(
                //     imageFile,
                //     _nameController.text.toString(),
                //     emailcontroller.text.toString(),
                //     dob,
                //     showselectGender,
                //     _phonecontroller.text.toString(),
                //     "android",
                //     "sdfsdfsdfsdf");
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
    );
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
    final DateTime? selected = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2010),
      lastDate: DateTime(2025),
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
}
