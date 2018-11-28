import 'package:flutter/material.dart';
import 'package:flutter_app/CommonRoute.dart';
import 'package:flutter_app/bloc/DailyBloc.dart';
import 'package:flutter_app/data/http/rsp/DailiesRsp.dart';
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
  ScrollController _scrollController = new ScrollController();

  @override
  void initState() {
    if (bloc == null) {
      bloc = new DailyBloc();
      bloc.initData();
    }
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        bloc.loadMore();
      }
    });
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
          var needRefresh = await Navigator.push(
              context, new CommonRoute(builder: (c) => new NewDailyPage()));
          if (needRefresh == true) {
            bloc.initData();
          }
        },
      ),
      body: new RefreshIndicator(
          child: StreamBuilder<List<Daily>>(
            initialData: new List<Daily>(),
            stream: bloc.dailies,
            builder: (BuildContext context,
                AsyncSnapshot<List<Daily>> snapshot) {
              return new ListView.builder(
                physics: AlwaysScrollableScrollPhysics(),
                controller: _scrollController,
                itemCount: snapshot.data.length,
                itemBuilder: (context, i) {
                  return _buildItem(i, snapshot.data);
                },
              );
            },
          ),
          onRefresh: () => bloc.initData()),
    );
  }

  Widget _buildItem(int i, List<Daily> dailies) {
    var daily = dailies[i];
    return new Card(
        margin: EdgeInsets.only(
          left: 16.0,
          right: 16.0,
          top: 12.0,
          bottom: i == dailies.length - 1 ? 12.0 : 0.0,
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
                daily.daily_time,
                style: Theme.of(context).textTheme.title.merge(
                      new TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
              ),
              new Container(
                margin: EdgeInsets.only(top: 12.0, bottom: 4.0),
                child: new Text(
                  "今日工作内容",
                  style: Theme.of(context).textTheme.subhead.merge(
                        new TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                ),
              ),
              new Text(
                daily.today_content,
                style: Theme.of(context).textTheme.body1,
              ),
              new Container(
                margin: EdgeInsets.only(top: 12.0, bottom: 4.0),
                child: new Text(
                  "今日拜访/跟进用户",
                  style: Theme.of(context).textTheme.subhead.merge(
                        new TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                ),
              ),
              new Text(
                daily.today_customer_visit,
                style: Theme.of(context).textTheme.body1,
              ),
              new Container(
                margin: EdgeInsets.only(top: 12.0, bottom: 4.0),
                child: new Text(
                  "今日所遇到的问题及解决方案",
                  style: Theme.of(context).textTheme.subhead.merge(
                        new TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                ),
              ),
              new Text(
                daily.today_solution,
                style: Theme.of(context).textTheme.body1,
              ),
              new Container(
                margin: EdgeInsets.only(top: 12.0, bottom: 4.0),
                child: new Text(
                  "明日工作计划",
                  style: Theme.of(context).textTheme.subhead.merge(
                        new TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                ),
              ),
              new Text(
                daily.next_plan,
                style: Theme.of(context).textTheme.body1,
              ),
              new Container(
                margin: EdgeInsets.only(top: 12.0, bottom: 4.0),
                child: new Text(
                  "明日拜访/跟进用户",
                  style: Theme.of(context).textTheme.subhead.merge(
                        new TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                ),
              ),
              new Text(
                daily.next_customer_visit,
                style: Theme.of(context).textTheme.body1,
              ),
            ],
          ),
        ));
  }

}
