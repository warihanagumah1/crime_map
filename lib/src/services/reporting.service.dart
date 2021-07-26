import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crime_map/src/models/crime_location.model.dart';

class ReportingService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Creates a new crime report.
  Future<void> reportCrime(CrimeLocation crimeLocation) async {
    var ref = _firestore.collection('crime_reports');
    var snapshot = await ref.where('latitude', isEqualTo: crimeLocation.latitude).where('longitude', isEqualTo: crimeLocation.longitude).get();
    if (snapshot.docs.length == 0) {
      crimeLocation.id = ref.doc().id;
      await ref.doc(crimeLocation.id).set(crimeLocation.toJson());
    } else {
      for (var doc in snapshot.docs) {
        var _json = doc.data();
        CrimeLocation _crimeLocation = CrimeLocation.fromJson(_json);
        _crimeLocation.reportNumber += 1;
        _crimeLocation.crimeImages.addAll(crimeLocation.crimeImages);
        await ref.doc(_crimeLocation.id).update(_crimeLocation.toJson());
      }
    }
  }

  Future<CrimeLocation?> getCrime(double latitude, double longitude) async {
    CrimeLocation? crimeLocation;
    var ref = _firestore.collection('crime_reports');
    var snapshot = await ref.where('latitude', isEqualTo: latitude.toString()).where('longitude', isEqualTo: longitude.toString()).get();
    if (snapshot.docs.length == 0) {
      print('not found');
      return crimeLocation;
    } else {
      for (var doc in snapshot.docs) {
        print('found');
        var _json = doc.data();
        crimeLocation = CrimeLocation.fromJson(_json);
        print('____img: ' + crimeLocation.id!);
        return crimeLocation;
      }
    }
  }

  /// Returns a crime report.
  Future<void> deleteCrimeReport(String id) async {
    var ref = _firestore.collection('crime_reports');
    await ref.doc(id).delete();
  }

  /// Returns a list of all reported crime locations.
  Future<List<CrimeLocation>> getCrimeLocations() async {
    List<CrimeLocation> resultSet = [];
    var ref = _firestore.collection('crime_reports');
    var snapshots = await ref.get();

    for (var doc in snapshots.docs) {
      var _json = doc.data();
      CrimeLocation crimeLocation = CrimeLocation.fromJson(_json);
      resultSet.add(crimeLocation);
    }

    return resultSet;
  }
}
