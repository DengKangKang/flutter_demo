import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app/bloc/Bloc.dart';
import 'package:flutter_app/page/base/CommonPageState.dart';
import 'package:intl/intl.dart';
import 'package:rxdart/rxdart.dart';

import '../../../main.dart';
import 'client_debug_account_page.dart';

class ClientApplyDebugAccountPage extends StatefulWidget {
  ClientApplyDebugAccountPage();

  @override
  State<StatefulWidget> createState() {
    return ClientDebugAccountPageState();
  }
}

class ClientDebugAccountPageState extends CommonPageState<
    ClientApplyDebugAccountPage, ClientDebugAccountBloc> {
  @override
  void initState() {
    if (bloc == null) {
      bloc = ClientDebugAccountBloc();
    }
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
        title: Text('测试账号'),
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
            onTap: () {},
          )
        ],
      ),
      body: ListView(
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
                                'id_124',
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
                                  '会议渠道',
                                  style: TextStyle(
                                      fontSize: 9, color: Color(0xFF3389FF)),
                                ),
                              )
                            ],
                          ),
                          Row(
                            children: <Widget>[
                              Text(
                                '还剩X天释放到公海',
                                style:
                                    TextStyle(fontSize: 13, color: Colors.red),
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
                              style:
                                  TextStyle(fontSize: 15, color: colorOrigin),
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
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                firstDate: DateTime(DateTime.now().year - 1),
                lastDate: DateTime(DateTime.now().year + 1, 12, 31),
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
          ),
          buildInputItem(
            label: '初始密码',
            hint: '请输入初始密码',
            content: bloc.password,
          ),
          buildInputItem(
            label: '人员上限制',
            hint: '请输入人员限制',
            content: bloc.personnelLimit,
          ),
        ],
      ),
    );
  }

  Widget buildInputItem({
    String label,
    String hint,
    StringBuffer content,
    List<TextInputFormatter> inputFormatters,
    TextInputType inputType,
    bool showLine = true,
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
                Text(
                  label,
                  style: TextStyle(fontSize: 15),
                ),
                Flexible(
                  child: TextField(
                    controller: TextEditingController.fromValue(
                      TextEditingValue(),
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
                    Text(
                      label,
                      style: TextStyle(fontSize: 15),
                    ),
                    Row(
                      children: <Widget>[
                        StreamBuilder(
                          initialData: hint,
                          stream: content,
                          builder: (b, s) => Text(
                                s.data,
                                style: TextStyle(
                                  fontSize: 15,
                                  color: s.data == hint
                                      ? Colors.grey
                                      : Colors.black,
                                ),
                              ),
                        ),
                        Icon(
                          Icons.keyboard_arrow_right,
                          color: Colors.grey,
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
}

class ClientDebugAccountBloc extends CommonBloc {
  var validity = BehaviorSubject<String>();
  StringBuffer adminName = StringBuffer();
  StringBuffer email = StringBuffer();
  StringBuffer password = StringBuffer();
  StringBuffer personnelLimit = StringBuffer();
}
