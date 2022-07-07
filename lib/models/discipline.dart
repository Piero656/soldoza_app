// To parse this JSON data, do
//
//     final discipline = disciplineFromMap(jsonString);

import 'dart:convert';

class Discipline {
    Discipline({
        required this.id,
        this.codDisciplina,
        this.descripcionDisciplina,
    });

    int id;
    String? codDisciplina;
    String? descripcionDisciplina;

    factory Discipline.fromJson(String str) => Discipline.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory Discipline.fromMap(Map<String, dynamic> json) => Discipline(
        id: json["id"],
        codDisciplina: json["codDisciplina"],
        descripcionDisciplina: json["descripcionDisciplina"],
    );

    Map<String, dynamic> toMap() => {
        "id": id,
        "codDisciplina": codDisciplina,
        "descripcionDisciplina": descripcionDisciplina,
    };
}
