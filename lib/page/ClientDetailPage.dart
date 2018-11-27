import 'package:flutter/material.dart';
import 'package:flutter_app/bloc/Bloc.dart';
import 'package:flutter_app/bloc/ClientDetailBloc.dart';
import 'package:flutter_app/data/http/rsp/data/ClientListData.dart';
import 'package:flutter_app/page/base/CommonPageState.dart';
import 'package:flutter_app/page/clientdetails/ClientInfoPage.dart';
import 'package:flutter_app/page/clientdetails/ClientNeed.dart';
import 'package:flutter_app/page/clientdetails/ClientSupportPage.dart';
import 'package:flutter_app/page/clientdetails/ContactsPage.dart';
import 'package:flutter_app/page/clientdetails/OperationLogPage.dart';
import 'package:flutter_app/page/clientdetails/VisitLogPage.dart';
import 'package:flutter_app/weight/DotsIndicator.dart';

class ClientDetailPage extends StatefulWidget {
  final Client _client;

  ClientDetailPage(this._client);

  @override
  State<StatefulWidget> createState() {
    return new ClientDetailPageState();
  }
}

class ClientDetailPageState extends CommonPageState<ClientDetailPage,ClientDetailBloc> {
  final _controller = new PageController();

  List<Widget> _page;


  @override
  void initState() {
    if (bloc == null) {
      bloc = new ClientDetailBloc(widget._client);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (_page == null) {
      _page = new List<Widget>();
      _page.add(new ClientInfoPage());
      _page.add(new ContactsPage());
      _page.add(new ClientNeedPage());
      _page.add(new VisitLogsPage());
      _page.add(new ClientSupportPage());
      _page.add(new OperationLogPage());
    }

    return BlocProvider<ClientDetailBloc>(
      bloc: bloc,
      child: new Scaffold(
        key: scaffoldKey,
        appBar: new AppBar(
          title: new Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              new Text(
                  widget._client == null ? "新建客户" : "ID：${widget._client.id}"),
              new Offstage(
                offstage:
                    widget._client == null || widget._client.is_important != 1,
                child: new Container(
                  margin: EdgeInsets.only(left: 8.0),
                  child: Icon(
                    Icons.star,
                    color: Colors.amber,
                  ),
                ),
              ),
            ],
          ),
          actions: <Widget>[
            new IconButton(
              icon: new Icon(
                Icons.check,
                color: Colors.black,
              ),
              onPressed: () {
                bloc.save();
              },
            )
          ],
        ),
        body: new Container(
          padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
          child: new Column(
            children: <Widget>[
              new Expanded(
                child: new Column(
                  children: <Widget>[
                    TextField(
                      controller:
                          new TextEditingController(text: bloc.clientName),
                      decoration: new InputDecoration(
                        hintText: "请输入客户名称",
                        border: InputBorder.none,
                      ),
                      style: Theme.of(context).textTheme.title,
                      onChanged: (s) {
                        bloc.clientName = s;
                      },
                    ),
                    new Expanded(
                      child: new Container(
                        margin: EdgeInsets.symmetric(
                          vertical: 12.0,
                        ),
                        child: new PageView.builder(
                          physics: new BouncingScrollPhysics(),
                          controller: _controller,
                          itemCount: _page.length,
                          itemBuilder: (BuildContext context, int index) {
                            return new Card(
                              elevation: 2.0,
                              shape: new RoundedRectangleBorder(
                                borderRadius: new BorderRadius.all(
                                    new Radius.circular(4.0)),
                              ),
                              color: Theme.of(context).primaryColor,
                              child: _page[index],
                            );
                          },
                        ),
                      ),
                    ),
                    new DotsIndicator(
                      controller: _controller,
                      itemCount: _page.length,
                      onPageSelected: (int page) {
                        _controller.animateToPage(
                          page,
                          duration: Duration(milliseconds: 300),
                          curve: Curves.ease,
                        );
                      },
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

//  void _onNewOrSave(BuildContext context) async {
//    if (bloc.clientName.isEmpty) {
//      _key.currentState.showSnackBar(
//        new SnackBar(
//          content: new Text("请输入客户名称"),
//        ),
//      );
//      return;
//    }
//    if (bloc.company.id == 0) {
//      _key.currentState.showSnackBar(
//        new SnackBar(
//          content: new Text("请选择公司类型"),
//        ),
//      );
//      return;
//    }
//    if (bloc.industry.id == 0) {
//      _key.currentState.showSnackBar(
//        new SnackBar(
//          content: new Text("请选择所属行业"),
//        ),
//      );
//      return;
//    }
//    if (bloc.source.id == 0) {
//      _key.currentState.showSnackBar(
//        new SnackBar(
//          content: new Text("请选择来源类型"),
//        ),
//      );
//      return;
//    }
//    if (bloc.location.id == 0) {
//      _key.currentState.showSnackBar(
//        new SnackBar(
//          content: new Text("请选择所在地"),
//        ),
//      );
//      return;
//    }
//    if (bloc.invoiceCount.isEmpty) {
//      _key.currentState.showSnackBar(
//        new SnackBar(
//          content: new Text("请输入年发票量"),
//        ),
//      );
//      return;
//    }
//    if (bloc.email != null &&
//        bloc.email.isNotEmpty &&
//        !EmailValidator.validate(bloc.email)) {
//      _key.currentState.showSnackBar(
//        new SnackBar(
//          content: new Text("邮箱格式不正确"),
//        ),
//      );
//      return;
//    }
//    if (bloc.contactWay == null || bloc.contactWay.isEmpty) {
//      _key.currentState.showSnackBar(
//        new SnackBar(
//          content: new Text("请输入联系方式"),
//        ),
//      );
//      return;
//    }
//    if (bloc.title == null || bloc.title.isEmpty) {
//      _key.currentState.showSnackBar(
//        new SnackBar(
//          content: new Text("请输入职务"),
//        ),
//      );
//      return;
//    }
//    onLoading(context);
//    var rsp = await ApiService().newOrSaveClient(
//      bloc.id,
//      bloc.clientName,
//      bloc.company.id,
//      bloc.industry.id,
//      bloc.source.id,
//      bloc.location.id,
//      bloc.invoiceCount,
//      bloc.startTarget.id,
//      bloc.secondaryDevelopment.id,
//      bloc.progress.id,
//      bloc.expectedContractAmount,
//      bloc.expectedSignDate,
//      bloc.lnsize,
//      bloc.companyIntro,
//      bloc.firstPartyRepresentatives,
//      bloc.contactWay,
//      bloc.email,
//      bloc.title,
//    );
//    loadingFinish(context);
//    if (rsp.code == ApiService.success) {
//      Navigator.of(context).pop(true);
//    } else {
//      _key.currentState.showSnackBar(
//        new SnackBar(
//          content: new Text(rsp.msg),
//        ),
//      );
//    }
//  }
}
