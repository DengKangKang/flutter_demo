import 'package:flutter/material.dart';
import 'package:flutter_app/bloc/Bloc.dart';
import 'package:flutter_app/bloc/ClientDetailBloc.dart';

class ContactsPage extends StatefulWidget {
  ContactsPage({
    Key key,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return ContactsPageState();
  }
}

class ContactsPageState extends State<ContactsPage>
    with AutomaticKeepAliveClientMixin<ContactsPage> {
  ClientDetailBloc _bloc;

  @override
  void initState() {
    if (_bloc == null) _bloc = BlocProvider.of(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      physics: BouncingScrollPhysics(),
      padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
      children: <Widget>[
        Align(
          alignment: Alignment.topLeft,
          child: Text("联系人信息"),
        ),
        Container(
          margin: EdgeInsets.only(top: 12.0),
          child: Card(
            elevation: 2.0,
            color: Theme.of(context).backgroundColor,
            margin: EdgeInsets.all(0.0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(4.0)),
            ),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    margin: EdgeInsets.only(right: 16.0),
                    child: Text(
                      "甲方负责人",
                      style: Theme.of(context).textTheme.body1.merge(
                            TextStyle(
                              color: Colors.grey,
                            ),
                          ),
                    ),
                  ),
                  Flexible(
                    child: TextField(
                      keyboardType: TextInputType.multiline,
                      maxLengthEnforced: true,
                      maxLines: null,
                      controller: TextEditingController.fromValue(
                        TextEditingValue(
                          text: _bloc.firstPartyRepresentatives,
                        ),
                      ),
                      textAlign: TextAlign.end,
                      decoration: InputDecoration(
                        hintText: "请输入甲方负责人",
                        border: InputBorder.none,
                      ),
                      style:
                          Theme.of(context).textTheme.body1.merge(TextStyle()),
                      onChanged: (s) {
                        _bloc.firstPartyRepresentatives = s;
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        Container(
          margin: EdgeInsets.only(top: 12.0),
          child: Card(
            elevation: 2.0,
            color: Theme.of(context).backgroundColor,
            margin: EdgeInsets.all(0.0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(4.0)),
            ),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    margin: EdgeInsets.only(right: 16.0),
                    child: Text(
                      "*联系方式",
                      style: Theme.of(context).textTheme.body1.merge(
                            TextStyle(
                              color: Colors.grey,
                            ),
                          ),
                    ),
                  ),
                  Flexible(
                    child: TextField(
                      keyboardType: TextInputType.emailAddress,
                      maxLengthEnforced: true,
                      maxLines: null,
                      controller: TextEditingController.fromValue(
                        TextEditingValue(
                          text: _bloc.contactWay,
                        ),
                      ),
                      textAlign: TextAlign.end,
                      decoration: InputDecoration(
                        hintText: "请输入联系方式",
                        border: InputBorder.none,
                      ),
                      style:
                          Theme.of(context).textTheme.body1.merge(TextStyle()),
                      onChanged: (s) {
                        _bloc.contactWay = s;
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        Container(
          margin: EdgeInsets.only(top: 12.0),
          child: Card(
            elevation: 2.0,
            color: Theme.of(context).backgroundColor,
            margin: EdgeInsets.all(0.0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(4.0)),
            ),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    margin: EdgeInsets.only(right: 16.0),
                    child: Text(
                      "邮箱",
                      style: Theme.of(context).textTheme.body1.merge(
                            TextStyle(
                              color: Colors.grey,
                            ),
                          ),
                    ),
                  ),
                  Flexible(
                    child: TextField(
                      keyboardType: TextInputType.emailAddress,
                      maxLengthEnforced: true,
                      maxLines: null,
                      controller: TextEditingController.fromValue(
                        TextEditingValue(
                          text: _bloc.email,
                        ),
                      ),
                      textAlign: TextAlign.end,
                      decoration: InputDecoration(
                        hintText: "请输入邮箱",
                        border: InputBorder.none,
                      ),
                      style:
                          Theme.of(context).textTheme.body1.merge(TextStyle()),
                      onChanged: (s) {
                        _bloc.email = s;
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        Container(
          margin: EdgeInsets.only(top: 12.0),
          child: Card(
            elevation: 2.0,
            color: Theme.of(context).backgroundColor,
            margin: EdgeInsets.all(0.0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(4.0)),
            ),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    margin: EdgeInsets.only(right: 16.0),
                    child: Text(
                      "*职务",
                      style: Theme.of(context).textTheme.body1.merge(
                            TextStyle(
                              color: Colors.grey,
                            ),
                          ),
                    ),
                  ),
                  Flexible(
                    child: TextField(
                      keyboardType: TextInputType.multiline,
                      maxLengthEnforced: true,
                      maxLines: null,
                      controller: TextEditingController.fromValue(
                        TextEditingValue(
                          text: _bloc.title,
                        ),
                      ),
                      textAlign: TextAlign.end,
                      decoration: InputDecoration(
                        hintText: "请输入职务",
                        border: InputBorder.none,
                      ),
                      style:
                          Theme.of(context).textTheme.body1.merge(TextStyle()),
                      onChanged: (s) {
                        _bloc.title = s;
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  @override
  bool get wantKeepAlive => true;
}
