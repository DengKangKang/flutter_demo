import 'package:flutter/material.dart';
import 'package:flutter_app/data/Constant.dart';
import 'package:flutter_app/data/http/rsp/data/RadioBean.dart';

class RadioListPage<T extends RadioBean> extends StatefulWidget {
  List<T> _radioValues;
  RadioBean groupValue;

  RadioListPage(this._radioValues, {this.groupValue});

  RadioListPage.location({this.groupValue}) {
    this._radioValues = locations;
  }

  RadioListPage.industry({this.groupValue}) {
    this._radioValues = industries;
  }

  RadioListPage.sourceType({this.groupValue}) {
    this._radioValues = sourceTypes;
  }

  RadioListPage.title({this.groupValue}) {
    this._radioValues = titles;
  }

  RadioListPage.companyType({this.groupValue}) {
    this._radioValues = companyTypes;
  }

  RadioListPage.progress({this.groupValue}) {
    this._radioValues = progresses;
  }

  RadioListPage.visitWaysDaily({this.groupValue}) {
    this._radioValues = visitWaysDaily;
  }

  RadioListPage.supportTypes({this.groupValue}) {
    this._radioValues = supportTypes;
  }

  RadioListPage.projectProgresses({this.groupValue}) {
    this._radioValues = projectProgresses;
  }

  RadioListPage.responsibilities({this.groupValue}) {
    this._radioValues = responsibilities;
  }

  RadioListPage.usageModel({this.groupValue}) {
    this._radioValues = usageModel;
  }

  RadioListPage.boolean({this.groupValue}) {
    this._radioValues = booleans;
  }

  @override
  State<StatefulWidget> createState() {
    return new RadioListPageState(_radioValues, groupValue);
  }
}

class RadioListPageState<T extends RadioBean> extends State<StatefulWidget> {
  final List<T> _radioValues;

  final RadioBean _groupValue;

  RadioListPageState(this._radioValues, this._groupValue);

  @override
  Widget build(BuildContext context) {
    List<Widget> content = new List();
    _radioValues.forEach((value) {
      content.add(new RadioListTile(
        title: new Text(value.name),
        value: value,
        groupValue: _groupValue,
        onChanged: (i) {
          Navigator.of(context).pop(i);
        },
      ));
    });
    return new Dialog(
      child: new ListView.builder(
        physics: new BouncingScrollPhysics(),
        shrinkWrap: true,
        itemCount: content.length,
        itemBuilder: (context, i) {
          return content[i];
        },
      ),
    );
  }
}



final locations = [
  RadioBean(0, "请选择所在地"),
  RadioBean(1, "北京"),
  RadioBean(2, "天津"),
  RadioBean(3, "上海"),
  RadioBean(4, "重庆"),
  RadioBean(5, "河北"),
  RadioBean(6, "山西"),
  RadioBean(7, "辽宁"),
  RadioBean(8, "吉林"),
  RadioBean(9, "黑龙江"),
  RadioBean(10, "江苏"),
  RadioBean(11, "浙江"),
  RadioBean(12, "安徽"),
  RadioBean(13, "福建"),
  RadioBean(14, "江西"),
  RadioBean(15, "山东"),
  RadioBean(16, "河南"),
  RadioBean(17, "湖北"),
  RadioBean(18, "湖南"),
  RadioBean(19, "广东"),
  RadioBean(20, "海南"),
  RadioBean(21, "四川"),
  RadioBean(22, "贵州"),
  RadioBean(23, "云南"),
  RadioBean(24, "陕西"),
  RadioBean(25, "甘肃"),
  RadioBean(26, "青海"),
  RadioBean(27, "西藏"),
  RadioBean(28, "广西"),
  RadioBean(29, "内蒙古"),
  RadioBean(30, "宁夏"),
  RadioBean(31, "新疆"),
  RadioBean(32, "香港"),
  RadioBean(33, "澳门"),
  RadioBean(34, "台湾"),
];
final industries = [
  RadioBean(0, "请选择所属行业"),
  RadioBean(1, "农、林、牧、渔业 "),
  RadioBean(2, "采矿业"),
  RadioBean(3, "制造业"),
  RadioBean(4, "电力、热力、燃气及水生产和供应业"),
  RadioBean(5, "建筑业"),
  RadioBean(6, "批发和零售业"),
  RadioBean(7, "交通运输、仓储和邮政业"),
  RadioBean(8, "住宿和餐饮业"),
  RadioBean(9, "信息传输、软件和信息技术服务业"),
  RadioBean(10, "金融业"),
  RadioBean(11, "房地产业"),
  RadioBean(12, "租赁和商务服务业"),
  RadioBean(13, "科学研究和技术服务业"),
  RadioBean(14, "水利、环境和公共设施管理业"),
  RadioBean(15, "居民服务、修理和其他服务业"),
  RadioBean(16, "教育"),
  RadioBean(17, "卫生和社会工作"),
  RadioBean(18, "文化、体育和娱乐业"),
  RadioBean(19, "公共管理、社会保障和社会组织"),
  RadioBean(20, "国际组织")
];
final titles = [
  RadioBean(0, "请选择职务"),
  RadioBean(3, "市场主管"),
  RadioBean(4, "市场专员"),
  RadioBean(5, "客户成功部主管"),
  RadioBean(6, "客户成功部专员"),
  RadioBean(7, "销售主管"),
  RadioBean(8, "销售专员"),
  RadioBean(9, "售前主管"),
  RadioBean(10, "售前专员"),
  RadioBean(11, "实施主管"),
  RadioBean(12, "实施专员"),
  RadioBean(13, "售后主管"),
  RadioBean(14, "售后专员")
];
final companyTypes = [
  RadioBean(0, "请选择公司类型"),
  RadioBean(1, "有限责任公司"),
  RadioBean(2, "股份有限公司"),
  RadioBean(3, "国有企业"),
  RadioBean(4, "全民集体企业"),
  RadioBean(5, "合伙企业"),
  RadioBean(6, "个体工商户"),
  RadioBean(7, "政府机构"),
  RadioBean(8, "社会组织")
];

