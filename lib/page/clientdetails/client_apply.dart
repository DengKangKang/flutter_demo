import 'package:flutter/material.dart';
import 'package:flutter_app/common_route.dart';
import 'package:flutter_app/data/http/api_service.dart';
import 'package:flutter_app/data/http/rsp/apply_info.dart';
import 'package:flutter_app/data/http/rsp/data/clients_data.dart';
import 'package:flutter_app/page/clientdetails/apply_account/client_apply_debug_account_page.dart';
import 'package:flutter_app/page/clientdetails/apply_account/client_debug_account_page.dart';
import 'package:flutter_app/page/clientdetails/client_apply_train.dart';
import 'package:rxdart/rxdart.dart';

const applyStateApply = 0;
const applyStateApplying = 1;
const applyStateApplied = 2;

class ClientApplyPage extends StatefulWidget {
  const ClientApplyPage({Key key, this.client}) : super(key: key);

  final Client client;

  @override
  State<StatefulWidget> createState() {
    return ClientApplyPageState();
  }
}

class ClientApplyPageState extends State<ClientApplyPage>
    with AutomaticKeepAliveClientMixin {
  var releaseAccountState = BehaviorSubject<int>(seedValue: applyStateApply);
  var debugAccountState = BehaviorSubject<int>(seedValue: applyStateApply);
  var trainAccountState = BehaviorSubject<int>(seedValue: applyStateApply);
  var trainLogs = BehaviorSubject<List<TrainLog>>(seedValue: []);

  @override
  void initState() {
    initData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return StreamBuilder<List>(
      initialData: [],
      stream: trainLogs,
      builder: (c, s) => ListView(
            physics: BouncingScrollPhysics(),
            children: <Widget>[
              Container(
                child: Material(
                  color: Colors.white,
                  child: InkWell(
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            '测试账号',
                            style: TextStyle(fontSize: 15),
                          ),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              StreamBuilder(
                                stream: debugAccountState,
                                builder: (c, s) => Text(
                                      accountStateText(s.data),
                                      style: TextStyle(fontSize: 15),
                                    ),
                              ),
                              Icon(Icons.keyboard_arrow_right),
                            ],
                          ),
                        ],
                      ),
                    ),
                    onTap: () async {
                      switch (debugAccountState.value) {
                        case applyStateApply:
                          var rsp = await Navigator.push(
                            context,
                            CommonRoute(
                              builder: (c) => ClientApplyDebugAccountPage(
                                    accountType: applyTypeDebugAccount,
                                    client: widget.client,
                                  ),
                            ),
                          );
                          if (rsp == true) {
                            initData();
                          }
                          break;
                        case applyStateApplied:
                          await Navigator.push(
                            context,
                            CommonRoute(
                              builder: (c) => ClientDebugAccountPage(
                                    accountType: applyTypeDebugAccount,
                                    clientId: widget.client.id,
                                  ),
                            ),
                          );
                          break;
                      }
                    },
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 15),
                child: Material(
                  color: Colors.white,
                  child: InkWell(
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            '正式账号',
                            style: TextStyle(fontSize: 15),
                          ),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              StreamBuilder(
                                stream: releaseAccountState,
                                builder: (c, s) => Text(
                                      accountStateText(s.data),
                                      style: TextStyle(fontSize: 15),
                                    ),
                              ),
                              Icon(Icons.keyboard_arrow_right),
                            ],
                          ),
                        ],
                      ),
                    ),
                    onTap: () async {
                      switch (releaseAccountState.value) {
                        case applyStateApply:
                          var rsp = await Navigator.push(
                            context,
                            CommonRoute(
                              builder: (c) => ClientApplyDebugAccountPage(
                                    accountType: applyTypeReleaseAccount,
                                    client: widget.client,
                                  ),
                            ),
                          );
                          if (rsp == true) {
                            initData();
                          }
                          break;
                        case applyStateApplied:
                          await Navigator.push(
                            context,
                            CommonRoute(
                              builder: (c) => ClientDebugAccountPage(
                                    accountType: applyTypeReleaseAccount,
                                    clientId: widget.client.id,
                                  ),
                            ),
                          );
                          break;
                      }
                    },
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 15),
                child: Material(
                  color: Colors.white,
                  child: InkWell(
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            '申请培训',
                            style: TextStyle(fontSize: 15),
                          ),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              StreamBuilder(
                                stream: trainAccountState,
                                builder: (c, s) => Text(
                                      trainStateText(s.data),
                                      style: TextStyle(fontSize: 15),
                                    ),
                              ),
                              Icon(Icons.keyboard_arrow_right),
                            ],
                          ),
                        ],
                      ),
                    ),
                    onTap: () async {
                      if (trainAccountState.value != applyStateApplying) {
                        var rsp = await Navigator.push(
                          context,
                          CommonRoute(
                            builder: (context) => ClientApplyTrainPage(
                                  id: widget.client.id,
                                  name: widget.client.leads_name,
                                  logs: trainLogs.value,
                                ),
                          ),
                        );
                        if (rsp == true) {
                          initData();
                        }
                      }
                    },
                  ),
                ),
              ),
              Divider(
                height: 1,
              ),
              ...s.data.map(
                (i) => itemTrain(
                      item: i,
                      lastOne: s.data.last == i,
                    ),
              )
            ],
          ),
    );
  }

  initData() async {
    var rsp = await ApiService().applyInfo(
      leads_id: widget.client.id.toString(),
    );
    if (rsp.code == ApiService.success) {
      releaseAccountState.value = rsp.data.state_formal;
      debugAccountState.value = rsp.data.state_test;
      trainAccountState.value = rsp.data.state_train;
      trainLogs.value = rsp.data.logs;
    }
  }

  String accountStateText(state) {
    switch (state) {
      case applyStateApply:
        return '申请';
        break;
      case applyStateApplying:
        return '申请中';
        break;
      case applyStateApplied:
        return '已通过';
        break;
      default:
        return '';
    }
  }

  String trainStateText(state) {
    switch (state) {
      case applyStateApply:
        return '申请';
        break;
      case applyStateApplying:
        return '申请中';
        break;
      case applyStateApplied:
        return '申请';
        break;
      default:
        return '';
    }
  }

  @override
  bool get wantKeepAlive => true;
}
