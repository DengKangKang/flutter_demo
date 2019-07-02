import 'package:flutter/material.dart';
import 'package:flutter_app/data/http/api_service.dart';
import 'package:flutter_app/weight/Tool.dart';

class NewNeed extends StatefulWidget {
  NewNeed(this._leadId, {Key key}) : super(key: key);

  final int _leadId;

  @override
  State<StatefulWidget> createState() {
    return NewNeedState(_leadId);
  }
}

class NewNeedState extends State<StatefulWidget> {
  NewNeedState(this._leadId);

  final int _leadId;
  final _key = GlobalKey<ScaffoldState>();

  String _need = "";

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _key,
      appBar: AppBar(
        title: Text("新增需求"),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.check,
              color: Colors.black,
            ),
            onPressed: () {
              _onAdd(context);
            },
          )
        ],
      ),
      body: Builder(
        builder: (context) => Container(
              padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
              color: Colors.white,
              child: TextField(
                keyboardType: TextInputType.multiline,
                maxLengthEnforced: true,
                maxLines: null,
                controller: TextEditingController.fromValue(
                  TextEditingValue(
                    text: _need,
                  ),
                ),
                decoration: InputDecoration(
                  hintText: "请输入需求",
                  border: InputBorder.none,
                ),
                style: Theme.of(context).textTheme.body1.merge(TextStyle()),
                onChanged: (s) {
                  _need = s;
                },
              ),
            ),
      ),
    );
  }

  void _onAdd(BuildContext context) async {
    if (_need == null || _need.isEmpty) {
      _key.currentState.showSnackBar(
        SnackBar(
          content: Text("请输入需求"),
        ),
      );
      return;
    }
    onLoading(context);
    var rsp = await ApiService().newNeed(
      _leadId.toString(),
      _need,
    );
    loadingFinish(context);
    if (rsp.code == ApiService.success) {
      Navigator.of(context).pop(true);
    } else {
      _key.currentState.showSnackBar(
        SnackBar(
          content: Text(rsp.msg),
        ),
      );
    }
  }
}
