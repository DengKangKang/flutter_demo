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

class NewHardWareSupport extends StatefulWidget {
  NewHardWareSupport(this._leadId, {Key key}) : super(key: key);

  final int _leadId;

  @override
  State<StatefulWidget> createState() {
    return new NewHardWareSupportState(_leadId);
  }
}

class NewHardWareSupportState extends State<StatefulWidget> {
  NewHardWareSupportState(this._leadId);

  final int _leadId;
  final _key = new GlobalKey<ScaffoldState>();

  RadioBean _deviceName = devices[0];
  RadioBean _usageModel = usageModel[0];

  String _count = "";
  String _price = "";
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
        title: new Text("新增硬件申请"),
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
                      var responsibilities = await showDialog(
                        context: context,
                        builder: (context) {
                          return RadioListPage.responsibilities(
                              groupValue: _deviceName);
                        },
                      );
                      if (responsibilities != null) {
                        setState(() {
                          _deviceName = responsibilities;
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
                            "*设备名称",
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
                                _deviceName.name,
                                style: Theme.of(context).textTheme.body1.merge(
                                    new TextStyle(
                                        color: _deviceName.id == 0
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
                  child: new RawMaterialButton(
                    elevation: 2.0,
                    fillColor: Theme.of(context).backgroundColor,
                    padding: new EdgeInsets.symmetric(horizontal: 16.0),
                    shape: new RoundedRectangleBorder(
                      borderRadius:
                          new BorderRadius.all(new Radius.circular(4.0)),
                    ),
                    onPressed: () async {
                      var responsibilities = await showDialog(
                        context: context,
                        builder: (context) {
                          return RadioListPage.usageModel(
                              groupValue: _usageModel);
                        },
                      );
                      if (responsibilities != null) {
                        setState(() {
                          _usageModel = responsibilities;
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
                            "*购买/押金",
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
                                _usageModel.name,
                                style: Theme.of(context).textTheme.body1.merge(
                                    new TextStyle(
                                        color: _usageModel.id == 0
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
                              "*数量",
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
                                  text: _count,
                                ),
                              ),
                              textAlign: TextAlign.end,
                              decoration: new InputDecoration(
                                hintText: "请输入数量",
                                border: InputBorder.none,
                              ),
                              style: Theme.of(context).textTheme.body1,
                              onChanged: (s) {
                                _count = s;
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
                              "*价格",
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
                                  text: _price,
                                ),
                              ),
                              textAlign: TextAlign.end,
                              decoration: new InputDecoration(
                                hintText: "请输入价格",
                                border: InputBorder.none,
                              ),
                              style: Theme.of(context).textTheme.body1,
                              onChanged: (s) {
                                _price = s;
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
                              "*备注",
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
                                  text: _memo,
                                ),
                              ),
                              textAlign: TextAlign.end,
                              decoration: new InputDecoration(
                                hintText: "请输入备注",
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
    if (_deviceName.id == 0) {
      _key.currentState.showSnackBar(
        new SnackBar(
          content: new Text("请选择设备名称"),
        ),
      );
      return;
    }

    if (_usageModel == null || _usageModel.id == 0) {
      _key.currentState.showSnackBar(
        new SnackBar(
          content: new Text("请选择购买/押金"),
        ),
      );
      return;
    }

    if (_count == null || _count.isEmpty) {
      _key.currentState.showSnackBar(
        new SnackBar(
          content: new Text("请输入数量"),
        ),
      );
      return;
    }

    if (_price == null || _price.isEmpty) {
      _key.currentState.showSnackBar(
        new SnackBar(
          content: new Text("请输入价格"),
        ),
      );
      return;
    }

    onLoading(context);
    var rsp = await ApiService().newSupport(
      _leadId.toString(),
      SUPPORT_TYPE_HARDWARE.toString(),
      deviceName: _deviceName.id.toString(),
      usageModel: _usageModel.id.toString(),
      count: _count,
      price: _price,
      memoDevice: _memo,
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
