import 'package:flutter/material.dart';
import 'package:flutter_app/data/constant.dart';
import 'package:flutter_app/data/http/api_service.dart';
import 'package:flutter_app/weight/tool.dart';
import 'package:intl/intl.dart';
import 'package:rxdart/rxdart.dart';

import '../../main.dart';
import 'apply_account/client_apply_debug_account_page.dart';

class NewSpecialVisit extends StatefulWidget {
  NewSpecialVisit(this._leadId, this._visitWay, {Key key}) : super(key: key);

  final int _leadId;
  final int _visitWay;

  @override
  State<StatefulWidget> createState() {
    return NewSpecialVisitState(_leadId, _visitWay);
  }
}

class NewSpecialVisitState extends State<StatefulWidget> {
  NewSpecialVisitState(
    this._leadId,
    this._visitWay,
  );

  final int _leadId;
  final int _visitWay;

  final _key = GlobalKey<ScaffoldState>();

  var _date = BehaviorSubject<String>();

  var _visitTargetPerson = StringBuffer();

  var _cost =  StringBuffer();

  var _target = StringBuffer();

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
        title: Text(
          _visitWay == businessVisit ? "新增商务宴请" : "新增赠送礼品",
        ),
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
              _onAdd();
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
                buildInputItem(
                  label: '对象',
                  hint: '请输入对象',
                  content: _visitTargetPerson,
                ),
                buildInputItem(
                  label: '花费',
                  hint: '请输入花费',
                  content: _cost,
                ),
                buildInputItem(
                  label: '目标',
                  hint: '请输入目标',
                  content: _target,
                ),
              ],
            ),
      ),
    );
  }

  void _onAdd() async {
    if (_date.value == null || _date.value.isEmpty) {
      _key.currentState.showSnackBar(
        SnackBar(
          content: Text("请输入日期"),
        ),
      );
      return;
    }
    if (_visitTargetPerson == null || _visitTargetPerson.isEmpty) {
      _key.currentState.showSnackBar(
        SnackBar(
          content: Text("请输入对象"),
        ),
      );
      return;
    }

    if (_cost == null || _cost.isEmpty) {
      _key.currentState.showSnackBar(
        SnackBar(
          content: Text("请输入费用"),
        ),
      );
      return;
    }
    if (_target == null || _target.isEmpty) {
      _key.currentState.showSnackBar(
        SnackBar(
          content: Text("请输入目标"),
        ),
      );
      return;
    }
    onLoading(context);
    var rsp = await ApiService().newVisitLog(
      _leadId.toString(),
      _visitWay.toString(),
      date: _date.value,
      visitTargetPeople: _visitTargetPerson.toString(),
      cost: _cost.toString(),
      visitTarget: _target.toString(),
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
