import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:soldoza_app/global_variables.dart';
import 'package:soldoza_app/models/category.dart';


class CategoryProvider extends ChangeNotifier {
  final String _endpoint = '/categories';

  List<MultiSelectItem<int>> items = [];
  List<Category> categories = [];
  bool isLoading = false;

  Future<List<Category>> getCategoriesbyDisciplineId(int idDiscipline) async {
    try {
      isLoading = true;
      notifyListeners();

      final endpoint = '$_endpoint/discipline/$idDiscipline';

      final url = Global.urlAPI + endpoint;
      final response = await Dio().get(url);

      categories = (response.data as List).map((x) => Category.fromMap(x)).toList();

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
