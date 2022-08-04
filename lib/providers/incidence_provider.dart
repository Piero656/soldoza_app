import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:soldoza_app/global_variables.dart';
import 'package:soldoza_app/models/incidence.dart';

class IncidenceProvider extends ChangeNotifier {
  final String _endpoint = '/incidences';

  List<Incidence> incidences = [];

  bool isLoading = false;

  static Map<String, dynamic> newIncidence = {
    "proyecto": null,
    "instalacion": null,
    "zona": null,
    "subZona": null,
    "disciplina": null,
    "categorias": null,
    "usuarioCreador": null,
    "fechaIncidencia": null,
    "descripcionIncidencia": "",
    "accionRequerida": "",
    "fechaLimite": null,
    "esNoConformidad": false,
    "codigoNC": ""
  };

  Future<List<Incidence>> getIncidencesFilter() async {
    try {
      isLoading = true;
      notifyListeners();

      final endpoint = '$_endpoint/find-by-filters';

      final url = Global.urlAPI + endpoint;

      final response = await Dio().get(url, queryParameters: {
        'proyectoId': Global.selects['filter_1'].toString(),
        'instalacionId': Global.selects['filter_2'].toString(),
        'zonaId': Global.selects['filter_3'].toString(),
        'subZonaId': Global.selects['filter_4'].toString(),
        'disciplinaId': Global.selects['filter_5'].toString()
      });
      incidences = (response.data as List).map((x) => Incidence.fromMap(x)).toList();

      isLoading = false;
      notifyListeners();
      return incidences;
    } catch (e) {
      return [];
    }
  }

  Future<Response> postIncidence() async {
    isLoading = true;
    notifyListeners();
    final String endpoint = _endpoint;

    final url = Global.urlAPI + endpoint;

    final json = jsonEncode(newIncidence);

    final response = await Dio().post(url, data: json);

    isLoading = false;

    return response;
  }

  Future<Response> postImages(
      List<XFile> files, incidenteId, latitud, longitud, usuario) async {
    final filestoUpload = [];

    for (var f in files) {
      final img = await MultipartFile.fromFile(f.path, filename: f.name);
      filestoUpload.add(img);
    }

    final endpoint = '${Global.urlAPI}/photos/upload-to-incident';

    FormData formData = FormData.fromMap({
      "files": filestoUpload,
      "incidenteId": incidenteId,
      "latitud": latitud,
      "longitud": longitud,
      "usuario": usuario
    });

    var response = await Dio().post(endpoint, data: formData);

    return response;
  }

  Future<Response> updateFields(
      Map<String, dynamic> fields, String idIncidence) async {
    isLoading = true;
    notifyListeners();
    final String endpoint = "$_endpoint/$idIncidence";

    final url = Global.urlAPI + endpoint;

    final json = jsonEncode(fields);

    final response = await Dio().put(url, data: json);

    isLoading = false;

    print(response);

    return response;
  }
}
