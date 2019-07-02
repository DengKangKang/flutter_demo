// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'applied_plugins_rsp.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AppliedPluginsRsp _$AppliedPluginsRspFromJson(Map<String, dynamic> json) {
  return AppliedPluginsRsp(
      json['code'],
      json['msg'],
      (json['data'] as List)
          ?.map((e) =>
              e == null ? null : Plugin.fromJson(e as Map<String, dynamic>))
          ?.toList());
}

Map<String, dynamic> _$AppliedPluginsRspToJson(AppliedPluginsRsp instance) =>
    <String, dynamic>{
      'code': instance.code,
      'msg': instance.msg,
      'data': instance.data
    };

Plugin _$PluginFromJson(Map<String, dynamic> json) {
  return Plugin(
      json['plugin_id'] as int,
      json['name'] as String,
      json['branch_limit'] as int,
      json['expiration_date'] as String,
      json['create_time'] as String,
      (json['quota'] as List)
          ?.map((e) =>
              e == null ? null : Quota.fromJson(e as Map<String, dynamic>))
          ?.toList())
    ..ocrSonPlugins = (json['ocrSonPlugins'] as List)
        ?.map((e) =>
            e == null ? null : Plugin.fromJson(e as Map<String, dynamic>))
        ?.toList()
    ..invoicePlugins = (json['invoicePlugins'] as List)
        ?.map((e) =>
            e == null ? null : Plugin.fromJson(e as Map<String, dynamic>))
        ?.toList();
}

Map<String, dynamic> _$PluginToJson(Plugin instance) => <String, dynamic>{
      'branch_limit': instance.branch_limit,
      'plugin_id': instance.id,
      'expiration_date': instance.expiration_date,
      'create_time': instance.create_time,
      'name': instance.name,
      'quota': instance.quota,
      'ocrSonPlugins': instance.ocrSonPlugins,
      'invoicePlugins': instance.invoicePlugins
    };

Quota _$QuotaFromJson(Map<String, dynamic> json) {
  return Quota(json['category'] as int, json['quota'] as int);
}

Map<String, dynamic> _$QuotaToJson(Quota instance) =>
    <String, dynamic>{'category': instance.category, 'quota': instance.quota};
