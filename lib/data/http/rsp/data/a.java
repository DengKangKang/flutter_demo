class SignLogData{

 /**
  * list : [{"contract_no":"DL-FY-20190628372","contract_amount":"0.00","contract_type":0,"received_amount":"0.00","files":[],"id":74,"contract_time":"2019-06-28 00:00:00","realname":"张家五"}]
  */
  java.util.List<ListEntity> list;
 

}

public class SignLog {
 /**
  * contract_no : DL-FY-20190628372
  * contract_amount : 0.00
  * contract_type : 0
  * received_amount : 0.00
  * files : []
  * id : 74
  * contract_time : 2019-06-28 00:00:00
  * realname : 张家五
  */
 String contract_no;
 String contract_amount;
 int contract_type;
 String received_amount;
 java.util.List<?> files;
 int id;
 String contract_time;
 String realname;

}