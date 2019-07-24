import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_app/common_route.dart';
import 'package:flutter_app/bloc/common_bloc.dart';
import 'package:flutter_app/data/http/api_service.dart';
import 'package:flutter_app/data/http/rsp/DailiesRsp.dart';
import 'package:flutter_app/data/persistence/persistence.dart';
import 'package:flutter_app/main.dart';
import 'package:flutter_app/page/radio_list_page.dart';
import 'package:flutter_app/page/create_comment.dart';
import 'package:flutter_app/page/main_page.dart';
import 'package:flutter_app/weight/tool.dart';
import 'package:intl/intl.dart';
import 'package:rxdart/rxdart.dart';

import 'base/common_page_state.dart';
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
  Timer timer;

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
              _scrollController.position.maxScrollExtent &&
          bloc._dailies.value != null &&
          bloc._dailies.value.length >= 10) {
        bloc.loadMore();
      }
    });
    timer = Timer.periodic(
      Duration(seconds: 8),
      (_) {
        getComments();
      },
    );
    super.initState();
  }

  void getComments() async {
    var rsp = await ApiService().getComments();
    if (rsp.code == ApiService.success) {
      bloc.comments.add(rsp.data ?? []);
      mainBloc.comments.value =
          rsp.data?.where((c) => c.viewed == 0)?.length ?? 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    getComments();
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
                      child: Image.asset(
                        'assets/images/ico_htxq_jt_s.png',
                        color: Colors.black,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            onTap: b.data ? changePageState : null,
          ),
        ),
        actions: <Widget>[
          IconButton(
            icon: Image.asset('assets/images/ico_xx.png'),
            onPressed: () async {
              var rsp = await Navigator.push(
                context,
                CommonRoute(
                    builder: (c) => CommentsPage(
                          comments: bloc.comments.value,
                        )),
              );
              if (rsp != null) {
                bloc.daily_id = rsp['id'];
                bloc.selectedDay.value = rsp['date'];
                await _keyRefresh.currentState.show();
              }
            },
          ),
          StreamBuilder<int>(
            initialData: pageStatePersonal,
            stream: bloc.pageState.stream,
            builder: (c, s) => s.data == pageStatePersonal
                ? IconButton(
                    icon: Image.asset('assets/images/ico_lb_tj_gray.png'),
                    onPressed: () async {
                      var needRefresh = await Navigator.push(
                          context, CommonRoute(builder: (c) => NewDailyPage()));
                      if (needRefresh == true) {
                        await _keyRefresh.currentState.show();
                      }
                    },
                  )
                : IconButton(
                    icon: Image.asset('assets/images/ico_ss.png'),
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
              Flexible(
                child: Container(
                  margin: EdgeInsets.only(left: 20),
                  child: InkWell(
                    child: Row(
                      children: <Widget>[
                        Image.asset('assets/images/ico_wdrb_jt_z.png'),
                        Text('  前一天')
                      ],
                    ),
                    onTap: () {
                      var date = DateFormat('yyyy-MM-dd').format(
                        DateTime.parse(bloc.selectedDay.value).subtract(
                          Duration(days: 1),
                        ),
                      );
                      bloc.selectedDay.value = date;
                      bloc.daily_id = '';
                      _keyRefresh.currentState.show();
                    },
                  ),
                ),
              ),
              Flexible(
                child: InkWell(
                  child: Container(
                    width: 130,
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
                          margin: EdgeInsets.only(left: 10),
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
                      firstDate: DateTime(DateTime.now().year - 2, 12, 31),
                      lastDate: DateTime(DateTime.now().year + 10, 12, 31),
                    );
                    if (date != null) {
                      bloc.selectedDay.value =
                          DateFormat('yyyy-MM-dd').format(date);
                    }
                    bloc.daily_id = '';
                    await _keyRefresh.currentState.show();
                  },
                ),
              ),
              Flexible(
                child: InkWell(
                  child: Container(
                    margin: EdgeInsets.only(right: 20),
                    alignment: Alignment.centerRight,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Text('后一天  '),
                        Image.asset('assets/images/ico_wdrb_jt_y.png'),
                      ],
                    ),
                  ),
                  onTap: () {
                    var date = DateFormat('yyyy-MM-dd').format(
                      DateTime.parse(bloc.selectedDay.value).add(
                        Duration(days: 1),
                      ),
                    );
                    bloc.selectedDay.value = date;
                    bloc.daily_id = '';
                    _keyRefresh.currentState.show();
                  },
                ),
              ),
            ],
          ),
          StreamBuilder<List<Comment>>(
            initialData: [],
            stream: bloc.comments,
            builder: (c, s) => Visibility(
              visible: s.data != null &&
                  s.data.where((c) => c.viewed == 0).isNotEmpty,
              child: Material(
                color: Color(0xFFFCE5D2),
                child: InkWell(
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      vertical: 10,
                      horizontal: 20,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Image.asset('assets/images/ico_tx.png'),
                            Text(
                              '  您有${s.data.where((c) => c.viewed == 0)?.length}条日报评论',
                              style: TextStyle(
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                        Image.asset('assets/images/ico_wdrb_jt_y.png'),
                      ],
                    ),
                  ),
                  onTap: () async {
                    var rsp = await Navigator.push(
                      context,
                      CommonRoute(
                          builder: (c) => CommentsPage(
                                comments: s.data,
                              )),
                    );
                    if (rsp != null) {
                      bloc.daily_id = rsp['id'];
                      bloc.selectedDay.value = rsp['date'];
                      await _keyRefresh.currentState.show();
                    }
                  },
                ),
              ),
            ),
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
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Row(
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
                InkWell(
                  child: Row(
                    children: <Widget>[
                      Image.asset('assets/images/ico_rb_pl.png'),
                      Text(
                        '  评论',
                        style: TextStyle(
                          fontSize: 12,
                        ),
                      )
                    ],
                  ),
                  onTap: () {
                    comment(daily);
                  },
                )
              ],
            ),
          ),
          Divider(
            height: 1,
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
                  margin: EdgeInsets.only(top: 10),
                  child: Text(
                    "今日工作形式",
                    style: TextStyle(color: colorCyan, fontSize: 10),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(
                    top: 5,
                    bottom: 10,
                  ),
                  child: Row(
                    children: <Widget>[
                      Text(
                        '上午  ',
                        style: TextStyle(fontSize: 12, color: colorCyan),
                      ),
                      Text(
                        '${getWorkFrom(daily, true)}${daily.morn_content}',
                        style: TextStyle(fontSize: 12),
                      ),
                    ],
                  ),
                ),
                Container(
                    margin: EdgeInsets.only(
                      top: 5,
                      bottom: 10,
                    ),
                    child: Row(
                      children: <Widget>[
                        Text(
                          '下午  ',
                          style: TextStyle(fontSize: 12, color: colorCyan),
                        ),
                        Text(
                          '${getWorkFrom(daily, false)}${daily.afternoon_content}',
                          style: TextStyle(fontSize: 12),
                        ),
                      ],
                    )),
                Divider(
                  height: 1,
                ),
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
                    height: 1,
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
                    height: 1,
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
                    height: 1,
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
                    height: 1,
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
          Visibility(
            visible: daily.comments != null && daily.comments.isNotEmpty,
            child: Container(
              margin: EdgeInsets.only(
                left: 20,
                right: 20,
                bottom: 10,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Divider(
                    height: 1,
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 5),
                    child: Text(
                      "评论",
                      style: TextStyle(color: colorCyan, fontSize: 10),
                    ),
                  ),
                  ...daily.comments?.map((e) => commentItem(e)) ?? []
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  String getWorkFrom(Daily daily, [isForenoon = true]) {
    var workFrom = workForms?.firstWhere(
      (s) => s.id == (isForenoon ? daily.morn_type : daily.afternoon_type),
      orElse: () => null,
    );
    var colon = '';
    if (isForenoon) {
      colon = daily.morn_content != null && daily.morn_content.isNotEmpty
          ? '：'
          : '';
    } else {
      colon =
          daily.afternoon_content != null && daily.afternoon_content.isNotEmpty
              ? '：'
              : '';
    }
    return workFrom != null ? '$workFrom$colon' : '';
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
                child: Text('小组日报'),
              ),
            ),
          ),
        ),
      ],
    );
    if (result != null) bloc.pageState.sink.add(result);
    bloc.daily_id = '';
    await _keyRefresh.currentState.show();
  }

  @override
  bool get wantKeepAlive => true;

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  void comment(Daily daily) async {
    var needRefresh = await Navigator.of(context).push(
      CommonRoute(
          builder: (_) => CreateCommentPage(
                dailyId: daily.id,
              )),
    );
    if (needRefresh == true) {
      await _keyRefresh.currentState.show();
    }
  }

  Widget commentItem(Comment comment) => InkWell(
        child: Container(
          margin: EdgeInsets.only(top: 5),
          child: RichText(
            text: TextSpan(
              text: comment?.author ?? '',
              style: TextStyle(fontSize: 12, color: colorOrigin),
              children: [
                TextSpan(
                  text: comment.target_name != null &&
                          comment.target_name.isNotEmpty
                      ? '回复'
                      : '',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.black,
                  ),
                ),
                TextSpan(
                    text: comment.target_name != null &&
                            comment.target_name.isNotEmpty
                        ? comment.target_name
                        : '',
                    style: TextStyle(fontSize: 12, color: colorOrigin)),
                TextSpan(
                  text: '：${comment.content}',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ),
        ),
        onTap: () async {
          var needRefresh = await Navigator.of(context).push(
            CommonRoute(
              builder: (_) => CreateCommentPage(
                dailyId: comment.daily_id,
                targetId: comment.author_id,
                targetName: comment.author,
              ),
            ),
          );
          if (needRefresh == true) {
            await _keyRefresh.currentState.show();
          }
        },
      );
}

class DailyBloc extends CommonBloc {
  var pageState = BehaviorSubject<int>(seedValue: pageStatePersonal);
  var comments = BehaviorSubject<List<Comment>>(seedValue: []);
  var name = '';

  BehaviorSubject<String> selectedDay = BehaviorSubject(
    seedValue: DateFormat('yyyy-MM-dd').format(DateTime.now()),
  );
  BehaviorSubject<List<Daily>> _dailies = BehaviorSubject();

  int page = 1;
  String daily_id = '';

  @override
  Future<void> initData() async {
    print(daily_id);
    var rsp = await ApiService().getDailies(
      1,
      10,
      selectedDay.value,
      pageState.value.toString(),
      name,
      daily_id,
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

class CommentsPage extends StatelessWidget {
  CommentsPage({Key key, this.comments}) : super(key: key);
  final List<Comment> comments;

  final scaffold = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffold,
      backgroundColor: colorBg,
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        title: Text('消息'),
        actions: <Widget>[
          InkWell(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Center(
                child: Text(
                  '清空',
                  style: TextStyle(
                    fontSize: 15,
                    color: colorOrigin,
                  ),
                ),
              ),
            ),
            onTap: () async {
              onLoading(context);
              var rsp = await ApiService().clearComments();
              loadingFinish(context);
              if (rsp.code == ApiService.success) {
                Navigator.pop(context);
              } else {
                scaffold.currentState.showSnackBar(
                  SnackBar(
                    content: Text(rsp.msg),
                  ),
                );
              }
            },
          )
        ],
      ),
      body: ListView(
        children: <Widget>[
          Divider(
            height: 10,
            color: colorBg,
          ),
          ...comments.map(
            (e) => Material(
              color: Colors.white,
              child: InkWell(
                child: Container(
                  padding: EdgeInsets.only(
                    left: 20,
                    right: 20,
                    top: 10,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            e.author,
                            style: TextStyle(
                              color: colorOrigin,
                              fontSize: 11,
                            ),
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: <Widget>[
                              Text(
                                e.create_time,
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 11,
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(left: 5),
                                child: Text(
                                  e.viewed == 0 ? '未读' : '已读',
                                  style: TextStyle(
                                    color:
                                    e.viewed == 0 ? Colors.red : Colors.grey,
                                    fontSize: 11,
                                  ),
                                ),
                              )
                            ],
                          ),
                        ],
                      ),
                      Container(
                        margin: EdgeInsets.symmetric(vertical: 5),
                        child: Text(
                          e.content,
                          style: TextStyle(
                            fontSize: 14,
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(bottom: 10),
                        child: Text(
                          e.daily_time,
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 11,
                          ),
                        ),
                      ),
                      Divider(
                        height: 1,
                      )
                    ],
                  ),
                ),
                onTap: () {
                  Navigator.pop(
                    context,
                    {
                      'date': e.daily_time,
                      'id': e.daily_id,
                    },
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
