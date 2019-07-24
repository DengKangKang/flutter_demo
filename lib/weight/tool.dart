import 'package:flutter/material.dart';

void onLoading(BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) => Container(
          child: Stack(
            children: <Widget>[
              Center(
                child: Container(
                  width: 66.0,
                  height: 66.0,
                  child: Card(
                    elevation: 16.0,
                    child: Padding(
                      padding: EdgeInsets.all(12.0),
                      child: CircularProgressIndicator(),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
  );
}

void loadingFinish(BuildContext context) {
  Navigator.of(context, rootNavigator: true).pop();
}
