// To parse this JSON data, do
//
//     final plant = plantFromMap(jsonString);

import 'dart:convert';

import 'package:soldoza_app/models/project.dart';

class Plant {
  Plant(
      {required this.id,
      required this.codInstalacion,
      required this.descripcionInstalacion,
      this.proyecto});

  int id;
  String codInstalacion;
  String descripcionInstalacion;
  Project? proyecto;

  factory Plant.fromJson(String str) => Plant.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Plant.fromMap(Map<String, dynamic> json) => Plant(
      id: json["id"],
      codInstalacion: json["codInstalacion"],
      descripcionInstalacion: json["descripcionInstalacion"],
      proyecto: json.containsKey("proyecto")
          ? Project.fromMap(json["proyecto"])
          : null);

  Map<String, dynamic> toMap() => {
        "id": id,
        "codInstalacion": codInstalacion,
        "descripcionInstalacion": descripcionInstalacion,
        "proyecto": proyecto != null ? proyecto!.toMap() : null,
      };
}
