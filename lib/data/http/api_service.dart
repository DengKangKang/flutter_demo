import 'dart:async';
import 'dart:convert';

import 'package:flutter_app/data/http/rsp/BaseRsp.dart';
import 'package:flutter_app/data/http/rsp/ClientListRsp.dart';
import 'package:flutter_app/data/http/rsp/ClientNeedListRsp.dart';
import 'package:flutter_app/data/http/rsp/ClientSupportListRsp.dart';
import 'package:flutter_app/data/http/rsp/LoginRsp.dart';
import 'package:flutter_app/data/http/rsp/OperationLogsRsp.dart';
import 'package:flutter_app/data/http/rsp/SourceTypesRsp.dart';
import 'package:flutter_app/data/http/rsp/VisitLogsRsp.dart';
import 'package:flutter_app/data/http/rsp/DailiesRsp.dart';
import 'package:flutter_app/data/http/rsp/account_info.dart';
import 'package:flutter_app/data/http/rsp/applied_plugins_rsp.dart';
import 'package:flutter_app/data/http/rsp/apply_info.dart';
import 'package:flutter_app/data/http/rsp/clients_rsp.dart';
import 'package:flutter_app/data/http/rsp/client_info.dart';
import 'package:flutter_app/data/http/rsp/count_use.dart';
import 'package:flutter_app/data/http/rsp/department_info.dart';
import 'package:flutter_app/data/http/rsp/home_rsp.dart';
import 'package:flutter_app/data/http/rsp/sign_log_rsp.dart';
import 'package:flutter_app/data/persistence/Persistence.dart';
import 'package:flutter_app/page/clientdetails/apply_account/client_apply_debug_account_page.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';

const defaultLoadSize = '10';
const yes = 1;
const no = 2;

class ApiService {
  factory ApiService() {
    return _singleton;
  }

  ApiService._internal();

  static final ApiService _singleton = ApiService._internal();

  static final String _baseUrl = 'http://192.168.1.241:3000/op/api';
  static final String _authority = '192.168.1.241:3000';
  static final String _basePath = '/op/api';

//  static final String _baseUrl = 'http://op.deallinker.com/op';
  static final int success = 0;
  static final int illicit = -1;

  var client = http.Client();

  Future<BaseRsp> login(String username, String password) async {
    try {
      Response rsp = await client.post(
        '$_baseUrl/app/login',
        body: {
          'username': username,
          'password': password,
        },
      );
      print(rsp.body);
      if (rsp.statusCode == 200) {
        return LoginRsp.fromJson(json.decode(rsp.body));
      } else {
        return BaseRsp(illicit, '网络异常，请稍后再试。');
      }
    } catch (e) {
      return BaseRsp(illicit, '网络异常，请稍后再试。');
    }
  }

  Future<BaseRsp> clientList(
    String page,
    String size,
    String keyword,
  ) async {
    try {
      Response rsp = await client.post(
        '$_baseUrl/app/fc/customer/list',
        headers: {'Authorization': 'Bearer ${await Persistence().getToken()}'},
        body: {
          'page': page,
          'size': size,
          'keyword': keyword,
        },
      );
      print(rsp.body);
      if (rsp.statusCode == 200) {
        return ClientListRsp.fromJson(json.decode(rsp.body));
      } else {
        return BaseRsp(illicit, '网络异常，请稍后再试。');
      }
    } catch (e) {
      return BaseRsp(illicit, '网络异常，请稍后再试。');
    }
  }

  Future<BaseRsp> clientNeedList(
    String leadId,
  ) async {
    try {
      Response rsp = await client.post(
        '$_baseUrl/fc/leads/requirement/list',
        headers: {'Authorization': 'Bearer ${await Persistence().getToken()}'},
        body: {
          'leads_id': leadId,
        },
      );
      print(rsp.body);
      if (rsp.statusCode == 200) {
        return ClientNeedListRsp.fromJson(json.decode(rsp.body));
      } else {
        return BaseRsp(illicit, '网络异常，请稍后再试。');
      }
    } catch (e) {
      return BaseRsp(illicit, '网络异常，请稍后再试。');
    }
  }

  Future<BaseRsp> newNeed(String leadId, String need) async {
    try {
      Response rsp =
          await client.post('$_baseUrl/fc/leads/requirement/add', headers: {
        'Authorization': 'Bearer ${await Persistence().getToken()}'
      }, body: {
        'leads_id': leadId,
        'requirement': need,
      });
      print(rsp.body);
      if (rsp.statusCode == 200) {
        return BaseRsp.fromJson(json.decode(rsp.body));
      } else {
        return BaseRsp(illicit, '网络异常，请稍后再试。');
      }
    } catch (e) {
      return BaseRsp(illicit, '网络异常，请稍后再试。');
    }
  }

