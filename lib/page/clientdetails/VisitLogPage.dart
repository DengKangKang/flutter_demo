import 'package:flutter/material.dart';
import 'package:flutter_app/CommonRoute.dart';
import 'package:flutter_app/bloc/Bloc.dart';
import 'package:flutter_app/bloc/ClientDetailBloc.dart';
import 'package:flutter_app/data/Constant.dart';
import 'package:flutter_app/data/http/api_service.dart';
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

  Widget _renderVisitLogItem(VisitLog visitLog){}

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
