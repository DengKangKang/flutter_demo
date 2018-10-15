import 'package:flutter/material.dart';
import 'package:flutter_app/data/http/ApiService.dart';
import 'package:flutter_app/data/http/rsp/data/ClientListData.dart';
import 'package:flutter_app/page/clientdetails/ClientInfoPage.dart';
import 'package:flutter_app/page/clientdetails/ClientNeed.dart';
import 'package:flutter_app/page/clientdetails/ClientSupportPage.dart';
import 'package:flutter_app/page/clientdetails/ContactsPage.dart';
import 'package:flutter_app/page/clientdetails/OperationLogPage.dart';
import 'package:flutter_app/page/clientdetails/VisitLogPage.dart';
import 'package:flutter_app/weight/DotsIndicator.dart';
import 'package:flutter_app/weight/Tool.dart';

class ClientDetailPage extends StatefulWidget {
  final Client _client;

  ClientDetailPage(this._client);

  @override
  State<StatefulWidget> createState() {
    return new ClientDetailPageState(_client);
  }
}

class ClientDetailPageState extends State<StatefulWidget> {
  final Client _client;
  String _clientName = "";

  ClientDetailPageState(this._client) {
    if (_client != null) {
      _clientName = _client.leads_name;
    }
  }

  final _controller = new PageController();

  List<Widget> _page;

  final _key = new GlobalKey<ScaffoldState>();
  final _clientInfoPageKey = new GlobalKey<ClientInfoPageState>();
  final _contactsPageKey = new GlobalKey<ContactsPageState>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (_page == null) {
      _page = new List<Widget>();
      _page.add(new ClientInfoPage(
        _client,
        key: _clientInfoPageKey,
      ));
      _page.add(new ContactsPage(
        _client,
        key: _contactsPageKey,
      ));
      _page.add(new ClientNeedPage(_client?.id));
      _page.add(new VisitLogsPage(_client?.id));
      _page.add(new ClientSupportPage(_client?.id));
      _page.add(new OperationLogPage(_client?.id));
    }
    return new Scaffold(
      key: _key,
      appBar: new AppBar(
        title: new Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            new Text(_client == null ? "新建客户" : "ID：${_client.id}"),
            new Offstage(
              offstage: _client == null || _client.is_important != 1,
              child: new Container(
                margin: EdgeInsets.only(left: 8.0),
                child: Icon(
                  Icons.star,
                  color: Colors.amber,
                ),
              ),
            ),
          ],
        ),
        actions: <Widget>[
          new IconButton(
            icon: new Icon(
              Icons.check,
              color: Colors.black,
            ),
            onPressed: () {
              _onNewOrSave(context);
            },
          )
        ],
      ),
      body: new Container(
        padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
        child: new Column(
          children: <Widget>[
            new Expanded(
              child: new Column(
                children: <Widget>[
                  TextField(
                      controller: TextEditingController.fromValue(
                        new TextEditingValue(
                          text: _clientName,
                        ),
                      ),
                      decoration: new InputDecoration(
                        hintText: "请输入客户名称",
                        border: InputBorder.none,
                      ),
                      style: Theme.of(context).textTheme.title,
                      onChanged: (s) {
                        _clientName = s;
                      }),
                  new Expanded(
                    child: new Container(
                      margin: EdgeInsets.symmetric(
                        vertical: 12.0,
                      ),
                      child: new PageView.builder(
                        physics: new BouncingScrollPhysics(),
                        controller: _controller,
                        itemCount: _page.length,
                        itemBuilder: (BuildContext context, int index) {
                          return new Card(
                            elevation: 2.0,
                            shape: new RoundedRectangleBorder(
                              borderRadius: new BorderRadius.all(
                                  new Radius.circular(4.0)),
                            ),
                            color: Theme.of(context).primaryColor,
                            child: _page[index],
                          );
                        },
                      ),
                    ),
                  ),
                  new DotsIndicator(
                    controller: _controller,
                    itemCount: _page.length,
                    onPageSelected: (int page) {
                      _controller.animateToPage(
                        page,
                        duration: Duration(milliseconds: 300),
                        curve: Curves.ease,
                      );
                    },
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _onNewOrSave(BuildContext context) async {
    if (_clientName.isEmpty) {
      _key.currentState.showSnackBar(
        new SnackBar(
          content: new Text("请输入客户名称"),
        ),
      );
      return;
    }
    if (_clientInfoPageKey.currentState.company.id == 0) {
      _key.currentState.showSnackBar(
        new SnackBar(
          content: new Text("请选择公司类型"),
        ),
      );
      return;
    }
    if (_clientInfoPageKey.currentState.industry.id == 0) {
      _key.currentState.showSnackBar(
        new SnackBar(
          content: new Text("请选择所属行业"),
        ),
      );
      return;
    }
    if (_clientInfoPageKey.currentState.source.id == 0) {
      _key.currentState.showSnackBar(
        new SnackBar(
          content: new Text("请选择来源类型"),
        ),
      );
      return;
    }
    if (_clientInfoPageKey.currentState.location.id == 0) {
      _key.currentState.showSnackBar(
        new SnackBar(
          content: new Text("请选择所在地"),
        ),
      );
      return;
    }
    if (_clientInfoPageKey.currentState.invoiceCount.isEmpty) {
      _key.currentState.showSnackBar(
        new SnackBar(
          content: new Text("请输入年发票量"),
        ),
      );
      return;
    }

    var firstPartyRepresentatives = _contactsPageKey.currentState != null
        ? _contactsPageKey.currentState.firstPartyRepresentatives
        : _client.leads_contact;

    var contactWay = _contactsPageKey.currentState != null
        ? _contactsPageKey.currentState.contactWay
        : _client.leads_mobile;

    var email = _contactsPageKey.currentState != null
        ? _contactsPageKey.currentState.email
        : _client.leads_email;

    var title = _contactsPageKey.currentState != null
        ? _contactsPageKey.currentState.title
        : _client.job_title;

    if (contactWay == null || contactWay.isEmpty) {
      _key.currentState.showSnackBar(
        new SnackBar(
          content: new Text("请输入联系方式"),
        ),
      );
      return;
    }
    if (title == null || title.isEmpty) {
      _key.currentState.showSnackBar(
        new SnackBar(
          content: new Text("请输入职务"),
        ),
      );
      return;
    }
    onLoading(context);
    var rsp = await ApiService().newOrSaveClient(
      _client?.id,
      _clientName,
      _clientInfoPageKey.currentState.company.id,
      _clientInfoPageKey.currentState.industry.id,
      _clientInfoPageKey.currentState.source.id,
      _clientInfoPageKey.currentState.location.id,
      _clientInfoPageKey.currentState.invoiceCount,
      _clientInfoPageKey.currentState.startTarget.id,
      _clientInfoPageKey.currentState.secondaryDevelopment.id,
      _clientInfoPageKey.currentState.progress.id,
      _clientInfoPageKey.currentState.expectedContractAmount,
      _clientInfoPageKey.currentState.expectedSignDate,
      _clientInfoPageKey.currentState.lnsize,
      _clientInfoPageKey.currentState.companyIntro,
      firstPartyRepresentatives,
      contactWay,
      email,
      title,
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