  Future<VisitLogsRsp> visitLogs(
    String leadId,
  ) async {
    try {
      var uri = Uri.http(
        _authority,
        _basePath + '/fc/leads/visit/list',
        {'leads_id': leadId},
      );

      Response rsp = await client.get(
        uri,
        headers: {'Authorization': 'Bearer ${await Persistence().getToken()}'},
      );
      print(rsp.body);
      if (rsp.statusCode == 200) {
        return VisitLogsRsp.fromJson(json.decode(rsp.body));
      } else {
        return VisitLogsRsp.base(illicit, '网络异常，请稍后再试。');
      }
    } catch (e) {
      print(e);
      return VisitLogsRsp.base(illicit, '网络异常，请稍后再试。');
    }
  }

  Future<BaseRsp> newVisitLog(
    String leadId,
    String visitWay, {
    String date = '',
    String clientRsp = '',
    String solution = '',
    String cost = '',
    String visitTargetPeople = '',
    String visitTarget = '',
  }) async {
    try {
      Response rsp =
          await client.post("$_baseUrl/app/customer/add/visit", headers: {
        "Authorization": "Bearer ${await Persistence().getToken()}"
      }, body: {
        "leads_id": leadId,
        "sale_visit_form": visitWay,
        "sale_visit_time": date,
        "sale_feedback": clientRsp,
        "sale_solution": solution,
        "expense": cost,
        "visitor": visitTargetPeople,
        "visit_goal": visitTarget,
      });
      print(rsp.body);
      if (rsp.statusCode == 200) {
        return SourceTypesRsp.fromJson(json.decode(rsp.body));
      } else {
        return BaseRsp(illicit, "网络异常，请稍后再试。");
      }
    } catch (e) {
      print(e);
      return BaseRsp(illicit, '网络异常，请稍后再试。');
    }
  }

  Future<BaseRsp> clientSupports(
    String leadId,
  ) async {
    try {
      Response rsp = await client.post(
        '$_baseUrl/app/customer/application/list',
        headers: {'Authorization': 'Bearer ${await Persistence().getToken()}'},
        body: {
          'leads_id': leadId,
        },
      );
      print(rsp.body);
      if (rsp.statusCode == 200) {
        return ClientSupportListRsp.fromJson(json.decode(rsp.body));
      } else {
        return BaseRsp(illicit, '网络异常，请稍后再试。');
      }
    } catch (e) {
      return BaseRsp(illicit, '网络异常，请稍后再试。');
    }
  }

  Future<BaseRsp> newSupport(
    String leadId,
    String supportType, {
    String account = '',
    String email = '',
    String password = '',
    String dateLimit = '',
    String function = '',
    String invoiceCount = '',
    String memo = '',
    String responsibility = '',
    String date = '',
    String projectProgress = '',
    String need = '',
    String deviceName = '',
    String usageModel = '',
    String count = '',
    String price = '',
    String memoDevice = '',
  }) async {
    try {
      Response rsp =
          await client.post('$_baseUrl/fc/customer/application/add', headers: {
        'Authorization': 'Bearer ${await Persistence().getToken()}'
      }, body: {
        'leads_id': leadId,
        'application_type': supportType,
        'fc_admin_name': account,
        'email': email,
        'initial_password': password,
        'time_limit': dateLimit,
        'features': function,
        'check_amount': invoiceCount,
        'memo': memo,
        'responsibility': responsibility,
        'visit_time': date,
        'visit_progress': projectProgress,
        'requirements': need,
        'device_name': deviceName,
        'device_quantity': count,
        'price': price,
        'is_purchase': usageModel,
        'memo_device': memoDevice,
        'user': '8',
      });
      print(rsp.body);
      if (rsp.statusCode == 200) {
        return SourceTypesRsp.fromJson(json.decode(rsp.body));
      } else {
        return BaseRsp(illicit, '网络异常，请稍后再试。');
      }
    } catch (e) {
      return BaseRsp(illicit, '网络异常，请稍后再试。');
    }
  }

  Future<BaseRsp> operationLogs(
    String leadId,
  ) async {
    try {
      Response rsp = await client.post(
        '$_baseUrl/fc/leads/log/list',
        headers: {'Authorization': 'Bearer ${await Persistence().getToken()}'},
        body: {
          'leads_id': leadId,
        },
      );
      print(rsp.body);
      if (rsp.statusCode == 200) {
        return OperationLogsRsp.fromJson(json.decode(rsp.body));
      } else {
        return BaseRsp(illicit, '网络异常，请稍后再试。');
      }
    } catch (e) {
      return BaseRsp(illicit, '网络异常，请稍后再试。');
    }
  }

