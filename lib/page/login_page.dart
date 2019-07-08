import 'package:flutter/material.dart';
import 'package:flutter_app/CommonRoute.dart';
import 'package:flutter_app/data/http/api_service.dart';
import 'package:flutter_app/data/http/rsp/BaseRsp.dart';
import 'package:flutter_app/data/http/rsp/LoginRsp.dart';
import 'package:flutter_app/data/persistence/Persistence.dart';
import 'package:flutter_app/main.dart';
import 'package:flutter_app/page/main_page.dart';
import 'package:flutter_app/weight/Tool.dart';

class LoginPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return LoginPageState();
  }
}

class LoginPageState extends State<StatefulWidget> {
  var _usernameController = TextEditingController();
  var _passwordController = TextEditingController();

  var usernameText = "";
  var passwordText = "";

  @override
  void initState() {
    Persistence().getUserAccount().then((userAccount) {
      _usernameController.text = userAccount;
    });

    _passwordController.addListener(() {
      setState(() {
        passwordText = _passwordController.text;
      });
    });

    _usernameController.addListener(() {
      setState(() {
        usernameText = _usernameController.text;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Builder(
        builder: (context) => ListView(
              children: <Widget>[
                Container(
                  height: 130,
                  width: 140,
                  margin: EdgeInsets.symmetric(vertical: 80),
                  child: Image.asset('assets/images/ico_dl_logo.png'),
                ),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 20),
                  child: TextField(
                      controller: _usernameController,
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.symmetric(
                          vertical: 20,
                        ),
                        border: InputBorder.none,
                        hintText: '请输入账号',
                      ),
                      keyboardType: TextInputType.emailAddress),
                ),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 20),
                  child: Divider(height: 1,),
                ),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 20),
                  child: TextField(
                      controller: _passwordController,
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.symmetric(
                          vertical: 20,
                        ),
                        border: InputBorder.none,
                        hintText: '请输入密码',
                      ),
                      obscureText: true,
                      keyboardType: TextInputType.emailAddress),
                ),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 20),
                  child: Divider(height: 1,),
                ),
                Container(
                  margin: EdgeInsets.symmetric(
                    vertical: 40,
                    horizontal: 60,
                  ),
                  width: double.infinity,
                  child: MaterialButton(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(5.0)),
                    ),
                    color: colorOrigin,
                    textColor: Colors.white,
                    padding: EdgeInsets.symmetric(
                      vertical: 12.0,
                      horizontal: 16.0,
                    ),
                    onPressed: () {
                      _login(context);
                    },
                    child: Text('登录'),
                  ),
                ),
              ],
            ),
      ),
    );
  }

  void _login(BuildContext context) async {
    if (_usernameController.text == null ||
        _usernameController.text.trim().isEmpty) {
      Scaffold.of(context).showSnackBar(
        SnackBar(
          content: Text("请输入用户名"),
        ),
      );
      return;
    }
    if (_passwordController.text == null ||
        _passwordController.text.trim().isEmpty) {
      Scaffold.of(context).showSnackBar(
        SnackBar(
          content: Text("请输入密码"),
        ),
      );
      return;
    }
    onLoading(context);
    BaseRsp rsp = await ApiService().login(
      _usernameController.text.trim(),
      _passwordController.text.trim(),
    );
    loadingFinish(context);
    if (rsp.code == ApiService.success) {
      await Persistence().setUserAccount(_usernameController.text);
      await Persistence().setUsername((rsp as LoginRsp).data.realname);
      await Persistence().setUserAuthority(
        (rsp as LoginRsp).data.roles?.contains(31) == true,
      );
      Persistence().userAuthority.add(
            (rsp as LoginRsp).data.roles?.contains(31) == true,
          );
      bool result = await Persistence().setToken((rsp as LoginRsp).data.auth);
      if (result == true) {
        await Navigator.pushReplacement(
            context,
            CommonRoute(
              builder: (BuildContext context) => MainPage(),
            ));
      } else {
        Scaffold.of(context).showSnackBar(
          SnackBar(
            content: Text("登陆失败，请稍后再试"),
          ),
        );
      }
    } else {
      Scaffold.of(context).showSnackBar(
        SnackBar(
          content: Text(rsp.msg),
        ),
      );
    }
  }
}
