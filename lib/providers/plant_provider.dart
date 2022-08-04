import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:soldoza_app/global_variables.dart';
import 'package:soldoza_app/models/plant.dart';
import 'package:soldoza_app/models/project.dart';

class PlantProvider extends ChangeNotifier {
  final String _endpoint = '/plants/project';

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

  Project project = Project(id: 0, codProyecto: '', descripcionProyecto: '');

  bool isLoading = false;

  PlantProvider() {
    getPlantByUserId(Global.userMap["id"].toString());
  }

  Future<List<Plant>> getPlantByProjectId(int idProject) async {
    try {
      isLoading = true;
      notifyListeners();

      final endpoint = '$_endpoint/$idProject';

      final url = Global.urlAPI + endpoint;
      final response = await Dio().get(url);

      plants = (response.data as List).map((x) => Plant.fromMap(x)).toList();
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

      final endpoint = '/plant-users/user/$userId/plants';

      final url = Global.urlAPI + endpoint;
      final response = await Dio().get(url);

      plantsByUser = (response.data as List).map((x) => Plant.fromMap(x)).toList();

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
