import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:location/location.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:provider/provider.dart';
import 'package:soldoza_app/providers/auth_provider.dart';
import 'package:soldoza_app/providers/category_provider.dart';
import 'package:soldoza_app/providers/discipline_provider.dart';
import 'package:soldoza_app/providers/incidence_provider.dart';
import 'package:soldoza_app/providers/plant_provider.dart';
import 'package:soldoza_app/providers/project_provider.dart';
import 'package:soldoza_app/providers/zone_provider.dart';
import 'package:soldoza_app/providers/zubzone_provider.dart';
import 'package:soldoza_app/theme/app_theme.dart';
import 'package:intl/intl.dart';
import 'dart:convert';

class FilterScreen extends StatefulWidget {
  const FilterScreen({Key? key}) : super(key: key);

  @override
  State<FilterScreen> createState() => _FilterScreenState();
}

class _FilterScreenState extends State<FilterScreen> {
  DateTime date = DateTime.now();

  DateTime limitDate = DateTime.now();
  final DateFormat formatter = DateFormat('yyyy-MM-dd');

  final myController = TextEditingController();

  bool _sliderEnable = false;

  List<XFile> images = [];

  Future pickImage() async {
    try {
      final imagesp = await ImagePicker().pickMultiImage();

      if (imagesp == null) return;

      for (var img in imagesp) {
        final imageTemp = XFile(img.path);

        images.add(imageTemp);
      }

      setState(() {});
    } on PlatformException catch (e) {
      print('Failed to pick image: $e');
    }
  }

  Future takePhoto() async {
    try {
      final imagep = await ImagePicker().pickImage(source: ImageSource.camera);

      if (imagep == null) return;

      final imageTemp = XFile(imagep.path);

      // print(imageTemp.path);
      // print(image);

      images.add(imageTemp);
      // print(image);

      setState(() {});
    } on PlatformException catch (e) {
      print('Failed to pick image: $e');
    }
  }

