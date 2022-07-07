import 'dart:convert';

class Zone {
    Zone({
        required this.id,
        required this.codZona,
        required this.descripcionZona,
    });

    int id;
    String codZona;
    String descripcionZona;

    factory Zone.fromJson(String str) => Zone.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory Zone.fromMap(Map<String, dynamic> json) => Zone(
        id: json["id"],
        codZona: json["codZona"],
        descripcionZona: json["descripcionZona"],
    );

    Map<String, dynamic> toMap() => {
        "id": id,
        "codZona": codZona,
        "descripcionZona": descripcionZona,
    };
}
