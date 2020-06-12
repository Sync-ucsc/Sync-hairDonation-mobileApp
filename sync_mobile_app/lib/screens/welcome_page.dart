import 'package:flutter/material.dart';


class WelcomePage extends StatelessWidget {
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("images/background.png"),
              fit: BoxFit.fill)
          ),
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
        child: SafeArea(
         child: Column(
           children: <Widget>[
            SizedBox(
              height: 20.0,
            ),
            Container(
                     height: 75.0,
                     width:75.0,
                     child: Image(image: AssetImage("images/logo.png"))),
            SizedBox(
                     height:330.0,
                   ),
            Form(
              child: Column(
                children: <Widget>[
                   Container(
                     margin: EdgeInsets.only(bottom:10.0),
                     width: 300.0 ,
                     color: Colors.white,
                     child:Row(
                       children: <Widget>[
                          SizedBox(width:20.0),
                          Icon(
                            Icons.email,
                            color: Colors.purple[600],),
                          SizedBox(width:20.0),
                          Container(
                   
                            width: 200.0,
                            child:TextFormField(
                     
                             decoration: InputDecoration(
                             labelText: 'Email',
                             fillColor: Colors.purple,
                             ),
                            ),
                          )
                        ]
                     )
                   ),
            
                   Container(
                     width: 300.0 ,
                     margin: EdgeInsets.only(bottom:10.0),
                     color: Colors.white,
                     child:Row(
                       children: <Widget>[
                       SizedBox(width:20.0),
                       Icon(
                          Icons.lock,
                          color: Colors.purple[600],),
                       SizedBox(width:20.0),
                       Container(
                          width: 200.0,
                          child:TextFormField(
                     
                          decoration: InputDecoration(
                            labelText: 'Password',
                            fillColor: Colors.purple,
                            
                          ),
                          ),
                        )
                       ]
                     )
                   ),
                   RaisedButton(
                     padding: EdgeInsets.fromLTRB(50,10,50,10),
                     shape: RoundedRectangleBorder(borderRadius:BorderRadius.circular(30)),
                     onPressed: (){},
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
}


