import 'package:flutter/material.dart';
import 'package:flutter_app/CommonRoute.dart';
import 'package:flutter_app/bloc/Bloc.dart';
import 'package:flutter_app/bloc/ClientDetailBloc.dart';
import 'package:flutter_app/data/http/ApiService.dart';
import 'package:flutter_app/data/http/rsp/ClientNeedListRsp.dart';
import 'package:flutter_app/data/http/rsp/data/ClientNeedListData.dart';
import 'package:flutter_app/main.dart';
import 'package:flutter_app/page/clientdetails/NewNeed.dart';
import 'package:flutter_app/page/clientdetails/apply_account/client_apply_debug_account_page.dart';
import 'package:flutter_app/page/clientdetails/create_demand.dart';

import 'package:flutter_app/page/clientdetails/apply_account/client_debug_account_page.dart';

class ClientApplyPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return ClientApplyPageState();
  }
}

class ClientApplyPageState extends State with AutomaticKeepAliveClientMixin {
  ClientDetailBloc _bloc;

  @override
  void initState() {
    if (_bloc == null) _bloc = BlocProvider.of(context);
    if (_bloc.id != null) {}
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return ListView(
      physics: BouncingScrollPhysics(),
      children: <Widget>[
        Container(
          child: Material(
            color: Colors.white,
            child: InkWell(
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      '测试账号',
                      style: TextStyle(fontSize: 15),
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Text(
                          '申请中',
                          style: TextStyle(fontSize: 15),
                        ),
                        Icon(Icons.keyboard_arrow_right),
                      ],
                    ),
                  ],
                ),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  CommonRoute(
                    builder: (c) => ClientDebugAccountPage(),
                  ),
                );
              },
            ),
          ),
        ),
        Container(
          margin: EdgeInsets.only(top: 15),
          child: Material(
            color: Colors.white,
            child: InkWell(
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      '正式账号',
                      style: TextStyle(fontSize: 15),
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Text(
                          '申请',
                          style: TextStyle(fontSize: 15),
                        ),
                        Icon(Icons.keyboard_arrow_right),
                      ],
                    ),
                  ],
                ),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  CommonRoute(
                    builder: (c) => ClientApplyDebugAccountPage(),
                  ),
                );
              },
            ),
          ),
        ),
        Container(
          margin: EdgeInsets.only(top: 15),
          child: Material(
            color: Colors.white,
            child: InkWell(
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      '申请培训',
                      style: TextStyle(fontSize: 15),
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Text(
                          '申请',
                          style: TextStyle(fontSize: 15),
                        ),
                        Icon(Icons.keyboard_arrow_right),
                      ],
                    ),
                  ],
                ),
              ),
              onTap: () {},
            ),
          ),
        ),
        Divider(
          height: 1,
        ),
        _item(),
        _item(),
        _item(),
        _item(),
        _item(),
        _item(),
        _item(),
        _item(),
        _item(),
        _item(),
        _item(),
        _item(),
        _item(),
        _item(lastOne: true),
      ],
    );
  }

  Widget _item({bool lastOne = false}) {
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
                  'xxxx-xx-xx xx:xx:xx',
                  style: TextStyle(fontSize: 11, color: colorOrigin),
                ),
                Container(
                  margin: EdgeInsets.only(left: 10),
                  child: Text(
                    'xxx',
                    style: TextStyle(fontSize: 11, color: colorOrigin),
                  ),
                ),
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 5.0, bottom: 5),
            child: Text(
              'xxxxxxxx',
              style: TextStyle(fontSize: 14),
            ),
          ),
          Container(
            margin: EdgeInsets.only(bottom: 10),
            child: Text(
              'xxxxxxxxxxxxx',
              style: TextStyle(fontSize: 12),
            ),
          ),
          Opacity(
            opacity: lastOne ? 0 : 1,
            child: Divider(
              height: 1,
            ),
          ),
        ],
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
