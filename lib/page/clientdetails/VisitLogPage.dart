import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_app/CommonRoute.dart';
import 'package:flutter_app/data/Constant.dart';
import 'package:flutter_app/data/http/ApiService.dart';
import 'package:flutter_app/data/http/rsp/VisitLogsRsp.dart';
import 'package:flutter_app/data/http/rsp/data/RadioBean.dart';
import 'package:flutter_app/data/http/rsp/data/VisitLogsData.dart';
import 'package:flutter_app/page/RadioListPage.dart';
import 'package:flutter_app/page/clientdetails/NewPlainVisit.dart';
import 'package:flutter_app/page/clientdetails/NewSpecialVisit.dart';

class VisitLogsPage extends StatefulWidget {
  final int _leadId;

  VisitLogsPage(this._leadId);

  @override
  State<StatefulWidget> createState() {
    return VisitLogsPageState(_leadId);
  }
}

class VisitLogsPageState extends State with AutomaticKeepAliveClientMixin {
  final int _leadId;

  List<VisitLog> _visitLogs = new List();

  VisitLogsPageState(this._leadId);

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
          child: new Text("拜访记录"),
        ),
        new Flexible(
          child: new Stack(
            children: <Widget>[
              _visitLogs.isNotEmpty
                  ? new Container(
                      margin: EdgeInsets.only(
                        top: 12.0,
                        bottom: 12.0,
                        right: 12.0,
                        left: 12.0,
                      ),
                      child: new ListView.builder(
                        physics: new BouncingScrollPhysics(),
                        itemCount: _visitLogs.length,
                        itemBuilder: (context, index) {
                          return _renderVisitLogItem(_visitLogs[index]);
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
                '新增拜访',
                style: Theme.of(context).textTheme.body1.merge(TextStyle(
                      color: _leadId != null ? Colors.blue : Colors.grey,
                    )),
              ),
              onTap: _leadId != null
                  ? () {
                      _newVisit(context);
                    }
                  : null,
            ),
          ),
        )
      ],
    );
  }

  void _newVisit(BuildContext context) async {
    RadioBean result = await showDialog(
      context: context,
      builder: (context) {
        return new RadioListPage([
          RadioBean(DAILY_VISIT, "日常拜访"),
          RadioBean(BUSINESS_VISIT, "商务宴请"),
          RadioBean(PRESENT_VISIT, "赠送礼品"),
        ]);
      },
    );
    switch (result?.id) {
      case DAILY_VISIT:
        var needRefresh = await Navigator.push(
            context,
            new CommonRoute(
              builder: (BuildContext context) => new NewPlainVisit(_leadId),
            ));
        if (needRefresh == true) {
          _initData();
        }
        break;
      case BUSINESS_VISIT:
      case PRESENT_VISIT:
        var needRefresh = await Navigator.push(
            context,
            new CommonRoute(
              builder: (BuildContext context) =>
                  new NewSpecialVisit(_leadId, result.id),
            ));
        if (needRefresh == true) {
          _initData();
        }
        break;
    }
  }

  Widget _renderVisitLogItem(VisitLog visitLog) {
    final children = new List<Widget>();
    children.add(new Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        new Text(
          visitLog.user_realname,
          style: Theme.of(context)
              .textTheme
              .body1
              .merge(TextStyle(color: Colors.grey)),
        ),
        new Text(
          visitLog.create_time,
          style: Theme.of(context)
              .textTheme
              .body1
              .merge(TextStyle(color: Colors.grey)),
        ),
      ],
    ));
    if (visitLog.sale_visit_time != null &&
        visitLog.sale_visit_time.isNotEmpty) {
      children.add(new Container(
        margin: EdgeInsets.only(top: 12.0),
        child: new Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            new Text(
              '拜访日期：',
              style: Theme.of(context).textTheme.body1,
            ),
            new Text(
              visitLog.sale_visit_time,
              style: Theme.of(context).textTheme.body1,
            ),
          ],
        ),
      ));
    }
    if (visitLog.sale_visit_form != null) {
      children.add(new Container(
        margin: EdgeInsets.only(top: 6.0),
        child: new Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            new Text(
              '拜访形式：',
              style: Theme.of(context).textTheme.body1,
            ),
            new Text(
              visitWays
                  .firstWhere((e) => e.id == visitLog.sale_visit_form)
                  .name,
              style: Theme.of(context).textTheme.body1,
            ),
          ],
        ),
      ));
    }
    if (visitLog.sale_feedback != null && visitLog.sale_feedback.isNotEmpty) {
      children.add(new Container(
        margin: EdgeInsets.only(top: 6.0),
        child: new Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            new Text(
              '客户反馈：',
              style: Theme.of(context).textTheme.body1,
            ),
            new Flexible(
              child: new Text(
                visitLog.sale_feedback,
                style: Theme.of(context).textTheme.body1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ));
    }

    if (visitLog.sale_solution != null && visitLog.sale_solution.isNotEmpty) {
      children.add(new Container(
        margin: EdgeInsets.only(top: 6.0),
        child: new Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            new Text(
              '解决方案：',
              style: Theme.of(context).textTheme.body1,
            ),
            new Flexible(
              child: new Text(
                visitLog.sale_solution,
                style: Theme.of(context).textTheme.body1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ));
    }

    if (visitLog.visitor != null && visitLog.visitor.isNotEmpty) {
      children.add(new Container(
        margin: EdgeInsets.only(top: 6.0),
        child: new Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            new Text(
              '拜访对象：',
              style: Theme.of(context).textTheme.body1,
            ),
            new Flexible(
              child: new Text(
                visitLog.visitor,
                style: Theme.of(context).textTheme.body1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ));
    }

    if (visitLog.expense != null && visitLog.expense.isNotEmpty) {
      children.add(new Container(
        margin: EdgeInsets.only(top: 6.0),
        child: new Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            new Text(
              '拜访费用：',
              style: Theme.of(context).textTheme.body1,
            ),
            new Flexible(
              child: new Text(
                visitLog.expense,
                style: Theme.of(context).textTheme.body1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ));
    }

    if (visitLog.visit_goal != null && visitLog.visit_goal.isNotEmpty) {
      children.add(new Container(
        margin: EdgeInsets.only(top: 6.0),
        child: new Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            new Text(
              '拜访目标：',
              style: Theme.of(context).textTheme.body1,
            ),
            new Flexible(
              child: new Text(
                visitLog.visit_goal,
                style: Theme.of(context).textTheme.body1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
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
    ApiService().visitLogs(_leadId.toString()).then(
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
