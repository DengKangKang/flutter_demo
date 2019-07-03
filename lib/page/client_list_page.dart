import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_app/CommonRoute.dart';
import 'package:flutter_app/bloc/Bloc.dart';
import 'package:flutter_app/data/http/api_service.dart';
import 'package:flutter_app/data/http/rsp/clients_rsp.dart';
import 'package:flutter_app/data/http/rsp/data/RadioBean.dart';
import 'package:flutter_app/data/http/rsp/data/clients_data.dart';
import 'package:flutter_app/data/persistence/Persistence.dart';
import 'package:flutter_app/main.dart';
import 'package:flutter_app/page/RadioListPage.dart';
import 'package:flutter_app/page/client_detail_page.dart';
import 'package:flutter_app/page/clientdetails/new_business.dart';
import 'package:flutter_app/weight/Tool.dart';
import 'package:intl/intl.dart';
import 'package:rxdart/rxdart.dart';

import 'base/CommonPageState.dart';
import 'daily_page.dart';

const typeTrace = 0x1;
const typeClient = 0x2;
const statePrivate = 0x10;
const statePublic = 0x20;

class ClientListPage extends StatefulWidget {
  const ClientListPage({Key key, this.title, this.businessType})
      : super(key: key);
  final title;
  final businessType;

  @override
  State createState() => ClientListState();
}

class ClientListState extends CommonPageState<ClientListPage, ClientListBloc> {
  ScrollController _scrollController = ScrollController();
  GlobalKey _keyTitle = GlobalKey();

