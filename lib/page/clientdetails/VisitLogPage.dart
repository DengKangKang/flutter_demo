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

class VisitLogsPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return VisitLogsPageState();
  }
}

class VisitLogsPageState extends State with AutomaticKeepAliveClientMixin {
  List<VisitLog> _visitLogs = List();

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
          padding: EdgeInsets.only(top: 12.0, right: 16.0, left: 16.0),
          child: Text("拜访记录"),
        ),
        Flexible(
          child: Stack(
            children: <Widget>[
              _visitLogs.isNotEmpty
                  ? Container(
                      margin: EdgeInsets.only(
                        top: 12.0,
                        bottom: 12.0,
                        right: 12.0,
                        left: 12.0,
                      ),
                      child: ListView.builder(
                        physics: BouncingScrollPhysics(),
                        itemCount: _visitLogs.length,
                        itemBuilder: (context, index) {
                          return _renderVisitLogItem(_visitLogs[index]);
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
                '新增拜访',
                style: Theme.of(context).textTheme.body1.merge(TextStyle(
                      color: _bloc.id != null ? Colors.blue : Colors.grey,
                    )),
              ),
              onTap: _bloc.id != null
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
    final children = List<Widget>();
    children.add(Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text(
          visitLog.user_realname,
          style: Theme.of(context)
              .textTheme
              .body1
              .merge(TextStyle(color: Colors.grey)),
        ),
        Text(
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
      children.add(Container(
        margin: EdgeInsets.only(top: 12.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Text(
              '拜访日期：',
              style: Theme.of(context).textTheme.body1,
            ),
            Text(
              visitLog.sale_visit_time,
              style: Theme.of(context).textTheme.body1,
            ),
          ],
        ),
      ));
    }
    if (visitLog.sale_visit_form != null) {
      children.add(Container(
        margin: EdgeInsets.only(top: 6.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Text(
              '拜访形式：',
              style: Theme.of(context).textTheme.body1,
            ),
            Text(
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
      children.add(Container(
        margin: EdgeInsets.only(top: 6.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Text(
              '客户反馈：',
              style: Theme.of(context).textTheme.body1,
            ),
            Flexible(
              child: Text(
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
      children.add(Container(
        margin: EdgeInsets.only(top: 6.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Text(
              '解决方案：',
              style: Theme.of(context).textTheme.body1,
            ),
            Flexible(
              child: Text(
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
      children.add(Container(
        margin: EdgeInsets.only(top: 6.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Text(
              '拜访对象：',
              style: Theme.of(context).textTheme.body1,
            ),
            Flexible(
              child: Text(
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
      children.add(Container(
        margin: EdgeInsets.only(top: 6.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Text(
              '拜访费用：',
              style: Theme.of(context).textTheme.body1,
            ),
            Flexible(
              child: Text(
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
      children.add(Container(
        margin: EdgeInsets.only(top: 6.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Text(
              '拜访目标：',
              style: Theme.of(context).textTheme.body1,
            ),
            Flexible(
              child: Text(
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
      child: Container(
        padding: EdgeInsets.symmetric(
          vertical: 12.0,
          horizontal: 16.0,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: children,
        ),
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
