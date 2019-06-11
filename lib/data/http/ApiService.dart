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
import 'package:flutter_app/data/persistence/Persistence.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';

class ApiService {
  factory ApiService() {
    return _singleton;
  }

  ApiService._internal();

  static final ApiService _singleton = ApiService._internal();

//  static final String _baseUrl = "http://192.168.1.192:3000/op/api";
  static final String _baseUrl = "http://op.deallinker.com/op";
  static final int success = 0;
  static final int illicit = -1;

  var client = http.Client();

  Future<BaseRsp> login(String username, String password) async {
    Response rsp = await client.post(
      "$_baseUrl/app/login",
      body: {
        "username": username,
        "password": password,
      },
    );
    if (rsp.statusCode == 200) {
      return LoginRsp.fromJson(json.decode(rsp.body));
    } else {
      return BaseRsp(illicit, "网络异常，请稍后再试。");
    }
  }

  Future<BaseRsp> clientList(
    String page,
    String size,
    String keyword,
  ) async {
    Response rsp = await client.post(
      "$_baseUrl/app/fc/customer/list",
      headers: {"Authorization": "Bearer ${await Persistence().getToken()}"},
      body: {
        "page": page,
        "size": size,
        "keyword": keyword,
      },
    );
    print(rsp.body);
    if (rsp.statusCode == 200) {
      return ClientListRsp.fromJson(json.decode(rsp.body));
    } else {
      return BaseRsp(illicit, "网络异常，请稍后再试。");
    }
  }

  Future<BaseRsp> clientNeedList(
    String leadId,
  ) async {
    Response rsp = await client.post(
      "$_baseUrl/fc/leads/requirement/list",
      headers: {"Authorization": "Bearer ${await Persistence().getToken()}"},
      body: {
        "leads_id": leadId,
      },
    );
    print(rsp.body);
    if (rsp.statusCode == 200) {
      return ClientNeedListRsp.fromJson(json.decode(rsp.body));
    } else {
      return BaseRsp(illicit, "网络异常，请稍后再试。");
    }
  }

  Future<BaseRsp> newNeed(String leadId, String need) async {
    Response rsp =
        await client.post("$_baseUrl/fc/leads/requirement/add", headers: {
      "Authorization": "Bearer ${await Persistence().getToken()}"
    }, body: {
      "leads_id": leadId,
      "requirement": need,
    });
    print(rsp.body);
    if (rsp.statusCode == 200) {
      return BaseRsp.fromJson(json.decode(rsp.body));
    } else {
      return BaseRsp(illicit, "网络异常，请稍后再试。");
    }
  }

  Future<BaseRsp> visitLogs(
    String leadId,
  ) async {
    Response rsp = await client.post(
      "$_baseUrl/app/customer/visit/list",
      headers: {"Authorization": "Bearer ${await Persistence().getToken()}"},
      body: {
        "leads_id": leadId,
      },
    );
    print(rsp.body);
    if (rsp.statusCode == 200) {
      return VisitLogsRsp.fromJson(json.decode(rsp.body));
    } else {
      return BaseRsp(illicit, "网络异常，请稍后再试。");
    }
  }

  Future<BaseRsp> newVisitLog(
    String leadId,
    String visitWay, {
    String date = "",
    String clientRsp = "",
    String solution = "",
    String cost = "",
    String visitTargetPeople = "",
    String visitTarget = "",
  }) async {
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
  }

  Future<BaseRsp> clientSupports(
    String leadId,
  ) async {
    Response rsp = await client.post(
      "$_baseUrl/app/customer/application/list",
      headers: {"Authorization": "Bearer ${await Persistence().getToken()}"},
      body: {
        "leads_id": leadId,
      },
    );
    print(rsp.body);
    if (rsp.statusCode == 200) {
      return ClientSupportListRsp.fromJson(json.decode(rsp.body));
    } else {
      return BaseRsp(illicit, "网络异常，请稍后再试。");
    }
  }

