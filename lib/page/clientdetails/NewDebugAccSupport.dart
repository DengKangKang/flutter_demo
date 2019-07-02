import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app/data/Constant.dart';
import 'package:flutter_app/data/http/api_service.dart';
import 'package:flutter_app/weight/Tool.dart';
import 'package:intl/intl.dart';
import 'package:email_validator/email_validator.dart';

class NewDebugAccSupport extends StatefulWidget {
  NewDebugAccSupport(this._leadId, {Key key}) : super(key: key);

  final int _leadId;

  @override
  State<StatefulWidget> createState() {
    return NewDebugAccSupportState(_leadId);
  }
}

class NewDebugAccSupportState extends State<StatefulWidget> {
  NewDebugAccSupportState(this._leadId);

  final int _leadId;
  final _key = GlobalKey<ScaffoldState>();

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
    return Scaffold(
      key: _key,
      appBar: AppBar(
        title: Text("新增测试账号"),
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
                              "*用户名",
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
                                  text: _account,
                                ),
                              ),
                              textAlign: TextAlign.end,
                              decoration: InputDecoration(
                                hintText: "请输入用户名",
                                border: InputBorder.none,
                              ),
                              style: Theme.of(context).textTheme.body1,
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
                              "*注册邮箱",
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
                                  text: _email,
                                ),
                              ),
                              textAlign: TextAlign.end,
                              decoration: InputDecoration(
                                hintText: "请输入注册邮箱",
                                border: InputBorder.none,
                              ),
                              style: Theme.of(context).textTheme.body1,
                              keyboardType: TextInputType.emailAddress,
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
                              "*初始密码",
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
                                  text: _password,
                                ),
                              ),
                              textAlign: TextAlign.end,
                              decoration: InputDecoration(
                                hintText: "请输入初始密码",
                                border: InputBorder.none,
                              ),
                              style: Theme.of(context).textTheme.body1,
                              keyboardType: TextInputType.emailAddress,
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
                          _dateLimit = DateFormat('yyyy-MM-dd').format(date);
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
                            "*使用期限",
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
                                _dateLimit.isEmpty ? "请选择使用期限" : _dateLimit,
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
                              "*开通票量",
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
                                  text: _invoiceCount,
                                ),
                              ),
                              textAlign: TextAlign.end,
                              decoration: InputDecoration(
                                hintText: "请输入开通票量",
                                border: InputBorder.none,
                              ),
                              style: Theme.of(context).textTheme.body1,
                              onChanged: (s) {
                                _invoiceCount = s;
                              },
                              inputFormatters: [
                                WhitelistingTextInputFormatter.digitsOnly
                              ],
                              keyboardType: TextInputType.number,
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
                              "备注",
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
                                  text: _memo,
                                ),
                              ),
                              textAlign: TextAlign.end,
                              decoration: InputDecoration(
                                hintText: "请输入备注内容",
                                border: InputBorder.none,
                              ),
                              style: Theme.of(context).textTheme.body1,
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
        SnackBar(
          content: Text("请输入用户名"),
        ),
      );
      return;
    }

    if (_email == null || _email.isEmpty) {
      _key.currentState.showSnackBar(
        SnackBar(
          content: Text("请输入注册邮箱"),
        ),
      );
      return;
    }

    if (!EmailValidator.validate(_email)) {
      _key.currentState.showSnackBar(
        SnackBar(
          content: Text("邮箱格式不正确"),
        ),
      );
      return;
    }

    if (_password == null || _password.isEmpty) {
      _key.currentState.showSnackBar(
        SnackBar(
          content: Text("请输入密码"),
        ),
      );
      return;
    }

    if (_dateLimit == null || _dateLimit.isEmpty) {
      _key.currentState.showSnackBar(
        SnackBar(
          content: Text("请选择使用期限"),
        ),
      );
      return;
    }

    if (_invoiceCount == null || _invoiceCount.isEmpty) {
      _key.currentState.showSnackBar(
        SnackBar(
          content: Text("请输入票量"),
        ),
      );
      return;
    }

    onLoading(context);
    var rsp = await ApiService().newSupport(
      _leadId.toString(),
      supportTypeDebugAccount.toString(),
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
        SnackBar(
          content: Text(rsp.msg),
        ),
      );
    }
  }
}
