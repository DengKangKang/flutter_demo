import 'package:flutter/material.dart';
import 'package:flutter_app/CommonRoute.dart';
import 'package:flutter_app/data/http/ApiService.dart';
import 'package:flutter_app/data/http/rsp/BaseRsp.dart';
import 'package:flutter_app/data/http/rsp/LoginRsp.dart';
import 'package:flutter_app/data/http/rsp/data/RadioBean.dart';
import 'package:flutter_app/data/persistence/Persistence.dart';
import 'package:flutter_app/page/HomePage.dart';
import 'package:flutter_app/page/RadioListPage.dart';
import 'package:flutter_app/weight/Tool.dart';
import 'package:intl/intl.dart';

class NewPlainVisit extends StatefulWidget {
  NewPlainVisit(this._leadId, {Key key}) : super(key: key);

  final int _leadId;

  @override
  State<StatefulWidget> createState() {
    return new NewPlainVisitState(_leadId);
  }
}

class NewPlainVisitState extends State<StatefulWidget> {
  NewPlainVisitState(this._leadId);

  final int _leadId;
  final _key = new GlobalKey<ScaffoldState>();

  String _date = "";

  RadioBean _visitWay = visitWaysDaily[0];

  String _clientRsp = "";

  String _solution = "";

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      key: _key,
      appBar: new AppBar(
        title: new Text("新增日常拜访"),
        actions: <Widget>[
          new IconButton(
            icon: new Icon(
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
        builder: (context) => new Column(
              children: <Widget>[
                new Container(
                  margin: EdgeInsets.only(
                    top: 12.0,
                    right: 16.0,
                    left: 16.0,
                  ),
                  child: new RawMaterialButton(
                    elevation: 2.0,
                    fillColor: Theme.of(context).backgroundColor,
                    padding: new EdgeInsets.symmetric(horizontal: 16.0),
                    shape: new RoundedRectangleBorder(
                      borderRadius:
                          new BorderRadius.all(new Radius.circular(4.0)),
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
                          _date = new DateFormat('yyyy-MM-dd').format(date);
                        });
                      }
                    },
                    child: new Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        new Container(
                          margin: EdgeInsets.only(
                              right: 16.0, top: 12.0, bottom: 12.0),
                          child: new Text(
                            "*日期",
                            style: Theme.of(context).textTheme.body1.merge(
                                  TextStyle(
                                    color: Colors.grey,
                                  ),
                                ),
                          ),
                        ),
                        new Flexible(
                            child: new Row(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            new Flexible(
                              child: new Text(
                                _date,
                                style: Theme.of(context).textTheme.body1,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                              ),
                            ),
                            new Icon(Icons.arrow_drop_down)
                          ],
                        )),
                      ],
                    ),
                  ),
                ),
                new Container(
                  margin: EdgeInsets.only(
                    top: 12.0,
                    right: 16.0,
                    left: 16.0,
                  ),
                  child: new RawMaterialButton(
                    elevation: 2.0,
                    fillColor: Theme.of(context).backgroundColor,
                    padding: new EdgeInsets.symmetric(horizontal: 16.0),
                    shape: new RoundedRectangleBorder(
                      borderRadius:
                          new BorderRadius.all(new Radius.circular(4.0)),
                    ),
                    onPressed: () async {
                      var visitWay = await showDialog(
                        context: context,
                        builder: (context) {
                          return RadioListPage.visitWaysDaily(
                              groupValue: _visitWay);
                        },
                      );
                      if (visitWay != null) {
                        setState(() {
                          _visitWay = visitWay;
                        });
                      }
                    },
                    child: new Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        new Container(
                          margin: EdgeInsets.only(
                              right: 16.0, top: 12.0, bottom: 12.0),
                          child: new Text(
                            "*形式",
                            style: Theme.of(context).textTheme.body1.merge(
                                  TextStyle(
                                    color: Colors.grey,
                                  ),
                                ),
                          ),
                        ),
                        new Flexible(
                            child: new Row(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            new Flexible(
                              child: new Text(
                                _visitWay.name,
                                style: Theme.of(context).textTheme.body1.merge(
                                    new TextStyle(
                                        color: _visitWay.id == 0
                                            ? Colors.grey
                                            : Colors.black)),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                              ),
                            ),
                            new Icon(Icons.arrow_drop_down)
                          ],
                        )),
                      ],
                    ),
                  ),
                ),
                new Container(
                  margin: EdgeInsets.only(
                    top: 12.0,
                    right: 16.0,
                    left: 16.0,
                  ),
                  child: new Card(
                    elevation: 2.0,
                    color: Theme.of(context).backgroundColor,
                    margin: EdgeInsets.all(0.0),
                    shape: new RoundedRectangleBorder(
                      borderRadius:
                          new BorderRadius.all(new Radius.circular(4.0)),
                    ),
                    child: new Container(
                      padding: EdgeInsets.symmetric(horizontal: 16.0),
                      child: new Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          new Container(
                            margin: EdgeInsets.only(right: 16.0),
                            child: new Text(
                              "*客户反馈",
                              style: Theme.of(context).textTheme.body1.merge(
                                    TextStyle(
                                      color: Colors.grey,
                                    ),
                                  ),
                            ),
                          ),
                          new Flexible(
                            child: TextField(
                              controller: TextEditingController.fromValue(
                                new TextEditingValue(
                                  text: _clientRsp,
                                ),
                              ),
                              textAlign: TextAlign.end,
                              decoration: new InputDecoration(
                                hintText: "请输入客户反馈",
                                border: InputBorder.none,
                              ),
                              style: Theme.of(context).textTheme.body1,
                              onChanged: (s) {
                                _clientRsp = s;
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                new Container(
                  margin: EdgeInsets.only(
                    top: 12.0,
                    right: 16.0,
                    left: 16.0,
                  ),
                  child: new Card(
                    elevation: 2.0,
                    color: Theme.of(context).backgroundColor,
                    margin: EdgeInsets.all(0.0),
                    shape: new RoundedRectangleBorder(
                      borderRadius:
                          new BorderRadius.all(new Radius.circular(4.0)),
                    ),
                    child: new Container(
                      padding: EdgeInsets.symmetric(horizontal: 16.0),
                      child: new Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          new Container(
                            margin: EdgeInsets.only(right: 16.0),
                            child: new Text(
                              "*解决方案",
                              style: Theme.of(context).textTheme.body1.merge(
                                    TextStyle(
                                      color: Colors.grey,
                                    ),
                                  ),
                            ),
                          ),
                          new Flexible(
                            child: TextField(
                              controller: TextEditingController.fromValue(
                                new TextEditingValue(
                                  text: _solution,
                                ),
                              ),
                              textAlign: TextAlign.end,
                              decoration: new InputDecoration(
                                hintText: "请输入解决方案",
                                border: InputBorder.none,
                              ),
                              style: Theme.of(context).textTheme.body1,
                              onChanged: (s) {
                                _solution = s;
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
        new SnackBar(
          content: new Text("请选择日期"),
        ),
      );
      return;
    }
    if (_visitWay == null || _visitWay.id == 0) {
      _key.currentState.showSnackBar(
        new SnackBar(
          content: new Text("请选择形式"),
        ),
      );
      return;
    }

    if (_clientRsp == null || _clientRsp.isEmpty) {
      _key.currentState.showSnackBar(
        new SnackBar(
          content: new Text("请输入客户反馈"),
        ),
      );
      return;
    }

    if (_solution == null || _solution.isEmpty) {
      _key.currentState.showSnackBar(
        new SnackBar(
          content: new Text("请输入解决方案"),
        ),
      );
      return;
    }

    onLoading(context);
    var rsp = await ApiService().newVisitLog(
      _leadId.toString(),
      _visitWay.id.toString(),
      date: _date,
      clientRsp: _clientRsp,
      solution: _solution,
    );
    loadingFinish(context);
    if (rsp.code == ApiService.success) {
      Navigator.of(context).pop(true);
    } else {
      _key.currentState.showSnackBar(
        new SnackBar(
          content: new Text(rsp.msg),
        ),
      );
    }
  }
}
