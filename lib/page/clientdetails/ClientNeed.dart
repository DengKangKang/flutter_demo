import 'package:flutter/material.dart';
import 'package:flutter_app/CommonRoute.dart';
import 'package:flutter_app/bloc/Bloc.dart';
import 'package:flutter_app/bloc/ClientDetailBloc.dart';
import 'package:flutter_app/data/http/api_service.dart';
import 'package:flutter_app/data/http/rsp/ClientNeedListRsp.dart';
import 'package:flutter_app/data/http/rsp/data/ClientNeedListData.dart';
import 'package:flutter_app/page/clientdetails/NewNeed.dart';

class ClientNeedPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return ClientNeedPageState();
  }
}

class ClientNeedPageState extends State with AutomaticKeepAliveClientMixin {
  List<Need> _clientNeeds = List();
  ClientDetailBloc _bloc;

  @override
  void initState() {
    if (_bloc == null) _bloc = BlocProvider.of(context);
    if (_bloc.id != null) {
      _initData();
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          padding: EdgeInsets.only(top: 12.0, right: 16.0, left: 16.0),
          child: Text("客户需求"),
        ),
        Flexible(
          child: Stack(
            children: <Widget>[
              _clientNeeds.isNotEmpty
                  ? Container(
                      margin: EdgeInsets.only(
                        top: 12.0,
                        bottom: 12.0,
                        right: 12.0,
                        left: 12.0,
                      ),
                      child: ListView.builder(
                        physics: BouncingScrollPhysics(),
                        itemCount: _clientNeeds.length,
                        itemBuilder: (context, index) {
                          return _renderClientNeedItem(_clientNeeds[index]);
                        },
                      ),
                    )
                  : Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Image.asset("assets/images/ic_empty.png"),
                          Container(
                            margin: EdgeInsets.symmetric(vertical: 12.0),
                            child: Text(_bloc.id == null ? "新建商机无法添加" : "暂无数据"),
                          )
                        ],
                      ),
                    ),
            ],
          ),
        ),
        Center(
          child: Container(
            padding: EdgeInsets.only(
              bottom: 12.0,
              right: 16.0,
              left: 16.0,
            ),
            child: InkWell(
              child: Text(
                '新增需求',
                style: Theme.of(context).textTheme.body1.merge(TextStyle(
                      color: _bloc.id != null ? Colors.blue : Colors.grey,
                    )),
              ),
              onTap: _bloc.id != null
                  ? () async {
                      var needRefresh = await Navigator.push(
                          context,
                          CommonRoute(
                            builder: (BuildContext context) =>
                                NewNeed(_bloc.id),
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
      child: Container(
        padding: EdgeInsets.symmetric(
          vertical: 12.0,
          horizontal: 16.0,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  clientNeed.creator_realname,
                  style: Theme.of(context)
                      .textTheme
                      .body1
                      .merge(TextStyle(color: Colors.grey)),
                ),
                Text(
                  clientNeed.create_time,
                  style: Theme.of(context)
                      .textTheme
                      .body1
                      .merge(TextStyle(color: Colors.grey)),
                ),
              ],
            ),
            Container(
              margin: EdgeInsets.only(top: 12.0),
              child: Text(
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
    ApiService().clientNeedList(_bloc.id.toString()).then(
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
