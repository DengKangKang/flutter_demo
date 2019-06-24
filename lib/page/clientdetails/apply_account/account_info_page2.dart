import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app/bloc/Bloc.dart';
import 'package:flutter_app/bloc/ClientDetailBloc.dart';
import 'package:flutter_app/page/RadioListPage.dart';
import 'package:intl/intl.dart';

import 'client_debug_account_page.dart';

class AccountInfoPage2 extends StatefulWidget {
  AccountInfoPage2({
    Key key,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return AccountInfoPage2State();
  }
}

class AccountInfoPage2State extends State<AccountInfoPage2>
    with AutomaticKeepAliveClientMixin<AccountInfoPage2> {
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
        Container(
          color: Colors.white,
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                '创建人：xx',
                style: TextStyle(fontSize: 15),
              ),
              Container(
                padding: EdgeInsets.only(top: 5),
                child: Text(
                  '申请时间：xxxx-xx-xx xx:xx:xx',
                  style: TextStyle(fontSize: 15),
                ),
              ),
            ],
          ),
        ),
        buildTitle('基本信息'),
        buildItem('企业名称', 'xxxx'),
        buildItem('注册地址', ''),
        buildItem('代理商', ''),
        buildItem('开户行', ''),
        buildItem('账户', ''),
        buildItem('手机号', '',showLine: false),
        buildTitle('Key&Secret'),
        _buildKeySecretItem(
          'xxx key',
          '32131231231231',
        ),
        buildTitle('其他信息'),
        buildItem('查验发票量', ''),
        buildItem('有效期', '',showLine: false),
      ],
    );
  }

  Container _buildKeySecretItem(String name, String timeLimit, {bool showLine = true}) {
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
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  timeLimit,
                  style: TextStyle(fontSize: 15, color: Colors.grey),
                ),
                Image.asset('assets/images/ico_xq_fz.png')
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
