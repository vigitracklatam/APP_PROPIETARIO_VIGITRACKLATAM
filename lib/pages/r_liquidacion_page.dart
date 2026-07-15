import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';
import '../models/liquidacion _m/liquidacionUpdateM.dart';
import '../models/liquidacion/liquidacion.dart';
import '../models/liquidacion/liquidacionUpdateD.dart';
import '../models/login/login_propietario.dart';
import '../models/unidadDespacho/unidad_despacho.dart';
import '../repositories/repo_liquidacion_vuelta.dart';
import '../repositories/repo_unidades_despacho.dart';
import '../repositories/repo_update_liquidacionD.dart';
import '../repositories/repo_update_liquidacion_m.dart';
import '../repositories/security_data.dart';
import '../utils/colors.dart';
import '../utils/dimens.dart';
import '../utils/iconos.dart';

class ReporteLiquidacionPage extends StatefulWidget {
  ReporteLiquidacionPage({Key? key});
  UnidadesDespachoPropietario lista = UnidadesDespachoPropietario();
  SecurityData oS = new SecurityData();

  @override
  _ReporteLiquidacionPageState createState() => _ReporteLiquidacionPageState();
}

class _ReporteLiquidacionPageState extends State<ReporteLiquidacionPage> {
  String propietario = "";
  List<DropdownMenuItem<String>> lista_unidades = [];
  String _unidad = "*";
  int position = 0;
  String _date = "yyyy-mm-dd";
  bool _isHidden = false;
  LiquidacionDetalleAppMovil? datosUserSalida = null;
  LiquidacionDUpdateAppMovil? datosUserUpdateSalida = null;
  bool _cargandoSalidas = false;
  TextEditingController _dateInputController = TextEditingController();
  List<FilaEditable> _filas = [];
  GlobalKey<_WidgetGastosState> widgetGastosKey =
      GlobalKey<_WidgetGastosState>();
  double totalDinero = 0;

  int totalNormal = 0;
  int totalPreferencial = 0;
  double totalValor = 0;
  bool _cargandoUpdate = false;

  @override
  void initState() {
    super.initState();
    _readPropietario();
    _getItemDropdownButton();
    _getFechaActual();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(color: colorWhite),
          backgroundColor: Colors.blue,
          title: Text(
            "R. Liquidación CH V",
            style: TextStyle(color: colorWhite),
          ),
        ),
        resizeToAvoidBottomInset: true,
        backgroundColor: colorGrey,
        body: SingleChildScrollView(
          padding: const EdgeInsets.only(
            bottom: 16,
          ), // para evitar solapamiento
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: marginSmallSmall),
              Container(
                margin: const EdgeInsets.symmetric(
                  horizontal: marginSmallSmall,
                ),
                child: Row(
                  children: [
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
                          isExpanded: true,
                          underline: Container(
                            height: 0,
                            color: Colors.transparent,
                          ),
                          value:
                              lista_unidades.isNotEmpty
                                  ? lista_unidades[position].value
                                  : _unidad,
                          items: lista_unidades,
                          onChanged: (String? value) {
                            setState(() {
                              _unidad = value!;
                              position = _getPosition(_unidad);
                            });
                          },
                        ),
                      ),
                    ),
                    const SizedBox(width: marginSmallSmall),
                    Expanded(
                      child: TextField(
                        controller: _dateInputController,
                        decoration: const InputDecoration(
                          labelStyle: TextStyle(fontSize: textBigMedium),
                          labelText: 'Fecha',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(IconCalendario),
                        ),
                        onTap: () {
                          FocusScope.of(context).requestFocus(FocusNode());
                          _getSelectDate(context);
                        },
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: marginSmallSmall),
              Container(
                margin: const EdgeInsets.symmetric(
                  horizontal: marginSmallSmall,
                ),
                child: ElevatedButton.icon(
                  onPressed: () {
                    _isHidden = false;
                    print('OnPress unidad $_unidad');
                    _getSalidas();
                  },
                  icon: Icon(IconBuscar),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: colorWhite,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    minimumSize: const Size(double.infinity, 50),
                  ),
                  label: const Text(
                    "Buscar",
                    style: TextStyle(fontSize: textBigMedium),
                  ),
                ),
              ),
              const SizedBox(height: marginSmall),

