import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:json_helpers/json_helpers.dart';
import 'package:soldoza_app/global_variables.dart';
import 'package:soldoza_app/models/incidence.dart';
import 'package:http/http.dart' as http;
import 'package:soldoza_app/router/app_routes.dart';

class IncidenceProvider extends ChangeNotifier {
  final String _endpoint = 'v1/incidences';

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

      final url = Uri.http(Global.urlAPI, endpoint, {
        'proyectoId': Global.selects['filter_1'].toString(),
        'instalacionId': Global.selects['filter_2'].toString(),
        'zonaId': Global.selects['filter_3'].toString(),
        'subZonaId': Global.selects['filter_4'].toString(),
        'disciplinaId': Global.selects['filter_5'].toString()
      });

      final response = await http.get(url);
      incidences = response.body.jsonList((e) => Incidence.fromMap(e));

      print(incidences.length);

      isLoading = false;
      notifyListeners();
      return incidences;
    } catch (e) {
      return [];
    }
  }

  Future<http.Response> postIncidence() async {
    isLoading = true;
    notifyListeners();
    final String endpoint = _endpoint;

    final url = Uri.http(Global.urlAPI, endpoint);

    final json = jsonEncode(newIncidence);

    final response = await http.post(url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: json);

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

    final endpoint = 'http://${Global.urlAPI}/v1/photos/upload-to-incident';

    FormData formData = FormData.fromMap({
      "files": filestoUpload,
      "incidenteId": incidenteId,
      "latitud": latitud,
      "longitud": longitud,
      "usuario": usuario
    });

    print(formData.fields);

    var response = await Dio().post(endpoint, data: formData);

    return response;
  }

  Future<http.Response> updateFields(
      Map<String, dynamic> fields, String idIncidence) async {
    isLoading = true;
    notifyListeners();
    final String endpoint = "$_endpoint/$idIncidence";

    final url = Uri.http(Global.urlAPI, endpoint);

    final json = jsonEncode(fields);

    final response = await http.put(url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: json);

    isLoading = false;

    print(response.body);

    return response;
  }
}