  @override
  void initState() {
    if (bloc == null) {
      bloc = ClientListBloc(widget.businessType);
    }

    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        bloc.loadMore();
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      bloc: bloc,
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: colorBg,
        appBar: AppBar(
          key: _keyTitle,
          elevation: 0,
          centerTitle: true,
          title: StreamBuilder<bool>(
            initialData: false,
            stream: Persistence().userAuthority,
            builder: (c, b) => InkWell(
                  child: StreamBuilder<int>(
                    initialData: pageStatePersonal,
                    stream: bloc.pageState.stream,
                    builder: (c, s) => Row(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Text(
                              geTitle(s),
                            ),
                            Visibility(
                              visible: b.data &&
                                  widget.businessType & 0xf0 == statePrivate,
                              child: Image.asset(
                                'assets/images/ico_htxq_jt_s.png',
                              ),
                            ),
                          ],
                        ),
                  ),
                  onTap: b.data && widget.businessType & 0xf0 == statePrivate
                      ? () {
                          changePageState(context);
                        }
                      : null,
                ),
          ),
          actions: <Widget>[
            Opacity(
              opacity: widget.businessType & 0xf0 == statePrivate ? 1 : 0,
              child: IconButton(
                icon: Icon(Icons.add),
                onPressed:
                    widget.businessType & 0xf0 == statePrivate ? add : null,
              ),
            ),
            Builder(
              builder: (context) => IconButton(
                    icon: Icon(Icons.menu),
                    onPressed: () async {
                      scaffoldKey.currentState.openEndDrawer();
                    },
                  ),
            ),
          ],
        ),
        body: RefreshIndicator(
            child: StreamBuilder<List<Client>>(
              initialData: List<Client>(),
              stream: bloc.dailies,
              builder:
                  (BuildContext context, AsyncSnapshot<List<Client>> snapshot) {
                return ListView.builder(
                  physics: AlwaysScrollableScrollPhysics(),
                  controller: _scrollController,
                  itemCount: snapshot.data.length,
                  itemBuilder: (context, i) {
                    return widget.businessType & 0xF == typeTrace
                        ? _traceItem(snapshot.data, i)
                        : _clientItem(snapshot.data, i);
                  },
                );
              },
            ),
            onRefresh: () => bloc.initData()),
        endDrawer: Drawer(
          child: Filter(),
        ),
      ),
    );
  }

  void add() async {
    var needRefresh = await Navigator.push(
      context,
      CommonRoute(
        builder: (c) => NewBusinessPage(
              type: widget.businessType & 0xf,
            ),
      ),
    );
    if (needRefresh == true) {
      await bloc.initData();
    }
  }

  Future changePageState(BuildContext context) async {
    final RenderBox overlay = Overlay.of(context).context.findRenderObject();
    print(Offset.zero & overlay.size);
    double b = _keyTitle.currentContext.findRenderObject().paintBounds.bottom;
    double l = (overlay.size.width - 168) / 2;
    double r = overlay.size.width - l;
    final result = await showMenu(
      context: context,
      position: RelativeRect.fromLTRB(l, b, r, 0),
      items: <PopupMenuEntry<int>>[
        PopupMenuItem<int>(
          value: pageStatePersonal,
          child: Center(
            child: Container(
              width: 100,
              child: Center(
                child: Text(
                    '私海${widget.businessType & 0xf == typeTrace ? '线索' : '客户'}'),
              ),
            ),
          ),
        ),
        PopupMenuDivider(
          height: 1,
        ),
        PopupMenuItem<int>(
          value: pageStateGroupMembers,
          child: Center(
            child: Container(
              width: 100,
              child: Center(
                child: Text(
                    '小组${widget.businessType & 0xf == typeTrace ? '线索' : '客户'}'),
              ),
            ),
          ),
        ),
      ],
    );
    if (result != null) bloc.pageState.sink.add(result);
    await bloc.initData();
  }

  String geTitle(AsyncSnapshot<int> s) {
    return widget.businessType & 0xf0 == statePrivate
        ? s.data == pageStatePersonal
            ? '私海${widget.businessType & 0xf == typeTrace ? '线索' : '客户'}'
            : '小组${widget.businessType & 0xf == typeTrace ? '线索' : '客户'}'
        : widget.title;
  }

  Widget _clientItem(List<Client> content, int index) {
    var client = content[index];
    return Container(
      margin: EdgeInsets.only(
        top: 20,
        bottom: content.length - 1 == index ? 20 : 0,
        left: 20,
        right: 20,
      ),
      child: MaterialButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(5)),
        ),
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        color: Colors.white,
        elevation: defaultElevation / 2,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Text(
                      client.id?.toString() ?? '',
                      style: TextStyle(fontSize: 13, color: Colors.grey),
                    ),
                    Container(
                      padding: EdgeInsets.all(4),
                      margin: EdgeInsets.only(left: 10),
                      decoration: BoxDecoration(
                        color: Color(0x263389FF),
                        borderRadius: BorderRadius.all(
                          Radius.circular(10),
                        ),
                      ),
                      child: Text(
                        client.source_name ?? '',
                        style: TextStyle(fontSize: 9, color: Color(0xFF3389FF)),
                      ),
                    ),
                    Visibility(
                      visible: bloc.pageState.value == pageStateGroupMembers,
                      child: Container(
                        margin: EdgeInsets.only(left: 13.5),
                        child: Image.asset('assets/images/ico_lb_ry.png'),
                      ),
                    ),
                    Visibility(
                      visible: bloc.pageState.value == pageStateGroupMembers,
                      child: Container(
                        margin: EdgeInsets.only(right: 10),
                        child: Text(
                          client.realname ?? '',
                          style: TextStyle(color: colorOrigin, fontSize: 14),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            Container(
              margin: EdgeInsets.symmetric(vertical: 10),
              child: Divider(
                height: 1,
              ),
            ),
            Text(
              client.leads_name ?? '',
              style: TextStyle(fontSize: 17),
            ),
            Container(
              margin: EdgeInsets.only(top: 10),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                textBaseline: TextBaseline.ideographic,
                crossAxisAlignment: CrossAxisAlignment.baseline,
                children: <Widget>[
                  Text(
                    client.leads_contact ?? '',
                    style: TextStyle(fontSize: 15, color: colorOrigin),
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 10),
                    child: Text(
                      client.job_title ?? '',
                      style: TextStyle(fontSize: 11),
                    ),
                  )
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 3),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    client.leads_mobile ?? '',
                    style: TextStyle(fontSize: 13),
                  ),
                  Opacity(
                    opacity: widget.businessType & 0xf0 == statePrivate ? 0 : 1,
                    child: InkWell(
                      child: Row(
                        children: <Widget>[
                          Image.asset("assets/images/ico_xq_zwkh.png"),
                          Container(
                            margin: EdgeInsets.only(left: 5),
                            child: Text(
                              '加入私海',
                              style: TextStyle(fontSize: 12),
                            ),
                          )
                        ],
                      ),
                      onTap: () {
                        addToPrivateClient(client);
                      },
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
        onPressed: () async {
          goDetail(client);
        },
      ),
    );
  }

  Widget _traceItem(List<Client> content, int index) {
    var client = content[index];
    var state = widget.businessType & 0xF0;
    return Container(
      margin: EdgeInsets.only(
        top: 20,
        bottom: content.length - 1 == index ? 20 : 0,
        left: 20,
        right: 20,
      ),
      child: MaterialButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(5)),
        ),
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        color: Colors.white,
        elevation: defaultElevation / 2,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Text(
                      client.id?.toString() ?? '',
                      style: TextStyle(fontSize: 13, color: Colors.grey),
                    ),
                    Container(
                      padding: EdgeInsets.all(4),
                      margin: EdgeInsets.only(left: 10),
                      decoration: BoxDecoration(
                        color: Color(0x263389FF),
                        borderRadius: BorderRadius.all(
                          Radius.circular(10),
                        ),
                      ),
                      child: Text(
                        client.source_name ?? '',
                        style: TextStyle(fontSize: 9, color: Color(0xFF3389FF)),
                      ),
                    ),
                    Visibility(
                      visible: bloc.pageState.value == pageStateGroupMembers,
                      child: Container(
                        margin: EdgeInsets.only(left: 13.5),
                        child: Image.asset('assets/images/ico_lb_ry.png'),
                      ),
                    ),
                    Visibility(
                      visible: bloc.pageState.value == pageStateGroupMembers,
                      child: Container(
                        margin: EdgeInsets.only(right: 10),
                        child: Text(
                          client.realname ?? '',
                          style: TextStyle(color: colorOrigin, fontSize: 14),
                        ),
                      ),
                    ),
                  ],
                ),
                Opacity(
                  opacity: state == statePrivate ? 1 : 0,
                  child: Text(
                    '还剩${client.daily ?? '0'}天',
                    style: TextStyle(fontSize: 13, color: Colors.red),
                  ),
                ),
              ],
            ),
            Container(
              margin: EdgeInsets.symmetric(vertical: 10),
              child: Divider(
                height: 1,
              ),
            ),
            Text(
              client.leads_name ?? '',
              style: TextStyle(fontSize: 17),
            ),
            Container(
              margin: EdgeInsets.only(top: 10),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                textBaseline: TextBaseline.ideographic,
                crossAxisAlignment: CrossAxisAlignment.baseline,
                children: <Widget>[
                  Text(
                    client.leads_contact ?? '',
                    style: TextStyle(fontSize: 15, color: colorOrigin),
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 10),
                    child: Text(
                      client.job_title ?? '',
                      style: TextStyle(fontSize: 11),
                    ),
                  )
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 3),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    client.leads_mobile ?? '',
                    style: TextStyle(fontSize: 13),
                  ),
                  InkWell(
                    child: Row(
                      children: <Widget>[
                        Image.asset(state == statePrivate
                            ? 'assets/images/ico_xq_zwkh.png'
                            : 'assets/images/ico_xq_xs_jrsh.png'),
                        Container(
                          margin: EdgeInsets.only(left: 5),
                          child: Text(
                            state == statePrivate ? '转为客户' : '加入私海',
                            style: TextStyle(fontSize: 12),
                          ),
                        )
                      ],
                    ),
                    onTap: () {
                      state == statePrivate
                          ? transformToClient(client)
                          : addToPrivateTrace(client);
                    },
                  )
                ],
              ),
            ),
          ],
        ),
        onPressed: () {
          goDetail(client);
        },
      ),
    );
  }

  void goDetail(Client client) async {
    var needRefresh = await Navigator.push(
      context,
      CommonRoute(
        builder: (c) => ClientDetailPage(
              client: client,
              businessType: widget.businessType,
              title: bloc.pageState.value == pageStateGroupMembers
                  ? '${client.realname}的${widget.businessType & 0xf == typeTrace ? '线索' : '客户'}'
                  : null,
            ),
      ),
    );
    if (needRefresh == true) {
      await bloc.initData();
    }
  }

  void transformToClient(Client client) async {
    onLoading(context);
    var rsp = await ApiService().transformToClient(client.id.toString());
    loadingFinish(context);
    if (rsp.code == ApiService.success) {
      await bloc.initData();
    } else {
      bloc.showTip(rsp.msg);
    }
  }

  void addToPrivateTrace(Client client) {
    showDialog(
      context: context,
      builder: (c) => AlertDialog(
            title: Text("提示"),
            content: Text("确定加入私海？"),
            actions: <Widget>[
              FlatButton(
                child: Text(
                  '取消',
                  style: TextStyle(
                    color: Colors.grey,
                  ),
                ),
                onPressed: () {
                  Navigator.of(c).pop();
                },
              ),
              FlatButton(
                child: Text(
                  '确定',
                  style: TextStyle(
                    color: colorOrigin,
                  ),
                ),
                onPressed: () async {
                  Navigator.of(c).pop();
                  onLoading(context);
                  var rsp = await ApiService()
                      .addToPrivateTrace(client.id.toString());
                  loadingFinish(context);
                  if (rsp.code == ApiService.success) {
                    await bloc.initData();
                  } else {
                    bloc.showTip(rsp.msg);
                  }
                },
              ),
            ],
          ),
    );
  }

  void addToPrivateClient(Client client) {
    showDialog(
      context: context,
      builder: (c) => AlertDialog(
            title: Text("提示"),
            content: Text("确定加入私海？"),
            actions: <Widget>[
              FlatButton(
                child: Text(
                  '取消',
                  style: TextStyle(
                    color: Colors.grey,
                  ),
                ),
                onPressed: () {
                  Navigator.of(c).pop();
                },
              ),
              FlatButton(
                child: Text(
                  '确定',
                  style: TextStyle(
                    color: colorOrigin,
                  ),
                ),
                onPressed: () async {
                  Navigator.of(c).pop();
                  onLoading(context);
                  var rsp = await ApiService()
                      .addToPrivateClient(client.id.toString());
                  loadingFinish(context);
                  if (rsp.code == ApiService.success) {
                    await bloc.initData();
                  } else {
                    bloc.showTip(rsp.msg);
                  }
                },
              ),
            ],
          ),
    );
  }
}

