import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart';
import 'package:flutter_rounded_progress_bar/rounded_progress_bar_style.dart';
import 'package:geolocator/geolocator.dart';
import 'package:sync_mobile_app/http_service.dart';
import 'package:sync_mobile_app/screens/routes_view.dart';
import 'package:sync_mobile_app/screens/target_page.dart';
import 'package:sync_mobile_app/screens/flutter_rounded_progress_bar.dart';
import 'package:sync_mobile_app/screens/welcome_page.dart';

bool isFirstBuild = true;

class DashBoard extends StatefulWidget {
  @override
  _DashBoardState createState() => _DashBoardState();
}

class _DashBoardState extends State<DashBoard> {
  double percent;
  Position currentLocation;
  @override
  void initState() {
    Timer.periodic(Duration(minutes: 2), (timer) {
      _locateMe();
    });
    setState(() {
      _percentCal();
    });
    super.initState();
  }

  _locateMe() async {
    currentLocation = await Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    setState(() {
      currentLocation = currentLocation;
    });
    HttpService().changeLocation(currentLocation.latitude,
        currentLocation.longitude, UserDetails.currentUserEmail);
  }

  _DashBoardState() {
    _percentCal();
  }

  Future<void> _percentCal() async {
    setState(() {
      UserTarget.salons = [];
    });
    final res = await HttpService().getTarget();
    for (var i = 0; i < res.data[0].targets.length; i++) {
      setState(() {
        UserTarget.completed = 0;
        UserTarget.salons.add(res.data[0].targets[i]);
      });
    }
    UserTarget.salons.forEach((element) {
      if (element.status == "Delivered") {
        setState(() {
          UserTarget.completed += element.noOfWigs;
        });
      }
    });
    setState(() {
      percent = (UserTarget.completed / UserTarget.target) * 100;
    });
  }

