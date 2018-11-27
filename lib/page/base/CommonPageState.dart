import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/CommonRoute.dart';
import 'package:flutter_app/bloc/Bloc.dart';
import 'package:flutter_app/weight/Tool.dart';

abstract class CommonPageState<T extends StatefulWidget, K extends CommonBloc>
    extends State<T> {
  K bloc;

  final scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  void initState() {
    if (bloc != null) {
      bloc.asObservable().listen((event) {
        print(event.id);
        switch (event.id) {
          case BLOC_EVENT_TIP:
            {
              scaffoldKey.currentState.showSnackBar(
                new SnackBar(
                  content: new Text(
                    event.obj,
                  ),
                ),
              );
              break;
            }
          case BLOC_EVENT_NAVIGATION_PUSH:
            {
              Navigator.of(context).push(
                new CommonRoute(
                  builder: (BuildContext context) => event.obj,
                ),
              );
              break;
            }
          case BLOC_EVENT_NAVIGATION_REPLACE:
            {
              Navigator.of(context).pushReplacement(
                new CommonRoute(
                  builder: (BuildContext context) => event.obj,
                ),
              );
              break;
            }
          case BLOC_EVENT_NAVIGATION_FINISH:
            {
              Navigator.of(context).pop(true);
              break;
            }
          case BLOC_EVENT_PAGE_LOADING:
            {
              onLoading(context);

              break;
            }
          case BLOC_EVENT_PAGE_COMPLETED:
            {
              loadingFinish(context);
              break;
            }
          default:
            break;
        }
      });
    }
    super.initState();
  }
}