class ClientListBloc extends CommonBloc {
  ClientListBloc(this.businessType);

  var pageState = BehaviorSubject<int>(seedValue: pageStatePersonal);

  String id = '';
  String maker;

  String dateStart = '';
  String dateEnd = '';

  String contact = '';

  String clientName = '';

  String responsibleMan = '';

  String source = '';

  String location = '';

  String companies = '';

  String company = '';

  String isImportant = '';

  String progress = '';

  String secondDev = '';

  final businessType;

  BehaviorSubject<List<Client>> _dailies = BehaviorSubject();

  int page = 1;

  @override
  Future<void> initData() async {
    ClientsRsp rsp;
    var type = businessType & 0xF;
    var state = businessType & 0xF0;
    if (type == typeClient) {
      rsp = await ApiService().clients(
        key: state == statePrivate ? pageState.value.toString() : '',
        is_public: state == statePublic ? 'true' : '',
        state: state == statePublic ? '5,6,7,98' : '4,5,6,7',
        user: '8',
        id: id ?? '',
        creator: maker ?? '',
        time_area:
            dateStart?.isNotEmpty == true && dateStart?.isNotEmpty == true
                ? [dateStart, dateEnd].join(',')
                : '',
        leads_mobile: contact ?? '',
        leads_name: clientName ?? '',
        source_id: source?.toString() ?? '',
        location: location?.toString() ?? '',
        company_type: company?.toString() ?? '',
        is_important: isImportant?.toString() ?? '',
        progress_percent: progress?.toString() ?? '',
        on_premise: secondDev?.toString() ?? '',
      );
    } else {
      rsp = await ApiService().trace(
        key: state == statePrivate ? pageState.value.toString() : '',
        is_private: state == statePrivate ? 'true' : '',
        state: state == statePrivate ? '1,2,3' : '2,3,99',
        user: '8',
        id: id ?? '',
        creator: maker ?? '',
        time_area:
            dateStart?.isNotEmpty == true && dateStart?.isNotEmpty == true
                ? [dateStart, dateEnd].join(',')
                : '',
        leads_mobile: contact ?? '',
        leads_name: clientName ?? '',
        leads_contact: responsibleMan ?? '',
        source_id: source?.toString() ?? '',
        location: location?.toString() ?? '',
      );
    }
    if (rsp.code == ApiService.success) {
      _dailies.sink.add(rsp.data.rows);
      page = 1;
    }
    return null;
  }