  Future<BaseRsp> newSupport(
    String leadId,
    String supportType, {
    String account = "",
    String email = "",
    String password = "",
    String dateLimit = "",
    String function = "",
    String invoiceCount = "",
    String memo = "",
    String responsibility = "",
    String date = "",
    String projectProgress = "",
    String need = "",
    String deviceName = "",
    String usageModel = "",
    String count = "",
    String price = "",
    String memoDevice = "",
  }) async {
    Response rsp =
        await client.post("$_baseUrl/fc/customer/application/add", headers: {
      "Authorization": "Bearer ${await Persistence().getToken()}"
    }, body: {
      "leads_id": leadId,
      "application_type": supportType,
      "fc_admin_name": account,
      "email": email,
      "initial_password": password,
      "time_limit": dateLimit,
      "features": function,
      "check_amount": invoiceCount,
      "memo": memo,
      "responsibility": responsibility,
      "visit_time": date,
      "visit_progress": projectProgress,
      "requirements": need,
      "device_name": deviceName,
      "device_quantity": count,
      "price": price,
      "is_purchase": usageModel,
      "memo_device": memoDevice,
      "user": "8",
    });
    print(rsp.body);
    if (rsp.statusCode == 200) {
      return SourceTypesRsp.fromJson(json.decode(rsp.body));
    } else {
      return BaseRsp(illicit, "网络异常，请稍后再试。");
    }
  }

  Future<BaseRsp> operationLogs(
    String leadId,
  ) async {
    Response rsp = await client.post(
      "$_baseUrl/fc/leads/log/list",
      headers: {"Authorization": "Bearer ${await Persistence().getToken()}"},
      body: {
        "leads_id": leadId,
      },
    );
    print(rsp.body);
    if (rsp.statusCode == 200) {
      return OperationLogsRsp.fromJson(json.decode(rsp.body));
    } else {
      return BaseRsp(illicit, "网络异常，请稍后再试。");
    }
  }

  Future<SourceTypesRsp> sourceTypes() async {
    Response rsp = await client.get(
      "$_baseUrl/fc/source/list",
      headers: {"Authorization": "Bearer ${await Persistence().getToken()}"},
    );
    print(rsp.body);
    if (rsp.statusCode == 200) {
      return SourceTypesRsp.fromJson(json.decode(rsp.body));
    } else {
      return SourceTypesRsp.base(illicit, "网络异常，请稍后再试。");
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
    Response rsp = await client.post(
      "$_baseUrl${leadId == null ? "/fc/customer/add" : "/fc/customer/edit"}",
      headers: {"Authorization": "Bearer ${await Persistence().getToken()}"},
      body: {
        "leads_id": leadId.toString(),
        "leads_name": leadsName,
        "company_type": companyType.toString(),
        "industry": industry.toString(),
        "source_id": sourceId.toString(),
        "location": location.toString(),
        "annual_invoice": annualInvoice,
        "is_important": isImportant.toString(),
        "on_premise": onPremise.toString(),
        "progress_percent": progressPercent.toString(),
        "anticipated_amount": anticipatedAmount,
        "anticipated_date": anticipatedDate,
        "company_size": companySize,
        "memo": memo,
        "leads_contact": leadsContact,
        "leads_mobile": leadsMobile,
        "leads_email": leadsEmail,
        "job_title": jobTitle,
      },
    );
    print(rsp.body);
    if (rsp.statusCode == 200) {
      return BaseRsp.fromJson(json.decode(rsp.body));
    } else {
      return BaseRsp(illicit, "网络异常，请稍后再试。");
    }
  }

  Future<BaseRsp> getDailies(
    int page,
    int size,
  ) async {
    Response rsp = await client.post("$_baseUrl/app/fc/daily/list", headers: {
      "Authorization": "Bearer ${await Persistence().getToken()}"
    }, body: {
      "page": page.toString(),
      "size": size.toString(),
    });
    print(rsp.body);
    if (rsp.statusCode == 200) {
      return DailiesRsp.fromJson(json.decode(rsp.body));
    } else {
      return BaseRsp(illicit, "网络异常，请稍后再试。");
    }
  }

  Future<BaseRsp> newDaily(
    String date,
    String todayWorkContent,
    String todayVisitClient,
    String todaySolution,
    String tomorrowPlane,
    String tomorrowVisitClient,
  ) async {
    Response rsp = await client.post("$_baseUrl/app/fc/daily/add", headers: {
      "Authorization": "Bearer ${await Persistence().getToken()}"
    }, body: {
      "daily_time": date,
      "today_content": todayWorkContent,
      "today_customer_visit": todayVisitClient,
      "today_solution": todaySolution,
      "next_plan": tomorrowPlane,
      "next_customer_visit": tomorrowVisitClient,
    });
    print(rsp.body);
    if (rsp.statusCode == 200) {
      return BaseRsp.fromJson(json.decode(rsp.body));
    } else {
      return BaseRsp(illicit, "网络异常，请稍后再试。");
    }
  }
}