  Future<SourceTypesRsp> sourceTypes() async {
    try {
      Response rsp = await client.get(
        '$_baseUrl/fc/source/list',
        headers: {'Authorization': 'Bearer ${await Persistence().getToken()}'},
      );
      print(rsp.body);
      if (rsp.statusCode == 200) {
        return SourceTypesRsp.fromJson(json.decode(rsp.body));
      } else {
        return SourceTypesRsp.base(illicit, '网络异常，请稍后再试。');
      }
    } catch (e) {
      return SourceTypesRsp.base(illicit, '网络异常，请稍后再试。');
    }
  }

  Future<BaseRsp> newOrSaveClient(
    int leadId,
    String leadsName,
    int companyType,
    int industry,
    int sourceId,
    int location,
    String annualInvoice,
    int isImportant,
    int onPremise,
    int progressPercent,
    String anticipatedAmount,
    String anticipatedDate,
    String companySize,
    String memo,
    String leadsContact,
    String leadsMobile,
    String leadsEmail,
    String jobTitle,
  ) async {
    try {
      Response rsp = await client.post(
        '$_baseUrl${leadId == null ? '/fc/customer/add' : '/fc/customer/edit'}',
        headers: {'Authorization': 'Bearer ${await Persistence().getToken()}'},
        body: {
          'leads_id': leadId.toString(),
          'leads_name': leadsName,
          'company_type': companyType.toString(),
          'industry': industry.toString(),
          'source_id': sourceId.toString(),
          'location': location.toString(),
          'annual_invoice': annualInvoice,
          'is_important': isImportant.toString(),
          'on_premise': onPremise.toString(),
          'progress_percent': progressPercent.toString(),
          'anticipated_amount': anticipatedAmount,
          'anticipated_date': anticipatedDate,
          'company_size': companySize,
          'memo': memo,
          'leads_contact': leadsContact,
          'leads_mobile': leadsMobile,
          'leads_email': leadsEmail,
          'job_title': jobTitle,
        },
      );
      print(rsp.body);
      if (rsp.statusCode == 200) {
        return BaseRsp.fromJson(json.decode(rsp.body));
      } else {
        return BaseRsp(illicit, '网络异常，请稍后再试。');
      }
    } catch (e) {
      return BaseRsp(illicit, '网络异常，请稍后再试。');
    }
  }

  Future<BaseRsp> getDailies(
    int page,
    int size,
    String daily_time,
    String key,
    String sale_name,
  ) async {
    try {
      Response rsp = await client.post('$_baseUrl/app/fc/daily/list', headers: {
        'Authorization': 'Bearer ${await Persistence().getToken()}'
      }, body: {
        'page': page.toString(),
        'size': size.toString(),
        'daily_time': daily_time,
        'key': key,
        'sale_name': sale_name,
      });
      print(rsp.body);
      if (rsp.statusCode == 200) {
        return DailiesRsp.fromJson(json.decode(rsp.body));
      } else {
        return BaseRsp(illicit, '网络异常，请稍后再试。');
      }
    } catch (e) {
      print(e);
      return BaseRsp(illicit, '网络异常，请稍后再试。');
    }
  }

  Future<BaseRsp> newDaily(
    String date,
    String todayWorkContent,
    String todayVisitClient,
    String todaySolution,
    String tomorrowPlane,
    String tomorrowVisitClient,
    String morn_type,
    String morn_content,
    String afternoon_type,
    String afternoon_content,
  ) async {
    try {
      Response rsp = await client.post('$_baseUrl/app/fc/daily/add', headers: {
        'Authorization': 'Bearer ${await Persistence().getToken()}'
      }, body: {
        'daily_time': date,
        'today_content': todayWorkContent,
        'today_customer_visit': todayVisitClient,
        'today_solution': todaySolution,
        'next_plan': tomorrowPlane,
        'next_customer_visit': tomorrowVisitClient,
        'morn_type': morn_type,
        'afternoon_type': afternoon_type,
        'morn_content': morn_content,
        'afternoon_content': afternoon_content,
      });
      print(rsp.body);
      if (rsp.statusCode == 200) {
        return BaseRsp.fromJson(json.decode(rsp.body));
      } else {
        return BaseRsp(illicit, '网络异常，请稍后再试。');
      }
    } catch (e) {
      return BaseRsp(illicit, '网络异常，请稍后再试。');
    }
  }

  Future<HomeRsp> home() async {
    Response rsp = await client.get(
      '$_baseUrl/app/fc/home/list',
      headers: {'Authorization': 'Bearer ${await Persistence().getToken()}'},
    );
    print(rsp.body);
    if (rsp.statusCode == 200) {
      return HomeRsp.fromJson(json.decode(rsp.body));
    } else {
      return HomeRsp.base(illicit, '网络异常，请稍后再试。');
    }
  }

