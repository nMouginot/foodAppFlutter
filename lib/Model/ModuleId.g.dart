// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ModuleId.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ModuleId _$ModuleIdFromJson(Map<String, dynamic> json) => ModuleId(
      id: json['id'] as int? ?? -1,
      type: $enumDecodeNullable(_$ModuleTypeEnumMap, json['type']) ??
          ModuleType.indefini,
    );

Map<String, dynamic> _$ModuleIdToJson(ModuleId instance) => <String, dynamic>{
      'type': _$ModuleTypeEnumMap[instance.type],
      'id': instance.id,
    };

const _$ModuleTypeEnumMap = {
  ModuleType.indefini: 'indefini',
  ModuleType.quiz: 'quiz',
  ModuleType.cours: 'cours',
};
