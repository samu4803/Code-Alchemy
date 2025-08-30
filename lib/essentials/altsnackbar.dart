import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';

void altSnackBar({
  required BuildContext context,
  required ContentType contentType,
  String message = "",
}) {
  String title = "";
  if (contentType == ContentType.failure) {
    title = "Error";
    message = "No profile photo is added";
  } else if (contentType == ContentType.warning) {
    title = "Warning";
  } else if (contentType == ContentType.success) {
    title = "Success";
  } else {
    title = "whoops";
  }
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(
      SnackBar(
        elevation: 0,
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.transparent,
        content: AwesomeSnackbarContent(
          title: title,
          message: message,
          contentType: contentType,
        ),
      ),
    );
}