  Future<HomeRsp> role() async {
    try {
      Response rsp = await client.get(
        '$_baseUrl/user/roles ',
        headers: {'Authorization': 'Bearer ${await Persistence().getToken()}'},
      );
      print(rsp.body);
      if (rsp.statusCode == 200) {
        return HomeRsp.fromJson(json.decode(rsp.body));
      } else {
        return HomeRsp.base(illicit, '网络异常，请稍后再试。');
      }
    } catch (e) {
      return HomeRsp.base(illicit, '网络异常，请稍后再试。');
    }
  }

  Future<ClientsRsp> clients({
    is_public,
    annual_invoice, //年发票量 最小值，最大值
    anticipated_amount, //预计签约金额
    anticipated_month, //预计签约月份
    application_type, //测试账号
    company_type, //公司类型
    contract_amount, //合同金额
    contract_ct, //合同签约日期
    creator, //创建人
    id,
    industry, //所属行业
    is_important, //是否重点
    key, //组长key='1'、组员key='2'
    leads_contact,
    leads_mobile,
    leads_name,
    location,
    on_premise, //二次开发
    progress_percent, //执行比例
    received_payment, //回款总额  最小值，最大值
    sale_name, //销售经理
    source_id, //来源类型
    state,
    user,
    time_area,
    page = '1',
    size = defaultLoadSize,
  }) async {
    try {
      var uri = Uri.http(
        _authority,
        _basePath + '/fc/sale/customer/list',
        {
          'annual_invoice': annual_invoice, //年发票量 最小值，最大值1,2
          'anticipated_amount': anticipated_amount, //预计签约金额
          'anticipated_month': anticipated_month, //预计签约月份
          'application_type': application_type, //测试账号
          'company_type': company_type, //公司类型
          'contract_amount': contract_amount, //合同金额
          'contract_ct': contract_ct, //合同签约日期
          'creator': creator, //创建人
          'id': id,
          'industry': industry, //所属行业
          'is_important': is_important, //是否重点
          'key': key, //组长key='1'、组员key='2'
          'leads_contact': leads_contact,
          'leads_mobile': leads_mobile,
          'leads_name': leads_name,
          'location': location,
          'on_premise': on_premise, //二次开发
          'page': page,
          'progress_percent': progress_percent, //执行比例
          'received_payment': received_payment, //回款总额  最小值，最大值
          'sale_name': sale_name, //销售经理
          'size': size,
          'source_id': source_id, //来源类型
          'state': state,
          'user': user,
          'is_public': is_public,
          'time_area': time_area,
        },
      );
      Response rsp = await client.get(
        uri,
        headers: {'Authorization': 'Bearer ${await Persistence().getToken()}'},
      );
      print(rsp.body);
      if (rsp.statusCode == 200) {
        return ClientsRsp.fromJson(json.decode(rsp.body));
      } else {
        return ClientsRsp.base(illicit, '网络异常，请稍后再试。');
      }
    } catch (e) {
      return ClientsRsp.base(illicit, '网络异常，请稍后再试。');
    }
  }

  Future<ClientsRsp> trace({
    is_private,
    annual_invoice, //年发票量 最小值，最大值
    anticipated_amount, //预计签约金额
    anticipated_month, //预计签约月份
    application_type, //测试账号
    company_type, //公司类型
    contract_amount, //合同金额
    contract_ct, //合同签约日期,
    leads_mobile,
    creator, //创建人
    id,
    industry, //所属行业
    is_important, //是否重点
    key, //组长key='1'、组员key='2'
    leads_contact,
    leads_name,
    location,
    on_premise, //二次开发
    progress_percent, //执行比例
    received_payment, //回款总额  最小值，最大值
    sale_name, //销售经理
    source_id, //来源类型
    state = '1,2,3',
    user,
    time_area,
    page = '1',
    size = defaultLoadSize,
  }) async {
    var uri = Uri.http(
      _authority,
      _basePath + '/fc/sale/clue/list',
      {
        'annual_invoice': annual_invoice, //年发票量 最小值，最大值1,2
        'anticipated_amount': anticipated_amount, //预计签约金额
        'anticipated_month': anticipated_month, //预计签约月份
        'application_type': application_type, //测试账号
        'company_type': company_type, //公司类型
        'contract_amount': contract_amount, //合同金额
        'contract_ct': contract_ct, //合同签约日期
        'creator': creator, //创建人
        'id': id,
        'industry': industry, //所属行业
        'is_important': is_important, //是否重点
        'key': key, //组长key='1'、组员key='2'
        'leads_contact': leads_contact,
        'leads_mobile': leads_mobile,
        'leads_name': leads_name,
        'location': location,
        'on_premise': on_premise, //二次开发
        'page': page,
        'progress_percent': progress_percent, //执行比例
        'received_payment': received_payment, //回款总额  最小值，最大值
        'sale_name': sale_name, //销售经理
        'size': size,
        'source_id': source_id, //来源类型
        'state': state,
        'user': user,
        'is_private': is_private,
        'time_area': time_area,
      },
    );
    try {
      Response rsp = await client.get(
        uri,
        headers: {'Authorization': 'Bearer ${await Persistence().getToken()}'},
      );
      print(rsp.body);
      if (rsp.statusCode == 200) {
        return ClientsRsp.fromJson(json.decode(rsp.body));
      } else {
        return ClientsRsp.base(illicit, '网络异常，请稍后再试。');
      }
    } catch (e) {
      return ClientsRsp.base(illicit, '网络异常，请稍后再试。');
    }
  }

