import 'package:flutter/material.dart';
import 'package:flutter_app/CommonRoute.dart';
import 'package:flutter_app/data/http/ApiService.dart';
import 'package:flutter_app/data/http/rsp/ClientNeedListRsp.dart';
import 'package:flutter_app/data/http/rsp/data/ClientNeedListData.dart';
import 'package:flutter_app/page/clientdetails/NewNeed.dart';

class ClientNeedPage extends StatefulWidget {
  final int _leadId;

  ClientNeedPage(this._leadId);

  State<StatefulWidget> createState() {
    return ClientNeedPageState(_leadId);
  }
}

class ClientNeedPageState extends State with AutomaticKeepAliveClientMixin {
  final int _leadId;

  List<Need> _clientNeeds = new List();

  ClientNeedPageState(this._leadId);

  @override
  void initState() {
    if (_leadId != null) {
      _initData();
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return new Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        new Container(
          padding: EdgeInsets.only(top: 12.0, right: 16.0, left: 16.0),
          child: new Text("客户需求"),
        ),
        new Flexible(
          child: new Stack(
            children: <Widget>[
              _clientNeeds.isNotEmpty
                  ? new Container(
                      margin: EdgeInsets.only(
                        top: 12.0,
                        bottom: 12.0,
                        right: 12.0,
                        left: 12.0,
                      ),
                      child: new ListView.builder(
                        physics: new BouncingScrollPhysics(),
                        itemCount: _clientNeeds.length,
                        itemBuilder: (context, index) {
                          return _renderClientNeedItem(_clientNeeds[index]);
                        },
                      ),
                    )
                  : new Center(
                      child: new Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Image.asset("assets/images/ic_empty.png"),
                          Container(
                            margin: EdgeInsets.symmetric(vertical: 12.0),
                            child: Text(_leadId == null ? "新建商机无法添加" : "暂无数据"),
                          )
                        ],
                      ),
                      ),
            ],
          ),
        ),
        new Center(
          child: new Container(
            padding: EdgeInsets.only(
              bottom: 12.0,
              right: 16.0,
              left: 16.0,
            ),
            child: new InkWell(
              child: new Text(
                '新增需求',
                style: Theme.of(context).textTheme.body1.merge(TextStyle(
                      color: _leadId != null ? Colors.blue : Colors.grey,
                    )),
              ),
              onTap: _leadId != null
                  ? () async {
                      var needRefresh = await Navigator.push(
                          context,
                          new CommonRoute(
                            builder: (BuildContext context) =>
                                new NewNeed(_leadId),
                          ));
                      if (needRefresh == true) {
                        _initData();
                      }
                    }
                  : null,
            ),
          ),
        ),
      ],
    );
  }

  Widget _renderClientNeedItem(Need clientNeed) {
    return Card(
      elevation: 2.0,
      child: new Container(
        padding: EdgeInsets.symmetric(
          vertical: 12.0,
          horizontal: 16.0,
        ),
        child: new Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            new Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                new Text(
                  clientNeed.creator_realname,
                  style: Theme.of(context)
                      .textTheme
                      .body1
                      .merge(TextStyle(color: Colors.grey)),
                ),
                new Text(
                  clientNeed.create_time,
                  style: Theme.of(context)
                      .textTheme
                      .body1
                      .merge(TextStyle(color: Colors.grey)),
                ),
              ],
            ),
            new Container(
              margin: EdgeInsets.only(top: 12.0),
              child: new Text(
                clientNeed.requirement,
                style: Theme.of(context).textTheme.body1,
              ),
            )
          ],
        ),
      ),
    );
  }

  void _initData() {
    ApiService().clientNeedList(_leadId.toString()).then(
      (rsp) {
        if (rsp.code == ApiService.success) {
          var clientNeedListRsp = rsp as ClientNeedListRsp;
          setState(() {
            _clientNeeds = clientNeedListRsp.data.list;
          });
        }
      },
    );
  }

  @override
  bool get wantKeepAlive => true;
}
