import 'package:flutter/material.dart';
import 'package:json_helpers/json_helpers.dart';
import 'package:soldoza_app/global_variables.dart';
import 'package:soldoza_app/models/subzone.dart';

import 'package:http/http.dart' as http;

class SubzoneProvider extends ChangeNotifier {
  final String _endpoint = 'v1/sub-zones';

  List<Subzone> subzones = [];
  bool isLoading = false;

  Future<List<Subzone>> getSubzonesByZoneId(int idZone) async {
    try {
      isLoading = true;
      notifyListeners();

      final endpoint = '$_endpoint/zone/$idZone';

      final url = Uri.http(Global.urlAPI, endpoint);
      final response = await http.get(url);

  
      subzones = response.body.jsonList((e) => Subzone.fromMap(e));
      isLoading = false;

      notifyListeners();
      return subzones;
    } catch (e) {
      return [];
    }
  }
}
