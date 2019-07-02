import 'package:flutter/material.dart';
import 'package:flutter_app/data/http/api_service.dart';
import 'package:flutter_app/data/http/rsp/OperationLogsRsp.dart';
import 'package:flutter_app/data/http/rsp/data/OperationLogsData.dart';
import 'package:rxdart/rxdart.dart';

import '../../main.dart';

class OperationLogPage extends StatefulWidget {
  const OperationLogPage({Key key, this.id}) : super(key: key);

  final id;

  @override
  State<StatefulWidget> createState() {
    return OperationLogPageState();
  }
}

class OperationLogPageState extends State<OperationLogPage>
    with AutomaticKeepAliveClientMixin {
  var _operationLogs = BehaviorSubject<List<OperationLog>>(seedValue: []);

  @override
  void initState() {
    _initData();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Stack(
      children: <Widget>[
        StreamBuilder(
          stream: _operationLogs,
          builder: (c, s) => s.data?.isNotEmpty == true
              ? ListView.builder(
                  physics: BouncingScrollPhysics(),
                  itemCount: s.data.length,
                  itemBuilder: (context, index) {
                    return _renderOperationLogItem(s.data[index]);
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
    ApiService().operationLogs(widget.id.toString()).then(
      (rsp) {
        if (rsp.code == ApiService.success) {
          var operationLogsRsp = rsp as OperationLogsRsp;
          _operationLogs.value = operationLogsRsp.data.list;
        }
      },
    );
  }

  @override
  bool get wantKeepAlive => true;
}