              // Lista de resultados (puede contener shimmer o data real)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: listaCard(),
              ),

              const SizedBox(height: marginSmall),
            ],
          ),
        ),
      ),
    );
  }

  Widget listaCard() {
    if (_cargandoSalidas) {
      return SingleChildScrollView(
        child: Column(
          children: [
            cardResultadoShimmer(), // Para la tabla
            const SizedBox(height: marginSmall),
            cardResultadoShimmer(), // Para gastos mientras carga todo
          ],
        ),
      );
    }

    if (_mostrarCardNoData) {
      return _cardNoData();
    }

    if (_filas.isNotEmpty) {
      return SingleChildScrollView(
        child: Column(
          children: [
            _buildTable(datosUserSalida!),
            const SizedBox(height: marginSmall),

            // 👇 Mostrar shimmer si estamos actualizando
            _cargandoUpdate
                ? cardResultadoShimmer()
                : WidgetGastos(
                  key: widgetGastosKey,
                  onGastosActualizados: _getSalidas,
                  onIniciarCarga: () {
                    setState(() {
                      _cargandoUpdate = true;
                    });
                  },
                  onTerminarCarga: () {
                    setState(() {
                      _cargandoUpdate = false;
                    });
                  },
                ),
          ],
        ),
      );
    }

    return const Center(child: Text(""));
  }

  Widget _buildTable(LiquidacionDetalleAppMovil model) {
    if (_cargandoUpdate) {
      return cardResultadoShimmer();
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black, width: 1),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeaderRow(),
                  ..._filas.asMap().entries.map((entry) {
                    final index = entry.key;
                    final fila = entry.value;
                    return _buildDataRow(index);
                  }).toList(),
                  _buildTotalRow(
                    (datosUserSalida != null &&
                            datosUserSalida!.datos != null &&
                            datosUserSalida!.datos!.isNotEmpty &&
                            datosUserSalida!.datos![0]?.dineroConteo != null)
                        ? (datosUserSalida!.datos![0]!.dineroConteo is double
                            ? datosUserSalida!.datos![0]!.dineroConteo as double
                            : double.tryParse(
                                  datosUserSalida!.datos![0]!.dineroConteo
                                      .toString(),
                                ) ??
                                0.0)
                        : 0.0,
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildHeaderRow() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: const [
            _HeaderCell("#", width: 35),
            _HeaderCell("Horario", width: 55),
            _HeaderCell("Ruta", width: 80),
            /*   _HeaderCell("T. Normal", width: 60),
            _HeaderCell("T. Prefer.", width: 60), */
            _HeaderCell("Valor", width: 100),
            //_HeaderCell("", width: 60),
          ],
        ),
        Divider(thickness: 1, color: Colors.black),
      ],
    );
  }

  Widget _buildDataRow(int index) {
    final fila = _filas[index];
    final item = fila.item;

    final _normalImputCntroler = fila.normalController;
    final _preferencialImputCntroler = fila.preferencialController;
    final _valorImputCntroler = fila.valorController;

    return Column(
      children: [
        Row(
          children: [
            Container(width: 35, child: _CellText('${item.numVuelta}')),
            Container(
              width: 55,
              child: _CellText(
                '${item.horaSalida}\n${item.horaLLegada}',
                fontSize: 13,
              ),
            ),
            Container(
              width: 80,
              child: _CellText('${item.LetrRuta}', fontSize: 18, isBold: true),
            ),

            /*  Container(
              width: 60,
              child: _EditableCell(controller: _normalImputCntroler),
            ),
            Container(
              width: 60,
              child: _EditableCell(controller: _preferencialImputCntroler),
            ), */
            Container(
              width: 100,
              child: _CellText(
                '${item.dineroConteoPasajero}',
                fontSize: 18,
                isBold: true,
              ),
            ),
            /*Container(
              width: 60,
              child: IconButton(
                icon: Icon(Icons.save),
                onPressed: () {
                  _mostrarDialogoConfirmacion(
                    context,
                    item,
                    _normalImputCntroler.text,
                    _preferencialImputCntroler.text,
                    _valorImputCntroler.text,
                  );
                },
              ),
            ),*/
          ],
        ),
        Divider(thickness: 0.8, height: 1, color: Colors.black),
      ],
    );
  }

  void _mostrarDialogoConfirmacion(
    BuildContext context,
    dynamic item,
    String value1,
    String value2,
    String value3,
  ) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          titlePadding: EdgeInsets.zero,
          title: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.blue,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(4),
              ),
            ),
            child: const Text(
              "Confirmar envío de información",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 12),
              _buildConfirmRow("Ruta:", item.LetrRuta),
              _buildConfirmRow("Descripción:", item.descRuta),
              _buildConfirmRow(
                "Horario:",
                '${item.horaSalida} - ${item.horaLLegada}',
              ),
              /*  _buildConfirmRow("T. Normal:", value1),
              _buildConfirmRow("T. Preferencial:", value2), */
              _buildConfirmRow("Valor:", value3),
              const SizedBox(height: 16),
              const Text(
                "¿Está seguro de enviar esta información?",
                style: TextStyle(fontStyle: FontStyle.italic),
              ),
              const SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 30,
                      vertical: 12,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: () {
                    final Map<String, dynamic> datos = {
                      "idLiquidaM": item.idLiquidacionMChofer ?? 0,
                      "fechaLiquidaM": item.fecha ?? '',
                      "idSalidaM": item.fkSalida ?? 0,
                      "idRuta": item.fkIdRuta ?? 0,
                      "conteoTotal": int.tryParse(value1) ?? 0,
                      "conteoMedio": int.tryParse(value2) ?? 0,
                      "dineroConteo": double.tryParse(value3) ?? 0.0,
                    };
                    String fechaFormateada = DateFormat(
                      'yyyy-MM-dd',
                    ).format(item.fecha);
                    print("📦 Datos a enviar:");
                    print(datos);
                    _updateLiquidacionD(
                      propietario,
                      item.idLiquidacionMChofer ?? 0,
                      fechaFormateada ?? '',
                      item.fkSalida ?? 0,
                      item.fkIdRuta ?? 0,
                      int.tryParse(value1) ?? 0,
                      int.tryParse(value2) ?? 0,
                      double.tryParse(value3) ?? 0.0,
                    );

                    Navigator.of(context).pop(); // Cierra el diálogo
                  },

                  child: const Text(
                    "Enviar",
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildConfirmRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(width: 6),
          Expanded(
            child: Text(value, maxLines: 2, overflow: TextOverflow.ellipsis),
          ),
        ],
      ),
    );
  }

  Widget _buildTotalRow(double totalValor) {
    return Container(
      child: Row(
        children: [
          Container(width: 35, child: _CellText('')),
          Container(
            width: 55,
            child: _CellTextTotal('TOTAL'),
          ), // Espacio vacío para el nombre
          Container(
            width: 80,
            child: _CellTextTotal(''),
          ), // Espacio vacío para el rango de horas
          /*         Container(
            width: 60,
            child: _CellTextTotal('$totalNormal'),
          ), // Muestra el total de Normal
          Container(
            width: 60,
            child: _CellTextTotal('$totalPreferencial'),
          ), // Muestra el total Preferencial */
          Container(
            width: 100,
            child: _CellTextTotal('$totalValor'),
          ), // Muestra el total Valor
          Container(width: 60), // Espacio vacío para el botón
        ],
      ),
    );
  }

  bool _mostrarCardNoData = false;

  _getSalidas() async {
    setState(() {
      _cargandoSalidas = true;
      _mostrarCardNoData = false;
      _filas = []; // Limpia antes de cargar
    });

    try {
      ApiRepoLiquidacionVuelta servicio = ApiRepoLiquidacionVuelta();
      final resultadoApi = await servicio.fetchLiquidacion(
        propietario,
        _unidad,
        _dateInputController.text,
      );

      datosUserSalida = resultadoApi;

      if (datosUserSalida != null &&
          datosUserSalida!.statusCode == 200 &&
          datosUserSalida!.datos != null &&
          datosUserSalida!.datos!.isNotEmpty) {
        _filas =
            datosUserSalida!.datos!.map((item) {
              return FilaEditable(
                item: item,
                normalController: TextEditingController(
                  text: item.conteoPasajeroCompleto?.toString() ?? '',
                ),
                preferencialController: TextEditingController(
                  text: item.conteoPasajeroMedio?.toString() ?? '',
                ),
                valorController: TextEditingController(
                  text:
                      item.dineroConteoPasajero != null &&
                              item.dineroConteoPasajero!.isNotEmpty
                          ? double.tryParse(
                                item.dineroConteoPasajero!,
                              )?.toStringAsFixed(2) ??
                              ''
                          : '',
                ),
              );
            }).toList();

        final datos = datosUserSalida!.datos![0];

        WidgetsBinding.instance.addPostFrameCallback((_) {
          final state = widgetGastosKey.currentState;
          if (state != null) {
            state.actualizarConDatos(
              idLiquiM: datos.idLiquidacionMChofer ?? 0,
              unidad: _unidad ?? '',
              fecha: _dateInputController.text,
              comida: double.tryParse(datos.gastoComida ?? '0') ?? 0.0,
              chofer: double.tryParse(datos.gastoChofer ?? '0') ?? 0.0,
              ayudante: double.tryParse(datos.gastoAyudante ?? '0') ?? 0.0,
              limpieza: double.tryParse(datos.gastoLimpieza ?? '0') ?? 0.0,
              bebida: double.tryParse(datos.gBebida ?? '0') ?? 0.0,
              otros: double.tryParse(datos.gastoOtro ?? '0') ?? 0.0,
              ticket: double.tryParse(datos.gastoTicket ?? '0') ?? 0.0,
              peaje: double.tryParse(datos.gastoPeaje ?? '0') ?? 0.0,
              diesel: double.tryParse(datos.gastoGasolina ?? '0') ?? 0.0,
              observacion: datos.observacion ?? '',
              totalDinero: double.tryParse(datos.total ?? '0') ?? 0.0,
              totalGasto: double.tryParse(datos.totalGasto ?? '0') ?? 0.0,
              dineroConteo: double.tryParse(datos.dineroConteo ?? '0') ?? 0.0,
            );
          }
        });
      } else {
        _mostrarCardNoData = true;
      }
    } catch (e) {
      print("Error al obtener salidas: $e");
      _mostrarCardNoData = true;
    }

    setState(() {
      _cargandoSalidas = false;
    });

    readUnidadesDespacho();
  }

  void _updateLiquidacionD(
    String propietario,
    int idLiquidaM,
    String fechaLiquidaM,
    int idSalidaM,
    int idRuta,
    int conteoTotal,
    int conteoMedio,
    double dineroConteo,
  ) async {
    setState(() {
      _cargandoUpdate = true;
    });

    ApiUpdateLiquidacionD servicio = ApiUpdateLiquidacionD();
    final resultadoApiUpdate = await servicio.fetchUpdateLiquidacion(
      propietario,
      idLiquidaM,
      fechaLiquidaM,
      idSalidaM,
      idRuta,
      conteoTotal,
      conteoMedio,
      dineroConteo,
    );

    setState(() {
      _cargandoUpdate = false;
      datosUserUpdateSalida = resultadoApiUpdate;
    });

    final statusCode = resultadoApiUpdate.statusCode;

    if (statusCode == 200) {
      showTopSnackBar(
        Overlay.of(context),
        const CustomSnackBar.success(message: "¡Operación exitosa!"),
      );

      _getSalidas();
      final datos = datosUserSalida!.datos![0];
      WidgetsBinding.instance.addPostFrameCallback((_) {
        final state = widgetGastosKey.currentState;
        if (state != null) {
          state.actualizarConDatos(
            idLiquiM: idLiquidaM ?? 0,
            unidad: _unidad ?? '',
            fecha: _dateInputController.text,
            comida: double.tryParse(datos.gastoComida ?? '0') ?? 0.0,
            chofer: double.tryParse(datos.gastoChofer ?? '0') ?? 0.0,
            ayudante: double.tryParse(datos.gastoAyudante ?? '0') ?? 0.0,
            limpieza: double.tryParse(datos.gastoLimpieza ?? '0') ?? 0.0,
            bebida: double.tryParse(datos.gBebida ?? '0') ?? 0.0,
            otros: double.tryParse(datos.gastoOtro ?? '0') ?? 0.0,
            ticket: double.tryParse(datos.gastoTicket ?? '0') ?? 0.0,
            peaje: double.tryParse(datos.gastoPeaje ?? '0') ?? 0.0,
            diesel: double.tryParse(datos.gastoGasolina ?? '0') ?? 0.0,
            observacion: datos.observacion ?? '',
            totalDinero: double.tryParse(datos.total ?? '0') ?? 0.0,
            totalGasto: double.tryParse(datos.totalGasto ?? '0') ?? 0.0,
            dineroConteo: double.tryParse(datos.dineroConteo ?? '0') ?? 0.0,
          );
        }
      });
    } else if (statusCode == 300) {
      showTopSnackBar(
        Overlay.of(context),
        const CustomSnackBar.info(message: "Error al actualizar"),
      );
    } else {
      showTopSnackBar(
        Overlay.of(context),
        const CustomSnackBar.error(message: "Error al actualizar"),
      );
    }
  }

  _ItemDropdownButton(String value, String desc) {
    return DropdownMenuItem<String>(value: value, child: Text(desc));
  }

  Widget tableResultadoShimmer() {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(
        horizontal: marginSmallSmall,
        vertical: marginSmallSmall,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: colorWhite,
        boxShadow: [boxShadowPersonalizado],
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          // Encabezado
          Container(
            height: 50,
            color: Colors.grey.shade200,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Row(
              children: const [
                Expanded(child: Skelton(height: 24, width: double.infinity)),
                Expanded(child: Skelton(height: 24, width: double.infinity)),
                Expanded(child: Skelton(height: 24, width: double.infinity)),
                Expanded(child: Skelton(height: 24, width: double.infinity)),
                Expanded(child: Skelton(height: 24, width: double.infinity)),
              ],
            ),
          ),
          Divider(height: 1, color: Colors.grey),
          // Filas shimmer
          ...List.generate(7, (index) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
              child: Row(
                children: const [
                  Expanded(child: Skelton(height: 18, width: double.infinity)),
                  Expanded(child: Skelton(height: 18, width: double.infinity)),
                  Expanded(child: Skelton(height: 18, width: double.infinity)),
                  Expanded(child: Skelton(height: 18, width: double.infinity)),
                  Expanded(child: Skelton(height: 18, width: double.infinity)),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget cardResultadoShimmer() {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(
        horizontal: marginSmallSmall,
        vertical: marginSmallSmall,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: colorWhite,
        boxShadow: [boxShadowPersonalizado],
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          // Encabezado
          Container(
            height: 50,
            color: Colors.grey.shade200,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Row(
              children: const [
                Expanded(child: Skelton(height: 24, width: double.infinity)),
                Expanded(child: Skelton(height: 24, width: double.infinity)),
                Expanded(child: Skelton(height: 24, width: double.infinity)),
                Expanded(child: Skelton(height: 24, width: double.infinity)),
                Expanded(child: Skelton(height: 24, width: double.infinity)),
              ],
            ),
          ),
          Divider(height: 1, color: Colors.grey),
          // Filas shimmer
          ...List.generate(4, (index) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
              child: Row(
                children: const [
                  Expanded(child: Skelton(height: 18, width: double.infinity)),
                  Expanded(child: Skelton(height: 18, width: double.infinity)),
                  Expanded(child: Skelton(height: 18, width: double.infinity)),
                  Expanded(child: Skelton(height: 18, width: double.infinity)),
                  Expanded(child: Skelton(height: 18, width: double.infinity)),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  _getItemDropdownButton() async {
    var jsonDataL = await widget.oS.readDataPreferenciasLoginPropietario(
      'dataLoginPropietarioLoginUnidadesd',
    );
    LoginPropietario listabuses = LoginPropietario.fromRawJson(jsonDataL);

    setState(() {
      lista_unidades.clear(); // Limpia antes de agregar nuevos datos

      if (listabuses.data == null || listabuses.data!.isEmpty) {
        // Si no hay datos, mostrar solo "*"
        lista_unidades.add(
          DropdownMenuItem<String>(child: Text('*'), value: '*'),
        );
        _unidad = "*";
      } else {
        // Si hay datos, agrega primero la primera unidad
        final primeraUnidad = listabuses.data!.first.codiVehiObseVehi;
        lista_unidades.add(
          DropdownMenuItem<String>(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Image.asset('assets/online_lista.png', width: 19),
                Container(
                  margin: EdgeInsets.only(left: 10),
                  child: Text(' ${listabuses.data!.first.codiVehiObseVehi}'),
                ),
              ],
            ),
            value: primeraUnidad,
          ),
        );
        _unidad = primeraUnidad!;
        // Luego agrega el resto (saltando el primero)
        listabuses.data!.skip(1).forEach((element) {
          lista_unidades.add(
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
      }
    });
  }

  _readPropietario() async {
    propietario = await widget.oS.readDataPreferenciasLoginPropietario(
      'dataLoginPropietarioLoginPropietario',
    );
    print('Propietario getsalida ${propietario}');
  }

  _getSelectDate(BuildContext context) async {
    DateTime? _datePick = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2050),
      locale: const Locale('es'),
    );

    if (_datePick != null) {
      setState(() {
        _date = DateFormat('yyyy-MM-dd').format(_datePick);
        _dateInputController.text = _date;
      });
    }
  }

  _getFechaActual() {
    var date = DateTime.now();
    var year = date.year;
    var month = date.month < 10 ? "0" + date.month.toString() : date.month;
    var day = date.day < 10 ? "0" + date.day.toString() : date.day;
    setState(() {
      _date = year.toString() + "/" + month.toString() + "/" + day.toString();
      _dateInputController.text = _date;
    });
  }

  int _getPosition(String value) {
    for (var i = 0; i < lista_unidades.length; i++) {
      if (lista_unidades[i].value == value) {
        return i;
      }
    }
    return 0;
  }

  Widget _cardNoData() {
    return !_isHidden
        ? Container(
          width:
              MediaQuery.of(context).size.width > 400
                  ? 400
                  : MediaQuery.of(context).size.width * 0.95,
          margin: const EdgeInsets.symmetric(
            horizontal: marginSmallSmall,
            vertical: marginSmallSmall,
          ),
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: colorWhite,
            boxShadow: [boxShadowPersonalizado],
          ),
          child: IntrinsicHeight(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'No Existen Datos',
                  style: TextStyle(
                    fontSize:
                        MediaQuery.of(context).size.width < 320
                            ? textBig * 0.85
                            : textBig,
                    color: colorBlack,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),
                Text(
                  _unidad == "*"
                      ? 'Todos los buses en la fecha $_date no tienen datos'
                      : 'El bus $_unidad en la fecha $_date no tiene datos',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: textMedium, color: colorBlack),
                ),
                const SizedBox(height: 6),
                Text(
                  'Por favor verifica la fecha.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: textMedium, color: colorBlack),
                ),
                const SizedBox(height: 12),
                ElevatedButton(
                  onPressed: _toggleVisibility,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  child: const Text("Ok"),
                ),
              ],
            ),
          ),
        )
        : const SizedBox.shrink();
  }

  void _toggleVisibility() {
    setState(() {
      _isHidden = !_isHidden;
    });
  }

  readUnidadesDespacho() async {
    ApiRepositorioUnidadesDespacho service = ApiRepositorioUnidadesDespacho();
    widget.lista = await service.fectchUnidadesDespacho();
    print('Aca datosBuses');
    //print(widget.lista);
    setState(() {});
  }
}

class _HeaderCell extends StatelessWidget {
  final String text;
  final double width;

  const _HeaderCell(this.text, {this.width = 80, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      width: width,
      child: Text(
        text,
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
        textAlign: TextAlign.center,
      ),
    );
  }
}

class _CellText extends StatelessWidget {
  final String text;
  final bool isBold;
  final double? fontSize;

  const _CellText(this.text, {this.isBold = false, this.fontSize});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: Text(
        text,
        style: TextStyle(
          fontSize: fontSize ?? 14,
          fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
        ),
      ),
    );
  }
}

class _CellTextTotal extends StatelessWidget {
  final String text;
  const _CellTextTotal(this.text);

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: Text(text, style: TextStyle(fontSize: 18)),
    );
  }
}

