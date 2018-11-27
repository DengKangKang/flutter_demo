import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:rxdart/rxdart.dart';

abstract class Bloc {
  void onClosed();
}

abstract class DataInitializer {
  Future<void> initData();
}

abstract class BlocNavigator {
  void navigate();

  void finish();
}

abstract class PageStateController {
  void pageLoading();

  void pageCompleted();
}

abstract class TipShow {
  void showTip(String tip);
}

class BlocEvent {
  int id;
  dynamic obj;

  BlocEvent(this.id, this.obj);

  BlocEvent.tip(String tip) {
    id = BLOC_EVENT_TIP;
    obj = tip;
  }

  BlocEvent.finish({Object result}) {
    id = BLOC_EVENT_NAVIGATION_FINISH;
    if (result != null) obj = result;
  }

  BlocEvent.pageLoading() {
    id = BLOC_EVENT_PAGE_LOADING;
  }

  BlocEvent.pageCompleted() {
    id = BLOC_EVENT_PAGE_COMPLETED;
  }
}

class CommonBloc extends Bloc
    implements BlocNavigator, PageStateController, TipShow, DataInitializer {
  var _tipController = StreamController<BlocEvent>();
  var _navigatorController = StreamController<BlocEvent>();
  var _pageStateController = StreamController<BlocEvent>();

  @override
  Future<void> initData() {}

  @override
  void showTip(String tip) {
    _tipController.sink.add(BlocEvent.tip(tip));
  }

  @override
  void navigate() {}

  @override
  void finish({Object result}) {
    _navigatorController.sink.add(BlocEvent.finish(result: result));
  }

  @override
  void pageLoading() {
    _pageStateController.sink.add(BlocEvent.pageLoading());
  }

  @override
  void pageCompleted() {
    _pageStateController.sink.add(BlocEvent.pageCompleted());
  }

  @override
  void onClosed() {
    _tipController.close();
    _navigatorController.close();
    _pageStateController.close();
  }

  Observable<BlocEvent> asObservable() {
    return Observable.merge([
      _tipController.stream,
      _navigatorController.stream,
      _pageStateController.stream
    ]);
  }
}

class BlocProvider<T extends CommonBloc> extends InheritedWidget {
  final T bloc;

  BlocProvider({
    Key key,
    @required this.bloc,
    @required Widget child,
  }) : super(key: key, child: child);

  static T of<T extends CommonBloc>(BuildContext context) {
    final type = _typeOf<BlocProvider<T>>();
    BlocProvider<T> provider = context.ancestorWidgetOfExactType(type);
    return provider.bloc;
  }

  static Type _typeOf<T>() => T;

  @override
  bool updateShouldNotify(BlocProvider oldWidget) {
    return bloc != oldWidget.bloc;
  }
}

const BLOC_EVENT_TIP = -0x1;
const BLOC_EVENT_NAVIGATION_FINISH = -0x2;
const BLOC_EVENT_NAVIGATION_PUSH = -0x3;
const BLOC_EVENT_NAVIGATION_REPLACE = -0x4;
const BLOC_EVENT_PAGE_LOADING = -0x5;
const BLOC_EVENT_PAGE_COMPLETED = -0x6;
