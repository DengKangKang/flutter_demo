import 'package:flutter/material.dart';
import 'package:flutter_app/CommonRoute.dart';
import 'package:flutter_app/bloc/Bloc.dart';
import 'package:flutter_app/bloc/ClientDetailBloc.dart';
import 'package:flutter_app/data/Constant.dart';
import 'package:flutter_app/data/http/ApiService.dart';
import 'package:flutter_app/data/http/rsp/VisitLogsRsp.dart';
import 'package:flutter_app/data/http/rsp/data/RadioBean.dart';
import 'package:flutter_app/data/http/rsp/data/VisitLogsData.dart';
import 'package:flutter_app/page/RadioListPage.dart';
import 'package:flutter_app/page/clientdetails/NewPlainVisit.dart';
import 'package:flutter_app/page/clientdetails/NewSpecialVisit.dart';

import '../../main.dart';
import 'create_demand.dart';

class VisitLogsPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return VisitLogsPageState();
  }
}

class VisitLogsPageState extends State with AutomaticKeepAliveClientMixin {
  List<VisitLog> _visitLogs = [
    VisitLog('xx', 'xx', 1, 'xx', 1, 'xx', 1, 'xx', 'xx', 'xx', 'xx', 'xx'),
    VisitLog('xx', 'xx', 1, 'xx', 1, 'xx', 1, 'xx', 'xx', 'xx', 'xx', 'xx'),
    VisitLog('xx', 'xx', 1, 'xx', 1, 'xx', 1, 'xx', 'xx', 'xx', 'xx', 'xx'),
    VisitLog('xx', 'xx', 1, 'xx', 1, 'xx', 1, 'xx', 'xx', 'xx', 'xx', 'xx'),
    VisitLog('xx', 'xx', 1, 'xx', 1, 'xx', 1, 'xx', 'xx', 'xx', 'xx', 'xx'),
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
                "拜访历史",
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
                            '添加拜访',
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
              _visitLogs.isNotEmpty
                  ? ListView.builder(
                      physics: BouncingScrollPhysics(),
                      itemCount: _visitLogs.length,
                      itemBuilder: (context, index) {
                        return _renderVisitLogItem(_visitLogs[index]);
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

  void _newVisit(BuildContext context) async {
    RadioBean result = await showDialog(
      context: context,
      builder: (context) {
        return RadioListPage([
          RadioBean(dailyVisit, "日常拜访"),
          RadioBean(businessVisit, "商务宴请"),
          RadioBean(presentVisit, "赠送礼品"),
        ]);
      },
    );
    switch (result?.id) {
      case dailyVisit:
        var needRefresh = await Navigator.push(
            context,
            CommonRoute(
              builder: (BuildContext context) => NewPlainVisit(_bloc.id),
            ));
        if (needRefresh == true) {
          _initData();
        }
        break;
      case businessVisit:
      case presentVisit:
        var needRefresh = await Navigator.push(
            context,
            CommonRoute(
              builder: (BuildContext context) =>
                  NewSpecialVisit(_bloc.id, result.id),
            ));
        if (needRefresh == true) {
          _initData();
        }
        break;
    }
  }

  Widget _renderVisitLogItem(VisitLog visitLog) {
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
                  visitLog.user_realname,
                  style: TextStyle(fontSize: 11, color: colorOrigin),
                ),
                Container(
                  margin: EdgeInsets.only(left: 10),
                  child: Text(
                    visitLog.create_time,
                    style: TextStyle(fontSize: 11, color: colorOrigin),
                  ),
                ),
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 5.0, bottom: 10),
            child: Text(
              visitLog.visit_goal,
              style: TextStyle(fontSize: 14),
            ),
          ),
          Opacity(
            opacity: _visitLogs.last == visitLog ? 0 : 1,
            child: Divider(
              height: 1,
            ),
          ),
        ],
      ),
    );
  }

  void _initData() {
    ApiService().visitLogs(_bloc.id.toString()).then(
      (rsp) {
        if (rsp.code == ApiService.success) {
          var visitLogsRsp = rsp as VisitLogsRsp;
          setState(() {
            _visitLogs = visitLogsRsp.data.list;
          });
        }
      },
    );
  }

  @override
  bool get wantKeepAlive => true;
}
