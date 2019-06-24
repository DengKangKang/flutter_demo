import 'package:flutter/material.dart';
import 'package:flutter_app/bloc/Bloc.dart';
import 'package:flutter_app/main.dart';

import 'client_debug_account_page.dart';

class AccountInfoPage3 extends StatefulWidget {
  AccountInfoPage3({
    Key key,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return AccountInfoPage3State();
  }
}

class AccountInfoPage3State extends State<AccountInfoPage3>
    with AutomaticKeepAliveClientMixin<AccountInfoPage3> {
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
        buildTitle('部门'),
        _buildDepartmentItem('xx公司', 'xxxxxxxx'),
        _buildDepartmentItem('xx公司', 'xxxxxxxx'),
        _buildDepartmentItem('xx公司', 'xxxxxxxx', showLine: false),
        buildTitle('用户'),
        _buildUserItem(
          'id:23131',
          'xxxx-xx-xx',
          'xxxx',
          true,
          true,
        ),
        _buildUserItem(
          'id:23131',
          'xxxx-xx-xx',
          'xxxx',
          false,
          false,
        ),
        _buildUserItem(
          'id:23131',
          'xxxx-xx-xx',
          'xxxx',
          true,
          false,
        ),
      ],
    );
  }

  Container _buildDepartmentItem(String info1, String info2,
      {bool showLine = true}) {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.symmetric(
        horizontal: 20,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(top: 10),
            child: Text(
              info1,
              style: TextStyle(fontSize: 15),
            ),
          ),
          Container(
            padding: EdgeInsets.only(top: 5, bottom: 10),
            child: Text(
              info2,
              style: TextStyle(fontSize: 15),
            ),
          ),
          Opacity(
            child: Divider(
              height: 1,
            ),
            opacity: showLine ? 1 : 0,
          ),
        ],
      ),
    );
  }

  Container _buildUserItem(
    String id,
    String time,
    String name,
    bool isOnTheJob,
    bool isAdmin, {
    bool showLine = true,
  }) {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.symmetric(
        horizontal: 20,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(top: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Text(
                      id,
                      style: TextStyle(fontSize: 12),
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 5),
                      child: Text(
                        time,
                        style: TextStyle(fontSize: 12),
                      ),
                    ),
                  ],
                ),
                Text(
                  isOnTheJob ? '在职' : '离职',
                  style: TextStyle(
                    fontSize: 14,
                    color: isOnTheJob ? colorCyan : Colors.red,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.only(top: 5, bottom: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  name,
                  style: TextStyle(fontSize: 17),
                ),
                Text(
                  isAdmin ? '管理员' : '非管理员',
                  style: TextStyle(
                    fontSize: 14,
                  ),
                )
              ],
            ),
          ),
          Opacity(
            child: Divider(
              height: 1,
            ),
            opacity: showLine ? 1 : 0,
          ),
        ],
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