  Future<BaseRsp> releaseTrace(
    id,
  ) async {
    try {
      Response rsp =
          await client.post('$_baseUrl/fc/sale/cluestate/action', headers: {
        'Authorization': 'Bearer ${await Persistence().getToken()}'
      }, body: {
        'leads_id': id,
        'state': '2',
      });
      print(rsp.body);
      if (rsp.statusCode == 200) {
        return BaseRsp.fromJson(json.decode(rsp.body));
      } else {
        return BaseRsp(illicit, '网络异常，请稍后再试。');
      }
    } catch (e) {
      return BaseRsp(illicit, '网络异常，请稍后再试。');
    }
  }

  Future<BaseRsp> transformToClient(
    id,
  ) async {
    try {
      Response rsp =
          await client.post('$_baseUrl/fc/sale/cluestate/action', headers: {
        'Authorization': 'Bearer ${await Persistence().getToken()}'
      }, body: {
        'leads_id': id,
        'state': '1',
      });
      print(rsp.body);
      if (rsp.statusCode == 200) {
        return BaseRsp.fromJson(json.decode(rsp.body));
      } else {
        return BaseRsp(illicit, '网络异常，请稍后再试。');
      }
    } catch (e) {
      return BaseRsp(illicit, '网络异常，请稍后再试。');
    }
  }

  Future<BaseRsp> addToPrivateTrace(
    id,
  ) async {
    try {
      Response rsp =
          await client.post('$_baseUrl/fc/sale/cluestate/action', headers: {
        'Authorization': 'Bearer ${await Persistence().getToken()}'
      }, body: {
        'leads_id': id,
        'state': '3',
      });
      print(rsp.body);
      if (rsp.statusCode == 200) {
        return BaseRsp.fromJson(json.decode(rsp.body));
      } else {
        return BaseRsp(illicit, '网络异常，请稍后再试。');
      }
    } catch (e) {
      return BaseRsp(illicit, '网络异常，请稍后再试。');
    }
  }

  Future<BaseRsp> releaseClient(
    id,
  ) async {
    try {
      Response rsp =
          await client.post('$_baseUrl/fc/sale/customerstate/action', headers: {
        'Authorization': 'Bearer ${await Persistence().getToken()}'
      }, body: {
        'leads_id': id,
        'state': '1',
      });
      print(rsp.body);
      if (rsp.statusCode == 200) {
        return BaseRsp.fromJson(json.decode(rsp.body));
      } else {
        return BaseRsp(illicit, '网络异常，请稍后再试。');
      }
    } catch (e) {
      return BaseRsp(illicit, '网络异常，请稍后再试。');
    }
  }

  Future<BaseRsp> addToPrivateClient(
    id,
  ) async {
    try {
      Response rsp =
          await client.post('$_baseUrl/fc/sale/customerstate/action', headers: {
        'Authorization': 'Bearer ${await Persistence().getToken()}'
      }, body: {
        'leads_id': id,
        'state': '2',
      });
      print(rsp.body);
      if (rsp.statusCode == 200) {
        return BaseRsp.fromJson(json.decode(rsp.body));
      } else {
        return BaseRsp(illicit, '网络异常，请稍后再试。');
      }
    } catch (e) {
      return BaseRsp(illicit, '网络异常，请稍后再试。');
    }
  }

  Future<BaseRsp> signContract(
    id,
    contract_amount,
    contract_time,
    contract_type,
    leads_name,
    userid_sale,
  ) async {
    try {
      Response rsp = await client.post(
        '$_baseUrl/fc/customer/newsign',
        headers: {'Authorization': 'Bearer ${await Persistence().getToken()}'},
        body: {
          'contract_amount': contract_amount, //合同金额
          'contract_time': contract_time, // 签约时间
          'contract_type': contract_type, // 1：新签 2：续签
          'leads_id': id, //
          'leads_name': leads_name, // 角色
          'userid_sale': userid_sale,
          'user': '8',
        },
      );
      print(rsp.body);
      if (rsp.statusCode == 200) {
        return BaseRsp.fromJson(json.decode(rsp.body));
      } else {
        return BaseRsp(illicit, '网络异常，请稍后再试。');
      }
    } catch (e) {
      return BaseRsp(illicit, '网络异常，请稍后再试。');
    }
  }

