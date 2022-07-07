
// To parse this JSON data, do
//
//     final plant = plantFromMap(jsonString);

import 'dart:convert';

class Plant {
    Plant({
        required this.id,
        required this.codInstalacion,
        required this.descripcionInstalacion,
    });

    int id;
    String codInstalacion;
    String descripcionInstalacion;

    factory Plant.fromJson(String str) => Plant.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory Plant.fromMap(Map<String, dynamic> json) => Plant(
        id: json["id"],
        codInstalacion: json["codInstalacion"],
        descripcionInstalacion: json["descripcionInstalacion"],
    );

    Map<String, dynamic> toMap() => {
        "id": id,
        "codInstalacion": codInstalacion,
        "descripcionInstalacion": descripcionInstalacion,
    };
}
