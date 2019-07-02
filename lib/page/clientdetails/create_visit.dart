import 'package:flutter/material.dart';
import 'package:flutter_app/data/http/api_service.dart';
import 'package:flutter_app/weight/Tool.dart';

import '../../main.dart';

class CreateVisitPage extends StatefulWidget {
  const CreateVisitPage({Key key, this.id}) : super(key: key);

  final id;

  @override
  State<StatefulWidget> createState() {
    return CreateVisitPagePageState();
  }
}

class CreateVisitPagePageState extends State<CreateVisitPage> {
  var _contentController = TextEditingController.fromValue(
    TextEditingValue(
      text: '',
    ),
  );

  var _scaffoldKey = GlobalKey<ScaffoldState>();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        backgroundColor: colorBg,
        appBar: AppBar(
          centerTitle: true,
          title: Text('添加拜访'),
          actions: <Widget>[
            InkWell(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Center(
                  child: Text(
                    '保存',
                    style: TextStyle(
                      fontSize: 15,
                      color: colorOrigin,
                    ),
                  ),
                ),
              ),
              onTap: () {
                _onAdd(context);
              },
            )
          ],
        ),
        body: Container(
          height: 240,
          margin: EdgeInsets.symmetric(vertical: 10),
          padding: EdgeInsets.all(20),
          color: Colors.white,
          child: Theme(
            data: ThemeData(
              primaryColor: colorOrigin,
            ),
            child: TextField(
              controller: _contentController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: "请输入拜访内容",
                alignLabelWithHint: true,
              ),
              keyboardType: TextInputType.multiline,
              maxLengthEnforced: true,
              maxLines: 100,
            ),
          ),
        ));
  }

  void _onAdd(BuildContext context) async {
    var content =_contentController.value.text;

    if (content == null || content.isEmpty) {
      _scaffoldKey.currentState.showSnackBar(
        SnackBar(
          content: Text("请输入拜访内容"),
        ),
      );
      return;
    }
    onLoading(context);
    var rsp = await ApiService().newVisitLog(
      widget.id.toString(),
      content,
    );
    loadingFinish(context);
    if (rsp.code == ApiService.success) {
      Navigator.of(context).pop(true);
    } else {
      _scaffoldKey.currentState.showSnackBar(
        SnackBar(
          content: Text(rsp.msg),
        ),
      );
    }
  }
}
