import 'package:flutter/material.dart';
import 'package:flutter_app/CommonRoute.dart';
import 'package:flutter_app/data/Constant.dart';
import 'package:flutter_app/data/http/api_service.dart';
import 'package:flutter_app/data/http/rsp/VisitLogsRsp.dart';
import 'package:flutter_app/data/http/rsp/data/RadioBean.dart';
import 'package:flutter_app/data/http/rsp/data/VisitLogsData.dart';
import 'package:rxdart/rxdart.dart';

import '../../main.dart';
import '../RadioListPage.dart';
import 'NewPlainVisit.dart';
import 'NewSpecialVisit.dart';

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
                  _newVisit(context);
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
                builder: (c, s) => s.data?.isNotEmpty == true
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

//  Widget _renderVisitLogItem(VisitLog visitLog) {
//    return Container(
//      color: Colors.white,
//      padding: EdgeInsets.symmetric(
//        horizontal: 20.0,
//      ),
//      child: Column(
//        crossAxisAlignment: CrossAxisAlignment.start,
//        children: <Widget>[
//          Container(
//            margin: EdgeInsets.only(top: 11),
//            child: Row(
//              children: <Widget>[
//                Text(
//                  visitLog.user_realname??'',
//                  style: TextStyle(fontSize: 11, color: colorOrigin),
//                ),
//                Container(
//                  margin: EdgeInsets.only(left: 10),
//                  child: Text(
//                    visitLog.create_time??'',
//                    style: TextStyle(fontSize: 11, color: colorOrigin),
//                  ),
//                ),
//              ],
//            ),
//          ),
//          Container(
//            margin: EdgeInsets.only(top: 5.0, bottom: 10),
//            child: Text(
//              visitLog.cs_log??'',
//              style: TextStyle(fontSize: 14),
//            ),
//          ),
//          Opacity(
//            opacity: _visitLogs.value.last == visitLog ? 0 : 1,
//            child: Divider(
//              height: 1,
//            ),
//          ),
//        ],
//      ),
//    );
//  }

  Widget _renderVisitLogItem(VisitLog visitLog) {
    final children = List<Widget>();

    children.add(
      Container(
        margin: EdgeInsets.only(top: 10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            Text(
              visitLog.user_realname ?? '',
              style: TextStyle(fontSize: 11, color: colorOrigin),
            ),
            Container(
              margin: EdgeInsets.only(left: 10),
              child: Text(
                visitLog.create_time ?? '',
                style: TextStyle(fontSize: 11, color: colorOrigin),
              ),
            ),
          ],
        ),
      ),
    );

    if (visitLog.sale_visit_form != null) {
      children.add(Container(
        margin: EdgeInsets.only(top: 10, bottom: 6),
        child: Text(
          int.parse(visitLog.sale_visit_form) == businessVisit ||
                  int.parse(visitLog.sale_visit_form) == presentVisit
              ? visitWays
                  .firstWhere(
                      (e) => e.id == int.parse(visitLog.sale_visit_form))
                  .name
              : '日常拜访',
          style: TextStyle(fontSize: 14, color: colorCyan),
        ),
      ));
    }

    if (visitLog.sale_visit_time != null &&
        visitLog.sale_visit_time.isNotEmpty) {
      children.add(Container(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Text(
              '拜访日期：',
              style: TextStyle(
                fontSize: 12,
              ),
            ),
            Text(
              visitLog.sale_visit_time,
              style: TextStyle(
                fontSize: 12,
              ),
            ),
          ],
        ),
      ));
    }
    if (visitLog.sale_visit_form != null &&
        (int.parse(visitLog.sale_visit_form) == businessVisit ||
            int.parse(visitLog.sale_visit_form) == presentVisit)) {
      if (visitLog.visitor != null) {
        children.add(Container(
          margin: EdgeInsets.only(top: 5),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Text(
                '拜访对象：',
                style: TextStyle(fontSize: 12),
              ),
              Text(
                visitLog.visitor ?? '',
                style: TextStyle(fontSize: 12),
              ),
            ],
          ),
        ));
      }
    } else {
      if (visitLog.sale_visit_form != null) {
        children.add(Container(
          margin: EdgeInsets.only(top: 5),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Text(
                '拜访形式：',
                style: TextStyle(fontSize: 12),
              ),
              Text(
                visitWays
                    .firstWhere(
                        (e) => e.id == int.parse(visitLog.sale_visit_form))
                    .name,
                style: TextStyle(fontSize: 12),
              ),
            ],
          ),
        ));
      }
    }

    if (visitLog.sale_feedback != null && visitLog.sale_feedback.isNotEmpty) {
      children.add(Container(
        margin: EdgeInsets.only(top: 5),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Text(
              '客户反馈：',
              style: TextStyle(fontSize: 12),
            ),
            Flexible(
              child: Text(
                visitLog.sale_feedback,
                style: TextStyle(fontSize: 12),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ));
    }

    if (visitLog.sale_solution != null && visitLog.sale_solution.isNotEmpty) {
      children.add(Container(
        margin: EdgeInsets.only(top: 5),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Text(
              '解决方案：',
              style: TextStyle(fontSize: 12),
            ),
            Flexible(
              child: Text(
                visitLog.sale_solution,
                style: TextStyle(fontSize: 12),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ));
    }

    if (visitLog.sale_visit_form != null &&
        (int.parse(visitLog.sale_visit_form) == businessVisit ||
            int.parse(visitLog.sale_visit_form) == presentVisit)) {
      children.add(Container(
        margin: EdgeInsets.only(top: 5),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Text(
              '拜访费用：',
              style: TextStyle(fontSize: 12),
            ),
            Flexible(
              child: Text(
                visitLog.expense?.toString() ?? '0',
                style: TextStyle(fontSize: 12),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ));
    }

    if (visitLog.visit_goal != null && visitLog.visit_goal.isNotEmpty) {
      children.add(Container(
        margin: EdgeInsets.only(top: 5),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Text(
              '拜访目标：',
              style: TextStyle(fontSize: 12),
            ),
            Flexible(
              child: Text(
                visitLog.visit_goal,
                style: TextStyle(fontSize: 12),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ));
    }
    return Column(
      children: <Widget>[
        Container(
          color: Colors.white,
          padding: EdgeInsets.only(bottom: 10, right: 20, left: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: children,
          ),
        ),
        Visibility(
          visible: _visitLogs.value?.last != visitLog,
          child: Divider(
            height: 1,
          ),
        )
      ],
    );
  }

  void _initData() async {
    var rsp = await ApiService().visitLogs(widget.id.toString());
    if (rsp.code == ApiService.success) {
      _visitLogs.add(rsp.data.list);
    }
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
              builder: (BuildContext context) => NewPlainVisit(widget.id),
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
                  NewSpecialVisit(widget.id, result.id),
            ));
        if (needRefresh == true) {
          _initData();
        }
        break;
    }
  }

  @override
  bool get wantKeepAlive => true;
}
