import 'package:rxdart/rxdart.dart';

abstract class AbstractBloc {}

abstract class Closer {
  void onClosed();
}

abstract class DataInitializer {
  dynamic initData();
}

abstract class PageNavigator {
  void navigate();

  void finish();
}

abstract class PageStateController {
  void pageLoading();

  void pageCompleted();

  void showEndDrawer();
}

abstract class TipShow {
  void showTip(String tip);
}

abstract class ObserverTransformer {
  Observable asObservable();
}



abstract class Bloc = AbstractBloc
    with
        Closer,
        DataInitializer,
        PageNavigator,
        PageStateController,
        TipShow,
        ObserverTransformer;


