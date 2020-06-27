import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class RoutesView extends StatefulWidget {
  @override
  _RoutesViewState createState() => _RoutesViewState();
}

class _RoutesViewState extends State<RoutesView> {
 
  GoogleMapController mapController;

  final LatLng _center = const LatLng(6.8372, 79.9203);





  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }
  
  @override
  Widget build(BuildContext context) {

        return Scaffold(
          body:GoogleMap(
         
       onMapCreated: _onMapCreated,
       initialCameraPosition: CameraPosition(
       target: _center,
       zoom: 13.0,)
      )
    );
  }
}