import 'dart:convert';

import 'package:flutter/material.dart';

import '../repositories/repo_unidades_despacho.dart';
import '../repositories/security_data.dart';
import '../utils/dimens.dart';

class UnidadesDespachoPage extends StatefulWidget {
  UnidadesDespachoPage({super.key});

  SecurityData oS = new SecurityData();
  var datosBuses;
  TextEditingController _numImputController = TextEditingController();

  @override
  State<UnidadesDespachoPage> createState() => _UnidadesDespachoPageState();
}

class _UnidadesDespachoPageState extends State<UnidadesDespachoPage> {
  int position = 0;
  List<String> lista_unidad = [];
  List<String> lista_unidadCompleta = [];
  String _unidad = "";
  bool isUnidad = true;

  @override
  void initState() {
    super.initState();
    updateListaUnidades();
    print("Longitud de lista_unidad en initState: ${lista_unidad.length}");
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          elevation: 1,
          title: Text("Unidades Despacho"),
          backgroundColor: Colors.blue,
          foregroundColor: Colors.white,
        ),
        body: Column(
          children: [
            Container(
              margin: const EdgeInsets.only(
                right: marginSmallSmall,
                left: marginSmallSmall,
                top: marginSmallSmall,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Flexible(
                    child: TextFormField(
                      controller: widget._numImputController,
                      onChanged: (value) {
                        setState(() {
                          // Si el campo de texto está vacío, restaurar la lista completa
                          if (value.isEmpty) {
                            lista_unidad =
                                lista_unidadCompleta; // Reemplaza lista_unidadCompleta con tu lista original completa
                          } else {
                            // Si hay texto en el campo de texto, filtrar la lista
                            lista_unidad = _filterList(value);
                          }
                        });
                      },
                      decoration: const InputDecoration(
                        hintText: 'Buscar',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            const Divider(height: 1, color: Colors.grey),
            Expanded(
              // Envuelve el ListView con un Expanded
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(vertical: 20),
                itemCount: lista_unidad.length,
                separatorBuilder: (context, index) =>
                    const Divider(height: 1, color: Colors.grey),
                itemBuilder: (context, index) {
                  final unidad = lista_unidad[index];
                  return GestureDetector(
                    onTap: () {
                      widget._numImputController.text = unidad;
                      _unidad = unidad;
                      Navigator.pop(context, _unidad);
                      // Puedes realizar otras acciones aquí según sea necesario
                    },
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      margin: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: Row(
                        children: [
                          Image.asset('assets/online_lista.png', width: 19),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              unidad,
                              style: const TextStyle(fontSize: 18),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<String> _filterList(String query) {
    return lista_unidad
        .where((unidad) => unidad.toLowerCase().contains(query.toLowerCase()))
        .toList();
  }

  Future<void> updateListaUnidades() async {
    lista_unidad.clear();
    lista_unidadCompleta.clear();

    ApiRepositorioUnidadesDespacho service = ApiRepositorioUnidadesDespacho();

    var listabuses = await service.fectchUnidadesDespacho();

    /*  print('Aca datos listabuses ${widget.datosBuses.runtimeType}');
    print('Aca datos listabuses ${jsonEncode(listabuses)}'); */

    if (listabuses != null && listabuses.datos != null) {
      listabuses.datos!.forEach((element) {
        lista_unidad.add(element.codiVehi!);
      });
    }
    lista_unidadCompleta = [...lista_unidad];

    // Imprimir la longitud después de llenar la lista
    print("Longitud de lista_unidad: ${lista_unidad.length}");

    // Actualizar el estado después de llenar la lista
    setState(() {});
  }
}
