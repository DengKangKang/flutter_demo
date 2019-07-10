import 'package:flutter/material.dart';
import 'package:flutter_app/bloc/Bloc.dart';
import 'package:flutter_app/data/http/rsp/applied_plugins_rsp.dart';

import '../../../main.dart';
import 'client_apply_debug_account_page.dart';
import 'client_debug_account_page.dart';

class AccountInfoPage1 extends StatefulWidget {
  AccountInfoPage1({
    Key key,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return AccountInfoPage1State();
  }
}

class AccountInfoPage1State extends State<AccountInfoPage1>
    with AutomaticKeepAliveClientMixin<AccountInfoPage1> {
  ClientDebugAccountBloc _bloc;

  @override
  void initState() {
    if (_bloc == null) _bloc = BlocProvider.of(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return ListView(
      physics: BouncingScrollPhysics(),
      children: <Widget>[
        Container(
          color: Colors.white,
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              StreamBuilder(
                initialData: '',
                stream: _bloc.id.stream,
                builder: (c, s) => Text(
                  'com_id：${s.data}',
                  style: TextStyle(fontSize: 15),
                ),
              ),
              Container(
                padding: EdgeInsets.only(top: 5),
                child: StreamBuilder(
                  initialData: '',
                  stream: _bloc.applier.stream,
                  builder: (c, s) => Text(
                    '申请人：${s.data}',
                    style: TextStyle(fontSize: 15),
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.only(top: 5),
                child: StreamBuilder(
                  initialData: '',
                  stream: _bloc.applyTime.stream,
                  builder: (c, s) => Text(
                    '申请时间：${s.data}',
                    style: TextStyle(fontSize: 15),
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.only(top: 5),
                child: StreamBuilder(
                  initialData: '',
                  stream: _bloc.passTime.stream,
                  builder: (c, s) => Text(
                    '开通时间：${s.data}',
                    style: TextStyle(fontSize: 15),
                  ),
                ),
              ),
            ],
          ),
        ),
        buildTitle('基础信息'),
        buildItem('管理员姓名', _bloc.adminName.stream),
        buildItem('邮箱', _bloc.email.stream),
        buildItem('初始密码', _bloc.password.stream),
        buildItem('人员上限', _bloc.peopleCount.stream),
        Visibility(
          visible: isRelease(_bloc.accountType),
          child: buildItem('功能模块', _bloc.function.stream),
        ),
        buildItem('有效日期', _bloc.validity.stream),
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
                child: StreamBuilder(
                  initialData: '',
                  stream: _bloc.memo.stream,
                  builder: (c, s) => Text(
                    s.data ?? '',
                    style: TextStyle(
                      color: Colors.grey,
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
        buildTitle('票量信息'),
        buildItem('查验发票量', _bloc.verifyCount.stream),
        buildItem('有效期', _bloc.verifyCountValidity.stream, showLine: false),
        buildTitle('插件信息'),
        StreamBuilder<List<Plugin>>(
          initialData: [],
          stream: _bloc.plugins,
          builder: (c, s) {
            return s.data == null || s.data.isNotEmpty
                ? Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[...s.data.map((e) => buildPlugin(e))],
                  )
                : Container(
                    margin: EdgeInsets.only(bottom: 20),
                    color: Colors.white,
                    padding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
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
    );
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
    return pluginWidget;
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

  @override
  bool get wantKeepAlive => true;
}