  Future<BaseRsp> newBusiness(
    String leads_name,
    String company_type,
    String industry,
    String location,
    String source_id,
    String annual_invoice,
    String is_important,
    String on_premise,
    String progress_percent,
    String anticipated_amount,
    String anticipated_month,
    String company_size,
    String memo,
    String leads_contact,
    String leads_mobile,
    String job_title,
    String leads_email,
    String state,
  ) async {
    try {
      print({
        'leads_name': leads_name,
        'company_type': company_type, // int   公司类型
        'industry': industry, // int   行业
        'location': location, // int  所在地
        'source_id': source_id, //  int  来源
        'annual_invoice': annual_invoice, //int  年发票量
        'is_important': is_important, //int  重点 是：1 否：2
        'on_premise': on_premise, // int 二次开发 是：1 否：2
        'progress_percent': progress_percent, //int 项目进度
        'anticipated_amount': anticipated_amount, //预计签约金额
        'anticipated_month': anticipated_month, //
        'company_size': company_size, //规模   var
        'memo': memo, //简介   var
        'leads_contact': leads_contact, //负责人
        'leads_mobile': leads_mobile,
        'job_title': job_title,
        'leads_email': leads_email,
        'state': state,
      });
      Response rsp = await client.post(
        '$_baseUrl/app/fc/customer/addcustom',
        headers: {'Authorization': 'Bearer ${await Persistence().getToken()}'},
        body: {
          'leads_name': leads_name,
          'company_type': company_type, // int   公司类型
          'industry': industry, // int   行业
          'location': location, // int  所在地
          'source_id': source_id, //  int  来源
          'annual_invoice': annual_invoice, //int  年发票量
          'is_important': is_important, //int  重点 是：1 否：2
          'on_premise': on_premise, // int 二次开发 是：1 否：2
          'progress_percent': progress_percent, //int 项目进度
          'anticipated_amount': anticipated_amount, //预计签约金额
          'anticipated_month': anticipated_month, //
          'company_size': company_size, //规模   var
          'memo': memo, //简介   var
          'leads_contact': leads_contact, //负责人
          'leads_mobile': leads_mobile,
          'job_title': job_title,
          'leads_email': leads_email,
          'state': state,
        },
      );
      print(rsp.body);
      if (rsp.statusCode == 200) {
        return BaseRsp.fromJson(json.decode(rsp.body));
      } else {
        return BaseRsp(illicit, '网络异常，请稍后再试。');
      }
    } catch (e) {
      return BaseRsp(illicit, '网络异常，请稍后再试。');
    }
  }

  Future<SignLogRsp> signLogs(
    String leadId,
  ) async {
    try {
      var uri = Uri.http(
        _authority,
        _basePath + '/fc/customer/signlist',
        {'leads_id': leadId},
      );

      Response rsp = await client.get(
        uri,
        headers: {'Authorization': 'Bearer ${await Persistence().getToken()}'},
      );
      print(rsp.body);
      if (rsp.statusCode == 200) {
        return SignLogRsp.fromJson(json.decode(rsp.body));
      } else {
        return SignLogRsp.base(illicit, '网络异常，请稍后再试。');
      }
    } catch (e) {
      return SignLogRsp.base(illicit, '网络异常，请稍后再试。');
    }
  }

  Future<SourceTypesRsp> pluginList() async {
    try {
      var uri = Uri.http(
        _authority,
        _basePath + '/fc/company/plugin/select',
        {'company_id': '0'},
      );
      Response rsp = await client.get(
        uri,
        headers: {'Authorization': 'Bearer ${await Persistence().getToken()}'},
      );
      print(rsp.body);
      if (rsp.statusCode == 200) {
        return SourceTypesRsp.fromJson(json.decode(rsp.body));
      } else {
        return SourceTypesRsp.base(illicit, '网络异常，请稍后再试。');
      }
    } catch (e) {
      return SourceTypesRsp.base(illicit, '网络异常，请稍后再试。');
    }
  }

  Future<BaseRsp> addPlugin({
    application_type,
    branch_limit,
    company_id,
    end_time,
    plugin_id,
    start_time,
    radiovalue,
    allquota,
    quota_1,
    quota_2,
    quota_3,
  }) async {
    try {
      var uri = Uri.http(
        _authority,
        _basePath + '/fc/customer/plugin/add',
      );
      Response rsp = await client.post(uri, headers: {
        'Authorization': 'Bearer ${await Persistence().getToken()}'
      }, body: {
        'application_type': application_type, //测试：5 正式：6
        'branch_limit': branch_limit, //集团
        'company_id': company_id, //线索id
        'end_time': end_time,
        'plugin_id': plugin_id, //插件id
        'start_time': start_time,
        'type': '0',
        'radiovalue': radiovalue, // 1:分类识别   2： 识别录入
        'allquota': allquota, //票量    识别录入
        'quota_1': quota_1, //增值税发票
        'quota_2': quota_2, //其他发票量
        'quota_3': quota_3,
      });
      print(rsp.body);
      if (rsp.statusCode == 200) {
        return BaseRsp.fromJson(json.decode(rsp.body));
      } else {
        return BaseRsp(illicit, '网络异常，请稍后再试。');
      }
    } catch (e) {
      return BaseRsp(illicit, '网络异常，请稍后再试。');
    }
  }

