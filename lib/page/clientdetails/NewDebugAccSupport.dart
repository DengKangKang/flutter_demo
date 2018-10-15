import 'package:flutter/material.dart';
import 'package:flutter_app/CommonRoute.dart';
import 'package:flutter_app/data/Constant.dart';
import 'package:flutter_app/data/http/ApiService.dart';
import 'package:flutter_app/data/http/rsp/BaseRsp.dart';
import 'package:flutter_app/data/http/rsp/LoginRsp.dart';
import 'package:flutter_app/data/http/rsp/data/RadioBean.dart';
import 'package:flutter_app/data/persistence/Persistence.dart';
import 'package:flutter_app/page/HomePage.dart';
import 'package:flutter_app/page/RadioListPage.dart';
import 'package:flutter_app/weight/Tool.dart';
import 'package:intl/intl.dart';

class NewDebugAccSupport extends StatefulWidget {
  NewDebugAccSupport(this._leadId, {Key key}) : super(key: key);

  final int _leadId;

  @override
  State<StatefulWidget> createState() {
    return new NewDebugAccSupportState(_leadId);
  }
}

class NewDebugAccSupportState extends State<StatefulWidget> {
  NewDebugAccSupportState(this._leadId);

  final int _leadId;
  final _key = new GlobalKey<ScaffoldState>();


  String _account = "";
  String _email = "";
  String _password = "";
  String _dateLimit = "";
  String _invoiceCount = "";

  String _memo = "";

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      key: _key,
      appBar: new AppBar(
        title: new Text("新增测试账号"),
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
        builder: (context) =>
        new Column(
          children: <Widget>[
            new Container(
              margin: EdgeInsets.only(
                top: 12.0,
                right: 16.0,
                left: 16.0,
              ),
              child: new Card(
                elevation: 2.0,
                color: Theme
                    .of(context)
                    .backgroundColor,
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
                          "*用户名",
                          style: Theme
                              .of(context)
                              .textTheme
                              .body1
                              .merge(
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
                              text: _account,
                            ),
                          ),
                          textAlign: TextAlign.end,
                          decoration: new InputDecoration(
                            hintText: "请输入用户名",
                            border: InputBorder.none,
                          ),
                          style: Theme
                              .of(context)
                              .textTheme
                              .body1,
                          onChanged: (s) {
                            _account = s;
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
                color: Theme
                    .of(context)
                    .backgroundColor,
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
                          "*注册邮箱",
                          style: Theme
                              .of(context)
                              .textTheme
                              .body1
                              .merge(
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
                              text: _email,
                            ),
                          ),
                          textAlign: TextAlign.end,
                          decoration: new InputDecoration(
                            hintText: "请输入注册邮箱",
                            border: InputBorder.none,
                          ),
                          style: Theme
                              .of(context)
                              .textTheme
                              .body1,
                          onChanged: (s) {
                            _email = s;
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
                color: Theme
                    .of(context)
                    .backgroundColor,
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
                          "*初始密码",
                          style: Theme
                              .of(context)
                              .textTheme
                              .body1
                              .merge(
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
                              text: _password,
                            ),
                          ),
                          textAlign: TextAlign.end,
                          decoration: new InputDecoration(
                            hintText: "请输入初始密码",
                            border: InputBorder.none,
                          ),
                          style: Theme
                              .of(context)
                              .textTheme
                              .body1,
                          onChanged: (s) {
                            _password = s;
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
              child: new RawMaterialButton(
                elevation: 2.0,
                fillColor: Theme
                    .of(context)
                    .backgroundColor,
                padding: new EdgeInsets.symmetric(horizontal: 16.0),
                shape: new RoundedRectangleBorder(
                  borderRadius:
                  new BorderRadius.all(new Radius.circular(4.0)),
                ),
                onPressed: () async {
                  var date = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(DateTime
                        .now()
                        .year - 1),
                    lastDate: DateTime(DateTime
                        .now()
                        .year + 1, 12, 31),
                  );
                  if (date != null) {
                    setState(() {
                      _dateLimit = new DateFormat('yyyy-MM-dd').format(date);
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
                        "*使用期限",
                        style: Theme
                            .of(context)
                            .textTheme
                            .body1
                            .merge(
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
                                _dateLimit,
                                style: Theme
                                    .of(context)
                                    .textTheme
                                    .body1,
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
                color: Theme
                    .of(context)
                    .backgroundColor,
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
                          "*开通票量",
                          style: Theme
                              .of(context)
                              .textTheme
                              .body1
                              .merge(
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
                              text: _invoiceCount,
                            ),
                          ),
                          textAlign: TextAlign.end,
                          decoration: new InputDecoration(
                            hintText: "请输入开通票量",
                            border: InputBorder.none,
                          ),
                          style: Theme
                              .of(context)
                              .textTheme
                              .body1,
                          onChanged: (s) {
                            _invoiceCount = s;
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
                color: Theme
                    .of(context)
                    .backgroundColor,
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
                          "备注",
                          style: Theme
                              .of(context)
                              .textTheme
                              .body1
                              .merge(
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
                              text: _memo,
                            ),
                          ),
                          textAlign: TextAlign.end,
                          decoration: new InputDecoration(
                            hintText: "请输入备注",
                            border: InputBorder.none,
                          ),
                          style: Theme
                              .of(context)
                              .textTheme
                              .body1,
                          onChanged: (s) {
                            _memo = s;
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
    if (_account == null || _account.isEmpty) {
      _key.currentState.showSnackBar(
        new SnackBar(
          content: new Text("请输入用户名"),
        ),
      );
      return;
    }

    if (_email == null || _email.isEmpty) {
      _key.currentState.showSnackBar(
        new SnackBar(
          content: new Text("请输入注册邮箱"),
        ),
      );
      return;
    }

    if (_password == null || _password.isEmpty) {
      _key.currentState.showSnackBar(
        new SnackBar(
          content: new Text("请输入密码"),
        ),
      );
      return;
    }

    if (_dateLimit == null || _dateLimit.isEmpty) {
      _key.currentState.showSnackBar(
        new SnackBar(
          content: new Text("请选择使用期限"),
        ),
      );
      return;
    }


    if (_invoiceCount == null || _invoiceCount.isEmpty) {
      _key.currentState.showSnackBar(
        new SnackBar(
          content: new Text("请输入票量"),
        ),
      );
      return;
    }

    onLoading(context);
    var rsp = await ApiService().newSupport(
      _leadId.toString(),
      SUPPORT_TYPE_DEBUG_ACCOUNT.toString(),
      account: _account,
      email: _email,
      password: _password,
      dateLimit: _dateLimit,
      invoiceCount: _invoiceCount,
      memo: _memo,
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
