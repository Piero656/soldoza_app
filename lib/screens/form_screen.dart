import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:soldoza_app/models/incidence.dart';
import 'package:soldoza_app/providers/incidence_provider.dart';
import 'package:soldoza_app/providers/plant_provider.dart';
import 'package:soldoza_app/providers/project_provider.dart';
import 'package:soldoza_app/providers/zone_provider.dart';
import 'package:soldoza_app/providers/zubzone_provider.dart';

import '../providers/plant_provider.dart';
import '../router/app_routes.dart';
import '../theme/app_theme.dart';

class FormScreen extends StatefulWidget {
  const FormScreen({Key? key}) : super(key: key);

  @override
  State<FormScreen> createState() => _FormScreenState();
}

class _FormScreenState extends State<FormScreen> {
  @override
  void initState() {
    super.initState();

    AppRoutes.selects['filter_1'] = '';
    AppRoutes.selects['filter_2'] = '';
    AppRoutes.selects['filter_3'] = '';
    AppRoutes.selects['filter_4'] = '';
  }

  @override
  Widget build(BuildContext context) {
    final projectProvider = Provider.of<ProjectProvider>(context);
    final plantProvider = Provider.of<PlantProvider>(context);
    final zonesProvider = Provider.of<ZoneProvider>(context);
    final subzonesProvider = Provider.of<SubzoneProvider>(context);
    final incidenceProvider = Provider.of<IncidenceProvider>(context);

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 30, horizontal: 30),
      width: double.infinity,
      child: SingleChildScrollView(
          child: Column(
        children: [
          inputTitle("Client:"),
          clientText(projectProvider),
          inputTitle("Projects:"),
          projectsDropDown(
              projectProvider, plantProvider, zonesProvider, subzonesProvider),
          const SizedBox(
            height: 18,
          ),
          inputTitle("Intallations:"),
          plantsDropDown(plantProvider, zonesProvider, subzonesProvider),
          const SizedBox(
            height: 18,
          ),
          inputTitle("Zones:"),
          zonesDropDown(zonesProvider, subzonesProvider),
          const SizedBox(
            height: 18,
          ),
          inputTitle("Subzones:"),
          subzonesDropDown(subzonesProvider),
          const SizedBox(
            height: 30,
          ),
          ElevatedButton(
              onPressed: () async {
                await incidenceProvider.getIncidencesFilter();

                if (incidenceProvider.incidences.isNotEmpty) {
                  if (!mounted) return;
                  navigate(context, incidenceProvider.incidences);
                }
              },
              // child: Text("go"),
              style: ButtonStyle(
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18.0),
                )),
                backgroundColor:
                    MaterialStateProperty.all<Color>(AppTheme.orangeColor),
              ),
              child: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 70, vertical: 10),
                child: Text(
                  "Search",
                  style: TextStyle(fontSize: 18),
                ),
              )),
          const SizedBox(
            height: 30,
          ),
        ],
      )),
    );
  }

  navigate(BuildContext context, List<Incidence> incidences) {
    Navigator.pushNamed(context, 'list', arguments: incidences);
  }

  Align inputTitle(String title) {
    return Align(
      heightFactor: 2,
      // widthFactor: 5,
      alignment: Alignment.centerLeft,
      child: Text(
        title,
        style: const TextStyle(fontSize: 17),
      ),
    );
  }

  Widget projectsDropDown(
      ProjectProvider projectProvider,
      PlantProvider plantProvider,
      ZoneProvider zoneProvider,
      SubzoneProvider subzoneProvider) {
    if (projectProvider.isLoading) {
      return const SizedBox(
        width: double.infinity,
        child: Center(child: CircularProgressIndicator()),
      );
    } else {
      return DropdownButtonFormField<int>(
        hint: const Text("Select"),
        items: projectProvider.projects
            .map((e) =>
                DropdownMenuItem(value: e.id, child: Text(e.codProyecto)))
            .toList(),

        onChanged: (value) async {
          if (value != AppRoutes.selects['filter_1']) {
            AppRoutes.selects['filter_1'] = value ?? '';
            AppRoutes.selects['filter_2'] = '';
            AppRoutes.selects['filter_3'] = '';
            AppRoutes.selects['filter_4'] = '';

            plantProvider.plants = [];
            zoneProvider.zones = [];
            subzoneProvider.subzones = [];
            await projectProvider.changeClient(value!);
            await plantProvider.getPlantByProjectId(value);
          }
        },

        // elevation: 50,
        // icon: Icon(Icons.personal_injury_outlined),
        // dropdownColor: AppTheme.orangeColor,
        // style: TextStyle(color: Colors.blue),
      );
    }
  }

  Widget plantsDropDown(PlantProvider plantProvider, ZoneProvider zoneProvider,
      SubzoneProvider subzoneProvider) {
    if (plantProvider.isLoading) {
      return const SizedBox(
        width: double.infinity,
        child: Center(child: CircularProgressIndicator()),
      );
    } else {
      return DropdownButtonFormField<int>(
        hint: const Text("Select"),
        items: plantProvider.plants
            .map((e) => DropdownMenuItem(
                value: e.id, child: Text(e.descripcionInstalacion)))
            .toList(),

        onChanged: (value) async {
          if (value != AppRoutes.selects['filter_2']) {
            AppRoutes.selects['filter_2'] = value ?? '';
            AppRoutes.selects['filter_3'] = '';
            AppRoutes.selects['filter_4'] = '';
            subzoneProvider.subzones = [];
            await zoneProvider.getZonesByPlantId(value!);
          }
        },

        // icon: Icon(Icons.personal_injury_outlined),
        // dropdownColor: AppTheme.orangeColor,
        // style: TextStyle(color: Colors.blue),
      );
    }
  }

  Widget zonesDropDown(
      ZoneProvider zoneProvider, SubzoneProvider subzoneProvider) {
    if (zoneProvider.isLoading) {
      return const SizedBox(
        width: double.infinity,
        child: Center(child: CircularProgressIndicator()),
      );
    } else {
      return DropdownButtonFormField<int>(
        hint: const Text("Select"),
        items: zoneProvider.zones
            .map((e) => DropdownMenuItem(
                value: e.id,
                child: Text('${e.codZona} - ${e.descripcionZona}')))
            .toList(),

        onChanged: (value) async {
          if (value != AppRoutes.selects['filter_3']) {
            AppRoutes.selects['filter_3'] = value ?? '';
            AppRoutes.selects['filter_4'] = '';
            await subzoneProvider.getSubzonesByZoneId(value!);
          }
        },

        // focusColor: AppTheme.orangeColor,

        // borderRadius: BorderRadius.circular(15),
        // elevation: 50,
        // icon: Icon(Icons.personal_injury_outlined),
        // dropdownColor: AppTheme.orangeColor,
        // style: TextStyle(color: Colors.blue),
      );
    }
  }

  Widget subzonesDropDown(SubzoneProvider subzoneProvider) {
    if (subzoneProvider.isLoading) {
      return const SizedBox(
        width: double.infinity,
        child: Center(child: CircularProgressIndicator()),
      );
    } else {
      return DropdownButtonFormField<int>(
        hint: const Text("Select"),
        items: subzoneProvider.subzones
            .map((e) => DropdownMenuItem(
                value: e.id,
                child: Text('${e.codSubzona} - ${e.descripcionSubzona}')))
            .toList(),

        onChanged: (value) {
          if (value != AppRoutes.selects['filter_4']) {
            AppRoutes.selects['filter_4'] = value ?? '';
          }
        },

      );
    }
  }

  Widget clientText(ProjectProvider projectProvider) {
    if (projectProvider.isLoading) {
      return const SizedBox(
        width: double.infinity,
        child: Center(child: CircularProgressIndicator()),
      );
    } else {
      return Align(
        heightFactor: 2,
        // widthFactor: 5,
        alignment: Alignment.centerLeft,
        child: Text(
          projectProvider.client.codCliente!,
          style: const TextStyle(fontSize: 17),
        ),
      );
    }
  }
}
