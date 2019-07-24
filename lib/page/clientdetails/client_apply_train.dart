import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/common_route.dart';
import 'package:flutter_app/bloc/common_bloc.dart';
import 'package:flutter_app/data/http/api_service.dart';
import 'package:flutter_app/data/http/rsp/apply_info.dart';
import 'package:flutter_app/page/base/common_page_state.dart';
import 'package:flutter_app/page/clientdetails/apply_account/client_apply_debug_account_page.dart';
import 'package:intl/intl.dart';
import 'package:rxdart/rxdart.dart';

import '../../main.dart';

class ClientApplyTrainPage extends StatefulWidget {
  const ClientApplyTrainPage({Key key, this.id, this.name, this.logs}) : super(key: key);

  final id;
  final name;
  final logs;

  @override
  State<StatefulWidget> createState() {
    return ClientApplyTrainPageState();
  }
}

class ClientApplyTrainPageState
    extends CommonPageState<ClientApplyTrainPage, ClientApplyTrain> {
  ScrollController _scrollController;

  @override
  void initState() {
    if (bloc == null) {
      bloc = ClientApplyTrain();
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
        title: Text('申请培训'),
        actions: <Widget>[
          InkWell(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Center(
                child: Text(
                  '申请历史',
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
                CommonRoute(builder: (c) => ApplyTrainHistory(widget.logs)),
              );
            },
          )
        ],
      ),
      body: Column(
        children: <Widget>[
          Flexible(
            child: ListView(
              controller: _scrollController,
              children: <Widget>[
                Divider(
                  height: 10,
                ),
                buildInputItem(
                  label: '培训地点',
                  hint: '请输入培训地点',
                  content: bloc.trainPlace,
                ),
                buildClickableItem(
                    label: '培训时间',
                    hint: '请选择培训时间',
                    content: bloc.trainTime,
                    onClick: () async {
                      var date = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(DateTime.now().year,
                            DateTime.now().month, DateTime.now().day),
                        lastDate: DateTime(DateTime.now().year + 1, 12, 31),
                      );
                      if (date != null) {
                        setState(() {
                          bloc.trainTime.value =
                              DateFormat('yyyy-MM-dd').format(date);
                        });
                      }
                    }),
                buildInputItem(
                  label: '培训功能',
                  hint: '请输入培训功能',
                  content: bloc.trainFunction,
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
                          decoration: InputDecoration(
                            hintText: '请输入备注内容',
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.all(0),
                          ),
                          onChanged: (s) {
                            bloc.memo = s;
                          },
                        ),
                      )
                    ],
                  ),
                ),
              ],
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
              onTap: () {
                bloc.confrim(widget.id, widget.name);
              },
            ),
          )
        ],
      ),
    );
  }
}

class ClientApplyTrain extends CommonBloc {
  var trainPlace = StringBuffer();
  var trainTime = BehaviorSubject<String>();
  var trainFunction = StringBuffer();
  String memo;

  void confrim(id, name) async {
    if (trainPlace.isEmpty) {
      showTip('请输入培训地点');
      return;
    }
    if (trainTime.value == null || trainTime.value.isEmpty) {
      showTip('请选择培训事件');
      return;
    }
    if (trainFunction.isEmpty) {
      showTip('请输入培训功能');
      return;
    }
    pageLoading();
    var rsp = await ApiService().apply(
        application_type: applyTypeTrain.toString(),
        leads_id: id.toString(),
        leads_name: name,
        train_place: trainPlace.toString(),
        requirements: trainFunction.toString(),
        visit_time: trainTime.value ?? '',
        memo: memo ?? '');
    pageCompleted();
    if (rsp.code == ApiService.success) {
      finish(result: true);
    } else {
      showTip(rsp.msg);
    }
  }
}

class ApplyTrainHistory extends StatelessWidget {
  const ApplyTrainHistory(
    this.histories, {
    Key key,
  }) : super(key: key);

  final List histories;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colorBg,
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        title: Text('申请历史'),
      ),
      body: ListView.builder(
        itemCount: histories.length,
        itemBuilder: (c, i) => itemTrain2(
              item: histories[i],
            ),
      ),
    );
  }
}

Widget itemTrain({TrainLog item, bool lastOne = false}) {
  return Container(
    color: Colors.white,
    padding: EdgeInsets.symmetric(
      horizontal: 20.0,
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          margin: EdgeInsets.only(top: 11),
          child: Row(
            children: <Widget>[
              Text(
                item.visit_time ?? '',
                style: TextStyle(fontSize: 11, color: colorOrigin),
              ),
              Container(
                margin: EdgeInsets.only(left: 10),
                child: Text(
                  item.train_place ?? '',
                  style: TextStyle(fontSize: 11, color: colorOrigin),
                ),
              ),
            ],
          ),
        ),
        Container(
          margin: EdgeInsets.only(top: 5.0, bottom: 5),
          child: Text(
            item.requirements??'',
            style: TextStyle(fontSize: 14),
          ),
        ),
        Container(
          margin: EdgeInsets.only(bottom: 10),
          child: Text(
            '备注：${item.memo??''}',
            style: TextStyle(fontSize: 12, color: Colors.grey),
          ),
        ),
        Opacity(
          opacity: lastOne ? 0 : 1,
          child: Divider(
            height: 1,
          ),
        ),
      ],
    ),
  );
}

Widget itemTrain2({TrainLog item,}) {
  return Container(
    color: Colors.white,
    margin: EdgeInsets.only(top: 10),
    padding: EdgeInsets.symmetric(
      horizontal: 20.0,
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          margin: EdgeInsets.only(top: 11),
          child: Row(
            children: <Widget>[
              Text(
                item.visit_time ?? '',
                style: TextStyle(fontSize: 11, color: colorOrigin),
              ),
              Container(
                margin: EdgeInsets.only(left: 10),
                child: Text(
                  item.train_place ?? '',
                  style: TextStyle(fontSize: 11, color: colorOrigin),
                ),
              ),
            ],
          ),
        ),
        Container(
          margin: EdgeInsets.only(top: 5.0, bottom: 5),
          child: Text(
            item.requirements??'',
            style: TextStyle(fontSize: 14),
          ),
        ),
        Container(
          margin: EdgeInsets.only(bottom: 10),
          child: Text(
            '备注：${item.memo??''}',
            style: TextStyle(fontSize: 12, color: Colors.grey),
          ),
        ),
      ],
    ),
  );
}

