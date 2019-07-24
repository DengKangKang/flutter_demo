import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/common_route.dart';
import 'package:flutter_app/bloc/Bloc.dart';
import 'package:flutter_app/weight/tool.dart';

abstract class CommonPageState<T extends StatefulWidget, K extends CommonBloc>
    extends State<T> {
  K bloc;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    if (bloc != null) {
      bloc.asObservable().listen((event) {
        print(event.id);
        switch (event.id) {
          case BLOC_SHOW_END_DRAWER:
            {
              scaffoldKey.currentState.openEndDrawer();
              break;
            }
          case BLOC_EVENT_TIP:
            {
              scaffoldKey.currentState.showSnackBar(
                SnackBar(
                  content: Text(
                    event.obj,
                  ),
                ),
              );
              break;
            }
          case BLOC_EVENT_NAVIGATION_PUSH:
            {
              Navigator.of(context).push(
                CommonRoute(
                  builder: (BuildContext context) => event.obj,
                ),
              );
              break;
            }
          case BLOC_EVENT_NAVIGATION_REPLACE:
            {
              Navigator.of(context).pushReplacement(
                CommonRoute(
                  builder: (BuildContext context) => event.obj,
                ),
              );
              break;
            }
          case BLOC_EVENT_NAVIGATION_FINISH:
            {
              Navigator.of(context).pop(event.obj);
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

  @override
  void dispose() {
    bloc.onClosed();
    super.dispose();
  }
}
