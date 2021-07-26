import 'package:crime_map/src/components/buttons.dart';
import 'package:crime_map/src/screens/signin/signin.dart';
import 'package:flutter/material.dart';

class SigninView extends SigninPageState {
  Widget buildTitle() {
    return Container(
      child: Text(
        'Crime Map',
        style: TextStyle(fontSize: 40.0),
      ),
    );
  }

  Widget buildIcon() {
    return Container(
      child: Icon(
        Icons.map_outlined,
        size: 100.0,
      ),
    );
  }

  Widget buildDescription() {
    return Container(
      padding: const EdgeInsets.only(top: 10.0),
      child: Text(
        'Quikly report crimes with this app. No signup required, just sign in with your Gmail Account.',
        style: TextStyle(fontSize: 17.0),
      ),
    );
  }

  Widget buildGoogleButton() {
    return Container(
      child: primaryButton(
        width: MediaQuery.of(context).size.width * 0.85,
        context: context,
        isLoading: isLoading,
        onPressed: googleSignIn,
        text: 'sign in with google',
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.only(left: 25.0, right: 25.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              buildIcon(),
              buildTitle(),
              buildDescription(),
              SizedBox(height: 50.0),
              buildGoogleButton(),
            ],
          ),
        ),
      ),
    );
  }
}
