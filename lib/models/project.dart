// To parse this JSON data, do
//
//     final project = projectFromMap(jsonString);

import 'dart:convert';

class Project {
    Project({
        required this.id,
        required this.codProyecto,
        required this.descripcionProyecto,
        this.usuarioActualizacion,
        this.fechaCreacion,
        this.fechaActualizacion,
        this.estado,
        this.cliente,
    });

    int id;
    String codProyecto;
    String descripcionProyecto;
    dynamic usuarioActualizacion;
    DateTime? fechaCreacion;
    dynamic fechaActualizacion;
    String? estado;
    Cliente? cliente;

    factory Project.fromJson(String str) => Project.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory Project.fromMap(Map<String, dynamic> json) => Project(
        id: json["id"],
        codProyecto: json["codProyecto"],
        descripcionProyecto: json["descripcionProyecto"],
        usuarioActualizacion: json["usuarioActualizacion"],
        fechaCreacion: DateTime.parse(json["fechaCreacion"]),
        fechaActualizacion: json["fechaActualizacion"],
        estado: json["estado"],
        cliente: Cliente.fromMap(json["cliente"]),
    );

    Map<String, dynamic> toMap() => {
        "id": id,
        "codProyecto": codProyecto,
        "descripcionProyecto": descripcionProyecto,
        "usuarioActualizacion": usuarioActualizacion,
        "fechaCreacion": fechaCreacion?.toIso8601String(),
        "fechaActualizacion": fechaActualizacion,
        "estado": estado,
        "cliente": cliente?.toMap(),
    };
}

class Cliente {
    Cliente({
        this.id,
        this.codCliente,
        this.nrdDocCliente,
        this.direccionCliente,
        this.pais,
        this.ciudad,
        this.telefono,
        this.email,
        this.estado,
    });

    int? id;
    String? codCliente;
    String? nrdDocCliente;
    String? direccionCliente;
    String? pais;
    String? ciudad;
    String? telefono;
    String? email;
    String? estado;

    factory Cliente.fromJson(String str) => Cliente.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory Cliente.fromMap(Map<String, dynamic> json) => Cliente(
        id: json["id"],
        codCliente: json["codCliente"],
        nrdDocCliente: json["nrdDocCliente"],
        direccionCliente: json["direccionCliente"],
        pais: json["pais"],
        ciudad: json["ciudad"],
        telefono: json["telefono"],
        email: json["email"],
        estado: json["estado"],
    );

    Map<String, dynamic> toMap() => {
        "id": id,
        "codCliente": codCliente,
        "nrdDocCliente": nrdDocCliente,
        "direccionCliente": direccionCliente,
        "pais": pais,
        "ciudad": ciudad,
        "telefono": telefono,
        "email": email,
        "estado": estado,
    };
}
