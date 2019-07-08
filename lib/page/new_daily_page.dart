import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_app/bloc/Bloc.dart';
import 'package:flutter_app/data/http/api_service.dart';
import 'package:flutter_app/data/persistence/Persistence.dart';
import 'package:flutter_app/main.dart';
import 'package:intl/intl.dart';
import 'package:rxdart/rxdart.dart';

import 'base/CommonPageState.dart';

class NewDailyPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return NewDailyPageState();
  }
}

class NewDailyPageState extends CommonPageState<NewDailyPage, NewDailyBloc> {
  var todayWorkContent = '';
  var todayVisitClient = '';
  var todaySolution = '';
  var tomorrowPlane = '';
  var tomorrowVisitClient = '';

  @override
  void initState() {
    if (bloc == null) {
      bloc = NewDailyBloc();
    }
    Persistence().getDaily().then(
      (s) {
        if (s != null && s.isNotEmpty) {
          var decoded = jsonDecode(s);
          setState(() {
            bloc._date.add(decoded['date'] ?? '');
            todayWorkContent = decoded['todayWorkContent'] ?? '';
            todayVisitClient = decoded['todayVisitClient'] ?? '';
            todaySolution = decoded['todaySolution'] ?? '';
            tomorrowPlane = decoded['tomorrowPlane'] ?? '';
            tomorrowVisitClient = decoded['tomorrowVisitClient'] ?? '';
          });
        }
      },
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: Scaffold(
        backgroundColor: colorBg,
        key: scaffoldKey,
        appBar: AppBar(
          centerTitle: true,
          elevation: 0,
          title: Text('新增日报'),
        ),
        body: Container(
          child: Theme(
            data: Theme.of(context).copyWith(
              primaryColor: Colors.blue,
            ),
            child: Column(
              children: <Widget>[
                Flexible(
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
                                firstDate: DateTime(
                                  DateTime.now().year - 2
                                ),
                                lastDate: DateTime.now(),
                              );
                              if (date != null) {
                                bloc.date =
                                    DateFormat('yyyy-MM-dd').format(date);
                              }
                            },
                            child: StreamBuilder<String>(
                              initialData: '',
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
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
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
                                  controller: TextEditingController.fromValue(
                                    TextEditingValue(
                                      text: todayWorkContent,
                                      selection: TextSelection.collapsed(
                                        offset: todayWorkContent.length,
                                      ),
                                    ),
                                  ),
                                  decoration: InputDecoration(
                                    fillColor: Colors.red,
                                    border: InputBorder.none,
                                    hintText: '请输入今日工作内容',
                                  ),
                                  keyboardType: TextInputType.multiline,
                                  maxLengthEnforced: true,
                                  maxLines: null,
                                  onChanged: (s) {
                                    todayWorkContent = s;
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
                                  controller: TextEditingController.fromValue(
                                      TextEditingValue(
                                    text: todayVisitClient,
                                    selection: TextSelection.collapsed(
                                      offset: todayVisitClient.length,
                                    ),
                                  )),
                                  decoration: InputDecoration(
                                      border: InputBorder.none,
                                      hintText: '请输入相关内容'),
                                  keyboardType: TextInputType.multiline,
                                  maxLengthEnforced: true,
                                  maxLines: null,
                                  onChanged: (s) {
                                    todayVisitClient = s;
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
                                  controller: TextEditingController.fromValue(
                                    TextEditingValue(
                                      text: todaySolution,
                                      selection: TextSelection.collapsed(
                                        offset: todaySolution.length,
                                      ),
                                    ),
                                  ),
                                  decoration: InputDecoration(
                                      border: InputBorder.none,
                                      hintText: '请输入相关内容'),
                                  keyboardType: TextInputType.multiline,
                                  maxLengthEnforced: true,
                                  maxLines: null,
                                  onChanged: (s) {
                                    todaySolution = s;
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
                                  controller: TextEditingController.fromValue(
                                      TextEditingValue(
                                    text: tomorrowPlane,
                                    selection: TextSelection.collapsed(
                                      offset: tomorrowPlane.length,
                                    ),
                                  )),
                                  decoration: InputDecoration(
                                    fillColor: Theme.of(context).primaryColor,
                                    border: InputBorder.none,
                                    hintText: '请输入明日工作计划',
                                  ),
                                  keyboardType: TextInputType.multiline,
                                  maxLengthEnforced: true,
                                  maxLines: null,
                                  onChanged: (s) {
                                    tomorrowPlane = s;
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
                                  controller: TextEditingController.fromValue(
                                      TextEditingValue(
                                    text: tomorrowVisitClient,
                                    selection: TextSelection.collapsed(
                                      offset: tomorrowVisitClient.length,
                                    ),
                                  )),
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText: '请输入相关内容',
                                  ),
                                  keyboardType: TextInputType.multiline,
                                  maxLengthEnforced: true,
                                  maxLines: null,
                                  onChanged: (s) {
                                    tomorrowVisitClient = s;
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
                Material(
                  elevation: defaultElevation,
                  child: InkWell(
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
                    onTap: () {
                      bloc.save(
                        todayWorkContent,
                        todayVisitClient,
                        todaySolution,
                        tomorrowPlane,
                        tomorrowVisitClient,
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      onWillPop: _onWillPop,
    );
  }

  Future<bool> _onWillPop() async {
    var daily = {};
    if (bloc._date.value.isNotEmpty) daily['date'] = bloc._date.value;
    if (todayWorkContent.isNotEmpty) {
      daily['todayWorkContent'] = todayWorkContent;
    }

    if (todayVisitClient.isNotEmpty) {
      daily['todayVisitClient'] = todayVisitClient;
    }

    if (todaySolution.isNotEmpty) {
      daily['todaySolution'] = todaySolution;
    }

    if (tomorrowPlane.isNotEmpty) {
      daily['tomorrowPlane'] = tomorrowPlane;
    }

    if (tomorrowVisitClient.isNotEmpty) {
      daily['tomorrowVisitClient'] = tomorrowVisitClient;
    }

    await Persistence().setDaily(
      jsonEncode(daily),
    );
    return showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('提示'),
            content: Text('草稿已自动保存'),
            actions: <Widget>[
              FlatButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: Text(
                  '退出',
                  style: TextStyle(color: Colors.grey),
                ),
              ),
              FlatButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: Text(
                  '继续填写',
                  style: TextStyle(color: colorOrigin),
                ),
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

  dynamic get date => _date.stream;

  set date(String value) {
    _date.sink.add(value);
  }

  @override
  void onClosed() {
    _date.close();
    super.onClosed();
  }

  void save(
    todayWorkContent,
    todayVisitClient,
    todaySolution,
    tomorrowPlane,
    tomorrowVisitClient,
  ) async {
    if (todayWorkContent.isEmpty &&
        todayVisitClient.isEmpty &&
        todaySolution.isEmpty &&
        tomorrowPlane.isEmpty &&
        tomorrowVisitClient.isEmpty) {
      showTip('请至少输入一项！');
      return;
    }
    pageLoading();
    var rsp = await ApiService().newDaily(
      _date.value,
      todayWorkContent,
      todayVisitClient,
      todaySolution,
      tomorrowPlane,
      tomorrowVisitClient,
    );
    pageCompleted();
    if (rsp.code == ApiService.success) {
      await Persistence().setDaily(
        jsonEncode(''),
      );
      finish(result: true);
    } else {
      showTip(rsp.msg);
    }
  }
}
