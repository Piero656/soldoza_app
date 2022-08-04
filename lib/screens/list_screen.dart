import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:soldoza_app/models/incidence.dart';
import 'package:soldoza_app/providers/incidence_provider.dart';
import 'package:intl/intl.dart';
import 'package:soldoza_app/theme/app_theme.dart';

class ListScreen extends StatelessWidget {
  const ListScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<Incidence> incidencias =
        ModalRoute.of(context)?.settings.arguments as List<Incidence>;

    final IncidenceProvider incidenceProvider =
        Provider.of<IncidenceProvider>(context);

    final DateFormat formatter = DateFormat('yyyy-MM-dd');

    return Scaffold(
      appBar: AppBar(
        title: const Text('Work Observations'),
      ),
      body: listOfIncidences(incidencias, incidenceProvider, formatter),
    );
  }

  Widget listOfIncidences(List<Incidence> incidencias,
      IncidenceProvider incidenceProvider, DateFormat formatter) {
    if (incidenceProvider.isLoading) {
      return const SizedBox(
        height: double.infinity,
        child: Center(
          child: CircularProgressIndicator(),
        ),
      );
    } else {
      return RefreshIndicator(
          onRefresh: () async {
            incidenceProvider.getIncidencesFilter();
          },
          child: ListView.builder(
            // physics: const BouncingScrollPhysics(),
            itemCount: incidencias.length,
            padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 25),
            itemBuilder: (context, index) {
              return Card(
                margin: const EdgeInsets.only(bottom: 15),
                clipBehavior: Clip.antiAlias,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25)),
                elevation: 10,
                child: InkWell(
                  splashColor: AppTheme.orangeColor,
                  onTap: () {
                    Navigator.pushNamed(context, 'details',
                        arguments: incidenceProvider.incidences[index]);
                  },
                  child: Container(
                      alignment: AlignmentDirectional.centerStart,
                      padding: const EdgeInsets.only(
                          right: 20, top: 10, bottom: 10, left: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                '${incidenceProvider.incidences[index].codIncidente}',
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 17),
                              ),
                              if (incidenceProvider
                                  .incidences[index].esNoConformidad!)
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(5.0),
                                  child: const Text(
                                    'NCR',
                                    style: TextStyle(
                                      backgroundColor: Colors.redAccent,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ClipRRect(
                                borderRadius: BorderRadius.circular(5.0),
                                child: Text(
                                  incidenceProvider.incidences[index].estado
                                          ?.codEstado ??
                                      'sin estado',
                                  style: TextStyle(
                                    backgroundColor: incidenceProvider
                                        .incidences[index]
                                        .getcolorState(),
                                    color: Colors.white,
                                  ),
                                ),
                              )
                            ],
                          ),
                          Text(
                            '${incidenceProvider.incidences[index].disciplina?.codDisciplina ?? 'Sin disiplina'} - ${incidenceProvider.incidences[index].descripcionIncidencia} ',
                            style: const TextStyle(fontSize: 15),
                            textAlign: TextAlign.justify,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            'Date: ${formatter.format(incidenceProvider.incidences[index].fechaIncidencia!)}  Due Date: ${formatter.format(incidenceProvider.incidences[index].fechaLimite!)}',
                            overflow: TextOverflow.ellipsis,
                          ),
                          // Row(
                          //   children: [
                          //     const Text("Date: "),
                          //     Text(formatter.format(incidenceProvider
                          //         .incidences[index].fechaIncidencia!)),
                          //     const SizedBox(
                          //       width: 10,
                          //     ),
                          //     const Text("Limit Date: "),
                          //     Text(
                          //       formatter.format(incidenceProvider
                          //           .incidences[index].fechaLimite!),
                          //       maxLines: 2,
                          //       overflow: TextOverflow.ellipsis,
                          //     ),
                          //   ],
                          // ),
                        ],
                      )),
                ),
              );
            },
          ));
    }
  }
}
