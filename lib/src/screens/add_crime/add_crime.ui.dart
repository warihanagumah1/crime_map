import 'dart:io';
import 'package:crime_map/src/components/buttons.dart';
import 'package:flutter/material.dart';
import 'package:crime_map/src/screens/add_crime/add_crime.dart';

class AddCrimeView extends AddCrimePageState {
  Widget buildTitle() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 5, top: 5),
      child: Text(
        'Add Crime',
        style: TextStyle(
          fontWeight: FontWeight.w700,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget buildSelectedLatLng() {
    return Container(
      padding: const EdgeInsets.only(bottom: 10, top: 10),
      color: Colors.black,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text(
                'Latitude',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'Longitude',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text(
                widget.latitude.toString(),
                style: TextStyle(color: Colors.white),
              ),
              Text(
                widget.longitude.toString(),
                style: TextStyle(color: Colors.white),
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget buildSelectedImages() {
    return Center(
      child: Container(
        height: 250.0,
        padding: const EdgeInsets.all(5.0),
        child: GridView.builder(
          shrinkWrap: true,
          itemCount: selectedImagesPath.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
          itemBuilder: (context, index) {
            return Stack(
              alignment: Alignment.topRight,
              children: [
                if (!isFromOnline)
                  Container(
                    height: 120,
                    width: 200,
                    margin: const EdgeInsets.all(5.0),
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        fit: BoxFit.cover,
                        image: FileImage(
                          File(selectedImagesPath[index]),
                        ),
                      ),
                    ),
                  )
                else
                  Container(
                    height: 120,
                    width: 200,
                    margin: const EdgeInsets.all(5.0),
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        fit: BoxFit.cover,
                        image: NetworkImage(selectedImagesPath[index]),
                      ),
                    ),
                  ),
                IconButton(
                  onPressed: () => removePhoto(index),
                  icon: Icon(
                    Icons.delete_outline,
                    color: Colors.white,
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget buildPickImageView() {
    return PopupMenuButton(
      child: Center(
        child: Container(
          padding: const EdgeInsets.only(top: 30.0, bottom: 30.0),
          width: MediaQuery.of(context).size.width * 0.80,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(6.0),
            border: Border.all(
              color: Colors.grey.shade400,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(
                Icons.image_outlined,
                size: 60.0,
              ),
              SizedBox(height: 30.0),
              Text(
                'Add Crime Photo(s).\nNOTE: This is not required.',
                style: TextStyle(
                  fontSize: 11.0,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
      onSelected: (value) {
        handleImageOptions(value);
      },
      itemBuilder: (context) => [
        PopupMenuItem(
          value: 1,
          child: Text('Take Photo'),
        ),
        PopupMenuItem(
          value: 2,
          child: Text('Choose From Gallery'),
        ),
      ],
    );
  }

  Widget buildLatitudeTextField() {
    return Container(
      margin: const EdgeInsets.only(top: 2.0, bottom: 5.0),
      width: MediaQuery.of(context).size.width * 0.80,
      child: TextFormField(
        enabled: false,
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderSide: BorderSide(
              width: 0.5,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              width: 0.5,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              width: 0.5,
            ),
          ),
          floatingLabelBehavior: FloatingLabelBehavior.auto,
          labelText: 'Enter Latitude',
          labelStyle: TextStyle(
            fontSize: 15.0,
            fontWeight: FontWeight.w500,
          ),
          contentPadding: EdgeInsets.only(left: 20.0, right: 10.0),
        ),
        style: TextStyle(
          fontSize: 15.0,
          fontWeight: FontWeight.bold,
        ),
        controller: latitudeCtrl,
        keyboardType: TextInputType.number,
        validator: (value) => value!.isEmpty ? 'Please enter a latitude.' : null,
      ),
    );
  }

  Widget buildLongitudeTextField() {
    return Container(
      margin: const EdgeInsets.only(top: 2.0, bottom: 5.0),
      width: MediaQuery.of(context).size.width * 0.80,
      child: TextFormField(
        enabled: false,
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderSide: BorderSide(
              width: 0.5,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              width: 0.5,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              width: 0.5,
            ),
          ),
          floatingLabelBehavior: FloatingLabelBehavior.auto,
          labelText: 'Entyer Longitude',
          labelStyle: TextStyle(
            fontSize: 15.0,
            fontWeight: FontWeight.w500,
          ),
          contentPadding: EdgeInsets.only(left: 20.0, right: 10.0),
        ),
        style: TextStyle(
          fontSize: 15.0,
          fontWeight: FontWeight.bold,
        ),
        controller: longitudeCtrl,
        keyboardType: TextInputType.number,
        validator: (value) => value!.isEmpty ? 'Please enter a longitude' : null,
      ),
    );
  }

  Widget buildSubmitButton() {
    return primaryButton(
      context: context,
      onPressed: reportCrime,
      text: 'Report',
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
          brightness: Platform.isIOS ? Brightness.dark : Brightness.light,
          leading: IconButton(
            onPressed: goBack,
            icon: Icon(Icons.arrow_back_outlined),
          ),
        ),
        body: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.only(bottom: 30.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                buildSelectedLatLng(),
                SizedBox(height: 30.0),
                if (selectedImagesPath.length == 0)
                  buildPickImageView()
                else if (isLoadingImages)
                  SizedBox(
                    height: 50,
                    width: 50,
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation(Colors.green),
                    ),
                  )
                else
                  buildSelectedImages(),
                SizedBox(height: 20.0),
                buildLatitudeTextField(),
                buildLongitudeTextField(),
                SizedBox(height: 30.0),
                buildSubmitButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
