import 'package:flutter/material.dart';
import 'package:flutter_app/bloc/Bloc.dart';
import 'package:flutter_app/bloc/ClientDetailBloc.dart';

class ContactsPage extends StatefulWidget {
  ContactsPage({
    Key key,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return new ContactsPageState();
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
    return new ListView(
      physics: new BouncingScrollPhysics(),
      padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
      children: <Widget>[
        new Align(
          alignment: Alignment.topLeft,
          child: new Text("联系人信息"),
        ),
        new Container(
          margin: EdgeInsets.only(top: 12.0),
          child: new Card(
            elevation: 2.0,
            color: Theme.of(context).backgroundColor,
            margin: EdgeInsets.all(0.0),
            shape: new RoundedRectangleBorder(
              borderRadius: new BorderRadius.all(new Radius.circular(4.0)),
            ),
            child: new Container(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: new Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  new Container(
                    margin: EdgeInsets.only(right: 16.0),
                    child: new Text(
                      "甲方负责人",
                      style: Theme.of(context).textTheme.body1.merge(
                            TextStyle(
                              color: Colors.grey,
                            ),
                          ),
                    ),
                  ),
                  new Flexible(
                    child: TextField(
                      keyboardType: TextInputType.multiline,
                      maxLengthEnforced: true,
                      maxLines: null,
                      controller: TextEditingController.fromValue(
                        new TextEditingValue(
                          text: _bloc.firstPartyRepresentatives,
                        ),
                      ),
                      textAlign: TextAlign.end,
                      decoration: new InputDecoration(
                        hintText: "请输入甲方负责人",
                        border: InputBorder.none,
                      ),
                      style: Theme.of(context)
                          .textTheme
                          .body1
                          .merge(new TextStyle()),
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
        new Container(
          margin: EdgeInsets.only(top: 12.0),
          child: new Card(
            elevation: 2.0,
            color: Theme.of(context).backgroundColor,
            margin: EdgeInsets.all(0.0),
            shape: new RoundedRectangleBorder(
              borderRadius: new BorderRadius.all(new Radius.circular(4.0)),
            ),
            child: new Container(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: new Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  new Container(
                    margin: EdgeInsets.only(right: 16.0),
                    child: new Text(
                      "*联系方式",
                      style: Theme.of(context).textTheme.body1.merge(
                            TextStyle(
                              color: Colors.grey,
                            ),
                          ),
                    ),
                  ),
                  new Flexible(
                    child: TextField(
                      keyboardType: TextInputType.emailAddress,
                      maxLengthEnforced: true,
                      maxLines: null,
                      controller: TextEditingController.fromValue(
                        new TextEditingValue(
                          text: _bloc.contactWay,
                        ),
                      ),
                      textAlign: TextAlign.end,
                      decoration: new InputDecoration(
                        hintText: "请输入联系方式",
                        border: InputBorder.none,
                      ),
                      style: Theme.of(context)
                          .textTheme
                          .body1
                          .merge(new TextStyle()),
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
        new Container(
          margin: EdgeInsets.only(top: 12.0),
          child: new Card(
            elevation: 2.0,
            color: Theme.of(context).backgroundColor,
            margin: EdgeInsets.all(0.0),
            shape: new RoundedRectangleBorder(
              borderRadius: new BorderRadius.all(new Radius.circular(4.0)),
            ),
            child: new Container(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: new Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  new Container(
                    margin: EdgeInsets.only(right: 16.0),
                    child: new Text(
                      "邮箱",
                      style: Theme.of(context).textTheme.body1.merge(
                            TextStyle(
                              color: Colors.grey,
                            ),
                          ),
                    ),
                  ),
                  new Flexible(
                    child: TextField(
                      keyboardType: TextInputType.emailAddress,
                      maxLengthEnforced: true,
                      maxLines: null,
                      controller: TextEditingController.fromValue(
                        new TextEditingValue(
                          text: _bloc.email,
                        ),
                      ),
                      textAlign: TextAlign.end,
                      decoration: new InputDecoration(
                        hintText: "请输入邮箱",
                        border: InputBorder.none,
                      ),
                      style: Theme.of(context)
                          .textTheme
                          .body1
                          .merge(new TextStyle()),
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
        new Container(
          margin: EdgeInsets.only(top: 12.0),
          child: new Card(
            elevation: 2.0,
            color: Theme.of(context).backgroundColor,
            margin: EdgeInsets.all(0.0),
            shape: new RoundedRectangleBorder(
              borderRadius: new BorderRadius.all(new Radius.circular(4.0)),
            ),
            child: new Container(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: new Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  new Container(
                    margin: EdgeInsets.only(right: 16.0),
                    child: new Text(
                      "*职务",
                      style: Theme.of(context).textTheme.body1.merge(
                            TextStyle(
                              color: Colors.grey,
                            ),
                          ),
                    ),
                  ),
                  new Flexible(
                    child: TextField(
                      keyboardType: TextInputType.multiline,
                      maxLengthEnforced: true,
                      maxLines: null,
                      controller: TextEditingController.fromValue(
                        new TextEditingValue(
                          text: _bloc.title,
                        ),
                      ),
                      textAlign: TextAlign.end,
                      decoration: new InputDecoration(
                        hintText: "请输入职务",
                        border: InputBorder.none,
                      ),
                      style: Theme.of(context)
                          .textTheme
                          .body1
                          .merge(new TextStyle()),
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
