import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter_app/bloc/bloc.dart';
import 'package:rxdart/rxdart.dart';

class CommonBloc = AbstractCommonBloc
    with
        CommonBlocCloser,
        CommonBlocDataInitializer,
        CommonBlocNavigator,
        CommonBlocPageStateController,
        CommonBlocObserverTipShow,
        CommonBlocObserverTransformer
    implements Bloc;

mixin CommonBlocCloser {
  StreamController<BlocEvent> get _tipController;

  StreamController<BlocEvent> get _navigatorController;

  StreamController<BlocEvent> get _pageStateController;

  void onClosed() {
    _tipController.close();
    _navigatorController.close();
    _pageStateController.close();
  }
}

mixin CommonBlocDataInitializer {
  dynamic initData() {}
}

mixin CommonBlocNavigator {
  StreamController<BlocEvent> get _navigatorController;

  void navigate() {}

  void finish({Object result}) {
    _navigatorController.sink.add(BlocEvent.finish(result: result));
  }

  void showEndDrawer() {
    _navigatorController.sink.add(BlocEvent(blocShowEndDrawer, null));
  }
}

mixin CommonBlocPageStateController {
  StreamController<BlocEvent> get _pageStateController;

  void pageLoading() {
    _pageStateController.sink.add(BlocEvent.pageLoading());
  }

  void pageCompleted() {
    _pageStateController.sink.add(BlocEvent.pageCompleted());
  }
}

mixin CommonBlocObserverTransformer {
  StreamController<BlocEvent> get _tipController;

  StreamController<BlocEvent> get _navigatorController;

  StreamController<BlocEvent> get _pageStateController;

  Observable<BlocEvent> asObservable() {
    return Observable.merge([
      _tipController.stream,
      _navigatorController.stream,
      _pageStateController.stream
    ]);
  }
}

mixin CommonBlocObserverTipShow {
  StreamController<BlocEvent> get _tipController;

  void showTip(String tip) {
    _tipController.sink.add(BlocEvent.tip(tip));
  }
}

abstract class AbstractCommonBloc {
  var _tipController = StreamController<BlocEvent>();
  var _navigatorController = StreamController<BlocEvent>();
  var _pageStateController = StreamController<BlocEvent>();
}

class BlocEvent {
  BlocEvent(this.id, this.obj);

  BlocEvent.tip(String tip) {
    id = blocEventTip;
    obj = tip;
  }

  BlocEvent.finish({Object result}) {
    id = blocEventNavigationFinish;
    if (result != null) obj = result;
  }

  BlocEvent.pageLoading() {
    id = blocEventPageLoading;
  }

  BlocEvent.pageCompleted() {
    id = blocEventPageCompleted;
  }

  int id;
  dynamic obj;
}

class BlocProvider<T extends CommonBloc> extends InheritedWidget {
  BlocProvider({
    Key key,
    @required this.bloc,
    @required Widget child,
  }) : super(key: key, child: child);

  final T bloc;

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

const blocShowEndDrawer = -0x7;
const blocEventTip = -0x1;
const blocEventNavigationFinish = -0x2;
const blocEventNavigationPush = -0x3;
const blocEventNavigationReplace = -0x4;
const blocEventPageLoading = -0x5;
const blocEventPageCompleted = -0x6;
