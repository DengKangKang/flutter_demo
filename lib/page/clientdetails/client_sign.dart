import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/common_route.dart';
import 'package:flutter_app/bloc/common_bloc.dart';
import 'package:flutter_app/data/http/api_service.dart';
import 'package:flutter_app/data/http/rsp/data/RadioBean.dart';
import 'package:flutter_app/data/http/rsp/data/clients_data.dart';
import 'package:flutter_app/data/http/rsp/data/sign_log_data.dart';
import 'package:flutter_app/page/radio_list_page.dart';
import 'package:flutter_app/page/base/common_page_state.dart';
import 'package:flutter_app/page/clientdetails/apply_account/client_apply_debug_account_page.dart';
import 'package:flutter_app/weight/tool.dart';
import 'package:intl/intl.dart';
import 'package:rxdart/rxdart.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../main.dart';

class ClientSignPage extends StatefulWidget {
  const ClientSignPage({Key key, this.client}) : super(key: key);

  final Client client;

  @override
  State<StatefulWidget> createState() {
    return ClientApplyTrainPageState();
  }
}

class ClientApplyTrainPageState
    extends CommonPageState<ClientSignPage, ClientSign> {
  ScrollController _scrollController;

  @override
  void initState() {
    if (bloc == null) {
      bloc = ClientSign();
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
        title: Text('签约信息'),
        actions: <Widget>[
          InkWell(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Center(
                child: Text(
                  '签约历史',
                  style: TextStyle(
                    fontSize: 15,
                    color: colorOrigin,
                  ),
                ),
              ),
            ),
            onTap: () {
              Navigator.push(
                context,
                CommonRoute(builder: (c) => SignHistory(id: widget.client.id)),
              );
            },
          )
        ],
      ),
      body: Column(
        children: <Widget>[
          Flexible(
            child: Container(
              margin: EdgeInsets.only(top: 10),
              child: ListView(
                controller: _scrollController,
                children: <Widget>[
                  buildInputItem(
                    label: '合同金额',
                    hint: '请输入合同金额',
                    content: bloc.amount,
                  ),
                  buildClickableItem(
                      label: '签约时间',
                      hint: '请选择日期',
                      content: bloc.time,
                      onClick: () async {
                        var date = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(DateTime.now().year,
                              DateTime.now().month, DateTime.now().day),
                          lastDate: DateTime(DateTime.now().year + 1, 12, 31),
                        );
                        if (date != null) {
                          bloc.time.value =
                              DateFormat('yyyy-MM-dd').format(date);
                        }
                      }),
                  buildClickableItem(
                    label: '签约类型',
                    hint: '请选择签约类型',
                    content: bloc.type,
                    onClick: () async {
                      RadioBean signType = await showDialog(
                        context: context,
                        builder: (context) => RadioListPage(signTypes),
                      );

                      if (signType != null) {
                        bloc.type.value = signType;
                      }
                    },
                    showLine: false,
                  ),
                ],
              ),
            ),
          ),
          Material(
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
              onTap: sign,
            ),
          ),
        ],
      ),
    );
  }

  void sign() async {
    if (bloc.amount.isEmpty) {
      bloc.showTip('请输入合同金额。');
      return;
    }
    if (bloc.time.value.isEmpty) {
      bloc.showTip('请选择签约时间。');
      return;
    }
    if (bloc.type.value == null) {
      bloc.showTip('请输入签约类型。');
      return;
    }
    onLoading(context);
    var rsp = await ApiService().signContract(
      widget.client.id.toString(),
      bloc.amount.toString(),
      bloc.time.value,
      bloc.type.toString(),
      widget.client.leads_name.toString(),
      widget.client.userid_sale.toString(),
    );
    loadingFinish(context);
    if (rsp.code == ApiService.success) {
      Navigator.of(context).pop();
    } else {
      bloc.showTip(rsp.msg);
    }
  }
}

class ClientSign extends CommonBloc {
  var amount = StringBuffer();
  var time = BehaviorSubject<String>();
  var type = BehaviorSubject<RadioBean>();
}

class SignHistory extends StatefulWidget {
  const SignHistory({Key key, this.id}) : super(key: key);

  final int id;

  @override
  State<StatefulWidget> createState() {
    return SignHistoryState();
  }
}

class SignHistoryState extends State<SignHistory> {
  var _key = GlobalKey<ScaffoldState>();

  List<SignLog> histories = [];

  @override
  void initState() {
    ApiService().signLogs(widget.id.toString()).then(
      (rsp) {
        if (rsp.code == ApiService.success) {
          setState(() {
            histories = rsp.data.list;
          });
        }
      },
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _key,
      backgroundColor: colorBg,
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        title: Text('签约历史'),
      ),
      body: ListView.builder(
        itemCount: histories.length,
        itemBuilder: (c, i) => ItemSign(
          signLog: histories[i],
        ),
      ),
    );
  }
}

class ItemSign extends StatefulWidget {
  const ItemSign({Key key, this.signLog}) : super(key: key);

  final SignLog signLog;

  @override
  State<StatefulWidget> createState() {
    return ItemSignState();
  }
}

class ItemSignState extends State<ItemSign> {
  List<ExtraFile> extra = [];
  var expanded = false;

  @override
  void initState() {
    if (widget.signLog.files.isNotEmpty) {
      extra.add(widget.signLog.files.first);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 10),
      child: Material(
        color: Colors.white,
        child: Container(
          padding: EdgeInsets.symmetric(
            vertical: 10,
            horizontal: 20,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    '合同编号：${widget.signLog?.contract_no ?? ''}',
                    style: TextStyle(fontSize: 14),
                  ),
                  Text(
                    '¥：${widget.signLog?.contract_amount ?? ''}',
                    style: TextStyle(fontSize: 17, color: colorOrigin),
                  )
                ],
              ),
              Container(
                margin: EdgeInsets.symmetric(vertical: 10),
                child: Divider(
                  height: 1,
                ),
              ),
              Text(
                '签约时间：${widget.signLog?.contract_time ?? ''}',
                style: TextStyle(fontSize: 14),
              ),
              Container(
                margin: EdgeInsets.only(top: 5),
                child: Text(
                  '签约类型：${widget.signLog?.contract_type == signTypes[0].id ? signTypes[0].name : signTypes[1].name}',
                  style: TextStyle(fontSize: 14),
                ),
              ),
              Opacity(
                opacity: widget.signLog?.files?.isNotEmpty == true ? 1 : 0,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    ...extra.map(
                      (e) => Container(
                        margin: EdgeInsets.only(top: 5),
                        child: InkWell(
                          child: Text(
                            e.file_name,
                            style: TextStyle(color: colorCyan, fontSize: 12),
                          ),
                          onTap: () {
                            launch(e.file_path);
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                height: widget.signLog?.files?.isNotEmpty == true ? null : 0,
                child: InkWell(
                  child: Container(
                    margin: EdgeInsets.only(top: 5),
                    child: Center(
                      child: InkWell(
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Text(
                              expanded
                                  ? '收起'
                                  : '查看更多（${widget.signLog?.files?.length ?? '0'}）',
                              style:
                                  TextStyle(fontSize: 12, color: Colors.grey),
                            ),
                            Container(
                              margin: EdgeInsets.only(left: 5),
                              child: expanded
                                  ? Image.asset(
                                      'assets/images/ico_htxq_jt_x.png')
                                  : Image.asset(
                                      'assets/images/ico_htxq_jt_s.png'),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                  onTap: () {
                    setState(() {
                      extra = expanded
                          ? [widget.signLog?.files[0]]
                          : widget.signLog?.files;
                      expanded = !expanded;
                    });
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
