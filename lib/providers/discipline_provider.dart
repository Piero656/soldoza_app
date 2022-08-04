import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:soldoza_app/global_variables.dart';
import 'package:soldoza_app/models/discipline.dart';

class DisciplineProvider extends ChangeNotifier {
  DisciplineProvider() {
    getDisciplinesByUserId(Global.userMap['id'].toString());
  }

  final String _endpoint = '/disciplines';

  List<Discipline> disciplines = [];
  bool isLoading = false;

  Future<List<Discipline>> getDisciplines() async {
    try {
      isLoading = true;
      notifyListeners();

      final url = Global.urlAPI + _endpoint;
      final response = await Dio().get(url);

      disciplines = (response.data as List).map((x) => Discipline.fromMap(x)).toList();
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

      final endpoint = '/user-disciplines/user/$userId/disciplines';

      final url = Global.urlAPI + endpoint;
      final response = await Dio().get(url);

      disciplines = (response.data as List).map((x) => Discipline.fromMap(x)).toList();
      isLoading = false;
      notifyListeners();
      return disciplines;
    } catch (e) {
      return [];
    }
  }
}
