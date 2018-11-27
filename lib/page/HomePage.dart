import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_app/CommonRoute.dart';
import 'package:flutter_app/data/http/ApiService.dart';
import 'package:flutter_app/data/http/rsp/ClientListRsp.dart';
import 'package:flutter_app/data/http/rsp/data/ClientListData.dart';
import 'package:flutter_app/data/persistence/Persistence.dart';
import 'package:flutter_app/page/ClientDetailPage.dart';
import 'package:flutter_app/page/DailyPage.dart';
import 'package:flutter_app/page/LoginPage.dart';
import 'package:flutter_app/page/SearchPage.dart';

class HomePage extends StatefulWidget {
  @override
  createState() => new HomePageState();
}

class HomePageState extends State<StatefulWidget> {
  final MySearchDelegate _delegate = MySearchDelegate();

  List<Client> _clients = new List();
  ScrollController _scrollController = new ScrollController();
  int _page = 1;

  String _username = "";
  String _userAccount = "";

  @override
  void initState() {
    new Persistence().getUsername().then((username) {
      _username = username;
    });
    new Persistence().getUserAccount().then((userAccount) {
      _userAccount = userAccount;
    });
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        print("loadMore");
        _loadMore();
      }
    });
    _initData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("我的客户"),
        actions: <Widget>[
          new IconButton(
              icon: new Icon(Icons.search),
              onPressed: () async {
                var selected = await showSearch<Client>(
                  context: context,
                  delegate: _delegate,
                );
                if (selected != null) {
                  var needRefresh = await Navigator.push(
                      context,
                      new CommonRoute(
                        builder: (BuildContext context) =>
                            new ClientDetailPage(selected),
                      ));
                  if (needRefresh == true) {
                    _initData();
                  }
                }
              })
        ],
      ),
      floatingActionButton: new FloatingActionButton(
        child: new Icon(Icons.add),
        onPressed: () async {
          var needRefresh = await Navigator.push(
              context,
              new CommonRoute(
                builder: (BuildContext context) => new ClientDetailPage(null),
              ));
          if (needRefresh == true) {
            _initData();
          }
        },
      ),
      drawer: new Drawer(
        child: new Container(
          margin: new EdgeInsets.only(
            bottom: 12.0,
            top: 36.0,
          ),
          child: new Column(
            children: <Widget>[
              new Flexible(
                child: new Column(
                  children: <Widget>[
                    new Container(
                      margin: EdgeInsets.only(right: 16.0,left: 16.0,bottom: 24.0),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        children: <Widget>[
                          Image.asset("assets/images/ic_head_big.png"),
                          new Container(
                            margin: EdgeInsets.symmetric(horizontal: 12.0),
                            child: new Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                new Text(_username),
                                new Text(_userAccount),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    new ListTile(
                      leading: new Icon(Icons.note),
                      title: new Text("日报"),
                      onTap: (){
                        Navigator.push(
                            context,
                            new CommonRoute(
                              builder: (BuildContext context) =>
                              new DailyPage(),
                            ));
                      },
                    ),
                  ],
                ),
              ),
              new IconButton(
                icon: new Icon(Icons.power_settings_new),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) => new AlertDialog(
                          title: new Text("提示"),
                          content: new Text("是否确认退出"),
                          actions: <Widget>[
                            new FlatButton(
                              child: new Text('取消'),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                            new FlatButton(
                              child: new Text('确定'),
                              onPressed: () {
                                _onLogout(context);
                              },
                            ),
                          ],
                        ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
      body: _buildSuggestions(),
    );
  }

  void _onLogout(BuildContext context) {
    Navigator.of(context).pop();
    new Persistence().setToken("").then((value) {
      Navigator.pushReplacement(
          context,
          new CommonRoute(
            builder: (BuildContext context) => new LoginPage(),
          ));
    });
  }

  Widget _buildSuggestions() {
    return new RefreshIndicator(
      child: new ListView.builder(
          physics: AlwaysScrollableScrollPhysics(),
          controller: _scrollController,
          itemCount: _clients.length,
          itemBuilder: (context, i) {
            return _buildClient(i);
          }),
      onRefresh: _initData,
    );
  }

  Widget _buildClient(int index) {
    var client = _clients[index];
    var content = new List<Widget>();
    content.add(
      new Flexible(
        child: new Text(
          client.leads_name,
          style: new TextStyle(
            color: Colors.black,
            fontSize: 16.0,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
    if (client.is_important == 1) {
      content.add(new Container(
        margin: EdgeInsets.only(left: 16.0),
        child: new Icon(
          Icons.star,
          color: Colors.amber,
        ),
      ));
    }
    return new Container(
      margin: new EdgeInsets.only(
        left: 16.0,
        right: 16.0,
        top: 12.0,
        bottom: index == _clients.length - 1 ? 12.0 : 0.0,
      ),
      child: new RawMaterialButton(
        fillColor: Theme.of(context).primaryColor,
        padding: new EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
        shape: new RoundedRectangleBorder(
          borderRadius: new BorderRadius.all(new Radius.circular(4.0)),
        ),
        onPressed: () async {
          var needRefresh = await Navigator.push(
              context,
              new CommonRoute(
                builder: (BuildContext context) => new ClientDetailPage(client),
              ));
          if (needRefresh == true) {
            _initData();
          }
        },
        child: new Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: content,
        ),
      ),
    );
  }

  void _loadMore() {
    _page += 1;
    ApiService().clientList((_page + 1).toString(), "15", "").then(
      (rsp) {
        if (rsp.code == ApiService.success) {
          var clientListRsp = rsp as ClientListRsp;
          _clients.addAll(clientListRsp.data.rows);
          setState(() {
            _page = (_page + 1);
            _clients = _clients;
          });
        }
      },
    );
  }

  Future<void> _initData() {
    return ApiService().clientList("1", "15", "").then(
      (rsp) {
        if (rsp.code == ApiService.success) {
          if (_clients.isNotEmpty) {
            _clients.clear();
          }
          var clientListRsp = rsp as ClientListRsp;
          setState(() {
            _page = 1;
            _clients = clientListRsp.data.rows;
          });
        }
      },
    );
  }
}
