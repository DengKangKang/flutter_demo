import 'package:flutter/material.dart';
import 'package:flutter_app/bloc/Bloc.dart';
import 'package:flutter_app/data/http/rsp/department_info.dart';
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
        StreamBuilder<List<Department>>(
          initialData: [],
          stream: _bloc.department,
          builder: (c, s) => Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  ...s.data.map((e) => _buildDepartmentItem(e))
                ],
              ),
        ),
        buildTitle('用户'),
        StreamBuilder<List<User>>(
          initialData: [],
          stream: _bloc.user,
          builder: (c, s) => Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  ...s.data.map((e) => _buildUserItem(
                        e.user_id.toString(),
                        e.create_time,
                        e.username,
                        e.is_link == 1,
                        e.is_admin==1,
                      ))
                ],
              ),
        ),
      ],
    );
  }

  Container _buildDepartmentItem(Department d, {bool showLine = true}) {
    var infos = d.name.split('  ');
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
              infos[0],
              style: TextStyle(fontSize: 15),
            ),
          ),
          Container(
            padding: EdgeInsets.only(top: 5, bottom: 10),
            child: Text(
              infos[1],
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


  int page = 1;


  @override
  bool get wantKeepAlive => true;

}
