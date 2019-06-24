import 'package:flutter/material.dart';
import 'package:flutter_app/CommonRoute.dart';
import 'package:flutter_app/bloc/Bloc.dart';
import 'package:flutter_app/bloc/ClientDetailBloc.dart';
import 'package:flutter_app/data/Constant.dart';
import 'package:flutter_app/data/http/ApiService.dart';
import 'package:flutter_app/data/http/rsp/VisitLogsRsp.dart';
import 'package:flutter_app/data/http/rsp/data/RadioBean.dart';
import 'package:flutter_app/data/http/rsp/data/VisitLogsData.dart';
import 'package:flutter_app/page/RadioListPage.dart';
import 'package:flutter_app/page/clientdetails/NewPlainVisit.dart';
import 'package:flutter_app/page/clientdetails/NewSpecialVisit.dart';

import '../../main.dart';

class CreateDemandPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return CreateDemandPageState();
  }
}

class CreateDemandPageState extends State {
  var _usernameController = TextEditingController.fromValue(
    TextEditingValue(
      text: '',
    ),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: colorBg,
        appBar: AppBar(
          centerTitle: true,
          title: Text('添加需求'),
          actions: <Widget>[
            InkWell(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Center(
                  child: Text(
                    '保存',
                    style: TextStyle(
                      fontSize: 15,
                      color: colorOrigin,
                    ),
                  ),
                ),
              ),
              onTap: (){},
            )
          ],
        ),
        body: Container(
          height: 240,
          margin: EdgeInsets.symmetric(vertical: 10),
          padding: EdgeInsets.all(20),
          color: Colors.white,
          child: Theme(
            data: ThemeData(
              primaryColor: colorOrigin,
            ),
            child: TextField(
              controller: _usernameController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: "请输入需求内容",
                alignLabelWithHint: true,
              ),
              keyboardType: TextInputType.multiline,
              maxLengthEnforced: true,
              maxLines: 100,
            ),
          ),
        ));
  }
}
