import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_app/bloc/Bloc.dart';
import 'package:flutter_app/page/base/common_page_state.dart';
import 'package:flutter_app/page/client_detail_page.dart' as prefix0;
import 'package:flutter_app/page/daily_page.dart';
import 'package:flutter_app/page/home_page.dart';
import 'package:flutter_app/page/personal_page.dart';
import 'package:rxdart/rxdart.dart';

import '../main.dart';
import 'client_detail_page.dart';

const home = 0;
const daily = 1;
const personal = 2;

class MainPage extends StatefulWidget {
  @override
  State createState() => MainPageState();
}

class MainPageState extends CommonPageState<MainPage, MainBloc>
    with SingleTickerProviderStateMixin {
  var page = [HomePage(), DailyPage(), PersonalPage()];

  TabController controller;

  @override
  void initState() {
    if (bloc == null) {
      bloc = MainBloc();
    }
    if (controller == null) {
      controller = TabController(length: 3, vsync: this);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<MainBloc>(
      bloc: bloc,
      child: Scaffold(
        key: scaffoldKey,
        body: TabBarView(
          physics: NeverScrollableScrollPhysics(),
          controller: controller,
          children: <Widget>[...page],
        ),
        bottomNavigationBar: StreamBuilder<int>(
          initialData: 0,
          stream: bloc.currentIndex.stream,
          builder: (
            BuildContext context,
            AsyncSnapshot<int> snapshot,
          ) {
            return Container(
              height: 70,
              child: Row(
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  Expanded(
                    child: Container(
                      child: GestureDetector(
                        child: snapshot.data == home
                            ? Image.asset('assets/images/ico_sy_xz.png')
                            : Image.asset('assets/images/ico_sy.png'),
                        onTap: () {
                          bloc.currentIndex.sink.add(0);
                          controller.animateTo(0);
                        },
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      child: GestureDetector(
                        child: snapshot.data == daily
                            ? Image.asset('assets/images/ico_rz_xz.png')
                            : Container(
                                child: Stack(
                                  alignment: Alignment.center,
                                  children: <Widget>[
                                    Image.asset('assets/images/ico_rz.png'),
                                    StreamBuilder(
                                      stream: bloc.comments,
                                      builder: (c, s) => Visibility(
                                        visible: s.data != null && s.data != 0,
                                        child: Container(
                                          margin: EdgeInsets.only(
                                              bottom: 15, left: 15),
                                          width: 15,
                                          height: 15,
                                          decoration: BoxDecoration(
                                              color: colorOrigin,
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(12))),
                                          child: Center(
                                            child: Text(
                                              '${s.data ?? 0}',
                                              style: TextStyle(
                                                fontSize: 10,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                        onTap: () {
                          bloc.currentIndex.sink.add(1);
                          controller.animateTo(1);
                        },
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      child: GestureDetector(
                        child: snapshot.data == personal
                            ? Image.asset('assets/images/ico_wd_xz.png')
                            : Image.asset('assets/images/ico_wd.png'),
                        onTap: () {
                          bloc.currentIndex.sink.add(2);
                          controller.animateTo(2);
                        },
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
        endDrawer: Drawer(
          elevation: 0,
          child: Filter(),
        ),
      ),
    );
  }
}

class MainBloc extends CommonBloc {
  StreamController<int> currentIndex = StreamController.broadcast();
  var onFilterConfirm = BehaviorSubject<String>();
  var comments = BehaviorSubject<int>(seedValue: 0);

  @override
  void onClosed() {
    currentIndex.close();
    onFilterConfirm.close();
    super.onClosed();
  }
}

class Filter extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return FilterState();
  }
}

class FilterState extends State<Filter> with TickerProviderStateMixin {
  var _actions = List<prefix0.Action>();

  var name;

  MainBloc bloc;

  @override
  void initState() {
    bloc = BlocProvider.of(context);
    name = bloc.onFilterConfirm.value ?? '';
    _actions.add(ActionButton(
      '重置',
      colorCyan,
      reset,
    ));
    _actions.add(ActionDivider());
    _actions.add(ActionButton(
      '筛选',
      colorOrigin,
      filter,
    ));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      child: Column(
        children: <Widget>[
          Flexible(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: ListView(
                physics: BouncingScrollPhysics(),
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(top: 20),
                    child: Text(
                      '名称',
                      style: TextStyle(fontSize: 12),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(7),
                    margin: EdgeInsets.only(top: 5),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(4)),
                      border: Border.all(color: colorDivider),
                    ),
                    child: TextField(
                      textAlign: TextAlign.center,
                      controller: TextEditingController.fromValue(
                        TextEditingValue(
                          text: name,
                        ),
                      ),
                      style: TextStyle(fontSize: 12),
                      decoration: InputDecoration(
                        hintText: '请输组员的名称',
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.all(0),
                      ),
                      onChanged: (s) {
                        name = s;
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
          Container(
            height: 60,
            child: Material(
              elevation: 0,
              color: Colors.white,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  ..._actions.map((a) => a.build()),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void reset() {
    setState(() {
      name = '';
    });
  }

  void filter() {
    bloc.onFilterConfirm.sink.add(name);
    Navigator.pop(context);
  }
}
