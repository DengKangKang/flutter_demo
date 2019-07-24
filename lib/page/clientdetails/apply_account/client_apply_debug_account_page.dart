import 'dart:async';

import 'package:email_validator/email_validator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app/common_route.dart';
import 'package:flutter_app/bloc/Bloc.dart';
import 'package:flutter_app/data/http/api_service.dart';
import 'package:flutter_app/data/http/rsp/applied_plugins_rsp.dart';
import 'package:flutter_app/data/http/rsp/data/RadioBean.dart';
import 'package:flutter_app/data/http/rsp/data/clients_data.dart';
import 'package:flutter_app/page/radio_list_page.dart';
import 'package:flutter_app/page/base/common_page_state.dart';
import 'package:flutter_app/page/clientdetails/apply_account/plugin_setting.dart';
import 'package:flutter_app/weight/tool.dart';
import 'package:intl/intl.dart';
import 'package:rxdart/rxdart.dart';

import '../../../main.dart';
import 'client_debug_account_page.dart';

const pluginNormal = 0;
const pluginGroup = 10;
const pluginRecognition = -1;
const pluginApiOCR = 25; //api  ocr
const pluginAppOCR = 27; //api  ocr
const pluginWebOCR = 3; //api  ocr
const pluginNormalInvoice = 26; //api  ocr
const pluginTaxInvoice = 31; //api  ocr

const applyTypeDebugAccount = 3;
const applyTypeReleaseAccount = 4;
const applyTypeTrain = 1;

const accountTypeDebug = '5';
const accountTypeRelease = '6';

bool isDebug(type) => type == applyTypeDebugAccount;

bool isRelease(type) => type == applyTypeReleaseAccount;

class ClientApplyDebugAccountPage extends StatefulWidget {
  const ClientApplyDebugAccountPage({Key key, this.accountType, this.client})
      : super(key: key);

  final int accountType;
  final Client client;

  @override
  State<StatefulWidget> createState() {
    return ClientDebugAccountPageState();
  }
}

