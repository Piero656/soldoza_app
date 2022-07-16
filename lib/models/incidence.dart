// To parse this JSON data, do
//
//     final project = projectFromMap(jsonString);

import 'dart:convert';

import 'package:soldoza_app/models/category.dart';
import 'package:soldoza_app/models/discipline.dart';
import 'package:soldoza_app/models/plant.dart';
import 'package:soldoza_app/models/project.dart';
import 'package:soldoza_app/models/subzone.dart';
import 'package:soldoza_app/models/user.dart';
import 'package:soldoza_app/models/zone.dart';

class Incidence {
    Incidence({
        required this.id,
        this.fechaIncidencia,
        this.descripcionIncidencia,
        this.accionRequerida,
        this.fechaLimite,
        this.esNoConformidad,
        this.codigoNc,
        this.comentarioReceptor,
        this.resultadoReceptor,
        this.codIncidente,
        this.proyecto,
        this.instalacion,
        this.zona,
        this.subZona,
        this.usuarioCreador,
        this.disciplina,
        this.estado,
        this.fotos,
        this.incidenteCategorias,
    });

    int id;
    DateTime? fechaIncidencia;
    String? descripcionIncidencia;
    String? accionRequerida;
    DateTime? fechaLimite;
    bool? esNoConformidad;
    String? codigoNc;
    String? comentarioReceptor;
    String? resultadoReceptor;
    String? codIncidente;
    Project? proyecto;
    Plant? instalacion;
    Zone? zona;
    Subzone? subZona;
    User? usuarioCreador;
    Discipline? disciplina;
    EstadoClass? estado;
    List<Foto>? fotos;
    List<IncidenteCategoria>? incidenteCategorias;

    factory Incidence.fromJson(String str) => Incidence.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory Incidence.fromMap(Map<String, dynamic> json) => Incidence(
        id: json["id"],
        fechaIncidencia: DateTime.parse(json["fechaIncidencia"]),
        descripcionIncidencia: json["descripcionIncidencia"],
        accionRequerida: json["accionRequerida"],
        fechaLimite: DateTime.parse(json["fechaLimite"]),
        esNoConformidad: json["esNoConformidad"],
        codigoNc: json["codigoNC"],
        comentarioReceptor: json["comentarioReceptor"],
        resultadoReceptor: json["resultadoReceptor"],
        codIncidente: json["codIncidente"],
        proyecto: Project.fromMap(json["proyecto"]),
        instalacion: Plant.fromMap(json["instalacion"]),
        zona: Zone.fromMap(json["zona"]),
        subZona: Subzone.fromMap(json["subZona"]),
        usuarioCreador: User.fromMap(json["usuarioCreador"]),
        disciplina: json["disciplina"] == null ? null : Discipline.fromMap(json["disciplina"]),
        estado: json["estado"] == null ? null : EstadoClass.fromMap(json["estado"]),
        fotos: List<Foto>.from(json["fotos"].map((x) => Foto.fromMap(x))),
        incidenteCategorias: List<IncidenteCategoria>.from(json["incidenteCategorias"].map((x) => IncidenteCategoria.fromMap(x))),
    );

    Map<String, dynamic> toMap() => {
        "id": id,
        "fechaIncidencia": "${fechaIncidencia!.year.toString().padLeft(4, '0')}-${fechaIncidencia!.month.toString().padLeft(2, '0')}-${fechaIncidencia!.day.toString().padLeft(2, '0')}",
        "descripcionIncidencia": descripcionIncidencia,
        "accionRequerida": accionRequerida,
        "fechaLimite": "${fechaLimite!.year.toString().padLeft(4, '0')}-${fechaLimite!.month.toString().padLeft(2, '0')}-${fechaLimite!.day.toString().padLeft(2, '0')}",
        "esNoConformidad": esNoConformidad,
        "codigoNC": codigoNc,
        "comentarioReceptor": comentarioReceptor == null ? null : comentarioReceptor,
        "resultadoReceptor": resultadoReceptor == null ? null : resultadoReceptor,
        "codIncidente": codIncidente == null ? null : codIncidente,
        "proyecto": proyecto!.toMap(),
        "instalacion": instalacion!.toMap(),
        "zona": zona!.toMap(),
        "subZona": subZona!.toMap(),
        "usuarioCreador": usuarioCreador!.toMap(),
        "disciplina": disciplina == null ? null : disciplina!.toMap(),
        "estado": estado == null ? null : estado!.toMap(),
        "fotos": List<dynamic>.from(fotos!.map((x) => x.toMap())),
        "incidenteCategorias": List<dynamic>.from(incidenteCategorias!.map((x) => x.toMap())),
    };
}

class EstadoClass {
    EstadoClass({
        required this.id,
        this.codEstado,
        this.descripcionEstado,
    });

    int id;
    String? codEstado;
    String? descripcionEstado;

    factory EstadoClass.fromJson(String str) => EstadoClass.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory EstadoClass.fromMap(Map<String, dynamic> json) => EstadoClass(
        id: json["id"],
        codEstado: json["codEstado"],
        descripcionEstado: json["descripcionEstado"],
    );

    Map<String, dynamic> toMap() => {
        "id": id,
        "codEstado": codEstado,
        "descripcionEstado": descripcionEstado,
    };
}

class Foto {
    Foto({
        required this.id,
        this.fotoUrl,
        this.latitud,
        this.longitud,
        this.usuario,
    });

    int id;
    String? fotoUrl;
    String? latitud;
    String? longitud;
    User? usuario;

    factory Foto.fromJson(String str) => Foto.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory Foto.fromMap(Map<String, dynamic> json) => Foto(
        id: json["id"],
        fotoUrl: json["fotoUrl"],
        latitud: json["latitud"],
        longitud: json["longitud"],
        usuario: User.fromMap(json["usuario"]),
    );

    Map<String, dynamic> toMap() => {
        "id": id,
        "fotoUrl": fotoUrl,
        "latitud": latitud,
        "longitud": longitud,
        "usuario": usuario!.toMap(),
    };
}

class IncidenteCategoria {
    IncidenteCategoria({
        required this.id,
        required this.categoria,
    });

    int id;
    Category categoria;

    factory IncidenteCategoria.fromJson(String str) => IncidenteCategoria.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory IncidenteCategoria.fromMap(Map<String, dynamic> json) => IncidenteCategoria(
        id: json["id"],
        categoria: Category.fromMap(json["categoria"]),
    );

    Map<String, dynamic> toMap() => {
        "id": id,
        "categoria": categoria.toMap(),
    };
}