import 'dart:io';
import 'package:flutter/material.dart';
import 'package:crime_map/src/screens/home/home.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class HomeView extends HomePageState {
  Widget buildTitle() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 5, top: 5),
      child: Text(
        'Home',
        style: TextStyle(
          fontWeight: FontWeight.w700,
          color: Colors.white,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: buildTitle(),
          elevation: 0.0,
          backgroundColor: Colors.green,
          brightness: Platform.isIOS ? Brightness.light : Brightness.dark,
          actions: [
            IconButton(
              onPressed: signout,
              icon: Icon(Icons.logout_outlined),
            ),
          ],
        ),
        body: Stack(
          children: [
            GoogleMap(
              markers: markers,
              mapType: MapType.normal,
              onMapCreated: onMapCreated,
              initialCameraPosition: initialCameraPosition,
              myLocationEnabled: true,
              myLocationButtonEnabled: true,
              onTap: (latLng) {
                openAddCrimeDirect(latLng);
              },
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Align(
                alignment: Alignment.bottomCenter,
                child: FloatingActionButton.extended(
                  onPressed: openAddCrime,
                  materialTapTargetSize: MaterialTapTargetSize.padded,
                  backgroundColor: Colors.green,
                  label: Row(
                    children: [
                      const Icon(Icons.add_outlined),
                      const SizedBox(width: 10.0),
                      const Text(
                        'Report Crime',
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
