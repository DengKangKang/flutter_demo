import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/bloc/Bloc.dart';
import 'package:flutter_app/page/base/CommonPageState.dart';

import '../../../main.dart';
import 'account_info_page1.dart';
import 'account_info_page2.dart';
import 'account_info_page3.dart';
import 'account_info_page4.dart';

class ClientDebugAccountPage extends StatefulWidget {
  ClientDebugAccountPage();

  @override
  State<StatefulWidget> createState() {
    return ClientDebugAccountPageState();
  }
}

class ClientDebugAccountPageState
    extends CommonPageState<ClientDebugAccountPage, ClientDebugAccountBloc> {
  final List<Tab> _tabs = <Tab>[
    Tab(text: '申请账号'),
    Tab(text: '客户详情'),
    Tab(text: '部门与用户'),
    Tab(text: '发票用量'),
  ];

  List<Widget> _page;

  @override
  void initState() {
    if (bloc == null) {
      bloc = ClientDebugAccountBloc();
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (_page == null) {
      _page = List<Widget>();
      _page.add(AccountInfoPage1());
      _page.add(AccountInfoPage2());
      _page.add(AccountInfoPage3());
      _page.add(AccountInfoPage4());
    }

    return BlocProvider<ClientDebugAccountBloc>(
      bloc: bloc,
      child: DefaultTabController(
        length: _tabs.length,
        child: Scaffold(
          key: scaffoldKey,
          backgroundColor: colorBg,
          appBar: AppBar(
            elevation: 0,
            centerTitle: true,
            title: Text('测试账号'),
          ),
          body: Column(
            children: <Widget>[
              SizedBox(
                height: 67,
                child: TabBar(
                  unselectedLabelColor: Colors.grey,
                  indicatorColor: colorOrigin,
                  indicatorPadding:
                      EdgeInsets.only(right: 15, left: 15, bottom: 20),
                  tabs: _tabs,
                  isScrollable: true,
                ),
              ),
              Flexible(
                child: TabBarView(
                  children: <Widget>[..._page],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class ClientDebugAccountBloc extends CommonBloc {}

Widget buildTitle(label) {
  return Container(
    padding: EdgeInsets.only(right: 20, left: 20, top: 20, bottom: 7),
    child: Text(
      label,
      style: TextStyle(fontSize: 12, color: Colors.grey),
    ),
  );
}

Widget buildItem(String title, String content, {bool showLine = true}) {
  return Container(
    color: Colors.white,
    padding: EdgeInsets.symmetric(horizontal: 20),
    child: Column(
      children: <Widget>[
        Container(
          padding: EdgeInsets.symmetric(vertical: 15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: TextStyle(fontSize: 15),
              ),
              Flexible(
                child: Text(
                  content,
                  style: TextStyle(fontSize: 15, color: Colors.grey),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              ),
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