  Future<BaseRsp> modifyPlugin({
    application_type,
    branch_limit,
    company_id,
    end_time,
    plugin_id,
    start_time,
    radiovalue,
    allquota,
    quota_1,
    quota_2,
    quota_3,
  }) async {
    try {
      var uri = Uri.http(
        _authority,
        _basePath + '/fc/customer/plugin/add',
      );
      Response rsp = await client.post(uri, headers: {
        'Authorization': 'Bearer ${await Persistence().getToken()}'
      }, body: {
        'application_type': application_type, //测试：5 正式：6
        'branch_limit': branch_limit, //集团
        'company_id': company_id, //线索id
        'end_time': end_time,
        'plugin_id': plugin_id, //插件id
        'start_time': start_time,
        'type': '1',
        'radiovalue': radiovalue, // 1:分类识别   2： 识别录入
        'allquota': allquota, //票量    识别录入
        'quota_1': quota_1, //增值税发票
        'quota_2': quota_2, //其他发票量
        'quota_3': quota_3,
      });
      print(rsp.body);
      if (rsp.statusCode == 200) {
        return BaseRsp.fromJson(json.decode(rsp.body));
      } else {
        return BaseRsp(illicit, '网络异常，请稍后再试。');
      }
    } catch (e) {
      return BaseRsp(illicit, '网络异常，请稍后再试。');
    }
  }

  Future<AppliedPluginsRsp> appliedPluginList({
    application_type,
    company_id,
  }) async {
    try {
      var uri = Uri.http(
        _authority,
        _basePath + '/fc/customer/plugin/detail',
        {
          'application_type': application_type, //测试：5 正式：6
          'company_id': company_id, //线索id
        },
      );
      Response rsp = await client.get(
        uri,
        headers: {'Authorization': 'Bearer ${await Persistence().getToken()}'},
      );
      print(rsp.body);
      if (rsp.statusCode == 200) {
        return AppliedPluginsRsp.fromJson(json.decode(rsp.body));
      } else {
        return AppliedPluginsRsp.base(illicit, '网络异常，请稍后再试。');
      }
    } catch (e) {
      return AppliedPluginsRsp.base(illicit, '网络异常，请稍后再试。');
    }
  }

  Future<BaseRsp> deletePlugin({
    leads_id,
    plugin_id,
    application_type,
  }) async {
    try {
      var uri = Uri.http(
        _authority,
        _basePath + '/fc/customer/plugin/del',
      );
      Response rsp = await client.post(
        uri,
        headers: {'Authorization': 'Bearer ${await Persistence().getToken()}'},
        body: {
          'leads_id': leads_id, //测试：5 正式：6
          'plugin_id': plugin_id, //线索id
          'application_type': application_type, //线索id
        },
      );
      print(plugin_id);
      print(rsp.body);
      if (rsp.statusCode == 200) {
        return BaseRsp.fromJson(json.decode(rsp.body));
      } else {
        return BaseRsp(illicit, '网络异常，请稍后再试。');
      }
    } catch (e) {
      return BaseRsp(illicit, '网络异常，请稍后再试。');
    }
  }

  Future<BaseRsp> apply({
    leads_id = '',
    application_type = '',
    check_amount = '',
    email = '',
    expire_time = '',
    fc_admin_name = '',
    initial_password = '',
    leads_name = '',
    memo = '',
    staff_limit = '',
    time_limit = '',
    requirements = '',
    train_place = '',
    visit_time = '',
    features = '',
  }) async {
    try {
      Response rsp = await client.post(
        '$_baseUrl/fc/customer/application/add',
        headers: {'Authorization': 'Bearer ${await Persistence().getToken()}'},
        body: {
          'application_type': application_type, //3：测试   4：正式
          'leads_id': leads_id, //
          'check_amount': check_amount, //查验发票量
          'email': email,
          'expire_time': expire_time,
          'fc_admin_name': fc_admin_name, //管理员姓名
          'initial_password': initial_password, //初始密码
          'leads_name': leads_name,
          'memo': memo, //备注
          'ocrtype': '0',
          'staff_limit': staff_limit, //人员限制
          'time_limit': time_limit, //票量失效日期
          'user': application_type == applyTypeTrain ? '7' : '8',
          'memo': memo, //备注
          'requirements': requirements, // 培训功能
          'train_place': train_place,
          'visit_time': visit_time,
          'features': features,
        },
      );
      print(rsp.body);
      if (rsp.statusCode == 200) {
        return BaseRsp.fromJson(json.decode(rsp.body));
      } else {
        return BaseRsp(illicit, '网络异常，请稍后再试。');
      }
    } catch (e) {
      print(e);
      return BaseRsp(illicit, '网络异常，请稍后再试。');
    }
  }

