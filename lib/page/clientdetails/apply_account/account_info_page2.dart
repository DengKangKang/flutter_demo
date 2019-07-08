import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app/bloc/Bloc.dart';
import 'package:flutter_app/bloc/ClientDetailBloc.dart';
import 'package:flutter_app/page/RadioListPage.dart';
import 'package:intl/intl.dart';

import 'client_debug_account_page.dart';

class AccountInfoPage2 extends StatefulWidget {
  AccountInfoPage2({
    Key key,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return AccountInfoPage2State();
  }
}

class AccountInfoPage2State extends State<AccountInfoPage2>
    with AutomaticKeepAliveClientMixin<AccountInfoPage2> {
  ClientDebugAccountBloc _bloc;

  @override
  void initState() {
    if (_bloc == null) _bloc = BlocProvider.of(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return ListView(
      physics: BouncingScrollPhysics(),
      children: <Widget>[
        Container(
          color: Colors.white,
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              StreamBuilder(
                initialData: '',
                stream: _bloc.maker.stream,
                builder: (c, s) => Text(
                  '创建人：${s.data}',
                  style: TextStyle(fontSize: 15),
                ),
              ),
              Container(
                padding: EdgeInsets.only(top: 5),
                child: StreamBuilder(
                  initialData: '',
                  stream: _bloc.applyTime.stream,
                  builder: (c, s) => Text(
                    '申请时间：${s.data}',
                    style: TextStyle(fontSize: 15),
                  ),
                ),
              ),
            ],
          ),
        ),
        buildTitle('基本信息'),
        buildItem('企业名称', _bloc.companyName.stream),
        buildItem('注册地址', _bloc.address.stream),
        buildItem('代理商', _bloc.proxy.stream),
        buildItem('开户行', _bloc.bank.stream),
        buildItem('账户', _bloc.account.stream),
        buildItem('手机号', _bloc.phoneNumber.stream, showLine: false),
        buildTitle('Key&Secret'),
        _buildKeySecretItem(
          'ic_client_key',
          _bloc.clientKey,
        ),
        _buildKeySecretItem(
          'company_key',
          _bloc.companyKey,
        ),
        _buildKeySecretItem(
          'company_secret',
          _bloc.companySecret,
        ),
      ],
    );
  }

  Container _buildKeySecretItem(String name, Stream timeLimit,
      {bool showLine = true}) {
    return Container(
      color: Colors.white,
      margin: EdgeInsets.only(bottom: 15),
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            name,
            style: TextStyle(fontSize: 15),
          ),
          Container(
              padding: EdgeInsets.only(top: 5),
              child: StreamBuilder(
                initialData: '',
                stream: timeLimit,
                builder: (c, s) => Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      s.data,
                      style: TextStyle(fontSize: 15, color: Colors.grey),
                    ),
                    InkWell(
                      child: Image.asset('assets/images/ico_xq_fz.png'),
                      onTap: () {
                        copy(s.data);
                      },
                    )
                  ],
                ),
              )),
        ],
      ),
    );
  }

  void copy(text) {
    Clipboard.setData(ClipboardData(text: text));
    _bloc.showTip('复制成功');
  }

  @override
  bool get wantKeepAlive => true;
}
