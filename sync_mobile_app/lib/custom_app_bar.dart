import 'package:flutter/material.dart';
import 'package:sync_mobile_app/screens/change_password.dart';
import 'package:sync_mobile_app/screens/dashboard.dart';
import 'package:sync_mobile_app/screens/routes_view.dart';
import 'package:sync_mobile_app/screens/target_page.dart';
import 'package:sync_mobile_app/screens/welcome_page.dart';
import 'dart:convert';
import 'package:convert/convert.dart';
import 'package:crypto/crypto.dart' as crypto;
import 'package:sync_mobile_app/http_service.dart';

class CustomAppBar extends StatefulWidget {
  CustomAppBar({Key key}) : super(key: key);

  @override
  _CustomAppBarState createState() => _CustomAppBarState();
}

class _CustomAppBarState extends State<CustomAppBar> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _oldPass = TextEditingController();
  final TextEditingController _pass = TextEditingController();
  final TextEditingController _confirmPass = TextEditingController();
  bool _autoValidate = false;
  String _password;
  String _oldPassword;
  String _confirmPassword;
  String _newPassword;
  String _submitOldPass;
  @override
  Widget build(BuildContext context) {
    final _height = MediaQuery.of(context).size.height;
    final _width = MediaQuery.of(context).size.width;

    return Container(
      child: DefaultTabController(
          length: 3,
          child: new Scaffold(
            appBar: PreferredSize(
              preferredSize: Size.fromHeight(_height * 0.2),
              child: new AppBar(
                  flexibleSpace: SafeArea(
                      child: Column(children: <Widget>[
                    Container(
                      margin: EdgeInsets.only(
                          top: _height * 0.03,
                          right: _width * 0.05,
                          left: _width * 0.05),
                      child: Row(children: <Widget>[
                        CircleAvatar(
                          radius: _width * 0.07,
                          backgroundImage: AssetImage("images/Himash.jpg"),
                        ),
                        SizedBox(width: _width * 0.04),
                        Container(
                          width: _width * 0.43,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                  UserDetails.firstName +
                                      " " +
                                      UserDetails.lastName,
                                  style: TextStyle(
                                      fontSize: _height * 0.03,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold)),
                              Text(UserDetails.currentUserEmail,
                                  style: TextStyle(
                                      fontSize: _height * 0.02,
                                      color: Colors.white,
                                      fontStyle: FontStyle.italic))
                            ],
                          ),
                        ),
                        IconButton(
                          icon: Icon(Icons.settings),
                          color: Colors.white,
                          onPressed: _showDialog,
                        ),
                        SizedBox(width: _width * 0.03),
                        IconButton(
                          icon: Icon(Icons.power_settings_new),
                          color: Colors.white,
                          onPressed: _logout,
                        )
                      ]),
                    ),
                  ])),
                  bottom: TabBar(indicatorColor: Colors.white, tabs: [
                    Tab(text: "Dashboard"),
                    Tab(text: "Map"),
                    Tab(text: "Target")
                  ]),
                  backgroundColor: Color(0xFF9F0784),
                  automaticallyImplyLeading: false),
            ),
            body: TabBarView(
                physics: NeverScrollableScrollPhysics(),
                children: [DashBoard(), RoutesView(), TargetPage()]),
          )),
    );
  }

  _logout() {
    UserDetails.currentUserEmail = null;
    UserDetails.firstName = null;
    UserDetails.lastName = null;
    UserDetails.userToken = null;

    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => WelcomePage()),
    );
  }

  void _showDialog() {
    showDialog(
        context: context,
        builder: (_) => new AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(10.0))),
            content: Builder(builder: (context) {
              var height = MediaQuery.of(context).size.height;
              var width = MediaQuery.of(context).size.width;

              return SingleChildScrollView(
                child: Container(
                  height: height - 100,
                  width: width - 100,
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          "Customize Your Profile",
                          style:
                              TextStyle(color: Color(0xFF9F0784), fontSize: 25),
                        ),
                        SizedBox(height: height * 0.04),
                        CircleAvatar(
                          radius: width * 0.17,
                          backgroundImage: AssetImage("images/Himash.jpg"),
                        ),
                        SizedBox(
                          height: height * 0.03,
                        ),
                        Text(
                          "Change Password",
                          style: TextStyle(
                              color: Color(0xFF9F0784),
                              fontSize: 25,
                              fontWeight: FontWeight.w500),
                        ),
                        Form(
                          key: _formKey,
                          autovalidate: _autoValidate,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              SizedBox(
                                height: height * 0.03,
                              ),
                              Container(
                                height: height * 0.09,
                                width: width * 0.7,
                                decoration: BoxDecoration(
                                    border: Border.all(
                                      width: 1,
                                      color: Color(0xFF9F0784),
                                    ),
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(20.0))),
                                padding: EdgeInsets.symmetric(horizontal: 10),
                                child: TextFormField(
                                    obscureText: true,
                                    keyboardType: TextInputType.text,
                                    decoration: InputDecoration(
                                      labelText: 'Old Password',
                                      fillColor: Colors.purple,
                                    ),
                                    controller: _oldPass,
                                    validator: (String arg) {
                                      if (arg.length < 8)
                                        return 'Password invalid';
                                      else
                                        return null;
                                    },
                                    onSaved: (String val) {
                                      _oldPassword = val;
                                    }),
                              ),
                              SizedBox(
                                height: 15,
                              ),
                              Container(
                                height: height * 0.09,
                                width: width * 0.7,
                                decoration: BoxDecoration(
                                    border: Border.all(
                                      width: 1,
                                      color: Color(0xFF9F0784),
                                    ),
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(20.0))),
                                padding: EdgeInsets.symmetric(horizontal: 10),
                                child: TextFormField(
                                    obscureText: true,
                                    keyboardType: TextInputType.text,
                                    decoration: InputDecoration(
                                      labelText: 'New Password',
                                      fillColor: Colors.purple,
                                    ),
                                    controller: _pass,
                                    validator: (String arg) {
                                      if (arg.length < 8)
                                        return 'Password invalid';
                                      else
                                        return null;
                                    },
                                    onSaved: (String val) {
                                      _password = val;
                                    }),
                              ),
                              SizedBox(
                                height: 15,
                              ),
                              Container(
                                height: height * 0.09,
                                width: width * 0.7,
                                decoration: BoxDecoration(
                                    border: Border.all(
                                      width: 1,
                                      color: Color(0xFF9F0784),
                                    ),
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(20.0))),
                                padding: EdgeInsets.symmetric(horizontal: 10),
                                child: TextFormField(
                                    obscureText: true,
                                    keyboardType: TextInputType.text,
                                    controller: _confirmPass,
                                    decoration: InputDecoration(
                                      labelText: 'Confirm Password',
                                      fillColor: Colors.purple,
                                    ),
                                    validator: (String arg) {
                                      if (arg != _pass.text)
                                        return "Password doesn't match";
                                      else
                                        return null;
                                    },
                                    onSaved: (String val) {
                                      _confirmPassword = val;
                                    }),
                              ),
                              SizedBox(
                                height: 30,
                              ),
                              RaisedButton(
                                padding: EdgeInsets.fromLTRB(width * 0.07,
                                    height * 0.02, width * 0.07, height * 0.02),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20)),
                                onPressed: _submit,
                                color: Color(0xFF9F0784),
                                child: Text(
                                  "Change Password",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 15.0,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )
                      ]),
                ),
              );
            })));
  }

  generateMd5(String data) {
    var content = new Utf8Encoder().convert(data);
    var md5 = crypto.md5;
    var digest = md5.convert(content);
    return hex.encode(digest.bytes);
  }

  Future<void> _submit() async {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      this._submitOldPass = generateMd5(_oldPassword);
      this._newPassword = generateMd5(_password);

      final res = await HttpService().changeProfilePassword(
          UserDetails.currentUserEmail,
          this._newPassword,
          this._submitOldPass,
          UserDetails.userToken);

      Navigator.of(context).pop();
    } else {
      setState(() {
        _autoValidate = true;
      });
    }
  }
}
