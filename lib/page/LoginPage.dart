import 'package:flutter/material.dart';
import 'package:flutter_app/CommonRoute.dart';
import 'package:flutter_app/data/http/ApiService.dart';
import 'package:flutter_app/data/http/rsp/BaseRsp.dart';
import 'package:flutter_app/data/http/rsp/LoginRsp.dart';
import 'package:flutter_app/data/persistence/Persistence.dart';
import 'package:flutter_app/page/HomePage.dart';
import 'package:flutter_app/weight/Tool.dart';

class LoginPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new LoginPageState();
  }
}

class LoginPageState extends State<StatefulWidget> {
  var _usernameController = new TextEditingController();
  var _passwordController = new TextEditingController();

  var usernameText = "";
  var passwordText = "";

  @override
  void initState() {
    new Persistence().getUsername().then((username){
      _usernameController.text = username;
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
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Login"),
      ),
      body: Builder(
        builder: (context) => new Column(
              children: <Widget>[
                new Container(
                  child: new Theme(
                    data: Theme.of(context).copyWith(
                      primaryColor: Colors.blue,
                    ),
                    child: new TextField(
                      controller: _usernameController,
                      decoration: new InputDecoration(
                        suffixIcon: usernameText.isNotEmpty
                            ? IconButton(
                                icon: Icon(
                                  Icons.close,
                                ),
                                onPressed: () {
                                  _usernameController.clear();
                                },
                              )
                            : null,
                        border: UnderlineInputBorder(),
                        labelStyle: TextStyle(decorationColor: Colors.blue),
                        labelText: "Username",
                      ),
                      keyboardType: TextInputType.emailAddress,
                    ),
                  ),
                  margin:
                      EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                ),
                new Container(
                  child: new Theme(
                    data: Theme.of(context).copyWith(
                      primaryColor: Colors.blue,
                    ),
                    child: new TextField(
                      obscureText: true,
                      controller: _passwordController,
                      decoration: new InputDecoration(
                        suffixIcon: passwordText.isNotEmpty
                            ? IconButton(
                                icon: Icon(
                                  Icons.close,
                                ),
                                onPressed: () {
                                  _passwordController.clear();
                                },
                              )
                            : null,
                        border: UnderlineInputBorder(),
                        labelStyle: TextStyle(decorationColor: Colors.blue),
                        labelText: "Passwrod",
                      ),
                      keyboardType: TextInputType.emailAddress,
                    ),
                  ),
                  margin: EdgeInsets.only(
                    left: 16.0,
                    right: 16.0,
                  ),
                ),
                new Container(
                  margin: EdgeInsets.symmetric(
                    vertical: 24.0,
                    horizontal: 16.0,
                  ),
                  width: double.infinity,
                  child: MaterialButton(
                    color: Theme.of(context).accentColor,
                    textColor: Theme.of(context).backgroundColor,
                    padding: new EdgeInsets.symmetric(
                      vertical: 12.0,
                      horizontal: 16.0,
                    ),
                    onPressed: () {
                      _login(context);
                    },
                    child: new Text('Login'),
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
        new SnackBar(
          content: new Text("请输入用户名"),
        ),
      );
      return;
    }
    if (_passwordController.text == null ||
        _passwordController.text.trim().isEmpty) {
      Scaffold.of(context).showSnackBar(
        new SnackBar(
          content: new Text("请输入密码"),
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
      new Persistence().setUserAccount(_usernameController.text);
      new Persistence().setUsername((rsp as LoginRsp).data.realname);
      new Persistence().setToken((rsp as LoginRsp).data.auth).then((value) {
        print(value);
        if (value == true) {
          Navigator.pushReplacement(
              context,
              new CommonRoute(
                builder: (BuildContext context) => new HomePage(),
              ));
        } else {
          Scaffold.of(context).showSnackBar(
            new SnackBar(
              content: new Text("登陆失败，请稍后再试"),
            ),
          );
        }
      });
    } else {
      Scaffold.of(context).showSnackBar(
        new SnackBar(
          content: new Text(rsp.msg),
        ),
      );
    }
  }
}
