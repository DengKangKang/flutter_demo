import 'dart:async';

import 'package:flutter_app/bloc/Bloc.dart';
import 'package:flutter_app/data/http/ApiService.dart';
import 'package:flutter_app/data/http/rsp/DailiesRsp.dart';
import 'package:rxdart/rxdart.dart';

class DailyBloc extends CommonBloc {
  BehaviorSubject<List<Daily>> _dailies = new BehaviorSubject();

  int page = 1;

  @override
  Future<void> initData() async {
    var rsp = await new ApiService().getDailies(1, 10);
    if (rsp.code == ApiService.success) {
      var dailiesRsp = rsp as DailiesRsp;
      _dailies.sink.add(dailiesRsp.data.list);
      page = 1;
    }
    return null;
  }

  void loadMore() async{
    var rsp = await new ApiService().getDailies(page+1, 10);
    if (rsp.code == ApiService.success) {
      var dailiesRsp = rsp as DailiesRsp;
      if(dailiesRsp?.data?.list != null && dailiesRsp?.data?.list?.isNotEmpty == true){
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
