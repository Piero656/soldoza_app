import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:json_helpers/json_helpers.dart';
import '../global_variables.dart';
import '../models/zone.dart';

class ZoneProvider extends ChangeNotifier {
  final String _endpoint = 'v1/plant-zone-details';

  List<Zone> zones = [];
  bool isLoading = false;

  Future<List<Zone>> getZonesByPlantId(int idPlant) async {
    try {
      isLoading = true;
      notifyListeners();

      final endpoint = '$_endpoint/plant/$idPlant/zones';

      final url = Uri.http(Global.urlAPI, endpoint);
      final response = await http.get(url);

      zones = response.body.jsonList((e) => Zone.fromMap(e));
      isLoading = false;
      notifyListeners();
      return zones;
    } catch (e) {
      return [];
    }
  }
}
