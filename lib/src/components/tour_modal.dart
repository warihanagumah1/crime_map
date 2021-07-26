import 'package:crime_map/src/components/buttons.dart';
import 'package:flutter/material.dart';

Future<void> showProductTourModal({required BuildContext context}) async {
  return await showModalBottomSheet(
    context: context,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(10.0),
        topRight: Radius.circular(
          10.0,
        ),
      ),
    ),
    builder: (BuildContext context) {
      return Container(
        height: 280.0,
        child: Container(
          child: Padding(
            padding: EdgeInsets.only(top: 10.0, left: 40.0, right: 40.0),
            child: Column(
              children: <Widget>[_buildModalHeaderBar(), SizedBox(height: 15.0), _buildModalContent(context)],
            ),
          ),
        ),
      );
    },
  );
}

Container _buildModalHeaderBar() {
  return Container(
    height: 5.0,
    width: 50.0,
    padding: EdgeInsets.only(bottom: 30.0),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(30.0),
      color: Colors.grey.shade300,
    ),
  );
}

Container _buildModalContent(BuildContext context) {
  return Container(
    child: Column(
      children: [
        Text(
          'How to use',
          style: TextStyle(fontSize: 28.0, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 10.0),
        Text(
          '''
Report crimes by tapping on a crime location or by tapping on the report crime button to report a crime\n\nNOTE: When you choose to report a crime by tapping on the report crime button, its selects your current locations latitude and longitude.''',
          style: TextStyle(
            fontSize: 15.0,
          ),
        ),
        SizedBox(height: 20.0),
        primaryButton(
          context: context,
          onPressed: () => Navigator.pop(context),
          text: 'OK, GOT IT',
        )
      ],
    ),
  );
}
