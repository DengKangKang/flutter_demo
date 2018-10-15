import 'package:flutter/material.dart';
import 'package:flutter_app/data/http/rsp/data/ClientListData.dart';

class ContactsPage extends StatefulWidget {
  final Client _client;

  ContactsPage(
    this._client, {
    Key key,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return new ContactsPageState(_client);
  }
}

class ContactsPageState extends State<ContactsPage>
    with AutomaticKeepAliveClientMixin<ContactsPage> {
  final Client _client;

  String _firstPartyRepresentatives = "";
  String _contactWay = "";
  String _email = "";
  String _title = "";

  ContactsPageState(this._client) {
    if (_client != null) {
      if (_client.leads_contact != null)
        _firstPartyRepresentatives = _client.leads_contact;

      if (_client.leads_mobile != null) _contactWay = _client.leads_mobile;

      if (_client.leads_email != null) _email = _client.leads_email;

      if (_client.job_title != null) _title = _client.job_title;
    }
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
                          text: _firstPartyRepresentatives,
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
                        _firstPartyRepresentatives = s;
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
                      keyboardType: TextInputType.multiline,
                      maxLengthEnforced: true,
                      maxLines: null,
                      controller: TextEditingController.fromValue(
                        new TextEditingValue(
                          text: _contactWay,
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
                        _contactWay = s;
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
                      keyboardType: TextInputType.multiline,
                      maxLengthEnforced: true,
                      maxLines: null,
                      controller: TextEditingController.fromValue(
                        new TextEditingValue(
                          text: _email,
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
                        _email = s;
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
                          text: _title,
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
                        _title = s;
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

  String get firstPartyRepresentatives => _firstPartyRepresentatives;

  String get contactWay => _contactWay;

  String get email => _email;

  String get title => _title;

  @override
  bool get wantKeepAlive => true;
}
