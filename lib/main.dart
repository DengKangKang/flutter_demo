import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_app/CommonRoute.dart';
import 'package:flutter_app/data/http/ApiService.dart';
import 'package:flutter_app/data/http/rsp/data/RadioBean.dart';
import 'package:flutter_app/data/persistence/Persistence.dart';
import 'package:flutter_app/page/LoginPage.dart';
import 'package:flutter_app/page/RadioListPage.dart';
import 'package:flutter_app/page/main_page.dart';

const colorOrigin = Color(0XFFEE7B1C);
const colorCyan = Color(0XFF37C6C5);

const colorBg = Color(0XFFF7F8FC);
const colorDivider = Color(0XFFE6E6E6);

const defaultElevation = 8.0;

void main() {
  runApp(MaterialApp(
    theme: ThemeData(
      primaryColor: Colors.white,
      scaffoldBackgroundColor: Colors.white,
      backgroundColor: Colors.white,
      hintColor: Colors.grey,
      dividerColor: colorDivider
    ),
    home: SplashScreen(),
  ));
}

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  Timer _goMainDelay(int milliseconds) {
    var _duration = Duration(milliseconds: milliseconds);
    return Timer(_duration, navigationPage);
  }

  void navigationPage() async {
    String token = await Persistence().getToken();
    await Navigator.pushReplacement(
      context,
      CommonRoute(
        builder: (BuildContext context) =>
            token != null && token.isNotEmpty ? MainPage() : LoginPage(),
      ),
    );
  }

  @override
  void initState() async {
    super.initState();
    final time = DateTime.now().millisecond;
    var rsp = await ApiService().sourceTypes();
    if (rsp.code == ApiService.success) {
      var sourceTypesRsp = rsp;
      sourceTypes.add(RadioBean(0, "请选择来源类型"));
      sourceTypes.addAll(sourceTypesRsp.data);
      var duration = 2000 - time;
      _goMainDelay(duration > 0 ? duration : 0);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Image.asset(
          'assets/images/bg_splash.png',
          width: double.infinity,
          height: double.infinity,
          fit: BoxFit.fill,
        ),
      ),
    );
  }
}
