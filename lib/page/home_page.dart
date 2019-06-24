import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_app/CommonRoute.dart';
import 'package:flutter_app/bloc/Bloc.dart';
import 'package:flutter_app/data/http/ApiService.dart';
import 'package:flutter_app/data/http/rsp/ClientListRsp.dart';
import 'package:flutter_app/data/http/rsp/data/ClientListData.dart';
import 'package:flutter_app/data/persistence/Persistence.dart';
import 'package:flutter_app/page/ClientDetailPage.dart';
import 'package:flutter_app/page/DailyPage.dart';
import 'package:flutter_app/page/LoginPage.dart';
import 'package:flutter_app/page/SearchPage.dart';
import 'package:flutter_app/page/client_list_page.dart';
import 'package:rxdart/rxdart.dart';

import '../main.dart';

class HomePage extends StatefulWidget {
  @override
  State createState() => HomePageState();
}

class HomePageState extends State<StatefulWidget> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Image.asset('assets/images/p_sy.png'),
        Container(
          margin: EdgeInsets.only(top: 182),
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  _item('私海线索', '20', '我的线索', true),
                  _item('公海线索', '20', '今日新增', true),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  _item('私海客户', '20', '我的客户', false),
                  _item('公海客户', '20', '今日新增', false),
                ],
              ),
            ],
          ),
        )
      ],
    );
  }

  Widget _item(String title, String count, String description, bool isTrack) =>
      Container(
          margin: EdgeInsets.only(left: 20, right: 20, bottom: 45),
          child: RawMaterialButton(
            fillColor: Colors.white,
            elevation: 8,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadiusDirectional.all(Radius.circular(20))),
            child: Container(
              padding: EdgeInsets.all(15),
              width: 110,
              height: 170,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      isTrack
                          ? Image.asset('assets/images/ico_sy_xs.png')
                          : Image.asset('assets/images/ico_sy_kh.png'),
                      Container(
                        margin: EdgeInsets.only(top: 5),
                        child: Text(
                          title,
                          style: TextStyle(
                            fontSize: 17,
                            color: isTrack ? colorCyan : colorOrigin,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        count + '条',
                        style: TextStyle(
                          fontSize: 17,
                          color: isTrack ? colorCyan : colorOrigin,
                        ),
                      ),
                      Text(
                        description,
                        style:
                            TextStyle(fontSize: 10, color: Color(0XFFA2A8B4)),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          color: isTrack ? colorCyan : colorOrigin,
                          borderRadius: BorderRadius.all(Radius.circular(3)),
                        ),
                        margin: EdgeInsets.only(top: 15),
                        height: 3,
                        width: 20,
                      )
                    ],
                  ),
                ],
              ),
            ),
            onPressed: () {
              Navigator.push(
                context,
                CommonRoute(
                  builder: (c) => ClientListPage(title: title),
                ),
              );
            },
          ));
}
