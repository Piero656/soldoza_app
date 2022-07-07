import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:soldoza_app/models/incidence.dart';

class DetailsScreen extends StatefulWidget {
  const DetailsScreen({Key? key}) : super(key: key);

  @override
  State<DetailsScreen> createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
  File? image;

  Future pickImage() async {
    try {
      final imagep = await ImagePicker().pickImage(source: ImageSource.gallery);

      if (imagep == null) return;

      final imageTemp = File(imagep.path);

      image = imageTemp;

      setState(() {});
    } on PlatformException catch (e) {
      print('Failed to pick image: $e');
    }
  }

  bool loadingEmisorPhotos = true;

  @override
  Widget build(BuildContext context) {
    final Incidence incidence =
        ModalRoute.of(context)?.settings.arguments as Incidence;
// print(incidence.fotos![0].fotoUrl.toString());

    return Scaffold(
        appBar: AppBar(
          title: Text(
            'Incidence ${incidence.codIncidente}',
            overflow: TextOverflow.ellipsis,
          ),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _customLabel("Cod Incidence: "),
                _customValue(incidence.codIncidente!),

                if (incidence.esNoConformidad!) _noConformidad(incidence),

                _customLabel("Description: "),
                _customValue(incidence.descripcionIncidencia!),
                _customLabel("Required Action: "),
                _customValue(incidence.accionRequerida!),
                _customLabel("Creation Date: "),
                _customValue(
                    incidence.fechaIncidencia!.toString().substring(0, 10)),
                _customLabel("Limit Date: "),
                _customValue(
                    incidence.fechaLimite!.toString().substring(0, 10)),
                _customLabel("Client"),
                _customValue(incidence.proyecto!.cliente!.codCliente!),
                _customLabel("Project"),
                _customValue(
                    "${incidence.proyecto!.codProyecto} - ${incidence.proyecto!.descripcionProyecto}"),
                _customLabel("Instalation"),
                _customValue(
                    "${incidence.instalacion!.codInstalacion} - ${incidence.instalacion!.descripcionInstalacion}"),
                _customLabel("Zone"),
                _customValue(
                    "${incidence.zona!.codZona} - ${incidence.zona!.descripcionZona}"),
                _customLabel("Sub Zone"),
                _customValue(
                    "${incidence.subZona!.codSubzona} - ${incidence.subZona!.descripcionSubzona}"),
                _customLabel("Discipline"),
                _customValue(
                    "${incidence.disciplina!.codDisciplina!} - ${incidence.disciplina!.descripcionDisciplina!}"),
                _customLabel("Categories"),
                _displayCategories(incidence),

                if (incidence.fotos!.isNotEmpty)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _customLabel("Latitude - Longitude"),
                      _customValue(
                          "${incidence.fotos![0].latitud}      ${incidence.fotos![0].longitud}"),
                    ],
                  ),

                _customLabel("Status"),
                _customValue(
                    "${incidence.estado!.codEstado} - ${incidence.estado!.descripcionEstado}"),
                const SizedBox(
                  height: 18,
                ),
                _emisorImages(incidence),

                // ElevatedButton(
                //     onPressed: () async {
                //       await pickImage();
                //     },
                //     child: Text("Pick Image")),
                // image != null
                //     ? Image.file(
                //         image!,
                //         width: 160,
                //         height: 160,
                //         fit: BoxFit.cover,
                //       )
                //     : const FlutterLogo(
                //         size: 160,
                //       ),
                const SizedBox(height: 45),
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                          onPressed: () async {
                            await _showMyDialog(context, "Confirm Action",
                                "Sure you want to accept this indicence?");
                          },
                          child: const Text("Si")),
                      ElevatedButton(onPressed: () {}, child: const Text("No")),
                    ]),
              ],
            ),
          ),
        ));
  }

  Widget _noConformidad(Incidence incidence) => Padding(
        padding: const EdgeInsets.only(bottom: 5),
        child: ClipRRect(
            borderRadius: BorderRadius.circular(5.0),
            child: Text(
              'Nonconformity Code:  ${incidence.codigoNc!}',
              style: TextStyle(
                backgroundColor: Colors.redAccent,
                fontSize: 18,
              ),
            )),
      );

  Widget _customValue(String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: SelectableText(
        value,
        style: const TextStyle(fontSize: 15),
        textAlign: TextAlign.justify,
      ),
    );
  }

  Widget _customLabel(String titulo) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 5),
      child: SelectableText(
        titulo,
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
      ),
    );
  }

  Widget _displayCategories(Incidence incidence) {
    if (incidence.incidenteCategorias!.isEmpty) {
      return const Text("No tiene Categorias");
    } else {
      return Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: Row(
          children: [
            for (var cat in incidence.incidenteCategorias!)
              SelectableText(
                  "${cat.categoria.codCategoria!} - ${cat.categoria.descripcionCategoria!} | ")
          ],
        ),
      );
    }
  }

  Widget _emisorImages(Incidence incidence) {
    final List<Foto> emisorImages = [];

    for (var img in incidence.fotos!) {
      if (img.usuario!.tipoUsuario!.id == 1) {
        emisorImages.add(img);
      }
    }

    if (emisorImages.isEmpty) {
      return const Text("There is not transmitter images.");
    } else {
      return Column(
        children: [
          _customLabel("Transmitter Images"),
          const SizedBox(
            height: 18,
          ),
          for (var img in emisorImages)
            Padding(
              padding: const EdgeInsets.only(bottom: 15),
              child: FadeInImage(
                image: NetworkImage(img.fotoUrl!),
                placeholder: const AssetImage("assets/jar-loading.gif"),
                width: double.infinity,
                height: 350,
                fit: BoxFit.cover,
              ),
            ),
        ],
      );
    }
  }

  Future<void> _showMyDialog(
      BuildContext context, String title, String content) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
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
              child: const Text('Confirm'),
              onPressed: () {
                print('Confirmed');
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Cancel'),
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
