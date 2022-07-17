import 'package:flutter/material.dart';
import 'package:json_helpers/json_helpers.dart';

import 'package:http/http.dart' as http;
import 'package:soldoza_app/global_variables.dart';
import 'package:soldoza_app/models/plant.dart';
import 'package:soldoza_app/models/project.dart';

class PlantProvider extends ChangeNotifier {
  final String _endpoint = 'v1/plants/project';

  List<Plant> plants = [];
  List<Plant> plantsByUser = [];

  Cliente client = Cliente(
      id: 0,
      codCliente: '',
      nrdDocCliente: '',
      direccionCliente: '',
      pais: '',
      ciudad: '',
      telefono: '',
      email: '',
      estado: '');

  Project project =
      Project(id: 0, codProyecto: '', descripcionProyecto: '');

  bool isLoading = false;

  PlantProvider() {
    getPlantByUserId(Global.userMap["id"].toString());
  }

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

  Future<List<Plant>> getPlantByUserId(String userId) async {
    try {
      isLoading = true;
      notifyListeners();

      final endpoint = 'v1/plant-users/user/$userId/plants';

      final url = Uri.http(Global.urlAPI, endpoint);
      final response = await http.get(url);

      plantsByUser = response.body.jsonList((e) => Plant.fromMap(e));

      isLoading = false;
      notifyListeners();
      return plantsByUser;
    } catch (e) {
      return [];
    }
  }

  changeProjectandClient(int id) {
    project = plantsByUser.firstWhere((element) => element.id == id).proyecto!;
    client = plantsByUser
        .firstWhere((element) => element.id == id)
        .proyecto!
        .cliente!;
    notifyListeners();
  }
}
