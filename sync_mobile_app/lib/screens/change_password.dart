import 'package:flutter/material.dart';
import 'package:sync_mobile_app/http_service.dart';
import 'package:sync_mobile_app/screens/welcome_page.dart';
import 'dart:convert';
import 'package:convert/convert.dart';
import 'package:crypto/crypto.dart' as crypto;

class passwordChange {
  static String _password;
}

class ChangePassword extends StatefulWidget {
  ChangePassword({Key key}) : super(key: key);
  @override
  _ChangePasswordState createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _pass = TextEditingController();
  final TextEditingController _confirmPass = TextEditingController();
  bool _autoValidate = false;
  String _password;
  String _confirmPassword;
  String _newPassword;
  @override
  Widget build(BuildContext context) {
    final _height = MediaQuery.of(context).size.height;
    final _width = MediaQuery.of(context).size.width;

    return Scaffold(
        body: SingleChildScrollView(
      child: Stack(
        children: <Widget>[
          Opacity(
            opacity: 0.8,
            child: Container(
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage("images/background.png"),
                      fit: BoxFit.fill)),
              width: _width,
              height: _height,
            ),
          ),
          SafeArea(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              SizedBox(
                height: _height * 0.08,
              ),
              Container(
                height: _height * 0.65,
                width: _width * 0.8,
                margin: EdgeInsets.all(40),
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.circular(_height * 0.04),
                ),
                child: Padding(
                  padding: EdgeInsets.all(25.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      SizedBox(
                        height: _height * 0.03,
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
                              height: _height * 0.12,
                            ),
                            Container(
                              height: _height * 0.09,
                              width: _width * 0.7,
                              decoration: BoxDecoration(
                                  border: Border.all(
                                    width: 1,
                                    color: Color(0xFF9F0784),
                                  ),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20.0))),
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
                              height: 30,
                            ),
                            Container(
                              height: _height * 0.09,
                              width: _width * 0.7,
                              decoration: BoxDecoration(
                                  border: Border.all(
                                    width: 1,
                                    color: Color(0xFF9F0784),
                                  ),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20.0))),
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
                              padding: EdgeInsets.fromLTRB(
                                  _width * 0.07,
                                  _height * 0.02,
                                  _width * 0.07,
                                  _height * 0.02),
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
                      ),
                    ],
                  ),
                ),
              )
            ],
          ))
        ],
      ),
    ));
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
      this._newPassword = generateMd5(_password);
      passwordChange._password = this._newPassword;
      final res = await HttpService().changePassword(
          UserDetails.currentUserEmail,
          passwordChange._password,
          UserDetails.userToken);

      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => WelcomePage()),
      );
    } else {
      setState(() {
        _autoValidate = true;
      });
    }
  }
}
