import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:untitled/screen/notification.dart';
import 'package:untitled/screen/register.dart';
import 'package:untitled/screen/saloondetail.dart';
import 'package:untitled/screen/sidenavigation.dart';
import 'package:flutter_svg/svg.dart';
import 'package:untitled/utils/CommomDialog.dart';
import 'package:untitled/utils/Utils.dart';
import 'package:geolocator/geolocator.dart';
import '../controller/home_controller.dart';
import '../model/AdminCouponPojo.dart';
import '../model/AdminServicePojo.dart';
import 'package:google_place/google_place.dart';

import '../model/SeeallShoplist.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  HomeController homeControlller = Get.put(HomeController());
  late GooglePlace googlePlace;
  final Geolocator geolocator = Geolocator()..forceAndroidLocationManager;
  late Position _currentPosition;
  String _currentAddress = "";
  List<AutocompletePrediction> predictions = [];
  final GlobalKey<ScaffoldState> _scaffoldkey = new GlobalKey<ScaffoldState>();
  int isSelected =
      1; // changed bool to int and set value to -1 on first time if you don't select anything otherwise set 0 to set first one as selected.
  bool _isLoading = true;
  String apiKey = "AIzaSyAIFnj6QxWUHPj3M086GFxMBPJrR6NePE8";

  var name = "";
  var email = "";
  var phone = "";
  var iamge = "";
  var session = "";
  late SharedPreferences sharedPreferences;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  GlobalKey<ScaffoldState> scaffolKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    // TODO: implement initState
    Future.delayed(Duration(seconds: 3), () {
      setState(() {
        _isLoading = false;
      });
    });

    super.initState();
    googlePlace = GooglePlace(apiKey);
    _getCurrentLocation();
  }

  _isSelected(int index) {
    //pass the selected index to here and set to 'isSelected'
    setState(() {
      isSelected = index;
    });
  }

  _getAddressFromLatLng() async {
    try {
      List<Placemark> p = await geolocator.placemarkFromCoordinates(
          _currentPosition.latitude, _currentPosition.longitude);

      Placemark place = p[0];

      setState(() {
        _currentAddress =
            "${place.locality}, ${place.postalCode}, ${place.country}";
        print(_currentAddress);
      });
    } catch (e) {
      print(e);
    }
  }

  _getCurrentLocation() {
    debugPrint("KLKDFKDFKDJSFLKDSKFDSKFLKDJSFKLDFKLDKFKDLFKLD");
    geolocator
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.best)
        .then((Position position) {
      setState(() {
        _currentPosition = position;
        debugPrint("${_currentPosition} ++++++++");
        if (kDebugMode) {
          print(_currentPosition);
        }
      });

      _getAddressFromLatLng();
    }).catchError((e) {
      print(e);
    });
  }

  void autoCompleteSearch(String value) async {
    var result = await googlePlace.autocomplete.get(value);
    if (result != null && result.predictions != null && mounted) {
      setState(() {
        predictions = result.predictions!;
      });
    }
  }

  void getDetils(String placeId) async {
    var result = await this.googlePlace.details.get(placeId);
    print(result);
    if (result != null && result.result != null) {
      print("opopoopoppopopopoopo");
      setState(() {
        var detailsResult = result.result!;
        _currentAddress = detailsResult.name!;
        print(detailsResult.geometry!.location!.lat);
        //print( detailsResult.geometry!.location!.lat);
      });
    } else {
      print("KJKJKJKJKJKJKKJ");
    }
  }

