// ignore_for_file: file_names
import "package:json_annotation/json_annotation.dart";
part "ModuleId.g.dart";

enum ModuleType { indefini, quiz, cours }

// Pour générer le fichier complémentaire => flutter pub run build_runner build
@JsonSerializable(explicitToJson: true)
class ModuleId {
  ModuleType type = ModuleType.indefini;
  int id = -1;

  ModuleId({this.id = -1, this.type = ModuleType.indefini});

  /// Connect the generated [_$ModuleIdFromJson] function to the `fromJson` factory.
  factory ModuleId.fromJson(Map<String, dynamic> json) =>
      _$ModuleIdFromJson(json);

  /// Connect the generated [_$ModuleIdToJson] function to the `toJson` method.
  Map<String, dynamic> toJson() => _$ModuleIdToJson(this);
}
