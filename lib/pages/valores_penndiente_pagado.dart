import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import '../models/login/login_propietario.dart';
import '../models/valores_pendientes_pagados/data_valores_pendientes_pagados.dart';
import '../models/valores_pendientes_pagados/valores_pendientes_pagados.dart';
import '../repositories/repo_valores_pen_pag.dart';
import '../repositories/security_data.dart';
import '../utils/dimens.dart';
import 'mintarjetapdf.dart';

class ValoresPenPagados extends StatefulWidget {
  BuildContext? contextAlert;
  SecurityData oS = new SecurityData();
  TextEditingController _inputFieldDateController = new TextEditingController();
  List<DropdownMenuItem<String>> lista_unidades = [];
  List<DatoValoresPenPag> oListPagos = [];

  String _unidad = "";
  int position = 0;
  String groupCheckValue = "typeReport";
  double oDoublePagado = 0.00;
  double oDoublePendiente = 0.00;
  bool isCheckPagado = false;
  bool isCheckPendiente = false;
  String fechaInicial = "";
  String fechaFinal = "";

  ValoresPenPagados({super.key});

  @override
  State<ValoresPenPagados> createState() => _ValoresPenPagadosState();
}

class _ValoresPenPagadosState extends State<ValoresPenPagados> {
  ValoresPendientesPagadosAppMovil? datosValoresPP = null;

