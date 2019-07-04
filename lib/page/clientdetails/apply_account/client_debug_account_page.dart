import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/bloc/Bloc.dart';
import 'package:flutter_app/data/http/api_service.dart';
import 'package:flutter_app/data/http/rsp/account_info.dart';
import 'package:flutter_app/data/http/rsp/applied_plugins_rsp.dart';
import 'package:flutter_app/data/http/rsp/department_info.dart';
import 'package:flutter_app/page/base/CommonPageState.dart';
import 'package:rxdart/rxdart.dart';

import '../../../main.dart';
import 'account_info_page1.dart';
import 'account_info_page2.dart';
import 'account_info_page3.dart';
import 'account_info_page4.dart';
import 'client_apply_debug_account_page.dart';

class ClientDebugAccountPage extends StatefulWidget {
  const ClientDebugAccountPage({Key key, this.accountType, this.clientId})
      : super(key: key);

  final int accountType;
  final int clientId;

  @override
  State<StatefulWidget> createState() {
    return ClientDebugAccountPageState();
  }
}

class ClientDebugAccountPageState
    extends CommonPageState<ClientDebugAccountPage, ClientDebugAccountBloc> {
  final List<Tab> _tabs = <Tab>[
    Tab(text: '申请账号'),
    Tab(text: '客户详情'),
    Tab(text: '部门与用户'),
    Tab(text: '发票用量'),
  ];

  List<Widget> _page;

  @override
  void initState() {
    if (bloc == null) {
      bloc = ClientDebugAccountBloc(widget.clientId, widget.accountType);
    }
    bloc.initData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (_page == null) {
      _page = List<Widget>();
      _page.add(AccountInfoPage1());
      _page.add(AccountInfoPage2());
      _page.add(AccountInfoPage3());
      _page.add(AccountInfoPage4());
    }

    return BlocProvider<ClientDebugAccountBloc>(
      bloc: bloc,
      child: DefaultTabController(
        length: _tabs.length,
        child: Scaffold(
          key: scaffoldKey,
          backgroundColor: colorBg,
          appBar: AppBar(
            elevation: 0,
            centerTitle: true,
            title: Text(isRelease(widget.accountType)?'正式账号':'测试账号'),
          ),
          body: Column(
            children: <Widget>[
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
              Flexible(
                child: TabBarView(
                  children: <Widget>[..._page],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class ClientDebugAccountBloc extends CommonBloc {
  ClientDebugAccountBloc(this.clientId, this.accountType);

  final int clientId;
  final int accountType;

  var id = BehaviorSubject<String>();
  var applier = BehaviorSubject<String>();
  var applyTime = BehaviorSubject<String>();
  var passTime = BehaviorSubject<String>();
  var adminName = BehaviorSubject<String>();
  var email = BehaviorSubject<String>();
  var password = BehaviorSubject<String>();
  var peopleCount = BehaviorSubject<String>();
  var function = BehaviorSubject<String>();
  var validity = BehaviorSubject<String>();
  var memo = BehaviorSubject<String>();
  var verifyCount = BehaviorSubject<String>();
  var verifyCountValidity = BehaviorSubject<String>();

  var plugins = BehaviorSubject<List<Plugin>>(seedValue: []);

  var maker = BehaviorSubject<String>();
  var companyName = BehaviorSubject<String>();
  var address = BehaviorSubject<String>();
  var proxy = BehaviorSubject<String>();
  var bank = BehaviorSubject<String>();
  var account = BehaviorSubject<String>();
  var phoneNumber = BehaviorSubject<String>();
  var clientKey = BehaviorSubject<String>();
  var companyKey = BehaviorSubject<String>();
  var companySecret = BehaviorSubject<String>();

  var department = BehaviorSubject<List<Department>>(seedValue: []);
  var user = BehaviorSubject<List<User>>(seedValue: []);


  @override
  void initData() async {
    pageLoading();
    var rsp = await ApiService().accountInfo(
      application_type: accountType.toString(),
      leads_id: clientId.toString(),
    );

    var pluginRsp = await ApiService().appliedPluginList(
      application_type:
          isDebug(accountType) ? accountTypeDebug : accountTypeRelease,
      company_id: clientId.toString(),
    );
    pageCompleted();
    if (rsp.code == ApiService.success) {
      initAccountInfo(rsp);
    } else {
      showTip(rsp.msg);
    }
    if (rsp.code == ApiService.success) {
      initPlugin(pluginRsp);
    } else {
      showTip(rsp.msg);
    }
    return super.initData();
  }

  void initAccountInfo(AccountInfoRsp rsp) {
    id.add(
      accountType == applyTypeReleaseAccount
          ? rsp.data.detail?.first?.fc_company_id?.toString() ?? ''
          : rsp.data.detail?.first?.fc_company_id_test?.toString() ?? '',
    );
    applier.add(rsp.data.detail?.first?.realname?.toString() ?? '');
    applyTime.add(rsp.data.detail?.first?.create_time?.toString() ?? '');
    passTime.add(rsp.data.detail?.first?.agree_time?.toString() ?? '');
    adminName.add(rsp.data.detail?.first?.fc_admin_name?.toString() ?? '');
    email.add(rsp.data.detail?.first?.email?.toString() ?? '');
    password.add(rsp.data.detail?.first?.initial_password?.toString() ?? '');
    peopleCount.add(rsp.data.detail?.first?.staff_limit?.toString() ?? '');
    function.add(rsp.data.detail?.first?.features?.toString() ?? '');
    validity.add(rsp.data.detail?.first?.expire_time?.toString() ?? '');
    memo.add(rsp.data.detail?.first?.memo?.toString() ?? '');
    verifyCount.add(rsp.data.detail?.first?.check_amount?.toString() ?? '');
    verifyCountValidity
        .add(rsp.data.detail?.first?.time_limit?.toString() ?? '');
    initClientInfo(
      accountType == applyTypeReleaseAccount
          ? rsp.data.detail?.first?.fc_company_id?.toString() ?? ''
          : rsp.data.detail?.first?.fc_company_id_test?.toString() ?? '',
    );

    initDepartmentInfo(
      accountType == applyTypeReleaseAccount
          ? rsp.data.detail?.first?.fc_company_id?.toString() ?? ''
          : rsp.data.detail?.first?.fc_company_id_test?.toString() ?? '',
    );
  }

  void initClientInfo(id) async {
    var rsp = await ApiService().clientInfo(id: id);
    if (rsp.code == ApiService.success) {
      maker.add(rsp.data.rows?.first?.creator?.toString() ?? '');

      companyName.add(rsp.data?.rows?.first?.name??'');
      address.add(rsp.data?.rows?.first?.address??'');
      proxy.add(rsp.data?.rows?.first?.channel_name??'');
      bank.add(rsp.data?.rows?.first?.account_bank??'');
      account.add(rsp.data?.rows?.first?.account_number??'');
      phoneNumber.add(rsp.data?.rows?.first?.telephone??'');
      clientKey.add(rsp.data?.rows?.first?.client_key??'');
      companyKey.add(rsp.data?.rows?.first?.company_key??'');
      companySecret.add(rsp.data?.rows?.first?.company_secret??'');

    } else {
      showTip(rsp.msg);
    }
  }
  void initDepartmentInfo(id) async {
    var rsp = await ApiService().department(id: id);
    if (rsp.code == ApiService.success) {
        department.add(rsp.data?.department??[]);
        user.add(rsp.data?.user??[]);
    } else {
      showTip(rsp.msg);
    }
  }

  void initPlugin(AppliedPluginsRsp pluginRsp) {
    var plugins = List<Plugin>.from(pluginRsp.data);
    Plugin ocrPlugin;
    plugins.removeWhere(
      (p) {
        if (p.id == pluginAppOCR ||
            p.id == pluginApiOCR ||
            p.id == pluginWebOCR ||
            p.id == pluginNormalInvoice ||
            p.id == pluginTaxInvoice) {
          if (ocrPlugin == null) {
            ocrPlugin = Plugin(
              pluginRecognition,
              '识别录入',
              p.branch_limit,
              p.expiration_date,
              p.create_time,
              p.quota,
            );
            ocrPlugin.ocrSonPlugins = [];
            ocrPlugin.invoicePlugins = [];
          }
          switch (p.id) {
            case pluginAppOCR:
              ocrPlugin.ocrSonPlugins.add(
                Plugin(
                  pluginAppOCR,
                  'app',
                ),
              );
              break;
            case pluginApiOCR:
              ocrPlugin.ocrSonPlugins.add(
                Plugin(
                  pluginApiOCR,
                  'api',
                ),
              );
              break;
            case pluginWebOCR:
              ocrPlugin.ocrSonPlugins.add(
                Plugin(
                  pluginWebOCR,
                  'web',
                ),
              );
              break;
            case pluginNormalInvoice:
              ocrPlugin.invoicePlugins.add(
                Plugin(
                  pluginNormalInvoice,
                  '非增值税',
                ),
              );

              break;
            case pluginTaxInvoice:
              ocrPlugin.invoicePlugins.add(
                Plugin(
                  pluginTaxInvoice,
                  '增值税',
                ),
              );
              break;
          }
          return true;
        } else {
          return false;
        }
      },
    );
    if (ocrPlugin != null) plugins.add(ocrPlugin);
    this.plugins.add(plugins);
  }
}

Widget buildTitle(label, {List<TextSpan> spans}) {
  return Container(
    padding: EdgeInsets.only(right: 20, left: 20, top: 20, bottom: 7),
    child: RichText(
      text: TextSpan(
          text: label ?? '',
          style: TextStyle(fontSize: 12, color: Colors.grey),
          children: spans),
    ),
  );
}

Widget buildItem(String title, Stream content, {bool showLine = true}) {
  return Container(
    color: Colors.white,
    padding: EdgeInsets.symmetric(horizontal: 20),
    child: Column(
      children: <Widget>[
        Container(
          padding: EdgeInsets.symmetric(vertical: 15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: TextStyle(fontSize: 15),
              ),
              Flexible(
                child: StreamBuilder(
                  initialData: '',
                  stream: content,
                  builder: (c, s) => Text(
                        s.data,
                        style: TextStyle(fontSize: 15, color: Colors.grey),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                ),
              ),
            ],
          ),
        ),
        Opacity(
          child: Divider(
            height: 1,
          ),
          opacity: showLine ? 1 : 0,
        ),
      ],
    ),
  );
}
