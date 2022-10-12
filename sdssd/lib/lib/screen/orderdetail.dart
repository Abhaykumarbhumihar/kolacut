import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:untitled/model/ShopDetailPojo.dart';
import 'package:untitled/utils/Utils.dart';

import '../controller/shopdetain_controller.dart';

class OrderDetail extends StatefulWidget {
  List<SubService>? newarray;
  Data? data;
  var selectEmpid="";
  var selectDate="";
  var selectDay="";
  var selectSlot="";


  // const OrderDetail(List<SubService> tempArray, Data a,  {Key? key}) : super(key: key){}

  OrderDetail(List<SubService> tempArray, Data a,String selectEmpid, String selectDate, String selectDay,String selectSlot) {
    this.newarray = tempArray;
    this.data = a;
    this.selectDate=selectDate;
    this.selectEmpid=selectEmpid;
    this.selectDay=selectDay;
    this.selectSlot=selectSlot;
  }

  @override
  State<OrderDetail> createState() => _OrderDetailState(newarray, data,selectDate,selectEmpid,selectDay,selectSlot);
}

class _OrderDetailState extends State<OrderDetail> {
  _OrderDetailState(tempArray, a,selectDate,selectEmpid,selectDay,selectSlot);
  ShopDetailController salonControlller = Get.put(ShopDetailController());
//shop_idd,employee_id,service_id,sub_service_id,date,
//       from_time,booking_day,to_time,amount

