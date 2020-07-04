import 'package:flutter/material.dart';
import 'package:sync_mobile_app/screens/welcome_page.dart';

void main() {
  runApp(SyncApp());
}

class SyncApp extends StatefulWidget {
  @override
  _SyncAppState createState() => _SyncAppState();
}

class _SyncAppState extends State<SyncApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: "/welcome",
      routes: {
        "/welcome": (BuildContext context) => WelcomePage(),
      },
    );
  }
}
