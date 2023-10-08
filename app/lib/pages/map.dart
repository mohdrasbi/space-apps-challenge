import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapSample extends StatefulWidget {
  const MapSample({super.key});

  @override
  State<MapSample> createState() => MapSampleState();
}

class MapSampleState extends State<MapSample> {
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();

  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(23.5880, 58.3829),
    zoom: 13,
  );

  Marker? _currentMarker = null;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GoogleMap(
        mapType: MapType.hybrid,
        initialCameraPosition: _kGooglePlex,
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
        },
        markers: _currentMarker != null ? {_currentMarker!} : {},
        mapToolbarEnabled: true,
        onTap: (arg) {
          setState(() {
            _currentMarker = Marker(
              markerId: const MarkerId('current'),
              position: arg,
            );
          });

          showModalBottomSheet(
            context: context,
            builder: (BuildContext context) {
              return SizedBox(
                height: 400,
                child: Center(
                  child: DefaultTabController(
                    initialIndex: 1,
                    length: 3,
                    child: Scaffold(
                      appBar: AppBar(
                        bottom: const TabBar(
                          tabs: <Widget>[
                            Tab(
                              icon: Icon(Icons.cloud_outlined),
                            ),
                            Tab(
                              icon: Icon(Icons.beach_access_sharp),
                            ),
                            Tab(
                              icon: Icon(Icons.brightness_5_sharp),
                            ),
                          ],
                        ),
                      ),
                      body: const TabBarView(
                        children: <Widget>[
                          Center(
                            child: Text("It's cloudy here"),
                          ),
                          Center(
                            child: Text("It's rainy here"),
                          ),
                          Center(
                            child: Text("It's sunny here"),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
