import 'package:flutter/material.dart';
import 'package:flutter_app/bloc/Bloc.dart';
import 'package:flutter_app/bloc/ClientDetailBloc.dart';
import 'package:flutter_app/data/http/ApiService.dart';
import 'package:flutter_app/data/http/rsp/OperationLogsRsp.dart';
import 'package:flutter_app/data/http/rsp/data/OperationLogsData.dart';

import '../../main.dart';

class OperationLogPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return OperationLogPageState();
  }
}

class OperationLogPageState extends State with AutomaticKeepAliveClientMixin {
  List<OperationLog> _operationLogs = [
    OperationLog('11','1231','31231','32131',1),
    OperationLog('11','1231','31231','32131',1),
    OperationLog('11','1231','31231','32131',1),
    OperationLog('11','1231','31231','32131',1),
    OperationLog('11','1231','31231','32131',1),
    OperationLog('11','1231','31231','32131',1),
    OperationLog('11','1231','31231','32131',1),
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
    return  Stack(
      children: <Widget>[
        _operationLogs.isNotEmpty
            ? ListView.builder(
          physics: BouncingScrollPhysics(),
          itemCount: _operationLogs.length,
          itemBuilder: (context, index) {
            return _renderOperationLogItem(_operationLogs[index]);
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
    );
  }

  Widget _renderOperationLogItem(OperationLog operationLog) {
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
                  operationLog.user_realname,
                  style: TextStyle(fontSize: 11, color: colorOrigin),
                ),
                Container(
                  margin: EdgeInsets.only(left: 10),
                  child: Text(
                    operationLog.create_time,
                    style: TextStyle(fontSize: 11, color: colorOrigin),
                  ),
                ),
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 5.0, bottom: 10),
            child: Text(
              operationLog.system_log,
              style: TextStyle(fontSize: 14),
            ),
          ),
          Opacity(
            opacity: _operationLogs.last == operationLog ? 0 : 1,
            child: Divider(
              height: 1,
            ),
          ),
        ],
      ),
    );
  }

  void _initData() {
    ApiService().operationLogs(_bloc.id.toString()).then(
      (rsp) {
        if (rsp.code == ApiService.success) {
          setState(() {
            var operationLogsRsp = rsp as OperationLogsRsp;
            _operationLogs = operationLogsRsp.data.list;
          });
        }
      },
    );
  }

  @override
  bool get wantKeepAlive => true;
}
