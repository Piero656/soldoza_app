import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:soldoza_app/providers/auth_provider.dart';
import 'package:soldoza_app/providers/category_provider.dart';
import 'package:soldoza_app/providers/discipline_provider.dart';
import 'package:soldoza_app/providers/incidence_provider.dart';
import 'package:soldoza_app/providers/plant_provider.dart';
import 'package:soldoza_app/providers/project_provider.dart';
import 'package:soldoza_app/providers/zone_provider.dart';
import 'package:soldoza_app/providers/zubzone_provider.dart';
import 'package:soldoza_app/router/app_routes.dart';
import 'package:soldoza_app/theme/app_theme.dart';

void main() async {
  runApp(const AppState());
}

class AppState extends StatelessWidget {
  const AppState({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => ProjectProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => PlantProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => ZoneProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => SubzoneProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => IncidenceProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => AuthProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => DisciplineProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => CategoryProvider(),
        ),
      ],
      child: const MyApp(),
    );
  }
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: 'login',
      routes: AppRoutes.getAppRoutes(),
      theme: AppTheme.lightTheme,
    );
  }
}
