import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_app/CommonRoute.dart';
import 'package:flutter_app/bloc/Bloc.dart';
import 'package:flutter_app/data/http/ApiService.dart';
import 'package:flutter_app/data/http/rsp/DailiesRsp.dart';
import 'package:flutter_app/main.dart';
import 'package:flutter_app/page/client_detail_page.dart';
import 'package:rxdart/rxdart.dart';

import 'base/CommonPageState.dart';
import 'new_daily_page.dart';

class ClientListPage extends StatefulWidget {
  const ClientListPage({Key key, this.title}) : super(key: key);
  final title;

  @override
  State createState() => ClientListState();
}

class ClientListState extends CommonPageState<ClientListPage, ClientListBloc> {
  ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    if (bloc == null) {
      bloc = ClientListBloc();
      bloc.initData();
    }
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        bloc.loadMore();
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colorBg,
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        title: Text(widget.title),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () async {
              var needRefresh = await Navigator.push(
                  context, CommonRoute(builder: (c) => NewDailyPage()));
              if (needRefresh == true) {
                await bloc.initData();
              }
            },
          ),
          IconButton(
            icon: Icon(Icons.menu),
            onPressed: () async {
              var needRefresh = await Navigator.push(
                  context, CommonRoute(builder: (c) => NewDailyPage()));
              if (needRefresh == true) {
                await bloc.initData();
              }
            },
          ),
        ],
      ),
      body: RefreshIndicator(
          child: StreamBuilder<List<String>>(
            initialData: List<String>(),
            stream: bloc.dailies,
            builder:
                (BuildContext context, AsyncSnapshot<List<String>> snapshot) {
              return ListView.builder(
                physics: AlwaysScrollableScrollPhysics(),
                controller: _scrollController,
                itemCount: snapshot.data.length,
                itemBuilder: (context, i) {
                  return _item(snapshot.data, i);
                },
              );
            },
          ),
          onRefresh: () => bloc.initData()),
    );
  }

  Widget _item(List content, int index) {
    return Container(
      margin: EdgeInsets.only(
        top: 20,
        bottom: content.length - 1 == index ? 20 : 0,
        left: 20,
        right: 20,
      ),
      child: MaterialButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(5)),
        ),
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        color: Colors.white,
        elevation: defaultElevation / 2,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Text(
                      'id_124',
                      style: TextStyle(fontSize: 13, color: Colors.grey),
                    ),
                    Container(
                      padding: EdgeInsets.all(2),
                      margin: EdgeInsets.only(left: 10),
                      decoration: BoxDecoration(
                        color: Color(0x263389FF),
                        borderRadius: BorderRadius.all(
                          Radius.circular(10),
                        ),
                      ),
                      child: Text(
                        '会议渠道',
                        style: TextStyle(fontSize: 9, color: Color(0xFF3389FF)),
                      ),
                    )
                  ],
                ),
                Text(
                  '还剩X天',
                  style: TextStyle(fontSize: 13, color: Colors.red),
                ),
              ],
            ),
            Container(
              margin: EdgeInsets.symmetric(vertical: 10),
              child: Divider(
                height: 1,
              ),
            ),
            Text(
              'xxxxxxxxxxxxx',
              style: TextStyle(fontSize: 17),
            ),
            Container(
              margin: EdgeInsets.only(top: 10),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text(
                    'XX',
                    style: TextStyle(fontSize: 15, color: colorOrigin),
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 10),
                    child: Text(
                      'xx',
                      style: TextStyle(fontSize: 11),
                    ),
                  )
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 3),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    'XX',
                    style: TextStyle(fontSize: 13),
                  ),
                  Row(
                    children: <Widget>[
                      Image.asset("assets/images/ico_xq_zwkh.png"),
                      Container(
                        margin: EdgeInsets.only(left: 5),
                        child: Text(
                          '转为客户',
                          style: TextStyle(fontSize: 12),
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
        onPressed: () {
          Navigator.push(context, CommonRoute(builder: (c)=>ClientDetailPage(null)));
        },
      ),
    );
  }
}

class ClientListBloc extends CommonBloc {
  BehaviorSubject<List<String>> _dailies = BehaviorSubject();

  int page = 1;

  @override
  Future<void> initData() async {
    var rsp = await ApiService().getDailies(1, 10);
    if (rsp.code == ApiService.success) {
      _dailies.sink.add(['', '',]);
      page = 1;
    }
    return null;
  }

  void loadMore() async {
    var rsp = await ApiService().getDailies(page + 1, 10);
    if (rsp.code == ApiService.success) {
      var dailiesRsp = rsp as DailiesRsp;
      if (dailiesRsp?.data?.list != null &&
          dailiesRsp?.data?.list?.isNotEmpty == true) {
        page++;
        _dailies.value.addAll(['', '']);
        _dailies.sink.add(_dailies.value);
      }
    }
  }

  Stream<List<String>> get dailies => _dailies.stream;

  @override
  void onClosed() {
    _dailies.close();
    super.onClosed();
  }
}
