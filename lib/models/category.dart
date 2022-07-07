// To parse this JSON data, do
//
//     final category = categoryFromMap(jsonString);

import 'dart:convert';

class Category {
    Category({
        required this.id,
        this.codCategoria,
        this.descripcionCategoria,
    });

    int id;
    String? codCategoria;
    String? descripcionCategoria;

    factory Category.fromJson(String str) => Category.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory Category.fromMap(Map<String, dynamic> json) => Category(
        id: json["id"],
        codCategoria: json["codCategoria"],
        descripcionCategoria: json["descripcionCategoria"],
    );

    Map<String, dynamic> toMap() => {
        "id": id,
        "codCategoria": codCategoria,
        "descripcionCategoria": descripcionCategoria,
    };
}
