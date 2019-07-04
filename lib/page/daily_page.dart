import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_app/CommonRoute.dart';
import 'package:flutter_app/bloc/Bloc.dart';
import 'package:flutter_app/data/http/api_service.dart';
import 'package:flutter_app/data/http/rsp/DailiesRsp.dart';
import 'package:flutter_app/data/persistence/Persistence.dart';
import 'package:flutter_app/main.dart';
import 'package:flutter_app/page/main_page.dart';
import 'package:intl/intl.dart';
import 'package:rxdart/rxdart.dart';

import 'base/CommonPageState.dart';
import 'new_daily_page.dart';

const pageStateGroupMembers = 2;
const pageStatePersonal = 1;

class DailyPage extends StatefulWidget {
  @override
  State createState() => DailyPageState();
}

class DailyPageState extends CommonPageState<DailyPage, DailyBloc>
    with AutomaticKeepAliveClientMixin<DailyPage> {
  ScrollController _scrollController = ScrollController();
  GlobalKey _keyTitle = GlobalKey();
  GlobalKey<RefreshIndicatorState> _keyRefresh = GlobalKey();
  MainBloc mainBloc;

  @override
  void initState() {
    if (bloc == null) {
      bloc = DailyBloc();
    }
    SchedulerBinding.instance.addPostFrameCallback(
      (_) => {_keyRefresh.currentState.show()},
    );
    if (mainBloc == null) {
      mainBloc = BlocProvider.of(context);
      mainBloc.onFilterConfirm.listen((d) {
        bloc.name = d ?? '';
        _keyRefresh.currentState.show();
      });
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
    super.build(context);
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        key: _keyTitle,
        elevation: 0,
        centerTitle: true,
        title: StreamBuilder<bool>(
          initialData: false,
          stream: Persistence().userAuthority,
          builder: (c, b) => InkWell(
            child: StreamBuilder<int>(
              initialData: pageStatePersonal,
              stream: bloc.pageState.stream,
              builder: (c, s) => Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text(s.data == pageStatePersonal ? '我的日报' : '组员日报'),
                  Visibility(
                    visible: b.data,
                    child: Container(
                      margin: EdgeInsets.only(left: 5),
                      child: Image.asset('assets/images/ico_htxq_jt_s.png'),
                    ),
                  ),
                ],
              ),
            ),
            onTap: b.data ? changePageState : null,
          ),
        ),
        actions: <Widget>[
          StreamBuilder<int>(
            initialData: pageStatePersonal,
            stream: bloc.pageState.stream,
            builder: (c, s) => s.data == pageStatePersonal
                ? IconButton(
                    icon: Icon(Icons.add_circle_outline),
                    onPressed: () async {
                      var needRefresh = await Navigator.push(
                          context, CommonRoute(builder: (c) => NewDailyPage()));
                      if (needRefresh == true) {
                        await _keyRefresh.currentState.show();
                      }
                    },
                  )
                : IconButton(
                    icon: Icon(Icons.search),
                    onPressed: () {
                      mainBloc.showEndDrawer();
                    },
                  ),
          ),
        ],
      ),
      body: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              InkWell(
                child: Row(
                  children: <Widget>[
                    Icon(Icons.keyboard_arrow_left),
                    Text('前一天')
                  ],
                ),
                onTap: () {
                  var date = DateFormat('yyyy-MM-dd').format(
                    DateTime.parse(bloc.selectedDay.value).subtract(
                      Duration(days: 1),
                    ),
                  );
                  bloc.selectedDay.value = date;
                  _keyRefresh.currentState.show();
                },
              ),
              InkWell(
                child: Container(
                  padding: EdgeInsets.symmetric(
                    vertical: 6,
                    horizontal: 10,
                  ),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.all(Radius.circular(5)),
                  ),
                  child: Row(
                    children: <Widget>[
                      StreamBuilder(
                        stream: bloc.selectedDay.stream,
                        builder: (c, s) => Text(
                          s.data ?? '',
                          style: TextStyle(
                            fontSize: 14,
                            color: colorOrigin,
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 14),
                        child: Image.asset('assets/images/ico_rb_rq.png'),
                      ),
                    ],
                  ),
                ),
                onTap: () async {
                  var initData = bloc.selectedDay.value?.isNotEmpty == true
                      ? DateTime.parse(
                          bloc.selectedDay.value,
                        )
                      : DateTime.now();
                  var date = await showDatePicker(
                    context: context,
                    initialDate: initData,
                    firstDate:DateTime(DateTime.now().year - 2, 12, 31),
                    lastDate: DateTime(DateTime.now().year + 10, 12, 31),
                  );
                  if (date != null) {
                    bloc.selectedDay.value =
                        DateFormat('yyyy-MM-dd').format(date);
                  }
                  await _keyRefresh.currentState.show();
                },
              ),
              InkWell(
                child: Row(
                  children: <Widget>[
                    Text('后一天'),
                    Icon(Icons.keyboard_arrow_right),
                  ],
                ),
                onTap: () {
                  var date = DateFormat('yyyy-MM-dd').format(
                    DateTime.parse(bloc.selectedDay.value).add(
                      Duration(days: 1),
                    ),
                  );
                  bloc.selectedDay.value = date;
                  _keyRefresh.currentState.show();
                },
              )
            ],
          ),
          StreamBuilder<List<Daily>>(
            initialData: List<Daily>(),
            stream: bloc.dailies,
            builder: (c, s) => Flexible(
              child: RefreshIndicator(
                  key: _keyRefresh,
                  child: ListView.builder(
                    physics: AlwaysScrollableScrollPhysics(),
                    controller: _scrollController,
                    itemCount: s.data.length,
                    itemBuilder: (context, i) {
                      return _buildItem(i, s.data);
                    },
                  ),
                  onRefresh: () => bloc.initData()),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildItem(int i, List<Daily> dailies) {
    var daily = dailies[i];
    return Card(
      margin: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 20,
        bottom: i == dailies.length - 1 ? 20 : 0,
      ),
      elevation: defaultElevation / 2,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            margin: EdgeInsets.symmetric(
              vertical: 10,
              horizontal: 20,
            ),
            child: Row(
              children: <Widget>[
                Visibility(
                  visible: bloc.pageState.value == pageStateGroupMembers,
                  child: Container(
                    margin: EdgeInsets.only(right: 10),
                    child: Text(
                      daily.user_realname ?? '',
                      style: TextStyle(color: colorOrigin, fontSize: 14),
                    ),
                  ),
                ),
                Container(
                  child: Text(
                    daily.daily_time,
                    style: TextStyle(color: colorOrigin, fontSize: 14),
                  ),
                ),
              ],
            ),
          ),
          Divider(
            height: 2,
            color: Colors.grey,
          ),
          Container(
            margin: EdgeInsets.symmetric(
              horizontal: 20,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  margin: EdgeInsets.symmetric(vertical: 5),
                  child: Text(
                    "今日工作内容",
                    style: TextStyle(color: colorCyan, fontSize: 10),
                  ),
                ),
                Text(
                  daily.today_content ?? '',
                  style: TextStyle(fontSize: 12),
                ),
                Container(
                  margin: EdgeInsets.only(top: 10),
                  child: Divider(
                    height: 2,
                  ),
                ),
                Container(
                  margin: EdgeInsets.symmetric(vertical: 5),
                  child: Text(
                    "今日拜访/跟进用户",
                    style: TextStyle(color: colorCyan, fontSize: 10),
                  ),
                ),
                Text(
                  daily.today_customer_visit ?? '',
                  style: TextStyle(fontSize: 12),
                ),
                Container(
                  margin: EdgeInsets.only(top: 10),
                  child: Divider(
                    height: 2,
                  ),
                ),
                Container(
                  margin: EdgeInsets.symmetric(vertical: 5),
                  child: Text(
                    "今日所遇到的问题及解决方案",
                    style: TextStyle(color: colorCyan, fontSize: 10),
                  ),
                ),
                Text(
                  daily.today_solution ?? '',
                  style: TextStyle(fontSize: 12),
                ),
                Container(
                  margin: EdgeInsets.only(top: 10),
                  child: Divider(
                    height: 2,
                  ),
                ),
                Container(
                  margin: EdgeInsets.symmetric(vertical: 5),
                  child: Text(
                    "明日工作计划",
                    style: TextStyle(color: colorCyan, fontSize: 10),
                  ),
                ),
                Text(
                  daily.next_plan ?? '',
                  style: TextStyle(fontSize: 12),
                ),
                Container(
                  margin: EdgeInsets.only(top: 10),
                  child: Divider(
                    height: 2,
                  ),
                ),
                Container(
                  margin: EdgeInsets.symmetric(vertical: 5),
                  child: Text(
                    "明日拜访/跟进用户",
                    style: TextStyle(color: colorCyan, fontSize: 10),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(bottom: 10),
                  child: Text(
                    daily.next_customer_visit ?? '',
                    style: TextStyle(fontSize: 12),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void changePageState() async {
    final RenderBox overlay = Overlay.of(context).context.findRenderObject();
    print(Offset.zero & overlay.size);
    double b = _keyTitle.currentContext.findRenderObject().paintBounds.bottom;
    double l = (overlay.size.width - 168) / 2;
    double r = overlay.size.width - l;
    final result = await showMenu(
      context: context,
      position: RelativeRect.fromLTRB(l, b, r, 0),
      items: <PopupMenuEntry<int>>[
        PopupMenuItem<int>(
          value: pageStatePersonal,
          child: Center(
            child: Container(
              width: 100,
              child: Center(
                child: Text('我的日报'),
              ),
            ),
          ),
        ),
        PopupMenuDivider(
          height: 1,
        ),
        PopupMenuItem<int>(
          value: pageStateGroupMembers,
          child: Center(
            child: Container(
              width: 100,
              child: Center(
                child: Text('组员日报'),
              ),
            ),
          ),
        ),
      ],
    );
    if (result != null) bloc.pageState.sink.add(result);
    await _keyRefresh.currentState.show();
  }

  @override
  bool get wantKeepAlive => true;
}

class DailyBloc extends CommonBloc {
  var pageState = BehaviorSubject<int>(seedValue: pageStatePersonal);
  var name = '';

  BehaviorSubject<String> selectedDay = BehaviorSubject(
    seedValue: DateFormat('yyyy-MM-dd').format(DateTime.now()),
  );
  BehaviorSubject<List<Daily>> _dailies = BehaviorSubject();

  int page = 1;

  @override
  Future<void> initData() async {
    var rsp = await ApiService().getDailies(
      1,
      10,
      selectedDay.value,
      pageState.value.toString(),
      name,
    );
    if (rsp.code == ApiService.success) {
      var dailiesRsp = rsp as DailiesRsp;
      _dailies.sink.add(dailiesRsp.data.list);
      page = 1;
    }
  }

  void loadMore() async {
    var rsp = await ApiService().getDailies(
      page + 1,
      10,
      selectedDay.value,
      pageState.value.toString(),
      name,
    );
    if (rsp.code == ApiService.success) {
      var dailiesRsp = rsp as DailiesRsp;
      if (dailiesRsp?.data?.list != null &&
          dailiesRsp?.data?.list?.isNotEmpty == true) {
        page++;
        _dailies.value.addAll(dailiesRsp?.data?.list);
        _dailies.sink.add(_dailies.value);
      }
    }
  }

  Stream<List<Daily>> get dailies => _dailies.stream;

  @override
  void onClosed() {
    _dailies.close();
    super.onClosed();
  }
}
