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
    return new WillPopScope(
      child: new Scaffold(
        key: scaffoldKey,
        appBar: new AppBar(
          title: new Text("新增日报"),
          actions: <Widget>[
            new IconButton(
              icon: new Icon(Icons.check),
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
                new Container(
                  padding: EdgeInsets.only(right: 16.0, left: 16.0, top: 12.0),
                  child: GestureDetector(
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
                    child: AbsorbPointer(
                      child: StreamBuilder<String>(
                        initialData: "",
                        stream: bloc.date,
                        builder: (
                          BuildContext context,
                          AsyncSnapshot<String> snapshot,
                        ) {
                          return new TextField(
                            controller: new TextEditingController(
                              text: snapshot.data,
                            ),
                            decoration: new InputDecoration(
                              fillColor: Color(0xFFf6f6f9),
                              filled: true,
                              suffixIcon: new Icon(Icons.keyboard_arrow_down),
                              border: UnderlineInputBorder(),
                              labelStyle:
                                  TextStyle(decorationColor: Colors.blue),
                              labelText: "日期",
                            ),
                            keyboardType: TextInputType.multiline,
                            maxLengthEnforced: true,
                            maxLines: null,
                          );
                        },
                      ),
                    ),
                  ),
                ),
                new Container(
                  padding: EdgeInsets.only(right: 16.0, left: 16.0, top: 12.0),
                  child: new TextField(
                    decoration: new InputDecoration(
                      fillColor: Theme.of(context).primaryColor,
                      filled: true,
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
                  padding: EdgeInsets.only(right: 16.0, left: 16.0, top: 12.0),
                  child: new TextField(
                    decoration: new InputDecoration(
                      fillColor: Theme.of(context).primaryColor,
                      filled: true,
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
                  padding: EdgeInsets.only(right: 16.0, left: 16.0, top: 12.0),
                  child: new TextField(
                    decoration: new InputDecoration(
                      fillColor: Theme.of(context).primaryColor,
                      filled: true,
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
                  padding: EdgeInsets.only(right: 16.0, left: 16.0, top: 12.0),
                  child: new TextField(
                    decoration: new InputDecoration(
                      fillColor: Theme.of(context).primaryColor,
                      filled: true,
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
                  padding: EdgeInsets.only(right: 16.0, left: 16.0, top: 12.0),
                  child: new TextField(
                    decoration: new InputDecoration(
                      fillColor: Theme.of(context).primaryColor,
                      filled: true,
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
      ),
      onWillPop: _onWillPop,
    );
  }

  Future<bool> _onWillPop() {
    return showDialog(
          context: context,
          builder: (context) => new AlertDialog(
                title: new Text('Are you sure?'),
                content: new Text('Unsaved data will be lost.'),
                actions: <Widget>[
                  new FlatButton(
                    onPressed: () => Navigator.of(context).pop(false),
                    child: new Text('No'),
                  ),
                  new FlatButton(
                    onPressed: () => Navigator.of(context).pop(true),
                    child: new Text('Yes'),
                  ),
                ],
              ),
        ) ??
        false;
  }
}
