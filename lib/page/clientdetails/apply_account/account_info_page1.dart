import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app/bloc/Bloc.dart';
import 'package:flutter_app/bloc/ClientDetailBloc.dart';
import 'package:flutter_app/page/RadioListPage.dart';
import 'package:intl/intl.dart';

import 'client_debug_account_page.dart';

class AccountInfoPage1 extends StatefulWidget {
  AccountInfoPage1({
    Key key,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return AccountInfoPage1State();
  }
}

class AccountInfoPage1State extends State<AccountInfoPage1>
    with AutomaticKeepAliveClientMixin<AccountInfoPage1> {
  ClientDebugAccountBloc _bloc;

  @override
  void initState() {
    if (_bloc == null) _bloc = BlocProvider.of(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return ListView(
      physics: BouncingScrollPhysics(),
      children: <Widget>[
        buildItem('管理员姓名', 'xxxx'),
        buildItem('邮箱', ''),
        buildItem('初始密码', ''),
        buildItem('人员上限', ''),
        buildItem('有效日期', ''),
        Container(
          color: Colors.white,
          padding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                '备注',
                style: TextStyle(fontSize: 15),
              ),
              Container(
                padding: EdgeInsets.all(10),
                height: 83,
                width: double.infinity,
                margin: EdgeInsets.only(top: 10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(4)),
                  border: Border.all(color: Color(0xFFF1F1F1)),
                ),
                child: Text(
                  'xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx',
                  style: TextStyle(
                    color: Colors.grey,
                  ),
                ),
              )
            ],
          ),
        ),
        buildTitle('票量信息'),
        buildItem('查验发票量', ''),
        buildItem('有效期', '', showLine: false),
        buildTitle('插件信息'),
        _buildPlugInItem(
          '1其他插件',
          '有效日期： xxxx-xx-xx - xxxx-xx-xx',
        )
      ],
    );
  }


  Container _buildPlugInItem(String name, String timeLimit, {bool showLine = true}) {
    return Container(
      color: Colors.white,
      margin: EdgeInsets.only(bottom: 15),
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            name,
            style: TextStyle(fontSize: 15),
          ),
          Container(
            padding: EdgeInsets.only(top: 5),
            child: Text(
              timeLimit,
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ),
        ],
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}

