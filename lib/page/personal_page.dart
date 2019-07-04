import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_app/CommonRoute.dart';
import 'package:flutter_app/data/persistence/Persistence.dart';
import 'package:flutter_app/main.dart';
import 'package:flutter_app/page/login_page.dart';
import 'package:flutter_app/page/reset_password.dart';

class PersonalPage extends StatefulWidget {
  @override
  State createState() => PersonalPageState();
}

class PersonalPageState extends State<PersonalPage>
    with AutomaticKeepAliveClientMixin<PersonalPage> {
  String userName;

  var userAccount = '';

  @override
  void initState() {
    Persistence().getUserAccount().then(
      (s) {
        setState(() {
          userAccount = s;
        });
      },
    );
    Persistence().getUsername().then(
      (s) {
        setState(() {
          userName = s;
        });
      },
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Stack(
          alignment: AlignmentDirectional.center,
          children: <Widget>[
            Image.asset('assets/images/p_me.png'),
            Column(
              children: <Widget>[
                Container(
                  width: 75,
                  height: 75,
                  margin: EdgeInsets.only(bottom: 20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(37.5)),
                  ),
                  child: Center(
                    child: Text(
                      userName == null ? '' : userName[0],
                      style: TextStyle(
                          color: colorOrigin,
                          fontSize: 32,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                Text(
                  userName ?? '',
                  style: TextStyle(color: Colors.white, fontSize: 22),
                ),
                Text(
                  userAccount ?? '',
                  style: TextStyle(color: Colors.white, fontSize: 14),
                )
              ],
            ),
          ],
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: <Widget>[
              item(
                '重置密码',
                'assets/images/ico_me_mm.png',
                () {
                  Navigator.push(
                    context,
                    CommonRoute(builder: (c) => ResetPasswordPage()),
                  );
                },
              ),
              Container(
                margin: EdgeInsets.only(top: 20),
                child: item(
                  '退出登录',
                  'assets/images/ico_me_tc.png',
                  () {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: Text("提示"),
                        content: Text("是否确认退出"),
                        actions: <Widget>[
                          FlatButton(
                            child: Text(
                              '确定',
                              style: TextStyle(
                                color: Colors.grey,
                              ),
                            ),
                            onPressed: () {
                              _onLogout(context);
                            },
                          ),
                          FlatButton(
                            child: Text(
                              '取消',
                              style: TextStyle(
                                color: colorOrigin,
                              ),
                            ),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        )
      ],
    );
  }

  Widget item(String label, String icon, VoidCallback onPress) {
    return RawMaterialButton(
      elevation: defaultElevation,
      fillColor: Colors.white,
      padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 18.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(4.0)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Row(
            children: <Widget>[
              Image.asset(icon),
              Container(
                margin: EdgeInsets.only(left: 5),
                child: Text(label),
              ),
            ],
          ),
          Icon(Icons.keyboard_arrow_right)
        ],
      ),
      onPressed: onPress,
    );
  }

  void _onLogout(BuildContext context) async {
    Navigator.of(context).pop();
    await Persistence().setToken("");
    await Persistence().userAuthority.add(false);
    await Persistence().setUserAuthority(false);
    await Navigator.pushReplacement(
      context,
      CommonRoute(
        builder: (BuildContext context) => LoginPage(),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
