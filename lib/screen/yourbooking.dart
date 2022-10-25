import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:untitled/controller/BookingController.dart';
import 'package:untitled/model/MyBookingPojo.dart';
import 'package:untitled/screen/sidenavigation.dart';
import 'package:untitled/utils/CommomDialog.dart';
import 'package:untitled/utils/Utils.dart';
import 'package:sticky_grouped_list/sticky_grouped_list.dart';
import 'package:http/http.dart' as http;

import '../utils/appconstant.dart';
import 'login.dart';

class TableBasicsExample extends StatefulWidget {
  const TableBasicsExample({Key? key}) : super(key: key);

  @override
  _TableBasicsExampleState createState() => _TableBasicsExampleState();
}

class _TableBasicsExampleState extends State<TableBasicsExample> {
  BookingController bookingController = Get.put(BookingController());
  var name = "";
  var email = "";
  var phone = "";
  var iamge = "";
  var rating = 0;
  late TextEditingController _nameController = TextEditingController();

  late SharedPreferences sharedPreferences;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  GlobalKey<ScaffoldState> scaffolKey = GlobalKey<ScaffoldState>();
  var session = "";
  var focuseddaate = DateTime.now();

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
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
        } else {
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
    List<SlotDetail> _element = [];
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    //  WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
    //       wishListControlller.getWishList();
    //     });
    return Scaffold(
      backgroundColor: Colors.white,
      key: scaffolKey,
      drawer: session == null || session == ""
          ? const SizedBox()
          : SideNavigatinPage("${name}", "${iamge}", "${email}", "${phone}"),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.0,
        automaticallyImplyLeading: false,
        titleSpacing: 0,
        centerTitle: false,
        leading: InkWell(
          onTap: () {
            session != "" ? scaffolKey.currentState!.openDrawer() : null;
          },
          child: const Icon(
            Icons.menu,
            color: Colors.black,
          ),
        ),
        title: Text(
          'Your bookings',
          style: TextStyle(
              color: Colors.black,
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
                    Get.off(const LoginPage());
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
          : GetBuilder<BookingController>(builder: (bookingController) {
              if (bookingController.lodaer) {
                return Container();
              } else {
                for (var i = 0;
                    i < bookingController.bookingPojo.value.slotDetail!.length;
                    i++) {
                  _element
                      .add(bookingController.bookingPojo.value.slotDetail![i]);
                }
                return RefreshIndicator(
                  onRefresh: () async {
                    bookingController.getBookingList();
                  },
                  child: ListView(
                    children: <Widget>[
                      Container(
                        width: width,
                        height: height,
                        child: SingleChildScrollView(
                          child: Column(
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.only(left: 6.0,right: 6),
                                child: SizedBox(
                                  width: width,
                                  height: height * 0.4,
                                  child: Center(
                                    child: TableCalendar(
                                      focusedDay: focuseddaate,
                                      firstDay: DateTime(2022),
                                      lastDay: DateTime(2060),
                                      calendarStyle: CalendarStyle(
                                          todayTextStyle: TextStyle(
                                              fontSize:
                                              MediaQuery.of(context).size.width *
                                                  0.03,
                                              color: Colors.white),
                                          weekendTextStyle: TextStyle(
                                              fontSize:
                                              MediaQuery.of(context).size.width *
                                                  0.03),
                                          outsideTextStyle: TextStyle(
                                              fontSize:
                                              MediaQuery.of(context).size.width *
                                                  0.03),
                                          defaultTextStyle: TextStyle(
                                              fontSize:
                                              MediaQuery.of(context).size.width *
                                                  0.03)),
                                      selectedDayPredicate: (day) =>
                                          isSameDay(day, focuseddaate),
                                      headerStyle: HeaderStyle(
                                          titleCentered: true,
                                          titleTextFormatter: (date, locale) =>
                                              DateFormat.yMMM(locale).format(date),
                                          formatButtonVisible: false,
                                          titleTextStyle: TextStyle(
                                              fontSize:
                                              MediaQuery.of(context).size.width *
                                                  0.05)),
                                      shouldFillViewport: true,
                                      onPageChanged: (DateTime date) {
                                        setState(() {
                                          focuseddaate = date;
                                        });
                                      },
                                      onFormatChanged: (format) {
                                        //
                                      },
                                      onDaySelected: (selectedTime, focusedTime) {
                                        setState(() {
                                          focuseddaate = selectedTime;
                                        });
                                        var mon = "";
                                        var datee = "";
                                        if (int.parse(selectedTime.month.toString()) >
                                            9) {
                                          mon = selectedTime.month.toString();
                                        } else {
                                          mon = "0" + selectedTime.month.toString();
                                        }

                                        if (int.parse(selectedTime.day.toString()) > 9) {
                                          datee = selectedTime.day.toString();
                                        } else {
                                          datee = "0" + selectedTime.day.toString();
                                        }
                                        var date = selectedTime.year.toString() +
                                            "-" +
                                            mon +
                                            "-" +
                                            datee;
                                        //  print(date);
                                        var newlist =bookingController.bookingPojo.value.slotDetail!
                                            .where((x) => x.date
                                            .toString()
                                            .toLowerCase()
                                            .contains(date))
                                            .toList();
                                        print(newlist);
                                        if(newlist.isNotEmpty){
                                          Get.dialog(
                                            Dialog(
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(10),
                                              ),
                                              child: ConstrainedBox(
                                                constraints: BoxConstraints(
                                                  minHeight: 0.2,
                                                  maxHeight: height * 0.5,
                                                ),
                                                child: recentleavelistbottom(
                                                    width, height, context, newlist),
                                              ),
                                            ),
                                          //  barrierDismissible: false,
                                          );
                                        }else{
                                          CommonDialog.showsnackbar("No data found for this date");
                                        }
                                      },
                                      calendarBuilders: CalendarBuilders(
                                        defaultBuilder: (ctx, day, focusedDay) {
                                          int index = 0;
                                          for (var leaveEvent = 0;
                                              leaveEvent <
                                                  bookingController.bookingPojo
                                                      .value.slotDetail!.length;
                                              leaveEvent++) {
                                            index++;
                                            final DateTime event =
                                                bookingController
                                                    .bookingPojo
                                                    .value
                                                    .slotDetail![leaveEvent]
                                                    .date!;
                                            if (day.day == event.day &&
                                                day.month == event.month &&
                                                day.year == event.year) {
                                              return Padding(
                                                padding:
                                                    const EdgeInsets.all(4.0),
                                                child: Material(
                                                  elevation: 6.0,
                                                  borderRadius:
                                                      BorderRadius.circular(6.0),
                                                  child: Container(
                                                    decoration:
                                                        const BoxDecoration(
                                                      color: Colors.white,
                                                      borderRadius:
                                                          BorderRadius.all(
                                                        Radius.circular(8.0),
                                                      ),
                                                    ),
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: <Widget>[
                                                        Container(
                                                          child: Center(
                                                            child: Text(
                                                                '${day.day}'),
                                                          ),
                                                        ),
                                                        Container(
                                                          width: 15,
                                                          height: 6,
                                                          decoration:
                                                              BoxDecoration(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        6.0),
                                                            color: Colors.orange,
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              );
                                            }
                                          }
                                          return null;
                                        },
                                      ),
                                    ),
                                  ),
                                ),
                              ),
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
                        ),
                      ),
                    ],
                  ),
                );
              }
            }),
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
                        width: width * 0.2-width*0.02,
                        child: Text(
                          '${slotDetail.toTime}',
                          softWrap: false,
                          maxLines: 1,
                          overflow: TextOverflow.fade,
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
}
