import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapScreen extends StatelessWidget {
  final String locationName;
  final LatLng locationCoords;

  const MapScreen({
    Key? key,
    required this.locationName,
    required this.locationCoords,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(locationName),
      ),
      body: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: locationCoords,
          zoom: 14.0,
        ),
        markers: {
          Marker(
            markerId: MarkerId(locationName),
            position: locationCoords,
            infoWindow: InfoWindow(
              title: locationName,
            ),
          ),
        },
      ),
    );
  }
}
