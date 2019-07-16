import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_app/bloc/Bloc.dart';
import 'package:flutter_app/data/http/api_service.dart';
import 'package:flutter_app/data/persistence/Persistence.dart';
import 'package:flutter_app/main.dart';
import 'package:flutter_app/page/RadioListPage.dart';
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
  var workFromForenoon = BehaviorSubject<int>();
  var workFromForenoonContent = '';
  var workFromAfternoon = BehaviorSubject<int>();
  var workFromAfternoonContent = '';

  var todayWorkContent = '';
  var todayVisitClient = '';
  var todaySolution = '';
  var tomorrowPlane = '';
  var tomorrowVisitClient = '';

  TextEditingController workFromForenoonContentController;
  TextEditingController workFromAfternoonContentController;

  @override
  void initState() {
    if (bloc == null) {
      bloc = NewDailyBloc();
    }
    if (workFromForenoonContentController == null) {
      workFromForenoonContentController = TextEditingController.fromValue(
        TextEditingValue(
          text: workFromForenoonContent,
          selection: TextSelection.collapsed(
            offset: workFromForenoonContent.length,
          ),
        ),
      );
    }
    if (workFromAfternoonContentController == null) {
      workFromAfternoonContentController = TextEditingController.fromValue(
        TextEditingValue(
          text: workFromAfternoonContent,
          selection: TextSelection.collapsed(
            offset: workFromAfternoonContent.length,
          ),
        ),
      );
    }
    Persistence().getDaily().then(
      (s) {
        if (s != null && s.isNotEmpty) {
          var decoded = jsonDecode(s);
          setState(() {
            bloc._date.add(decoded['date'] ?? '');
            workFromForenoon.value = decoded['workFromForenoon'];
            workFromForenoonContent = decoded['workFromForenoonContent'] ?? '';
            workFromForenoonContentController.text = workFromForenoonContent;
            workFromForenoonContentController.selection =
                TextSelection.collapsed(
              offset: workFromForenoonContent.length,
            );
            workFromAfternoon.value = decoded['workFromAfternoon'];
            workFromAfternoonContent =
                decoded['workFromAfternoonContent'] ?? '';
            workFromAfternoonContentController.text = workFromAfternoonContent;
            workFromAfternoonContentController.selection =
                TextSelection.collapsed(
              offset: workFromAfternoonContent.length,
            );
            todayWorkContent = decoded['todayWorkContent'] ?? '';
            todayWorkContent = decoded['todayWorkContent'] ?? '';
            todayWorkContent = decoded['todayWorkContent'] ?? '';
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
                                firstDate: DateTime(DateTime.now().year - 2),
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
                        margin: EdgeInsets.only(top: 10),
                        child: Material(
                          color: Colors.white,
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 20,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Container(
                                  margin: EdgeInsets.only(top: 9),
                                  child: Text(
                                    '今日工作形式',
                                    style: TextStyle(
                                      color: colorCyan,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                                Container(
                                  child: Row(
                                    children: <Widget>[
                                      InkWell(
                                        child: buildWorkFrom(
                                            true, workFromForenoon),
                                        onTap: () {
                                          workFromSelected(
                                            context,
                                            true,
                                          );
                                        },
                                      ),
                                      buildWorkFromContent(true),
                                    ],
                                  ),
                                ),
                                Divider(
                                  height: 1,
                                ),
                                Container(
                                  child: Row(
                                    children: <Widget>[
                                      InkWell(
                                        child: buildWorkFrom(
                                            false, workFromAfternoon),
                                        onTap: () {
                                          workFromSelected(
                                            context,
                                            false,
                                          );
                                        },
                                      ),
                                      buildWorkFromContent(false),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 10),
                        child: Material(
                          color: Colors.white,
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 20),
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
                                      controller:
                                          TextEditingController.fromValue(
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
                                      controller:
                                          TextEditingController.fromValue(
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
                                      controller:
                                          TextEditingController.fromValue(
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
                                      controller:
                                          TextEditingController.fromValue(
                                              TextEditingValue(
                                        text: tomorrowPlane,
                                        selection: TextSelection.collapsed(
                                          offset: tomorrowPlane.length,
                                        ),
                                      )),
                                      decoration: InputDecoration(
                                        fillColor:
                                            Theme.of(context).primaryColor,
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
                                      controller:
                                          TextEditingController.fromValue(
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
                        workFromForenoon.value,
                        workFromForenoonContent,
                        workFromAfternoon.value,
                        workFromAfternoonContent,
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

  Flexible buildWorkFromContent(isForenoon) {
    return Flexible(
      child: Container(
        margin: EdgeInsets.only(left: 10),
        child: StreamBuilder<int>(
          stream: isForenoon ? workFromForenoon : workFromAfternoon,
          builder: (c, s) => TextField(
            textAlign: TextAlign.end,
            controller: isForenoon
                ? workFromForenoonContentController
                : workFromAfternoonContentController,
            decoration: InputDecoration(
              fillColor: Colors.red,
              border: InputBorder.none,
              hintText: getHint(s.data),
              contentPadding: EdgeInsets.only(
                top: 5,
                bottom: 8,
              ),
            ),
            style: TextStyle(fontSize: 15),
            keyboardType: TextInputType.multiline,
            maxLengthEnforced: true,
            maxLines: null,
            onChanged: (content) {
              if (isForenoon) {
                workFromForenoonContent = content;
              } else {
                workFromAfternoonContent = content;
              }
            },
          ),
        ),
      ),
    );
  }

  Future workFromSelected(BuildContext context, isForenoon) async {
    var workFrom = await showDialog(
      context: context,
      builder: (context) {
        return RadioListPage(workForms);
      },
    );
    if (workFrom != null) {
      if (workFrom.id == workFormCallOut) {
        if (isForenoon) {
          workFromForenoonContentController.clear();
          workFromForenoonContent = '';
        } else {
          workFromAfternoonContentController.clear();
          workFromAfternoonContent = '';
        }
      }
      if (isForenoon) {
        workFromForenoon.sink.add(workFrom.id);
      } else {
        workFromAfternoon.sink.add(workFrom.id);
      }
    }
    ;
  }

  StreamBuilder buildWorkFrom(isForenoon, steam) {
    return StreamBuilder<int>(
      stream: steam,
      builder: (c, s) => Container(
        padding: EdgeInsets.only(
          top: 5,
          bottom: 8,
        ),
        child: Row(
          children: <Widget>[
            Text(
              isForenoon ? '上午' : '下午',
              style: TextStyle(
                fontSize: 15,
                color: colorCyan,
              ),
            ),
            Container(
              margin: EdgeInsets.only(left: 10),
              child: Text(
                workForms
                        .firstWhere(
                          (e) => e.id == s.data,
                          orElse: () => null,
                        )
                        ?.name ??
                    '请选择',
                style: TextStyle(
                  fontSize: 15,
                  color: workForms.firstWhere(
                            (e) => e.id == s.data,
                            orElse: () => null,
                          ) ==
                          null
                      ? Colors.grey
                      : Colors.black,
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(
                left: 7,
              ),
              child: Image.asset(
                'assets/images/ico_me_jt.png',
              ),
            ),
            Container(
              height: 15,
              width: 1,
              color: Colors.grey,
              margin: EdgeInsets.only(
                left: 7,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<bool> _onWillPop() async {
    var daily = {};
    if (bloc._date.value.isNotEmpty) daily['date'] = bloc._date.value;
    if (workFromForenoon.value != null) {
      daily['workFromForenoon'] = workFromForenoon.value;
    }
    if (workFromAfternoon.value != null) {
      daily['workFromAfternoon'] = workFromAfternoon.value;
    }
    if (workFromForenoonContent != null && workFromForenoonContent.isNotEmpty) {
      daily['workFromForenoonContent'] = workFromForenoonContent;
    }
    if (workFromAfternoonContent != null &&
        workFromAfternoonContent.isNotEmpty) {
      daily['workFromAfternoonContent'] = workFromAfternoonContent;
    }

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

  String getHint(workFrom) {
    var hint;
    switch (workFrom) {
      case workFormCallOut:
        hint = '请输入呼叫数（必填）';
        break;
      case workFormGoOut:
        hint = '请输入客户名（必填）';
        break;
      case workFormOther:
        hint = '请输入内容（必填）';
        break;
    }
    return hint;
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
    forenoonWorkFrom,
    forenoonWorkContent,
    afternoonWorkFrom,
    afternoonWorkContent,
  ) async {
    if (workForms.firstWhere((e) => e.id == forenoonWorkFrom,
            orElse: () => null) ==
        null) {
      showTip('请选择上午工作形式！');
      return;
    }

    if ((forenoonWorkContent == null || forenoonWorkContent.isEmpty)) {
      showTip('${getHint(forenoonWorkFrom)}！');
      return;
    }
    if (workForms.firstWhere((e) => e.id == afternoonWorkFrom,
            orElse: () => null) ==
        null) {
      showTip('请选择下午工作形式！');
      return;
    }
    if ((afternoonWorkContent == null || afternoonWorkContent.isEmpty)) {
      showTip('${getHint(afternoonWorkFrom)}！');
      return;
    }
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
      forenoonWorkFrom.toString(),
      forenoonWorkContent,
      afternoonWorkFrom.toString(),
      afternoonWorkContent,
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

  String getHint(workFrom) {
    var hint;
    switch (workFrom) {
      case workFormCallOut:
        hint = '请输入呼叫数';
        break;
      case workFormGoOut:
        hint = '请输入客户名';
        break;
      case workFormOther:
        hint = '请输入内容';
        break;
    }
    return hint;
  }
}
