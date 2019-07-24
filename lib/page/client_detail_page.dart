import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/common_route.dart';
import 'package:flutter_app/bloc/Bloc.dart';
import 'package:flutter_app/data/http/api_service.dart';
import 'package:flutter_app/data/http/rsp/data/clients_data.dart';
import 'package:flutter_app/page/base/common_page_state.dart';
import 'package:flutter_app/page/client_list_page.dart';
import 'package:flutter_app/page/clientdetails/client_need_page.dart';
import 'package:flutter_app/page/clientdetails/client_operation_log_page.dart';
import 'package:flutter_app/weight/tool.dart';
import 'package:url_launcher/url_launcher.dart';

import '../main.dart';
import 'clientdetails/client_apply.dart';
import 'clientdetails/client_info_page.dart';
import 'clientdetails/client_sign.dart';
import 'clientdetails/client_visit_log_page.dart';

class ClientDetailPage extends StatefulWidget {
  const ClientDetailPage({Key key, this.client, this.businessType, this.title})
      : super(key: key);

  final Client client;
  final businessType;
  final title;

  @override
  State<StatefulWidget> createState() {
    return ClientDetailPageState();
  }
}

class ClientDetailPageState
    extends CommonPageState<ClientDetailPage, ClientDetailBloc> {
  final List<Tab> _tabs = <Tab>[
    Tab(text: '客户信息'),
    Tab(text: '客户需求'),
    Tab(text: '回访拜访'),
    Tab(text: '操作日志'),
  ];

  List<Widget> _page;

  List<Action> _action;

  @override
  void initState() {
    if (bloc == null) {
      bloc = ClientDetailBloc(widget.client);
    }
    if (_action == null) _action = List();
    switch (widget.businessType) {
      case (typeTrace | statePrivate):
        _action.add(ActionButton(
          '释放线索',
          colorCyan,
          releaseTrace,
        ));
        _action.add(ActionDivider());
        _action.add(ActionButton(
          '转为客户',
          colorOrigin,
          transformToClient,
        ));
        break;
      case (typeTrace | statePublic):
        _action.add(ActionButton(
          '加入私海',
          colorOrigin,
          addToPrivateTrace,
        ));
        break;
      case (typeClient | statePrivate):
        _action.add(ActionButton(
          '释放客户',
          colorCyan,
          releaseClient,
        ));
        _action.add(ActionDivider());
        _action.add(ActionButton(
          '签约',
          colorOrigin,
          signContract,
        ));
        break;
      case (typeClient | statePublic):
        _action.add(ActionButton(
          '加入私海',
          colorOrigin,
          addToPrivateClient,
        ));
        break;
    }

    if (_page == null) {
      _page = List<Widget>();
      _page.add(ClientInfoPage(
        client: widget.client,
      ));
      _page.add(ClientNeedPage(id: widget.client.id));
      if (widget.businessType == typeClient | statePrivate) {
        _page.add(ClientApplyPage(client: widget.client));
      }
      _page.add(VisitLogsPage(id: widget.client.id));
      _page.add(OperationLogPage(id: widget.client.id));
    }
    if (widget.businessType == typeClient | statePrivate) {
      _tabs.insert(
        2,
        Tab(text: '申请开通'),
      );
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ClientDetailBloc>(
      bloc: bloc,
      child: DefaultTabController(
        length: _tabs.length,
        child: Scaffold(
          key: scaffoldKey,
          backgroundColor: colorBg,
          appBar: AppBar(
            elevation: 0,
            centerTitle: true,
            title: Text(
              title(),
            ),
          ),
          body: Column(
            children: <Widget>[
              Flexible(
                child: Column(
                  children: <Widget>[
                    Expanded(
                      child: Column(
                        children: <Widget>[
                          Container(
                            margin: EdgeInsets.only(top: 10),
                            child: Material(
                              color: Colors.white,
                              elevation: defaultElevation / 2,
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                    vertical: 10, horizontal: 20),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        Row(
                                          children: <Widget>[
                                            Text(
                                              'id:' +
                                                      widget.client.id
                                                          ?.toString() ??
                                                  '',
                                              style: TextStyle(
                                                  fontSize: 13,
                                                  color: Colors.grey),
                                            ),
                                            Container(
                                              padding: EdgeInsets.all(4),
                                              margin: EdgeInsets.only(left: 10),
                                              decoration: BoxDecoration(
                                                color: Color(0x263389FF),
                                                borderRadius: BorderRadius.all(
                                                  Radius.circular(10),
                                                ),
                                              ),
                                              child: Text(
                                                widget.client.source_name ?? '',
                                                style: TextStyle(
                                                    fontSize: 9,
                                                    color: Color(0xFF3389FF)),
                                              ),
                                            )
                                          ],
                                        ),
                                        Row(
                                          children: <Widget>[
                                            Visibility(
                                              child: Text(
                                                '还剩${widget.client.daily}天释放到公海',
                                                style: TextStyle(
                                                    fontSize: 13,
                                                    color: Colors.red),
                                              ),
                                              visible: widget.businessType ==
                                                      (typeTrace |
                                                          statePrivate) &&
                                                  (widget.client.daily ??
                                                          -1) >=
                                                      0,
                                            ),
                                            Container(
                                              margin: EdgeInsets.only(left: 6),
                                              child: Image.asset(
                                                widget.client.is_important ==
                                                        yes
                                                    ? 'assets/images/ico_zd_checked.png'
                                                    : 'assets/images/ico_zd.png',
                                                color: widget.client
                                                            .is_important ==
                                                        yes
                                                    ? colorOrigin
                                                    : Colors.grey,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    Container(
                                      margin:
                                          EdgeInsets.symmetric(vertical: 10),
                                      child: Divider(
                                        height: 1,
                                      ),
                                    ),
                                    Text(
                                      widget.client.leads_name ?? '',
                                      style: TextStyle(
                                        fontSize: 17,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Container(
                                      margin: EdgeInsets.only(top: 10),
                                      child: Row(
                                        textBaseline: TextBaseline.ideographic,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.baseline,
                                        mainAxisSize: MainAxisSize.min,
                                        children: <Widget>[
                                          Text(
                                            widget.client.leads_contact ?? '',
                                            style: TextStyle(
                                              fontSize: 15,
                                              color: colorOrigin,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          Container(
                                            margin: EdgeInsets.only(left: 10),
                                            child: Text(
                                              widget.client.job_title ?? '',
                                              style: TextStyle(fontSize: 11),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                    Container(
                                      margin: EdgeInsets.only(top: 3),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          Text(
                                            widget.client.leads_mobile ?? '',
                                            style: TextStyle(fontSize: 13),
                                          ),
                                          InkWell(
                                            child: Image.asset(
                                                "assets/images/ico_dh.png"),
                                            onTap: () async {
                                              callPhone();
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 67,
                            child: TabBar(
                              unselectedLabelColor: Colors.grey,
                              indicatorColor: colorOrigin,
                              indicatorPadding: EdgeInsets.only(
                                  right: 15, left: 15, bottom: 20),
                              tabs: _tabs,
                              isScrollable: true,
                            ),
                          ),
                          Expanded(
                            child: TabBarView(
                              children: <Widget>[..._page],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          bottomNavigationBar: Container(
            height: 60,
            child: Material(
              elevation: defaultElevation,
              color: Colors.white,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  ..._action.map((a) => a.build()),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  String title() => widget.title == null
      ? widget.businessType & 0xF == typeTrace ? '线索详情' : '客户详情'
      : widget.title;

  void callPhone() async {
    if (await canLaunch('tel:${widget.client.leads_mobile}')) {
      await launch('tel:${widget.client.leads_mobile}');
    } else {
      scaffoldKey.currentState.showSnackBar(
        SnackBar(
          content: Text(
            '您的手机不支持应用拨打电话。',
          ),
        ),
      );
    }
  }

  void releaseTrace() {
    showDialog(
      context: context,
      builder: (c) => AlertDialog(
        title: Text("提示"),
        content: Text("确定释放线索？"),
        actions: <Widget>[
          FlatButton(
            child: Text(
              '取消',
              style: TextStyle(
                color: Colors.grey,
              ),
            ),
            onPressed: () {
              Navigator.of(c).pop();
            },
          ),
          FlatButton(
            child: Text(
              '确定',
              style: TextStyle(
                color: colorOrigin,
              ),
            ),
            onPressed: () async {
              Navigator.of(c).pop();
              onLoading(context);
              var rsp =
                  await ApiService().releaseTrace(widget.client.id.toString());
              loadingFinish(context);
              if (rsp.code == ApiService.success) {
                Navigator.of(context).pop(true);
              } else {
                bloc.showTip(rsp.msg);
              }
            },
          ),
        ],
      ),
    );
  }

  void transformToClient() async {
    onLoading(context);
    var rsp = await ApiService().transformToClient(widget.client.id.toString());
    loadingFinish(context);
    if (rsp.code == ApiService.success) {
      await Navigator.pushAndRemoveUntil(
        context,
        CommonRoute(
          builder: (BuildContext context) => ClientListPage(
            title: '私海客户',
            businessType: typeClient | statePrivate,
          ),
        ),
        ModalRoute.withName('/main'),
      );
    } else {
      bloc.showTip(rsp.msg);
    }
  }

  void addToPrivateTrace() {
    showDialog(
      context: context,
      builder: (c) => AlertDialog(
        title: Text("提示"),
        content: Text("确定加入私海？"),
        actions: <Widget>[
          FlatButton(
            child: Text(
              '取消',
              style: TextStyle(
                color: Colors.grey,
              ),
            ),
            onPressed: () {
              Navigator.of(c).pop();
            },
          ),
          FlatButton(
            child: Text(
              '确定',
              style: TextStyle(
                color: colorOrigin,
              ),
            ),
            onPressed: () async {
              Navigator.of(c).pop();
              onLoading(context);
              var rsp = await ApiService()
                  .addToPrivateTrace(widget.client.id.toString());
              loadingFinish(context);
              if (rsp.code == ApiService.success) {
                await Navigator.pushAndRemoveUntil(
                  context,
                  CommonRoute(
                    builder: (BuildContext context) => ClientListPage(
                      title: '私海线索',
                      businessType: typeTrace | statePrivate,
                    ),
                  ),
                  ModalRoute.withName('/main'),
                );
              } else {
                bloc.showTip(rsp.msg);
              }
            },
          ),
        ],
      ),
    );
  }

  void releaseClient() {
    showDialog(
      context: context,
      builder: (c) => AlertDialog(
        title: Text("提示"),
        content: Text("确定释放客户？"),
        actions: <Widget>[
          FlatButton(
            child: Text(
              '取消',
              style: TextStyle(
                color: Colors.grey,
              ),
            ),
            onPressed: () {
              Navigator.of(c).pop();
            },
          ),
          FlatButton(
            child: Text(
              '确定',
              style: TextStyle(
                color: colorOrigin,
              ),
            ),
            onPressed: () async {
              Navigator.of(c).pop();
              onLoading(context);
              var rsp =
                  await ApiService().releaseClient(widget.client.id.toString());
              loadingFinish(context);
              if (rsp.code == ApiService.success) {
                Navigator.of(context).pop(true);
              } else {
                bloc.showTip(rsp.msg);
              }
            },
          ),
        ],
      ),
    );
  }

  void signContract() {
    Navigator.push(
      context,
      CommonRoute(
          builder: (c) => ClientSignPage(
                client: widget.client,
              )),
    );
  }

  void addToPrivateClient() {
    showDialog(
      context: context,
      builder: (c) => AlertDialog(
        title: Text("提示"),
        content: Text("确定加入私海？"),
        actions: <Widget>[
          FlatButton(
            child: Text(
              '取消',
              style: TextStyle(
                color: Colors.grey,
              ),
            ),
            onPressed: () {
              Navigator.of(c).pop();
            },
          ),
          FlatButton(
            child: Text(
              '确定',
              style: TextStyle(
                color: colorOrigin,
              ),
            ),
            onPressed: () async {
              Navigator.of(c).pop();
              onLoading(context);
              var rsp = await ApiService()
                  .addToPrivateClient(widget.client.id.toString());
              loadingFinish(context);
              if (rsp.code == ApiService.success) {
                await Navigator.pushAndRemoveUntil(
                  context,
                  CommonRoute(
                    builder: (BuildContext context) => ClientListPage(
                      title: '私海客户',
                      businessType: typeClient | statePrivate,
                    ),
                  ),
                  ModalRoute.withName('/main'),
                );
              } else {
                bloc.showTip(rsp.msg);
              }
            },
          ),
        ],
      ),
    );
  }
}

class ClientDetailBloc extends CommonBloc {
  ClientDetailBloc(this.client);

  final Client client;
}

abstract class Action = ActionStructure with ActionBehavior;

class ActionButton = ActionButtonStructure
    with ActionButtonBehavior
    implements Action;

class ActionDivider = ActionDividerStructure
    with ActionDividerBehavior
    implements Action;

mixin ActionBehavior {
  Widget build();
}

class ActionStructure {}

mixin ActionButtonBehavior {
  String get label;

  Color get color;

  GestureTapCallback get action;

  Widget build() => Flexible(
        child: InkWell(
          child: Container(
            height: 60,
            child: Center(
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 17,
                  color: color,
                ),
              ),
            ),
          ),
          onTap: action,
        ),
      );
}

class ActionButtonStructure {
  ActionButtonStructure(this.label, this.color, this.action);

  final String label;
  final Color color;
  final GestureTapCallback action;
}

mixin ActionDividerBehavior {
  Widget build() {
    return VerticalDivider(
      width: 1,
    );
  }
}

class ActionDividerStructure {}
