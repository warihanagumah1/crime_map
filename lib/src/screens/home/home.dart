import 'dart:async';
import 'package:crime_map/src/components/loading_dialog.dart';
import 'package:crime_map/src/components/tour_modal.dart';
import 'package:crime_map/src/models/crime_location.model.dart';
import 'package:crime_map/src/screens/add_crime/add_crime.dart';
import 'package:crime_map/src/screens/home/home.ui.dart';
import 'package:crime_map/src/screens/signin/signin.dart';
import 'package:crime_map/src/services/account.services.dart';
import 'package:crime_map/src/services/reporting.service.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class HomePage extends StatefulWidget {
  @override
  HomeView createState() => HomeView();
}

abstract class HomePageState extends State<HomePage> {
  late double latitude;
  late double longitude;
  late CameraPosition initialCameraPosition;

  Set<Marker> markers = {};
  Location location = Location();
  List<CrimeLocation> crimeLocationList = [];
  Completer<GoogleMapController> controller = Completer();
  LatLng centerLatLng = const LatLng(45.521563, -122.677433);

  @override
  void initState() {
    super.initState();
    initialize();

    handleFirstTimeUser();
    getAllCrimeLocations();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void goBack() {
    Navigator.pop(context);
  }

  void initialize() {
    print('init');
    initialCameraPosition = CameraPosition(
      target: centerLatLng,
      zoom: 11.0,
    );
  }

  void refresh() {
    initialize();
    getAllCrimeLocations();
    setState(() {});
  }

  void signout() async {
    presentLoadingDialog();

    AccountService accountService = AccountService();
    await accountService.signOutFromGoogle();

    hideLoadingDialog();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => SigninPage(),
      ),
    );
  }

  void presentLoadingDialog() {
    return showLoadingDialog(
      context: context,
      text: 'Signing you out ...',
    );
  }

  void hideLoadingDialog() {
    Navigator.pop(context);
  }

  Future<void> showProductDescriptionModal() {
    return showProductTourModal(context: context);
  }

  void handleFirstTimeUser() {
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      this.showProductDescriptionModal();
    });
  }

  void getAllCrimeLocations() async {
    ReportingService reportingService = ReportingService();
    crimeLocationList = await reportingService.getCrimeLocations();

    setAllCrimeLocationMarkers(crimeLocationList);
  }

  void setAllCrimeLocationMarkers(List<CrimeLocation> crimeLocations) {
    for (var location in crimeLocations) {
      int reportNumber = location.reportNumber;
      double latitude = double.parse(location.latitude);
      double longitude = double.parse(location.longitude);
      if (reportNumber < 5) {
        setLowCrimeMarker(location.id!, latitude, longitude);
      } else if (reportNumber > 5 && reportNumber < 20) {
        setMinimumCrimeMarker(location.id!, latitude, longitude);
      } else if (reportNumber > 20) {
        setHighCrimeMarker(location.id!, latitude, longitude);
      } else {
        // we just arent sure.
      }
    }
  }

  void setLowCrimeMarker(String markerId, double latitude, double longitude) {
    markers.add(
      new Marker(
        markerId: MarkerId(markerId),
        position: LatLng(latitude, longitude),
        icon: BitmapDescriptor.defaultMarkerWithHue(
          BitmapDescriptor.hueGreen,
        ),
        onTap: () {
          openAddCrimeDirect(LatLng(latitude, longitude));
        },
      ),
    );
  }

  void setMinimumCrimeMarker(String markerId, double latitude, double longitude) {
    markers.add(
      new Marker(
        markerId: MarkerId(markerId),
        position: LatLng(latitude, longitude),
        icon: BitmapDescriptor.defaultMarkerWithHue(
          BitmapDescriptor.hueOrange,
        ),
        onTap: () {
          openAddCrimeDirect(LatLng(latitude, longitude));
        },
      ),
    );
  }

  void setHighCrimeMarker(String markerId, double latitude, double longitude) {
    markers.add(
      new Marker(
        markerId: MarkerId(markerId),
        position: LatLng(latitude, longitude),
        icon: BitmapDescriptor.defaultMarkerWithHue(
          BitmapDescriptor.hueRed,
        ),
        onTap: () {
          openAddCrimeDirect(LatLng(latitude, longitude));
        },
      ),
    );
  }

  void getCurrentLocation(GoogleMapController? ctrl) {
    print('on created');
    location.onLocationChanged.listen((l) {
      setState(() {
        latitude = l.latitude!;
        longitude = l.longitude!;
      });
      ctrl!.animateCamera(
        CameraUpdate.newCameraPosition(
          initialCameraPosition = CameraPosition(
            target: LatLng(l.latitude!, l.longitude!),
            zoom: 15,
          ),
        ),
      );
    });
  }

  void onMapCreated(GoogleMapController? ctrl) {
    controller.complete(ctrl);
    getCurrentLocation(ctrl);
    ctrl!.setMapStyle('[{"featureType": "poi","stylers": [{"visibility": "off"}]}]');
  }

  void openAddCrime() async {
    var res = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddCrimePage(latitude: latitude, longitude: longitude),
      ),
    );

    if (res != null) {
      refresh();
    }
  }

  void openAddCrimeDirect(LatLng latLng) async {
    var res = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddCrimePage(latitude: latLng.latitude, longitude: latLng.longitude),
      ),
    );

    if (res != null) {
      refresh();
    }
  }
}
