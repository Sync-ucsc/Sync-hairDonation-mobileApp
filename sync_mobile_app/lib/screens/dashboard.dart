import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart';
import 'package:flutter_rounded_progress_bar/rounded_progress_bar_style.dart';
import 'package:sync_mobile_app/screens/flutter_rounded_progress_bar.dart';

bool isFirstBuild = true;

class UserTarget {
  static int target = 0;
  static int completed = 0;
}

class DashBoard extends StatefulWidget {
  @override
  _DashBoardState createState() => _DashBoardState();
}

class _DashBoardState extends State<DashBoard> {
  double percent;
  @override
  void initState() {
    setState(() {
      _percentCal();
    });
    super.initState();
  }

  Future<void> _percentCal() async {
    if (isFirstBuild) {
      percent = 0;
      isFirstBuild = false;
      print("hi");
    } else {
      setState(() {
        percent = (UserTarget.completed / UserTarget.target) * 100;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final _height = MediaQuery.of(context).size.height;
    final _width = MediaQuery.of(context).size.width;

    return Scaffold(
      body: SingleChildScrollView(
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
                        borderRadius: BorderRadius.circular(_height * 0.05),
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
                          borderRadius: BorderRadius.circular(_height * 0.04),
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
                        color: Color(0xFF9F0784), fontSize: _width * 0.05),
                    weekdayTextStyle: TextStyle(
                        color: Color(0xFF9F0784), fontSize: _width * 0.03),
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
            margin:
                EdgeInsets.only(top: _height * 0.02, bottom: _height * 0.02),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(_height * 0.04),
              side: BorderSide(color: Color(0xFF9F0784), width: _width * 0.001),
            ),
            color: Colors.white,
            child: Container(
                height: _height * 0.28,
                width: _width * 0.95,
                padding: EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      "Income Analysis",
                      style: TextStyle(
                          fontSize: 23,
                          color: Color(0xFF9F0784),
                          fontWeight: FontWeight.w500),
                    ),
                  ],
                )),
          )
        ],
      )),
    );
  }
}
