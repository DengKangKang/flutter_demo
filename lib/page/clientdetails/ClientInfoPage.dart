import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app/data/http/rsp/data/ClientListData.dart';
import 'package:flutter_app/data/http/rsp/data/RadioBean.dart';
import 'package:flutter_app/page/RadioListPage.dart';
import 'package:intl/intl.dart';

class ClientInfoPage extends StatefulWidget {
  final Client _client;

  ClientInfoPage(
    this._client, {
    Key key,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return new ClientInfoPageState(_client);
  }
}

class ClientInfoPageState extends State<ClientInfoPage>
    with AutomaticKeepAliveClientMixin<ClientInfoPage> {
  final Client _client;

  RadioBean _company = companyTypes[0];
  RadioBean _industry = industries[0];
  RadioBean _source = sourceTypes[0];
  RadioBean _location = locations[0];

  var _invoiceCountController = TextEditingController.fromValue(
    new TextEditingValue(
      text: "",
    ),
  );

  String _invoiceCountError = "";

  RadioBean _startTarget = booleans[0];
  RadioBean _secondaryDevelopment = booleans[0];
  RadioBean _progress = progresses[0];
  String _expectedContractAmount = "";
  String _expectedSignDate = "";
  String _lnsize = "";
  String _companyIntro = "";

  ClientInfoPageState(this._client) {
    if (_client != null) {
      if (_client.company_type != null)
        _company = companyTypes.firstWhere((e) => e.id == _client.company_type);

      if (_client.industry != null)
        _industry = industries.firstWhere((e) => e.id == _client.industry);

      if (_client.source_id != null)
        _source = sourceTypes.firstWhere((e) => e.id == _client.source_id);

      if (_client.location != null)
        _location = locations.firstWhere((e) => e.id == _client.location);

      if (_client.annual_invoice != null)
        _invoiceCountController.text = _client.annual_invoice.toString();

      if (_client.is_important != null)
        _startTarget = booleans.firstWhere((e) => e.id == _client.is_important);

      if (_client.on_premise != null)
        _secondaryDevelopment =
            booleans.firstWhere((e) => e.id == _client.on_premise);

      if (_client.progress_percent != null)
        _progress =
            progresses.firstWhere((e) => e.id == _client.progress_percent);

      if (_client.anticipated_amount != null)
        _expectedContractAmount = _client.anticipated_amount;

      if (_client.anticipated_date != null)
        _expectedSignDate = _client.anticipated_date;

      if (_client.company_size != null) _lnsize = _client.company_size;

      if (_client.memo != null) _companyIntro = _client.memo;
    }
  }

  @override
  Widget build(BuildContext context) {
    return new Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        new Container(
          padding: EdgeInsets.only(top: 12.0, right: 16.0, left: 16.0),
          child: new Text("客户信息"),
        ),
        new Flexible(
          child: new Container(
            margin: EdgeInsets.only(
              top: 12.0,
              bottom: 12.0,
              right: 12.0,
              left: 12.0,
            ),
            child: new ListView(
              physics: new BouncingScrollPhysics(),
              children: <Widget>[
                new Container(
                  margin: EdgeInsets.only(
                    right: 4.0,
                    left: 4.0,
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
                      var company = await showDialog(
                        context: context,
                        builder: (context) {
                          return RadioListPage.companyType(
                              groupValue: _company);
                        },
                      );
                      if (company != null) {
                        setState(() {
                          _company = company;
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
                            "*公司类型",
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
                                _company.name,
                                style: Theme.of(context).textTheme.body1.merge(
                                    new TextStyle(
                                        color: _company.id == 0
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
                    right: 4.0,
                    left: 4.0,
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
                      var industry = await showDialog(
                        context: context,
                        builder: (context) {
                          return RadioListPage.industry(groupValue: _industry);
                        },
                      );
                      if (industry != null) {
                        setState(() {
                          _industry = industry;
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
                            "*所属行业",
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
                                _industry.name,
                                style: Theme.of(context).textTheme.body1.merge(
                                    new TextStyle(
                                        color: _industry.id == 0
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
                    right: 4.0,
                    left: 4.0,
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
                      var industry = await showDialog(
                        context: context,
                        builder: (context) {
                          return RadioListPage.sourceType(groupValue: _source);
                        },
                      );
                      if (industry != null) {
                        setState(() {
                          _source = industry;
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
                            "*来源类型",
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
                                _source.name,
                                style: Theme.of(context).textTheme.body1.merge(
                                    new TextStyle(
                                        color: _source.id == 0
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
                    right: 4.0,
                    left: 4.0,
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
                      var location = await showDialog(
                        context: context,
                        builder: (context) {
                          return RadioListPage.location(groupValue: _company);
                        },
                      );
                      if (location != null) {
                        setState(() {
                          _location = location;
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
                            "*所在地",
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
                                _location.name,
                                style: Theme.of(context).textTheme.body1.merge(
                                    new TextStyle(
                                        color: _location.id == 0
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
                    right: 4.0,
                    left: 4.0,
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
                              "*年发票量",
                              style: Theme.of(context).textTheme.body1.merge(
                                    TextStyle(
                                      color: Colors.grey,
                                    ),
                                  ),
                            ),
                          ),
                          new Flexible(
                            child: TextField(
                              controller: _invoiceCountController,
                              textAlign: TextAlign.end,
                              decoration: new InputDecoration(
                                hintText: "请输入企业年度发票量",
                                border: InputBorder.none,
                              ),
                              style: Theme.of(context).textTheme.body1,
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
                new Container(
                  margin: EdgeInsets.only(
                    top: 12.0,
                    right: 4.0,
                    left: 4.0,
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
                      var secondaryDevelopment = await showDialog(
                        context: context,
                        builder: (context) {
                          return RadioListPage.boolean(
                            groupValue: _startTarget,
                          );
                        },
                      );
                      if (secondaryDevelopment != null) {
                        setState(() {
                          _startTarget = secondaryDevelopment;
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
                            "是否为重点",
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
                                _startTarget.name,
                                style: Theme.of(context).textTheme.body1.merge(
                                    new TextStyle(
                                        color: _startTarget.id == 0
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
                    right: 4.0,
                    left: 4.0,
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
                      var secondaryDevelopment = await showDialog(
                        context: context,
                        builder: (context) {
                          return RadioListPage.boolean(
                            groupValue: _secondaryDevelopment,
                          );
                        },
                      );
                      if (secondaryDevelopment != null) {
                        setState(() {
                          _secondaryDevelopment = secondaryDevelopment;
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
                            "是否为二次开发",
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
                                _secondaryDevelopment.name,
                                style: Theme.of(context).textTheme.body1.merge(
                                    new TextStyle(
                                        color: _secondaryDevelopment.id == 0
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
                    right: 4.0,
                    left: 4.0,
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
                      var progress = await showDialog(
                        context: context,
                        builder: (context) {
                          return RadioListPage.progress(groupValue: _progress);
                        },
                      );
                      if (progress != null) {
                        setState(() {
                          _progress = progress;
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
                            "执行比例",
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
                                _progress.name,
                                style: Theme.of(context).textTheme.body1.merge(
                                    new TextStyle(
                                        color: _progress.id == 0
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
                    right: 4.0,
                    left: 4.0,
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
                              "预计签约额",
                              style: Theme.of(context).textTheme.body1.merge(
                                    TextStyle(
                                      color: Colors.grey,
                                    ),
                                  ),
                            ),
                          ),
                          new Flexible(
                            child: TextField(
                              keyboardType: TextInputType.number,
                              controller: TextEditingController.fromValue(
                                new TextEditingValue(
                                  text: _expectedContractAmount,
                                ),
                              ),
                              textAlign: TextAlign.end,
                              decoration: new InputDecoration(
                                hintText: "请输入预计签约额",
                                border: InputBorder.none,
                              ),
                              style: Theme.of(context).textTheme.body1,
                              onChanged: (s) {
                                _expectedContractAmount = s;
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
                    right: 4.0,
                    left: 4.0,
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
                          _expectedSignDate =
                              new DateFormat('yyyy-MM-dd').format(date);
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
                            "预计签约日",
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
                                _expectedSignDate.isEmpty
                                    ? "请选择预计签约日"
                                    : _expectedSignDate,
                                style: Theme.of(context)
                                    .textTheme
                                    .body1
                                    .merge(new TextStyle(color: Colors.grey)),
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
                    right: 4.0,
                    left: 4.0,
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
                              "公司规模",
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
                                  text: _lnsize,
                                ),
                              ),
                              textAlign: TextAlign.end,
                              decoration: new InputDecoration(
                                hintText: "请输入公司规模",
                                border: InputBorder.none,
                              ),
                              style: Theme.of(context).textTheme.body1,
                              onChanged: (s) {
                                _lnsize = s;
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
                      top: 12.0, right: 4.0, left: 4.0, bottom: 4.0),
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
                              "公司简介",
                              style: Theme.of(context).textTheme.body1.merge(
                                    TextStyle(
                                      color: Colors.grey,
                                    ),
                                  ),
                            ),
                          ),
                          new Flexible(
                            child: TextField(
                              keyboardType: TextInputType.multiline,
                              maxLengthEnforced: true,
                              maxLines: null,
                              controller: TextEditingController.fromValue(
                                new TextEditingValue(
                                  text: _companyIntro,
                                ),
                              ),
                              textAlign: TextAlign.end,
                              decoration: new InputDecoration(
                                hintText: "请输入公司简介",
                                border: InputBorder.none,
                              ),
                              style: Theme.of(context)
                                  .textTheme
                                  .body1
                                  .merge(new TextStyle()),
                              onChanged: (s) {
                                _companyIntro = s;
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
        )
      ],
    );
  }

  String get companyIntro => _companyIntro;

  String get lnsize => _lnsize;

  String get expectedSignDate => _expectedSignDate;

  String get expectedContractAmount => _expectedContractAmount;

  RadioBean get progress => _progress;

  RadioBean get secondaryDevelopment => _secondaryDevelopment;

  RadioBean get startTarget => _startTarget;

  String get invoiceCount => _invoiceCountController.text;

  RadioBean get location => _location;

  RadioBean get source => _source;

  RadioBean get industry => _industry;

  RadioBean get company => _company;

  @override
  bool get wantKeepAlive => true;
}