  @override
  void initState() {
    _getFechaActual();
    _ItemDropdownButton();
    super.initState();
  }

  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text("Valores Pendientes/Pagados"),
          elevation: 1,
          backgroundColor: Colors.blue,
          foregroundColor: Colors.white,
        ),
        body: Container(
          width: double.infinity,
          padding: const EdgeInsets.only(
            top: marginSmallSmall,
            right: marginSmallSmall,
            left: marginSmallSmall,
            bottom: marginSmallSmall,
          ),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Expanded(
                      flex: 2,
                      child: TextField(
                        autocorrect: false,
                        controller: widget._inputFieldDateController,
                        keyboardType: TextInputType.none,
                        showCursor: false,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                        ),
                        onTap: () {
                          FocusScope.of(context).requestFocus(new FocusNode());
                          showRagePicker();
                        },
                      ),
                    ),
                    SizedBox(width: 5),
                    Expanded(
                      child: InputDecorator(
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 5,
                            vertical: 4,
                          ),
                          disabledBorder: OutlineInputBorder(),
                        ),
                        child: DropdownButton<String>(
                          underline: Container(
                            height: 0,
                            color: Colors.transparent,
                          ),
                          value:
                              widget.lista_unidades.isNotEmpty
                                  ? widget.lista_unidades[widget.position].value
                                  : widget._unidad,
                          items: widget.lista_unidades,
                          onChanged: (String? value) {
                            setState(() {
                              widget._unidad = value!;
                              widget.position = getPosition(widget._unidad);
                            });
                          },
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                          Checkbox(
                            value: widget.isCheckPagado,
                            onChanged: (value) {
                              setState(() {
                                widget.isCheckPagado = value!;
                              });
                            },
                          ),
                          Text("R. PAGADOS"),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Row(
                        children: [
                          Checkbox(
                            value: widget.isCheckPendiente,
                            onChanged: (value) {
                              setState(() {
                                widget.isCheckPendiente = value!;
                              });
                            },
                          ),
                          Text("R. PENDIENTES"),
                        ],
                      ),
                    ),
                  ],
                ),
                ElevatedButton.icon(
                  onPressed: () {
                    print('On Press unidad >>> ${widget._unidad}');
                    print('On Press fechaI >>> ${widget.fechaInicial}');
                    print('On Press FechaF >>> ${widget.fechaFinal}');
                    setState(() {
                      datosValoresPP = new ValoresPendientesPagadosAppMovil(
                        statusCode: null,
                      );
                    });
                    llamarBloc();
                  },
                  icon: Icon(Iconsax.search_normal),
                  label: Text("Buscar", style: TextStyle(fontSize: textMedium)),
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.blue, // Texto blanco
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10), // Radio de 10
                    ),
                    minimumSize: Size.fromHeight(altoMedium),
                  ),
                ),
                SizedBox(height: marginSmallSmall),
                _getTotales(),
                SizedBox(height: marginSmallSmall),
                listPdf(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  showRagePicker() async {
    var date = DateTime.now();

    final DateTimeRange? newDateRange = await showDateRangePicker(
      context: context,
      initialDateRange: DateTimeRange(start: date, end: date),
      firstDate: DateTime(2020, 7),
      lastDate: DateTime(2050, 7),
      locale: const Locale('es'),
      helpText: 'Seleccione las Fechas',
    );

    if (newDateRange != null) {
      setState(() {
        widget.fechaInicial =
            newDateRange.start.year.toString() +
            "/" +
            newDateRange.start.month.toString() +
            "/" +
            newDateRange.start.day.toString();

        widget.fechaFinal =
            newDateRange.end.year.toString() +
            "/" +
            newDateRange.end.month.toString() +
            "/" +
            newDateRange.end.day.toString();

        widget._inputFieldDateController.text =
            widget.fechaInicial + " HASTA " + widget.fechaFinal;
      });
    }
  }

  _getFechaActual() {
    var date = DateTime.now();
    var year = date.year;
    var month = date.month < 10 ? "0" + date.month.toString() : date.month;
    var day = date.day < 10 ? "0" + date.day.toString() : date.day;
    setState(() {
      widget.fechaFinal =
          year.toString() + "/" + month.toString() + "/" + day.toString();
      widget.fechaInicial =
          year.toString() + "/" + month.toString() + "/" + day.toString();
      widget._inputFieldDateController.text =
          widget.fechaInicial + " HASTA " + widget.fechaFinal;
    });
  }

  _ItemDropdownButton() async {
    var jsonDataL = await widget.oS.readDataPreferenciasLoginPropietario(
      'dataLoginPropietarioLoginUnidadesd',
    );
    LoginPropietario listabuses = LoginPropietario.fromRawJson(jsonDataL);

    setState(() {
      listabuses.data!.forEach((element) {
        widget._unidad = listabuses.data!.elementAt(0).codiVehiObseVehi!;
        widget.lista_unidades.add(
          DropdownMenuItem<String>(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Image.asset('assets/online_lista.png', width: 19),
                Container(
                  margin: EdgeInsets.only(left: 10),
                  child: Text(' ${element.codiVehiObseVehi}'),
                ),
              ],
            ),
            value: element.codiVehiObseVehi,
          ),
        );
      });
    });
  }

  int getPosition(unidad) {
    for (int i = 0; i < widget.lista_unidades.length; i++) {
      print("POSITION UNIDAD : " + widget.lista_unidades[i].value!);
      if (widget.lista_unidades[i].value == unidad) {
        return i;
      }
    }
    return 0;
  }

  Widget _buildCard(
    BuildContext context,
    ValoresPendientesPagadosAppMovil model,
  ) {
    widget.oListPagos = model.datos!;
    return ListView.builder(
      itemCount: widget.oListPagos == null ? 0 : widget.oListPagos.length,
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemBuilder: (context, int index_position) {
        if (widget.oListPagos.length == 0) {
          return Container(
            height: 190,
            width: 130,
            child: CircularProgressIndicator(),
          );
        }
        return _getItemList(
          widget.oListPagos[index_position].estadoCobro!,
          widget.oListPagos[index_position].unidad!,
          widget.oListPagos[index_position].fecha!,
          widget.oListPagos[index_position].descRuta!,
          widget.oListPagos[index_position].deudaTotal!,
        );
      },
    );
  }

  Widget _buildCardTotal(
    BuildContext context,
    ValoresPendientesPagadosAppMovil model,
  ) {
    var datos = model.datos!;
    double auxPen = 0.0;
    double auxPag = 0.0;
    for (var element in datos) {
      if (element.estadoCobro == 0) {
        auxPen = auxPen + double.parse(element.deudaTotal!);
      } else {
        auxPag = auxPag + double.parse(element.deudaTotal!);
      }
    }

    setState(() {
      widget.oDoublePagado = auxPag;
      widget.oDoublePendiente = auxPen;
    });

    return Container();
  }

  _getItemList(
    int EstadoCobro,
    String unidad,
    DateTime fecha,
    String linea,
    String deudaTotal,
  ) {
    return GestureDetector(
      child: Column(
        children: [
          ListTile(
            leading: Icon(
              EstadoCobro == 1 ? Iconsax.shield_tick : Iconsax.shield_cross,
              color:
                  EstadoCobro == 1
                      ? Color.fromARGB(255, 46, 83, 47)
                      : Colors.red,
            ),
            title: Text(
              "( " + unidad + " ) " + fecha.toString().substring(0, 10),
            ),
            subtitle: Text(linea),
            trailing: Text(
              deudaTotal,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: textBigMedium,
                color:
                    EstadoCobro == 1
                        ? Color.fromARGB(255, 46, 83, 47)
                        : Colors.red,
              ),
            ),
          ),
          Divider(color: Colors.black38),
        ],
      ),
      onTap: () {
        _readMinTarjetas(fecha.toString(), unidad);
      },
    );
  }

  llamarBloc() async {
    setState(() {
      widget.oDoublePagado = 0;
      widget.oDoublePendiente = 0;
    });
    int bandera = 3;
    if (widget.isCheckPendiente == true && widget.isCheckPagado == true) {
      bandera = 3;
    } else if (widget.isCheckPendiente == false &&
        widget.isCheckPagado == false) {
      bandera = 3;
    } else if (widget.isCheckPagado == true &&
        widget.isCheckPendiente == false) {
      bandera = 1;
    } else if (widget.isCheckPendiente == true &&
        widget.isCheckPagado == false) {
      bandera = 0;
    }
    print('On Press bandera >>> ${bandera}');
    ApiValoresPenPag servicio = ApiValoresPenPag();
    datosValoresPP = await servicio.readValoresPenPag(
      widget._unidad,
      widget.fechaInicial,
      widget.fechaFinal,
      bandera,
    );
    var datos = datosValoresPP!.datos!;
    double auxPen = 0.0;
    double auxPag = 0.0;
    for (var element in datos) {
      if (element.estadoCobro == 0) {
        auxPen = auxPen + double.parse(element.deudaTotal!);
      } else {
        auxPag = auxPag + double.parse(element.deudaTotal!);
      }
    }
    setState(() {
      widget.oDoublePagado = auxPag;
      widget.oDoublePendiente = auxPen;
    });
  }

  _readMinTarjetas(String _date, String _unidad) {
    final route = MaterialPageRoute(
      builder: (context) {
        return MinTarjetasPDF(_date, _date, _unidad);
      },
    );
    Navigator.push(context, route);
  }

  _getTotales() {
    return Row(
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Text(
            "PAG ${widget.oDoublePagado.toStringAsFixed(2)}",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: textBigMedium,
              color: Color.fromARGB(255, 46, 83, 47),
            ),
          ),
        ),
        Expanded(
          child: Text(
            "PEN ${widget.oDoublePendiente.toStringAsFixed(2)}",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: textBigMedium,
              fontWeight: FontWeight.bold,
              color: Colors.red,
            ),
          ),
        ),
      ],
    );
  }

  Widget listPdf() {
    if (datosValoresPP != null) {
      if (datosValoresPP!.statusCode == null) {
        return Text("Cargando ...");
      } else if (datosValoresPP!.statusCode == 200) {
        return Column(
          children: [
            //_buildCardTotal(context, datosValoresPP!),
            _buildCard(context, datosValoresPP!),
          ],
        );
      } else if (datosValoresPP!.statusCode == 300) {
        return Text("No hay datos ...");
      }
    }
    return Container();
  }
}
