import 'package:flutter/material.dart';

void onLoading(BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) => new Container(
      child: new Stack(
        children: <Widget>[
          new Center(
            child: new Container(
              width: 66.0,
              height: 66.0,
              child: new Card(
                elevation: 16.0,
                child: new Padding(
                  padding: EdgeInsets.all(12.0),
                  child: new CircularProgressIndicator(),
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