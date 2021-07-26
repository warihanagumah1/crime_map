import 'dart:io';
import 'package:crime_map/src/components/loading_dialog.dart';
import 'package:crime_map/src/models/crime_location.model.dart';
import 'package:crime_map/src/screens/add_crime/add_crime.ui.dart';
import 'package:crime_map/src/services/reporting.service.dart';
import 'package:crime_map/src/services/storage.service.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:images_picker/images_picker.dart';

class AddCrimePage extends StatefulWidget {
  final double latitude;
  final double longitude;

  AddCrimePage({
    required this.latitude,
    required this.longitude,
  });

  @override
  AddCrimeView createState() => AddCrimeView();
}

abstract class AddCrimePageState extends State<AddCrimePage> {
  late bool isFromOnline;
  late bool isLoadingImages;
  late List<Media> selectedImages;
  late StorageService storageService;
  late List<String> selectedImagesPath;
  late ReportingService reportingService;
  TextEditingController latitudeCtrl = TextEditingController();
  TextEditingController longitudeCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    selectedImages = [];
    selectedImagesPath = [];

    isFromOnline = false;
    isLoadingImages = false;

    latitudeCtrl.text = widget.latitude.toString();
    longitudeCtrl.text = widget.longitude.toString();

    storageService = StorageService();
    reportingService = ReportingService();

    getCrimeImagesIfExists();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void goBack() {
    Navigator.pop(context, 0);
  }

  void showSavedToast() {
    Fluttertoast.showToast(
      msg: 'Crime reported.',
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: Colors.white54,
      textColor: Colors.black87,
      fontSize: 16.0,
    );
  }

  void presentLoadingDialog() {
    return showLoadingDialog(
      context: context,
      text: 'Please wait ...',
    );
  }

  void hideLoadingDialog() {
    Navigator.pop(context);
  }

  void handleImageOptions(Object? value) {
    print(value.toString());
    switch (value.toString()) {
      case '1':
        showCamera();
        break;
      case '2':
        openFilePicker();
        break;
      default:
        break;
    }
  }

  void removePhoto(int index) {
    setState(() {
      selectedImages.removeAt(index);
      selectedImagesPath.removeAt(index);
    });
  }

  Future<void> showCamera() async {
    var images = await ImagesPicker.openCamera(
      quality: 1.0,
      pickType: PickType.image,
      cropOpt: CropOption(cropType: CropType.circle),
    );
    if (images != null) {
      if (images.length != 0) {
        setState(() {
          this.isFromOnline = false;
          this.isLoadingImages = false;
          selectedImages.add(images[0]);
          selectedImagesPath.add(selectedImages[0].path);
        });
      }
    }
  }

  Future<void> openFilePicker() async {
    this.selectedImagesPath = [];
    var images = await ImagesPicker.pick(
      count: 2,
      pickType: PickType.image,
    );
    if (images != null) {
      this.selectedImages = images;
      print('imgs_: ${images.length}');
      for (var image in images) {
        setState(() {
          this.isFromOnline = false;
          this.isLoadingImages = false;
          this.selectedImagesPath.add(image.path);
        });
      }
    }
  }

  Future<List<String>> uploadImages(List<Media> images) async {
    List<File> files = storageService.convertMediaToFile(images);
    return await storageService.uploadImages(files);
  }

  void getCrimeImagesIfExists() async {
    setState(() {
      isLoadingImages = true;
    });
    CrimeLocation? crime = await reportingService.getCrime(widget.latitude, widget.longitude);
    if (crime != null) {
      if (crime.crimeImages.length > 0) {
        for (var img in crime.crimeImages) {
          setState(() {
            isFromOnline = true;
            isLoadingImages = false;
            selectedImages.add(
              Media(path: img, size: 100),
            );
          });
        }
      }
      if (crime.crimeImages.length > 0) {
        for (var img in crime.crimeImages) {
          setState(() {
            isFromOnline = true;
            isLoadingImages = false;
            selectedImagesPath.add(img);
          });
        }
      }
    }
  }

  void reportCrime() async {
    this.presentLoadingDialog();

    var crimeImageUrls = await this.uploadImages(selectedImages);
    var crimeLocation = CrimeLocation(
      reportNumber: 1,
      latitude: widget.latitude.toString(),
      longitude: widget.longitude.toString(),
      crimeImages: crimeImageUrls,
    );

    await reportingService.reportCrime(crimeLocation);
    this.hideLoadingDialog();
    this.showSavedToast();
  }
}
