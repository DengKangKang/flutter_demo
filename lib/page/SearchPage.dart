import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_app/data/http/ApiService.dart';
import 'package:flutter_app/data/http/rsp/ClientListRsp.dart';
import 'package:flutter_app/data/http/rsp/data/ClientListData.dart';

// Copyright 2018 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

class MySearchDelegate extends SearchDelegate<Client> {
  MySearchDelegate() {
    _result = _ResultList(
      query,
      this,
      key: _key,
    );
  }

  GlobalKey<__ResultListState> _key = GlobalKey();
  Widget _result;

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      tooltip: 'Back',
      icon: AnimatedIcon(
        icon: AnimatedIcons.menu_arrow,
        progress: transitionAnimation,
      ),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    if (_key.currentState != null) {
      _key.currentState.query = query;
      _key.currentState.initData();
    }
    return _result;
  }

  @override
  Widget buildResults(BuildContext context) {
    if (_key.currentState != null) {
      _key.currentState.query = query;
      _key.currentState.initData();
    }
    return _result;
  }

  @override
  List<Widget> buildActions(BuildContext context) {
    return <Widget>[
      Offstage(
        offstage: query.isEmpty,
        child: IconButton(
          tooltip: 'Clear',
          icon: const Icon(Icons.clear),
          onPressed: () {
            query = '';
            showSuggestions(context);
          },
        ),
      )
    ];
  }
}

class _ResultList extends StatefulWidget {
  const _ResultList(
    this.query,
    this.delegate, {
    Key key,
  }) : super(key: key);

  final String query;
  final SearchDelegate delegate;

  @override
  State<StatefulWidget> createState() {
    return __ResultListState(query, delegate);
  }
}

class __ResultListState extends State<_ResultList> {
  __ResultListState(this.query, this.delegate);

  String query;
  final SearchDelegate delegate;

  List<Client> _clients = List();
  ScrollController _scrollController = ScrollController();
  int _page = 1;

  @override
  void initState() {
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        _loadMore();
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        physics: AlwaysScrollableScrollPhysics(),
        controller: _scrollController,
        itemCount: _clients.length,
        itemBuilder: (context, i) {
          return _buildClient(i, context);
        });
  }

  Widget _buildClient(int index, BuildContext context) {
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
        fillColor: Theme.of(context).splashColor,
        padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(4.0)),
        ),
        onPressed: () {
          delegate.close(context, client);
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: content,
        ),
      ),
    );
  }

  void _loadMore() {
    ApiService().clientList((_page + 1).toString(), "15", query).then(
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

  Future<void> initData() {
    return ApiService().clientList("1", "15", query).then(
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
