import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';
import 'package:soldoza_app/global_variables.dart';
import 'package:soldoza_app/models/incidence.dart';
import 'package:soldoza_app/providers/auth_provider.dart';
import 'package:soldoza_app/providers/incidence_provider.dart';

class DetailsScreen extends StatefulWidget {
  const DetailsScreen({Key? key}) : super(key: key);

  @override
  State<DetailsScreen> createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
  File? image;

  List<XFile> images = [];

  String incidenceComment = '';
  String incidenceCorrectComment = '';

  bool sliderEnable = false;
  String codigoNCR = '';

  int userId = Global.userMap['id'];
  final DateFormat formatter = DateFormat('yyyy-MM-dd');

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

      images.add(imageTemp);

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

    final AuthProvider authProvider = Provider.of<AuthProvider>(context);
    final IncidenceProvider incidenceProvider =
        Provider.of<IncidenceProvider>(context);

    return Scaffold(
        appBar: AppBar(
          title: Text(
            '${incidence.codIncidente}',
            overflow: TextOverflow.ellipsis,
          ),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _customLabel("WO Number: "),
                _customValue(incidence.codIncidente!),

                if (incidence.esNoConformidad!) _noConformidad(incidence),

                _customLabel("Description: "),
                _customValue(incidence.descripcionIncidencia!),
                _customLabel("Required Action: "),
                _customValue(incidence.accionRequerida!),
                _customLabel("WO Date: "),
                _customValue(
                    incidence.fechaIncidencia!.toString().substring(0, 10)),
                _customLabel("Expiration Date: "),
                _customValue(
                    incidence.fechaLimite!.toString().substring(0, 10)),
                _customLabel("Customer"),
                _customValue(incidence.proyecto!.cliente!.codCliente!),
                _customLabel("Project"),
                _customValue(
                    "${incidence.proyecto!.codProyecto} - ${incidence.proyecto!.descripcionProyecto}"),
                _customLabel("Installation"),
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

                // if (incidence.fotos!.isNotEmpty)
                //   Column(
                //     crossAxisAlignment: CrossAxisAlignment.start,
                //     children: [
                //       _customLabel("Latitude - Longitude"),
                //       _customValue(
                //           "${incidence.fotos![0].latitud}      ${incidence.fotos![0].longitud}"),
                //     ],
                //   ),

                _customLabel("Status"),
                _customValue(
                    "${incidence.estado!.codEstado} - ${incidence.estado!.descripcionEstado}"),
                _customLabel("Commet"),
                _customValue(incidence.comentarioReceptor == ''
                    ? 'There is not comment'
                    : incidence.comentarioReceptor!),
                _customLabel("Corrected"),
                _customValue(incidence.resultadoReceptor == ''
                    ? 'There is not corrected'
                    : incidence.resultadoReceptor!),
                const SizedBox(
                  height: 18,
                ),
                _emisorImages(incidence),
                const SizedBox(
                  height: 18,
                ),
                _receptorImages(incidence),

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

                if (authProvider.userMap["userType"]["id"] == 1 &&
                    authProvider.userMap["role"]["id"] != 3 &&
                    incidence.esNoConformidad! == false &&
                    incidence.estado!.id == 1)
                  _ncr(context, incidenceProvider, incidence),

                if (authProvider.userMap["userType"]["id"] == 1 &&
                    authProvider.userMap["role"]["id"] != 3 &&
                    incidence.estado!.id == 1)
                  _accepted(context, incidenceProvider, incidence),

                if (authProvider.userMap["userType"]["id"] == 2 &&
                    authProvider.userMap["role"]["id"] != 3 &&
                    incidence.estado!.id == 2)
                  _received(context, incidenceProvider, incidence),

                if (authProvider.userMap["userType"]["id"] == 2 &&
                    incidence.estado!.id == 4)
                  _comment(context, incidenceProvider, incidence),

                if (authProvider.userMap["userType"]["id"] == 2 &&
                    incidence.estado!.id == 5)
                  _correct(context, incidenceProvider, incidence, authProvider),

                if (authProvider.userMap["userType"]["id"] == 1 &&
                    authProvider.userMap["role"]["id"] != 3 &&
                    incidence.estado!.id == 6)
                  _close(context, incidenceProvider, incidence),
              ],
            ),
          ),
        ));
  }

  Widget _ncr(BuildContext context, IncidenceProvider incidenceProvider,
      Incidence incidence) {
    return Column(
      children: [
        SwitchListTile.adaptive(
            value: sliderEnable,
            title: const Text("NCR"),
            onChanged: (value) {
              sliderEnable = value;
              // IncidenceProvider.newIncidence["esNoConformidad"] = value;
              codigoNCR = '';
              setState(() {});
            }),
        if (sliderEnable)
          TextFormField(
            decoration: const InputDecoration(label: Text("NCR Code")),
            onChanged: (value) {
              codigoNCR = value;
            },
          ),
        const SizedBox(
          height: 18,
        ),
        ElevatedButton(
            style: ElevatedButton.styleFrom(
              primary: Colors.red,
            ),
            onPressed: incidenceProvider.isLoading == true
                ? null
                : () async {
                    FocusScopeNode currentFocus = FocusScope.of(context);
                    if (!currentFocus.hasPrimaryFocus) {
                      currentFocus.unfocus();
                    }

                    if (codigoNCR == '') {
                      await _showMyDialogRequired(
                          context, "NCR code Missing", "Please add a NCR code");
                      return;
                    }

                    var r = await _showMyDialog(context, "Confirm Action",
                        "Sure you want to CHANGE TO NCR this WO?");

                    if (r == 'ok') {
                      Map<String, dynamic> fields = {
                        "esNoConformidad": sliderEnable,
                        "codigoNC": codigoNCR
                      };

                      await incidenceProvider.updateFields(
                          fields, incidence.id.toString());
                      Fluttertoast.showToast(
                          msg: "WO is an NRC", backgroundColor: Colors.green);

                      if (!mounted) return;
                      Navigator.pushNamed(context, 'home');
                    }
                  },
            child: const Text("Change to NRC")),
        const SizedBox(
          height: 36,
        ),
      ],
    );
  }

  Widget _accepted(BuildContext context, IncidenceProvider incidenceProvider,
      Incidence incidence) {
    return Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
      ElevatedButton(
          style: ElevatedButton.styleFrom(
            primary: Colors.green,
          ),
          onPressed: incidenceProvider.isLoading == true
              ? null
              : () async {
                  var r = await _showMyDialog(context, "Confirm Action",
                      "Sure you want to ACCEPT this WO?");

                  if (r == 'ok') {
                    DateTime date = DateTime.now();

                    Map<String, dynamic> fields = {
                      "estado": 2,
                      "usuarioApproved": userId,
                      "fechaApproved": formatter.format(date)
                    };

                    await incidenceProvider.updateFields(
                        fields, incidence.id.toString());
                    Fluttertoast.showToast(
                        msg: "WO State Updated", backgroundColor: Colors.green);

                    if (!mounted) return;
                    Navigator.pushNamed(context, 'home');
                  }
                },
          child: const Text("Accept")),
      ElevatedButton(
          style: ElevatedButton.styleFrom(
            primary: Colors.red,
          ),
          onPressed: incidenceProvider.isLoading == true
              ? null
              : () async {
                  var r = await _showMyDialog(context, "Confirm Action",
                      "Sure you want to REJECT this WO?");

                  if (r == 'ok') {
                    DateTime date = DateTime.now();

                    Map<String, dynamic> fields = {
                      "estado": 3,
                      "usuarioRejected": userId,
                      "fechaRejected": formatter.format(date)
                    };

                    await incidenceProvider.updateFields(
                        fields, incidence.id.toString());
                    Fluttertoast.showToast(
                        msg: "WO State Updated", backgroundColor: Colors.green);

                    if (!mounted) return;
                    Navigator.pushNamed(context, 'home');
                  }
                },
          child: const Text("Reject")),
    ]);
  }

  Widget _received(BuildContext context, IncidenceProvider incidenceProvider,
      Incidence incidence) {
    return Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
      ElevatedButton(
          style: ElevatedButton.styleFrom(
            primary: Colors.green,
          ),
          onPressed: incidenceProvider.isLoading == true
              ? null
              : () async {
                  var r = await _showMyDialog(context, "Confirm Action",
                      "Sure you want to RECEIVE this WO?");

                  if (r == 'ok') {
                    DateTime date = DateTime.now();

                    Map<String, dynamic> fields = {
                      "estado": 4,
                      "usuarioReceived": userId,
                      "fechaReceived": formatter.format(date)
                    };

                    await incidenceProvider.updateFields(
                        fields, incidence.id.toString());
                    Fluttertoast.showToast(
                        msg: "WO State Updated", backgroundColor: Colors.green);

                    if (!mounted) return;
                    Navigator.pushNamed(context, 'home');
                  }
                },
          child: const Text("Receive")),
    ]);
  }

  Widget _comment(BuildContext context, IncidenceProvider incidenceProvider,
      Incidence incidence) {
    return Column(
      children: [
        Align(
            alignment: Alignment.centerLeft, child: _customLabel("Comment: ")),
        TextFormField(
          decoration: const InputDecoration(label: Text("Required Comment")),
          maxLines: 18,
          onChanged: (value) {
            incidenceComment = value;
          },
        ),
        const SizedBox(
          height: 20,
        ),
        ElevatedButton(
            onPressed: incidenceProvider.isLoading
                ? null
                : () async {
                    FocusScopeNode currentFocus = FocusScope.of(context);

                    if (!currentFocus.hasPrimaryFocus) {
                      currentFocus.unfocus();
                    }
                    if (incidenceComment == '') {
                      await _showMyDialogRequired(
                          context, "Comment Missing", "Please add a Comment");
                      return;
                    }

                    var r = await _showMyDialog(context, "Confirm Action",
                        "Sure you want to COMMENT this WO?");

                    if (r == 'ok') {
                      DateTime date = DateTime.now();

                      Map<String, dynamic> fields = {
                        "comentarioReceptor": incidenceComment,
                        "estado": 5,
                        "usuarioCommented": userId,
                        "fechaCommented": formatter.format(date)
                      };

                      await incidenceProvider.updateFields(
                          fields, incidence.id.toString());
                      Fluttertoast.showToast(
                          msg: "WO State Updated",
                          backgroundColor: Colors.green);

                      if (!mounted) return;
                      Navigator.pushNamed(context, 'home');
                    }
                  },

            // child: Text("go"),
            style: ButtonStyle(
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18.0),
              )),
              backgroundColor: MaterialStateProperty.all<Color>(Colors.green),
            ),
            child: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
              child: Text(
                "Comment",
                style: TextStyle(fontSize: 15),
              ),
            )),
        const SizedBox(
          height: 30,
        )
      ],
    );
  }

  Widget _correct(BuildContext context, IncidenceProvider incidenceProvider,
      Incidence incidence, AuthProvider authProvider) {
    return Column(
      children: [
        Align(
            alignment: Alignment.centerLeft,
            child: _customLabel("Corrected: ")),
        TextFormField(
          decoration: const InputDecoration(label: Text("Required Corrected")),
          maxLines: 18,
          onChanged: (value) {
            incidenceCorrectComment = value;
          },
        ),
        const SizedBox(
          height: 20,
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
                    FocusScopeNode currentFocus = FocusScope.of(context);

                    if (!currentFocus.hasPrimaryFocus) {
                      currentFocus.unfocus();
                    }
                    if (incidenceCorrectComment == '') {
                      await _showMyDialogRequired(context, "Corrected Missing",
                          "Please add a Corrected");
                      return;
                    }

                    var r = await _showMyDialog(context, "Confirm Action",
                        "Sure you want to CORRECT this WO?");

                    if (r == 'ok') {
                      DateTime date = DateTime.now();

                      Map<String, dynamic> fields = {
                        "resultadoReceptor": incidenceCorrectComment,
                        "estado": 6,
                        "usuarioCorrected": userId,
                        "fechaCorrected": formatter.format(date)
                      };

                      await incidenceProvider.updateFields(
                          fields, incidence.id.toString());

                      LocationData location = await getLocation();

                      if (images.isNotEmpty) {
                        await incidenceProvider.postImages(
                            images,
                            incidence.id,
                            location.latitude.toString(),
                            location.longitude.toString(),
                            authProvider.userMap["id"]);
                      }

                      Fluttertoast.showToast(
                          msg: "WO State Updated",
                          backgroundColor: Colors.green);

                      if (!mounted) return;
                      Navigator.pushNamed(context, 'home');
                    }
                  },
            // child: Text("go"),
            style: ButtonStyle(
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18.0),
              )),
              backgroundColor: MaterialStateProperty.all<Color>(Colors.green),
            ),
            child: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
              child: Text(
                "Correct",
                style: TextStyle(fontSize: 15),
              ),
            )),
        const SizedBox(
          height: 30,
        )
      ],
    );
  }

  Widget _close(BuildContext context, IncidenceProvider incidenceProvider,
      Incidence incidence) {
    return Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
      ElevatedButton(
          style: ElevatedButton.styleFrom(
            primary: Colors.green,
          ),
          onPressed: incidenceProvider.isLoading == true
              ? null
              : () async {
                  var r = await _showMyDialog(context, "Confirm Action",
                      "Sure you want to CLOSE this WO?");

                  if (r == 'ok') {
                    DateTime date = DateTime.now();

                    Map<String, dynamic> fields = {
                      "estado": 7,
                      "usuarioClosed": userId,
                      "fechaClosed": formatter.format(date)
                    };

                    await incidenceProvider.updateFields(
                        fields, incidence.id.toString());
                    Fluttertoast.showToast(
                        msg: "WO State Updated", backgroundColor: Colors.green);

                    if (!mounted) return;
                    Navigator.pushNamed(context, 'home');
                  }
                },
          child: const Text("Close")),
    ]);
  }

  Widget _noConformidad(Incidence incidence) => Padding(
        padding: const EdgeInsets.only(bottom: 5),
        child: ClipRRect(
            borderRadius: BorderRadius.circular(5.0),
            child: Text(
              'NCR Code:  ${incidence.codigoNc!}',
              style: const TextStyle(
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
      return const Text("There were no images transmitted.");
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
              child: Column(
                children: [
                  FadeInImage(
                    image: NetworkImage(img.fotoUrl!),
                    placeholder: const AssetImage("assets/jar-loading.gif"),
                    width: double.infinity,
                    height: 350,
                    fit: BoxFit.cover,
                  ),
                  Text("Lat - Lng: ${img.latitud}    ${img.longitud}")
                ],
              ),
            ),
        ],
      );
    }
  }

  Widget _receptorImages(Incidence incidence) {
    final List<Foto> emisorImages = [];

    for (var img in incidence.fotos!) {
      if (img.usuario!.tipoUsuario!.id == 2) {
        emisorImages.add(img);
      }
    }

    if (emisorImages.isEmpty) {
      return const Text("There were no images recived.");
    } else {
      return Column(
        children: [
          _customLabel("Receiver Images"),
          const SizedBox(
            height: 18,
          ),
          for (var img in emisorImages)
            Padding(
              padding: const EdgeInsets.only(bottom: 15),
              child: Column(
                children: [
                  FadeInImage(
                    image: NetworkImage(img.fotoUrl!),
                    placeholder: const AssetImage("assets/jar-loading.gif"),
                    width: double.infinity,
                    height: 350,
                    fit: BoxFit.cover,
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Text("Lat - Lng: ${img.latitud}    ${img.longitud}")
                ],
              ),
            ),
        ],
      );
    }
  }

  Future _showMyDialog(
      BuildContext context, String title, String content) async {
    return showDialog<String>(
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
                Navigator.pop(context, "ok");
              },
            ),
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.pop(context, "cancel");
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _showMyDialogRequired(
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
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
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
}
