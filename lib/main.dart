import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_app/CommonRoute.dart';
import 'package:flutter_app/data/http/ApiService.dart';
import 'package:flutter_app/data/http/rsp/SourceTypesRsp.dart';
import 'package:flutter_app/data/http/rsp/data/RadioBean.dart';
import 'package:flutter_app/data/persistence/Persistence.dart';
import 'package:flutter_app/page/HomePage.dart';
import 'package:flutter_app/page/LoginPage.dart';
import 'package:flutter_app/page/RadioListPage.dart';

void main() {
  runApp(new MaterialApp(
    theme: ThemeData(
      hintColor: Colors.grey,
      primaryColor: Color(0xFFf6f6f9),
      accentColor: Colors.blue,
      backgroundColor: Colors.white,
    ),
    home: new SplashScreen(),
  ));
}

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => new _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  startTime(int milliseconds) async {
    var _duration = new Duration(milliseconds: milliseconds);
    return new Timer(_duration, navigationPage);
  }

  void navigationPage() async {
    String token = await Persistence().getToken();
    if (token != null && token.isNotEmpty) {
      Navigator.pushReplacement(
          context,
          new CommonRoute(
            builder: (BuildContext context) => new HomePage(),
          ));
    } else {
      Navigator.pushReplacement(
          context,
          new CommonRoute(
            builder: (BuildContext context) => new LoginPage(),
          ));
    }
  }

  @override
  void initState() {
    super.initState();
    var time = new DateTime.now().millisecond;
    new ApiService().sourceTypes().then((rsp) {
      if (rsp.code == ApiService.success) {
        var sourceTypesRsp = rsp as SourceTypesRsp;
        sourceTypes.add(RadioBean(0, "请选择来源类型"));
        sourceTypes.addAll(sourceTypesRsp.data);
        var duration = 2000 - time;
        startTime(duration > 0 ? duration : 0);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: new Center(
        child: new Image.asset(
          'assets/images/bg_splash.png',
          width: double.infinity,
          height: double.infinity,
          fit: BoxFit.fill,
        ),
      ),
    );
  }
}
