import 'package:email_validator/email_validator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/bloc/Bloc.dart';
import 'package:flutter_app/data/http/api_service.dart';
import 'package:flutter_app/data/http/rsp/data/RadioBean.dart';
import 'package:flutter_app/page/base/CommonPageState.dart';
import 'package:flutter_app/page/client_list_page.dart';
import 'package:flutter_app/page/clientdetails/apply_account/client_apply_debug_account_page.dart';
import 'package:flutter_app/page/clientdetails/apply_account/client_debug_account_page.dart';
import 'package:flutter_app/weight/Tool.dart';
import 'package:intl/intl.dart';
import 'package:rxdart/rxdart.dart';

import '../../main.dart';
import '../RadioListPage.dart';

class NewBusinessPage extends StatefulWidget {
  const NewBusinessPage({Key key, this.type}) : super(key: key);

  final int type;

  @override
  State<StatefulWidget> createState() {
    return NewBusinessPagePageState();
  }
}

class NewBusinessPagePageState
    extends CommonPageState<NewBusinessPage, NewClientBloc> {
  @override
  void initState() {
    if (bloc == null) {
      bloc = NewClientBloc();
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: colorBg,
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        title: Text('新增客户'),
        actions: <Widget>[
          InkWell(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Center(
                child: Text(
                  '确定',
                  style: TextStyle(
                    fontSize: 15,
                    color: colorOrigin,
                  ),
                ),
              ),
            ),
            onTap: () {
              onConfirm();
            },
          )
        ],
      ),
      body: ListView(
        children: <Widget>[
          buildTitle('客户信息'),
          buildInputItem(
            spans: [
              TextSpan(
                text: '*',
                style: TextStyle(
                  fontSize: 15,
                  color: colorOrigin,
                ),
              ),
              TextSpan(
                text: '客户名称',
                style: TextStyle(fontSize: 15),
              ),
            ],
            hint: '请输入客户名称',
            content: bloc._clientName,
          ),
          buildClickableItem(
            spans: [
              TextSpan(
                text: '*',
                style: TextStyle(
                  fontSize: 15,
                  color: colorOrigin,
                ),
              ),
              TextSpan(
                text: '公司类型',
                style: TextStyle(fontSize: 15),
              ),
            ],
            hint: '请选择公司类型',
            content: bloc._company,
            onClick: () async {
              var company = await showDialog(
                context: context,
                builder: (context) {
                  return RadioListPage.companyType(
                    groupValue: bloc._company.value,
                  );
                },
              );
              if (company != null) {
                bloc._company.value = company;
              }
            },
          ),
          buildClickableItem(
            spans: [
              TextSpan(
                text: '*',
                style: TextStyle(
                  fontSize: 15,
                  color: colorOrigin,
                ),
              ),
              TextSpan(
                text: '所属行业',
                style: TextStyle(fontSize: 15),
              ),
            ],
            hint: '请选择所属行业',
            content: bloc._industry,
            onClick: () async {
              var industry = await showDialog(
                context: context,
                builder: (context) {
                  return RadioListPage.industry(
                    groupValue: bloc._industry.value,
                  );
                },
              );
              if (industry != null) {
                bloc._industry.value = industry;
              }
            },
          ),
          buildClickableItem(
            spans: [
              TextSpan(
                text: '*',
                style: TextStyle(
                  fontSize: 15,
                  color: colorOrigin,
                ),
              ),
              TextSpan(
                text: '所在地',
                style: TextStyle(fontSize: 15),
              ),
            ],
            hint: '请选择所在地',
            content: bloc._location,
            onClick: () async {
              var location = await showDialog(
                context: context,
                builder: (context) {
                  return RadioListPage.location(
                    groupValue: bloc._location.value,
                  );
                },
              );
              if (location != null) {
                bloc._location.value = location;
              }
            },
          ),
          buildClickableItem(
            spans: [
              TextSpan(
                text: '*',
                style: TextStyle(
                  fontSize: 15,
                  color: colorOrigin,
                ),
              ),
              TextSpan(
                text: '所在地',
                style: TextStyle(fontSize: 15),
              ),
            ],
            hint: '请选择来源类型',
            content: bloc._source,
            onClick: () async {
              var location = await showDialog(
                context: context,
                builder: (context) {
                  return RadioListPage.sourceType(
                    groupValue: bloc._source.value,
                  );
                },
              );
              if (location != null) {
                bloc._source.value = location;
              }
            },
          ),
          buildInputItem(
            spans: [
              TextSpan(
                text: '*',
                style: TextStyle(
                  fontSize: 15,
                  color: colorOrigin,
                ),
              ),
              TextSpan(
                text: '年发票量',
                style: TextStyle(fontSize: 15),
              ),
            ],
            hint: '请输入年发票量',
            content: bloc._invoiceCount,
          ),
          buildClickableItem(
            label: '是否为重点',
            hint: '请选择是否为重点',
            content: bloc._isImportant,
            onClick: () async {
              var result = await showDialog(
                context: context,
                builder: (context) {
                  return RadioListPage.boolean(
                    groupValue: bloc._isImportant.value,
                  );
                },
              );
              if (result != null) {
                bloc._isImportant.value = result;
              }
            },
          ),
          buildClickableItem(
            label: '是否二次开发',
            hint: '请选择是否二次开发',
            content: bloc._secondaryDevelopment,
            onClick: () async {
              var result = await showDialog(
                context: context,
                builder: (context) {
                  return RadioListPage.boolean(
                    groupValue: bloc._secondaryDevelopment.value,
                  );
                },
              );
              if (result != null) {
                bloc._secondaryDevelopment.value = result;
              }
            },
          ),
          buildClickableItem(
            label: '执行比例',
            hint: '请选择执行比例',
            content: bloc._progress,
            onClick: () async {
              var result = await showDialog(
                context: context,
                builder: (context) {
                  return RadioListPage.progress(
                    groupValue: bloc._progress.value,
                  );
                },
              );
              if (result != null) {
                bloc._progress.value = result;
              }
            },
          ),
          buildInputItem(
              label: '预计签约额',
              hint: '请输入预计签约额',
              content: bloc._expectedContractAmount),
          buildClickableItem(
              label: '预计签约日',
              hint: '请选择预计签约日',
              content: bloc._expectedSignDate,
              onClick: () async {
                var date = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(DateTime.now().year - 1),
                  lastDate: DateTime(DateTime.now().year + 1, 12, 31),
                );
                if (date != null) {
                  bloc._expectedSignDate.value =
                      DateFormat('yyyy-MM-dd').format(date);
                }
              }),
          buildInputItem(
            label: '公司规模',
            hint: '请输入公司规模',
            content: bloc._lnsize,
          ),
          buildInputItem(
            label: '公司简介',
            hint: '请输入公司简介',
            content: bloc._companyIntro,
          ),
          buildTitle('联系人信息'),
          buildInputItem(
              spans: [
                TextSpan(
                  text: '*',
                  style: TextStyle(
                    fontSize: 15,
                    color: colorOrigin,
                  ),
                ),
                TextSpan(
                  text: '甲方负责人',
                  style: TextStyle(fontSize: 15),
                ),
              ],
              hint: '请输入甲方负责人姓名',
              content: bloc._firstPartyRepresentatives),
          buildInputItem(
            spans: [
              TextSpan(
                text: '*',
                style: TextStyle(
                  fontSize: 15,
                  color: colorOrigin,
                ),
              ),
              TextSpan(
                text: '联系方式',
                style: TextStyle(fontSize: 15),
              ),
            ],
            hint: '请输入联系方式',
            content: bloc._contactWay,
          ),
          buildInputItem(
            label: '邮箱',
            hint: '请输入邮箱',
            content: bloc._email,
          ),
          buildInputItem(
            spans: [
              TextSpan(
                text: '*',
                style: TextStyle(
                  fontSize: 15,
                  color: colorOrigin,
                ),
              ),
              TextSpan(
                text: '职务',
                style: TextStyle(fontSize: 15),
              ),
            ],
            hint: '请输入职务',
            content: bloc._title,
          ),
        ],
      ),
    );
  }

  void onConfirm() async {

    if (bloc._clientName.isEmpty) {
      bloc.showTip('请输入客户名称');
      return;
    }
    if (bloc._company.value == null) {
      bloc.showTip('请选择公司类型');
      return;
    }
    if (bloc._industry.value== null) {
      bloc.showTip('请选择所属行业');
      return;
    }
    if (bloc._source.value== null) {
      bloc.showTip('请选择来源类型');
      return;
    }
    if (bloc._location.value== null) {
      bloc.showTip('请选择所在地');
      return;
    }

    if (bloc._invoiceCount.isEmpty) {
      bloc.showTip('请输入年发票量');
      return;
    }

    if (bloc._email != null &&
        bloc._email.isNotEmpty &&
        !EmailValidator.validate(bloc._email.toString())) {
      bloc.showTip('邮箱格式不正确');
      return;
    }
    if (bloc._firstPartyRepresentatives == null || bloc._firstPartyRepresentatives.isEmpty) {
      bloc.showTip('请输入甲方联系人');
      return;
    }

    if (bloc._contactWay == null || bloc._contactWay.isEmpty) {
      bloc.showTip('请输入联系方式');
      return;
    }
    if (bloc._title == null ||bloc. _title.isEmpty) {
      bloc.showTip('请输入职务');
      return;
    }
    onLoading(context);
    var rsp = await ApiService().newBusiness(
      bloc._clientName.toString(),
      bloc._company.value?.id?.toString()??'',
      bloc._industry.value?.id?.toString()??'',
      bloc._location.value?.id?.toString()??'',
      bloc._source.value?.id?.toString()??'',
      bloc._invoiceCount.toString(),
      bloc._isImportant.value?.id?.toString()??'',
      bloc._secondaryDevelopment.value?.id?.toString()??'',
      bloc._progress.value?.id?.toString()??'',
      bloc._expectedContractAmount.toString(),
      bloc._expectedSignDate.value.toString(),
      bloc._lnsize.toString(),
      bloc._companyIntro.toString(),
      bloc._firstPartyRepresentatives.toString(),
      bloc._contactWay.toString(),
      bloc._title.toString(),
      bloc._email.toString(),
      widget.type == typeTrace ? '2' : '5',
    );
    loadingFinish(context);
    if (rsp.code == ApiService.success) {
      Navigator.of(context).pop(true);
    }else{
      bloc.showTip(rsp.msg);
    }
  }
}

class NewClientBloc extends CommonBloc {
  var _clientName = StringBuffer();
  var _company = BehaviorSubject<RadioBean>();
  var _industry = BehaviorSubject<RadioBean>();
  var _source = BehaviorSubject<RadioBean>();
  var _location = BehaviorSubject<RadioBean>();
  var _invoiceCount = StringBuffer();
  var _isImportant = BehaviorSubject<RadioBean>();
  var _secondaryDevelopment = BehaviorSubject<RadioBean>();
  var _progress = BehaviorSubject<RadioBean>();
  var _expectedContractAmount = StringBuffer();
  var _expectedSignDate = BehaviorSubject();
  var _lnsize = StringBuffer();
  var _companyIntro = StringBuffer();
  var _firstPartyRepresentatives = StringBuffer();
  var _contactWay = StringBuffer();
  var _email = StringBuffer();
  var _title = StringBuffer();
}
