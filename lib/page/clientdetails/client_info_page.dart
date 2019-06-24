import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app/bloc/Bloc.dart';
import 'package:flutter_app/bloc/ClientDetailBloc.dart';
import 'package:flutter_app/page/RadioListPage.dart';
import 'package:intl/intl.dart';

class ClientInfoPage extends StatefulWidget {
  ClientInfoPage({
    Key key,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return ClientInfoPageState();
  }
}

class ClientInfoPageState extends State<ClientInfoPage>
    with AutomaticKeepAliveClientMixin<ClientInfoPage> {
  ClientDetailBloc _bloc;

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
        buildItem(context, "*公司类型", _bloc.company.name),
        buildItem(context, "*所属行业", _bloc.industry.name),
        buildItem(context, "*所在地", _bloc.location.name),
        buildItem(context, "*年发票量", _bloc.invoiceCount),
        buildItem(context, "是否为二次开发", _bloc.secondaryDevelopment.name),
        buildItem(context, "执行比例", _bloc.progress.name),
        buildItem(context, "预计签约额", _bloc.expectedContractAmount),
        buildItem(context, "预计签约日", _bloc.expectedSignDate),
        buildItem(context, "公司规模", _bloc.lnsize),
        buildItem(context, "公司简介", _bloc.companyIntro, showLine: false),
      ],
    );
  }

  Widget buildItem(BuildContext context, String title, String content,
      {bool showLine = true}) {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.symmetric(vertical: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: TextStyle(fontSize: 15),
                ),
                Flexible(
                  child: Text(
                    content,
                    style: TextStyle(fontSize: 15,color: Colors.grey),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ),
              ],
            ),
          ),
          Opacity(
            child: Divider(
              height: 1,
            ),
            opacity: showLine ? 1 : 0,
          ),
        ],
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
