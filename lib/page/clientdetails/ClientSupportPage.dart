import 'package:flutter/material.dart';
import 'package:flutter_app/CommonRoute.dart';
import 'package:flutter_app/data/Constant.dart';
import 'package:flutter_app/data/http/ApiService.dart';
import 'package:flutter_app/data/http/rsp/ClientSupportListRsp.dart';
import 'package:flutter_app/data/http/rsp/data/RadioBean.dart';
import 'package:flutter_app/page/RadioListPage.dart';
import 'package:flutter_app/page/clientdetails/NewDebugAccSupport.dart';
import 'package:flutter_app/page/clientdetails/NewHardWareSupport.dart';
import 'package:flutter_app/page/clientdetails/NewPreSaleSupport.dart';
import 'package:flutter_app/page/clientdetails/NewReleaseAccSupport.dart';

class ClientSupportPage extends StatefulWidget {
  final int _leadId;

  ClientSupportPage(this._leadId);

  @override
  State<StatefulWidget> createState() {
    return ClientSupportPageState(_leadId);
  }
}

class ClientSupportPageState extends State {
  final int _leadId;

  List<ClientSupport> _clientSupports = new List();

  ClientSupportPageState(this._leadId);

  @override
  void initState() {
    if (_leadId != null) {
      _initData();
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return new Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        new Container(
          padding: EdgeInsets.only(top: 12.0, right: 16.0, left: 16.0),
          child: new Text("申请支持"),
        ),
        new Flexible(
          child: new Stack(
            children: <Widget>[
              _clientSupports.isNotEmpty
                  ? new Container(
                      margin: EdgeInsets.only(
                        top: 12.0,
                        bottom: 12.0,
                        right: 12.0,
                        left: 12.0,
                      ),
                      child: new ListView.builder(
                        physics: new BouncingScrollPhysics(),
                        itemCount: _clientSupports.length,
                        itemBuilder: (context, index) {
                          return _renderVisitLogItem(_clientSupports[index]);
                        },
                      ),
                    )
                  : new Center(
                      child: new Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Image.asset("assets/images/ic_empty.png"),
                          Container(
                            margin: EdgeInsets.symmetric(vertical: 12.0),
                            child: Text(_leadId == null ? "新建商机无法添加" : "暂无数据"),
                          )
                        ],
                      ),
                    ),
            ],
          ),
        ),
        new Center(
          child: new Container(
            padding: EdgeInsets.only(
              bottom: 12.0,
              right: 16.0,
              left: 16.0,
            ),
            child: new InkWell(
              child: new Text(
                '新增申请支持',
                style: Theme.of(context).textTheme.body1.merge(TextStyle(
                      color: _leadId != null ? Colors.blue : Colors.grey,
                    )),
              ),
              onTap: _leadId != null
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
    var supportList = new List<RadioBean>();
    supportList.add(RadioBean(SUPPORT_TYPE_PRE_SALES, "售前支持"));
    var hasHardWare = _clientSupports.firstWhere(
        ((e) => e.application_type == SUPPORT_TYPE_HARDWARE),
        orElse: () => null);
    if (hasHardWare == null) {
      supportList.add(RadioBean(SUPPORT_TYPE_HARDWARE, "硬件设备"));
    }
    var hasDebugAccount = _clientSupports.firstWhere(
        ((e) => e.application_type == SUPPORT_TYPE_DEBUG_ACCOUNT),
        orElse: () => null);
    if (hasDebugAccount == null) {
      supportList.add(RadioBean(SUPPORT_TYPE_DEBUG_ACCOUNT, "测试账号"));
    }
    var hasReleaseAccount = _clientSupports.firstWhere(
        ((e) => e.application_type == SUPPORT_TYPE_RELEASE_ACCOUNT),
        orElse: () => null);
    if (hasReleaseAccount == null) {
      supportList.add(RadioBean(SUPPORT_TYPE_RELEASE_ACCOUNT, "正式账号"));
    }

    RadioBean result = await showDialog(
      context: context,
      builder: (context) {
        return new RadioListPage(supportList);
      },
    );
    bool needRefresh;
    switch (result?.id) {
      case SUPPORT_TYPE_PRE_SALES:
        needRefresh = await Navigator.push(
            context,
            new CommonRoute(
              builder: (BuildContext context) => new NewPreSaleSupport(_leadId),
            ));
        break;
      case SUPPORT_TYPE_HARDWARE:
        needRefresh = await Navigator.push(
            context,
            new CommonRoute(
              builder: (BuildContext context) =>
                  new NewHardWareSupport(_leadId),
            ));
        break;
      case SUPPORT_TYPE_DEBUG_ACCOUNT:
        needRefresh = await Navigator.push(
            context,
            new CommonRoute(
              builder: (BuildContext context) =>
                  new NewDebugAccSupport(_leadId),
            ));
        break;
      case SUPPORT_TYPE_RELEASE_ACCOUNT:
        needRefresh = await Navigator.push(
            context,
            new CommonRoute(
              builder: (BuildContext context) =>
                  new NewReleaseAccSupport(_leadId),
            ));
        break;
    }
    if (needRefresh == true) {
      _initData();
    }
  }

  Widget _renderVisitLogItem(ClientSupport clientSupport) {
    final children = new List<Widget>();
    switch (clientSupport.application_type) {
      case SUPPORT_TYPE_PRE_SALES:
        _initPreSalesContent(clientSupport, children);
        break;
      case SUPPORT_TYPE_HARDWARE:
        _initHardWareContent(clientSupport, children);

        break;
      case SUPPORT_TYPE_DEBUG_ACCOUNT:

      case SUPPORT_TYPE_RELEASE_ACCOUNT:
        //正式 测试
        _initApplyAccountContent(clientSupport, children);
        break;
    }

    return Card(
      elevation: 2.0,
      child: new Container(
        padding: EdgeInsets.symmetric(
          vertical: 12.0,
          horizontal: 16.0,
        ),
        child: new Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: children,
        ),
      ),
    );
  }

  void _initHardWareContent(
      ClientSupport clientSupport, List<Widget> children) {
    //硬件
    children.add(new Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        new Text(
          "硬件申请",
          style: Theme.of(context)
              .textTheme
              .body2
              .merge(TextStyle(color: Colors.blue)),
        ),
        new Text(
          clientSupport.create_time,
          style: Theme.of(context)
              .textTheme
              .body1
              .merge(TextStyle(color: Colors.grey)),
        ),
      ],
    ));

