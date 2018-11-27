import 'package:flutter/material.dart';
import 'package:flutter_app/page/base/CommonPageState.dart';

class NewDailyPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new NewDailyPageState();
  }
}

class NewDailyPageState extends CommonPageState {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("新增日报"),
      ),
      body: new Container(
        padding: EdgeInsets.symmetric(horizontal: 16.0),
        child: new Theme(
          data: Theme.of(context).copyWith(
            primaryColor: Colors.blue,
          ),
          child: new ListView(
            children: <Widget>[
              new TextField(
                decoration: new InputDecoration(
                  border: UnderlineInputBorder(),
                  labelStyle: TextStyle(decorationColor: Colors.blue),
                  labelText: "日期",
                ),
                keyboardType: TextInputType.multiline,
                maxLengthEnforced: true,
                maxLines: null,
              ),
              new TextField(
                decoration: new InputDecoration(
                  border: UnderlineInputBorder(),
                  labelStyle: TextStyle(decorationColor: Colors.blue),
                  labelText: "今日工作内容",
                ),
                keyboardType: TextInputType.multiline,
                maxLengthEnforced: true,
                maxLines: null,
              ),
              new TextField(
                decoration: new InputDecoration(
                  border: UnderlineInputBorder(),
                  labelStyle: TextStyle(decorationColor: Colors.blue),
                  labelText: "今日拜访/跟进客户",
                ),
                keyboardType: TextInputType.multiline,
                maxLengthEnforced: true,
                maxLines: null,
              ),
              new TextField(
                decoration: new InputDecoration(
                  border: UnderlineInputBorder(),
                  labelStyle: TextStyle(decorationColor: Colors.blue),
                  labelText: "今日所遇到的问题及解决方案",
                ),
                keyboardType: TextInputType.multiline,
                maxLengthEnforced: true,
                maxLines: null,
              ),
              new TextField(
                decoration: new InputDecoration(
                  border: UnderlineInputBorder(),
                  labelStyle: TextStyle(decorationColor: Colors.blue),
                  labelText: "明日工作计划",
                ),
                keyboardType: TextInputType.multiline,
                maxLengthEnforced: true,
                maxLines: null,
              ),
              new TextField(
                decoration: new InputDecoration(
                  border: UnderlineInputBorder(),
                  labelStyle: TextStyle(decorationColor: Colors.blue),
                  labelText: "明日拜访/跟进用户",
                ),
                keyboardType: TextInputType.multiline,
                maxLengthEnforced: true,
                maxLines: null,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