  @override
  Widget build(BuildContext context) {
    final _height = MediaQuery.of(context).size.height;
    final _width = MediaQuery.of(context).size.width;

    return Scaffold(
      body: (percent == null)
          ? Container()
          : SingleChildScrollView(
              child: Column(
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Column(children: <Widget>[
                      Column(children: [
                        Container(
                            child: Stack(
                          children: <Widget>[
                            ClipRRect(
                              borderRadius:
                                  BorderRadius.circular(_height * 0.05),
                              child: Image.asset(
                                "images/Progress.png",
                                height: _height * 0.2,
                                width: _width * 0.47,
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(
                                  top: _height * 0.1, left: _width * 0.05),
                              child: Text(
                                "Your Progress",
                                style: TextStyle(
                                    fontSize: _height * 0.023,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.rectangle,
                                borderRadius:
                                    BorderRadius.circular(_height * 0.04),
                              ),
                              margin: EdgeInsets.only(
                                  top: _height * 0.152, left: _width * 0.01),
                              height: _height * 0.12,
                              width: _width * 0.43,
                              child: Center(
                                child: RoundedProgressBar(
                                    style: RoundedProgressBarStyle(
                                        borderWidth: 0, widthShadow: 0),
                                    childLeft: Text("$percent%",
                                        style: TextStyle(color: Colors.white)),
                                    margin: EdgeInsets.symmetric(vertical: 8),
                                    borderRadius: BorderRadius.circular(6),
                                    percent: percent,
                                    theme: RoundedProgressBarTheme.purple),
                              ),
                            )
                          ],
                        ))
                      ]),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            Card(
                              shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.circular(_height * 0.04)),
                              margin: EdgeInsets.only(
                                  top: _height * 0.025,
                                  left: _width * 0.01,
                                  right: _width * 0.01),
                              color: Color(0xFF9F0784),
                              child: Container(
                                height: _height * 0.13,
                                width: _width * 0.2,
                                child: Column(children: <Widget>[
                                  SizedBox(height: _height * 0.02),
                                  Text(
                                    "Target",
                                    style: TextStyle(
                                        fontSize: _height * 0.02,
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    UserTarget.target.toString(),
                                    style: TextStyle(
                                        fontSize: _height * 0.05,
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold),
                                  )
                                ]),
                              ),
                            ),
                            Card(
                              shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.circular(_height * 0.04)),
                              margin: EdgeInsets.only(
                                  top: _height * 0.02,
                                  left: _width * 0.01,
                                  right: _width * 0.01),
                              color: Color(0xFFF5E5F2),
                              child: Container(
                                height: _height * 0.13,
                                width: _width * 0.2,
                                child: Column(children: <Widget>[
                                  SizedBox(height: _height * 0.02),
                                  Text(
                                    "Total",
                                    style: TextStyle(
                                        fontSize: _height * 0.02,
                                        color: Color(0xFF9F0784),
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    "52",
                                    style: TextStyle(
                                        fontSize: _height * 0.06,
                                        color: Color(0xFF9F0784),
                                        fontWeight: FontWeight.bold),
                                  )
                                ]),
                              ),
                            ),
                          ]),
                    ]),
                    Card(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(_height * 0.04),
                          side: BorderSide(
                              color: Color(0xFF9F0784), width: _width * 0.001)),
                      margin: EdgeInsets.only(top: _height * 0.03),
                      color: Colors.white,
                      child: Container(
                        height: _height * 0.4,
                        width: _width * 0.5,
                        child: CalendarCarousel(
                          rightButtonIcon: Icon(
                            Icons.chevron_right,
                            color: Color(0xFF9F0784),
                          ),
                          leftButtonIcon: Icon(
                            Icons.chevron_left,
                            color: Color(0xFF9F0784),
                          ),
                          headerTextStyle: TextStyle(
                              color: Color(0xFF9F0784),
                              fontSize: _width * 0.05),
                          weekdayTextStyle: TextStyle(
                              color: Color(0xFF9F0784),
                              fontSize: _width * 0.03),
                          width: _width * 0.5,
                          todayButtonColor: Color(0xFF9F0784),
                          thisMonthDayBorderColor: Color(0xFFF5E5F2),
                          selectedDayButtonColor: Color(0xFFF5E5F2),
                        ),
                      ),
                    ),
                  ],
                ),
                Card(
                  margin: EdgeInsets.only(
                      top: _height * 0.02, bottom: _height * 0.02),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(_height * 0.04),
                    side: BorderSide(
                        color: Color(0xFF9F0784), width: _width * 0.001),
                  ),
                  color: Colors.white,
                  child: Container(
                      height: _height * 0.28,
                      width: _width * 0.95,
                      padding: EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.only(left: _height * 0.01),
                            child: Text(
                              "Target : ",
                              style: TextStyle(
                                  fontSize: 23,
                                  color: Color(0xFF9F0784),
                                  fontWeight: FontWeight.w500),
                            ),
                          ),
                          SizedBox(height: 5),
                          // GridView.builder(
                          //     itemCount: 6,
                          //     gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          //         crossAxisCount: 3, childAspectRatio: 8.0 / 10.0),
                          //     itemBuilder: (BuildContext context, int index) {
                          //       return Padding(
                          //         padding: EdgeInsets.all(5),
                          //         child: Card(
                          //           shape: RoundedRectangleBorder(
                          //               borderRadius: BorderRadius.circular(10)),
                          //           clipBehavior: Clip.antiAlias,
                          //           child: Column(
                          //             children: <Widget>[
                          //               Expanded(
                          //                   child: Container(
                          //                 decoration: BoxDecoration(
                          //                   image: DecorationImage(
                          //                       image:
                          //                           AssetImage("images/Himash.jpg"),
                          //                       fit: BoxFit.fill),
                          //                 ),
                          //               )),
                          //               Padding(
                          //                   padding: EdgeInsets.all(10.0),
                          //                   child: Text(
                          //                     "Name",
                          //                     style: TextStyle(fontSize: 18.0),
                          //                   )),
                          //             ],
                          //           ),
                          //         ),
                          //       );
                          //     })
                        ],
                      )),
                )
              ],
            )),
    );
  }
}
