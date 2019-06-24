import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app/bloc/Bloc.dart';
import 'package:flutter_app/bloc/ClientDetailBloc.dart';
import 'package:flutter_app/page/RadioListPage.dart';
import 'package:intl/intl.dart';

import 'client_debug_account_page.dart';

class AccountInfoPage4 extends StatefulWidget {
  AccountInfoPage4({
    Key key,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return AccountInfoPage4State();
  }
}

class AccountInfoPage4State extends State<AccountInfoPage4>
    with AutomaticKeepAliveClientMixin<AccountInfoPage4> {
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
        buildItem('发票余量', '1000',showLine: false),
        buildTitle('每日查验量'),
        buildItem('xxxx-xx-xx', '1000张',),
        buildItem('xxxx-xx-xx', '1000张',),
        buildItem('xxxx-xx-xx', '1000张',),
        buildItem('xxxx-xx-xx', '1000张',showLine: false),

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
