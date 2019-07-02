import 'package:email_validator/email_validator.dart';
import 'package:flutter_app/bloc/Bloc.dart';
import 'package:flutter_app/data/http/api_service.dart';
import 'package:flutter_app/data/http/rsp/data/ClientListData.dart';
import 'package:flutter_app/data/http/rsp/data/RadioBean.dart';
import 'package:flutter_app/page/RadioListPage.dart';

class ClientDetailBloc extends CommonBloc {
  ClientDetailBloc(Client client) {
    _id = client?.id;
    _clientName = client?.leads_name ?? "";

    _company = companyTypes.firstWhere(
      (e) => e.id == client?.company_type,
      orElse: () => companyTypes[0],
    );

    _industry = industries.firstWhere(
      (e) => e.id == client?.industry,
      orElse: () => industries[0],
    );

    _source = sourceTypes.firstWhere(
      (e) => e.id == client?.source_id,
      orElse: () => sourceTypes[0],
    );

    _location = locations.firstWhere(
      (e) => e.id == client?.location,
      orElse: () => locations[0],
    );

    _invoiceCount = client?.annual_invoice?.toString() ?? "";

    _startTarget = booleans.firstWhere(
      (e) => e.id == client?.is_important,
      orElse: () => booleans[0],
    );

    _secondaryDevelopment = booleans.firstWhere(
      (e) => e.id == client?.on_premise,
      orElse: () => booleans[0],
    );

    _progress = progresses.firstWhere(
      (e) => e.id == client?.progress_percent,
      orElse: () => progresses[0],
    );

    _expectedContractAmount = client?.anticipated_amount ?? "";

    _expectedSignDate = client?.anticipated_date ?? "";

    _lnsize = client?.company_size ?? "";

    _companyIntro = client?.memo ?? "";

    _firstPartyRepresentatives = client?.leads_contact ?? "";

    _contactWay = client?.leads_mobile ?? "";

    _email = client?.leads_email ?? "";

    _title = client?.job_title ?? "";
  }

  int _id;
  String _clientName;
  RadioBean _company;
  RadioBean _industry;
  RadioBean _source;
  RadioBean _location;
  String _invoiceCount;
  RadioBean _startTarget;
  RadioBean _secondaryDevelopment;
  RadioBean _progress;
  String _expectedContractAmount;
  String _expectedSignDate;
  String _lnsize;
  String _companyIntro;
  String _firstPartyRepresentatives;
  String _contactWay;
  String _email;
  String _title;

  void save() async {
    if (_clientName.isEmpty) {
      showTip('请输入客户名称');
      return;
    }
    if (_company.id == 0) {
      showTip('请选择公司类型');
      return;
    }
    if (_industry.id == 0) {
      showTip('请选择所属行业');
      return;
    }
    if (_source.id == 0) {
      showTip('请选择来源类型');
      return;
    }
    if (_location.id == 0) {
      showTip('请选择所在地');
      return;
    }

    if (_invoiceCount.isEmpty) {
      showTip('请输入年发票量');
      return;
    }

    if (_email != null &&
        _email.isNotEmpty &&
        !EmailValidator.validate(_email)) {
      showTip('邮箱格式不正确');
      return;
    }

    if (_contactWay == null || _contactWay.isEmpty) {
      showTip('请输入联系方式');
      return;
    }
    if (_title == null || _title.isEmpty) {
      showTip('请输入职务');
      return;
    }
    pageLoading();
    var rsp = await ApiService().newOrSaveClient(
      _id,
      _clientName,
      _company.id,
      _industry.id,
      _source.id,
      _location.id,
      _invoiceCount,
      _startTarget.id,
      _secondaryDevelopment.id,
      _progress.id,
      _expectedContractAmount,
      _expectedSignDate,
      _lnsize,
      _companyIntro,
      _firstPartyRepresentatives,
      _contactWay,
      _email,
      _title,
    );
    pageCompleted();
    if (rsp.code == ApiService.success) {
      finish(result: true);
    } else {
      showTip(rsp.msg);
    }
  }

  String get title => _title;

  set title(String value) {
    if (value != null) _title = value;
  }

  String get email => _email;

  set email(String value) {
    if (value != null) _email = value;
  }

  String get contactWay => _contactWay;

  set contactWay(String value) {
    if (value != null) _contactWay = value;
  }

  String get firstPartyRepresentatives => _firstPartyRepresentatives;

  set firstPartyRepresentatives(String value) {
    if (value != null) _firstPartyRepresentatives = value;
  }

  String get companyIntro => _companyIntro;

  set companyIntro(String value) {
    if (value != null) _companyIntro = value;
  }

  String get lnsize => _lnsize;

  set lnsize(String value) {
    if (value != null) _lnsize = value;
  }

  String get expectedSignDate => _expectedSignDate;

  set expectedSignDate(String value) {
    if (value != null) _expectedSignDate = value;
  }

  String get expectedContractAmount => _expectedContractAmount;

  set expectedContractAmount(String value) {
    if (value != null) _expectedContractAmount = value;
  }

  RadioBean get progress => _progress;

  set progress(RadioBean value) {
    if (value != null) _progress = value;
  }

  RadioBean get secondaryDevelopment => _secondaryDevelopment;

  set secondaryDevelopment(RadioBean value) {
    if (value != null) _secondaryDevelopment = value;
  }

  RadioBean get startTarget => _startTarget;

  set startTarget(RadioBean value) {
    if (value != null) _startTarget = value;
  }

  String get invoiceCount => _invoiceCount;

  set invoiceCount(String value) {
    if (value != null) _invoiceCount = value;
  }

  RadioBean get location => _location;

  set location(RadioBean value) {
    if (value != null) _location = value;
  }

  RadioBean get source => _source;

  set source(RadioBean value) {
    if (value != null) _source = value;
  }

  RadioBean get industry => _industry;

  set industry(RadioBean value) {
    if (value != null) _industry = value;
  }

  RadioBean get company => _company;

  set company(RadioBean value) {
    if (value != null) _company = value;
  }

  String get clientName => _clientName;

  set clientName(String value) {
    if (value != null) _clientName = value;
  }

  int get id => _id;

  set id(int value) {
    if (value != null) _id = value;
  }
}
