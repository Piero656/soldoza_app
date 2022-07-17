import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:soldoza_app/global_variables.dart';
import 'package:soldoza_app/models/incidence.dart';
import 'package:soldoza_app/providers/discipline_provider.dart';
import 'package:soldoza_app/providers/incidence_provider.dart';
import 'package:soldoza_app/providers/plant_provider.dart';
import 'package:soldoza_app/providers/project_provider.dart';
import 'package:soldoza_app/providers/zone_provider.dart';
import 'package:soldoza_app/providers/zubzone_provider.dart';
import 'package:soldoza_app/theme/app_theme.dart';

class FormScreen extends StatefulWidget {
  const FormScreen({Key? key}) : super(key: key);

  @override
  State<FormScreen> createState() => _FormScreenState();
}

class _FormScreenState extends State<FormScreen> {
  @override
  void initState() {
    super.initState();

    Global.selects['filter_1'] = '';
    Global.selects['filter_2'] = '';
    Global.selects['filter_3'] = '';
    Global.selects['filter_4'] = '';
    Global.selects['filter_5'] = '';
  }

  @override
  Widget build(BuildContext context) {
    final projectProvider = Provider.of<ProjectProvider>(context);
    final plantProvider = Provider.of<PlantProvider>(context);
    final zonesProvider = Provider.of<ZoneProvider>(context);
    final subzonesProvider = Provider.of<SubzoneProvider>(context);
    final disciplineProvider = Provider.of<DisciplineProvider>(context);
    final incidenceProvider = Provider.of<IncidenceProvider>(context);

    return SingleChildScrollView(
        child: Padding(
      padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 30),
      child: Column(
        children: [
          inputTitle("Client:"),
          if (Global.userMap['userType']['id'] == 1)
            clientText(projectProvider),
          if (Global.userMap['userType']['id'] == 2)
            clientReceptorText(plantProvider),
          inputTitle("Projects:"),
          if (Global.userMap['userType']['id'] == 1)
            projectsDropDown(projectProvider, plantProvider, zonesProvider,
                subzonesProvider),
          if (Global.userMap['userType']['id'] == 2) projectText(plantProvider),
          const SizedBox(
            height: 18,
          ),
          inputTitle("Intallations:"),
          if (Global.userMap['userType']['id'] == 1)
            plantsDropDown(plantProvider, zonesProvider, subzonesProvider),
          if (Global.userMap['userType']['id'] == 2)
            plantsReceptorsDropDown(
                plantProvider, zonesProvider, subzonesProvider),
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
            height: 18,
          ),
          inputTitle("Disciplines:"),
          disciplinesDropDown(disciplineProvider),
          const SizedBox(
            height: 30,
          ),
          ElevatedButton(
              onPressed: () async {

                print(Global.selects);

                if (Global.userMap['userType']['id'] == 1) {
                  if (Global.selects['filter_1'] == '') {
                    await _showMyDialog(
                        context, "Project Missing", "Please select a Project");
                    return;
                  }
                }

                if (Global.userMap['userType']['id'] == 2) {
                  if (Global.selects['filter_2'] == '') {
                    // ignore: use_build_context_synchronously
                    await _showMyDialog(context, "Installation Missing",
                        "Please select an Installation");
                    return;
                  }
                }

                if (Global.selects['filter_5'] == '') {
                  // ignore: use_build_context_synchronously
                  await _showMyDialog(context, "Discipline Missing",
                      "Please select a Discipline");
                  return;
                }

                await incidenceProvider.getIncidencesFilter();

                if (incidenceProvider.incidences.isNotEmpty) {
                  if (!mounted) return;
                  navigate(context, incidenceProvider.incidences);
                }
              },
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
      ),
    ));
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
          if (value != Global.selects['filter_1']) {
            Global.selects['filter_1'] = value ?? '';
            Global.selects['filter_2'] = '';
            Global.selects['filter_3'] = '';
            Global.selects['filter_4'] = '';

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
                value: e.id,
                child: Text(
                  '${e.codInstalacion} - ${e.descripcionInstalacion}',
                  overflow: TextOverflow.ellipsis,
                )))
            .toList(),

        onChanged: (value) async {
          if (value != Global.selects['filter_2']) {
            Global.selects['filter_2'] = value ?? '';
            Global.selects['filter_3'] = '';
            Global.selects['filter_4'] = '';
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

  Widget plantsReceptorsDropDown(PlantProvider plantProvider,
      ZoneProvider zoneProvider, SubzoneProvider subzoneProvider) {
    if (plantProvider.isLoading) {
      return const SizedBox(
        width: double.infinity,
        child: Center(child: CircularProgressIndicator()),
      );
    } else {
      return DropdownButtonFormField<int>(
        hint: const Text("Select"),
        items: plantProvider.plantsByUser
            .map((e) => DropdownMenuItem(
                value: e.id,
                child: Text(
                  '${e.codInstalacion} - ${e.descripcionInstalacion}',
                  overflow: TextOverflow.ellipsis,
                )))
            .toList(),

        onChanged: (value) async {
          if (value != Global.selects['filter_2']) {
            Global.selects['filter_2'] = value ?? '';
            Global.selects['filter_3'] = '';
            Global.selects['filter_4'] = '';
            subzoneProvider.subzones = [];
            plantProvider.changeProjectandClient(value!);
            await zoneProvider.getZonesByPlantId(value);
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
                child: Text(
                  '${e.codZona} - ${e.descripcionZona}',
                  overflow: TextOverflow.ellipsis,
                )))
            .toList(),

        onChanged: (value) async {
          if (value != Global.selects['filter_3']) {
            Global.selects['filter_3'] = value ?? '';
            Global.selects['filter_4'] = '';
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
                child: Text(
                  '${e.codSubzona} - ${e.descripcionSubzona}',
                  overflow: TextOverflow.ellipsis,
                )))
            .toList(),
        onChanged: (value) {
          if (value != Global.selects['filter_4']) {
            Global.selects['filter_4'] = value ?? '';
          }
        },
      );
    }
  }

  Widget disciplinesDropDown(DisciplineProvider disciplineProvider) {
    if (disciplineProvider.isLoading) {
      return const SizedBox(
        width: double.infinity,
        child: Center(child: CircularProgressIndicator()),
      );
    } else {
      return DropdownButtonFormField<int>(
        hint: const Text("Select"),
        items: disciplineProvider.disciplines
            .map((e) => DropdownMenuItem(
                value: e.id,
                child: Text(
                  '${e.codDisciplina} - ${e.descripcionDisciplina}',
                  overflow: TextOverflow.ellipsis,
                )))
            .toList(),
        onChanged: (value) {
          if (value != Global.selects['filter_5']) {
            Global.selects['filter_5'] = value ?? '';
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

  Widget clientReceptorText(PlantProvider plantProvider) {
    if (plantProvider.isLoading) {
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
          plantProvider.client.codCliente!,
          style: const TextStyle(fontSize: 17),
        ),
      );
    }
  }

  Widget projectText(PlantProvider plantProvider) {
    if (plantProvider.isLoading) {
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
          plantProvider.project.codProyecto,
          style: const TextStyle(fontSize: 17),
        ),
      );
    }
  }

  Future<void> _showMyDialog(
      BuildContext context, String title, String content) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text(content),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Ok'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
