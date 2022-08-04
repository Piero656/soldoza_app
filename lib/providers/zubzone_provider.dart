import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:soldoza_app/global_variables.dart';
import 'package:soldoza_app/models/subzone.dart';

class SubzoneProvider extends ChangeNotifier {
  final String _endpoint = '/sub-zones';

  List<Subzone> subzones = [];
  bool isLoading = false;

  Future<List<Subzone>> getSubzonesByZoneId(int idZone) async {
    try {
      isLoading = true;
      notifyListeners();

      final endpoint = '$_endpoint/zone/$idZone';

      final url = Global.urlAPI + endpoint;
      final response = await Dio().get(url);

      subzones =
          (response.data as List).map((x) => Subzone.fromMap(x)).toList();
      isLoading = false;

      notifyListeners();
      return subzones;
    } catch (e) {
      return [];
    }
  }
}
