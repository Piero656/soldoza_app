import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:soldoza_app/screens/details_screen.dart';
import 'package:soldoza_app/screens/filter_screen.dart';
import 'package:soldoza_app/screens/form_screen.dart';
import 'package:soldoza_app/screens/list_screen.dart';

import 'package:soldoza_app/screens/screens.dart';

import '../models/models.dart';

class AppRoutes {
  static const initialRoute = 'login';

  static Map<String, dynamic> selects = {
    'filter_1': 0,
    'filter_2': 0,
    'filter_3': 0,
    'filter_4': 0,
  };

  static final menuOptions = <MenuOption>[
    MenuOption(
        route: 'home',
        name: 'HomeScreen',
        screen: const HomeScreen(),
        icon: Icons.home),
    MenuOption(
        route: 'form',
        name: 'Search Filters',
        screen: const FormScreen(),
        icon: Icons.note_add_outlined),
    MenuOption(
        route: 'filter',
        name: 'Add Incidence',
        screen: const FilterScreen(),
        icon: Icons.filter_1_outlined)
  ];

  static Map<String, Widget Function(BuildContext)> getAppRoutes() {
    Map<String, Widget Function(BuildContext)> appRoutes = {};

    appRoutes.addAll({'home': (BuildContext context) => const HomeScreen()});
    appRoutes.addAll({'login': (BuildContext context) => const LoginScreen()});
    appRoutes.addAll({'form': (BuildContext context) => const FormScreen()});
    appRoutes.addAll({'list': (BuildContext context) => const ListScreen()});
    appRoutes
        .addAll({'details': (BuildContext context) => const DetailsScreen()});

    return appRoutes;
  }
}