class ClientDebugAccountPageState extends CommonPageState<
    ClientApplyDebugAccountPage, ClientApplyDebugAccountBloc> {
  ScrollController _scrollController;

  @override
  void initState() {
    if (bloc == null) {
      bloc = ClientApplyDebugAccountBloc(widget.accountType, widget.client.id);
      bloc.initData();
    }
    if (isDebug(widget.accountType)) {
      bloc.personnelLimit.write('5');
    }
    _scrollController = ScrollController(
      initialScrollOffset: 0.0,
      keepScrollOffset: true,
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: colorBg,
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        title: Text(isDebug(widget.accountType) ? '测试账号' : '正式账号'),
        actions: <Widget>[
          InkWell(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Center(
                child: Text(
                  '申请',
                  style: TextStyle(
                    fontSize: 15,
                    color: colorOrigin,
                  ),
                ),
              ),
            ),
            onTap: () {
              bloc.apply(widget.client.id, widget.accountType,
                  widget.client.leads_name);
            },
          )
        ],
      ),
      body: ListView(
        controller: _scrollController,
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(top: 10),
            child: Material(
                color: Colors.white,
                elevation: defaultElevation / 2,
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              Text(
                                'id:' + widget.client.id?.toString() ?? '',
                                style:
                                    TextStyle(fontSize: 13, color: Colors.grey),
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
                                  widget.client.source_name ?? '',
                                  style: TextStyle(
                                      fontSize: 9, color: Color(0xFF3389FF)),
                                ),
                              )
                            ],
                          ),
                          Container(
                            margin: EdgeInsets.only(left: 6),
                            child: Image.asset(
                              widget.client.is_important == yes
                                  ? 'assets/images/ico_zd_checked.png'
                                  : 'assets/images/ico_zd.png',
                              color: widget.client.is_important == yes
                                  ? colorOrigin
                                  : Colors.grey,
                            ),
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
                          crossAxisAlignment: CrossAxisAlignment.baseline,
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
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                              widget.client.leads_mobile,
                              style: TextStyle(fontSize: 13),
                            ),
                            Image.asset("assets/images/ico_dh.png"),
                          ],
                        ),
                      ),
                    ],
                  ),
                )),
          ),
          buildTitle('账号有效期'),
          buildClickableItem(
            label: '有效期',
            hint: '请选择日期',
            content: bloc.validity,
            onClick: () async {
              var date = await showDatePicker(
                context: context,
                initialDate: bloc.validity.value?.isNotEmpty == true
                    ? DateTime.parse(bloc.validity.value)
                    : DateTime.now(),
                firstDate: DateTime(
                  DateTime.now().year,
                  DateTime.now().month,
                  DateTime.now().day,
                ),
                lastDate: DateTime(DateTime.now().year + 10, 12, 31),
              );
              if (date != null) {
                bloc.validity.value = DateFormat('yyyy-MM-dd').format(date);
              }
            },
            showLine: false,
          ),
          buildTitle('基础信息'),
          buildInputItem(
            label: '管理员姓名',
            hint: '请输入管理员姓名',
            content: bloc.adminName,
          ),
          buildInputItem(
            label: '邮箱',
            hint: '请输入邮箱',
            content: bloc.email,
            inputType: TextInputType.emailAddress,
          ),
          buildInputItem(
            label: '初始密码',
            hint: '请输入初始密码',
            content: bloc.password,
            inputType: TextInputType.emailAddress,
          ),
          buildInputItem(
              label: '人员上限',
              hint: '请输入人员限',
              content: bloc.personnelLimit,
              inputFormatters: [WhitelistingTextInputFormatter.digitsOnly],
              inputType: TextInputType.number,
              enabled: isRelease(widget.accountType)),
          Visibility(
            visible: isRelease(widget.accountType),
            child: buildInputItem(
              label: '功能模块',
              hint: '请输入功能模块',
              content: bloc.function,
            ),
          ),
          Container(
            color: Colors.white,
            padding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  '备注',
                  style: TextStyle(fontSize: 15),
                ),
                Container(
                  padding: EdgeInsets.all(10),
                  height: 83,
                  width: double.infinity,
                  margin: EdgeInsets.only(top: 10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(4)),
                    border: Border.all(color: Color(0xFFF1F1F1)),
                  ),
                  child: TextField(
                    maxLines: null,
                    keyboardType: TextInputType.multiline,
                    decoration: InputDecoration(
                      hintText: '请输入备注内容',
                      hintStyle: TextStyle(fontSize: 15),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.all(0),
                    ),
                  ),
                )
              ],
            ),
          ),
          buildTitle('票量信息'),
          buildInputItem(
            label: '查验发票量',
            hint: '请输入查验发票量',
            content: bloc.verifyLimit,
            inputFormatters: [WhitelistingTextInputFormatter.digitsOnly],
            inputType: TextInputType.number,
          ),
          buildClickableItem(
            label: '失效日期',
            hint: '请选择日期',
            content: bloc.verifyCountValidity,
            onClick: () async {
              var date = await showDatePicker(
                context: context,
                initialDate: bloc.verifyCountValidity.value?.isNotEmpty == true
                    ? DateTime.parse(bloc.verifyCountValidity.value)
                    : DateTime.now(),
                firstDate: DateTime(
                  DateTime.now().year,
                  DateTime.now().month,
                  DateTime.now().day,
                ),
                lastDate: DateTime(DateTime.now().year + 10, 12, 31),
              );
              if (date != null) {
                bloc.verifyCountValidity.value =
                    DateFormat('yyyy-MM-dd').format(date);
              }
            },
            showLine: false,
          ),
          buildButtonTitle(
            '插件信息',
            '新增插件',
            'assets/images/ico_lb_tj.png',
            () {
              addPlugin(context);
            },
          ),
          StreamBuilder<List<Plugin>>(
            initialData: [],
            stream: bloc.plugins,
            builder: (c, s) {
              return s.data.isNotEmpty
                  ? Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[...s.data.map((e) => buildPlugin(e))],
                    )
                  : Container(
                      margin: EdgeInsets.only(bottom: 20),
                      color: Colors.white,
                      padding:
                          EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                      child: Text(
                        '暂无内容',
                        style: TextStyle(
                          fontSize: 15,
                          color: Colors.grey,
                        ),
                      ),
                    );
            },
          ),
        ],
      ),
    );
  }

  void addPlugin(BuildContext context) async {
    onLoading(context);
    var rsp = await ApiService().pluginList();
    loadingFinish(context);
    if (rsp.code == ApiService.success && rsp.data != null) {
      rsp.data.add(
        RadioBean(pluginRecognition, '识别录入'),
      );
      RadioBean result = await showDialog(
        context: context,
        builder: (context) {
          return RadioListPage(
            rsp.data,
          );
        },
      );
      if (result == null) return;
      Plugin selectedPlugin;
      switch (result?.id) {
        case pluginGroup:
          selectedPlugin = Plugin(result?.id, result.name);
          break;
        case pluginRecognition:
          selectedPlugin = Plugin(result?.id, result.name);
          break;
        default:
          selectedPlugin = Plugin(result?.id, result.name);
          break;
      }
      var refresh = await Navigator.push(
        context,
        CommonRoute(
          builder: (c) => PluginSetting(
            plugin: selectedPlugin,
            accountType: widget.accountType,
            clientId: widget.client.id,
          ),
        ),
      );

      if (refresh == true) {
        await bloc.initData();
        Future.delayed(
          Duration(milliseconds: 500),
          () {
            _toEnd();
          },
        );
      }
    } else {
      bloc.showTip(rsp.msg);
    }
  }

  Widget buildPlugin(Plugin plugin) {
    Widget pluginWidget;

    switch (plugin.id) {
      case pluginGroup:
        pluginWidget = buildGroupPlugin(plugin);
        break;
      case pluginRecognition:
        pluginWidget = buildRecognitionPlugin(plugin);
        break;
      default:
        pluginWidget = buildNormalPlugin(plugin);
        break;
    }
    return GestureDetector(
      child: pluginWidget,
      onTap: () async {
        var result = await Navigator.push(
          context,
          CommonRoute(
            builder: (c) => PluginSetting(
              plugin: plugin,
              accountType: widget.accountType,
              clientId: widget.client.id,
              isEdit: true,
            ),
          ),
        );
        print(result);
        if (result == true) {
          bloc.initData();
        }
      },
    );
  }

  Widget buildNormalPlugin(Plugin plugin) {
    return Container(
      margin: EdgeInsets.only(bottom: 10),
      child: Material(
        color: Colors.white,
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    plugin.name,
                    style: TextStyle(
                      fontSize: 15,
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 5),
                    child: Text(
                      '有效期： ${plugin.create_time} - ${plugin.expiration_date} ',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                ],
              ),
              InkWell(
                child: Image.asset("assets/images/ico_xq_sc.png"),
                onTap: () {
                  deletePlugin(plugin);
                },
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget buildGroupPlugin(Plugin plugin) {
    return Container(
      margin: EdgeInsets.only(bottom: 10),
      child: Material(
        color: Colors.white,
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        plugin.name,
                        style: TextStyle(
                          fontSize: 15,
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 5),
                        child: Text(
                          '有效期： ${plugin.create_time} - ${plugin.expiration_date} ',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    ],
                  ),
                  InkWell(
                    child: Image.asset("assets/images/ico_xq_sc.png"),
                    onTap: () {
                      deletePlugin(plugin);
                    },
                  )
                ],
              ),
              Container(
                margin: EdgeInsets.symmetric(vertical: 10),
                child: Divider(
                  color: colorDivider,
                  height: 1,
                ),
              ),
              Row(
                textBaseline: TextBaseline.ideographic,
                crossAxisAlignment: CrossAxisAlignment.baseline,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    '集团子公司数量',
                    style: TextStyle(fontSize: 15),
                  ),
                  Text(
                    '${plugin.branch_limit ?? 0}',
                    style: TextStyle(fontSize: 15),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget buildRecognitionPlugin(Plugin plugin) {
    return Container(
      margin: EdgeInsets.only(bottom: 10),
      child: Material(
        color: Colors.white,
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        plugin.name,
                        style: TextStyle(
                          fontSize: 15,
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 5),
                        child: Text(
                          '有效期： ${plugin.create_time} - ${plugin.expiration_date} ',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    ],
                  ),
                  InkWell(
                    child: Image.asset("assets/images/ico_xq_sc.png"),
                    onTap: () {
                      deletePlugin(plugin);
                    },
                  )
                ],
              ),
              Container(
                margin: EdgeInsets.symmetric(vertical: 10),
                child: Divider(
                  color: colorDivider,
                  height: 1,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    '入口',
                    style: TextStyle(fontSize: 15),
                  ),
                  Row(
                    children: <Widget>[
                      ...plugin.ocrSonPlugins.map((p) => Container(
                            margin: EdgeInsets.only(left: 10),
                            height: 20,
                            width: 50,
                            decoration: BoxDecoration(
                              color: colorBlueLight,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20)),
                            ),
                            child: Center(
                              child: Text(
                                p.name,
                                style: TextStyle(
                                  color: colorBlue,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ))
                    ],
                  ),
                ],
              ),
              Container(
                margin: EdgeInsets.symmetric(vertical: 10),
                child: Divider(
                  color: colorDivider,
                  height: 1,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    '能力配置',
                    style: TextStyle(fontSize: 15),
                  ),
                  Row(
                    children: <Widget>[
                      ...plugin.invoicePlugins.map((p) => Container(
                            margin: EdgeInsets.only(left: 10),
                            padding: EdgeInsets.symmetric(horizontal: 10),
                            height: 20,
                            decoration: BoxDecoration(
                              color: colorBlueLight,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20)),
                            ),
                            child: Center(
                              child: Text(
                                p.name,
                                style: TextStyle(
                                  color: colorBlue,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ))
                    ],
                  ),
                ],
              ),
              Container(
                margin: EdgeInsets.symmetric(vertical: 10),
                child: Divider(
                  color: colorDivider,
                  height: 1,
                ),
              ),
              Column(
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(bottom: 5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          '计费类型',
                          style: TextStyle(fontSize: 15),
                        ),
                        Text(
                          billTypeIsClassify(plugin) ? '分类计费' : '通用计费',
                          style: TextStyle(fontSize: 15),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    height: billTypeIsClassify(plugin) ? 0 : null,
                    padding: EdgeInsets.only(top: 5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          '发票量',
                          style: TextStyle(fontSize: 15),
                        ),
                        Text(
                          plugin.quota
                                  ?.firstWhere(
                                    (e) => e.category == 7,
                                    orElse: () => null,
                                  )
                                  ?.quota
                                  ?.toString() ??
                              '0',
                          style: TextStyle(fontSize: 15),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    height: billTypeIsClassify(plugin) ? null : 0,
                    padding: EdgeInsets.only(top: 5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          '增值税发票',
                          style: TextStyle(fontSize: 15),
                        ),
                        Text(
                          plugin.quota
                                  ?.firstWhere(
                                    (e) => e.category == 2,
                                    orElse: () => null,
                                  )
                                  ?.quota
                                  ?.toString() ??
                              '0',
                          style: TextStyle(fontSize: 15),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    height: billTypeIsClassify(plugin) ? null : 0,
                    padding: EdgeInsets.only(top: 5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          '其他发票量',
                          style: TextStyle(fontSize: 15),
                        ),
                        Text(
                          plugin.quota
                                  ?.firstWhere(
                                    (e) => e.category == 3,
                                    orElse: () => null,
                                  )
                                  ?.quota
                                  ?.toString() ??
                              '0',
                          style: TextStyle(fontSize: 15),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    height: billTypeIsClassify(plugin) ? null : 0,
                    padding: EdgeInsets.only(top: 5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          '定额发票量',
                          style: TextStyle(fontSize: 15),
                        ),
                        Text(
                          plugin.quota
                                  ?.firstWhere(
                                    (e) => e.category == 4,
                                    orElse: () => null,
                                  )
                                  ?.quota
                                  ?.toString() ??
                              '0',
                          style: TextStyle(fontSize: 15),
                        ),
                      ],
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  void deletePlugin(Plugin plugin) async {
    var rsp = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('提示?'),
        content: Text('确定删除该插件？'),
        actions: <Widget>[
          FlatButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text('否'),
          ),
          FlatButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text('是'),
          ),
        ],
      ),
    );
    if (rsp) {
      bloc.pageLoading();

      var rsp = await ApiService().deletePlugin(
        application_type:
            isDebug(widget.accountType) ? accountTypeDebug : accountTypeRelease,
        leads_id: widget.client.id.toString(),
        plugin_id: plugin.ocrSonPlugins != null || plugin.invoicePlugins != null
            ? plugin.ocrSonPlugins.map((e) => e.id).join(',') +
                ',' +
                plugin.invoicePlugins.map((e) => e.id).join(',')
            : plugin.id.toString(),
      );
      bloc.pageCompleted();
      if (rsp.code == ApiService.success) {
        bloc.initData();
      } else {
        bloc.showTip(rsp.msg);
      }
    }
  }

  void _toEnd() async {
    await _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: const Duration(milliseconds: 500),
      curve: Curves.ease,
    );
  }
}

class ClientApplyDebugAccountBloc extends CommonBloc {
  ClientApplyDebugAccountBloc(this.accountType, this.clientId);

  final accountType;
  final clientId;

  var validity = BehaviorSubject<String>();
  StringBuffer adminName = StringBuffer();
  StringBuffer email = StringBuffer();
  StringBuffer password = StringBuffer();
  StringBuffer personnelLimit = StringBuffer();
  StringBuffer memo = StringBuffer();

  StringBuffer verifyLimit = StringBuffer();
  StringBuffer function = StringBuffer();
  var verifyCountValidity = BehaviorSubject<String>();

  var plugins = BehaviorSubject<List<Plugin>>(seedValue: []);

  @override
  void initData() async {
    pageLoading();
    var rsp = await ApiService().appliedPluginList(
      application_type:
          isDebug(accountType) ? accountTypeDebug : accountTypeRelease,
      company_id: clientId.toString(),
    );
    pageCompleted();
    if (rsp.code == ApiService.success) {
      var plugins = List<Plugin>.from(rsp.data);
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
    } else {
      showTip(rsp.msg);
    }
    return super.initData();
  }

  void apply(id, accountType, leads_name) async {
    if (validity.value == null || validity.value.isEmpty) {
      showTip('请选择有效期');
      return;
    }
    if (adminName.isEmpty) {
      showTip('请输入管理员姓名');
      return;
    }
    if (email.isEmpty) {
      showTip('请输入邮箱');
      return;
    }
    if (!EmailValidator.validate(email.toString())) {
      showTip('邮箱格式不正确');
      return;
    }
    if (password.isEmpty) {
      showTip('请输入初始密码');
      return;
    }
    if (personnelLimit.isEmpty) {
      showTip('请输入人员上限');
      return;
    }
    if (function.isEmpty && isRelease(accountType)) {
      showTip('请输入功能模块');
      return;
    }
    if (verifyLimit.isEmpty) {
      showTip('请输入发票量');
      return;
    }
    if (verifyCountValidity.value == null ||
        verifyCountValidity.value.isEmpty) {
      showTip('请选择查验发票量有效期');
      return;
    }
    pageLoading();
    var rsp = await ApiService().apply(
      application_type: accountType.toString(),
      leads_id: id.toString(),
      expire_time: validity.value,
      fc_admin_name: adminName.toString(),
      email: email.toString(),
      initial_password: password.toString(),
      staff_limit: personnelLimit.toString(),
      memo: memo.toString(),
      check_amount: verifyLimit.toString(),
      time_limit: verifyCountValidity.value,
      leads_name: leads_name,
      features: function.toString(),
    );
    pageCompleted();
    if (rsp.code == ApiService.success) {
      finish(result: true);
    } else {
      showTip(rsp.msg);
    }
  }
}

Widget buildInputItem({
  String label,
  List<TextSpan> spans,
  String hint,
  StringBuffer content,
  List<TextInputFormatter> inputFormatters,
  TextInputType inputType,
  bool showLine = true,
  bool enabled = true,
}) {
  return Container(
    color: Colors.white,
    padding: EdgeInsets.symmetric(horizontal: 20),
    child: Column(
      children: <Widget>[
        Container(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              RichText(
                text: TextSpan(
                  text: label ?? '',
                  style: TextStyle(fontSize: 15, color: Colors.black),
                  children: spans,
                ),
              ),
              Flexible(
                child: TextField(
                  controller: TextEditingController.fromValue(
                    TextEditingValue(
                      text: content.toString(),
                      selection: TextSelection.collapsed(
                        offset: content.length,
                      ),
                    ),
                  ),
                  textAlign: TextAlign.end,
                  inputFormatters: inputFormatters,
                  keyboardType: inputType,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.only(
                      left: 15,
                      right: 0,
                      top: 15,
                      bottom: 15,
                    ),
                    hintText: hint,
                    border: InputBorder.none,
                  ),
                  style: TextStyle(fontSize: 15),
                  enabled: enabled,
                  onChanged: (s) {
                    if (content.isNotEmpty) content.clear();
                    content.write(s);
                  },
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

Widget buildClickableItem({
  String label,
  List<TextSpan> spans,
  String hint,
  Stream content,
  VoidCallback onClick,
  bool showLine = true,
}) {
  return Material(
    color: Colors.white,
    child: InkWell(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: <Widget>[
            Container(
              padding: EdgeInsets.symmetric(vertical: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  RichText(
                    text: TextSpan(
                        text: label ?? '',
                        style: TextStyle(fontSize: 15, color: Colors.black),
                        children: spans),
                  ),
                  Row(
                    children: <Widget>[
                      StreamBuilder(
                        initialData: hint,
                        stream: content,
                        builder: (b, s) => Text(
                          s.data?.toString() ?? '',
                          style: TextStyle(
                            fontSize: 15,
                            color: s.data == hint ? Colors.grey : Colors.black,
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 5),
                        child: Image.asset('assets/images/ico_me_jt.png'),
                      ),
                    ],
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
      ),
      onTap: onClick,
    ),
  );
}

Widget buildButtonTitle(label, actionLabel, actionIcon, action) {
  return Container(
    padding: EdgeInsets.only(
      right: 20,
      left: 20,
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Container(
          margin: EdgeInsets.only(top: 20, bottom: 7),
          child: Text(
            label,
            style: TextStyle(fontSize: 12, color: Colors.grey),
          ),
        ),
        Container(
            margin: EdgeInsets.only(top: 20, bottom: 7),
            child: InkWell(
              child: Row(
                children: <Widget>[
                  Image.asset(actionIcon),
                  Container(
                    margin: EdgeInsets.only(left: 5),
                    child: Text(actionLabel),
                  )
                ],
              ),
              onTap: action,
            )),
      ],
    ),
  );
}

Widget buildSwitchItem(
  String label,
  Stream value,
  ValueChanged<bool> onChanged, [
  bool showLine = true,
]) {
  return Container(
    color: Colors.white,
    padding: EdgeInsets.symmetric(horizontal: 20),
    child: Column(
      children: <Widget>[
        Container(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                label,
                style: TextStyle(fontSize: 15),
              ),
              StreamBuilder<bool>(
                initialData: false,
                stream: value,
                builder: (c, s) => Switch(
                  activeColor: colorOrigin,
                  onChanged: onChanged,
                  value: s.data,
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

bool billTypeIsClassify(plugin) {
  return plugin.quota?.firstWhere(
        (e) => e.category == 7,
        orElse: () => null,
      ) ==
      null;
}
