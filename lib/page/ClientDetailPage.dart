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
  ClientDetailPage(this._client);

  final Client _client;

  @override
  State<StatefulWidget> createState() {
    return ClientDetailPageState();
  }
}

class ClientDetailPageState
    extends CommonPageState<ClientDetailPage, ClientDetailBloc> {
  final _controller = PageController();

  List<Widget> _page;

  @override
  void initState() {
    if (bloc == null) {
      bloc = ClientDetailBloc(widget._client);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (_page == null) {
      _page = List<Widget>();
      _page.add(ClientInfoPage());
      _page.add(ContactsPage());
      _page.add(ClientNeedPage());
      _page.add(VisitLogsPage());
      _page.add(ClientSupportPage());
      _page.add(OperationLogPage());
    }

    return BlocProvider<ClientDetailBloc>(
      bloc: bloc,
      child: Scaffold(
        key: scaffoldKey,
        appBar: AppBar(
          title: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(widget._client == null ? "新建客户" : "ID：${widget._client.id}"),
              Offstage(
                offstage:
                    widget._client == null || widget._client.is_important != 1,
                child: Container(
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
            IconButton(
              icon: Icon(
                Icons.check,
                color: Colors.black,
              ),
              onPressed: () {
                bloc.save();
              },
            )
          ],
        ),
        body: Container(
          padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
          child: Column(
            children: <Widget>[
              Expanded(
                child: Column(
                  children: <Widget>[
                    TextField(
                      controller: TextEditingController(text: bloc.clientName),
                      decoration: InputDecoration(
                        hintText: "请输入客户名称",
                        border: InputBorder.none,
                      ),
                      style: Theme.of(context).textTheme.title,
                      onChanged: (s) {
                        bloc.clientName = s;
                      },
                    ),
                    Expanded(
                      child: Container(
                        margin: EdgeInsets.symmetric(
                          vertical: 12.0,
                        ),
                        child: PageView.builder(
                          physics: BouncingScrollPhysics(),
                          controller: _controller,
                          itemCount: _page.length,
                          itemBuilder: (BuildContext context, int index) {
                            return Card(
                              elevation: 2.0,
                              shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(4.0)),
                              ),
                              color: Theme.of(context).primaryColor,
                              child: _page[index],
                            );
                          },
                        ),
                      ),
                    ),
                    DotsIndicator(
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
//        SnackBar(
//          content: Text("请输入客户名称"),
//        ),
//      );
//      return;
//    }
//    if (bloc.company.id == 0) {
//      _key.currentState.showSnackBar(
//        SnackBar(
//          content: Text("请选择公司类型"),
//        ),
//      );
//      return;
//    }
//    if (bloc.industry.id == 0) {
//      _key.currentState.showSnackBar(
//        SnackBar(
//          content: Text("请选择所属行业"),
//        ),
//      );
//      return;
//    }
//    if (bloc.source.id == 0) {
//      _key.currentState.showSnackBar(
//        SnackBar(
//          content: Text("请选择来源类型"),
//        ),
//      );
//      return;
//    }
//    if (bloc.location.id == 0) {
//      _key.currentState.showSnackBar(
//        SnackBar(
//          content: Text("请选择所在地"),
//        ),
//      );
//      return;
//    }
//    if (bloc.invoiceCount.isEmpty) {
//      _key.currentState.showSnackBar(
//        SnackBar(
//          content: Text("请输入年发票量"),
//        ),
//      );
//      return;
//    }
//    if (bloc.email != null &&
//        bloc.email.isNotEmpty &&
//        !EmailValidator.validate(bloc.email)) {
//      _key.currentState.showSnackBar(
//        SnackBar(
//          content: Text("邮箱格式不正确"),
//        ),
//      );
//      return;
//    }
//    if (bloc.contactWay == null || bloc.contactWay.isEmpty) {
//      _key.currentState.showSnackBar(
//        SnackBar(
//          content: Text("请输入联系方式"),
//        ),
//      );
//      return;
//    }
//    if (bloc.title == null || bloc.title.isEmpty) {
//      _key.currentState.showSnackBar(
//        SnackBar(
//          content: Text("请输入职务"),
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
//        SnackBar(
//          content: Text(rsp.msg),
//        ),
//      );
//    }
//  }
}
