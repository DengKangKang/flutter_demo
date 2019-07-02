import 'package:flutter/material.dart';
import 'package:flutter_app/bloc/Bloc.dart';
import 'package:flutter_app/main.dart';

import 'base/CommonPageState.dart';

class ResetPasswordPage extends StatefulWidget {
  const ResetPasswordPage({Key key}) : super(key: key);

  @override
  State createState() => ResetPasswordState();
}

class ResetPasswordState
    extends CommonPageState<ResetPasswordPage, ResetPassword> {
  @override
  void initState() {
    if (bloc == null) {
      bloc = ResetPassword();
      bloc.initData();
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colorBg,
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        title: Text('重置密码'),
      ),
      body: Column(
        children: <Widget>[
          Flexible(
            child: ListView(
              children: <Widget>[
                Container(
                  color: Colors.white,
                  margin: EdgeInsets.only(top: 10),
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      TextField(
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.symmetric(
                              vertical: 20,
                            ),
                            hintText: '请输入旧密码'),
                        onChanged: (s) {
                          bloc.oldPassword = s;
                        },
                      ),
                      Divider(
                        height: 1,
                      ),
                      TextField(
                        decoration: InputDecoration(
                            contentPadding: EdgeInsets.symmetric(
                              vertical: 20,
                            ),
                            border: InputBorder.none,
                            hintText: '请输入新密码'),
                        onChanged: (s) {
                          bloc.newPassword = s;
                        },
                      ),
                      Divider(
                        height: 1,
                      ),
                      TextField(
                        decoration: InputDecoration(
                            contentPadding: EdgeInsets.symmetric(
                              vertical: 20,
                            ),
                            border: InputBorder.none,
                            hintText: '请再次输入新密码'),
                        onChanged: (s) {
                          bloc.newPasswordAgain = s;
                        },
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
          Material(
            elevation: defaultElevation,
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
          ),
        ],
      ),
    );
  }
}

class ResetPassword extends CommonBloc {
  var oldPassword = '';
  var newPassword = '';
  var newPasswordAgain = '';
}
