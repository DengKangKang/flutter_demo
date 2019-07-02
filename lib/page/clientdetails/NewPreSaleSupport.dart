import 'package:flutter/material.dart';
import 'package:flutter_app/data/Constant.dart';
import 'package:flutter_app/data/http/api_service.dart';
import 'package:flutter_app/data/http/rsp/data/RadioBean.dart';
import 'package:flutter_app/page/RadioListPage.dart';
import 'package:flutter_app/weight/Tool.dart';
import 'package:intl/intl.dart';

class NewPreSaleSupport extends StatefulWidget {
  NewPreSaleSupport(this._leadId, {Key key}) : super(key: key);

  final int _leadId;

  @override
  State<StatefulWidget> createState() {
    return NewPreSaleSupportState(_leadId);
  }
}

class NewPreSaleSupportState extends State<StatefulWidget> {
  NewPreSaleSupportState(this._leadId);

  final int _leadId;
  final _key = GlobalKey<ScaffoldState>();

  RadioBean _responsibility = responsibilities[0];
  RadioBean _projectProgress = projectProgresses[0];

  String _date = "";
  String _need = "";

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _key,
      appBar: AppBar(
        title: Text("新增售前支持"),
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
                      borderRadius:
                          BorderRadius.all(Radius.circular(4.0)),
                    ),
                    onPressed: () async {
                      var responsibilities = await showDialog(
                        context: context,
                        builder: (context) {
                          return RadioListPage.responsibilities(
                              groupValue: _responsibility);
                        },
                      );
                      if (responsibilities != null) {
                        setState(() {
                          _responsibility = responsibilities;
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
                            "*对象职责",
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
                                _responsibility.name,
                                style: Theme.of(context).textTheme.body1.merge(
                                    TextStyle(
                                        color: _responsibility.id == 0
                                            ? Colors.grey
                                            : Colors.black)),
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
                  child: RawMaterialButton(
                    elevation: 2.0,
                    fillColor: Theme.of(context).backgroundColor,
                    padding: EdgeInsets.symmetric(horizontal: 16.0),
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.all(Radius.circular(4.0)),
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
                  child: RawMaterialButton(
                    elevation: 2.0,
                    fillColor: Theme.of(context).backgroundColor,
                    padding: EdgeInsets.symmetric(horizontal: 16.0),
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.all(Radius.circular(4.0)),
                    ),
                    onPressed: () async {
                      var visitWay = await showDialog(
                        context: context,
                        builder: (context) {
                          return RadioListPage.projectProgresses(
                              groupValue: _projectProgress);
                        },
                      );
                      if (visitWay != null) {
                        setState(() {
                          _projectProgress = visitWay;
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
                            "*项目进度",
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
                                _projectProgress.name,
                                style: Theme.of(context).textTheme.body1.merge(
                                    TextStyle(
                                        color: _projectProgress.id == 0
                                            ? Colors.grey
                                            : Colors.black)),
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
                      borderRadius:
                          BorderRadius.all(Radius.circular(4.0)),
                    ),
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            margin: EdgeInsets.only(right: 16.0),
                            child: Text(
                              "*功能需求",
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
                                  text: _need,
                                ),
                              ),
                              textAlign: TextAlign.end,
                              decoration: InputDecoration(
                                hintText: "功能需求",
                                border: InputBorder.none,
                              ),
                              style: Theme.of(context).textTheme.body1,
                              onChanged: (s) {
                                _need = s;
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
    if (_responsibility.id == 0) {
      _key.currentState.showSnackBar(
        SnackBar(
          content: Text("请选择对象职责"),
        ),
      );
      return;
    }

    if (_date == null || _date.isEmpty) {
      _key.currentState.showSnackBar(
        SnackBar(
          content: Text("请选择日期"),
        ),
      );
      return;
    }

    if (_projectProgress.id == 0) {
      _key.currentState.showSnackBar(
        SnackBar(
          content: Text("请选择项目进度"),
        ),
      );
      return;
    }

    if (_need == null) {
      _key.currentState.showSnackBar(
        SnackBar(
          content: Text("请输入功能需求"),
        ),
      );
      return;
    }

    onLoading(context);
    var rsp = await ApiService().newSupport(
      _leadId.toString(),
      supportTypePreSales.toString(),
      responsibility: _responsibility.id.toString(),
      date: _date,
      projectProgress: _projectProgress.id.toString(),
      need: _need,
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
