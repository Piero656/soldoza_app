import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:soldoza_app/providers/auth_provider.dart';
import 'package:soldoza_app/providers/incidence_provider.dart';
import 'package:soldoza_app/screens/filter_screen.dart';
import 'package:soldoza_app/screens/form_screen.dart';

import '../widgets/navigation_drawer.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedDrawerItem = 0;
  String _title = '';

  final List<String> nombres = ["uno", "dos", "tres"];

  _getDrawerItemWidget(int pos) {
    switch (pos) {
      case 0:
        return ListItems(
          nombres: nombres,
        );

      case 1:
        return const FormScreen();
      case 2:
        IncidenceProvider.newIncidence["proyecto"] = null;
        IncidenceProvider.newIncidence["instalacion"] = null;
        IncidenceProvider.newIncidence["zona"] = null;
        IncidenceProvider.newIncidence["subZona"] = null;
        IncidenceProvider.newIncidence["disciplina"] = null;
        IncidenceProvider.newIncidence["categorias"] = null;
        IncidenceProvider.newIncidence["usuarioCreador"] = null;
        IncidenceProvider.newIncidence["fechaIncidencia"] = null;
        IncidenceProvider.newIncidence["descripcionIncidencia"] = "";
        IncidenceProvider.newIncidence["accionRequerida"] = "";
        IncidenceProvider.newIncidence["fechaLimite"] = null;
        IncidenceProvider.newIncidence["esNoConformidad"] = false;
        IncidenceProvider.newIncidence["codigoNC"] = "";
        return const FilterScreen();

      default:
    }
  }

  _onSelectDrawerItem(int pos, String title) {
    Navigator.of(context).pop();
    setState(() {
      _selectedDrawerItem = pos;
      _title = title;
    });
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => showExitPopup(context),
      child: Scaffold(
          drawer: NavigationDrawer(setPosition: _onSelectDrawerItem),
          appBar: AppBar(
            title: Text(_title),
          ),
          body: _getDrawerItemWidget(_selectedDrawerItem)),
    );
  }

  Future<bool> showExitPopup(context) async {
    final authProvider = Provider.of<AuthProvider>(context);

    return await showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: SizedBox(
              height: 90,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Do you want to exit?"),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () async {
                            await authProvider.updateFirebaseToken(
                                '', authProvider.userMap['id'].toString());
                            SystemChannels.platform
                                .invokeMethod('SystemNavigator.pop');

                            // return true;
                          },
                          style: ElevatedButton.styleFrom(
                              primary: Colors.red.shade800),
                          child: const Text("Yes"),
                        ),
                      ),
                      const SizedBox(width: 15),
                      Expanded(
                          child: ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        style: ElevatedButton.styleFrom(
                          primary: Colors.white,
                        ),
                        child: const Text("No",
                            style: TextStyle(color: Colors.black)),
                      ))
                    ],
                  )
                ],
              ),
            ),
          );
        });
  }
}

class ListItems extends StatelessWidget {
  const ListItems({
    Key? key,
    required this.nombres,
  }) : super(key: key);

  final List<String> nombres;

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {},
      child: ListView.builder(
        // physics: const BouncingScrollPhysics(),
        itemCount: nombres.length,
        padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 25),
        itemBuilder: (context, index) {
          return Card(
            margin: const EdgeInsets.only(bottom: 15),
            clipBehavior: Clip.antiAlias,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
            elevation: 10,
            child: Column(
              children: [
                // FadeInImage(
                //   image: NetworkImage(imageUrl),
                //   placeholder: const AssetImage('assets/jar-loading.gif'),
                //   width: double.infinity,
                //   height: 300,
                //   fit: BoxFit.cover,
                //   fadeInDuration: const Duration(milliseconds: 300),
                // ),

                Container(
                  alignment: AlignmentDirectional.centerStart,
                  padding: const EdgeInsets.only(
                      right: 20, top: 10, bottom: 10, left: 20),
                  child: const Text("nombre"),
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
