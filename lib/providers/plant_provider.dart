import 'package:flutter/material.dart';
import 'package:json_helpers/json_helpers.dart';

import 'package:http/http.dart' as http;
import 'package:soldoza_app/global_variables.dart';
import 'package:soldoza_app/models/plant.dart';

class PlantProvider extends ChangeNotifier {
  final String _endpoint = 'v1/plants/project';

  List<Plant> plants = [];

  bool isLoading = false;

  Future<List<Plant>> getPlantByProjectId(int idProject) async {
    try {
      isLoading = true;
      notifyListeners();

      final endpoint = '$_endpoint/$idProject';

      final url = Uri.http(Global.urlAPI, endpoint);
      final response = await http.get(url);

      plants = response.body.jsonList((e) => Plant.fromMap(e));
      isLoading = false;
      notifyListeners();
      return plants;
    } catch (e) {
      return [];
    }
  }
}