  var totalPrice=0;
  void bookService(){
    salonControlller.bookserVice("1",
        widget.selectEmpid.toString()+"", "3", "1,2", widget.selectDate.toString(), widget.selectSlot.toString(),
        widget.selectDay.toString(), "", "200");
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    print(widget.data!.name.toString());
    print(widget.selectEmpid+"EMP");
    print(widget.selectDay+" day");
    print(widget.selectDate+" date");
    widget.newarray!.forEach((element) {
      totalPrice=totalPrice+int.parse(element.price.toString());
      print(element.name.toString()+"  "+element.price.toString());
    });
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;

    return SafeArea(
        child: Scaffold(
      //  backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Container(
          color: Color(Utils.hexStringToHexInt('#fcfcfc')),
          width: width,
          height: height,
          margin: EdgeInsets.only(left: width * 0.02, right: width * 0.02),
          child: Column(
            children: <Widget>[
              Container(
                width: width,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(
                      height: height * 0.02,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            GestureDetector(
                              onTap: () {
                                Navigator.pop(context);
                              },
                              child: Icon(
                                CupertinoIcons.arrow_left,
                                color: Colors.black,
                              ),
                            ),
                            Text(
                              '${widget.data!.name.toString()}',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: width * 0.04,
                                  fontFamily: 'Poppins Regular'),
                            )
                          ],
                        ),
                        SvgPicture.asset(
                          'images/svgicons/appcupon.svg',
                          fit: BoxFit.contain,
                          width: 24,
                          height: 24,
                        )
                      ],
                    ),
                    SizedBox(
                      height: height * 0.01,
                    ),
                    Container(
                      alignment: Alignment.topLeft,
                      color: Colors.white,
                      child: Row(
                        children: <Widget>[
                          Container(
                            width: 24,
                            height: 24,
                            child: SvgPicture.asset(
                              "images/svgicons/mappin.svg",
                            ),
                          ),
                          Text(' ${widget.data!.address.toString()}',
                              style: TextStyle(
                                  fontSize: width * 0.03,
                                  fontFamily: 'Poppins Regular',
                                  color: Color(
                                      Utils.hexStringToHexInt('#77ACA2'))),
                              textAlign: TextAlign.center),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: height * 0.04,
                    ),
                    Row(
                      children: <Widget>[
                        Container(
                          width: 24,
                          height: 24,
                          child: SvgPicture.asset(
                            "images/svgicons/lock.svg",
                          ),
                        ),
                        Text(
                          '  Your Order',
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: width * 0.04,
                              fontFamily: 'Poppins Semibold'),
                        )
                      ],
                    ),
                    SizedBox(
                      height: height * 0.02,
                    ),
                    Container(
                      width: width,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            '  Services',
                            style: TextStyle(
                                color: Color(Utils.hexStringToHexInt('5E5E5E')),
                                fontSize: width * 0.03,
                                fontFamily: 'Poppins Regular'),
                          ),
                          Text(
                            '  Prices      ',
                            style: TextStyle(
                                color: Color(Utils.hexStringToHexInt('5E5E5E')),
                                fontSize: width * 0.03,
                                fontFamily: 'Poppins Regular'),
                          )
                        ],
                      ),
                    ),
                    SizedBox(height: height * 0.02),
                    Material(
                      elevation: 1,
                      color: Colors.white,
                      child: Column(
                        children: <Widget>[
                          SizedBox(
                            height: height * 0.02,
                          ),
                          SizedBox(
                            width: width,
                            child: ListView.builder(
                              shrinkWrap: true,
                                itemCount: widget.newarray!.length,
                                itemBuilder: (context,position){
                              return Container(
                                margin: EdgeInsets.only(right: width * 0.03),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Row(
                                      children: <Widget>[
                                        Container(
                                          width: width * 0.08,
                                          height: height * 0.04,
                                          child: SvgPicture.asset(
                                            "images/svgicons/checktick.svg",
                                          ),
                                        ),
                                        Container(
                                          margin:
                                          EdgeInsets.only(left: width * 0.03),
                                          child: Text('${widget.newarray![position].name}',
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: width * 0.04,
                                                  fontFamily: 'Poppins Regular')),
                                        )
                                      ],
                                    ),
                                    Container(
                                      margin: EdgeInsets.only(right: width * 0.03),
                                      child: Text('Rs. ${widget.newarray![position].price}',
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: width * 0.03,
                                              fontFamily: 'Poppins Regular')),
                                    )
                                  ],
                                ),
                              );
                            }),
                          ),

                          SizedBox(
                            height: height * 0.05,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              SvgPicture.asset(
                                'images/svgicons/addmoreservices.svg',
                                width: width * 0.01,
                                height: height * 0.02,
                              ),
                            ],
                          ),
                          Divider(
                            thickness: 2,
                            color: Color(Utils.hexStringToHexInt('E5E5E5')),
                          ),
                          SizedBox(
                            height: 4,
                          ),
                          Row(
                            children: <Widget>[
                              SvgPicture.asset(
                                'images/svgicons/questionmark.svg',
                                fit: BoxFit.contain,
                                width: 18,
                                height: 18,
                              ),
                              Text(
                                ' Do you have any query?',
                                style: TextStyle(
                                    fontFamily: 'Poppins Light',
                                    fontSize: width * 0.02,
                                    color: Color(
                                        Utils.hexStringToHexInt('8D8D8D'))),
                              )
                            ],
                          ),
                          SizedBox(
                            height: height * 0.02,
                          ),
                        ],
                      ),
                    ),
                    InkWell(
                      onTap: (){
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            bool showSublist =
                            false; // Declare your variable outside the builder


                            bool showmainList = true;

                            return AlertDialog(
                              content: StatefulBuilder(
                                // You need this, notice the parameters below:
                                builder: (BuildContext context,
                                    StateSetter setState) {
                                  return Container(
                                    width: width,
                                    height: height,
                                    child: Column(
                                      mainAxisAlignment:
                                      MainAxisAlignment.start,
                                      children: [
                                        SizedBox(
                                          width: width,
                                        height: height*0.8,
                                          child: ListView.builder(
                                            shrinkWrap: true,
                                              itemCount:widget.data!.coupon!.length,
                                              scrollDirection: Axis.vertical,
                                              itemBuilder: (context, position) {
                                                return Container(
                                                    width: width * 0.4 + width * 0.05,
                                                    height: height * 0.12,
                                                    margin: EdgeInsets.all(6),
                                                    decoration: BoxDecoration(
                                                        color: Colors.white,
                                                        borderRadius:
                                                        BorderRadius.all(Radius.circular(8)),
                                                        border:
                                                        Border.all(color: Colors.grey, width: 1)),
                                                    child: Stack(
                                                      children: <Widget>[
                                                        Column(
                                                          crossAxisAlignment:
                                                          CrossAxisAlignment.start,
                                                          mainAxisAlignment:
                                                          MainAxisAlignment.spaceAround,
                                                          children: <Widget>[
                                                            Column(
                                                              crossAxisAlignment:
                                                              CrossAxisAlignment.start,
                                                              children: <Widget>[
                                                                Text(
                                                                  '  ${widget.data!.coupon![position].couponName.toString()}',
                                                                  style: TextStyle(
                                                                      fontFamily: 'Poppins Regular',
                                                                      fontSize: MediaQuery.of(context)
                                                                          .size
                                                                          .height *
                                                                          0.02,
                                                                      color: Colors.black),
                                                                ),
                                                                SizedBox(
                                                                  height: 8,
                                                                ),
                                                                Text(
                                                                  '  Upto 50% off via UPI',
                                                                  style: TextStyle(
                                                                      fontFamily: 'Poppins Light',
                                                                      fontSize: MediaQuery.of(context)
                                                                          .size
                                                                          .height *
                                                                          0.01,
                                                                      color: Color(
                                                                          Utils.hexStringToHexInt(
                                                                              'A4A4A4'))),
                                                                ),
                                                              ],
                                                            ),
                                                            Row(
                                                              children: <Widget>[
                                                                Text(
                                                                  '  Use Code ',
                                                                  style: TextStyle(
                                                                      fontFamily: 'Poppins Light',
                                                                      fontSize: MediaQuery.of(context)
                                                                          .size
                                                                          .height *
                                                                          0.01,
                                                                      color: Color(
                                                                          Utils.hexStringToHexInt(
                                                                              'A4A4A4'))),
                                                                ),
                                                                Container(
                                                                  padding: EdgeInsets.symmetric(
                                                                      vertical: 2.0,
                                                                      horizontal: 10.0),
                                                                  color: Color(
                                                                      Utils.hexStringToHexInt(
                                                                          '#46D0D9')),
                                                                  child: Text(
                                                                    '${widget.data!.coupon![position].couponCode.toString()}',
                                                                    style: TextStyle(
                                                                      fontFamily: 'Poppins Light',
                                                                      fontSize: MediaQuery.of(context)
                                                                          .size
                                                                          .height *
                                                                          0.01,
                                                                      color: Colors.white,
                                                                    ),
                                                                  ),
                                                                )
                                                              ],
                                                            )
                                                          ],
                                                        ),
                                                        Align(
                                                          alignment: Alignment.topRight,
                                                          child: IconButton(
                                                              onPressed: () {

                                                                //profileController.getCouponList1();
                                                              },
                                                              icon: Icon(
                                                                Icons.copy,
                                                                size: width * 0.05,
                                                                color: Colors.cyan,
                                                              )),
                                                        ),
                                                      ],
                                                    ));
                                              }),
                                        ),
                                        // Container(
                                        //   width: width,
                                        //   height: height * 0.4,
                                        //   child: ListView.builder(
                                        //       shrinkWrap: true,
                                        //       itemCount:widget.data!.coupon!.length,
                                        //       itemBuilder:
                                        //           (context, position) {
                                        //         return InkWell(
                                        //           onTap: () {
                                        //             setState((){
                                        //
                                        //
                                        //             });
                                        //           },
                                        //           child: Container(
                                        //             height:
                                        //             height * 0.1,
                                        //             padding:
                                        //             EdgeInsets.all(
                                        //                 6.0),
                                        //             child: Card(
                                        //               child: Row(
                                        //                 mainAxisAlignment:
                                        //                 MainAxisAlignment
                                        //                     .spaceBetween,
                                        //                 children: [
                                        //                   Column(
                                        //                     crossAxisAlignment:
                                        //                     CrossAxisAlignment
                                        //                         .start,
                                        //                     mainAxisAlignment:
                                        //                     MainAxisAlignment
                                        //                         .center,
                                        //                     children: <
                                        //                         Widget>[
                                        //                       Text(widget.data!.coupon![position].couponName.toString()),
                                        //                       Text(widget.data!.coupon![position].price.toString())
                                        //                     ],
                                        //                   ),
                                        //
                                        //
                                        //
                                        //                 ],
                                        //               ),
                                        //             ),
                                        //           ),
                                        //         );
                                        //       }),
                                        // )
                                      ],
                                    ),
                                  );
                                },
                              ),
                            );
                          },
                        );
                      },
                      child: Material(
                        color: Color(Utils.hexStringToHexInt('#dbe8e5')),
                        child: Container(
                            width: width,
                            height: height * 0.09,
                            padding: EdgeInsets.only(
                                left: width * 0.03, right: width * 0.03),
                            color: Color(Utils.hexStringToHexInt('#dbe8e5')),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Row(
                                  children: <Widget>[
                                    SvgPicture.asset(
                                      'images/svgicons/bigoffer.svg',
                                      fit: BoxFit.contain,
                                      width: width * 0.06,
                                      height: height * 0.04,
                                    ),
                                    Text(
                                      ' Use Coupons',
                                      style: TextStyle(
                                          color: Color(
                                              Utils.hexStringToHexInt('77ACA2')),
                                          fontFamily: 'Poppins Medium',
                                          fontSize: width * 0.04),
                                    )
                                  ],
                                ),
                                Icon(
                                  Icons.arrow_forward_ios_outlined,
                                  color: Color(Utils.hexStringToHexInt('77ACA2')),
                                )
                              ],
                            )),
                      ),
                    ),
                    SizedBox(
                      height: height * 0.02,
                    ),
                    Material(
                      color: Colors.white,
                      child: Column(
                        children: <Widget>[
                          Container(
                            margin: EdgeInsets.only(right: width * 0.03),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Row(
                                  children: <Widget>[
                                    Container(
                                      margin:
                                          EdgeInsets.only(left: width * 0.03),
                                      child: Text('Services total',
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: width * 0.04,
                                              fontFamily: 'Poppins Regular')),
                                    )
                                  ],
                                ),
                                Container(
                                  margin: EdgeInsets.only(right: width * 0.03),
                                  child: Text('Rs. ${totalPrice.toString()}',
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: width * 0.03,
                                          fontFamily: 'Poppins Regular')),
                                )
                              ],
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(right: width * 0.03),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Row(
                                  children: <Widget>[
                                    Container(
                                      margin:
                                          EdgeInsets.only(left: width * 0.03),
                                      child: Text('Taxes & Charges',
                                          style: TextStyle(
                                              color: Color(
                                                  Utils.hexStringToHexInt(
                                                      '5E5E5E')),
                                              fontSize: width * 0.03,
                                              fontFamily: 'Poppins Regular')),
                                    ),
                                    Icon(
                                      Icons.arrow_drop_down_sharp,
                                      size: width * 0.06,
                                    )
                                  ],
                                ),
                                Container(
                                  margin: EdgeInsets.only(right: width * 0.03),
                                  child: Text('Rs. ${totalPrice.toString()}',
                                      style: TextStyle(
                                          color: Color(Utils.hexStringToHexInt(
                                              '5E5E5E')),
                                          fontSize: width * 0.03,
                                          fontFamily: 'Poppins Regular')),
                                )
                              ],
                            ),
                          ),
                          SizedBox(
                            height: height * 0.02,
                          ),
                          Container(
                            margin: EdgeInsets.only(right: width * 0.03),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Row(
                                  children: <Widget>[
                                    Container(
                                      margin:
                                          EdgeInsets.only(left: width * 0.03),
                                      child: Text('Coupon Discount',
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: width * 0.04,
                                              fontFamily: 'Poppins Regular')),
                                    )
                                  ],
                                ),
                                Container(
                                  margin: EdgeInsets.only(right: width * 0.03),
                                  child: Text('- 250',
                                      style: TextStyle(
                                          color: Color(Utils.hexStringToHexInt(
                                              '5E5E5E')),
                                          fontSize: width * 0.03,
                                          fontFamily: 'Poppins Regular')),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 2,
                          ),
                          Divider(
                            color: Color(Utils.hexStringToHexInt('5E5E5E')),
                            thickness: 1,
                          ),
                          SizedBox(
                            height: height * 0.02,
                          ),
                          Container(
                            margin: EdgeInsets.only(right: width * 0.03),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Row(
                                  children: <Widget>[
                                    Container(
                                      margin:
                                          EdgeInsets.only(left: width * 0.03),
                                      child: Text('Grand Total',
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: width * 0.05,
                                              fontFamily: 'Poppins Medium')),
                                    )
                                  ],
                                ),
                                Container(
                                  margin: EdgeInsets.only(right: width * 0.03),
                                  child: Text('Rs. 600',
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: width * 0.05,
                                          fontFamily: 'Poppins Medium')),
                                ),
                                ElevatedButton(onPressed: (){
                                  bookService();
                                }, child: Text("Book service"))
                              ],
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    ));
  }
}
