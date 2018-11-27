import 'package:flutter/material.dart';
import 'package:flutter_app/CommonRoute.dart';
import 'package:flutter_app/bloc/DailyBloc.dart';
import 'package:flutter_app/page/NewDailyPage.dart';
import 'package:flutter_app/page/base/CommonPageState.dart';

class DailyPage extends StatefulWidget {
  DailyPage({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return new DailyPageState();
  }
}

class DailyPageState extends CommonPageState<DailyPage, DailyBloc> {
  @override
  void initState() {
    if (bloc == null) {
      bloc = new DailyBloc();
      bloc.dailies.add("");
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("日报"),
      ),
      floatingActionButton: new FloatingActionButton(
        child: new Icon(Icons.add),
        onPressed: () async {
          Navigator.push(context, new CommonRoute(
            builder: (c)=> new NewDailyPage()
          ));
        },
      ),
      body: new ListView.builder(
        physics: new BouncingScrollPhysics(),
        shrinkWrap: true,
        itemCount: bloc.dailies.length,
        itemBuilder: (context, i) {
          return _buildItem(i);
        },
      ),
    );
  }

  Widget _buildItem(int i) {
    return new Card(
        margin: EdgeInsets.only(
          left: 16.0,
          right: 16.0,
          top: 12.0,
          bottom: i == bloc.dailies.length - 1 ? 12.0 : 0.0,
        ),
        elevation: 2.0,
        child: new Container(
          margin: EdgeInsets.symmetric(
            vertical: 12.0,
            horizontal: 16.0,
          ),
          child: new Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              new Text(
                "122121",
                style: Theme.of(context).textTheme.title,
              ),
              new Container(
                margin: EdgeInsets.only(top: 12.0),
                child: new Text(
                  "今日工作内容",
                  style: Theme.of(context).textTheme.body1,
                ),
              ),
              new Text(
                "1111111",
                style: Theme.of(context).textTheme.body2,
              ),
              new Container(
                margin: EdgeInsets.only(top: 12.0),
                child: new Text(
                  "今日拜访/跟进用户",
                  style: Theme.of(context).textTheme.body1,
                ),
              ),
              new Text(
                "1111111",
                style: Theme.of(context).textTheme.body2,
              ),
              new Container(
                margin: EdgeInsets.only(top: 12.0),
                child: new Text(
                  "今日所遇到的问题及解决方案",
                  style: Theme.of(context).textTheme.body1,
                ),
              ),
              new Text(
                "1111111",
                style: Theme.of(context).textTheme.body2,
              ),
              new Container(
                margin: EdgeInsets.only(top: 12.0),
                child: new Text(
                  "明日工作计划",
                  style: Theme.of(context).textTheme.body1,
                ),
              ),
              new Text(
                "1111111",
                style: Theme.of(context).textTheme.body2,
              ),
              new Container(
                margin: EdgeInsets.only(top: 12.0),
                child: new Text(
                  "明日拜访/跟进用户",
                  style: Theme.of(context).textTheme.body1,
                ),
              ),
              new Text(
                "1111111",
                style: Theme.of(context).textTheme.body2,
              ),
            ],
          ),
        ));
  }
}
