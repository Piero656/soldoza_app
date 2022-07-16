import 'package:flutter/material.dart';
import 'package:soldoza_app/global_variables.dart';
import 'package:http/http.dart' as http;
import 'package:soldoza_app/models/project.dart';
import 'package:json_helpers/json_helpers.dart';

class ProjectProvider extends ChangeNotifier {
  final String _endpoint = 'v1/projects';

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

      final url = Uri.http(Global.urlAPI, _endpoint);
      final response = await http.get(url);

      projects = response.body.jsonList((e) => Project.fromMap(e));

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

      final endpoint = 'v1/project-users/user/$userId/projects';

      final url = Uri.http(Global.urlAPI, endpoint);
      final response = await http.get(url);

      projects = response.body.jsonList((e) => Project.fromMap(e));

      print(projects);

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
