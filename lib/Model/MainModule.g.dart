// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'MainModule.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MainModule _$MainModuleFromJson(Map<String, dynamic> json) => MainModule(
      id: json['id'] as int,
      name: json['name'] as String,
      modulesId: (json['modulesId'] as List<dynamic>)
          .map((e) => ModuleId.fromJson(e as Map<String, dynamic>))
          .toList(),
      definition: json['definition'] as String? ?? "",
    )
      ..tags = json['tags'] as String
      ..lastUpdate = DateTime.parse(json['lastUpdate'] as String);

Map<String, dynamic> _$MainModuleToJson(MainModule instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'definition': instance.definition,
      'tags': instance.tags,
      'modulesId': instance.modulesId.map((e) => e.toJson()).toList(),
      'lastUpdate': instance.lastUpdate.toIso8601String(),
    };
