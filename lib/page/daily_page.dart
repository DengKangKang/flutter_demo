import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_app/CommonRoute.dart';
import 'package:flutter_app/bloc/Bloc.dart';
import 'package:flutter_app/data/http/ApiService.dart';
import 'package:flutter_app/data/http/rsp/DailiesRsp.dart';
import 'package:flutter_app/main.dart';
import 'package:rxdart/rxdart.dart';

import 'base/CommonPageState.dart';
import 'new_daily_page.dart';

class DailyPage extends StatefulWidget {
  @override
  State createState() => DailyPageState();
}

class DailyPageState extends CommonPageState<DailyPage, DailyBloc> {
  ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    if (bloc == null) {
      bloc = DailyBloc();
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
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        title: Text("我的日报"),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.add_circle_outline),
            onPressed: () async {
              var needRefresh = await Navigator.push(
                  context, CommonRoute(builder: (c) => NewDailyPage()));
              if (needRefresh == true) {
                await bloc.initData();
              }
            },
          )
        ],
      ),
      body: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Icon(Icons.keyboard_arrow_left),
                  Text('前一天')
                ],
              ),
              Container(
                padding: EdgeInsets.symmetric(
                  vertical: 6,
                  horizontal: 10,
                ),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
                child: Row(
                  children: <Widget>[
                    Text('xxxx-xx-xx'),
                    Container(
                      margin: EdgeInsets.only(left: 14),
                      child: Image.asset('assets/images/ico_rb_rq.png'),
                    ),
                  ],
                ),
              ),
              Row(
                children: <Widget>[
                  Text('后一天'),
                  Icon(Icons.keyboard_arrow_right),
                ],
              )
            ],
          ),
          Flexible(
            child: RefreshIndicator(
                child: StreamBuilder<List<Daily>>(
                  initialData: List<Daily>(),
                  stream: bloc.dailies,
                  builder: (BuildContext context,
                      AsyncSnapshot<List<Daily>> snapshot) {
                    return ListView.builder(
                      physics: AlwaysScrollableScrollPhysics(),
                      controller: _scrollController,
                      itemCount: snapshot.data.length,
                      itemBuilder: (context, i) {
                        return _buildItem(i, snapshot.data);
                      },
                    );
                  },
                ),
                onRefresh: () => bloc.initData()),
          )
        ],
      ),
    );
  }

  Widget _buildItem(int i, List<Daily> dailies) {
    var daily = dailies[i];
    return Card(
      margin: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 20,
        bottom: i == dailies.length - 1 ? 20 : 0,
      ),
      elevation: defaultElevation / 2,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            margin: EdgeInsets.symmetric(
              vertical: 10,
              horizontal: 20,
            ),
            child: Text(
              daily.daily_time,
              style: TextStyle(color: colorOrigin, fontSize: 14),
            ),
          ),
          Divider(
            height: 2,
            color: Colors.grey,
          ),
          Container(
            margin: EdgeInsets.symmetric(
              horizontal: 20,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  margin: EdgeInsets.symmetric(vertical: 5),
                  child: Text(
                    "今日工作内容",
                    style: TextStyle(color: colorCyan, fontSize: 10),
                  ),
                ),
                Text(
                  daily.today_content,
                  style: TextStyle(fontSize: 12),
                ),
                Container(
                  margin: EdgeInsets.only(top: 10),
                  child: Divider(
                    height: 2,
                  ),
                ),
                Container(
                  margin: EdgeInsets.symmetric(vertical: 5),
                  child: Text(
                    "今日拜访/跟进用户",
                    style: TextStyle(color: colorCyan, fontSize: 10),
                  ),
                ),
                Text(
                  daily.today_customer_visit,
                  style: TextStyle(fontSize: 12),
                ),
                Container(
                  margin: EdgeInsets.only(top: 10),
                  child: Divider(
                    height: 2,
                  ),
                ),
                Container(
                  margin: EdgeInsets.symmetric(vertical: 5),
                  child: Text(
                    "今日所遇到的问题及解决方案",
                    style: TextStyle(color: colorCyan, fontSize: 10),
                  ),
                ),
                Text(
                  daily.today_solution,
                  style: TextStyle(fontSize: 12),
                ),
                Container(
                  margin: EdgeInsets.only(top: 10),
                  child: Divider(
                    height: 2,
                  ),
                ),
                Container(
                  margin: EdgeInsets.symmetric(vertical: 5),
                  child: Text(
                    "明日工作计划",
                    style: TextStyle(color: colorCyan, fontSize: 10),
                  ),
                ),
                Text(
                  daily.next_plan,
                  style: TextStyle(fontSize: 12),
                ),
                Container(
                  margin: EdgeInsets.only(top: 10),
                  child: Divider(
                    height: 2,
                  ),
                ),
                Container(
                  margin: EdgeInsets.symmetric(vertical: 5),
                  child: Text(
                    "明日拜访/跟进用户",
                    style: TextStyle(color: colorCyan, fontSize: 10),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(bottom: 10),
                  child: Text(
                    daily.next_customer_visit,
                    style: TextStyle(fontSize: 12),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class DailyBloc extends CommonBloc {
  BehaviorSubject<List<Daily>> _dailies = BehaviorSubject();

  int page = 1;

  @override
  Future<void> initData() async {
    var rsp = await ApiService().getDailies(1, 10);
    if (rsp.code == ApiService.success) {
      var dailiesRsp = rsp as DailiesRsp;
      _dailies.sink.add(dailiesRsp.data.list);
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
        _dailies.value.addAll(dailiesRsp?.data?.list);
        _dailies.sink.add(_dailies.value);
      }
    }
  }

  Stream<List<Daily>> get dailies => _dailies.stream;

  @override
  void onClosed() {
    _dailies.close();
    super.onClosed();
  }
}
