// ignore_for_file: file_names
import 'dart:math';

import "package:json_annotation/json_annotation.dart";

import 'ModuleId.dart';
part "MainModule.g.dart";

// Classe qui doit manager le stockage local des résultats des quiz d'entrainements.
// Pour générer le fichier complémentaire => flutter pub run build_runner build
@JsonSerializable(explicitToJson: true)
class MainModule {
  late final int id; // Identifiant unique du mainModule
  late String name; // Nom du mainModule
  late String definition; // Définition textuel du mainModule
  late String
      tags; // Liste des tags du mainModule, permet de faire des recherches par tags. Splitter = \\
  late List<ModuleId>
      modulesId; // Liste des id des modules de ce mainModule. (La partie string permet de savoir quel type de module est indexé. (Quiz, cours...))
  late final DateTime creationDate =
      DateTime.now(); // Date de création du mainModule
  late DateTime lastUpdate = DateTime
      .now(); // Dernière fois que l'utiliateur a utiliser un des modules de ce mainModule. (Utile pour les rappels si le module n'est pas terminé.)

  int get numberOfModule =>
      modulesId.length; // Nombre de module à l'interieur de ce mainModule
  int get completionOfTheMainModule =>
      _randomMainModuleCompletion(); // Valeur entre 0 et 100 qui indique le taux de completion du module

  int _randomMainModuleCompletion() {
    var rng = Random();
    return rng.nextInt(100);
  }

  MainModule(
      {required this.id,
      required this.name,
      required this.modulesId,
      this.definition = ""}) {
    tags = "";
  }

  @override
  String toString() {
    return "\n-------------------------------------------------"
        "\nQuiz n°$id"
        "\n  name: $name"
        "\n  definition: $definition"
        "\n  tags: $tags"
        "\n  lastUpdate: $lastUpdate"
        "\n  numberOfModule: $numberOfModule"
        "\n  modules: $modulesId";
  }

  /// Connect the generated [_$MainModuleFromJson] function to the `fromJson` factory.
  factory MainModule.fromJson(Map<String, dynamic> json) =>
      _$MainModuleFromJson(json);

  /// Connect the generated [_$MainModuleToJson] function to the `toJson` method.
  Map<String, dynamic> toJson() => _$MainModuleToJson(this);
}
