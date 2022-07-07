// To parse this JSON data, do
//
//     final project = projectFromMap(jsonString);

import 'dart:convert';

class User {
    User({
        required this.id,
        required this.nombreUsuario,
        required this.apellidosUsuario,
        required this.emailUsuario,
        required this.fotoUsuario,
        this.firmaUsuario,
        this.tipoUsuario,
    });

    int id;
    String nombreUsuario;
    String apellidosUsuario;
    String emailUsuario;
    String fotoUsuario;
    String? firmaUsuario;
    TipoUsuario? tipoUsuario;
    factory User.fromJson(String str) => User.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory User.fromMap(Map<String, dynamic> json) => User(
        id: json["id"],
        nombreUsuario: json["nombreUsuario"],
        apellidosUsuario: json["apellidosUsuario"],
        emailUsuario: json["emailUsuario"],
        fotoUsuario: json["fotoUsuario"],
        firmaUsuario: json["firmaUsuario"],
        tipoUsuario: TipoUsuario.fromMap(json["tipoUsuario"]),
    );

    Map<String, dynamic> toMap() => {
        "id": id,
        "nombreUsuario": nombreUsuario,
        "apellidosUsuario": apellidosUsuario,
        "emailUsuario": emailUsuario,
        "fotoUsuario": fotoUsuario,
        "firmaUsuario": firmaUsuario,
        "tipoUsuario": tipoUsuario!.toMap(),
    };
}

class TipoUsuario {
    TipoUsuario({
        required this.id,
        this.descripcionTipo,
    });

    int id;
    String? descripcionTipo;

    factory TipoUsuario.fromJson(String str) => TipoUsuario.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory TipoUsuario.fromMap(Map<String, dynamic> json) => TipoUsuario(
        id: json["id"],
        descripcionTipo: json["descripcionTipo"],
    );

    Map<String, dynamic> toMap() => {
        "id": id,
        "descripcionTipo": descripcionTipo,
    };
}
