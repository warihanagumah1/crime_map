class CrimeLocation {
  String? id;
  late String latitude;
  late String longitude;
  late int reportNumber;
  late List<String> crimeImages;

  CrimeLocation({
    this.id,
    required this.latitude,
    required this.longitude,
    required this.reportNumber,
    required this.crimeImages,
  });

  CrimeLocation.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    reportNumber = json['report_number'];
    crimeImages = json['crime_images'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['latitude'] = this.latitude;
    data['longitude'] = this.longitude;
    data['report_number'] = this.reportNumber;
    data['crime_images'] = this.crimeImages;
    return data;
  }
}
