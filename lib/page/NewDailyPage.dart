import 'package:flutter/material.dart';
import 'package:flutter_app/page/base/CommonPageState.dart';
import 'package:flutter_app/bloc/NewDailyBloc.dart';
import 'package:intl/intl.dart';

class NewDailyPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new NewDailyPageState();
  }
}

class NewDailyPageState extends CommonPageState<NewDailyPage, NewDailyBloc> {
  @override
  void initState() {
    if (bloc == null) {
      bloc = new NewDailyBloc();
      bloc.initData();
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      key: scaffoldKey,
      appBar: new AppBar(
        title: new Text("新增日报"),
        actions: <Widget>[
          new IconButton(
            icon: new Icon(Icons.close),
            onPressed: () {
              bloc.save();
            },
          )
        ],
      ),
      body: new Container(
        child: new Theme(
          data: Theme.of(context).copyWith(
            primaryColor: Colors.blue,
          ),
          child: new ListView(
            children: <Widget>[
              new ListTile(
                title: new Text("日期"),
                subtitle: StreamBuilder<String>(
                  initialData: "",
                  stream: bloc.date,
                  builder:
                      (BuildContext context, AsyncSnapshot<String> snapshot) {
                    return new Text(snapshot.data);
                  },
                ),
                trailing: new Icon(Icons.keyboard_arrow_down),
                onTap: () async {
                  var date = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(DateTime.now().year - 1),
                    lastDate: DateTime.now(),
                  );
                  if (date != null) {
                    bloc.date = new DateFormat('yyyy-MM-dd').format(date);
                  }
                },
              ),
              new Container(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: new TextField(
                  decoration: new InputDecoration(
                    border: UnderlineInputBorder(),
                    labelStyle: TextStyle(decorationColor: Colors.blue),
                    labelText: "今日工作内容",
                  ),
                  keyboardType: TextInputType.multiline,
                  maxLengthEnforced: true,
                  maxLines: null,
                  onChanged: (s) {
                    bloc.todayWorkContent = s;
                  },
                ),
              ),
              new Container(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: new TextField(
                  decoration: new InputDecoration(
                    border: UnderlineInputBorder(),
                    labelStyle: TextStyle(decorationColor: Colors.blue),
                    labelText: "今日拜访/跟进客户",
                  ),
                  keyboardType: TextInputType.multiline,
                  maxLengthEnforced: true,
                  maxLines: null,
                  onChanged: (s) {
                    bloc.todayVisitClient = s;
                  },
                ),
              ),
              new Container(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: new TextField(
                  decoration: new InputDecoration(
                    border: UnderlineInputBorder(),
                    labelStyle: TextStyle(decorationColor: Colors.blue),
                    labelText: "今日所遇到的问题及解决方案",
                  ),
                  keyboardType: TextInputType.multiline,
                  maxLengthEnforced: true,
                  maxLines: null,
                  onChanged: (s) {
                    bloc.todaySolution = s;
                  },
                ),
              ),
              new Container(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: new TextField(
                  decoration: new InputDecoration(
                    border: UnderlineInputBorder(),
                    labelStyle: TextStyle(decorationColor: Colors.blue),
                    labelText: "明日工作计划",
                  ),
                  keyboardType: TextInputType.multiline,
                  maxLengthEnforced: true,
                  maxLines: null,
                  onChanged: (s) {
                    bloc.tomorrowPlane = s;
                  },
                ),
              ),
              new Container(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: new TextField(
                  decoration: new InputDecoration(
                    border: UnderlineInputBorder(),
                    labelStyle: TextStyle(decorationColor: Colors.blue),
                    labelText: "明日拜访/跟进用户",
                  ),
                  keyboardType: TextInputType.multiline,
                  maxLengthEnforced: true,
                  maxLines: null,
                  onChanged: (s) {
                    bloc.tomorrowVisitClient = s;
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