  void loadMore() async {
    var rsp =
        await ApiService().clients(page: (page + 1).toString(), size: '10');
    if (rsp.code == ApiService.success) {
      if (rsp?.data?.rows != null && rsp?.data?.rows?.isNotEmpty == true) {
        page++;
        _dailies.value.addAll(rsp.data.rows);
        _dailies.sink.add(_dailies.value);
      }
    }
  }

  Stream<List<Client>> get dailies => _dailies.stream;

  @override
  void onClosed() {
    _dailies.close();
    super.onClosed();
  }
}

class Filter extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return FilterState();
  }
}

class FilterState extends State<Filter> with TickerProviderStateMixin {
  ClientListBloc _bloc;
  var _actions = List<Action>();

  var id;
  var maker;

  var dateStart = BehaviorSubject<String>();
  var dateEnd = BehaviorSubject<String>();

  var contact;

  var clientName;

  var responsibleMan;

  var sources = BehaviorSubject<List<RadioBean>>(
    seedValue: List.from(sourceTypes),
  );

  var source = BehaviorSubject<int>();

  var filterLocations = BehaviorSubject<List<RadioBean>>(
    seedValue: List.from(locations),
  );

  var location = BehaviorSubject<int>();

  var companies = BehaviorSubject<List<RadioBean>>(
    seedValue: List.from(companyTypes),
  );

  var company = BehaviorSubject<int>();

  var importantStates = BehaviorSubject<List<RadioBean>>(
    seedValue: List.from(booleans),
  );

  var isImportant = BehaviorSubject<int>();

  var filterProgresses = BehaviorSubject<List<RadioBean>>(
    seedValue: List.from(progresses),
  );

  var progress = BehaviorSubject<int>();

  var secondDev = BehaviorSubject<int>();

