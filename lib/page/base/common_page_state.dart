import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/bloc/bloc.dart';
import 'package:flutter_app/common_route.dart';
import 'package:flutter_app/bloc/common_bloc.dart';
import 'package:flutter_app/weight/tool.dart';

abstract class CommonPageState<T extends StatefulWidget, K extends Bloc>
    extends State<T> {
  K bloc;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    if (bloc != null) {
      bloc.asObservable().listen((event) {
        print(event.id);
        switch (event.id) {
          case blocShowEndDrawer:
            {
              scaffoldKey.currentState.openEndDrawer();
              break;
            }
          case blocEventTip:
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
          case blocEventNavigationPush:
            {
              Navigator.of(context).push(
                CommonRoute(
                  builder: (BuildContext context) => event.obj,
                ),
              );
              break;
            }
          case blocEventNavigationReplace:
            {
              Navigator.of(context).pushReplacement(
                CommonRoute(
                  builder: (BuildContext context) => event.obj,
                ),
              );
              break;
            }
          case blocEventNavigationFinish:
            {
              Navigator.of(context).pop(event.obj);
              break;
            }
          case blocEventPageLoading:
            {
              onLoading(context);

              break;
            }
          case blocEventPageCompleted:
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
