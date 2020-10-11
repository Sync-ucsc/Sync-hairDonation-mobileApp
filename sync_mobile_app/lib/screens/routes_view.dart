import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:sync_mobile_app/screens/target_page.dart';
import 'dart:ui' as ui;
import 'dart:math' show cos, sqrt, asin;

class RoutesView extends StatefulWidget {
  @override
  _RoutesViewState createState() => _RoutesViewState();
}

List<Marker> _markers = [];

class _RoutesViewState extends State<RoutesView> {
  Position position;
  LatLng _center;
  PolylinePoints polylinePoints;
  String googleApiKey = "AIzaSyAkGlhRjMfmotb0UBMf8EAcmkTB6v3WEVM";
  List<LatLng> polylineCoordinates = [];
  Map<PolylineId, Polyline> polylines = {};
  BitmapDescriptor vanLocationIcon;
  @override
  void initState() {
    _getCurrentLocation();
    _getDistance();
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

  _getDistance() async {
    print("ooooooooooooooooooooooooo");
    _createPolylines(
        _center, UserTarget.salons[0].lat, UserTarget.salons[0].lng);
    setState(() async {
      double minimumDistance = await Geolocator().distanceBetween(
        position.latitude,
        position.longitude,
        UserTarget.salons[0].lat,
        UserTarget.salons[0].lng,
      );
      print("Minimum Distance:" + minimumDistance.toString());
    });
  }

  _getMarkers() async {
    final Uint8List salonIcon =
        await getBytesFromAsset('images/salon.png', 100);

    UserTarget.salons.forEach((salon) {
      _markers.add(Marker(
          markerId: MarkerId(salon.salonName),
          draggable: false,
          position: LatLng(salon.lat, salon.lng),
          icon: BitmapDescriptor.fromBytes(salonIcon)));
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

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
    _getCurrentLocation();
  }

  _createPolylines(
      LatLng start, double destinationLat, double destinationLng) async {
    // Initializing PolylinePoints
    polylinePoints = PolylinePoints();
    _getCurrentLocation();
    // Generating the list of coordinates to be used for
    // drawing the polylines
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      googleApiKey, // Google Maps API Key
      PointLatLng(UserTarget.salons[0].lat, UserTarget.salons[0].lng),
      PointLatLng(6.927079, 79.861244),
      travelMode: TravelMode.transit,
    );

    // Adding the coordinates to the list
    if (result.points.isNotEmpty) {
      result.points.forEach((PointLatLng point) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      });
    }

    // Defining an ID
    PolylineId id = PolylineId('poly');

    // Initializing Polyline
    Polyline polyline = Polyline(
      polylineId: id,
      color: Colors.purple,
      points: polylineCoordinates,
      width: 5,
    );

    // Adding the polyline to the map
    polylines[id] = polyline;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: (_center == null)
            ? Container()
            : GoogleMap(
                onMapCreated: _onMapCreated,
                zoomControlsEnabled: true,
                myLocationButtonEnabled: false,
                initialCameraPosition: CameraPosition(
                  target: _center,
                  zoom: 17.0,
                ),
                markers: Set.from(_markers),
                polylines: Set<Polyline>.of(polylines.values),
              ));
  }
}
