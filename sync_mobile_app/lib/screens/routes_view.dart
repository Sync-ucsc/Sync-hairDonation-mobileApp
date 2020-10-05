import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:sync_mobile_app/screens/target_page.dart';
import 'dart:ui' as ui;

class RoutesView extends StatefulWidget {
  @override
  _RoutesViewState createState() => _RoutesViewState();
}

List<Marker> _markers = [];

class _RoutesViewState extends State<RoutesView> {
  Position position;
  LatLng _center;

  BitmapDescriptor vanLocationIcon;
  @override
  void initState() {
    _getCurrentLocation();
    _getMarkers();
    super.initState();
  }

  _getCurrentLocation() async {
    position = await Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);

    print("Location" + position.toString());
    final Uint8List markerIcon = await getBytesFromAsset('images/van.png', 100);
    vanLocationIcon = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(devicePixelRatio: 0.5), 'images/van.png');
    setState(() {
      try {
        _center = LatLng(position.latitude, position.longitude);

        _markers.add(Marker(
            markerId: MarkerId('currentLocation'),
            draggable: false,
            position: _center,
            icon: BitmapDescriptor.fromBytes(markerIcon)));
        print(_center);
      } catch (e) {
        print(e);
      }
    });
  }

  _getMarkers() async {
    UserTarget.salons.forEach((salon) {
      _markers.add(Marker(
        markerId: MarkerId(salon.salonName),
        draggable: false,
        position: LatLng(salon.lat, salon.lng),
      ));
    });
  }

  Future<Uint8List> getBytesFromAsset(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
        targetWidth: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))
        .buffer
        .asUint8List();
  }

  GoogleMapController mapController;

  final LatLng _start = LatLng(6.8372, 79.9203);

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
    _getCurrentLocation();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: (_center == null)
            ? Container()
            : GoogleMap(
                onMapCreated: _onMapCreated,
                zoomControlsEnabled: false,
                myLocationButtonEnabled: false,
                initialCameraPosition: CameraPosition(
                  target: _center,
                  zoom: 17.0,
                ),
                markers: Set.from(_markers),
              ));
  }
}
