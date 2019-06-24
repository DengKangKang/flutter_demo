import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_app/CommonRoute.dart';
import 'package:flutter_app/bloc/Bloc.dart';
import 'package:flutter_app/data/http/ApiService.dart';
import 'package:flutter_app/data/http/rsp/DailiesRsp.dart';
import 'package:flutter_app/main.dart';
import 'package:intl/intl.dart';
import 'package:rxdart/rxdart.dart';

import 'NewDailyPage.dart';
import 'base/CommonPageState.dart';

class NewDailyPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return NewDailyPageState();
  }
}

class NewDailyPageState extends CommonPageState<NewDailyPage, NewDailyBloc> {
  @override
  void initState() {
    if (bloc == null) {
      bloc = NewDailyBloc();
      bloc.initData();
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: Scaffold(
        backgroundColor: colorBg,
        key: scaffoldKey,
        appBar: AppBar(
          elevation: 0,
          title: Text("新增日报"),
        ),
        body: Container(
          child: Theme(
            data: Theme.of(context).copyWith(
              primaryColor: Colors.blue,
            ),
            child: ListView(
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(top: 10),
                  child: Material(
                    color: Colors.white,
                    child: InkWell(
                      onTap: () async {
                        var date = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(DateTime.now().year - 1),
                          lastDate: DateTime.now(),
                        );
                        if (date != null) {
                          bloc.date = DateFormat('yyyy-MM-dd').format(date);
                        }
                      },
                      child: StreamBuilder<String>(
                        initialData: "",
                        stream: bloc.date,
                        builder: (
                          BuildContext context,
                          AsyncSnapshot<String> snapshot,
                        ) {
                          return Container(
                            padding: EdgeInsets.symmetric(
                              vertical: 15,
                              horizontal: 20,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text(
                                  '日期',
                                  style: TextStyle(fontSize: 15),
                                ),
                                Row(
                                  children: <Widget>[
                                    Text(
                                      snapshot.data,
                                      style: TextStyle(fontSize: 15),
                                    ),
                                    Icon(Icons.keyboard_arrow_right)
                                  ],
                                )
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  color: Colors.white,
                  margin: EdgeInsets.only(top: 10),
                  child: Column(
                    children: <Widget>[
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            margin: EdgeInsets.only(top: 10),
                            child: Text(
                              '今日工作内容',
                              style: TextStyle(
                                color: colorCyan,
                              ),
                            ),
                          ),
                          TextField(
                            decoration: InputDecoration(
                              fillColor: Colors.red,
                              border: InputBorder.none,
                              hintText: "请输入今日工作内容",
                            ),
                            keyboardType: TextInputType.multiline,
                            maxLengthEnforced: true,
                            maxLines: null,
                            onChanged: (s) {
                              bloc.todayWorkContent = s;
                            },
                          ),
                          Divider(
                            height: 1,
                          )
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            margin: EdgeInsets.only(top: 10),
                            child: Text(
                              '今日拜访/跟进客户',
                              style: TextStyle(
                                color: colorCyan,
                              ),
                            ),
                          ),
                          TextField(
                            decoration: InputDecoration(
                                border: InputBorder.none, hintText: '请输入相关内容'),
                            keyboardType: TextInputType.multiline,
                            maxLengthEnforced: true,
                            maxLines: null,
                            onChanged: (s) {
                              bloc.todayVisitClient = s;
                            },
                          ),
                          Divider(
                            height: 2,
                          )
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            margin: EdgeInsets.only(top: 10),
                            child: Text(
                              '今日所遇到的问题及解决方案',
                              style: TextStyle(
                                color: colorCyan,
                              ),
                            ),
                          ),
                          TextField(
                            decoration: InputDecoration(
                                border: InputBorder.none, hintText: '请输入相关内容'),
                            keyboardType: TextInputType.multiline,
                            maxLengthEnforced: true,
                            maxLines: null,
                            onChanged: (s) {
                              bloc.todaySolution = s;
                            },
                          ),
                          Divider(
                            height: 2,
                          )
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            margin: EdgeInsets.only(top: 10),
                            child: Text(
                              '明日工作计划',
                              style: TextStyle(
                                color: colorCyan,
                              ),
                            ),
                          ),
                          TextField(
                            decoration: InputDecoration(
                              fillColor: Theme.of(context).primaryColor,
                              border: InputBorder.none,
                              hintText: "请输入明日工作计划",
                            ),
                            keyboardType: TextInputType.multiline,
                            maxLengthEnforced: true,
                            maxLines: null,
                            onChanged: (s) {
                              bloc.tomorrowPlane = s;
                            },
                          ),
                          Divider(
                            height: 2,
                          )
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            margin: EdgeInsets.only(top: 10),
                            child: Text(
                              '明日拜访/跟进用户',
                              style: TextStyle(
                                color: colorCyan,
                              ),
                            ),
                          ),
                          TextField(
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: "请输入相关内容",
                            ),
                            keyboardType: TextInputType.multiline,
                            maxLengthEnforced: true,
                            maxLines: null,
                            onChanged: (s) {
                              bloc.tomorrowVisitClient = s;
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        bottomNavigationBar: Material(
          elevation: defaultElevation,
          child: Container(
            height: 60,
            child: Center(
              child: Text(
                '提交',
                style: TextStyle(
                  fontSize: 17,
                  color: colorOrigin,
                ),
              ),
            ),
          ),
        ),
      ),
      onWillPop: _onWillPop,
    );
  }

  Future<bool> _onWillPop() {
    return showDialog(
          context: context,
          builder: (context) => AlertDialog(
                title: Text('Are you sure?'),
                content: Text('Unsaved data will be lost.'),
                actions: <Widget>[
                  FlatButton(
                    onPressed: () => Navigator.of(context).pop(false),
                    child: Text('No'),
                  ),
                  FlatButton(
                    onPressed: () => Navigator.of(context).pop(true),
                    child: Text('Yes'),
                  ),
                ],
              ),
        ) ??
        false;
  }
}

class NewDailyBloc extends CommonBloc {
  BehaviorSubject<String> _date = BehaviorSubject(
    seedValue: DateFormat('yyyy-MM-dd').format(
      DateTime.now(),
    ),
  );
  String _todayWorkContent = "";
  String _todayVisitClient = "";
  String _todaySolution = "";
  String _tomorrowPlane = "";
  String _tomorrowVisitClient = "";

  dynamic get date => _date.stream;

  set date(String value) {
    _date.sink.add(value);
  }

  set todayWorkContent(String value) {
    if (value != _todayWorkContent) _todayWorkContent = value;
  }

  set tomorrowVisitClient(String value) {
    if (value != _tomorrowVisitClient) _tomorrowVisitClient = value;
  }

  set tomorrowPlane(String value) {
    if (value != _tomorrowPlane) _tomorrowPlane = value;
  }

  set todaySolution(String value) {
    if (value != _todaySolution) _todaySolution = value;
  }

  set todayVisitClient(String value) {
    if (value != _todayVisitClient) _todayVisitClient = value;
  }

  @override
  void onClosed() {
    _date.close();
    super.onClosed();
  }

  void save() async {
    if (_todayWorkContent.isEmpty &&
        _todayVisitClient.isEmpty &&
        _todaySolution.isEmpty &&
        _tomorrowPlane.isEmpty &&
        _tomorrowVisitClient.isEmpty) {
      showTip("请至少输入一项！");
      return;
    }
    pageLoading();
    var rsp = await ApiService().newDaily(
      _date.value,
      _todayWorkContent,
      _todayVisitClient,
      _todaySolution,
      _tomorrowPlane,
      _tomorrowVisitClient,
    );
    pageCompleted();
    if (rsp.code == ApiService.success) {
      finish(result: true);
    } else {
      showTip(rsp.msg);
    }
  }
}