//flutter build apk --split-per-abi --no-sound-null-safety
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
          homeControlller.sessiooo.value =
              sharedPreferences.getString("session") as String;
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
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;

    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.white,
        key: scaffolKey,
        drawer: session == null
            ? SizedBox()
            : SideNavigatinPage("${name}", "${iamge}", "${email}", "${phone}"),
        appBar: appBarr(context, width, height),
        body: _isLoading
            ? Container()
            : ListView(
                scrollDirection: Axis.vertical,
                children: <Widget>[
                  GetBuilder<HomeController>(builder: (homeControlller) {
                    if (homeControlller.lodaer) {
                      return Container();
                    } else {
                      var data = homeControlller.data;
                      var servicedata =
                          homeControlller.serviceList.value.serviceDetail;
                      return Container(
                        width: MediaQuery.of(context).size.width,
                        //  color: Color(Utils.hexStringToHexInt('#fbfbfc')),
                        margin: const EdgeInsets.only(left: 12, right: 12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            const SizedBox(
                              height: 12,
                            ),
                            Text(
                              'Hello ${name}!',
                              style: TextStyle(
                                  fontFamily: 'Poppins Regular',
                                  fontSize:
                                      MediaQuery.of(context).size.width * 0.05,
                                  color: Color(
                                      Utils.hexStringToHexInt('#cfcfcf'))),
                            ),
                            Text(
                              'Start looking for your Favourite Salon?',
                              style: TextStyle(
                                  fontFamily: 'Poppins Medium',
                                  fontSize:
                                      MediaQuery.of(context).size.width * 0.05,
                                  color: Color(
                                      Utils.hexStringToHexInt('#154f84'))),
                            ),
                            filterContainer(context, width, height),
                            searchHint(context),
                            session == null || session == ""
                                ? Container()
                                : ConstrainedBox(
                                    constraints: BoxConstraints(
                                      minHeight: 0.01,
                                      maxHeight: height * 0.2 - height * 0.06,
                                    ),
                                    child: ListView.builder(
                                        scrollDirection: Axis.horizontal,
                                        itemCount: homeControlller
                                            .adminCouponList
                                            .value
                                            .couponDetail
                                            ?.length,
                                        itemBuilder: (context, position) {
                                          return OfferWidger(
                                              context,
                                              width,
                                              height,
                                              homeControlller
                                                  .adminCouponList
                                                  .value
                                                  .couponDetail![position]);
                                        }),
                                  ),
                            session == null || session == ""
                                ? Container()
                                : Utils().titleText('Services', context),
                            session == null || session == ""
                                ? Container()
                                : servicelist(
                                    context, width, height, servicedata),
                            seeall(context),
                            ConstrainedBox(
                              constraints: BoxConstraints(
                                minHeight: 0.5,
                                maxHeight: height * 0.4,
                              ),
                              child:
                              ListView.builder(
                                  scrollDirection: Axis.vertical,
                                  shrinkWrap: true,
                                  itemCount: data.length,
                                  itemBuilder: (context, position) {
                                    return GestureDetector(
                                        onTap: () {
                                          print(data[position].shopId!);
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    SaloonDetail(data[position]
                                                        .shopId!)),
                                          );
                                        },
                                        child:
                                        Container(
                                          width: width,
                                          height: height * 0.2 - height * 0.06,
                                          margin: EdgeInsets.only(
                                              top: height * 0.006,
                                              bottom: height * 0.006),
                                          color: Colors.transparent,
                                          child: Card(
                                            elevation: 4.0,
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
                                                             Stack(
                                                               clipBehavior: Clip.none,
                                                               children: <Widget>[
                                                                 // // /*TODO--femina text*/

                                                                 AutoSizeText(
                                                                   data[position]
                                                                       .shopName
                                                                       .toString(),
                                                                   softWrap: false,
                                                                   maxLines: 1,
                                                                   overflow: TextOverflow.fade,
                                                                   style: TextStyle(
                                                                       color: Colors
                                                                           .black,
                                                                       fontSize: MediaQuery.of(context)
                                                                           .size
                                                                           .width *
                                                                           0.05,
                                                                       fontFamily:
                                                                       'Poppins Regular'),
                                                                 ),
                                                                 //*TODO---address*/
                                                                 Positioned(
                                                                   top: height*0.03,
                                                                   child: Container(
                                                                     width: width*0.4,
                                                                     child: Text(
                                                                       data[position]
                                                                           .location
                                                                           .toString(),
                                                                       softWrap: false,
                                                                       maxLines: 1,
                                                                       overflow: TextOverflow.fade,
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
                                                                   ),
                                                                 ),
                                                               ],
                                                             ),
                                                              SizedBox(height: 2.0,),
                                                              /*TODO---inner servce*/
                                                              SizedBox(
                                                                height: MediaQuery.of(
                                                                            context)
                                                                        .size
                                                                        .height *
                                                                    0.02,
                                                                child: ListView
                                                                    .builder(
                                                                        shrinkWrap:
                                                                            true,
                                                                        scrollDirection:
                                                                            Axis
                                                                                .horizontal,
                                                                        itemCount: data[position]
                                                                            .service!
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
                                                                                  margin: EdgeInsets.only(bottom: 1,top: 2),
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
                                                                                  padding: EdgeInsets.only(right: 2),
                                                                                  decoration: BoxDecoration(color: Color(Utils.hexStringToHexInt('E5E5E5'))),
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
                                                                child:
                                                                    RatingBarIndicator(
                                                                  rating: data[position]
                                                                              .rating !=
                                                                          null
                                                                      ? data[position]
                                                                          .rating!
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
                                                                      10.0,
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
                            )
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

      leading: InkWell(
        onTap: () {
          session != "" ? scaffolKey.currentState!.openDrawer() : null;
        },
        child: Icon(
          Icons.menu,
          color: Color(Utils.hexStringToHexInt('#77ACA2')),
        ),
      ),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            width: width * 0.03,
            height: height * 0.03,
            child: SvgPicture.asset(
              "images/svgicons/mappin.svg",
            ),
          ),
          Text(' ${_currentAddress != null ? _currentAddress : ""}',
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
            tooltip: 'Search location',
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text("Search your location"),
                    content: StatefulBuilder(
                      // You need this, notice the parameters below:
                      builder: (BuildContext context, StateSetter setState) {
                        return ConstrainedBox(
                          constraints: BoxConstraints(
                            minHeight: 0.5,
                            maxHeight: height * 0.4,
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              TextField(
                                decoration: InputDecoration(
                                  labelText: "Search",
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Color(
                                          Utils.hexStringToHexInt('77ACA2')),
                                      width: 2.0,
                                    ),
                                  ),
                                  enabledBorder: const OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Colors.black54,
                                      width: 2.0,
                                    ),
                                  ),
                                ),
                                onChanged: (value) {
                                  if (value.isNotEmpty) {
                                    setState(() {
                                      autoCompleteSearch(value);
                                    });
                                  } else {
                                    if (predictions.length > 0 && mounted) {
                                      setState(() {
                                        predictions = [];
                                      });
                                    }
                                  }
                                },
                              ),
                              ConstrainedBox(
                                constraints: BoxConstraints(
                                  minHeight: 0.5,
                                  maxHeight: height * 0.3,
                                ),
                                child: ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: predictions.length,
                                  itemBuilder: (context, index) {
                                    return ListTile(
                                      leading: CircleAvatar(
                                        backgroundColor: Colors.white60,
                                        child: Icon(
                                          Icons.pin_drop,
                                          color: Color(Utils.hexStringToHexInt(
                                              '77ACA2')),
                                        ),
                                      ),
                                      title: Text(
                                        predictions[index]
                                            .description
                                            .toString(),
                                        style: TextStyle(color: Colors.black),
                                      ),
                                      onTap: () {
                                        setState(() {
                                          debugPrint(
                                              predictions[index].placeId);
                                          getDetils(
                                              predictions[index].placeId!);
                                          Navigator.pop(context);
                                        });
                                      },
                                    );
                                  },
                                ),
                              )
                            ],
                          ),
                        );
                      },
                    ),
                  );
                },
              );
            },
          )
        ],
      ),
      elevation: 0.0,
      actions: <Widget>[
        //IconButton
        // Row(
        //   mainAxisAlignment: MainAxisAlignment.center,
        //   children: <Widget>[
        //     Container(
        //       width: width * 0.03,
        //       height: height * 0.03,
        //       child: SvgPicture.asset(
        //         "images/svgicons/mappin.svg",
        //       ),
        //     ),
        //     Text('Crossing Republick, Ghaziabad',
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
        IconButton(
          iconSize: width * 0.07,
          icon: Icon(
            CupertinoIcons.bell,
            color: Color(Utils.hexStringToHexInt('#77ACA2')),
          ),
          tooltip: 'Setting Icon',
          onPressed: () {
            if (session == null || session == "") {
              CommonDialog.showsnackbar("Please login for use this");
            } else {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => NotificationPage()),
              );
            }
          },
        ), //IconButton
      ],
      //<Widget>[]
      backgroundColor: Colors.white,

      brightness: Brightness.dark,
    );
  }

  Widget filterContainer(BuildContext context, width, height) {
    return Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height * 0.07,
        margin: EdgeInsets.only(top: height * 0.02, bottom: height * 0.02),
        //padding: const EdgeInsets.all(6.0),
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(10.0)),
          color: Colors.white,
        ),
        child: Card(
          elevation: 1.0,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(6.0)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Row(
                children: <Widget>[
                  const SizedBox(
                    width: 4.0,
                  ),
                  Icon(
                    CupertinoIcons.search,
                    color: Color(Utils.hexStringToHexInt('#77aca2')),
                    size: MediaQuery.of(context).size.width * 0.06,
                  ),
                  SizedBox(
                    width: 6.0,
                  ),
                  Center(
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width * 0.6,
                      height: MediaQuery.of(context).size.height * 0.06,
                      child: TextField(
                          autocorrect: true,
                          autofocus: false,
                          style: TextStyle(
                              fontFamily: 'Poppins Regular',
                              fontSize:
                                  MediaQuery.of(context).size.width * 0.05,
                              color: Color(Utils.hexStringToHexInt('77ACA2'))),
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Search for salons or services here?',
                            hintStyle: TextStyle(
                                fontFamily: 'Poppins Regular',
                                fontSize:
                                    MediaQuery.of(context).size.width * 0.05,
                                color:
                                    Color(Utils.hexStringToHexInt('77ACA2'))),
                          ),
                          onChanged: (value) {
                            homeControlller.filterEmplist(value);
                          }),
                    ),
                  ),
                ],
              ),
              // Container(
              //   width: MediaQuery.of(context).size.width * 0.06,
              //   height: MediaQuery.of(context).size.height * 0.06,
              //   child: SvgPicture.asset('images/svgicons/filter.svg'),
              // )
            ],
          ),
        ));
  }

  Widget searchHint(BuildContext context) {
    var list = ["makeup", "Hair cut", "Cosmetics", "Trimming"];
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height * 0.04,
      child: ListView.builder(
          itemCount: list.length,
          shrinkWrap: true,
          physics: const AlwaysScrollableScrollPhysics(),
          scrollDirection: Axis.horizontal,
          itemBuilder: (context, position) {
            return InkWell(
              onTap: () {
                print(list[position].toString().toLowerCase());
                homeControlller
                    .filterEmplist(list[position].toString().toLowerCase());
              },
              child: Container(
                width: MediaQuery.of(context).size.width * 0.3 - 5,
                margin: const EdgeInsets.only(left: 4, right: 4),
                decoration: BoxDecoration(
                    border: Border.all(
                      color: Color(Utils.hexStringToHexInt('#e5e5e5')),
                      width: 1,
                    ),
                    borderRadius:
                        const BorderRadius.all(const Radius.circular(6))),
                child: Center(
                  child: Text(
                    '${list[position]}',
                    style: TextStyle(
                        fontFamily: 'Poppins Regular',
                        fontSize: MediaQuery.of(context).size.width * 0.03,
                        color: Color(Utils.hexStringToHexInt('000000'))),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            );
          }),
    );
  }

  Widget OfferWidger(
      BuildContext context, width, height, CouponDetail couponDetail) {
    return Stack(children: [
      Container(
        width: MediaQuery.of(context).size.width - width * 0.4,
        height: MediaQuery.of(context).size.height * 0.10,
        margin: EdgeInsets.only(top: height * 0.02, left: 4, right: 4),
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
                    '${couponDetail.couponName}',
                    style: TextStyle(
                        color: Color(Utils.hexStringToHexInt('FFFFFF')),
                        fontFamily: 'Poppins Medium',
                        fontSize: MediaQuery.of(context).size.width * 0.04),
                  ),
                  // Text(
                  //   'Get 50% discount on your first booking at your favourite salon',
                  //   textAlign: TextAlign.left,
                  //   style: TextStyle(
                  //       color: Color(Utils.hexStringToHexInt('FFFFFF')),
                  //       fontFamily: 'Poppins Light',
                  //       fontSize: width * 0.03),
                  // ),
                  SizedBox(
                    height: height * 0.01,
                  ),
                  Text(
                    'Use Code : ${couponDetail.couponCode}',
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
      ),
      Positioned(
          top: height * 0.07,
          right: 0,
          child: Container(
            width: width * 0.2 - width * 0.06,
            height: height * 0.09,
            decoration: BoxDecoration(
                // Image.asset('images/svgicons/circlecoupon.png')
                image: DecorationImage(
                    image: AssetImage('images/svgicons/circlecoupon.png'))),
          ))
    ]);
  }

  Widget servicelist(
      BuildContext context, width, height, List<ServiceDetail>? serviceDetail) {
    return ConstrainedBox(
      constraints: BoxConstraints(
        minHeight: 0.05,
        maxHeight: height * 0.2 - height * 0.09,
      ),
      child: ListView.builder(
        itemCount: serviceDetail!.length,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, position) {
          double scale = 1;
          return Center(
            child: Container(
              margin: const EdgeInsets.only(left: 5, right: 5),
              width: MediaQuery.of(context).size.width * 0.2 - width * 0.04,
              height: height * 0.1,
              decoration: BoxDecoration(
                color: isSelected != null &&
                        isSelected ==
                            position //set condition like this. voila! if isSelected and list index matches it will colored as white else orange.
                    ? Color(Utils.hexStringToHexInt('77ACA2'))
                    : Colors.transparent,
                borderRadius: const BorderRadius.all(Radius.circular(8)),
              ),
              child: GestureDetector(
                onTap: () {
                  _isSelected(position);
                  debugPrint("Click working");
                },
                child: Center(
                  child: Column(
                    children: <Widget>[
                      Container(
                        margin:
                            const EdgeInsets.only(left: 6, right: 6, top: 6),
                        width: MediaQuery.of(context).size.width * 0.2 -
                            width * 0.04,
                        height: height * 0.05,
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(12)),
                        ),
                        child: Center(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8.0),
                            child: Image.network(
                              serviceDetail[position].serviceImage.toString(),
                              width: MediaQuery.of(context).size.width * 0.2 -
                                  width * 0.04,
                              height: MediaQuery.of(context).size.height * 0.1,
                              fit: isSelected != null &&
                                      isSelected ==
                                          position //set condition like this. voila! if isSelected and list index matches it will colored as white else orange.
                                  ? BoxFit.cover
                                  : null,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                          height: MediaQuery.of(context).size.height * 0.01),
                      Text(
                        serviceDetail[position].serviceTitle.toString(),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Colors.white,
                            fontFamily: 'Poppins Regular',
                            fontSize: MediaQuery.of(context).size.width * 0.03),
                      )
                    ],
                  ),
                ),
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
        InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => SeeAllShopList()),
            );
          },
          child: Text(
            'See all',
            style: TextStyle(
                fontFamily: 'Poppins Regular',
                fontSize: MediaQuery.of(context).size.height * 0.02,
                color: Color(Utils.hexStringToHexInt('#77aca2'))),
          ),
        )
      ],
    );
  }
}
