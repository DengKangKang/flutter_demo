import 'package:flutter/material.dart';
import 'package:flutter_app/CommonRoute.dart';
import 'package:flutter_app/data/http/api_service.dart';
import 'package:flutter_app/data/http/rsp/VisitLogsRsp.dart';
import 'package:flutter_app/data/http/rsp/data/VisitLogsData.dart';
import 'package:flutter_app/page/clientdetails/create_visit.dart';
import 'package:rxdart/rxdart.dart';

import '../../main.dart';

class VisitLogsPage extends StatefulWidget {
  const VisitLogsPage({Key key, this.id}) : super(key: key);

  final int id;

  @override
  State<StatefulWidget> createState() {
    return VisitLogsPageState();
  }
}

class VisitLogsPageState extends State<VisitLogsPage>
    with AutomaticKeepAliveClientMixin {
  var _visitLogs = BehaviorSubject<List<VisitLog>>(seedValue: []);

  @override
  void initState() {
    _initData();
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
                onTap: () async {
                  var result = await Navigator.push(
                    context,
                    CommonRoute(
                        builder: (c) => CreateVisitPage(
                              id: widget.id,
                            )),
                  );
                  if (result) {
                    _initData();
                  }
                },
              ),
            ],
          ),
        ),
        Flexible(
          child: Stack(
            children: <Widget>[
              StreamBuilder(
                stream: _visitLogs,
                builder: (c,s)=>s.data?.isNotEmpty==true
                    ? ListView.builder(
                  physics: BouncingScrollPhysics(),
                  itemCount: s.data.length,
                  itemBuilder: (context, index) {
                    return _renderVisitLogItem(s.data[index]);
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
              )
            ],
          ),
        ),
      ],
    );
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
              visitLog.cs_log,
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
    ApiService().visitLogs(widget.id.toString()).then(
      (rsp) {
        if (rsp.code == ApiService.success) {
          var visitLogsRsp = rsp as VisitLogsRsp;
          _visitLogs.value = visitLogsRsp.data.list;
        }
      },
    );
  }

  @override
  bool get wantKeepAlive => true;
}
