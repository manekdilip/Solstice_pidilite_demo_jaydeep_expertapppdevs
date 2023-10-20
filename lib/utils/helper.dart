import 'package:flutter/material.dart';
import 'package:google_mlkit_translation/google_mlkit_translation.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:solstice_assigment/utils/strings.dart';

const TranslateLanguage sourceLanguage = TranslateLanguage.english;
const TranslateLanguage targetLanguage = TranslateLanguage.hindi;

final translator = OnDeviceTranslator(
  sourceLanguage: sourceLanguage,
  targetLanguage: targetLanguage,
);

// to show snackBar
void showSnackBar(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message),
    ),
  );
}

//it render title
Widget dialogTitleView() {
  return const Text(
    speak,
    style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold),
  );
}

//it renders cancel button
Widget dialogCancelButton(Function onPressed) {
  return Expanded(
    child: ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xffB58392),
      ),
      onPressed: () {
        onPressed();
      },
      child: const Text(cancel,style: TextStyle(color: Colors.white),),
    ),
  );
}

// it render model download dialog
void downloadingDialog(BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setStateData) {
          return const AlertDialog(
            content: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    downloadingModel,
                    textAlign: TextAlign.center,
                  )
                ],
              ),
            ),
          );
        },
      );
    },
  );
}

// it shows setting dialog
Future<void> showSettingsDialog(BuildContext context) async {
  return showDialog<void>(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text(permissionRequired),
        content: const SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              Text(thisPermissionIsRequired),
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: const Text(openSettings),
            onPressed: () async {
              await openAppSettings();
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}