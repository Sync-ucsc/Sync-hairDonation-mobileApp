import 'package:flutter/material.dart';
import 'package:sync_mobile_app/custom_app_bar.dart';
import 'package:sync_mobile_app/models/user_model.dart';
import 'package:sync_mobile_app/http_service.dart';
import 'package:sync_mobile_app/screens/dashboard.dart';


class WelcomePage extends  StatefulWidget {
  WelcomePage({Key key}) : super(key: key);
  @override
  _WelcomePageState createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _autoValidate = false;
  String _email;
  String _password;
  


  @override
  Widget build(BuildContext context) {
   final _height=MediaQuery.of(context).size.height;
   final _width=MediaQuery.of(context).size.width;

    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("images/background.png"),
              fit: BoxFit.fill)
          ),
          width: _width,
          height: _height,
          child: SafeArea(
           child: Column(
            children: <Widget>[
            SizedBox(
              height: _height*0.02,
            ),
            Container(
                     height: _height*0.18,
                     width:_width*0.18,
                     child: Image(image: AssetImage("images/logo.png"))),
            SizedBox(
                     height:_height*0.4,
                   ),
            Form(
              key: _formKey,
              autovalidate: _autoValidate,
              child: Column(
                children: <Widget>[
                   Container(
                     margin: EdgeInsets.only(bottom:_height*0.01),
                     width: _width*0.75 ,
                     color: Colors.white,
                     child:Row(
                       children: <Widget>[
                          SizedBox(width:_width*0.05),
                          Icon(
                            Icons.email,
                            color: Colors.purple[600],),
                          SizedBox(width:_width*0.05),
                          Container(
                   
                            width: _width*0.53,
                            child:TextFormField(
                             keyboardType: TextInputType.emailAddress,
                             decoration: InputDecoration(
                             labelText: 'Email',
                             fillColor: Colors.purple,
                             ),
                             validator: validateEmail,
                              onSaved: (String val) {
                                _email = val;
                              },
                            ),
                          )
                        ]
                     )
                   ),
            
                   Container(
                     width:_width*0.75 ,
                     margin: EdgeInsets.only(bottom:_height*0.02),
                     color: Colors.white,
                     child:Row(
                       children: <Widget>[
                       SizedBox(width:_width*0.05),
                       Icon(
                          Icons.lock,
                          color: Colors.purple[600],),
                       SizedBox(width:_width*0.05),
                       Container(
                          width:_width*0.53,
                          child:TextFormField(
                            obscureText: true,
                            keyboardType: TextInputType.text,
                            decoration: InputDecoration(
                            labelText: 'Password',
                            fillColor: Colors.purple,
                            
                          ),
                          validator: (String arg) {
                               if(arg.length < 8)
                                 return 'Password invalid';
                               else
                                 return null;
                              },
                            onSaved: (String val) {
                            _password = val;}
                          ),
                        )
                       ]
                     )
                   ),
                   RaisedButton(
                     padding: EdgeInsets.fromLTRB(_width*0.1,_height*0.02,_width*0.1,_height*0.02),
                     shape: RoundedRectangleBorder(borderRadius:BorderRadius.circular(30)),
                     onPressed: _submit,
                     color: Colors.purple,
                     child: Text(
                       "Login",
                       style: TextStyle(
                         color: Colors.white,
                         fontSize: 20.0,
                       ),
                     ),)
                ],))
            
           ],
            
          
          ),
        ),
        ),
      ),
      
    );
  }


  Future<void> _submit() async {
  if (_formKey.currentState.validate()) {

    _formKey.currentState.save();

    

    final res=HttpService().authenticateUser(_email, _password);

    if(res != null){
      //Also have to get the data of the relevant driver by a get function
      Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => CustomAppBar()),
        );
    }

      } else {
    //    If all data are not valid then start auto validation.
        setState(() {
          _autoValidate = true;
        });
      }
    }
    
     
}
String validateEmail(String value) {
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern);
    if (!regex.hasMatch(value))
      return 'Enter a valid Email';
    else
      return null;
  }