    if (clientSupport.device_name != null) {
      children.add(new Container(
        margin: EdgeInsets.only(top: 12.0),
        child: new Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            new Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                new Text(
                  '设备名称：',
                  style: Theme.of(context).textTheme.body1,
                ),
                new Text(
                  devices
                      .firstWhere((e) => e.id == clientSupport.device_name)
                      .name,
                  style: Theme.of(context).textTheme.body1,
                ),
              ],
            ),
            new Text(
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
      children.add(new Container(
        margin: EdgeInsets.only(top: 6.0),
        child: new Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            new Text(
              '购买/押金：',
              style: Theme.of(context).textTheme.body1,
            ),
            new Text(
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
      children.add(new Container(
        margin: EdgeInsets.only(top: 6.0),
        child: new Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            new Text(
              '数量：',
              style: Theme.of(context).textTheme.body1,
            ),
            new Text(
              clientSupport.device_quantity.toString(),
              style: Theme.of(context).textTheme.body1,
            ),
          ],
        ),
      ));
    }

    if (clientSupport.price != null && clientSupport.price.isNotEmpty) {
      children.add(new Container(
        margin: EdgeInsets.only(top: 6.0),
        child: new Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            new Text(
              '价格：',
              style: Theme.of(context).textTheme.body1,
            ),
            new Flexible(
              child: new Text(
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
      children.add(new Container(
        margin: EdgeInsets.only(top: 6.0),
        child: new Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            new Text(
              '备注：',
              style: Theme.of(context).textTheme.body1,
            ),
            new Flexible(
              child: new Text(
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
    children.add(new Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        new Text(
          "售前支持",
          style: Theme.of(context)
              .textTheme
              .body2
              .merge(TextStyle(color: Colors.blue)),
        ),
        new Text(
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
      children.add(new Container(
        margin: EdgeInsets.only(top: 12.0),
        child: new Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            new Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                new Text(
                  '对象职责：',
                  style: Theme.of(context).textTheme.body1,
                ),
                new Text(
                  responsibilities
                      .firstWhere((e) => e.id == clientSupport.responsibility)
                      .name,
                  style: Theme.of(context).textTheme.body1,
                ),
              ],
            ),
            new Text(
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
      children.add(new Container(
        margin: EdgeInsets.only(top: 6.0),
        child: new Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            new Text(
              '拜访时间：',
              style: Theme.of(context).textTheme.body1,
            ),
            new Text(
              clientSupport.visit_time,
              style: Theme.of(context).textTheme.body1,
            ),
          ],
        ),
      ));
    }

    if (clientSupport.visit_progress != null) {
      children.add(new Container(
        margin: EdgeInsets.only(top: 6.0),
        child: new Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            new Text(
              '项目进度：',
              style: Theme.of(context).textTheme.body1,
            ),
            new Text(
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
      children.add(new Container(
        margin: EdgeInsets.only(top: 6.0),
        child: new Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            new Text(
              '功能需求：',
              style: Theme.of(context).textTheme.body1,
            ),
            new Flexible(
              child: new Text(
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
    children.add(new Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        new Text(
          clientSupport.application_type == SUPPORT_TYPE_DEBUG_ACCOUNT
              ? "测试账号"
              : "正式账号",
          style: Theme.of(context)
              .textTheme
              .body2
              .merge(TextStyle(color: Colors.blue)),
        ),
        new Text(
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
      children.add(new Container(
        margin: EdgeInsets.only(top: 12.0),
        child: new Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            new Flexible(child:new Container(
              margin: EdgeInsets.only(right: 16.0),
              child:  new Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  new Text(
                    '用户名：',
                    style: Theme.of(context).textTheme.body1,
                  ),
                  new Flexible(child: new Text(
                    clientSupport.fc_admin_name,
                    style: Theme.of(context).textTheme.body1,
                    overflow: TextOverflow.ellipsis,
                  )),
                ],
              ),
            )),
            new Text(
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
      children.add(new Container(
        margin: EdgeInsets.only(top: 6.0),
        child: new Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            new Text(
              '注册邮箱：',
              style: Theme.of(context).textTheme.body1,
            ),
            new Flexible(
              child: new Text(
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
      children.add(new Container(
        margin: EdgeInsets.only(top: 6.0),
        child: new Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            new Text(
              '初始密码：',
              style: Theme.of(context).textTheme.body1,
            ),
            new Flexible(
              child: new Text(
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
      children.add(new Container(
        margin: EdgeInsets.only(top: 6.0),
        child: new Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            new Text(
              '使用期限：',
              style: Theme.of(context).textTheme.body1,
            ),
            new Text(
              clientSupport.time_limit,
              style: Theme.of(context).textTheme.body1,
            ),
          ],
        ),
      ));
    }

    if (clientSupport.check_amount != null) {
      children.add(new Container(
        margin: EdgeInsets.only(top: 6.0),
        child: new Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            new Text(
              '开通票量：',
              style: Theme.of(context).textTheme.body1,
            ),
            new Text(
              clientSupport.check_amount.toString(),
              style: Theme.of(context).textTheme.body1,
            ),
          ],
        ),
      ));
    }

    if (clientSupport.memo != null) {
      children.add(new Container(
        margin: EdgeInsets.only(top: 6.0),
        child: new Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            new Text(
              '备注：',
              style: Theme.of(context).textTheme.body1,
              maxLines: null,
            ),
            new Flexible(
              child: new Text(
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
    ApiService().clientSupports(_leadId.toString()).then(
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
