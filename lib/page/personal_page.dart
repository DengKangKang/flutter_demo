import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_app/CommonRoute.dart';
import 'package:flutter_app/bloc/Bloc.dart';
import 'package:flutter_app/data/http/api_service.dart';
import 'package:flutter_app/data/http/rsp/ClientListRsp.dart';
import 'package:flutter_app/data/http/rsp/data/ClientListData.dart';
import 'package:flutter_app/data/persistence/Persistence.dart';
import 'package:flutter_app/main.dart';
import 'package:flutter_app/page/ClientDetailPage.dart';
import 'package:flutter_app/page/DailyPage.dart';
import 'package:flutter_app/page/login_page.dart';
import 'package:flutter_app/page/SearchPage.dart';
import 'package:flutter_app/page/reset_password.dart';
import 'package:rxdart/rxdart.dart';

class PersonalPage extends StatefulWidget {
  @override
  State createState() => PersonalPageState();
}

class PersonalPageState extends State<StatefulWidget> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Image.asset('assets/images/p_me.png'),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: <Widget>[
              item(
                '重置密码',
                'assets/images/ico_me_mm.png',
                () {
                  Navigator.push(
                    context,
                    CommonRoute(builder: (c) => ResetPasswordPage()),
                  );
                },
              ),
              Container(
                margin: EdgeInsets.only(top: 20),
                child: item(
                  '退出登录',
                  'assets/images/ico_me_tc.png',
                  () {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: Text("提示"),
                        content: Text("是否确认退出"),
                        actions: <Widget>[
                          FlatButton(
                            child: Text('取消'),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                          FlatButton(
                            child: Text('确定'),
                            onPressed: () {
                              _onLogout(context);
                            },
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        )
      ],
    );
  }

  Widget item(String label, String icon, VoidCallback onPress) {
    return RawMaterialButton(
      elevation: defaultElevation,
      fillColor: Colors.white,
      padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 18.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(4.0)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Row(
            children: <Widget>[
              Image.asset(icon),
              Container(
                margin: EdgeInsets.only(left: 5),
                child: Text(label),
              ),
            ],
          ),
          Icon(Icons.keyboard_arrow_right)
        ],
      ),
      onPressed: onPress,
    );
  }

  void _onLogout(BuildContext context) {
    Navigator.of(context).pop();
    Persistence().setToken("").then((value) {
      Navigator.pushReplacement(
          context,
          CommonRoute(
            builder: (BuildContext context) => LoginPage(),
          ));
    });
  }

}
