import 'package:flutter/material.dart';
import 'package:sync_mobile_app/screens/dashboard.dart';
import 'package:sync_mobile_app/screens/routes_view.dart';
import 'package:sync_mobile_app/screens/target_page.dart';


class CustomAppBar extends StatefulWidget {
  @override
  _CustomAppBarState createState() => _CustomAppBarState();
}

class _CustomAppBarState extends State<CustomAppBar> {
  @override
  Widget build(BuildContext context) {
   final _height=MediaQuery.of(context).size.height;
   final _width=MediaQuery.of(context).size.width;

    return Container(
     
      child:DefaultTabController(
        length: 3, 
        child: new Scaffold(
         
         appBar: PreferredSize(
           preferredSize: Size.fromHeight(_height*0.2),
           child: new AppBar(
             
             flexibleSpace: SafeArea(
              child: Column(
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(top:_height*0.03,right:_width*0.05,left:_width*0.05 ),
                    child: Row(
                      
                      children: <Widget>[
                        CircleAvatar(
                          radius: _width*0.07,
                          backgroundImage: AssetImage("images/Himash.jpg"),
                        ),
                        SizedBox(width:_width*0.04),
                         Column(
                           crossAxisAlignment: CrossAxisAlignment.start,
                           children: <Widget>[
                             
                             Text("Sachindu Himash Peiris",style:TextStyle(fontSize: _height*0.03,color: Colors.white,fontWeight: FontWeight.bold)),
                             Text("himash1997@gmail.com",style:TextStyle(fontSize: _height*0.02,color:Colors.white, fontStyle:FontStyle.italic))
                           ],
                         ),
                         SizedBox(width:_width*0.05),
                         Icon(Icons.settings,color: Colors.white,)
                      ]
                    ),
                  ),])
                   ),
              bottom: TabBar(
                  
                    indicatorColor: Colors.white, 
                    tabs: [
                      Tab(text:"Dashboard"),
                      Tab(text:"Map"),
                      Tab(text:"Target")]
                      
                  ),
              backgroundColor: Color(0xFF9F0784), 
              automaticallyImplyLeading: false  
              
             ),
         ),
           
        body: TabBarView(
          children:[
            DashBoard(),
            RoutesView(),
            TargetPage()
          ]),
        
        )
        ),
      
    );
  }
}