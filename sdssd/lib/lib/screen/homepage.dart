import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:untitled/screen/register.dart';
import 'package:untitled/screen/saloondetail.dart';
import 'package:untitled/screen/sidenavigation.dart';
import 'package:flutter_svg/svg.dart';
import 'package:untitled/utils/Utils.dart';

import '../controller/home_controller.dart';
import '../model/AdminServicePojo.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  HomeController homeControlller = Get.put(HomeController());
  final GlobalKey<ScaffoldState> _scaffoldkey = new GlobalKey<ScaffoldState>();
  int isSelected =
      1; // changed bool to int and set value to -1 on first time if you don't select anything otherwise set 0 to set first one as selected.

  _isSelected(int index) {
    //pass the selected index to here and set to 'isSelected'
    setState(() {
      isSelected = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    print("IN HOME SCREN ************");
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;

    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        key: _scaffoldkey,
        drawer: const SideNavigatinPage(),
        appBar: appBarr(context, width, height),
        body: ListView(
          scrollDirection: Axis.vertical,
          children: <Widget>[
            GetBuilder<HomeController>(builder: (homeControlller) {
              if (homeControlller.lodaer) {
                return Container();
              } else {
                var data = homeControlller.shopListPojo.value.staffDetail;
                var servicedata =
                    homeControlller.serviceList.value.serviceDetail;
                return Container(
                  width: MediaQuery.of(context).size.width,
                  color: Color(Utils.hexStringToHexInt('#fbfbfc')),
                  margin: const EdgeInsets.only(left: 12, right: 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      const SizedBox(
                        height: 12,
                      ),
                      Text(
                        'Hello Vanshita Singh!',
                        style: TextStyle(
                            fontFamily: 'Poppins Regular',
                            fontSize: MediaQuery.of(context).size.width * 0.02,
                            color: Color(Utils.hexStringToHexInt('#cfcfcf'))),
                      ),
                      Text(
                        'Start looking for your Favourite Salon',
                        style: TextStyle(
                            fontFamily: 'Poppins Medium',
                            fontSize: MediaQuery.of(context).size.width * 0.03,
                            color: Color(Utils.hexStringToHexInt('#154f84'))),
                      ),
                      filterContainer(context, width, height),
                      searchHint(context),
                      GestureDetector(
                        onTap: () {},
                        child: OfferWidger(context, width, height),
                      ),
                      SizedBox(
                        height: height * 0.02,
                      ),
                      Utils().titleText('Services', context),
                      servicelist(context, width, height, servicedata),
                      SizedBox(
                        height: height * 0.02,
                      ),
                      seeall(context),
                      ListView.builder(
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: data!.length,
                          itemBuilder: (context, position) {
                            return GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => SaloonDetail(
                                            data[position].shopId!)),
                                  );
                                },
                                child: Container(
                                  width: width,
                                  height: height * 0.2,
                                  margin: EdgeInsets.only(
                                      top: height * 0.001,
                                      bottom: height * 0.001),
                                  color: Colors.white,
                                  child: Card(
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
                                                    margin: EdgeInsets.only(
                                                        left: 8),
                                                    height:
                                                        MediaQuery.of(context)
                                                                    .size
                                                                    .height *
                                                                0.2 -
                                                            height * 0.04,
                                                    decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius.only(
                                                                topLeft: Radius
                                                                    .circular(
                                                                        12),
                                                                bottomLeft: Radius
                                                                    .circular(
                                                                        12)),
                                                        image: DecorationImage(
                                                          image: NetworkImage(
                                                              data[position]
                                                                  .shopLogo
                                                                  .toString()),
                                                          fit: BoxFit.cover,
                                                        ))),
                                              ),
                                            ),
                                            Container(
                                              child: Expanded(
                                                flex: 5,
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceAround,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: <Widget>[
                                                    Column(
                                                      children: <Widget>[],
                                                    ),
                                                    Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceAround,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: <Widget>[
                                                        Text(""),
                                                        SizedBox(
                                                          height: height * 0.03,
                                                        ),
                                                        SizedBox(
                                                          height: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .height *
                                                              0.04,
                                                          child:
                                                              ListView.builder(
                                                                  shrinkWrap:
                                                                      true,
                                                                  scrollDirection:
                                                                      Axis
                                                                          .horizontal,
                                                                  itemCount: data[
                                                                          position]
                                                                      .service!
                                                                      .length,
                                                                  itemBuilder:
                                                                      (context,
                                                                          index) {
                                                                    return Container(
                                                                      margin: EdgeInsets.only(
                                                                          left:
                                                                              4,
                                                                          right:
                                                                              4),
                                                                      padding:
                                                                          EdgeInsets.all(
                                                                              4),
                                                                      color: Color(
                                                                          Utils.hexStringToHexInt(
                                                                              'E5E5E5')),
                                                                      child:
                                                                          Row(
                                                                        crossAxisAlignment:
                                                                            CrossAxisAlignment.center,
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.start,
                                                                        children: <
                                                                            Widget>[
                                                                          Container(
                                                                            margin:
                                                                                EdgeInsets.only(top: 5),
                                                                            child:
                                                                                Center(
                                                                              child: SvgPicture.asset(
                                                                                'images/svgicons/tagsvg.svg',
                                                                                fit: BoxFit.contain,
                                                                                width: 24,
                                                                                height: 24,
                                                                              ),
                                                                            ),
                                                                          ),
                                                                          Container(
                                                                            padding:
                                                                                EdgeInsets.only(right: 4),
                                                                            decoration:
                                                                                BoxDecoration(color: Color(Utils.hexStringToHexInt('E5E5E5'))),
                                                                            child: Center(
                                                                                child: Text(
                                                                              data[position].service![index].serviceTitle.toString(),
                                                                              style: TextStyle(fontSize: width * 0.03),
                                                                            )),
                                                                          )
                                                                        ],
                                                                      ),
                                                                    );
                                                                  }),
                                                        ),
                                                        Container(
                                                          margin:
                                                              EdgeInsets.only(
                                                                  top: height *
                                                                      0.01),
                                                          child:
                                                              RatingBarIndicator(
                                                            rating: 2.75,
                                                            itemBuilder:
                                                                (context,
                                                                        index) =>
                                                                    Icon(
                                                              Icons.star,
                                                              color:
                                                                  Colors.amber,
                                                            ),
                                                            itemCount: 5,
                                                            itemSize: 18.0,
                                                            direction:
                                                                Axis.horizontal,
                                                          ),
                                                        ),
                                                      ],
                                                    )
                                                  ],
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
                                                      color: Colors.blue,
                                                    ),
                                                  )),
                                            )
                                          ],
                                        ),
                                        // /*TODO--femina text*/
                                        Positioned(
                                          top: height * 0.02,
                                          left: width * 0.3 + width * 0.03,
                                          child: Text(
                                            data[position].shopName.toString(),
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.03,
                                                fontFamily: 'Poppins Regular'),
                                          ),
                                        ),

                                        /*TODO---address*/
                                        Positioned(
                                          top: height * 0.05,
                                          left: width * 0.3 + width * 0.03,
                                          child: Text(
                                            data[position].location.toString(),
                                            style: TextStyle(
                                                color: Color(
                                                    Utils.hexStringToHexInt(
                                                        'A3A2A2')),
                                                fontSize: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.03,
                                                fontFamily: 'Poppins Regular'),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ));
                          })
                    ],
                  ),
                );
              }
            })
          ],
        ),
      ),
    );
  }

  AppBar appBarr(BuildContext context, width, height) {
    return AppBar(
      centerTitle: true,
      // title: Row(
      //   mainAxisAlignment: MainAxisAlignment.center,
      //   children: <Widget>[
      //     Container(
      //       width: width * 0.03,
      //       height: height * 0.03,
      //       child: SvgPicture.asset(
      //         "images/svgicons/mappin.svg",
      //       ),
      //     ),
      //     Text(' Crossing Republick, Ghaziabad',
      //         style: TextStyle(
      //             fontSize: width * 0.02,
      //             fontFamily: 'Poppins Regular',
      //             color: Colors.black),
      //         textAlign: TextAlign.center),
      //     IconButton(
      //       icon: Icon(
      //         Icons.keyboard_arrow_down_sharp,
      //         size: width * 0.04,
      //         color: Colors.black,
      //       ),
      //       tooltip: 'Comment Icon',
      //       onPressed: () {},
      //     )
      //   ],
      // ),

      actions: <Widget>[
        //IconButton
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
                size: width * 0.04,
                color: Colors.black,
              ),
              tooltip: 'Comment Icon',
              onPressed: () {},
            )
          ],
        ),
        IconButton(
          iconSize: width * 0.07,
          icon: Icon(
            CupertinoIcons.bell,
            color: Colors.blue,
          ),
          tooltip: 'Setting Icon',
          onPressed: () {},
        ), //IconButton
      ],
      //<Widget>[]
      backgroundColor: Colors.white,
      elevation: 50.0,
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

  Widget filterContainer(BuildContext context, width, height) {
    return Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height * 0.08,
        margin: EdgeInsets.only(top: height * 0.02, bottom: height * 0.02),
        padding: const EdgeInsets.only(left: 12, right: 12),
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(10.0)),
          color: Colors.white,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Row(
              children: <Widget>[
                Icon(
                  CupertinoIcons.search,
                  color: Color(Utils.hexStringToHexInt('#77aca2')),
                  size: MediaQuery.of(context).size.width * 0.06,
                ),
                Text(
                  'What are you looking for?',
                  style: TextStyle(
                      fontFamily: 'Poppins Semibold',
                      fontSize: MediaQuery.of(context).size.width * 0.03,
                      color: Color(Utils.hexStringToHexInt('77ACA2'))),
                ),
              ],
            ),
            Container(
              width: MediaQuery.of(context).size.width * 0.06,
              height: MediaQuery.of(context).size.height * 0.06,
              child: SvgPicture.asset('images/svgicons/filter.svg'),
            )
          ],
        ));
  }

  Widget searchHint(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height * 0.05,
      child: ListView.builder(
          itemCount: 4,
          shrinkWrap: true,
          physics: const AlwaysScrollableScrollPhysics(),
          scrollDirection: Axis.horizontal,
          itemBuilder: (context, position) {
            return Container(
              width: MediaQuery.of(context).size.width * 0.3,
              margin: const EdgeInsets.only(left: 6, right: 6),
              decoration: BoxDecoration(
                  border: Border.all(
                    color: Color(Utils.hexStringToHexInt('#e5e5e5')),
                    width: 2,
                  ),
                  borderRadius:
                      const BorderRadius.all(const Radius.circular(6))),
              child: Center(
                child: Text(
                  'Makeup',
                  style: TextStyle(
                      fontFamily: 'Poppins Regular',
                      fontSize: MediaQuery.of(context).size.width * 0.03,
                      color: Color(Utils.hexStringToHexInt('000000'))),
                  textAlign: TextAlign.center,
                ),
              ),
            );
          }),
    );
  }

  Widget OfferWidger(BuildContext context, width, height) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height * 0.2,
      margin: EdgeInsets.only(top: height * 0.02),
      padding: EdgeInsets.only(
          top: MediaQuery.of(context).size.height * 0.02, left: 12),
      decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(12)),
          color: Color(Utils.hexStringToHexInt('#77ACA2'))),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SvgPicture.asset(
            'images/svgicons/offericon.svg',
            width: width * 0.04,
            height: height * 0.04,
          ),
          const SizedBox(
            width: 6,
          ),
          Flexible(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  'New User Discounts',
                  style: TextStyle(
                      color: Color(Utils.hexStringToHexInt('FFFFFF')),
                      fontFamily: 'Poppins Medium',
                      fontSize: MediaQuery.of(context).size.width * 0.04),
                ),
                Text(
                  'Get 50% discount on your first booking at your favourite salon',
                  textAlign: TextAlign.left,
                  style: TextStyle(
                      color: Color(Utils.hexStringToHexInt('FFFFFF')),
                      fontFamily: 'Poppins Light',
                      fontSize: width * 0.03),
                ),
                SizedBox(
                  height: height * 0.02,
                ),
                Text(
                  'Use Code : NEW50',
                  style: TextStyle(
                      color: Colors.white,
                      fontFamily: 'Poppins Medium',
                      fontSize: MediaQuery.of(context).size.height * 0.02),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget servicelist(
      BuildContext context, width, height, List<ServiceDetail>? serviceDetail) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: height * 0.2 - height * 0.06,
      child: ListView.builder(
        itemCount: serviceDetail!.length,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, position) {
          double scale = 1;
          return Container(
            margin: const EdgeInsets.only(left: 5, right: 5),
            width: MediaQuery.of(context).size.width * 0.2,
            height: height * 0.06,
            decoration: BoxDecoration(
              color: isSelected != null &&
                      isSelected ==
                          position //set condition like this. voila! if isSelected and list index matches it will colored as white else orange.
                  ? Color(Utils.hexStringToHexInt('77ACA2'))
                  : Colors.transparent,
              borderRadius: const BorderRadius.all(Radius.circular(12)),
            ),
            child: GestureDetector(
              onTap: () {
                _isSelected(position);
                debugPrint("Click working");
              },
              child: Column(
                children: <Widget>[
                  Container(
                    margin: const EdgeInsets.only(left: 6, right: 6),
                    width: MediaQuery.of(context).size.width * 0.2,
                    height: height * 0.08,
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(12)),
                    ),
                    child: Center(
                      child: Image.network(
                        serviceDetail[position].serviceImage.toString(),
                        width: MediaQuery.of(context).size.width * 0.1 + 4,
                        height: MediaQuery.of(context).size.height * 0.1 + 4,
                        // color: isSelected != null &&
                        //         isSelected ==
                        //             position //set condition like this. voila! if isSelected and list index matches it will colored as white else orange.
                        //     ? Colors.white
                        //     : Color(
                        //         Utils.hexStringToHexInt('77ACA2'),
                        //       ),
                        fit: isSelected != null &&
                                isSelected ==
                                    position //set condition like this. voila! if isSelected and list index matches it will colored as white else orange.
                            ? BoxFit.contain
                            : null,
                      ),
                    ),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.01),
                  Text(
                    serviceDetail[position].serviceTitle.toString(),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Colors.white,
                        fontFamily: 'Hair Cut',
                        fontSize: MediaQuery.of(context).size.width * 0.03),
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget seeall(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Utils().titleText('Nearby Salons', context),
        Text(
          'See all',
          style: TextStyle(
              fontFamily: 'Poppins Regular',
              fontSize: MediaQuery.of(context).size.height * 0.02,
              color: Color(Utils.hexStringToHexInt('#77aca2'))),
        )
      ],
    );
  }
}
