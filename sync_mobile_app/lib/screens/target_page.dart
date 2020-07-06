import 'package:flutter/material.dart';
import 'package:sync_mobile_app/http_service.dart';
import 'package:sync_mobile_app/models/target_model.dart';
import 'package:sync_mobile_app/screens/welcome_page.dart';

class TargetPage extends StatefulWidget {
  @override
  _TargetPageState createState() => _TargetPageState();
}

class _TargetPageState extends State<TargetPage> {
  List<Target> salons = [];
  @override
  void initState() {
    _getSalon();
    super.initState();
  }

  Future<void> _getSalon() async {
    final res = await HttpService().getTarget();
    for (var i = 0; i < res.data[0].targets.length; i++) {
      salons.add(res.data[0].targets[i]);
    }
    print(salons);
  }

  @override
  Widget build(BuildContext context) {
    final _height = MediaQuery.of(context).size.height;
    final _width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: ListView.separated(
        scrollDirection: Axis.vertical,
        padding: const EdgeInsets.all(8),
        itemCount: salons.length,
        itemBuilder: (BuildContext context, int index) {
          return Card(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(_height * 0.04),
                side: BorderSide(
                    color: Color(0xFF9F0784), width: _width * 0.001)),
            color: Colors.white,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        width: _width * 0.5,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              '${salons[index].salonName}',
                              style: TextStyle(
                                  color: Color(0xFF9F0784),
                                  fontSize: 22,
                                  fontWeight: FontWeight.w400),
                            ),
                            Text(
                              'No. of Wigs : ${salons[index].noOfWigs}',
                              style: TextStyle(
                                  color: Color(0xFF9F0784).withOpacity(0.6),
                                  fontSize: 17,
                                  fontStyle: FontStyle.italic),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      RaisedButton(
                        color: Color(0xFF9F0784),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30)),
                        child: Text(
                          "Complete",
                          style: TextStyle(color: Colors.white),
                        ),
                        onPressed: () => _complete(index),
                      )
                    ],
                  ),
                ),
              ],
            ),
          );
        },
        separatorBuilder: (BuildContext context, int index) => const Divider(),
      ),
    );
  }

  _complete(int index) {
    final noOfWigs = salons[index].noOfWigs;
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Are you Sure',
            style: TextStyle(color: Colors.purple),
          ),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(
                    'This Number of wigs will be added to your completed target'),
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text(
                "Yes, I'm sure",
                style: TextStyle(
                  color: Colors.purple,
                ),
              ),
              onPressed: () {},
            ),
          ],
        );
      },
    );
  }
}
