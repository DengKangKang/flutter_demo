import 'package:flutter/material.dart';
import 'package:flutter_app/CommonRoute.dart';
import 'package:flutter_app/bloc/Bloc.dart';
import 'package:flutter_app/bloc/ClientDetailBloc.dart';
import 'package:flutter_app/data/Constant.dart';
import 'package:flutter_app/data/http/api_service.dart';
import 'package:flutter_app/data/http/rsp/ClientSupportListRsp.dart';
import 'package:flutter_app/data/http/rsp/data/RadioBean.dart';
import 'package:flutter_app/page/RadioListPage.dart';
import 'package:flutter_app/page/clientdetails/NewDebugAccSupport.dart';
import 'package:flutter_app/page/clientdetails/NewHardWareSupport.dart';
import 'package:flutter_app/page/clientdetails/NewPreSaleSupport.dart';
import 'package:flutter_app/page/clientdetails/NewReleaseAccSupport.dart';

class ClientSupportPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return ClientSupportPageState();
  }
}

class ClientSupportPageState extends State {
  List<ClientSupport> _clientSupports = List();

  ClientDetailBloc _bloc;

  @override
  void initState() {
    if (_bloc == null) _bloc = BlocProvider.of(context);
    if (_bloc.id != null) {
      _initData();
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          padding: EdgeInsets.only(top: 12.0, right: 16.0, left: 16.0),
          child: Text("申请支持"),
        ),
        Flexible(
          child: Stack(
            children: <Widget>[
              _clientSupports.isNotEmpty
                  ? Container(
                      margin: EdgeInsets.only(
                        top: 12.0,
                        bottom: 12.0,
                        right: 12.0,
                        left: 12.0,
                      ),
                      child: ListView.builder(
                        physics: BouncingScrollPhysics(),
                        itemCount: _clientSupports.length,
                        itemBuilder: (context, index) {
                          return _renderVisitLogItem(_clientSupports[index]);
                        },
                      ),
                    )
                  : Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Image.asset("assets/images/ic_empty.png"),
                          Container(
                            margin: EdgeInsets.symmetric(vertical: 12.0),
                            child: Text(_bloc.id == null ? "新建商机无法添加" : "暂无数据"),
                          )
                        ],
                      ),
                    ),
            ],
          ),
        ),
        Center(
          child: Container(
            padding: EdgeInsets.only(
              bottom: 12.0,
              right: 16.0,
              left: 16.0,
            ),
            child: InkWell(
              child: Text(
                '新增申请支持',
                style: Theme.of(context).textTheme.body1.merge(TextStyle(
                      color: _bloc.id != null ? Colors.blue : Colors.grey,
                    )),
              ),
              onTap: _bloc.id != null
                  ? () {
                      newSupport(context);
                    }
                  : null,
            ),
          ),
        )
      ],
    );
  }

  void newSupport(BuildContext context) async {
    var supportList = List<RadioBean>();
    supportList.add(RadioBean(supportTypePreSales, "售前支持"));
    var hasHardWare = _clientSupports.firstWhere(
        ((e) => e.application_type == supportTypeHardware),
        orElse: () => null);
    if (hasHardWare == null) {
      supportList.add(RadioBean(supportTypeHardware, "硬件设备"));
    }
    var hasDebugAccount = _clientSupports.firstWhere(
        ((e) => e.application_type == supportTypeDebugAccount),
        orElse: () => null);
    if (hasDebugAccount == null) {
      supportList.add(RadioBean(supportTypeDebugAccount, "测试账号"));
    }
    var hasReleaseAccount = _clientSupports.firstWhere(
        ((e) => e.application_type == supportTypeReleaseAccount),
        orElse: () => null);
    if (hasReleaseAccount == null) {
      supportList.add(RadioBean(supportTypeReleaseAccount, "正式账号"));
    }

    RadioBean result = await showDialog(
      context: context,
      builder: (context) {
        return RadioListPage(supportList);
      },
    );
    bool needRefresh;
    switch (result?.id) {
      case supportTypePreSales:
        needRefresh = await Navigator.push(
            context,
            CommonRoute(
              builder: (BuildContext context) => NewPreSaleSupport(_bloc.id),
            ));
        break;
      case supportTypeHardware:
        needRefresh = await Navigator.push(
            context,
            CommonRoute(
              builder: (BuildContext context) => NewHardWareSupport(_bloc.id),
            ));
        break;
      case supportTypeDebugAccount:
        needRefresh = await Navigator.push(
            context,
            CommonRoute(
              builder: (BuildContext context) => NewDebugAccSupport(_bloc.id),
            ));
        break;
      case supportTypeReleaseAccount:
        needRefresh = await Navigator.push(
            context,
            CommonRoute(
              builder: (BuildContext context) => NewReleaseAccSupport(_bloc.id),
            ));
        break;
    }
    if (needRefresh == true) {
      _initData();
    }
  }

  Widget _renderVisitLogItem(ClientSupport clientSupport) {
    final children = List<Widget>();
    switch (clientSupport.application_type) {
      case supportTypePreSales:
        _initPreSalesContent(clientSupport, children);
        break;
      case supportTypeHardware:
        _initHardWareContent(clientSupport, children);

        break;
      case supportTypeDebugAccount:

      case supportTypeReleaseAccount:
        //正式 测试
        _initApplyAccountContent(clientSupport, children);
        break;
    }

    return Card(
      elevation: 2.0,
      child: Container(
        padding: EdgeInsets.symmetric(
          vertical: 12.0,
          horizontal: 16.0,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: children,
        ),
      ),
    );
  }

  void _initHardWareContent(
      ClientSupport clientSupport, List<Widget> children) {
    //硬件
    children.add(Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text(
          "硬件申请",
          style: Theme.of(context)
              .textTheme
              .body2
              .merge(TextStyle(color: Colors.blue)),
        ),
        Text(
          clientSupport.create_time,
          style: Theme.of(context)
              .textTheme
              .body1
              .merge(TextStyle(color: Colors.grey)),
        ),
      ],
    ));

    if (clientSupport.device_name != null) {
      children.add(Container(
        margin: EdgeInsets.only(top: 12.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Text(
                  '设备名称：',
                  style: Theme.of(context).textTheme.body1,
                ),
                Text(
                  devices
                      .firstWhere((e) => e.id == clientSupport.device_name)
                      .name,
                  style: Theme.of(context).textTheme.body1,
                ),
              ],
            ),
            Text(
              clientSupport.state.toInt() == 1 ? "申请中" : "已通过",
              style: TextStyle(
                  color: clientSupport.state.toInt() == 1
                      ? Colors.green
                      : Colors.blue),
            ),
          ],
        ),
      ));
    }

    if (clientSupport.is_purchase != null) {
      children.add(Container(
        margin: EdgeInsets.only(top: 6.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Text(
              '购买/押金：',
              style: Theme.of(context).textTheme.body1,
            ),
            Text(
              usageModel
                  .firstWhere((e) => e.id == clientSupport.is_purchase)
                  .name,
              style: Theme.of(context).textTheme.body1,
            ),
          ],
        ),
      ));
    }

    if (clientSupport.device_quantity != null) {
      children.add(Container(
        margin: EdgeInsets.only(top: 6.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Text(
              '数量：',
              style: Theme.of(context).textTheme.body1,
            ),
            Text(
              clientSupport.device_quantity.toString(),
              style: Theme.of(context).textTheme.body1,
            ),
          ],
        ),
      ));
    }

    if (clientSupport.price != null && clientSupport.price.isNotEmpty) {
      children.add(Container(
        margin: EdgeInsets.only(top: 6.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Text(
              '价格：',
              style: Theme.of(context).textTheme.body1,
            ),
            Flexible(
              child: Text(
                clientSupport.price,
                style: Theme.of(context).textTheme.body1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ));
    }

    if (clientSupport.memo != null) {
      children.add(Container(
        margin: EdgeInsets.only(top: 6.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Text(
              '备注：',
              style: Theme.of(context).textTheme.body1,
            ),
            Flexible(
              child: Text(
                clientSupport.memo,
                style: Theme.of(context).textTheme.body1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ));
    }
  }

  void _initPreSalesContent(
      ClientSupport clientSupport, List<Widget> children) {
    children.add(Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text(
          "售前支持",
          style: Theme.of(context)
              .textTheme
              .body2
              .merge(TextStyle(color: Colors.blue)),
        ),
        Text(
          clientSupport.create_time,
          style: Theme.of(context)
              .textTheme
              .body1
              .merge(TextStyle(color: Colors.grey)),
        ),
      ],
    ));

    //售前
    if (clientSupport.responsibility != null) {
      children.add(Container(
        margin: EdgeInsets.only(top: 12.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Text(
                  '对象职责：',
                  style: Theme.of(context).textTheme.body1,
                ),
                Text(
                  responsibilities
                      .firstWhere((e) => e.id == clientSupport.responsibility)
                      .name,
                  style: Theme.of(context).textTheme.body1,
                ),
              ],
            ),
            Text(
              clientSupport.state.toInt() == 1 ? "申请中" : "已通过",
              style: TextStyle(
                  color: clientSupport.state.toInt() == 1
                      ? Colors.green
                      : Colors.blue),
            ),
          ],
        ),
      ));
    }

    if (clientSupport.visit_time != null &&
        clientSupport.visit_time.isNotEmpty) {
      children.add(Container(
        margin: EdgeInsets.only(top: 6.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Text(
              '拜访时间：',
              style: Theme.of(context).textTheme.body1,
            ),
            Text(
              clientSupport.visit_time,
              style: Theme.of(context).textTheme.body1,
            ),
          ],
        ),
      ));
    }

    if (clientSupport.visit_progress != null) {
      children.add(Container(
        margin: EdgeInsets.only(top: 6.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Text(
              '项目进度：',
              style: Theme.of(context).textTheme.body1,
            ),
            Text(
              projectProgresses
                  .firstWhere((e) => e.id == clientSupport.visit_progress)
                  .name,
              style: Theme.of(context).textTheme.body1,
            ),
          ],
        ),
      ));
    }

    if (clientSupport.requirements != null &&
        clientSupport.requirements.isNotEmpty) {
      children.add(Container(
        margin: EdgeInsets.only(top: 6.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Text(
              '功能需求：',
              style: Theme.of(context).textTheme.body1,
            ),
            Flexible(
              child: Text(
                clientSupport.requirements,
                style: Theme.of(context).textTheme.body1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ));
    }
  }

  void _initApplyAccountContent(
      ClientSupport clientSupport, List<Widget> children) {
    children.add(Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text(
          clientSupport.application_type == supportTypeDebugAccount
              ? "测试账号"
              : "正式账号",
          style: Theme.of(context)
              .textTheme
              .body2
              .merge(TextStyle(color: Colors.blue)),
        ),
        Text(
          clientSupport.create_time,
          style: Theme.of(context)
              .textTheme
              .body1
              .merge(TextStyle(color: Colors.grey)),
        ),
      ],
    ));

    //正式 测试
    if (clientSupport.fc_admin_name != null &&
        clientSupport.fc_admin_name.isNotEmpty) {
      children.add(Container(
        margin: EdgeInsets.only(top: 12.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Flexible(
                child: Container(
              margin: EdgeInsets.only(right: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Text(
                    '用户名：',
                    style: Theme.of(context).textTheme.body1,
                  ),
                  Flexible(
                      child: Text(
                    clientSupport.fc_admin_name,
                    style: Theme.of(context).textTheme.body1,
                    overflow: TextOverflow.ellipsis,
                  )),
                ],
              ),
            )),
            Text(
              clientSupport.state.toInt() == 1 ? "申请中" : "已通过",
              style: TextStyle(
                  color: clientSupport.state.toInt() == 1
                      ? Colors.green
                      : Colors.blue),
            ),
          ],
        ),
      ));
    }
    if (clientSupport.email != null && clientSupport.email.isNotEmpty) {
      children.add(Container(
        margin: EdgeInsets.only(top: 6.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Text(
              '注册邮箱：',
              style: Theme.of(context).textTheme.body1,
            ),
            Flexible(
              child: Text(
                clientSupport.email,
                style: Theme.of(context).textTheme.body1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ));
    }
    if (clientSupport.initial_password != null &&
        clientSupport.initial_password.isNotEmpty) {
      children.add(Container(
        margin: EdgeInsets.only(top: 6.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Text(
              '初始密码：',
              style: Theme.of(context).textTheme.body1,
            ),
            Flexible(
              child: Text(
                clientSupport.initial_password,
                style: Theme.of(context).textTheme.body1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ));
    }

    if (clientSupport.time_limit != null &&
        clientSupport.time_limit.isNotEmpty) {
      children.add(Container(
        margin: EdgeInsets.only(top: 6.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Text(
              '使用期限：',
              style: Theme.of(context).textTheme.body1,
            ),
            Text(
              clientSupport.time_limit,
              style: Theme.of(context).textTheme.body1,
            ),
          ],
        ),
      ));
    }

    if (clientSupport.check_amount != null) {
      children.add(Container(
        margin: EdgeInsets.only(top: 6.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Text(
              '开通票量：',
              style: Theme.of(context).textTheme.body1,
            ),
            Text(
              clientSupport.check_amount.toString(),
              style: Theme.of(context).textTheme.body1,
            ),
          ],
        ),
      ));
    }

    if (clientSupport.memo != null) {
      children.add(Container(
        margin: EdgeInsets.only(top: 6.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Text(
              '备注：',
              style: Theme.of(context).textTheme.body1,
              maxLines: null,
            ),
            Flexible(
              child: Text(
                clientSupport.memo,
                style: Theme.of(context).textTheme.body1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ));
    }
  }

  void _initData() {
    ApiService().clientSupports(_bloc.id.toString()).then(
      (rsp) {
        if (rsp.code == ApiService.success) {
          var clientSupports = rsp as ClientSupportListRsp;
          setState(() {
            _clientSupports = clientSupports.data;
          });
        }
      },
    );
  }
}
