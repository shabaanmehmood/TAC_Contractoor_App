import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Livetrackingpage extends StatefulWidget {
  const Livetrackingpage({super.key});

  @override
  State<Livetrackingpage> createState() => _LivetrackingpageState();
}

class _LivetrackingpageState extends State<Livetrackingpage> {

  LatLng sourceLocation = const LatLng(37.7749, -122.4194); // Example coordinates
  LatLng destinationLocation = const LatLng(34.0522, -118.2437); // Example coordinates

  final Completer<GoogleMapController> _controller = Completer();


  @override
  Widget build(BuildContext context) {
    return GoogleMap(
      initialCameraPosition: CameraPosition(
        target: sourceLocation,
        zoom: 13,
      ),
      markers: {
        Marker(
          markerId: const MarkerId('source'),
          position: sourceLocation,
          infoWindow: const InfoWindow(title: 'Source Location'),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
        ),
        Marker(
          markerId: const MarkerId('destination'),
          position: destinationLocation,
          infoWindow: const InfoWindow(title: 'Destination Location'),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
        ),
      },
      onMapCreated: (controller) {
        _controller.complete(controller);
      },
      myLocationButtonEnabled: true,
      myLocationEnabled: true,

    );
  }
}
