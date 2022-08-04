import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:soldoza_app/global_variables.dart';
import 'package:soldoza_app/models/project.dart';


class ProjectProvider extends ChangeNotifier {
  final String _endpoint = '/projects';

  List<Project> projects = [];
  bool isLoading = true;

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

  ProjectProvider() {
    getProjectsByUser(Global.userMap['id'].toString());
  }

  Future<List<Project>> getAllProjects() async {
    try {
      isLoading = true;
      notifyListeners();

      final url = Global.urlAPI + _endpoint;
      final response = await Dio().get(url);

      projects =
          (response.data as List).map((x) => Project.fromMap(x)).toList();

      isLoading = false;
      notifyListeners();
      return projects;
    } catch (e) {
      return [];
    }
  }

  Future<List<Project>> getProjectsByUser(String userId) async {
    try {
      isLoading = true;
      notifyListeners();

      final endpoint = '/project-users/user/$userId/projects';

      final url = Global.urlAPI + endpoint;
      final response = await Dio().get(url);

      projects = (response.data as List).map((x) => Project.fromMap(x)).toList();

      isLoading = false;
      notifyListeners();
      return projects;
    } catch (e) {
      return [];
    }
  }

  changeClient(int id) {
    client = projects.firstWhere((element) => element.id == id).cliente!;
    notifyListeners();
  }
}
