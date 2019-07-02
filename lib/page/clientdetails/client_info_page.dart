import 'package:flutter/material.dart';
import 'package:flutter_app/data/http/api_service.dart';
import 'package:flutter_app/data/http/rsp/data/clients_data.dart';

import '../RadioListPage.dart';

class ClientInfoPage extends StatefulWidget {
  ClientInfoPage({
    Key key,
    this.client,
  }) : super(key: key);

  final Client client;

  @override
  State<StatefulWidget> createState() {
    return ClientInfoPageState();
  }
}

class ClientInfoPageState extends State<ClientInfoPage>
    with AutomaticKeepAliveClientMixin<ClientInfoPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return ListView(
      physics: BouncingScrollPhysics(),
      children: <Widget>[
        buildItem(
          context,
          '公司类型',
          widget.client.leads_name??'',
        ),
        buildItem(
          context,
          '所属行业',
          industries
                  .firstWhere((e) => e.id == widget.client.industry,
                      orElse: () => null)
                  ?.name ??
              '',
        ),
        buildItem(
          context,
          '所在地',
          locations
                  .firstWhere((e) => e.id == widget.client.location,
                      orElse: () => null)
                  ?.name ??
              '',
        ),
        buildItem(
          context,
          '年发票量',
          widget.client.annual_invoice?.toString() ?? '0',
        ),
        buildItem(
          context,
          '是否为二次开发',
          widget.client?.on_premise == yes ? '是' : '否',
        ),
        buildItem(
          context,
          '执行比例',
            progresses.firstWhere(
                  (e) => e.id == widget.client?.progress_percent,
              orElse: () => null,
            )?.name??''
        ),
        buildItem(
          context,
          '预计签约额',
          widget.client?.anticipated_amount ?? '',
        ),
        buildItem(
          context,
          '预计签约日',
          widget.client.anticipated_date??'',
        ),
        buildItem(
          context,
          '公司规模',
          widget.client.company_size??'',
        ),
        buildItem(
          context,
          '公司简介',
          widget.client.memo??'',
          showLine: false,
        ),
      ],
    );
  }

  Widget buildItem(BuildContext context, String title, String content,
      {bool showLine = true}) {
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
                Flexible(
                  child: Text(
                    content,
                    style: TextStyle(fontSize: 15, color: Colors.grey),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
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

  @override
  bool get wantKeepAlive => true;
}
