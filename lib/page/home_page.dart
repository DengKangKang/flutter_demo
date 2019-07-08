import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_app/CommonRoute.dart';
import 'package:flutter_app/bloc/Bloc.dart';
import 'package:flutter_app/data/http/api_service.dart';
import 'package:flutter_app/page/base/CommonPageState.dart';
import 'package:flutter_app/page/client_list_page.dart';
import 'package:rxdart/rxdart.dart';

import '../main.dart';

class HomePage extends StatefulWidget {
  @override
  State createState() => HomePageState();
}

class HomePageState extends CommonPageState<HomePage, HomeBloc>
    with AutomaticKeepAliveClientMixin<HomePage> {
  @override
  void initState() {
    if (bloc == null) {
      bloc = HomeBloc();
      bloc.initData();
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Positioned.fill(
          child: Image.asset(
            'assets/images/p_sy.png',
            fit: BoxFit.fitWidth,
            alignment: Alignment.topCenter,
          ),
        ),
        Container(
          margin: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.25),
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  StreamBuilder(
                    initialData: '0',
                    stream: bloc.privateTrace.stream,
                    builder: (c, s) => _item(
                      '私海线索',
                      s.data,
                      '我的线索',
                      typeTrace | statePrivate,
                    ),
                  ),
                  StreamBuilder(
                    initialData: '0',
                    stream: bloc.publicTrace.stream,
                    builder: (c, s) => _item(
                      '公海线索',
                      s.data,
                      '今日新增',
                      typeTrace | statePublic,
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  StreamBuilder(
                    initialData: '0',
                    stream: bloc.privateClient.stream,
                    builder: (c, s) => _item(
                      '私海客户',
                      s.data,
                      '我的客户',
                      typeClient | statePrivate,
                    ),
                  ),
                  StreamBuilder(
                    initialData: '0',
                    stream: bloc.publicClient.stream,
                    builder: (c, s) => _item(
                      '公海客户',
                      s.data,
                      '今日新增',
                      typeClient | statePublic,
                    ),
                  ),
                ],
              ),
            ],
          ),
        )
      ],
    );
  }

  Widget _item(
      String title, String count, String description, int businessType) {
    var type = businessType & 0xF;
    return Container(
        margin: EdgeInsets.only(
          left: 20,
          right: 20,
          bottom:
              type == typeTrace ? MediaQuery.of(context).size.height * 0.05 : 0,
        ),
        child: RawMaterialButton(
          fillColor: Colors.white,
          elevation: 8,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadiusDirectional.all(Radius.circular(20))),
          child: Container(
            padding: EdgeInsets.only(top: 15,left: 15,right: 15,bottom: 10),
            width: MediaQuery.of(context).size.width * 0.3,
            height: MediaQuery.of(context).size.height * 0.275,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    type == typeTrace
                        ? Image.asset('assets/images/ico_sy_xs.png')
                        : Image.asset('assets/images/ico_sy_kh.png'),
                    Container(
                      margin: EdgeInsets.only(top: 5),
                      child: Text(
                        title,
                        style: TextStyle(
                          fontSize: 17,
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
                        color: type == typeTrace ? colorCyan : colorOrigin,
                      ),
                    ),
                    Text(
                      description,
                      style: TextStyle(fontSize: 10, color: Color(0XFFA2A8B4)),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: type == typeTrace ? colorCyan : colorOrigin,
                        borderRadius: BorderRadius.all(Radius.circular(3)),
                      ),
                      margin: EdgeInsets.only(top: 10),
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
                builder: (c) => ClientListPage(
                  title: title,
                  businessType: businessType,
                ),
              ),
            );
          },
        ));
  }

  @override
  bool get wantKeepAlive => true;
}

class HomeBloc extends CommonBloc {
  var privateTrace = BehaviorSubject<String>();
  var publicTrace = BehaviorSubject<String>();
  var privateClient = BehaviorSubject<String>();
  var publicClient = BehaviorSubject<String>();

  @override
  void initData() async {
    var rsp = await ApiService().home();
    if (rsp.code == ApiService.success) {
      privateTrace.add(rsp.data.list?.first?.p_clue?.toString() ?? '0');
      publicTrace.add(rsp.data.list?.first?.c_clue?.toString() ?? '0');
      privateClient.add(rsp.data.list?.first?.p_customer?.toString() ?? '0');
      publicClient.add(rsp.data.list?.first?.c_customer?.toString() ?? '0');
    }
  }
}
