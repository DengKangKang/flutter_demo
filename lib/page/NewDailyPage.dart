import 'package:flutter/material.dart';
import 'package:flutter_app/page/base/CommonPageState.dart';
import 'package:flutter_app/bloc/NewDailyBloc.dart';
import 'package:intl/intl.dart';

class NewDailyPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return NewDailyPageState();
  }
}

class NewDailyPageState extends CommonPageState<NewDailyPage, NewDailyBloc> {
  @override
  void initState() {
    if (bloc == null) {
      bloc = NewDailyBloc();
      bloc.initData();
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: Scaffold(
        key: scaffoldKey,
        appBar: AppBar(
          title: Text("新增日报"),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.check),
              onPressed: () {
                bloc.save();
              },
            )
          ],
        ),
        body: Container(
          child: Theme(
            data: Theme.of(context).copyWith(
              primaryColor: Colors.blue,
            ),
            child: ListView(
              children: <Widget>[
                Container(
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
                        bloc.date = DateFormat('yyyy-MM-dd').format(date);
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
                          return TextField(
                            controller: TextEditingController(
                              text: snapshot.data,
                            ),
                            decoration: InputDecoration(
                              fillColor: Color(0xFFf6f6f9),
                              filled: true,
                              suffixIcon: Icon(Icons.keyboard_arrow_down),
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
                Container(
                  padding: EdgeInsets.only(right: 16.0, left: 16.0, top: 12.0),
                  child: TextField(
                    decoration: InputDecoration(
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
                Container(
                  padding: EdgeInsets.only(right: 16.0, left: 16.0, top: 12.0),
                  child: TextField(
                    decoration: InputDecoration(
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
                Container(
                  padding: EdgeInsets.only(right: 16.0, left: 16.0, top: 12.0),
                  child: TextField(
                    decoration: InputDecoration(
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
                Container(
                  padding: EdgeInsets.only(right: 16.0, left: 16.0, top: 12.0),
                  child: TextField(
                    decoration: InputDecoration(
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
                Container(
                  padding: EdgeInsets.only(right: 16.0, left: 16.0, top: 12.0),
                  child: TextField(
                    decoration: InputDecoration(
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
          builder: (context) => AlertDialog(
                title: Text('Are you sure?'),
                content: Text('Unsaved data will be lost.'),
                actions: <Widget>[
                  FlatButton(
                    onPressed: () => Navigator.of(context).pop(false),
                    child: Text('No'),
                  ),
                  FlatButton(
                    onPressed: () => Navigator.of(context).pop(true),
                    child: Text('Yes'),
                  ),
                ],
              ),
        ) ??
        false;
  }
}
