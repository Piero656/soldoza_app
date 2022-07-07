
// To parse this JSON data, do
//
//     final subzone = subzoneFromMap(jsonString);

import 'dart:convert';

class Subzone {
    Subzone({
        required this.id,
        required this.codSubzona,
        required this.descripcionSubzona,
    });

    int id;
    String codSubzona;
    String descripcionSubzona;

    factory Subzone.fromJson(String str) => Subzone.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory Subzone.fromMap(Map<String, dynamic> json) => Subzone(
        id: json["id"],
        codSubzona: json["codSubzona"],
        descripcionSubzona: json["descripcionSubzona"],
    );

    Map<String, dynamic> toMap() => {
        "id": id,
        "codSubzona": codSubzona,
        "descripcionSubzona": descripcionSubzona,
    };
}