class _EditableCell extends StatelessWidget {
  final TextEditingController controller;
  final Function(String)? onChanged;

  const _EditableCell({required this.controller, this.onChanged, Key? key})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 2),
      child: SizedBox(
        child: Focus(
          onFocusChange: (hasFocus) {
            if (!hasFocus) {
              // Si el campo está vacío al salir, poner "0"
              if (controller.text.trim().isEmpty) {
                controller.text = '0';
              }
            }
          },
          child: TextField(
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 18),
            controller: controller,
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            textInputAction: TextInputAction.next,
            decoration: const InputDecoration(
              isDense: true,
              border: OutlineInputBorder(),
              contentPadding: EdgeInsets.symmetric(vertical: 4),
            ),
            onChanged: onChanged,
          ),
        ),
      ),
    );
  }
}

class _EditableCellValor extends StatelessWidget {
  final TextEditingController controller;
  final Function(String)? onChanged;

  const _EditableCellValor({required this.controller, this.onChanged, Key? key})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 2),
      child: Focus(
        onFocusChange: (hasFocus) {
          if (!hasFocus) {
            final text = controller.text.trim();
            // Si está vacío, poner "0.00"
            if (text.isEmpty) {
              controller.text = '0.00';
            } else {
              // Si no está vacío, asegurar máximo 2 decimales
              final parsed = double.tryParse(text);
              if (parsed != null) {
                controller.text = parsed.toStringAsFixed(2);
              } else {
                controller.text = '0.00'; // fallback por si acaso
              }
            }
          }
        },
        child: TextField(
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 18),
          controller: controller,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
          ],
          textInputAction: TextInputAction.next,
          decoration: const InputDecoration(
            isDense: true,
            border: OutlineInputBorder(),
            contentPadding: EdgeInsets.symmetric(vertical: 4),
          ),
          onChanged: onChanged,
        ),
      ),
    );
  }
}

