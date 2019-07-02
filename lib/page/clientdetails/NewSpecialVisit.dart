import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app/data/Constant.dart';
import 'package:flutter_app/data/http/api_service.dart';
import 'package:flutter_app/weight/Tool.dart';
import 'package:intl/intl.dart';

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

  String _date = "";

  String _visitTargetPerson = "";

  String _cost = "";

  String _target = "";

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _key,
      appBar: AppBar(
        title: Text(
          _visitWay == businessVisit ? "新增商务宴请" : "新增赠送礼品",
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.check,
              color: Colors.black,
            ),
            onPressed: () {
              _onAdd(context);
            },
          )
        ],
      ),
      body: Builder(
        builder: (context) => Column(
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(
                    top: 12.0,
                    right: 16.0,
                    left: 16.0,
                  ),
                  child: RawMaterialButton(
                    elevation: 2.0,
                    fillColor: Theme.of(context).backgroundColor,
                    padding: EdgeInsets.symmetric(horizontal: 16.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(4.0)),
                    ),
                    onPressed: () async {
                      var date = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(DateTime.now().year - 1),
                        lastDate: DateTime(DateTime.now().year + 1, 12, 31),
                      );
                      if (date != null) {
                        setState(() {
                          _date = DateFormat('yyyy-MM-dd').format(date);
                        });
                      }
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          margin: EdgeInsets.only(
                              right: 16.0, top: 12.0, bottom: 12.0),
                          child: Text(
                            "*日期",
                            style: Theme.of(context).textTheme.body1.merge(
                                  TextStyle(
                                    color: Colors.grey,
                                  ),
                                ),
                          ),
                        ),
                        Flexible(
                            child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Flexible(
                              child: Text(
                                _date.isEmpty ? "请选择日期" : _date,
                                style: Theme.of(context)
                                    .textTheme
                                    .body1
                                    .merge(TextStyle(color: Colors.grey)),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                              ),
                            ),
                            Icon(Icons.arrow_drop_down)
                          ],
                        )),
                      ],
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(
                    top: 12.0,
                    right: 16.0,
                    left: 16.0,
                  ),
                  child: Card(
                    elevation: 2.0,
                    color: Theme.of(context).backgroundColor,
                    margin: EdgeInsets.all(0.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(4.0)),
                    ),
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            margin: EdgeInsets.only(right: 16.0),
                            child: Text(
                              "*对象",
                              style: Theme.of(context).textTheme.body1.merge(
                                    TextStyle(
                                      color: Colors.grey,
                                    ),
                                  ),
                            ),
                          ),
                          Flexible(
                            child: TextField(
                              controller: TextEditingController.fromValue(
                                TextEditingValue(
                                  text: _visitTargetPerson,
                                ),
                              ),
                              textAlign: TextAlign.end,
                              decoration: InputDecoration(
                                hintText: "请输入对象",
                                border: InputBorder.none,
                              ),
                              style: Theme.of(context).textTheme.body1,
                              onChanged: (s) {
                                _visitTargetPerson = s;
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(
                    top: 12.0,
                    right: 16.0,
                    left: 16.0,
                  ),
                  child: Card(
                    elevation: 2.0,
                    color: Theme.of(context).backgroundColor,
                    margin: EdgeInsets.all(0.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(4.0)),
                    ),
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            margin: EdgeInsets.only(right: 16.0),
                            child: Text(
                              "*花费",
                              style: Theme.of(context).textTheme.body1.merge(
                                    TextStyle(
                                      color: Colors.grey,
                                    ),
                                  ),
                            ),
                          ),
                          Flexible(
                            child: TextField(
                              controller: TextEditingController.fromValue(
                                TextEditingValue(
                                  text: _cost,
                                ),
                              ),
                              textAlign: TextAlign.end,
                              decoration: InputDecoration(
                                hintText: "请输入花费",
                                border: InputBorder.none,
                              ),
                              style: Theme.of(context).textTheme.body1,
                              keyboardType: TextInputType.number,
                              onChanged: (s) {
                                _cost = s;
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(
                    top: 12.0,
                    right: 16.0,
                    left: 16.0,
                  ),
                  child: Card(
                    elevation: 2.0,
                    color: Theme.of(context).backgroundColor,
                    margin: EdgeInsets.all(0.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(4.0)),
                    ),
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            margin: EdgeInsets.only(right: 16.0),
                            child: Text(
                              "*目标",
                              style: Theme.of(context).textTheme.body1.merge(
                                    TextStyle(
                                      color: Colors.grey,
                                    ),
                                  ),
                            ),
                          ),
                          Flexible(
                            child: TextField(
                              controller: TextEditingController.fromValue(
                                TextEditingValue(
                                  text: _target,
                                ),
                              ),
                              textAlign: TextAlign.end,
                              decoration: InputDecoration(
                                hintText: "请输入目标",
                                border: InputBorder.none,
                              ),
                              style: Theme.of(context).textTheme.body1,
                              onChanged: (s) {
                                _target = s;
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
      ),
    );
  }

  void _onAdd(BuildContext context) async {
    if (_date == null || _date.isEmpty) {
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
//    var rsp = await ApiService().newVisitLog(
//      _leadId.toString(),
//      _visitWay.toString(),
//      date: _date,
//      visitTargetPeople: _visitTargetPerson,
//      cost: _cost,
//      visitTarget: _target,
//    );
//    loadingFinish(context);
//    if (rsp.code == ApiService.success) {
//      Navigator.of(context).pop(true);
//    } else {
//      _key.currentState.showSnackBar(
//        SnackBar(
//          content: Text(rsp.msg),
//        ),
//      );
//    }
  }
}
