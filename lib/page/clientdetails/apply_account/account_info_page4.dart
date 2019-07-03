import 'package:flutter/material.dart';
import 'package:flutter_app/bloc/Bloc.dart';
import 'package:flutter_app/data/http/api_service.dart';
import 'package:flutter_app/data/http/rsp/count_use.dart';
import 'package:rxdart/rxdart.dart';

import 'client_debug_account_page.dart';

class AccountInfoPage4 extends StatefulWidget {
  AccountInfoPage4({
    Key key,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return AccountInfoPage4State();
  }
}

class AccountInfoPage4State extends State<AccountInfoPage4>
    with AutomaticKeepAliveClientMixin<AccountInfoPage4> {
  ClientDebugAccountBloc _bloc;
  ScrollController _scrollController = ScrollController();
  var page = 1;
  BehaviorSubject<List<CountUse>> data = BehaviorSubject();
  BehaviorSubject<String> total = BehaviorSubject();

  @override
  void initState() {
    if (_bloc == null) _bloc = BlocProvider.of(context);
    initData();
    _scrollController.addListener(
      () {
        if (_scrollController.position.pixels ==
            _scrollController.position.maxScrollExtent) {
          loadMore();
        }
      },
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return StreamBuilder<List<CountUse>>(
      initialData: [],
      stream: data,
      builder: (c, s) => ListView(
            physics: BouncingScrollPhysics(),
            controller: _scrollController,
            children: <Widget>[
              buildItem(
                '发票余量',
                total,
                showLine: false,
              ),
              buildTitle('每日查验量'),
              ...s.data.map((e) => _buildItem(e.dt, e.count.toString()))
            ],
          ),
    );
  }

  Widget _buildItem(String title, String content, {bool showLine = true}) {
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
                Text(
                  content,
                  style: TextStyle(fontSize: 15, color: Colors.grey),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
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

  Future<void> initData() async {
    print('initData');
    var rsp = await ApiService().countUseInfo('1', '10', _bloc.id.value);
    if (rsp.code == ApiService.success) {
      data.value = rsp.data.rows;
      total.value = rsp.data.quota?.toString() ?? '0';
      page = 1;
    }
  }

  void loadMore() async {
    var rsp = await ApiService()
        .countUseInfo((page + 1).toString(), '10', _bloc.id.value);
    if (rsp.code == ApiService.success) {
      data.value.addAll(rsp.data.rows);
      data.value = data.value;
      total.value = rsp.data.quota?.toString() ?? '0';
      page++;
    }
  }

  @override
  bool get wantKeepAlive => true;
}
