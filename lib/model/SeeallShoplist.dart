import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../controller/home_controller.dart';
import '../screen/saloondetail.dart';
import '../utils/Utils.dart';

class SeeAllShopList extends StatefulWidget {
  const SeeAllShopList({Key key}) : super(key: key);

  @override
  State<SeeAllShopList> createState() => _SeeAllShopListState();
}

class _SeeAllShopListState extends State<SeeAllShopList> {
   SharedPreferences sharedPreferences;
  HomeController homeControlller = Get.put(HomeController());
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  GlobalKey<ScaffoldState> scaffolKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery
        .of(context)
        .size
        .width;
    var height = MediaQuery
        .of(context)
        .size
        .height;
    return SafeArea(child: Scaffold(
      appBar: AppBar(
        centerTitle: false,
        elevation: 0.0,
        backgroundColor: Color(Utils.hexStringToHexInt('77ACA2')),
        leading: InkWell(
          onTap: () {
           Navigator.pop(context);
          },
          child: Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
        ),
        titleSpacing: 0,
        title: Text(
          'Salons',
          style: TextStyle(
              color: Colors.white,
              fontFamily: 'Poppins Medium',
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
      body: homeControlller != null ?
      GetBuilder<HomeController>(builder: (homeControlller) {
        if (homeControlller.lodaer) {
          return Container();
        } else {
          var data = homeControlller.shopListPojo.value.staffDetail;
          var servicedata =
              homeControlller.serviceList.value.serviceDetail;
          return
            SizedBox(
              width: width,
              height: height,
              child:
              ListView.builder(
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  itemCount: data.length,
                  itemBuilder: (context, position) {
                    return GestureDetector(
                        onTap: () {
                          print(data[position].shopId);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    SaloonDetail(data[position]
                                        .shopId)),
                          );
                        },
                        child: Container(
                          width: width,
                          height: height * 0.2 - height * 0.06,
                          margin: EdgeInsets.only(
                              top: height * 0.001,
                              bottom: height * 0.001),
                          color: Colors.transparent,
                          child: Card(
                            shape: RoundedRectangleBorder(
                                borderRadius:
                                BorderRadius.circular(12)),
                            child: Stack(
                              clipBehavior: Clip.none,
                              children: <Widget>[
                                Row(
                                  children: <Widget>[
                                    /*TODO---Saloon image*/
                                    Container(
                                      child: Expanded(
                                        flex: 3,
                                        child: Container(
                                            height: MediaQuery.of(
                                                context)
                                                .size
                                                .height *
                                                0.2 -
                                                height * 0.03,
                                            decoration:
                                            BoxDecoration(
                                                borderRadius: const BorderRadius
                                                    .only(
                                                    topLeft:
                                                    Radius.circular(
                                                        12),
                                                    bottomLeft:
                                                    Radius.circular(
                                                        12)),
                                                image:
                                                DecorationImage(
                                                  image: NetworkImage(data[
                                                  position]
                                                      .shopLogo
                                                      .toString()),
                                                  fit: BoxFit
                                                      .cover,
                                                ))),
                                      ),
                                    ),
                                    //SizedBox(width: 4.0,),
                                    Container(
                                      child: Expanded(
                                        flex: 5,
                                        child: Container(
                                          margin:
                                          EdgeInsets.only(
                                              left: 6.0,top: 3.0,bottom: 3.0),
                                          child: Column(
                                            mainAxisAlignment:
                                            MainAxisAlignment
                                                .spaceAround,
                                            crossAxisAlignment:
                                            CrossAxisAlignment
                                                .start,
                                            children: <Widget>[
                                              // // /*TODO--femina text*/
                                              Text(
                                                data[position]
                                                    .shopName
                                                    .toString(),
                                                style: TextStyle(
                                                    color: Colors
                                                        .black,
                                                    fontSize: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                        0.03,
                                                    fontFamily:
                                                    'Poppins Regular'),
                                              ),
                                              //*TODO---address*/
                                              Text(
                                                data[position]
                                                    .location
                                                    .toString(),
                                                style: TextStyle(
                                                    color: Color(
                                                        Utils.hexStringToHexInt(
                                                            'A3A2A2')),
                                                    fontSize: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                        0.03,
                                                    fontFamily:
                                                    'Poppins Regular'),
                                              ),
                                              SizedBox(
                                                height: MediaQuery.of(
                                                    context)
                                                    .size
                                                    .height *
                                                    0.03,
                                                child: ListView
                                                    .builder(
                                                    shrinkWrap:
                                                    true,
                                                    scrollDirection:
                                                    Axis
                                                        .horizontal,
                                                    itemCount: data[position]
                                                        .service
                                                        .length,
                                                    itemBuilder:
                                                        (context,
                                                        index) {
                                                      return Container(
                                                        margin:
                                                        EdgeInsets.only(right: 4),
                                                        // padding:
                                                        //     EdgeInsets.all(2),
                                                        color:
                                                        Color(Utils.hexStringToHexInt('E5E5E5')),
                                                        child:
                                                        Row(
                                                          crossAxisAlignment: CrossAxisAlignment.center,
                                                          mainAxisAlignment: MainAxisAlignment.start,
                                                          children: <Widget>[
                                                            Container(
                                                              margin: EdgeInsets.only(top: 5),
                                                              child: Center(
                                                                child: SvgPicture.asset(
                                                                  'images/svgicons/tagsvg.svg',
                                                                  fit: BoxFit.contain,
                                                                  width: 20,
                                                                  height: 20,
                                                                ),
                                                              ),
                                                            ),
                                                            Container(
                                                              padding: EdgeInsets.only(right: 4),
                                                              decoration: BoxDecoration(color: Color(Utils.hexStringToHexInt('E5E5E5'))),
                                                              child: Center(
                                                                  child: Text(
                                                                    data[position].service[index].serviceTitle.toString(),
                                                                    style: TextStyle(fontSize: width * 0.03),
                                                                  )),
                                                            )
                                                          ],
                                                        ),
                                                      );
                                                    }),
                                              ),
                                              Container(
                                                child:
                                                RatingBarIndicator(
                                                  rating: data[position]
                                                      .rating !=
                                                      null
                                                      ? data[position]
                                                      .rating
                                                      .toDouble()
                                                      : 1.0,
                                                  itemBuilder: (context,
                                                      index) =>
                                                  const Icon(
                                                    Icons.star,
                                                    color: Colors
                                                        .amber,
                                                  ),
                                                  itemCount: 5,
                                                  itemSize:
                                                  14.0,
                                                  direction: Axis
                                                      .horizontal,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                    Container(
                                      child: Expanded(
                                          flex: 1,
                                          child: Container(
                                            child: Icon(
                                              Icons
                                                  .keyboard_arrow_right_outlined,
                                              size: 34,
                                              color:
                                              Colors.black,
                                            ),
                                          )),
                                    )
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ));
                  }),
            );
        }
      }) : Container(),
    ));
  }
}
