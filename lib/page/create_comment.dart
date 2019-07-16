import 'package:flutter/material.dart';
import 'package:flutter_app/data/http/api_service.dart';
import 'package:flutter_app/weight/Tool.dart';

import '../main.dart';

class CreateCommentPage extends StatefulWidget {
  CreateCommentPage({Key key, this.dailyId, this.targetName, this.targetId})
      : super(key: key);

  final dailyId; //日志id
  final targetName;
  final targetId;

  @override
  State<StatefulWidget> createState() {
    return CreateCommentPageState();
  }
}

class CreateCommentPageState extends State<CreateCommentPage> {
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
          elevation: 0,
          centerTitle: true,
          title: Text('评论'),
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
          child: Container(
            padding: EdgeInsets.all(10),
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(4)),
              border: Border.all(color: Color(0xFFF1F1F1)),
            ),
            child: TextField(
              controller: _contentController,
              maxLines: null,
              keyboardType: TextInputType.multiline,
              decoration: InputDecoration(
                hintText: widget.targetName != null ?'回复${widget.targetName}' : '请输入评论内容',
                hintStyle: TextStyle(fontSize: 15),
                border: InputBorder.none,
                contentPadding: EdgeInsets.all(0),
              ),
            ),
          ),
        ));
  }

  void _onAdd(BuildContext context) async {
    var content = _contentController.value.text;

    if (content == null || content.isEmpty) {
      _scaffoldKey.currentState.showSnackBar(
        SnackBar(
          content: Text("请输入评论内容"),
        ),
      );
      return;
    }
    onLoading(context);
    var rsp = await ApiService().comment(
      content,
      daily_id: widget.dailyId ?? '',
      target_name: widget.targetName ?? '',
      target_id: widget.targetId.toString() ?? '',
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