  @override
  void initState() {
    if (_bloc == null) _bloc = BlocProvider.of(context);
    reset();
    _actions.add(ActionButton('重置', reset, colorCyan));
    _actions.add(ActionDivider());
    _actions.add(ActionButton('筛选', filter, colorOrigin));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      child: Column(
        children: <Widget>[
          Flexible(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: ListView(
                physics: BouncingScrollPhysics(),
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(top: 20),
                    child: Text(
                      'id',
                      style: TextStyle(fontSize: 12),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(7),
                    margin: EdgeInsets.only(top: 5),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(4)),
                      border: Border.all(color: colorDivider),
                    ),
                    child: TextField(
                      textAlign: TextAlign.center,
                      controller: TextEditingController.fromValue(
                        TextEditingValue(
                          text: id,
                        ),
                      ),
                      style: TextStyle(fontSize: 12),
                      decoration: InputDecoration(
                        hintText: '请输入id号',
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.all(0),
                      ),
                      onChanged: (s) {
                        id = s;
                      },
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 15),
                    child: Text(
                      '创建人',
                      style: TextStyle(fontSize: 12),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(7),
                    margin: EdgeInsets.only(top: 5),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(4)),
                      border: Border.all(color: colorDivider),
                    ),
                    child: TextField(
                      textAlign: TextAlign.center,
                      controller: TextEditingController.fromValue(
                        TextEditingValue(
                          text: id,
                        ),
                      ),
                      style: TextStyle(fontSize: 12),
                      decoration: InputDecoration(
                        hintText: '请输入创建人名称',
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.all(0),
                      ),
                      onChanged: (s) {
                        maker = s;
                      },
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 15, bottom: 5),
                    child: Text(
                      '创建人时间',
                      style: TextStyle(fontSize: 12),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      Flexible(
                        child: InkWell(
                          borderRadius: BorderRadius.all(Radius.circular(5)),
                          child: Container(
                            width: double.infinity,
                            padding: EdgeInsets.all(7),
                            decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(5)),
                              border: Border.all(color: colorDivider),
                            ),
                            child: Center(
                              child: StreamBuilder(
                                initialData: '开始日期',
                                stream: dateStart.stream,
                                builder: (c, s) => Text(
                                      s.data,
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey,
                                      ),
                                    ),
                              ),
                            ),
                          ),
                          onTap: () async {
                            var date = await showDatePicker(
                              context: context,
                              initialDate: dateStart.value?.isNotEmpty == true
                                  ? DateTime.parse(
                                      dateStart.value,
                                    )
                                  : DateTime.now(),
                              firstDate: DateTime(DateTime.now().year,
                                  DateTime.now().month, DateTime.now().day),
                              lastDate:
                                  DateTime(DateTime.now().year + 10, 12, 31),
                            );
                            if (date != null) {
                              dateStart.value =
                                  DateFormat('yyyy-MM-dd').format(date);
                            }
                          },
                        ),
                      ),
                      Container(
                        width: 10,
                        margin: EdgeInsets.symmetric(horizontal: 10),
                        child: Divider(
                          height: 2,
                          color: colorDivider,
                        ),
                      ),
                      Flexible(
                        child: InkWell(
                          borderRadius: BorderRadius.all(Radius.circular(5)),
                          child: Container(
                            width: double.infinity,
                            padding: EdgeInsets.all(7),
                            decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(5)),
                              border: Border.all(color: colorDivider),
                            ),
                            child: Center(
                              child: StreamBuilder(
                                initialData: '结束日期',
                                stream: dateEnd.stream,
                                builder: (c, s) => Text(
                                      s.data,
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey,
                                      ),
                                    ),
                              ),
                            ),
                          ),
                          onTap: () async {
                            var date = await showDatePicker(
                              context: context,
                              initialDate: dateEnd.value?.isNotEmpty == true
                                  ? DateTime.parse(
                                      dateEnd.value,
                                    )
                                  : dateStart.value?.isNotEmpty == true
                                      ? DateTime(
                                          DateTime.parse(
                                            dateStart.value,
                                          ).year,
                                          DateTime.parse(
                                            dateStart.value,
                                          ).month,
                                          DateTime.parse(
                                                dateStart.value,
                                              ).day +
                                              1,
                                        )
                                      : DateTime.now(),
                              firstDate: dateStart.value?.isNotEmpty == true
                                  ? DateTime(
                                      DateTime.parse(dateStart.value).year,
                                      DateTime.parse(dateStart.value).month,
                                      DateTime.parse(dateStart.value).day + 1,
                                    )
                                  : DateTime(
                                      DateTime.now().year,
                                      DateTime.now().month,
                                      DateTime.now().day,
                                    ),
                              lastDate:
                                  DateTime(DateTime.now().year + 10, 12, 31),
                            );
                            if (date != null) {
                              dateEnd.value =
                                  DateFormat('yyyy-MM-dd').format(date);
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 15),
                    child: Text(
                      '联系方式',
                      style: TextStyle(fontSize: 12),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(7),
                    margin: EdgeInsets.only(top: 5),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(4)),
                      border: Border.all(color: colorDivider),
                    ),
                    child: TextField(
                      textAlign: TextAlign.center,
                      controller: TextEditingController.fromValue(
                        TextEditingValue(
                          text: id,
                        ),
                      ),
                      style: TextStyle(fontSize: 12),
                      decoration: InputDecoration(
                        hintText: '请输入联系方式',
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.all(0),
                      ),
                      onChanged: (s) {
                        contact = s;
                      },
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 15),
                    child: Text(
                      '客户名称',
                      style: TextStyle(fontSize: 12),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(7),
                    margin: EdgeInsets.only(top: 5),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(4)),
                      border: Border.all(color: colorDivider),
                    ),
                    child: TextField(
                      textAlign: TextAlign.center,
                      controller: TextEditingController.fromValue(
                        TextEditingValue(
                          text: id,
                        ),
                      ),
                      style: TextStyle(fontSize: 12),
                      decoration: InputDecoration(
                        hintText: '请输入客户名称',
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.all(0),
                      ),
                      onChanged: (s) {
                        clientName = s;
                      },
                    ),
                  ),
                  Container(
                    height: _bloc.businessType & 0xf == typeTrace ? null : 0,
                    margin: EdgeInsets.only(
                      top: _bloc.businessType & 0xf == typeTrace ? 15 : 0,
                    ),
                    child: Text(
                      '甲方负责人',
                      style: TextStyle(fontSize: 12),
                    ),
                  ),
                  Container(
                    height: _bloc.businessType & 0xf == typeTrace ? null : 0,
                    padding: EdgeInsets.all(7),
                    margin: EdgeInsets.only(
                      top: _bloc.businessType & 0xf == typeTrace ? 5 : 0,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(4)),
                      border: Border.all(color: colorDivider),
                    ),
                    child: TextField(
                      textAlign: TextAlign.center,
                      controller: TextEditingController.fromValue(
                        TextEditingValue(
                          text: id,
                        ),
                      ),
                      style: TextStyle(fontSize: 12),
                      decoration: InputDecoration(
                        hintText: '请输入甲方负责人名称',
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.all(0),
                      ),
                      onChanged: (s) {
                        responsibleMan = s;
                      },
                    ),
                  ),
                  GestureDetector(
                    child: Container(
                      margin: EdgeInsets.only(top: 10),
                      padding: EdgeInsets.symmetric(vertical: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            '来源类型',
                            style: TextStyle(fontSize: 12),
                          ),
                          StreamBuilder<List>(
                            stream: sources,
                            builder: (c, s) => s.data?.isEmpty == true
                                ? Image.asset('assets/images/ico_htxq_jt_s.png')
                                : Image.asset(
                                    'assets/images/ico_htxq_jt_x.png'),
                          )
                        ],
                      ),
                    ),
                    onTap: () {
                      if (sources.value.isEmpty) {
                        sources.value = List.from(sourceTypes);
                      } else {
                        sources.value = [];
                      }
                    },
                  ),
                  StreamBuilder<List<RadioBean>>(
                    stream: sources,
                    builder: (c, s) => AnimatedSize(
                          duration: Duration(milliseconds: 500),
                          curve: Curves.fastOutSlowIn,
                          vsync: this,
                          child: Container(
                            height: s.data?.isEmpty == true ? 0 : null,
                            child: GridView.builder(
                                physics: NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 3,
                                  crossAxisSpacing: 12.5,
                                  mainAxisSpacing: 10,
                                  childAspectRatio: 2.5,
                                ),
                                itemCount: s.data?.length ?? 0,
                                itemBuilder: (context, index) {
                                  var item = s.data[index];
                                  return StreamBuilder<int>(
                                    stream: source,
                                    builder: (c, s) => Material(
                                          child: Container(
                                            color: Colors.white,
                                            child: GestureDetector(
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  color: s.data == item.id
                                                      ? colorOriginLight
                                                      : colorGrey,
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(4.0)),
                                                ),
                                                child: Center(
                                                  child: Text(
                                                    item.name,
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                      fontSize: 12,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              onTap: () {
                                                if (source.value != item.id) {
                                                  source.value = item.id;
                                                } else {
                                                  source.value = null;
                                                }
                                              },
                                            ),
                                          ),
                                        ),
                                  );
                                }),
                          ),
                        ),
                  ),
                  GestureDetector(
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            '所在地',
                            style: TextStyle(fontSize: 12),
                          ),
                          StreamBuilder<List>(
                            stream: filterLocations,
                            builder: (c, s) => s.data?.isEmpty == true
                                ? Image.asset('assets/images/ico_htxq_jt_s.png')
                                : Image.asset(
                                    'assets/images/ico_htxq_jt_x.png'),
                          )
                        ],
                      ),
                    ),
                    onTap: () {
                      if (filterLocations.value.isEmpty) {
                        filterLocations.value = List.from(locations);
                      } else {
                        filterLocations.value = [];
                      }
                    },
                  ),
                  StreamBuilder<List<RadioBean>>(
                    stream: filterLocations,
                    builder: (c, s) => AnimatedSize(
                          duration: Duration(milliseconds: 500),
                          curve: Curves.fastOutSlowIn,
                          vsync: this,
                          child: Container(
                            height: s.data?.isEmpty == true ? 0 : null,
                            child: GridView.builder(
                                physics: NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 3,
                                  crossAxisSpacing: 12.5,
                                  mainAxisSpacing: 10,
                                  childAspectRatio: 2.5,
                                ),
                                itemCount: s.data?.length ?? 0,
                                itemBuilder: (context, index) {
                                  var item = s.data[index];
                                  return StreamBuilder<int>(
                                    stream: location,
                                    builder: (c, s) => Material(
                                          child: Container(
                                            color: Colors.white,
                                            child: GestureDetector(
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  color: s.data == item.id
                                                      ? colorOriginLight
                                                      : colorGrey,
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(4.0)),
                                                ),
                                                child: Center(
                                                  child: Text(
                                                    item.name,
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                      fontSize: 12,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              onTap: () {
                                                if (location.value != item.id) {
                                                  location.value = item.id;
                                                } else {
                                                  location.value = null;
                                                }
                                              },
                                            ),
                                          ),
                                        ),
                                  );
                                }),
                          ),
                        ),
                  ),
                  GestureDetector(
                    child: Container(
                      height: _bloc.businessType & 0xf == typeClient ? null : 0,
                      padding: EdgeInsets.symmetric(vertical: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            '公司类型',
                            style: TextStyle(fontSize: 12),
                          ),
                          StreamBuilder<List>(
                            stream: companies,
                            builder: (c, s) => s.data?.isEmpty == true
                                ? Image.asset('assets/images/ico_htxq_jt_s.png')
                                : Image.asset(
                                    'assets/images/ico_htxq_jt_x.png'),
                          )
                        ],
                      ),
                    ),
                    onTap: () {
                      if (companies.value.isEmpty) {
                        companies.value = List.from(companyTypes);
                      } else {
                        companies.value = [];
                      }
                    },
                  ),
                  StreamBuilder<List<RadioBean>>(
                    stream: companies,
                    builder: (c, s) => AnimatedSize(
                          duration: Duration(milliseconds: 500),
                          curve: Curves.fastOutSlowIn,
                          vsync: this,
                          child: Container(
                            height: s.data?.isEmpty == true ||
                                    _bloc.businessType & 0xf == typeTrace
                                ? 0
                                : null,
                            child: GridView.builder(
                                physics: NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 3,
                                  crossAxisSpacing: 12.5,
                                  mainAxisSpacing: 10,
                                  childAspectRatio: 2.5,
                                ),
                                itemCount: s.data?.length ?? 0,
                                itemBuilder: (context, index) {
                                  var item = s.data[index];
                                  return StreamBuilder<int>(
                                    stream: company,
                                    builder: (c, s) => Material(
                                          child: Container(
                                            color: Colors.white,
                                            child: GestureDetector(
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  color: s.data == item.id
                                                      ? colorOriginLight
                                                      : colorGrey,
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(4.0)),
                                                ),
                                                child: Center(
                                                  child: Text(
                                                    item.name,
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                      fontSize: 12,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              onTap: () {
                                                if (company.value != item.id) {
                                                  company.value = item.id;
                                                } else {
                                                  company.value = null;
                                                }
                                              },
                                            ),
                                          ),
                                        ),
                                  );
                                }),
                          ),
                        ),
                  ),
                  Container(
                    height: _bloc.businessType & 0xf == typeClient ? null : 0,
                    padding: EdgeInsets.symmetric(vertical: 10),
                    child: Text(
                      '是否重点',
                      style: TextStyle(fontSize: 12),
                    ),
                  ),
                  Container(
                    height: _bloc.businessType & 0xf == typeClient ? null : 0,
                    child: GridView.builder(
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          crossAxisSpacing: 12.5,
                          mainAxisSpacing: 10,
                          childAspectRatio: 2.5,
                        ),
                        itemCount: 2,
                        itemBuilder: (context, index) {
                          var item = booleans[index];
                          return StreamBuilder<int>(
                            stream: isImportant,
                            builder: (c, s) => Material(
                                  child: Container(
                                    color: Colors.white,
                                    child: GestureDetector(
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: s.data == item.id
                                              ? colorOriginLight
                                              : colorGrey,
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(4.0)),
                                        ),
                                        child: Center(
                                          child: Text(
                                            item.name,
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              fontSize: 12,
                                            ),
                                          ),
                                        ),
                                      ),
                                      onTap: () {
                                        if (isImportant.value != item.id) {
                                          isImportant.value = item.id;
                                        } else {
                                          isImportant.value = null;
                                        }
                                      },
                                    ),
                                  ),
                                ),
                          );
                        }),
                  ),
                  GestureDetector(
                    child: Container(
                      height: _bloc.businessType & 0xf == typeClient ? null : 0,
                      padding: EdgeInsets.symmetric(vertical: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            '执行比例',
                            style: TextStyle(fontSize: 12),
                          ),
                          StreamBuilder<List>(
                            stream: filterProgresses,
                            builder: (c, s) => s.data?.isEmpty == true
                                ? Image.asset('assets/images/ico_htxq_jt_s.png')
                                : Image.asset(
                                    'assets/images/ico_htxq_jt_x.png'),
                          )
                        ],
                      ),
                    ),
                    onTap: () {
                      if (filterProgresses.value.isEmpty) {
                        filterProgresses.value = List.from(companyTypes);
                      } else {
                        filterProgresses.value = [];
                      }
                    },
                  ),
                  StreamBuilder<List<RadioBean>>(
                    stream: filterProgresses,
                    builder: (c, s) => AnimatedSize(
                          duration: Duration(milliseconds: 500),
                          curve: Curves.fastOutSlowIn,
                          vsync: this,
                          child: Container(
                            height: s.data?.isEmpty == true ||
                                    _bloc.businessType & 0xf == typeTrace
                                ? 0
                                : null,
                            child: GridView.builder(
                                physics: NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 3,
                                  crossAxisSpacing: 12.5,
                                  mainAxisSpacing: 10,
                                  childAspectRatio: 2.5,
                                ),
                                itemCount: s.data?.length ?? 0,
                                itemBuilder: (context, index) {
                                  var item = s.data[index];
                                  return StreamBuilder<int>(
                                    stream: company,
                                    builder: (c, s) => Material(
                                          child: Container(
                                            color: Colors.white,
                                            child: GestureDetector(
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  color: s.data == item.id
                                                      ? colorOriginLight
                                                      : colorGrey,
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(4.0)),
                                                ),
                                                child: Center(
                                                  child: Text(
                                                    item.name,
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                      fontSize: 12,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              onTap: () {
                                                if (progress.value != item.id) {
                                                  progress.value = item.id;
                                                } else {
                                                  progress.value = null;
                                                }
                                              },
                                            ),
                                          ),
                                        ),
                                  );
                                }),
                          ),
                        ),
                  ),
                  Container(
                    height: _bloc.businessType & 0xf == typeClient ? null : 0,
                    padding: EdgeInsets.symmetric(vertical: 10),
                    child: Text(
                      '二次开发',
                      style: TextStyle(fontSize: 12),
                    ),
                  ),
                  Container(
                    height: _bloc.businessType & 0xf == typeClient ? null : 0,
                    child: GridView.builder(
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          crossAxisSpacing: 12.5,
                          mainAxisSpacing: 10,
                          childAspectRatio: 2.5,
                        ),
                        itemCount: 2,
                        itemBuilder: (context, index) {
                          var item = booleans[index];
                          return StreamBuilder<int>(
                            stream: secondDev,
                            builder: (c, s) => Material(
                                  child: Container(
                                    color: Colors.white,
                                    child: GestureDetector(
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: s.data == item.id
                                              ? colorOriginLight
                                              : colorGrey,
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(4.0)),
                                        ),
                                        child: Center(
                                          child: Text(
                                            item.name,
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              fontSize: 12,
                                            ),
                                          ),
                                        ),
                                      ),
                                      onTap: () {
                                        if (secondDev.value != item.id) {
                                          secondDev.value = item.id;
                                        } else {
                                          secondDev.value = null;
                                        }
                                      },
                                    ),
                                  ),
                                ),
                          );
                        }),
                  ),
                  Divider(
                    height: 40,
                    color: Colors.white,
                  ),
                ],
              ),
            ),
          ),
          Container(
            height: 60,
            child: Material(
              elevation: defaultElevation,
              color: Colors.white,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  ..._actions.map((a) => a.build()),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void reset() {
    id = _bloc.id;
    maker = _bloc.maker;
    if (_bloc.dateStart.isNotEmpty) dateStart.value = _bloc.dateStart;
    if (_bloc.dateEnd.isNotEmpty) dateEnd.value = _bloc.dateEnd;
    contact = _bloc.contact;
    clientName = _bloc.clientName;
    responsibleMan = _bloc.responsibleMan;
    if (_bloc.source.isNotEmpty) source.value = int.parse(_bloc.source);
    if (_bloc.location.isNotEmpty) location.value = int.parse(_bloc.location);
    if (_bloc.company.isNotEmpty) company.value = int.parse(_bloc.company);
    if (_bloc.isImportant.isNotEmpty) {
      isImportant.value = int.parse(_bloc.isImportant);
    }
    if (_bloc.progress.isNotEmpty) progress.value = int.parse(_bloc.progress);
    if (_bloc.secondDev.isNotEmpty) {
      secondDev.value = int.parse(_bloc.secondDev);
    }
  }

  void filter() {
    _bloc.id = id;
    _bloc.maker = maker;
    _bloc.dateStart = dateStart?.value ?? '';
    _bloc.dateEnd = dateEnd?.value ?? '';
    _bloc.contact = contact;
    _bloc.clientName = clientName;
    _bloc.responsibleMan = responsibleMan;
    _bloc.source = source.value?.toString() ?? '';
    _bloc.location = location.value?.toString() ?? '';
    _bloc.company = company.value?.toString() ?? '';
    _bloc.isImportant = isImportant.value?.toString() ?? '';
    _bloc.progress = progress.value?.toString() ?? '';
    _bloc.secondDev = secondDev.value?.toString() ?? '';
    _bloc.initData();
    Navigator.pop(context);
  }
}
