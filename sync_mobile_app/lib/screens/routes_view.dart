import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:sync_mobile_app/http_service.dart';
import 'package:sync_mobile_app/screens/target_page.dart';
import 'dart:ui' as ui;
import 'dart:math' show cos, sqrt, asin;

import 'package:sync_mobile_app/screens/welcome_page.dart';

class Markers {
  static List<Marker> _markers = [];
}

class RoutesView extends StatefulWidget {
  @override
  _RoutesViewState createState() => _RoutesViewState();
}

class _RoutesViewState extends State<RoutesView> {
  Position currentLocation;
  Position position;
  LatLng _center;
  PolylinePoints polylinePoints;
  String googleApiKey = "AIzaSyAkGlhRjMfmotb0UBMf8EAcmkTB6v3WEVM";
  List<LatLng> polylineCoordinates = [];
  Map<PolylineId, Polyline> polylines = {};
  BitmapDescriptor vanLocationIcon;
  String salonName;
  @override
  void initState() {
    Timer.periodic(Duration(minutes: 2), (timer) {
      _locateMe();
    });
    super.initState();
  }

  _locateMe() async {
    currentLocation = await Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    setState(() {
      currentLocation = currentLocation;
    });
    HttpService().changeLocation(currentLocation.latitude,
        currentLocation.longitude, UserDetails.currentUserEmail);
  }

  _RoutesViewState() {
    _getTarget();
    _getCurrentLocation();
  }

  _getTarget() async {
    final res = await HttpService().getTarget();
    for (var i = 0; i < res.data[0].targets.length; i++) {
      if (res.data[0].targets[i].status == "NeedToDeliver") {
        setState(() {
          UserTarget.salons.add(res.data[0].targets[i]);
        });
      }
    }
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

        Markers._markers.add(Marker(
            markerId: MarkerId('currentLocation'),
            draggable: false,
            position: _center,
            icon: BitmapDescriptor.fromBytes(markerIcon)));
        print(_center);
        _getDistance();
        _getMarkers();
      } catch (e) {
        print(e);
      }
    });
  }

  _getDistance() async {
    double minimumDistance = await Geolocator().distanceBetween(
      position.latitude,
      position.longitude,
      UserTarget.salons[0].lat,
      UserTarget.salons[0].lng,
    );
    salonName = UserTarget.salons[0].salonName;

    UserTarget.salons.forEach((element) async {
      double distance = await Geolocator().distanceBetween(
          position.latitude, position.longitude, element.lat, element.lng);
      if (distance < minimumDistance) {
        minimumDistance = distance;
        salonName = element.salonName;
      }
    });
  }

  _getMarkers() async {
    final Uint8List salonIcon =
        await getBytesFromAsset('images/salon.png', 100);

    UserTarget.salons.forEach((salon) {
      Markers._markers.add(Marker(
          markerId: MarkerId(salon.salonName),
          draggable: false,
          position: LatLng(salon.lat, salon.lng),
          icon: BitmapDescriptor.fromBytes(salonIcon)));
    });
    print("Creaaaaaaaaaaaaaaaating polyline");
    print(position.latitude);
    UserTarget.salons.forEach((element) {
      if (element.salonName == salonName) {
        _createPolylines(position, element.lat, element.lng);
      }
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
      Position start, double destinationLat, double destinationLng) async {
    // Initializing PolylinePoints
    polylinePoints = PolylinePoints();

    // Generating the list of coordinates to be used for
    // drawing the polylines
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      googleApiKey, // Google Maps API Key
      PointLatLng(start.latitude, start.longitude),
      PointLatLng(destinationLat, destinationLng),
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
                markers: Set.from(Markers._markers),
                polylines: Set<Polyline>.of(polylines.values),
              ));
  }
}