  Future<ApplyInfoRsp> applyInfo({
    leads_id,
  }) async {
    var uri = Uri.http(
      _authority,
      _basePath + '/app/customer/application/list',
    );
    try {
      Response rsp = await client.post(
        uri,
        headers: {'Authorization': 'Bearer ${await Persistence().getToken()}'},
        body: {
          'leads_id': leads_id,
        },
      );
      print(rsp.body);
      if (rsp.statusCode == 200) {
        return ApplyInfoRsp.fromJson(json.decode(rsp.body));
      } else {
        return ApplyInfoRsp.base(illicit, '网络异常，请稍后再试。');
      }
    } catch (e) {
      return ApplyInfoRsp.base(illicit, '网络异常，请稍后再试。');
    }
  }

  Future<AccountInfoRsp> accountInfo({
    application_type, //3测试   4正式
    leads_id,
  }) async {
    var uri = Uri.http(
      _authority,
      _basePath + '/fc/customer/application/list',
    );
    try {
      Response rsp = await client.post(
        uri,
        headers: {'Authorization': 'Bearer ${await Persistence().getToken()}'},
        body: {
          'application_type': application_type,
          'leads_id': leads_id,
        },
      );
      print(rsp.body);
      if (rsp.statusCode == 200) {
        return AccountInfoRsp.fromJson(json.decode(rsp.body));
      } else {
        return AccountInfoRsp.base(illicit, '网络异常，请稍后再试。');
      }
    } catch (e) {
      return AccountInfoRsp.base(illicit, '网络异常，请稍后再试。');
    }
  }

  Future<ClientInfoRsp> clientInfo({
    id,
  }) async {
    var uri = Uri.http(_authority, _basePath + '/fc/company', {'keyword': id});
    try {
      Response rsp = await client.get(
        uri,
        headers: {'Authorization': 'Bearer ${await Persistence().getToken()}'},
      );
      print(rsp.body);
      if (rsp.statusCode == 200) {
        return ClientInfoRsp.fromJson(json.decode(rsp.body));
      } else {
        return ClientInfoRsp.base(illicit, '网络异常，请稍后再试。');
      }
    } catch (e) {
      return ClientInfoRsp.base(illicit, '网络异常，请稍后再试。');
    }
  }

  Future<DepartmentInfo> department({
    id,
  }) async {
    var uri = Uri.http(
      _authority,
      _basePath + '/app/fc/company/deptUser',
      {'company_id': id},
    );
    try {
      Response rsp = await client.get(
        uri,
        headers: {'Authorization': 'Bearer ${await Persistence().getToken()}'},
      );
      print(rsp.body);
      if (rsp.statusCode == 200) {
        return DepartmentInfo.fromJson(json.decode(rsp.body));
      } else {
        return DepartmentInfo.base(illicit, '网络异常，请稍后再试。');
      }
    } catch (e) {
      return DepartmentInfo.base(illicit, '网络异常，请稍后再试。');
    }
  }

  Future<BaseRsp> modifyPassword({
    new_password,
    old_password,
  }) async {
    var uri = Uri.http(
      _authority,
      _basePath + '/user/changepassword',
    );
    try {
      Response rsp = await client.post(uri, headers: {
        'Authorization': 'Bearer ${await Persistence().getToken()}'
      }, body: {
        'new_password': new_password,
        'old_password': old_password,
      });
      print(rsp.body);
      if (rsp.statusCode == 200) {
        return BaseRsp.fromJson(json.decode(rsp.body));
      } else {
        return BaseRsp(illicit, '网络异常，请稍后再试。');
      }
    } catch (e) {
      return BaseRsp(illicit, '网络异常，请稍后再试。');
    }
  }

  Future<CountUseRsp> countUseInfo(
    String page,
    String size,
    String company_id,
  ) async {
    try {
//    /app/fc/company/clientQuota
      var uri = Uri.http(
        _authority,
        _basePath + '/app/fc/company/clientQuota',
        {
          'page': page,
          'size': size,
          'company_id': company_id,
        },
      );
      Response rsp = await client.get(
        uri,
        headers: {'Authorization': 'Bearer ${await Persistence().getToken()}'},
      );
      print(rsp.body);
      if (rsp.statusCode == 200) {
        return CountUseRsp.fromJson(json.decode(rsp.body));
      } else {
        return CountUseRsp.base(illicit, '网络异常，请稍后再试。');
      }
    } catch (e) {
      return CountUseRsp.base(illicit, '网络异常，请稍后再试。');
    }
  }
}
