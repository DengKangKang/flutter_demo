import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_app/data/http/api_service.dart';
import 'package:flutter_app/data/persistence/Persistence.dart';
import 'package:flutter_app/page/RadioListPage.dart';
import 'package:flutter_app/page/login_page.dart';
import 'package:flutter_app/page/main_page.dart';

const colorOrigin = Color(0XFFEE7B1C);
const colorCyan = Color(0XFF37C6C5);
const colorBlue = Color(0XFF3389FF);
const colorBlueLight = Color(0X333389FF);
const colorGrey = Color(0XFFF5F5F5);
const colorOriginLight = Color(0X33EE7B1C);

const colorBg = Color(0XFFF7F8FC);
const colorDivider = Color(0XFFE6E6E6);

const defaultElevation = 8.0;

void main() {
  runApp(
    MaterialApp(
      theme: ThemeData(
          primaryColor: Colors.white,
          accentColor: colorOrigin,
          scaffoldBackgroundColor: Colors.white,
          backgroundColor: Colors.white,
          hintColor: Colors.grey,
          dividerColor: colorDivider),
      home: SplashScreen(),
      routes: <String, WidgetBuilder>{
        '/main': (BuildContext context) => MainPage(),
        '/login': (BuildContext context) => LoginPage(),
      },
    ),
  );
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
    await Navigator.pushReplacementNamed(
      context,
      token != null && token.isNotEmpty ? '/main' : '/login',
    );
  }

  @override
  void initState() {
    super.initState();
    final time = DateTime.now().millisecond;
    ApiService().sourceTypes().then((rsp) {
      print(rsp);
      if (rsp.code == ApiService.success) {
        var sourceTypesRsp = rsp;
        sourceTypes.addAll(sourceTypesRsp.data);
      }
      var duration = 2000 - time;
      _goMainDelay(duration > 0 ? duration : 0);
    }, onError: (e) {
      var duration = 2000 - time;
      _goMainDelay(duration > 0 ? duration : 0);
    });
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
