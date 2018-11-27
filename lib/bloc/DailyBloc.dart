import 'package:flutter_app/bloc/Bloc.dart';

class DailyBloc extends CommonBloc{

  List<String> _dailies = new List();

  List<String> get dailies => _dailies;


}