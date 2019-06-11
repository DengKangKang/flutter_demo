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
    return DailyPageState();
  }
}

class DailyPageState extends CommonPageState<DailyPage, DailyBloc> {
  ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    if (bloc == null) {
      bloc = DailyBloc();
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
    return Scaffold(
      appBar: AppBar(
        title: Text("日报"),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () async {
          var needRefresh = await Navigator.push(
              context, CommonRoute(builder: (c) => NewDailyPage()));
          if (needRefresh == true) {
            await bloc.initData();
          }
        },
      ),
      body: RefreshIndicator(
          child: StreamBuilder<List<Daily>>(
            initialData: List<Daily>(),
            stream: bloc.dailies,
            builder:
                (BuildContext context, AsyncSnapshot<List<Daily>> snapshot) {
              return ListView.builder(
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
    return Card(
        margin: EdgeInsets.only(
          left: 16.0,
          right: 16.0,
          top: 12.0,
          bottom: i == dailies.length - 1 ? 12.0 : 0.0,
        ),
        elevation: 2.0,
        child: Container(
          margin: EdgeInsets.symmetric(
            vertical: 12.0,
            horizontal: 16.0,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                daily.daily_time,
                style: Theme.of(context).textTheme.title.merge(
                      TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
              ),
              Container(
                margin: EdgeInsets.only(top: 12.0, bottom: 4.0),
                child: Text(
                  "今日工作内容",
                  style: Theme.of(context).textTheme.subhead.merge(
                        TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                ),
              ),
              Text(
                daily.today_content,
                style: Theme.of(context).textTheme.body1,
              ),
              Container(
                margin: EdgeInsets.only(top: 12.0, bottom: 4.0),
                child: Text(
                  "今日拜访/跟进用户",
                  style: Theme.of(context).textTheme.subhead.merge(
                        TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                ),
              ),
              Text(
                daily.today_customer_visit,
                style: Theme.of(context).textTheme.body1,
              ),
              Container(
                margin: EdgeInsets.only(top: 12.0, bottom: 4.0),
                child: Text(
                  "今日所遇到的问题及解决方案",
                  style: Theme.of(context).textTheme.subhead.merge(
                        TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                ),
              ),
              Text(
                daily.today_solution,
                style: Theme.of(context).textTheme.body1,
              ),
              Container(
                margin: EdgeInsets.only(top: 12.0, bottom: 4.0),
                child: Text(
                  "明日工作计划",
                  style: Theme.of(context).textTheme.subhead.merge(
                        TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                ),
              ),
              Text(
                daily.next_plan,
                style: Theme.of(context).textTheme.body1,
              ),
              Container(
                margin: EdgeInsets.only(top: 12.0, bottom: 4.0),
                child: Text(
                  "明日拜访/跟进用户",
                  style: Theme.of(context).textTheme.subhead.merge(
                        TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                ),
              ),
              Text(
                daily.next_customer_visit,
                style: Theme.of(context).textTheme.body1,
              ),
            ],
          ),
        ));
  }
}
