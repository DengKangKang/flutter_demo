import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/bloc/Bloc.dart';
import 'package:flutter_app/bloc/ClientDetailBloc.dart';
import 'package:flutter_app/data/http/rsp/data/ClientListData.dart';
import 'package:flutter_app/page/base/CommonPageState.dart';
import 'package:flutter_app/page/clientdetails/client_need_page.dart';
import 'package:flutter_app/page/clientdetails/client_operation_log_page.dart';

import '../main.dart';
import 'clientdetails/client_apply.dart';
import 'clientdetails/client_info_page.dart';
import 'clientdetails/client_visit_log_page.dart';

class ClientDetailPage extends StatefulWidget {
  ClientDetailPage(this._client);

  final Client _client;

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
    Tab(text: '申请开通'),
    Tab(text: '回访拜访'),
    Tab(text: '操作日志'),
  ];

  List<Widget> _page;

  @override
  void initState() {
    if (bloc == null) {
      bloc = ClientDetailBloc(widget._client);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (_page == null) {
      _page = List<Widget>();
      _page.add(ClientInfoPage());
      _page.add(ClientNeedPage());
      _page.add(ClientApplyPage());
      _page.add(VisitLogsPage());
      _page.add(OperationLogPage());
    }

    return BlocProvider<ClientDetailBloc>(
      bloc: bloc,
      child: DefaultTabController(
        length: _tabs.length,
        child: Scaffold(
          key: scaffoldKey,
          backgroundColor: colorBg,
          appBar: AppBar(
            centerTitle: true,
            title: Text('线索详情'),
          ),
          body: Column(
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
                                        'id_124',
                                        style: TextStyle(
                                            fontSize: 13, color: Colors.grey),
                                      ),
                                      Container(
                                        padding: EdgeInsets.all(2),
                                        margin: EdgeInsets.only(left: 10),
                                        decoration: BoxDecoration(
                                          color: Color(0x263389FF),
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(10),
                                          ),
                                        ),
                                        child: Text(
                                          '会议渠道',
                                          style: TextStyle(
                                              fontSize: 9,
                                              color: Color(0xFF3389FF)),
                                        ),
                                      )
                                    ],
                                  ),
                                  Row(
                                    children: <Widget>[
                                      Text(
                                        '还剩X天释放到公海',
                                        style: TextStyle(
                                            fontSize: 13, color: Colors.red),
                                      ),
                                      Container(
                                        margin: EdgeInsets.only(left: 6),
                                        child: Icon(
                                          Icons.star_border,
                                          color: Colors.grey,
                                        ),
                                      )
                                    ],
                                  ),
                                ],
                              ),
                              Container(
                                margin: EdgeInsets.symmetric(vertical: 10),
                                child: Divider(
                                  height: 1,
                                ),
                              ),
                              Text(
                                'xxxxxxxxxxxxx',
                                style: TextStyle(fontSize: 17),
                              ),
                              Container(
                                margin: EdgeInsets.only(top: 10),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    Text(
                                      'XX',
                                      style: TextStyle(
                                          fontSize: 15, color: colorOrigin),
                                    ),
                                    Container(
                                      margin: EdgeInsets.only(left: 10),
                                      child: Text(
                                        'xx',
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
                                      'XX',
                                      style: TextStyle(fontSize: 13),
                                    ),
                                    Image.asset("assets/images/ico_dh.png"),
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
                        indicatorPadding:
                            EdgeInsets.only(right: 15, left: 15, bottom: 20),
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
          bottomNavigationBar: Container(
            height: 60,
            child: Material(
              elevation: defaultElevation,
              color: Colors.white,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  Flexible(
                    child: InkWell(
                      child: Container(
                        height: 60,
                        child: Center(
                          child: Text(
                            '释放线索',
                            style: TextStyle(
                              fontSize: 17,
                              color: colorCyan,
                            ),
                          ),
                        ),
                      ),
                      onTap: () {},
                    ),
                  ),
                  VerticalDivider(
                    width: 1,
                  ),
                  Flexible(
                    child: InkWell(
                      child: Container(
                        height: 60,
                        child: Center(
                          child: Text(
                            '转为客户',
                            style: TextStyle(
                              fontSize: 17,
                              color: colorOrigin,
                            ),
                          ),
                        ),
                      ),
                      onTap: () {},
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

//  void _onNewOrSave(BuildContext context) async {
//    if (bloc.clientName.isEmpty) {
//      _key.currentState.showSnackBar(
//        SnackBar(
//          content: Text("请输入客户名称"),
//        ),
//      );
//      return;
//    }
//    if (bloc.company.id == 0) {
//      _key.currentState.showSnackBar(
//        SnackBar(
//          content: Text("请选择公司类型"),
//        ),
//      );
//      return;
//    }
//    if (bloc.industry.id == 0) {
//      _key.currentState.showSnackBar(
//        SnackBar(
//          content: Text("请选择所属行业"),
//        ),
//      );
//      return;
//    }
//    if (bloc.source.id == 0) {
//      _key.currentState.showSnackBar(
//        SnackBar(
//          content: Text("请选择来源类型"),
//        ),
//      );
//      return;
//    }
//    if (bloc.location.id == 0) {
//      _key.currentState.showSnackBar(
//        SnackBar(
//          content: Text("请选择所在地"),
//        ),
//      );
//      return;
//    }
//    if (bloc.invoiceCount.isEmpty) {
//      _key.currentState.showSnackBar(
//        SnackBar(
//          content: Text("请输入年发票量"),
//        ),
//      );
//      return;
//    }
//    if (bloc.email != null &&
//        bloc.email.isNotEmpty &&
//        !EmailValidator.validate(bloc.email)) {
//      _key.currentState.showSnackBar(
//        SnackBar(
//          content: Text("邮箱格式不正确"),
//        ),
//      );
//      return;
//    }
//    if (bloc.contactWay == null || bloc.contactWay.isEmpty) {
//      _key.currentState.showSnackBar(
//        SnackBar(
//          content: Text("请输入联系方式"),
//        ),
//      );
//      return;
//    }
//    if (bloc.title == null || bloc.title.isEmpty) {
//      _key.currentState.showSnackBar(
//        SnackBar(
//          content: Text("请输入职务"),
//        ),
//      );
//      return;
//    }
//    onLoading(context);
//    var rsp = await ApiService().newOrSaveClient(
//      bloc.id,
//      bloc.clientName,
//      bloc.company.id,
//      bloc.industry.id,
//      bloc.source.id,
//      bloc.location.id,
//      bloc.invoiceCount,
//      bloc.startTarget.id,
//      bloc.secondaryDevelopment.id,
//      bloc.progress.id,
//      bloc.expectedContractAmount,
//      bloc.expectedSignDate,
//      bloc.lnsize,
//      bloc.companyIntro,
//      bloc.firstPartyRepresentatives,
//      bloc.contactWay,
//      bloc.email,
//      bloc.title,
//    );
//    loadingFinish(context);
//    if (rsp.code == ApiService.success) {
//      Navigator.of(context).pop(true);
//    } else {
//      _key.currentState.showSnackBar(
//        SnackBar(
//          content: Text(rsp.msg),
//        ),
//      );
//    }
//  }
}

//class ClientDetailBloc extends CommonBloc {
//  ClientDetailBloc(Client client) {
//    _id = client?.id;
//    _clientName = client?.leads_name ?? "";
//
//    _company = companyTypes.firstWhere(
//          (e) => e.id == client?.company_type,
//      orElse: () => companyTypes[0],
//    );
//
//    _industry = industries.firstWhere(
//          (e) => e.id == client?.industry,
//      orElse: () => industries[0],
//    );
//
//    _source = sourceTypes.firstWhere(
//          (e) => e.id == client?.source_id,
//      orElse: () => sourceTypes[0],
//    );
//
//    _location = locations.firstWhere(
//          (e) => e.id == client?.location,
//      orElse: () => locations[0],
//    );
//
//    _invoiceCount = client?.annual_invoice?.toString() ?? "";
//
//    _startTarget = booleans.firstWhere(
//          (e) => e.id == client?.is_important,
//      orElse: () => booleans[0],
//    );
//
//    _secondaryDevelopment = booleans.firstWhere(
//          (e) => e.id == client?.on_premise,
//      orElse: () => booleans[0],
//    );
//
//    _progress = progresses.firstWhere(
//          (e) => e.id == client?.progress_percent,
//      orElse: () => progresses[0],
//    );
//
//    _expectedContractAmount = client?.anticipated_amount ?? "";
//
//    _expectedSignDate = client?.anticipated_date ?? "";
//
//    _lnsize = client?.company_size ?? "";
//
//    _companyIntro = client?.memo ?? "";
//
//    _firstPartyRepresentatives = client?.leads_contact ?? "";
//
//    _contactWay = client?.leads_mobile ?? "";
//
//    _email = client?.leads_email ?? "";
//
//    _title = client?.job_title ?? "";
//  }
//
//  int _id;
//  String _clientName;
//  RadioBean _company;
//  RadioBean _industry;
//  RadioBean _source;
//  RadioBean _location;
//  String _invoiceCount;
//  RadioBean _startTarget;
//  RadioBean _secondaryDevelopment;
//  RadioBean _progress;
//  String _expectedContractAmount;
//  String _expectedSignDate;
//  String _lnsize;
//  String _companyIntro;
//  String _firstPartyRepresentatives;
//  String _contactWay;
//  String _email;
//  String _title;
//
//  void save() async {
//    if (_clientName.isEmpty) {
//      showTip('请输入客户名称');
//      return;
//    }
//    if (_company.id == 0) {
//      showTip('请选择公司类型');
//      return;
//    }
//    if (_industry.id == 0) {
//      showTip('请选择所属行业');
//      return;
//    }
//    if (_source.id == 0) {
//      showTip('请选择来源类型');
//      return;
//    }
//    if (_location.id == 0) {
//      showTip('请选择所在地');
//      return;
//    }
//
//    if (_invoiceCount.isEmpty) {
//      showTip('请输入年发票量');
//      return;
//    }
//
//    if (_email != null &&
//        _email.isNotEmpty &&
//        !EmailValidator.validate(_email)) {
//      showTip('邮箱格式不正确');
//      return;
//    }
//
//    if (_contactWay == null || _contactWay.isEmpty) {
//      showTip('请输入联系方式');
//      return;
//    }
//    if (_title == null || _title.isEmpty) {
//      showTip('请输入职务');
//      return;
//    }
//    pageLoading();
//    var rsp = await ApiService().newOrSaveClient(
//      _id,
//      _clientName,
//      _company.id,
//      _industry.id,
//      _source.id,
//      _location.id,
//      _invoiceCount,
//      _startTarget.id,
//      _secondaryDevelopment.id,
//      _progress.id,
//      _expectedContractAmount,
//      _expectedSignDate,
//      _lnsize,
//      _companyIntro,
//      _firstPartyRepresentatives,
//      _contactWay,
//      _email,
//      _title,
//    );
//    pageCompleted();
//    if (rsp.code == ApiService.success) {
//      finish(result: true);
//    } else {
//      showTip(rsp.msg);
//    }
//  }
//
//  String get title => _title;
//
//  set title(String value) {
//    if (value != null) _title = value;
//  }
//
//  String get email => _email;
//
//  set email(String value) {
//    if (value != null) _email = value;
//  }
//
//  String get contactWay => _contactWay;
//
//  set contactWay(String value) {
//    if (value != null) _contactWay = value;
//  }
//
//  String get firstPartyRepresentatives => _firstPartyRepresentatives;
//
//  set firstPartyRepresentatives(String value) {
//    if (value != null) _firstPartyRepresentatives = value;
//  }
//
//  String get companyIntro => _companyIntro;
//
//  set companyIntro(String value) {
//    if (value != null) _companyIntro = value;
//  }
//
//  String get lnsize => _lnsize;
//
//  set lnsize(String value) {
//    if (value != null) _lnsize = value;
//  }
//
//  String get expectedSignDate => _expectedSignDate;
//
//  set expectedSignDate(String value) {
//    if (value != null) _expectedSignDate = value;
//  }
//
//  String get expectedContractAmount => _expectedContractAmount;
//
//  set expectedContractAmount(String value) {
//    if (value != null) _expectedContractAmount = value;
//  }
//
//  RadioBean get progress => _progress;
//
//  set progress(RadioBean value) {
//    if (value != null) _progress = value;
//  }
//
//  RadioBean get secondaryDevelopment => _secondaryDevelopment;
//
//  set secondaryDevelopment(RadioBean value) {
//    if (value != null) _secondaryDevelopment = value;
//  }
//
//  RadioBean get startTarget => _startTarget;
//
//  set startTarget(RadioBean value) {
//    if (value != null) _startTarget = value;
//  }
//
//  String get invoiceCount => _invoiceCount;
//
//  set invoiceCount(String value) {
//    if (value != null) _invoiceCount = value;
//  }
//
//  RadioBean get location => _location;
//
//  set location(RadioBean value) {
//    if (value != null) _location = value;
//  }
//
//  RadioBean get source => _source;
//
//  set source(RadioBean value) {
//    if (value != null) _source = value;
//  }
//
//  RadioBean get industry => _industry;
//
//  set industry(RadioBean value) {
//    if (value != null) _industry = value;
//  }
//
//  RadioBean get company => _company;
//
//  set company(RadioBean value) {
//    if (value != null) _company = value;
//  }
//
//  String get clientName => _clientName;
//
//  set clientName(String value) {
//    if (value != null) _clientName = value;
//  }
//
//  int get id => _id;
//
//  set id(int value) {
//    if (value != null) _id = value;
//  }
//}