class FilaEditable {
  final dynamic item;
  final TextEditingController normalController;
  final TextEditingController preferencialController;
  final TextEditingController valorController;

  FilaEditable({
    required this.item,
    required this.normalController,
    required this.preferencialController,
    required this.valorController,
  });
}

class GastoInputRow extends StatelessWidget {
  final String label;
  final TextEditingController controller;

  const GastoInputRow({
    super.key,
    required this.label,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          Expanded(child: Text(label)),
          SizedBox(
            width: 100,
            child: TextField(
              controller: controller,
              keyboardType: TextInputType.number,
              textAlign: TextAlign.right,
              decoration: const InputDecoration(
                isDense: true,
                border: OutlineInputBorder(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class WidgetGastos extends StatefulWidget {
  final VoidCallback? onGastosActualizados; // <-- Callback al padre
  final VoidCallback? onIniciarCarga;
  final VoidCallback? onTerminarCarga;

  WidgetGastos({
    Key? key,
    this.onGastosActualizados,
    this.onIniciarCarga,
    this.onTerminarCarga,
  }) : super(key: key);

  SecurityData oS = SecurityData();

  @override
  State<WidgetGastos> createState() => _WidgetGastosState();
}

class _WidgetGastosState extends State<WidgetGastos> {
  int idLiquiM = 0;
  String unidad = '';
  String fecha = '';
  String propietario = '';
  final TextEditingController conductorCtrl = TextEditingController(text: '0');
  final TextEditingController ayudanteCtrl = TextEditingController(text: '0');
  final TextEditingController comidaCtrl = TextEditingController(text: '0');
  final TextEditingController ticketCtrl = TextEditingController(text: '0');
  final TextEditingController peajeCtrl = TextEditingController(text: '0');
  final TextEditingController dieselCtrl = TextEditingController(text: '0');
  final TextEditingController otrosCtrl = TextEditingController(text: '0');
  final TextEditingController limpieza = TextEditingController(text: '0');
  final TextEditingController bebidaCtrl = TextEditingController(text: '0');
  final TextEditingController observacionCtrl = TextEditingController();

  String totalDinero = "0.0";
  String dineroConteo = "0.0";
  String totalGasto = " 0.0";
  LiquidacionMUpdateMAppMovil? datosUserUpdateSalida = null;
  LiquidacionDetalleAppMovil? datosUserSalida = null;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          //margin: const EdgeInsets.symmetric(horizontal: marginSmallSmall),
          child: const Text(
            'Gastos',
            textAlign: TextAlign.end,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        const SizedBox(height: 10),

        // Inputs en filas de 2
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 0),
          child: Column(
            children: [
              _buildRowPar(
                'Conductor',
                conductorCtrl,
                'Ayudante',
                ayudanteCtrl,
              ),
              _buildRowPar('Comida', comidaCtrl, 'Ticket', ticketCtrl),
              _buildRowPar('Peaje', peajeCtrl, 'Combustible', dieselCtrl),
              _buildRowPar('Limpieza', limpieza, 'O. Gastos', otrosCtrl),
              _buildRow('Hidratación', bebidaCtrl),
            ],
          ),
        ),
        const SizedBox(height: 12),
        const Divider(color: Colors.black),
        _buildRowResumen('Total recaudado', dineroConteo, 16, false),
        const Divider(color: Colors.black),
        _buildRowResumen('Total gastos', totalGasto, 16, false),
        const Divider(color: Colors.black),
        _buildRowResumen('Total a recibir', totalDinero, 20, true),
        const Divider(color: Colors.black),
        const SizedBox(height: 12),
        _buildObservacionInput(),
        /*Center(
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              foregroundColor: colorWhite,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
            ),
            onPressed: () {
              // Obtenemos los valores de todos los campos
              /*      final datosGastos = {
                'idLiquiM': idLiquiM,
                'unidad': unidad,
                'fecha': fecha,
                'conductor': conductorCtrl.text,
                'ayudante': ayudanteCtrl.text,
                'comida': comidaCtrl.text,
                'ticket': ticketCtrl.text,
                'peaje': peajeCtrl.text,
                'diesel': dieselCtrl.text,
                'otros': otrosCtrl.text,
                'limpiezaExtra': limpieza.text,
                'observacion': observacionCtrl.text,
                'totalGastos': totalGasto,
                'totalRecibir': totalDinero,
                'dineroConteo': dineroConteo,
              }; */
              _updateLiquidacionM(
                idLiquiM,
                unidad,
                fecha,
                double.tryParse(comidaCtrl.text) ?? 0.0,
                double.tryParse(conductorCtrl.text) ?? 0.0,
                double.tryParse(ayudanteCtrl.text) ?? 0.0,
                double.tryParse(limpieza.text) ?? 0.0,
                double.tryParse(bebidaCtrl.text) ?? 0.0,
                double.tryParse(otrosCtrl.text) ?? 0.0,
                double.tryParse(ticketCtrl.text) ?? 0.0,
                double.tryParse(peajeCtrl.text) ?? 0.0,
                double.tryParse(dieselCtrl.text) ?? 0.0,
                observacionCtrl.text,
                propietario,
              );

              /*   print("📦 Datos de gastos guardados:");
              datosGastos.forEach((key, value) {
                print("$key: $value");
              }); */
            },

            child: const Text('Guardar Gastos'),
          ),
        ),*/
      ],
    );
  }

