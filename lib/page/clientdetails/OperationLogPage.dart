import 'package:flutter/material.dart';
import 'package:flutter_app/bloc/Bloc.dart';
import 'package:flutter_app/bloc/ClientDetailBloc.dart';
import 'package:flutter_app/data/http/ApiService.dart';
import 'package:flutter_app/data/http/rsp/OperationLogsRsp.dart';
import 'package:flutter_app/data/http/rsp/data/OperationLogsData.dart';

class OperationLogPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return OperationLogPageState();
  }
}

class OperationLogPageState extends State with AutomaticKeepAliveClientMixin {

  List<OperationLog> _operationLogs = new List();

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
    return new Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        new Container(
          padding: EdgeInsets.only(top: 12.0, right: 16.0, left: 16.0),
          child: new Text("操作记录"),
        ),
        new Flexible(
          child: new Container(
            margin: EdgeInsets.only(
              top: 12.0,
              bottom: 12.0,
              right: 12.0,
              left: 12.0,
            ),
            child: new ListView.builder(
              physics: new BouncingScrollPhysics(),
              itemCount: _operationLogs.length,
              itemBuilder: (context, index) {
                return _renderOperationLogItem(_operationLogs[index]);
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _renderOperationLogItem(OperationLog operationLog) {
    final children = new List<Widget>();
    children.add(new Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        new Text(
          operationLog.user_realname,
          style: Theme.of(context)
              .textTheme
              .body1
              .merge(TextStyle(color: Colors.grey)),
        ),
        new Text(
          operationLog.create_time,
          style: Theme.of(context)
              .textTheme
              .body1
              .merge(TextStyle(color: Colors.grey)),
        ),
      ],
    ));
    if (operationLog.system_log != null && operationLog.system_log.isNotEmpty) {
      children.add(new Container(
        margin: EdgeInsets.only(top: 12.0),
        child: new Text(
          operationLog.system_log,
          style: Theme.of(context).textTheme.body1,
        ),
      ));
    }

    return Card(
      elevation: 2.0,
      child: new Container(
        padding: EdgeInsets.symmetric(
          vertical: 12.0,
          horizontal: 16.0,
        ),
        child: new Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: children,
        ),
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
