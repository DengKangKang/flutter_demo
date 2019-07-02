import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_app/CommonRoute.dart';
import 'package:flutter_app/data/http/api_service.dart';
import 'package:flutter_app/data/http/rsp/ClientListRsp.dart';
import 'package:flutter_app/data/http/rsp/data/ClientListData.dart';
import 'package:flutter_app/data/persistence/Persistence.dart';
import 'package:flutter_app/page/ClientDetailPage.dart';
import 'package:flutter_app/page/DailyPage.dart';
import 'package:flutter_app/page/login_page.dart';
import 'package:flutter_app/page/SearchPage.dart';

class HomePage extends StatefulWidget {
  @override
  State createState() => HomePageState();
}

class HomePageState extends State<StatefulWidget> {
  final MySearchDelegate _delegate = MySearchDelegate();

  List<Client> _clients = List();
  ScrollController _scrollController = ScrollController();
  int _page = 1;

  String _username = "";
  String _userAccount = "";

  @override
  void initState() {
    Persistence().getUsername().then((username) {
      _username = username ?? '';
    });
    Persistence().getUserAccount().then((userAccount) {
      _userAccount = userAccount ?? '';
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
    return Scaffold(
      appBar: AppBar(
        title: Text("我的客户"),
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.search),
              onPressed: () async {
                var selected = await showSearch<Client>(
                  context: context,
                  delegate: _delegate,
                );
                if (selected != null) {
                  var needRefresh = await Navigator.push(
                      context,
                      CommonRoute(
                        builder: (BuildContext context) =>
                            ClientDetailPage(selected),
                      ));
                  if (needRefresh == true) {
                    await _initData();
                  }
                }
              })
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () async {
          var needRefresh = await Navigator.push(
              context,
              CommonRoute(
                builder: (BuildContext context) => ClientDetailPage(null),
              ));
          if (needRefresh == true) {
            await _initData();
          }
        },
      ),
      drawer: Drawer(
        child: Container(
          margin: EdgeInsets.only(
            bottom: 12.0,
            top: 36.0,
          ),
          child: Column(
            children: <Widget>[
              Flexible(
                child: Column(
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.only(
                          right: 16.0, left: 16.0, bottom: 24.0),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        children: <Widget>[
                          Image.asset("assets/images/ic_head_big.png"),
                          Container(
                            margin: EdgeInsets.symmetric(horizontal: 12.0),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(_username),
                                Text(_userAccount),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    ListTile(
                      leading: Image.asset("assets/images/rili.png"),
                      title: Text("日报"),
                      onTap: () {
                        Navigator.push(
                            context,
                            CommonRoute(
                              builder: (BuildContext context) => DailyPage(),
                            ));
                      },
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: Icon(Icons.power_settings_new),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                          title: Text("提示"),
                          content: Text("是否确认退出"),
                          actions: <Widget>[
                            FlatButton(
                              child: Text('取消'),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                            FlatButton(
                              child: Text('确定'),
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
    Persistence().setToken("").then((value) {
      Navigator.pushReplacement(
          context,
          CommonRoute(
            builder: (BuildContext context) => LoginPage(),
          ));
    });
  }

  Widget _buildSuggestions() {
    return RefreshIndicator(
      child: ListView.builder(
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
    var content = List<Widget>();
    content.add(
      Flexible(
        child: Text(
          client.leads_name,
          style: TextStyle(
            color: Colors.black,
            fontSize: 16.0,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
    if (client.is_important == 1) {
      content.add(Container(
        margin: EdgeInsets.only(left: 16.0),
        child: Icon(
          Icons.star,
          color: Colors.amber,
        ),
      ));
    }
    return Container(
      margin: EdgeInsets.only(
        left: 16.0,
        right: 16.0,
        top: 12.0,
        bottom: index == _clients.length - 1 ? 12.0 : 0.0,
      ),
      child: RawMaterialButton(
        fillColor: Theme.of(context).primaryColor,
        padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(4.0)),
        ),
        onPressed: () async {
          var needRefresh = await Navigator.push(
              context,
              CommonRoute(
                builder: (BuildContext context) => ClientDetailPage(client),
              ));
          if (needRefresh == true) {
            await _initData();
          }
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: content,
        ),
      ),
    );
  }

  void _loadMore() {
    ApiService().clientList((_page + 1).toString(), "20", "").then(
      (rsp) {
        if (rsp.code == ApiService.success) {
          var clientListRsp = rsp as ClientListRsp;
          if (clientListRsp?.data?.rows != null &&
              clientListRsp?.data?.rows?.isNotEmpty == true) {
            _clients.addAll(clientListRsp.data.rows);
            setState(() {
              _page = (_page + 1);
              _clients = _clients;
            });
          }
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