final progresses = [
  RadioBean(0, "请选择执行比例"),
  RadioBean(1, "10%项目立项"),
  RadioBean(2, "30%项目商务谈判"),
  RadioBean(3, "60%合同签署"),
  RadioBean(4, "80%项目收款"),
  RadioBean(5, "90%项目实施"),
  RadioBean(6, "100%项目完成"),
  RadioBean(7, "项目失败"),
];

final booleans = [
  RadioBean(0, "请选择"),
  RadioBean(2, "否"),
  RadioBean(1, "是"),
];

final visitWays = [
  RadioBean(0, "请选择拜访方式"),
  RadioBean(1, "面谈"),
  RadioBean(2, "微信"),
  RadioBean(3, "电话"),
  RadioBean(4, "QQ"),
  RadioBean(5, "邮件"),
  RadioBean(6, "其他"),
  RadioBean(BUSINESS_VISIT, "商务宴请"),
  RadioBean(PRESENT_VISIT, "赠送礼品"),
];

final visitWaysDaily  = [
  RadioBean(0, "请选择拜访方式"),
  RadioBean(1, "面谈"),
  RadioBean(2, "微信"),
  RadioBean(3, "电话"),
  RadioBean(4, "QQ"),
  RadioBean(5, "邮件"),
  RadioBean(6, "其他"),
];

final responsibilities = [
  RadioBean(0, "请选择对象职责"),
  RadioBean(1, "财务"),
  RadioBean(2, "信息部"),
  RadioBean(3, "企业高管"),
  RadioBean(4, "其他"),
];

final projectProgresses = [
  RadioBean(0, "请选择项目进度"),
  RadioBean(1, "首次拜访"),
  RadioBean(2, "与财务部沟通具体培训"),
  RadioBean(3, "费耘产品培训"),
  RadioBean(4, "渠道培训"),
];

final devices = [
  RadioBean(0, "请选择设备名称"),
  RadioBean(1, "Superlead"),
  RadioBean(2, "霍尼韦尔"),
  RadioBean(3, "德沃"),
  RadioBean(4, "扫描仪"),
];

final usageModel = [
  RadioBean(0, "请选择购买/押金"),
  RadioBean(1, "购买"),
  RadioBean(2, "押金"),
];


final supportTypes = [
  RadioBean(SUPPORT_TYPE_PRE_SALES, "售前支持"),
  RadioBean(SUPPORT_TYPE_HARDWARE, "硬件设备"),
  RadioBean(SUPPORT_TYPE_DEBUG_ACCOUNT, "测试账号"),
  RadioBean(SUPPORT_TYPE_RELEASE_ACCOUNT, "正式账号"),
];

final sourceTypes = new List<RadioBean>();