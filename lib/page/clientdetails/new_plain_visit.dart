import 'package:flutter/material.dart';
import 'package:flutter_app/data/http/api_service.dart';
import 'package:flutter_app/data/http/rsp/data/RadioBean.dart';
import 'package:flutter_app/page/radio_list_page.dart';
import 'package:flutter_app/weight/tool.dart';
import 'package:intl/intl.dart';
import 'package:rxdart/rxdart.dart';

import '../../main.dart';
import 'apply_account/client_apply_debug_account_page.dart';

class NewPlainVisit extends StatefulWidget {
  NewPlainVisit(this._leadId, {Key key}) : super(key: key);

  final int _leadId;

  @override
  State<StatefulWidget> createState() {
    return NewPlainVisitState(_leadId);
  }
}

class NewPlainVisitState extends State<StatefulWidget> {
  NewPlainVisitState(this._leadId);

  final int _leadId;
  final _key = GlobalKey<ScaffoldState>();

  var _date = BehaviorSubject<String>();

  var _visitWay = BehaviorSubject<RadioBean>();

  var _clientRsp = StringBuffer();

  var _solution = StringBuffer();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _key,
      backgroundColor: colorBg,
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        title: Text("新增日常拜访"),
        actions: <Widget>[
          InkWell(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Center(
                child: Text(
                  '确定',
                  style: TextStyle(
                    fontSize: 15,
                    color: colorOrigin,
                  ),
                ),
              ),
            ),
            onTap: () {
              _onAdd(context);
            },
          )

        ],
      ),
      body: Builder(
        builder: (context) => Column(
              children: <Widget>[
                Divider(height: 10,color: colorBg,),
                buildClickableItem(
                    label: '日期',
                    hint: '请选择日期',
                    content: _date,
                    onClick: () async {
                      var date = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(DateTime.now().year - 1),
                        lastDate: DateTime(DateTime.now().year + 1, 12, 31),
                      );
                      if (date != null) {
                        _date.value = DateFormat('yyyy-MM-dd').format(date);
                      }
                    }),
                buildClickableItem(
                    spans: [
                      TextSpan(
                        text: '*',
                        style: TextStyle(
                          fontSize: 15,
                          color: colorOrigin,
                        ),
                      ),
                      TextSpan(
                        text: '形式',
                        style: TextStyle(fontSize: 15),
                      ),
                    ],
                    hint: '请选择形式',
                    content: _visitWay,
                    onClick: () async {
                      var visitWay = await showDialog(
                        context: context,
                        builder: (context) {
                          return RadioListPage.visitWaysDaily(
                              groupValue: _visitWay.value);
                        },
                      );
                      if (visitWay != null) {
                        _visitWay.value = visitWay;
                      }
                    }),
                buildInputItem(
                  label: '客户反馈',
                  hint: '请输入客户反馈',
                  content: _clientRsp,
                ),
                buildInputItem(
                  label: '解决方案',
                  hint: '请输入解决方案',
                  content: _solution,
                ),
              ],
            ),
      ),
    );
  }

  void _onAdd(BuildContext context) async {
    if (_date.value == null || _date.value.isEmpty) {
      _key.currentState.showSnackBar(
        SnackBar(
          content: Text("请选择日期"),
        ),
      );
      return;
    }
    if (_visitWay.value == null || _visitWay.value.id == 0) {
      _key.currentState.showSnackBar(
        SnackBar(
          content: Text("请选择形式"),
        ),
      );
      return;
    }

    if (_clientRsp == null || _clientRsp.isEmpty) {
      _key.currentState.showSnackBar(
        SnackBar(
          content: Text("请输入客户反馈"),
        ),
      );
      return;
    }

    if (_solution == null || _solution.isEmpty) {
      _key.currentState.showSnackBar(
        SnackBar(
          content: Text("请输入解决方案"),
        ),
      );
      return;
    }

    onLoading(context);
    var rsp = await ApiService().newVisitLog(
      _leadId.toString(),
      _visitWay.value.id.toString(),
      date: _date.value,
      clientRsp: _clientRsp.toString(),
      solution: _solution.toString(),
    );
    loadingFinish(context);
    if (rsp.code == ApiService.success) {
      Navigator.of(context).pop(true);
    } else {
      _key.currentState.showSnackBar(
        SnackBar(
          content: Text(rsp.msg),
        ),
      );
    }
  }
}
