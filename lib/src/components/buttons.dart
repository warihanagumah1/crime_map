import 'package:flutter/material.dart';

primaryButton({
  double? width,
  required BuildContext context,
  required VoidCallback onPressed,
  required String text,
  bool? isLoading,
}) {
  isLoading = isLoading == null ? false : isLoading;
  return Container(
    height: 45.0,
    width: width == null ? MediaQuery.of(context).size.width * 0.50 : width,
    child: RawMaterialButton(
      elevation: isLoading ? 1.0 : 0.0,
      onPressed: onPressed,
      fillColor: isLoading  ? Colors.green.shade200  : Colors.green,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(6.0),
      ),
      child: Center(
        child: Text(
          text.toUpperCase(),
          style: TextStyle(
            fontSize: 14.0,
            color: Colors.white,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
    ),
  );
}