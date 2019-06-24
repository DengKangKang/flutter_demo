import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_app/bloc/Bloc.dart';
import 'package:flutter_app/page/daily_page.dart';
import 'package:flutter_app/page/home_page.dart';
import 'package:flutter_app/page/personal_page.dart';

const home = 0;
const daily = 1;
const personal = 2;

class MainPage extends StatefulWidget {
  @override
  State createState() => MainPageState();
}

class MainPageState extends State<StatefulWidget> {
  MainBloc bloc;

  var _home = HomePage();
  var _daily = DailyPage();
  var _personal = PersonalPage();

  @override
  void initState() {
    if (bloc == null) {
      bloc = MainBloc();
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<int>(
        initialData: 0,
        stream: bloc.currentIndex.stream,
        builder: (
            BuildContext context,
            AsyncSnapshot<int> snapshot,
            ) {
          return body(snapshot.data);
        },
      ),
      bottomNavigationBar:  StreamBuilder<int>(
        initialData: 0,
        stream: bloc.currentIndex.stream,
        builder: (
            BuildContext context,
            AsyncSnapshot<int> snapshot,
            ) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Container(
                width: 80,
                height: 80,
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.all(Radius.circular(40)),
                  child: snapshot.data == home
                      ? Image.asset('assets/images/ico_sy_xz.png')
                      : Image.asset('assets/images/ico_sy.png'),
                  onTap: () {
                    bloc.currentIndex.add(home);
                  },
                ),
              ),
              Container(
                width: 80,
                height: 80,
                child: InkWell(
                  borderRadius: BorderRadius.all(Radius.circular(40)),
                  child: snapshot.data == daily
                      ? Image.asset('assets/images/ico_rz_xz.png')
                      : Image.asset('assets/images/ico_rz.png'),
                  onTap: () {
                    bloc.currentIndex.add(daily);
                  },
                ),
              ),
              Container(
                width: 80,
                height: 80,
                child: InkWell(
                  borderRadius: BorderRadius.all(Radius.circular(40)),
                  child: snapshot.data == personal
                      ? Image.asset('assets/images/ico_wd_xz.png')
                      : Image.asset('assets/images/ico_wd.png'),
                  onTap: () {
                    bloc.currentIndex.add(personal);
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget body(int index) {
    switch (index) {
      case home:
        return _home;
      case daily:
        return _daily;
      case personal:
        return _personal;
      default:
        return null;
    }
  }
}

class MainBloc extends CommonBloc {
  StreamController<int> currentIndex = StreamController.broadcast();
}
