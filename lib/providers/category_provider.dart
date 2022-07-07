import 'package:flutter/material.dart';
import 'package:json_helpers/json_helpers.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:soldoza_app/global_variables.dart';
import 'package:soldoza_app/models/category.dart';
import 'package:http/http.dart' as http;

class CategoryProvider extends ChangeNotifier {
  final String _endpoint = 'v1/categories';

  List<MultiSelectItem<int>> items = [];
  List<Category> categories = [];
  bool isLoading = false;

  Future<List<Category>> getCategoriesbyDisciplineId(int idDiscipline) async {
    try {
      isLoading = true;
      notifyListeners();

      final endpoint = '$_endpoint/discipline/$idDiscipline';

      final url = Uri.http(Global.urlAPI, endpoint);
      final response = await http.get(url);

      categories = response.body.jsonList((e) => Category.fromMap(e));

      items = categories
          .map((categories) =>
              MultiSelectItem<int>(categories.id, categories.codCategoria!))
          .toList();

      isLoading = false;

      notifyListeners();
      return categories;
    } catch (e) {
      return [];
    }
  }
}
