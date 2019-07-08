import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app/bloc/Bloc.dart';
import 'package:flutter_app/data/http/api_service.dart';
import 'package:flutter_app/data/http/rsp/applied_plugins_rsp.dart';
import 'package:flutter_app/data/http/rsp/data/RadioBean.dart';
import 'package:flutter_app/main.dart';
import 'package:flutter_app/page/base/CommonPageState.dart';
import 'package:flutter_app/page/clientdetails/apply_account/client_debug_account_page.dart';
import 'package:flutter_app/weight/Tool.dart';
import 'package:intl/intl.dart';
import 'package:rxdart/rxdart.dart';

import '../../RadioListPage.dart';
import 'client_apply_debug_account_page.dart';

class PluginSetting extends StatefulWidget {
  PluginSetting({
    Key key,
    this.accountType,
    this.plugin,
    this.clientId,
    this.isEdit = false,
  }) : super(key: key);
  final Plugin plugin;
  final accountType;
  final clientId;
  final isEdit;

  @override
  State<StatefulWidget> createState() {
    return PluginSettingState();
  }
}

class PluginSettingState
    extends CommonPageState<PluginSetting, PluginSettingBloc> {
  @override
  void initState() {
    if (bloc == null) bloc = PluginSettingBloc();
    if (widget.plugin.create_time != null &&
        widget.plugin.create_time.isNotEmpty) {
      bloc.validityStart.value = widget.plugin.create_time;
    }
    if (widget.plugin.expiration_date != null &&
        widget.plugin.expiration_date.isNotEmpty) {
      bloc.validityEnd.value = widget.plugin.expiration_date;
    }
    if (widget.plugin.branch_limit != null) {
      bloc.subsidiaryCorporation.write(widget.plugin.branch_limit);
    }

    if (widget.plugin.ocrSonPlugins?.firstWhere(
          (e) => e.id == pluginWebOCR,
          orElse: () => null,
        ) !=
        null) {
      bloc.webOCR.add(true);
    }
    if (widget.plugin.ocrSonPlugins?.firstWhere(
          (e) => e.id == pluginApiOCR,
          orElse: () => null,
        ) !=
        null) {
      bloc.apiOCR.add(true);
    }
    if (widget.plugin.ocrSonPlugins?.firstWhere(
          (e) => e.id == pluginAppOCR,
          orElse: () => null,
        ) !=
        null) {
      bloc.appOCR.add(true);
    }
    if (widget.plugin.invoicePlugins?.firstWhere(
          (e) => e.id == pluginTaxInvoice,
          orElse: () => null,
        ) !=
        null) {
      bloc.taxInvoice.add(true);
    }
    if (widget.plugin.invoicePlugins?.firstWhere(
          (e) => e.id == pluginNormalInvoice,
          orElse: () => null,
        ) !=
        null) {
      bloc.normalInvoice.add(true);
    }
    if (billTypeIsClassify(widget.plugin)) {
      bloc.billingType.add(billingTypes.first);
    } else {
      bloc.billingType.add(billingTypes[1]);
    }

    if (widget.plugin.quota != null) {
      bloc.allQuota.write(widget.plugin.quota
              ?.firstWhere(
                (e) => e.category == 7,
                orElse: () => null,
              )
              ?.quota
              ?.toString() ??
          '0');
      bloc.quota1.write(widget.plugin.quota
              ?.firstWhere(
                (e) => e.category == 2,
                orElse: () => null,
              )
              ?.quota
              ?.toString() ??
          '0');
      bloc.quota2.write(widget.plugin.quota
              ?.firstWhere(
                (e) => e.category == 3,
                orElse: () => null,
              )
              ?.quota
              ?.toString() ??
          '0');
      bloc.quota3.write(widget.plugin.quota
              ?.firstWhere(
                (e) => e.category == 4,
                orElse: () => null,
              )
              ?.quota
              ?.toString() ??
          '0');
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var children = <Widget>[
      Container(
        margin: EdgeInsets.only(top: 10),
        child: Material(
          color: Colors.white,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(
                  margin: EdgeInsets.symmetric(vertical: 15),
                  child: Text('有效期'),
                ),
                Row(
                  children: <Widget>[
                    InkWell(
                      borderRadius: BorderRadius.all(Radius.circular(5)),
                      child: Container(
                        padding: EdgeInsets.all(7),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(5)),
                            border: Border.all(
                              color: Colors.grey,
                            )),
                        child: StreamBuilder(
                          initialData: '开始日期',
                          stream: bloc.validityStart.stream,
                          builder: (c, s) => Text(
                                s.data,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey,
                                ),
                              ),
                        ),
                      ),
                      onTap: () async {
                        var date = await showDatePicker(
                          context: context,
                          initialDate:
                              bloc.validityStart.value?.isNotEmpty == true
                                  ? DateTime.parse(
                                      bloc.validityStart.value,
                                    )
                                  : DateTime.now(),
                          firstDate: DateTime(DateTime.now().year,
                              DateTime.now().month, DateTime.now().day),
                          lastDate: DateTime(DateTime.now().year + 10, 12, 31),
                        );
                        if (date != null) {
                          bloc.validityStart.value =
                              DateFormat('yyyy-MM-dd').format(date);
                        }
                      },
                    ),
                    Container(
                      width: 10,
                      margin: EdgeInsets.symmetric(horizontal: 10),
                      child: Divider(
                        height: 2,
                        color: Colors.grey,
                      ),
                    ),
                    InkWell(
                      borderRadius: BorderRadius.all(Radius.circular(5)),
                      child: Container(
                        padding: EdgeInsets.all(7),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(5)),
                            border: Border.all(
                              color: Colors.grey,
                            )),
                        child: StreamBuilder(
                          initialData: '结束日期',
                          stream: bloc.validityEnd.stream,
                          builder: (c, s) => Text(
                                s.data,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey,
                                ),
                              ),
                        ),
                      ),
                      onTap: () async {
                        var date = await showDatePicker(
                          context: context,
                          initialDate: bloc.validityEnd.value?.isNotEmpty ==
                                  true
                              ? DateTime.parse(
                                  bloc.validityEnd.value,
                                )
                              : bloc.validityStart.value?.isNotEmpty == true
                                  ? DateTime(
                                      DateTime.parse(bloc.validityStart.value)
                                          .year,
                                      DateTime.parse(bloc.validityStart.value)
                                          .month,
                                      DateTime.parse(bloc.validityStart.value)
                                              .day +
                                          1,
                                    )
                                  : DateTime.now(),
                          firstDate: bloc.validityStart.value?.isNotEmpty ==
                                  true
                              ? DateTime(
                                  DateTime.parse(bloc.validityStart.value).year,
                                  DateTime.parse(bloc.validityStart.value)
                                      .month,
                                  DateTime.parse(bloc.validityStart.value).day +
                                      1,
                                )
                              : DateTime(DateTime.now().year,
                                  DateTime.now().month, DateTime.now().day),
                          lastDate: DateTime(DateTime.now().year + 10, 12, 31),
                        );
                        if (date != null) {
                          bloc.validityEnd.value =
                              DateFormat('yyyy-MM-dd').format(date);
                        }
                      },
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    ];
    switch (widget.plugin.id) {
      case pluginGroup:
        children.add(
          Divider(
            height: 10,
            color: colorBg,
          ),
        );
        children.add(
          buildInputItem(
            label: '集团子公司数量',
            hint: '请输入集团子公司数量',
            content: bloc.subsidiaryCorporation,
            showLine: false,
            inputFormatters: [
              WhitelistingTextInputFormatter.digitsOnly
            ],
            inputType: TextInputType.number,
          ),
        );
        break;

      case pluginRecognition:
        children.add(
          buildTitle(
            null,
            spans: [
              TextSpan(
                  text: '*',
                  style: TextStyle(fontSize: 12, color: colorOrigin)),
              TextSpan(
                  text: '入口选择',
                  style: TextStyle(fontSize: 12, color: Colors.grey)),
              TextSpan(
                  text: '(可复选)',
                  style: TextStyle(fontSize: 12, color: colorOrigin)),
            ],
          ),
        );
        children.add(
          buildSwitchItem(
            'web-ocr',
            bloc.webOCR,
            (b) {
              bloc.webOCR.add(b);
            },
          ),
        );
        children.add(
          buildSwitchItem(
            'api-ocr',
            bloc.apiOCR,
            (b) {
              bloc.apiOCR.add(b);
            },
          ),
        );
        children.add(
          buildSwitchItem(
            'app-ocr',
            bloc.appOCR,
            (b) {
              bloc.appOCR.add(b);
            },
            false,
          ),
        );
        children.add(
          buildTitle(null, spans: [
            TextSpan(
                text: '*', style: TextStyle(fontSize: 12, color: colorOrigin)),
            TextSpan(
                text: '能力配置',
                style: TextStyle(fontSize: 12, color: Colors.grey)),
            TextSpan(
                text: '(可复选)',
                style: TextStyle(fontSize: 12, color: colorOrigin)),
          ]),
        );
        children.add(
          buildSwitchItem(
            '非增值税发票',
            bloc.normalInvoice,
            (b) {
              bloc.normalInvoice.add(b);
              print('normalInvoice  ${bloc.normalInvoice.value}');
            },
          ),
        );
        children.add(
          buildSwitchItem(
            '增值税发票',
            bloc.taxInvoice,
            (b) {
              bloc.taxInvoice.add(b);
              print('taxInvoice  ${bloc.taxInvoice.value}');
            },
            false,
          ),
        );
        children.add(
          Divider(
            height: 10,
            color: colorBg,
          ),
        );

        children.add(
          buildClickableItem(
              label: '计费类型',
              hint: '',
              content: bloc.billingType,
              onClick: () async {
                RadioBean result = await showDialog(
                  context: context,
                  builder: (context) {
                    return RadioListPage(billingTypes);
                  },
                );
                print(result);
                if (result != null) {
                  bloc.billingType.add(result);
                }
              }),
        );

        children.add(StreamBuilder<RadioBean>(
          initialData: billingTypes[1],
          stream: bloc.billingType,
          builder: (c, s) {
            if (s.data.id == billTypeClassify) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  buildInputItem(
                    label: '增值税发票',
                    hint: '请输入识别票量',
                    content: bloc.quota1,
                    inputFormatters: [
                      WhitelistingTextInputFormatter.digitsOnly
                    ],
                    inputType: TextInputType.number,
                  ),
                  buildInputItem(
                    label: '其他发票量',
                    hint: '请输入识别票量',
                    content: bloc.quota2,
                    inputFormatters: [
                      WhitelistingTextInputFormatter.digitsOnly
                    ],
                    inputType: TextInputType.number,
                  ),
                  buildInputItem(
                    label: '定额发票量',
                    hint: '请输入识别票量',
                    content: bloc.quota3,
                    inputFormatters: [
                      WhitelistingTextInputFormatter.digitsOnly
                    ],
                    inputType: TextInputType.number,
                    showLine: false,
                  ),
                ],
              );
            } else {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  buildInputItem(
                    label: '发票量',
                    hint: '请输入识别票量',
                    content: bloc.allQuota,
                    inputFormatters: [
                      WhitelistingTextInputFormatter.digitsOnly
                    ],
                    inputType: TextInputType.number,
                    showLine: false,
                  ),
                ],
              );
            }
          },
        ));
        break;
    }

    return Scaffold(
      key: scaffoldKey,
      backgroundColor: colorBg,
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        title: Text(widget.plugin.name),
      ),
      body: Column(
        children: <Widget>[
          Flexible(
            child: ListView(
              physics: BouncingScrollPhysics(),
              children: children,
            ),
          ),
          Material(
            color: Colors.white,
            elevation: defaultElevation,
            child: InkWell(
              child: Container(
                height: 60,
                child: Center(
                  child: Text(
                    '确定',
                    style: TextStyle(
                      fontSize: 17,
                      color: colorOrigin,
                    ),
                  ),
                ),
              ),
              onTap: confirm,
            ),
          )
        ],
      ),
    );
  }

  void confirm() async {
    if (bloc.validityStart.value == null || bloc.validityStart.value.isEmpty) {
      bloc.showTip('请选择开始日期');
      return;
    }
    if (bloc.validityEnd.value == null || bloc.validityEnd.value.isEmpty) {
      bloc.showTip('请结束选择日期');
      return;
    }
    if (widget.plugin.id == pluginGroup && bloc.subsidiaryCorporation.isEmpty) {
      bloc.showTip('请输入集团子公司数量');
      return;
    }

    if (widget.plugin.id == pluginRecognition &&
        !bloc.appOCR.value &&
        !bloc.apiOCR.value &&
        !bloc.webOCR.value) {
      bloc.showTip('入口选择即能力配置均为必填项');
      return;
    }

    if (widget.plugin.id == pluginRecognition &&
        !bloc.taxInvoice.value &&
        !bloc.normalInvoice.value) {
      bloc.showTip('入口选择即能力配置均为必填项');
      return;
    }

    if (widget.plugin.id == pluginRecognition &&
        bloc.billingType.value.id == billTypeCommon &&
        bloc.allQuota.isEmpty) {
      bloc.showTip('请输入发票量');
      return;
    }
    if (widget.plugin.id == pluginRecognition &&
        bloc.billingType.value.id == billTypeClassify &&
        bloc.quota1.isEmpty) {
      bloc.showTip('请输入增值税发票量');
      return;
    }
    if (widget.plugin.id == pluginRecognition &&
        bloc.billingType.value.id == billTypeClassify &&
        bloc.quota2.isEmpty) {
      bloc.showTip('请输入其他发票量');
      return;
    }
    if (widget.plugin.id == pluginRecognition &&
        bloc.billingType.value.id == billTypeClassify &&
        bloc.quota3.isEmpty) {
      bloc.showTip('请输入定额发票量');
      return;
    }
    onLoading(context);
    var rsp;
    if (widget.plugin.id == pluginRecognition) {
      if (bloc.webOCR.value) bloc.plugins.add(pluginWebOCR);
      if (bloc.apiOCR.value) bloc.plugins.add(pluginApiOCR);
      if (bloc.appOCR.value) bloc.plugins.add(pluginAppOCR);
      if (bloc.normalInvoice.value) bloc.plugins.add(pluginNormalInvoice);
      if (bloc.taxInvoice.value) bloc.plugins.add(pluginTaxInvoice);
    } else {
      bloc.plugins.add(widget.plugin.id);
    }
    if (widget.isEdit) {
      rsp = await ApiService().modifyPlugin(
        application_type:
            isDebug(widget.accountType) ? accountTypeDebug : accountTypeRelease,
        company_id: widget.clientId.toString(),
        plugin_id: bloc.plugins.join(',') ?? '',
        start_time: bloc.validityStart.value,
        end_time: bloc.validityEnd.value,
        branch_limit: bloc.subsidiaryCorporation.toString() ?? '',
        radiovalue: bloc.billingType.value?.id?.toString() ?? '',
        allquota: bloc.allQuota.toString() ?? '',
        quota_1: bloc.quota1.toString() ?? '',
        quota_2: bloc.quota2.toString() ?? '',
        quota_3: bloc.quota3.toString() ?? '',
      );
    } else {
      rsp = await ApiService().addPlugin(
        application_type:
            isDebug(widget.accountType) ? accountTypeDebug : accountTypeRelease,
        company_id: widget.clientId.toString(),
        plugin_id: bloc.plugins.join(',') ?? '',
        start_time: bloc.validityStart.value,
        end_time: bloc.validityEnd.value,
        branch_limit: bloc.subsidiaryCorporation.toString() ?? '',
        radiovalue: bloc.billingType.value?.id?.toString() ?? '',
        allquota: bloc.allQuota.toString() ?? '',
        quota_1: bloc.quota1.toString() ?? '',
        quota_2: bloc.quota2.toString() ?? '',
        quota_3: bloc.quota3.toString() ?? '',
      );
    }
    loadingFinish(context);
    if (rsp.code == ApiService.success) {
      Navigator.of(context).pop(true);
    } else {
      bloc.showTip(rsp.msg);
    }
  }
}

class PluginSettingBloc extends CommonBloc {
  var validityStart = BehaviorSubject<String>();
  var validityEnd = BehaviorSubject<String>();
  var billingType = BehaviorSubject<RadioBean>();
  var subsidiaryCorporation = StringBuffer();

  var webOCR = BehaviorSubject<bool>(seedValue: false);
  var apiOCR = BehaviorSubject<bool>(seedValue: false);
  var appOCR = BehaviorSubject<bool>(seedValue: false);

  var taxInvoice = BehaviorSubject<bool>(seedValue: false);
  var normalInvoice = BehaviorSubject<bool>(seedValue: false);

  var allQuota = StringBuffer();

  var quota1 = StringBuffer();
  var quota2 = StringBuffer();
  var quota3 = StringBuffer();

  var plugins = [];
}
