import 'package:flutter_app/bloc/Bloc.dart';
import 'package:flutter_app/data/http/ApiService.dart';
import 'package:intl/intl.dart';
import 'package:rxdart/rxdart.dart';

class NewDailyBloc extends CommonBloc {
  BehaviorSubject<String> _date = BehaviorSubject(
    seedValue: DateFormat('yyyy-MM-dd').format(
      DateTime.now(),
    ),
  );
  String _todayWorkContent = "";
  String _todayVisitClient = "";
  String _todaySolution = "";
  String _tomorrowPlane = "";
  String _tomorrowVisitClient = "";

  dynamic get date => _date.stream;

  set date(String value) {
    _date.sink.add(value);
  }

  set todayWorkContent(String value) {
    if (value != _todayWorkContent) _todayWorkContent = value;
  }

  set tomorrowVisitClient(String value) {
    if (value != _tomorrowVisitClient) _tomorrowVisitClient = value;
  }

  set tomorrowPlane(String value) {
    if (value != _tomorrowPlane) _tomorrowPlane = value;
  }

  set todaySolution(String value) {
    if (value != _todaySolution) _todaySolution = value;
  }

  set todayVisitClient(String value) {
    if (value != _todayVisitClient) _todayVisitClient = value;
  }

  @override
  void onClosed() {
    _date.close();
    super.onClosed();
  }

  void save() async {
    if (_todayWorkContent.isEmpty &&
        _todayVisitClient.isEmpty &&
        _todaySolution.isEmpty &&
        _tomorrowPlane.isEmpty &&
        _tomorrowVisitClient.isEmpty) {
      showTip("请至少输入一项！");
      return;
    }
    pageLoading();
    var rsp = await ApiService().newDaily(
      _date.value,
      _todayWorkContent,
      _todayVisitClient,
      _todaySolution,
      _tomorrowPlane,
      _tomorrowVisitClient,
    );
    pageCompleted();
    if (rsp.code == ApiService.success) {
      finish(result: true);
    } else {
      showTip(rsp.msg);
    }
  }
}