  Widget _buildRow(String label1, TextEditingController ctrl1) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Expanded(child: _buildInput(label1, ctrl1)),

          //const SizedBox(width: 8),
        ],
      ),
    );
  }

  Widget _buildRowPar(
    String label1,
    TextEditingController ctrl1,
    String label2,
    TextEditingController ctrl2,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Expanded(child: _buildInput(label1, ctrl1)),
          //const SizedBox(width: 8),
          Expanded(child: _buildInput(label2, ctrl2)),
        ],
      ),
    );
  }

  Widget _buildInput(String label, TextEditingController controller) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Label del input
        Container(
          width: 80, // 👈 Asignar ancho fijo
          margin: const EdgeInsets.only(right: 8),

          child: Text(
            label,
            maxLines: 1,
            textAlign: TextAlign.left,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),

        // Campo de texto
        SizedBox(
          width: 70,
          child: Focus(
            onFocusChange: (hasFocus) {
              if (!hasFocus) {
                final text = controller.text.trim();
                if (text.isEmpty) {
                  controller.text = '0.00';
                } else {
                  final parsed = double.tryParse(text);
                  if (parsed != null) {
                    controller.text = parsed.toStringAsFixed(2);
                  } else {
                    controller.text = '0.00';
                  }
                }
                setState(() {});
              }
            },
            child: TextField(
              controller: controller,
              enabled: false,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
              ],
              textAlign: TextAlign.center,
              decoration: const InputDecoration(
                isDense: true,
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.symmetric(vertical: 6),
              ),
              onChanged: (_) => setState(() {}),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildRowResumen(
    String label,
    String value,
    double _fontSize,
    bool isTotal,
  ) {
    double? numero = double.tryParse(value.replaceAll(",", ""));

    final color =
        (numero != null && numero < 0)
            ? Colors.red
            : isTotal
            ? Colors.green
            : Colors.black;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          margin: const EdgeInsets.only(left: 10),
          child: Text(
            label,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
        ),
        Container(
          margin: const EdgeInsets.only(right: 10),
          child: Text(
            value,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: _fontSize,
              color: color, // 👉 Aplica el color según el valor
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildObservacionInput() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Observación',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 4),
          Focus(
            onFocusChange: (hasFocus) {
              if (!hasFocus) {
                // Limpia espacios extra y corta a 250 caracteres
                String text = observacionCtrl.text.trim();
                if (text.length > 150) {
                  text = text.substring(0, 150);
                }
                observacionCtrl.text = text;
                setState(() {});
              }
            },
            child: TextField(
              controller: observacionCtrl,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                isDense: true,
                enabled: false,
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 10,
                ),
                hintText: 'Máximo 150 caracteres...',
              ),
              maxLines: 3,
              maxLength: 150,
              textCapitalization: TextCapitalization.sentences,
            ),
          ),
        ],
      ),
    );
  }

  void actualizarConDatos({
    required int idLiquiM,
    required String unidad,
    required String fecha,
    required double comida,
    required double chofer,
    required double ayudante,
    required double limpieza,
    required double bebida,
    required double otros,
    required double ticket,
    required double peaje,
    required double diesel,
    required String observacion,
    required double totalDinero, // ← Este es el "total"
    required double totalGasto, // ← Este es "totalGasto"
    required double dineroConteo, // ← Este es "dineroConteo"
  }) {
    setState(() {
      this.idLiquiM = idLiquiM;
      this.unidad = unidad;
      this.fecha = fecha;
      comidaCtrl.text = comida.toStringAsFixed(2);
      conductorCtrl.text = chofer.toStringAsFixed(2);
      ayudanteCtrl.text = ayudante.toStringAsFixed(2);
      this.limpieza.text = limpieza.toStringAsFixed(2);
      this.bebidaCtrl.text = bebida.toStringAsFixed(2);
      otrosCtrl.text = otros.toStringAsFixed(2);
      ticketCtrl.text = ticket.toStringAsFixed(2);
      peajeCtrl.text = peaje.toStringAsFixed(2);
      dieselCtrl.text = diesel.toStringAsFixed(2);
      observacionCtrl.text = observacion;
      this.totalDinero = totalDinero.toStringAsFixed(2);
      this.totalGasto = totalGasto.toStringAsFixed(2);
      this.dineroConteo = dineroConteo.toStringAsFixed(2);
    });
  }

  void _updateLiquidacionM(
    int idLiquidaM,
    String unidad,
    String fechaLiquidaM,
    double gComida,
    double gChofer,
    double gAyudante,
    double gLimpieza,
    double gBebida,
    double gOtros,
    double gTicket,
    double gPeaje,
    double gGasolina,
    String observacion,
    String propietario,
  ) async {
    widget.onIniciarCarga?.call();

    final servicio = ApiUpdateLiquidacionM();
    final resultadoApiUpdate = await servicio.fetchUpdateLiquidacionM(
      idLiquidaM,
      unidad,
      fechaLiquidaM,
      gComida,
      gChofer,
      gAyudante,
      gLimpieza,
      gBebida,
      gOtros,
      gTicket,
      gPeaje,
      gGasolina,
      observacion,
      propietario,
    );

    widget.onTerminarCarga?.call();

    if (resultadoApiUpdate.statusCode == 200) {
      widget.onGastosActualizados?.call();
      final key = widget.key;
      if (key is GlobalKey<_WidgetGastosState>) {
        final state = key.currentState;
        if (state != null && mounted) {
          state.actualizarConDatos(
            idLiquiM: idLiquidaM,
            unidad: unidad,
            fecha: fechaLiquidaM,
            comida: gComida,
            chofer: gChofer,
            ayudante: gAyudante,
            limpieza: gLimpieza,
            bebida: gBebida,
            otros: gOtros,
            ticket: gTicket,
            peaje: gPeaje,
            diesel: gGasolina,
            observacion: observacion,
            totalDinero: double.tryParse(state.totalDinero) ?? 0.0,
            totalGasto: double.tryParse(state.totalGasto) ?? 0.0,
            dineroConteo: double.tryParse(state.dineroConteo) ?? 0.0,
          );
        }
      }
    }
    /*  _mostrarResultadoDialogo(
      statusCode: resultadoApiUpdate!.statusCode!,
      mensaje: resultadoApiUpdate.msm ?? "Sin mensaje",
    ); */
  }

  void _mostrarResultadoDialogo({
    required int statusCode,
    required String mensaje,
  }) {
    if (!mounted) return; // ✅ Asegura que el widget siga montado

    String titulo = "";
    Color color = Colors.blue;

    if (statusCode == 200) {
      titulo = "Éxito";
      color = Colors.green;
    } else if (statusCode == 300) {
      titulo = "Atención";
      color = Colors.orange;
    } else {
      titulo = "Error";
      color = Colors.red;
    }

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Row(
            children: [
              Icon(Icons.info, color: color),
              const SizedBox(width: 8),
              Text(titulo),
            ],
          ),
          content: Text(mensaje, style: const TextStyle(fontSize: 16)),
          actions: [
            TextButton(
              style: TextButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: color,
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 10,
                ),
              ),
              onPressed: () => Navigator.of(context).pop(),
              child: const Text("Aceptar"),
            ),
          ],
        );
      },
    );
  }
}

class Skelton extends StatelessWidget {
  const Skelton({super.key, this.height, this.width});
  final double? height, width;

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[500]!,
      highlightColor: Colors.grey[100]!,
      child: Container(
        height: height,
        width: width,
        margin: const EdgeInsets.only(top: 5),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(6),
          color: Colors.grey.withOpacity(0.25),
        ),
        clipBehavior: Clip.antiAlias,
      ),
    );
  }
}
