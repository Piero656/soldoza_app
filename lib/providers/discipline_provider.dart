import 'package:flutter/material.dart';
import 'package:json_helpers/json_helpers.dart';
import 'package:soldoza_app/models/discipline.dart';
import 'package:http/http.dart' as http;

import '../global_variables.dart';

class DisciplineProvider extends ChangeNotifier {
  DisciplineProvider() {
    getDisciplinesByUserId(Global.userMap['id'].toString());
  }

  final String _endpoint = 'v1/disciplines';

  List<Discipline> disciplines = [];
  bool isLoading = false;

  Future<List<Discipline>> getDisciplines() async {
    try {
      isLoading = true;
      notifyListeners();

      final url = Uri.http(Global.urlAPI, _endpoint);
      final response = await http.get(url);

      disciplines = response.body.jsonList((e) => Discipline.fromMap(e));
      isLoading = false;
      notifyListeners();
      return disciplines;
    } catch (e) {
      return [];
    }
  }

  Future<List<Discipline>> getDisciplinesByUserId(String userId) async {
    try {
      isLoading = true;
      notifyListeners();

      final endpoint = 'v1/user-disciplines/user/$userId/disciplines';

      final url = Uri.http(Global.urlAPI, endpoint);
      final response = await http.get(url);

      disciplines = response.body.jsonList((e) => Discipline.fromMap(e));
      isLoading = false;
      notifyListeners();
      return disciplines;
    } catch (e) {
      return [];
    }
  }
}
