// ignore_for_file: file_names
import 'dart:math';

import "package:json_annotation/json_annotation.dart";

import 'ModuleId.dart';
part "MainModule.g.dart";

// Classe qui doit manager le stockage local des résultats des quiz d'entrainements.
// Pour générer le fichier complémentaire => flutter pub run build_runner build
@JsonSerializable(explicitToJson: true)
class MainModule {
  /// Identifiant unique du mainModule
  late final int id;

  /// Nom du mainModule
  late String name;

  /// Définition textuel du mainModule
  late String definition;

  /// Liste des tags du mainModule, permet de faire des recherches par tags. Splitter = \\
  late String tags;

  /// Liste des id des modules de ce mainModule. (La partie string permet de savoir quel type de module est indexé. (Quiz, cours...))
  late List<ModuleId> modulesId;

  /// Date de création du mainModule
  late final DateTime creationDate = DateTime.now();

  /// Dernière fois que l'utiliateur a utiliser un des modules de ce mainModule. (Utile pour les rappels si le module n'est pas terminé.)
  late DateTime lastUpdate = DateTime.now();

  /// Nombre de module à l'interieur de ce mainModule
  int get numberOfModule => modulesId.length;

  /// Valeur entre 0 et 100 qui indique le taux de completion du module
  late int completionOfTheMainModule;

  MainModule(
      {required this.id,
      required this.name,
      required this.modulesId,
      this.definition = ""}) {
    tags = "";
    completionOfTheMainModule = 0;
  }

  @override
  String toString() {
    return "\n-------------------------------------------------"
        "\nQuiz n°$id"
        "\n  name: $name"
        "\n  definition: $definition"
        "\n  tags: $tags"
        "\n  lastUpdate: $lastUpdate"
        "\n  completionOfTheMainModule: $completionOfTheMainModule"
        "\n  numberOfModule: $numberOfModule"
        "\n  modules: $modulesId";
  }

  /// Connect the generated [_$MainModuleFromJson] function to the `fromJson` factory.
  factory MainModule.fromJson(Map<String, dynamic> json) =>
      _$MainModuleFromJson(json);

  /// Connect the generated [_$MainModuleToJson] function to the `toJson` method.
  Map<String, dynamic> toJson() => _$MainModuleToJson(this);
}