  Future getLocation() async {
    Location location = Location();

    bool serviceEnabled;
    PermissionStatus permissionGranted;
    LocationData locationData;

    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        return;
      }
    }

    permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    locationData = await location.getLocation();
    return locationData;
  }

  @override
  Widget build(BuildContext context) {
    final projectProvider = Provider.of<ProjectProvider>(context);
    final plantProvider = Provider.of<PlantProvider>(context);
    final zonesProvider = Provider.of<ZoneProvider>(context);
    final subzonesProvider = Provider.of<SubzoneProvider>(context);
    final incidenceProvider = Provider.of<IncidenceProvider>(context);
    final authProvider = Provider.of<AuthProvider>(context);
    final disciplineProvider = Provider.of<DisciplineProvider>(context);
    final categoryProvider = Provider.of<CategoryProvider>(context);

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 50),
        child: Column(
          children: [
            TextFormField(
              readOnly: true,
              decoration: const InputDecoration(label: Text("Incidence Day")),
              initialValue: formatter.format(date),
            ),
            dropProjects(projectProvider, plantProvider, zonesProvider,
                subzonesProvider, incidenceProvider),
            plantsDropDown(plantProvider, zonesProvider, subzonesProvider,
                incidenceProvider),
            zonesDropDown(zonesProvider, subzonesProvider, incidenceProvider),
            subzonesDropDown(subzonesProvider, incidenceProvider),
            disciplinesDropDown(
                disciplineProvider, categoryProvider, incidenceProvider),
            categoriesDropDown(categoryProvider, incidenceProvider),
            TextFormField(
              decoration:
                  const InputDecoration(label: Text("Incidence Description")),
              maxLines: 18,
              onChanged: (value) {
                IncidenceProvider.newIncidence["descripcionIncidencia"] = value;
              },
            ),
            TextFormField(
              decoration: const InputDecoration(label: Text("Required Action")),
              maxLines: 18,
              onChanged: (value) {
                IncidenceProvider.newIncidence["accionRequerida"] = value;
              },
            ),
            TextFormField(
              controller: myController,
              readOnly: true,
              decoration: const InputDecoration(
                  label: Text("Limit Date"),
                  suffixIcon: Icon(Icons.calendar_month_outlined)),
              onTap: () async {
                DateTime? newDate = await showDatePicker(
                    context: context,
                    initialDate: limitDate,
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2100));

                if (newDate == null) return;

                IncidenceProvider.newIncidence["fechaLimite"] =
                    formatter.format(newDate);
                setState(() {
                  myController.text = formatter.format(newDate);
                });
              },
            ),
            const SizedBox(
              height: 30,
            ),

            SwitchListTile.adaptive(
                value: _sliderEnable,
                title: const Text("Nonconformity"),
                onChanged: (value) {
                  _sliderEnable = value;
                  IncidenceProvider.newIncidence["esNoConformidad"] = value;
                  IncidenceProvider.newIncidence["codigoNC"] = '';
                  setState(() {});
                }),
            if(_sliderEnable)
            TextFormField(
              decoration: const InputDecoration(label: Text("Nonconformity Code")),
              onChanged: (value) {
                IncidenceProvider.newIncidence["codigoNC"] = value;
              },
            ),
            const SizedBox(
              height: 30,
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(
                    onPressed: () async {
                      await pickImage();
                    },
                    child: const Text("Image Gallery")),
                ElevatedButton(
                    onPressed: () async {
                      await takePhoto();
                    },
                    child: const Text("Take Photo")),
                ElevatedButton(
                    onPressed: () async {
                      images = [];
                      setState(() {});
                    },
                    child: const Icon(Icons.delete)),
              ],
            ),

            const SizedBox(
              height: 30,
            ),

            if (images.isEmpty) const Text("No images selected"),

            // if(images.isNotEmpty)
            // images.map((i) => Text(""))

            if (images.isNotEmpty)
              for (var i in images)
                Padding(
                  padding: const EdgeInsets.only(bottom: 15),
                  child: Image.file(
                    File(i.path),
                    width: double.infinity,
                    height: 350,
                    fit: BoxFit.cover,
                  ),
                ),

            const SizedBox(
              height: 30,
            ),
            ElevatedButton(
                onPressed: incidenceProvider.isLoading
                    ? null
                    : () async {
                        IncidenceProvider.newIncidence["fechaIncidencia"] =
                            formatter.format(date);

                        IncidenceProvider.newIncidence["usuarioCreador"] =
                            authProvider.userMap["id"];


                        print(IncidenceProvider.newIncidence);

                        if (IncidenceProvider.newIncidence["proyecto"] ==
                            null) {
                          await _showMyDialog(context, "Project Missing",
                              "Please select a project");
                          return;
                        }

                        if (IncidenceProvider.newIncidence["instalacion"] ==
                            null) {
                          await _showMyDialog(context, "Instalation Missing",
                              "Please select a Instalation");
                          return;
                        }

                        if (IncidenceProvider.newIncidence["zona"] == null) {
                          await _showMyDialog(
                              context, "Zone Missing", "Please select a Zone");
                          return;
                        }

                        if (IncidenceProvider.newIncidence["subZona"] == null) {
                          await _showMyDialog(context, "Subzone Missing",
                              "Please select a Subzone");
                          return;
                        }

                        if (IncidenceProvider.newIncidence["disciplina"] ==
                            null) {
                          await _showMyDialog(context, "Discipline Missing",
                              "Please select a Discipline");
                          return;
                        }

                        if (IncidenceProvider.newIncidence["categorias"] ==
                            null) {
                          await _showMyDialog(context, "Category Missing",
                              "Please select a Category");
                          return;
                        }

                        if (IncidenceProvider
                                .newIncidence["descripcionIncidencia"] ==
                            "") {
                          await _showMyDialog(context, "Description Missing",
                              "Please enter a Description");
                          return;
                        }

                        if (IncidenceProvider.newIncidence["accionRequerida"] ==
                            "") {
                          await _showMyDialog(
                              context,
                              "Required Action Missing",
                              "Please enter a Required Action");
                          return;
                        }

                        if (IncidenceProvider.newIncidence["fechaLimite"] ==
                            null) {
                          await _showMyDialog(context, "Limit Date Missing",
                              "Please select a Limit Date");
                          return;
                        }

                        final response =
                            await incidenceProvider.postIncidence();

                        LocationData location = await getLocation();

                        final Map<String, dynamic> inci =
                            json.decode(response.body);

                        final imageResponse =
                            await incidenceProvider.postImages(
                                images,
                                inci["id"],
                                location.latitude.toString(),
                                location.longitude.toString(),
                                authProvider.userMap["id"]);

                        if (response.statusCode == 201) {
                          Fluttertoast.showToast(
                              msg: "Incidence Saved",
                              backgroundColor: Colors.green);
                          if (!mounted) return;
                          Navigator.pushNamed(context, 'home');
                        } else {
                          Fluttertoast.showToast(
                              msg: "Error", backgroundColor: Colors.red);
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
                    "Save",
                    style: TextStyle(fontSize: 18),
                  ),
                )),
          ],
        ),
      ),
    );
  }

  Widget dropProjects(
      ProjectProvider projectProvider,
      PlantProvider plantProvider,
      ZoneProvider zonesProvider,
      SubzoneProvider subzonesProvider,
      IncidenceProvider incidenceProvider) {
    if (projectProvider.isLoading) {
      return const Center(child: CircularProgressIndicator());
    } else {
      return DropdownButtonFormField<int>(
          decoration: const InputDecoration(label: Text("Projects:")),
          items: projectProvider.projects
              .map((e) =>
                  DropdownMenuItem(value: e.id, child: Text(e.codProyecto)))
              .toList(),
          onChanged: (value) async {
            if (value != IncidenceProvider.newIncidence['proyecto']) {
              IncidenceProvider.newIncidence['proyecto'] = value;
              IncidenceProvider.newIncidence['instalacion'] = null;
              IncidenceProvider.newIncidence['zona'] = null;
              IncidenceProvider.newIncidence['subZona'] = null;

              plantProvider.plants = [];
              zonesProvider.zones = [];
              subzonesProvider.subzones = [];
              await projectProvider.changeClient(value!);
              await plantProvider.getPlantByProjectId(value);
            }
          });
    }
  }

  Widget plantsDropDown(PlantProvider plantProvider, ZoneProvider zoneProvider,
      SubzoneProvider subzoneProvider, IncidenceProvider incidenceProvider) {
    if (plantProvider.isLoading) {
      return const SizedBox(
        width: double.infinity,
        child: Center(child: CircularProgressIndicator()),
      );
    } else {
      return DropdownButtonFormField<int>(
        decoration: const InputDecoration(label: Text("Instalations:")),
        items: plantProvider.plants
            .map((e) => DropdownMenuItem(
                value: e.id, child: Text(e.descripcionInstalacion)))
            .toList(),
        onChanged: (value) async {
          if (value != IncidenceProvider.newIncidence['instalacion']) {
            IncidenceProvider.newIncidence['instalacion'] = value;
            IncidenceProvider.newIncidence['zona'] = null;
            IncidenceProvider.newIncidence['subZona'] = null;
            subzoneProvider.subzones = [];
            await zoneProvider.getZonesByPlantId(value!);
          }
        },
      );
    }
  }

  Widget zonesDropDown(ZoneProvider zoneProvider,
      SubzoneProvider subzoneProvider, IncidenceProvider incidenceProvider) {
    if (zoneProvider.isLoading) {
      return const SizedBox(
        width: double.infinity,
        child: Center(child: CircularProgressIndicator()),
      );
    } else {
      return DropdownButtonFormField<int>(
        decoration: const InputDecoration(label: Text("Zones:")),
        items: zoneProvider.zones
            .map((e) => DropdownMenuItem(
                value: e.id,
                child: Text('${e.codZona} - ${e.descripcionZona}')))
            .toList(),
        onChanged: (value) async {
          if (value != IncidenceProvider.newIncidence['zona']) {
            IncidenceProvider.newIncidence['zona'] = value;
            IncidenceProvider.newIncidence['subZona'] = null;
            await subzoneProvider.getSubzonesByZoneId(value!);
          }
        },
      );
    }
  }

  Widget subzonesDropDown(
      SubzoneProvider subzoneProvider, IncidenceProvider incidenceProvider) {
    if (subzoneProvider.isLoading) {
      return const SizedBox(
        width: double.infinity,
        child: Center(child: CircularProgressIndicator()),
      );
    } else {
      return DropdownButtonFormField<int>(
        decoration: const InputDecoration(label: Text("Subzones:")),
        items: subzoneProvider.subzones
            .map((e) => DropdownMenuItem(
                value: e.id,
                child: Text('${e.codSubzona} - ${e.descripcionSubzona}')))
            .toList(),
        onChanged: (value) {
          if (value != IncidenceProvider.newIncidence['subZona']) {
            IncidenceProvider.newIncidence['subZona'] = value;
          }
        },
      );
    }
  }

  Widget disciplinesDropDown(DisciplineProvider disciplineProvider,
      CategoryProvider categoryProvider, IncidenceProvider incidenceProvider) {
    if (disciplineProvider.isLoading) {
      return const SizedBox(
        width: double.infinity,
        child: Center(child: CircularProgressIndicator()),
      );
    } else {
      return DropdownButtonFormField<int>(
        decoration: const InputDecoration(label: Text("Disciplines: ")),
        items: disciplineProvider.disciplines
            .map((e) => DropdownMenuItem(
                value: e.id,
                child: Text('${e.codDisciplina} - ${e.descripcionDisciplina}')))
            .toList(),
        onChanged: (value) async {
          if (value != IncidenceProvider.newIncidence['disciplina']) {
            IncidenceProvider.newIncidence['disciplina'] = value;
            await categoryProvider.getCategoriesbyDisciplineId(value!);
            // await subzoneProvider.getSubzonesByZoneId(value!);
          }
        },
      );
    }
  }

  Widget categoriesDropDown(
      CategoryProvider categoryProvider, IncidenceProvider incidenceProvider) {
    if (categoryProvider.isLoading) {
      return const SizedBox(
        width: double.infinity,
        child: Center(child: CircularProgressIndicator()),
      );
    } else {
      return MultiSelectDialogField(
        items: categoryProvider.items,
        title: const Text("Categories"),
        // selectedColor: Colors.blue,

        buttonIcon: const Icon(
          Icons.arrow_downward_outlined,
          // color: Colors.blue,
        ),
        buttonText: const Text(
          "Categories",
          style: TextStyle(
            // color: Colors.blue[800],
            fontSize: 16,
          ),
        ),
        onConfirm: (results) {
          IncidenceProvider.newIncidence["categorias"] = results;
        },
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
