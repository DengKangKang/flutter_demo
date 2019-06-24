import 'package:flutter/material.dart';
import 'package:flutter_app/CommonRoute.dart';
import 'package:flutter_app/bloc/Bloc.dart';
import 'package:flutter_app/bloc/ClientDetailBloc.dart';
import 'package:flutter_app/data/http/ApiService.dart';
import 'package:flutter_app/data/http/rsp/ClientNeedListRsp.dart';
import 'package:flutter_app/data/http/rsp/data/ClientNeedListData.dart';
import 'package:flutter_app/main.dart';
import 'package:flutter_app/page/clientdetails/NewNeed.dart';
import 'package:flutter_app/page/clientdetails/create_demand.dart';

class ClientNeedPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return ClientNeedPageState();
  }
}

class ClientNeedPageState extends State with AutomaticKeepAliveClientMixin {
  List<Need> _clientNeeds = [
    Need(1, 'xxxx-xx-xx', 1, 'sb', '231231231232131321'),
    Need(1, 'xxxx-xx-xx', 1, 'sb', '231231231232131321'),
    Need(1, 'xxxx-xx-xx', 1, 'sb', '231231231232131321'),
    Need(1, 'xxxx-xx-xx', 1, 'sb', '231231231232131321'),
    Need(1, 'xxxx-xx-xx', 1, 'sb', '231231231232131321'),
    Need(1, 'xxxx-xx-xx', 1, 'sb', '231231231232131321'),
    Need(1, 'xxxx-xx-xx', 1, 'sb', '231231231232131321'),
    Need(1, 'xxxx-xx-xx', 1, 'sb', '231231231232131321'),
  ];
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
    super.build(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          padding: EdgeInsets.only(bottom: 7, right: 20, left: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                "需求历史",
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                ),
              ),
              InkWell(
                child: Container(
                    margin: EdgeInsets.only(left: 5),
                    child: Row(
                      children: <Widget>[
                        Image.asset('assets/images/ico_lb_tj.png'),
                        Container(
                          margin: EdgeInsets.only(left: 5),
                          child: Text(
                            '添加需求',
                            style: TextStyle(fontSize: 15),
                          ),
                        ),
                      ],
                    )),
                onTap: () {
                  Navigator.push(
                    context,
                    CommonRoute(builder: (c) => CreateDemandPage()),
                  );
                },
              ),
            ],
          ),
        ),
        Flexible(
          child: Stack(
            children: <Widget>[
              _clientNeeds.isNotEmpty
                  ? ListView.builder(
                      physics: BouncingScrollPhysics(),
                      itemCount: _clientNeeds.length,
                      itemBuilder: (context, index) {
                        return _renderClientNeedItem(_clientNeeds[index]);
                      },
                    )
                  : Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Image.asset("assets/images/ic_empty.png"),
                          Container(
                            margin: EdgeInsets.symmetric(vertical: 12.0),
                            child: Text("暂无数据"),
                          )
                        ],
                      ),
                    ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _renderClientNeedItem(Need clientNeed) {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.symmetric(
        horizontal: 20.0,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(top: 11),
            child: Row(
              children: <Widget>[
                Text(
                  clientNeed.creator_realname,
                  style: TextStyle(fontSize: 11, color: colorOrigin),
                ),
                Container(
                  margin: EdgeInsets.only(left: 10),
                  child: Text(
                    clientNeed.create_time,
                    style: TextStyle(fontSize: 11, color: colorOrigin),
                  ),
                ),
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 5.0, bottom: 10),
            child: Text(
              clientNeed.requirement,
              style: TextStyle(fontSize: 14),
            ),
          ),
          Opacity(
            opacity: _clientNeeds.last == clientNeed ? 0 : 1,
            child: Divider(
              height: 1,
              color: Colors.grey,
            ),
          ),
        ],
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