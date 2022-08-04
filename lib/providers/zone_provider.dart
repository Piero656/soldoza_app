import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import '../global_variables.dart';
import '../models/zone.dart';

class ZoneProvider extends ChangeNotifier {
  final String _endpoint = '/plant-zone-details';

  List<Zone> zones = [];
  bool isLoading = false;

  Future<List<Zone>> getZonesByPlantId(int idPlant) async {
    try {
      isLoading = true;
      notifyListeners();

      final endpoint = '$_endpoint/plant/$idPlant/zones';

      final url = Global.urlAPI + endpoint;
      final response = await Dio().get(url);

      zones = (response.data as List).map((x) => Zone.fromMap(x)).toList();
      isLoading = false;
      notifyListeners();
      return zones;
    } catch (e) {
      return [];
    }
  }
}
