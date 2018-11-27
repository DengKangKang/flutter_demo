import 'dart:async';

import 'package:flutter_app/bloc/Bloc.dart';
import 'package:flutter_app/data/http/ApiService.dart';
import 'package:flutter_app/data/http/rsp/DailiesRsp.dart';

class DailyBloc extends CommonBloc {
  StreamController<List<String>> _dailies = new StreamController();

  @override
  void initData() async {
    var rsp = await new ApiService().getDailies(1, 15);
    if(rsp.code == ApiService.success){
      var dailiesRsp = rsp as DailiesRsp;
      var list = new List<String>();
      list.add("");
      list.add("");
      list.add("");
//      _dailies.sink.add(dailiesRsp.code);
    }

  }

  Stream<List<String>> get dailies => _dailies.stream;

  @override
  void onClosed() {
    _dailies.close();
    super.onClosed();
  }
}
