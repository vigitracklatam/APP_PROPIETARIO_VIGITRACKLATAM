import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';

import '../models/liquidacionSB/data_liquidacion_SB.dart';
import '../models/liquidacionSB/liquidacion_SB.dart';
import '../models/login/login_propietario.dart';
import '../provider/provi_get_liquidacion_SB.dart';
import '../repositories/security_data.dart';
import '../utils/colors.dart';
import '../utils/dimens.dart';
import '../utils/iconos.dart';
import 'visor_evidencia_page.dart';


class ReportLiqVueltaSB extends StatefulWidget {
  ReportLiqVueltaSB({super.key});
  final SecurityData oS = SecurityData();

  @override
  State<ReportLiqVueltaSB> createState() => _ReportLiqVueltaSBState();
}

class _ReportLiqVueltaSBState extends State<ReportLiqVueltaSB> {
  String propietario = "";
  List<DropdownMenuItem<String>> lista_unidades = [];
  String _unidad = "*";
  int position = 0;
  String _date = "yyyy-mm-dd";
  bool _isHidden = false;
  bool _mostrarCardNoData = false;
  bool _cargandoSalidas = false;
  TextEditingController _dateInputController = TextEditingController();
  List<DatoLiquidacionSB>? datoLiquidacionSB;

  Map<int, List<FilaEditable>> _liquidacionesAgrupadasDesdeAPI = {};

  @override
  void initState() {
    super.initState();
    _getItemDropdownButton();
    _getFechaActual();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(color: colorWhite),
          backgroundColor: Colors.blue,
          title: Text(
            "R. Liquidación Vuelta S.B",
            style: TextStyle(color: colorWhite),
          ),
        ),
        resizeToAvoidBottomInset: true,
        backgroundColor: colorGrey,
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
                        //isDense: true,
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
                  Flexible(
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
            Container(
              margin: const EdgeInsets.only(
                right: marginSmallSmall,
                left: marginSmallSmall,
                top: marginSmallSmall,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        _isHidden = false;
                        print('OnPress unidad $_unidad');

                        _getSalidas();
                      },
                      icon: Icon(IconBuscar),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue, // Color de fondo azul
                        foregroundColor: colorWhite,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                        minimumSize: Size(double.infinity, 50),
                      ),
                      label: const Text(
                        "Buscar",
                        style: TextStyle(fontSize: textBigMedium),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: marginSmall),
            Flexible(child: listaCard()),
          ],
        ),
      ),
    );
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

  _getItemDropdownButton() async {
    var jsonDataL = await widget.oS.readDataPreferenciasLoginPropietario(
      'dataLoginPropietarioLoginUnidadesd',
    );
    LoginPropietario listabuses = LoginPropietario.fromRawJson(jsonDataL);

    setState(() {
      LoginPropietario listabuses = LoginPropietario.fromRawJson(jsonDataL);

      setState(() {
        if (listabuses.data != null && listabuses.data!.isNotEmpty) {
          _unidad = listabuses.data!.first.codiVehiObseVehi!;
        }
      });

      listabuses.data!.forEach((element) {
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
    double screenWidth = MediaQuery.of(context).size.width;

    return !_isHidden
        ? SingleChildScrollView(
          // Evita que se corte el contenido
          child: Container(
            width: screenWidth * 0.95, // Siempre un 95% del ancho disponible
            constraints: const BoxConstraints(maxWidth: 400), // No más de 400px
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
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'No Existen Datos',
                  style: TextStyle(
                    fontSize:
                        screenWidth < 320
                            ? textBig * 0.8
                            : screenWidth < 380
                            ? textBig * 0.9
                            : textBig,
                    color: colorBlack,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),
                Text(
                  'El bus en la fecha $_date no tiene datos',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize:
                        screenWidth < 320 ? textMedium * 0.85 : textMedium,
                    color: colorBlack,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'Por favor verifica la fecha.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize:
                        screenWidth < 320 ? textMedium * 0.85 : textMedium,
                    color: colorBlack,
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  child: ElevatedButton(
                    onPressed: _toggleVisibility,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                    child: const Text("Ok"),
                  ),
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

  _getTitle(unidad, fecha) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 0.0),
          child: Text.rich(
            TextSpan(
              style: const TextStyle(fontSize: 14, color: Colors.black),
              children: <TextSpan>[
                const TextSpan(
                  text: 'Unidad: ',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                TextSpan(text: '$unidad'),
              ],
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 0.0),
          child: Text.rich(
            TextSpan(
              style: const TextStyle(fontSize: 14, color: Colors.black),
              children: <TextSpan>[
                const TextSpan(
                  text: 'Fecha: ',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                TextSpan(text: fecha.split(' ')[0]),
              ],
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget cardResultadoShimmer() {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: 12),
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
                Spacer(),
                Expanded(child: Skelton(height: 24, width: double.infinity)),
              ],
            ),
          ),
          Divider(height: 1, color: Colors.grey),
          // Filas shimmer
          ...List.generate(6, (index) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
              child: Row(
                children: const [
                  Expanded(child: Skelton(height: 18, width: 10.0)),
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

  Widget listaCard() {
    if (_cargandoSalidas) {
      return SingleChildScrollView(
        child: Column(
          children: [
            cardResultadoShimmer(),
            const SizedBox(height: marginSmall),
            cardResultadoShimmer(),
          ],
        ),
      );
    }

    if (_mostrarCardNoData) {
      return _cardNoData();
    }

    if (_liquidacionesAgrupadasDesdeAPI.isNotEmpty) {
      return SingleChildScrollView(
        padding: EdgeInsets.only(bottom: 20.0),
        child: Column(
          children:
              _liquidacionesAgrupadasDesdeAPI.entries.map((entry) {
                int idLiquidacion = entry.key;
                List<FilaEditable> filasDelGrupo = entry.value;
                return _buildTablaDeLiquidacion(idLiquidacion, filasDelGrupo);
              }).toList(),
        ),
      );
    }

    return const Center(child: Text(""));
  }

  Widget _buildTablaDeLiquidacion(int idLiquidacion, List<FilaEditable> filas) {
    final primerItem = filas[0].item;
    final unidad = primerItem.codiVehiSaliM;
    final fecha = primerItem.fechaLiquidacionM;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade400, width: 1),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _getTitle(unidad, fecha),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8.0,
                  vertical: 4.0,
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder:
                                (context) => VisorEvidenciaPage(
                                  unidadLiquidacionM: unidad,
                                  fechaLiquidacionM: fecha,
                                  evidencia1: primerItem.evidencia1,
                                  evidencia2: primerItem.evidencia2,
                                  evidencia3: primerItem.evidencia3,
                                ),
                          ),
                        );
                      },
                      child: const Text(
                        'Ver Evidencias',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          Divider(height: 1, thickness: 1, color: Colors.grey.shade400),

          // --- Tabla de datos ---
          Table(
            border: TableBorder(
              horizontalInside: BorderSide(
                color: Colors.grey.shade300,
                width: 1,
              ),
            ),
            columnWidths: const <int, TableColumnWidth>{
              0: FlexColumnWidth(1.2),
              1: FlexColumnWidth(2.5),
              2: FlexColumnWidth(1.5),
              3: FlexColumnWidth(1.5),
              4: FlexColumnWidth(2),
              5: FlexColumnWidth(2),
            },
            children: [
              _buildHeaderRow(),
              ...filas.map((fila) => _buildDataRow(fila)).toList(),
            ],
          ),

          _LiquidacionSummary(item: primerItem),
        ],
      ),
    );
  }

  TableRow _buildDataRow(FilaEditable fila) {
    final item = fila.item;

    // Asegúrate de que estás devolviendo un TableRow
    return TableRow(
      children: [
        // Cada hijo aquí es una celda que corresponde a una columna del encabezado
        _buildCell(Text('${item.numeVuelSaliM}', textAlign: TextAlign.center)),
        _buildCell(
          Text('${item.horaI}\n${item.horaLl}', textAlign: TextAlign.center),
        ),
        _buildCell(
          Text(
            '${item.letraRutaSaliM}',
            textAlign: TextAlign.center,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        _buildCell(
          Text(
            '${item.letrFrec}',
            textAlign: TextAlign.center,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        _buildCell(
          Text(
            '${item.dineroRecaudoConductorIda}',
            textAlign: TextAlign.center,
          ),
        ),
        _buildCell(
          Text(
            '${item.dineroRecaudoConductorVuelta}',
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }

  Widget _buildCell(Widget child) {
    return TableCell(
      verticalAlignment: TableCellVerticalAlignment.middle,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 2.0),
        child: child,
      ),
    );
  }

  Widget titleTable(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 0.0),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: textSmall,
          fontWeight: FontWeight.normal,
        ),
      ),
    );
  }

  TableRow _buildHeaderRow() {
    // Asegúrate de que estás devolviendo un TableRow, no un Row
    return TableRow(
      // Es una buena práctica darle un color de fondo al encabezado
      decoration: BoxDecoration(color: Colors.grey.shade200),
      children: [
        // Cada hijo aquí es una celda de la fila.
        // Puedes usar una función helper para no repetir el estilo.
        _buildHeaderCell('#'),
        _buildHeaderCell('H. Salida'),
        _buildHeaderCell('Ruta'),
        _buildHeaderCell('Frec'),
        _buildHeaderCell('Sub.'),
        _buildHeaderCell('Baj.'),
      ],
    );
  }

  Widget _buildHeaderCell(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
      ),
    );
  }

  _getSalidas() async {
    setState(() {
      _cargandoSalidas = true;
      _liquidacionesAgrupadasDesdeAPI.clear();
      _mostrarCardNoData = false;
    });

    ProviLiquidacionSB servicio = ProviLiquidacionSB();

    // Ahora, fetchedResponse será correctamente de tipo GetLiquidacionAppPropietario
    GetLiquidacionAppPropietario fetchedResponse = await servicio
        .readLiquidacionSB(_unidad, _dateInputController.text);

    // Accedemos a la lista de datos a través de la propiedad 'datos'
    List<DatoLiquidacionSB>? fetchedData = fetchedResponse.datos;

    if (fetchedData != null && fetchedData.isNotEmpty) {
      datoLiquidacionSB = fetchedData;

      Map<String, List<FilaEditable>> tempGroupedMap = {};
      int currentLiquidacionId = 1;

      for (var apiDato in datoLiquidacionSB!) {
        String groupKey =
            "${apiDato.unidadLiquidacionM ?? 'Desconocida'}-${apiDato.fechaLiquidacionM}";

        LiquidacionItem item = LiquidacionItem(
          numeVuelSaliM: apiDato.numeVuelSaliM!,
          horaI: apiDato.horaSaliProgSaliM!,
          horaLl: apiDato.horaLlegProgSaliM!,
          letraRutaSaliM: apiDato.letraRutaSaliM!,
          letrFrec: apiDato.letrFrec!,
          dineroRecaudoConductorIda: apiDato.dineroRecaudoConductorIda!,
          dineroRecaudoConductorVuelta: apiDato.dineroRecaudoConductorVuelta!,
          codiVehiSaliM: apiDato.unidadLiquidacionM!,
          fechaLiquidacionM: apiDato.fechaLiquidacionM!,
          totalRecaudado: apiDato.totalRecaudado,
          totalGasto: apiDato.totalGasto,
          evidencia1: apiDato.evidencia1Foto,
          evidencia2: apiDato.evidencia2Foto,
          evidencia3: apiDato.evidencia3Foto,
          gastoConductor: apiDato.gastoConductor,
          gastoAyudante: apiDato.gastoAyudante,
          gastoComida: apiDato.gastoComida,
          gastoConbustible: apiDato.gastoConbustible,
          gastoHidratacion: apiDato.gastoHidratacion,
          gastoLimpieza: apiDato.gastoLimpieza,
          gastoPeaje: apiDato.gastoPeaje,
          gastoTicket: apiDato.gastoTicket,
          observacion: apiDato.observacion,
        );

        FilaEditable fila = FilaEditable(
          item: item,
          normalController: TextEditingController(
            text: "0",
          ), // Inicializa con valores si es editable
          preferencialController: TextEditingController(text: "0"),
          valorController: TextEditingController(text: "0"),
        );

        if (!tempGroupedMap.containsKey(groupKey)) {
          tempGroupedMap[groupKey] = [];
        }
        tempGroupedMap[groupKey]!.add(fila);
      }

      _liquidacionesAgrupadasDesdeAPI.clear();
      tempGroupedMap.forEach((key, value) {
        _liquidacionesAgrupadasDesdeAPI[currentLiquidacionId++] = value;
      });

      _mostrarCardNoData = false;
    } else {
      datoLiquidacionSB = [];
      _mostrarCardNoData = true;
    }

    setState(() {
      _cargandoSalidas = false;
    });
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

class LiquidacionItem {
  final int numeVuelSaliM;
  final String horaI;
  final String horaLl;
  final String letraRutaSaliM;
  final String letrFrec;
  final String dineroRecaudoConductorIda;
  final String dineroRecaudoConductorVuelta;
  final String codiVehiSaliM;
  final String fechaLiquidacionM;
  final String? totalRecaudado; // Asegúrate de que este campo existe
  final String? totalGasto;
  final String? gastoComida;
  final String? gastoConductor;
  final String? gastoAyudante;
  final String? gastoLimpieza;
  final String? gastoConbustible;
  final String? gastoTicket;
  final String? gastoPeaje;
  final String? gastoHidratacion;
  final String? evidencia1;
  final String? evidencia2;
  final String? evidencia3;
  final String? observacion;

  LiquidacionItem({
    required this.numeVuelSaliM,
    required this.horaI,
    required this.horaLl,
    required this.letraRutaSaliM,
    required this.letrFrec,
    required this.dineroRecaudoConductorIda,
    required this.dineroRecaudoConductorVuelta,
    required this.codiVehiSaliM,
    required this.fechaLiquidacionM,
    this.totalRecaudado, // Añadido
    this.totalGasto,
    this.gastoComida, // Añadido
    this.gastoConductor, // Añadido
    this.gastoAyudante, // Añadido
    this.gastoLimpieza, // Añadido
    this.gastoConbustible, // Añadido
    this.gastoTicket, // Añadido
    this.gastoPeaje, // Añadido
    this.gastoHidratacion, // Añadido
    this.evidencia1,
    this.evidencia2,
    this.evidencia3,
    this.observacion,
  });
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
          color: Colors.grey.withAlpha((0.25 * 255).toInt()),
        ),
        clipBehavior: Clip.antiAlias,
      ),
    );
  }
}

class _LiquidacionSummary extends StatelessWidget {
  // Recibe el item que contiene toda la información necesaria.
  final LiquidacionItem item;

  const _LiquidacionSummary({required this.item});

  @override
  Widget build(BuildContext context) {
    final double totalRecaudado =
        double.tryParse(item.totalRecaudado ?? '0') ?? 0.0;
    final double totalGasto = double.tryParse(item.totalGasto ?? '0') ?? 0.0;
    final double totalLiquidacion = totalRecaudado - totalGasto;
    final Color colorTotalLiquidacion =
        totalLiquidacion >= 0 ? Colors.green : Colors.red;

    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildDivider(),
          _buildTotalRow(
            label: 'Total Recaudado:',
            valor: ' ${totalRecaudado.toStringAsFixed(2)}',
            valorColor: Colors.green,
            isLabelBold: true,
          ),
          _buildDivider(),

          // --- Detalle de Gastos ---
          const Text(
            'Detalle de Gastos:',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          _buildGastoRow(
            'Comida',
            item.gastoComida,
            'Conductor',
            item.gastoConductor,
          ),
          _buildGastoRow(
            'Ayudante',
            item.gastoAyudante,
            'Limpieza',
            item.gastoLimpieza,
          ),
          _buildGastoRow(
            'Combustible',
            item.gastoConbustible,
            'Hidratación',
            item.gastoHidratacion,
          ),
          _buildGastoRow('Ticket', item.gastoTicket, 'Peaje', item.gastoPeaje),
          const SizedBox(height: 12),

          _buildTotalRow(
            label: 'Total Gastos:',
            valor: '${totalGasto.toStringAsFixed(2)}',
            valorColor: Colors.redAccent,
            isLabelBold: true,
          ),

          _buildDivider(),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Total Liquidación:',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              Text(
                '${totalLiquidacion.toStringAsFixed(2)}',
                style: TextStyle(
                  fontSize: 21,
                  fontWeight: FontWeight.bold,
                  color: colorTotalLiquidacion,
                ),
              ),
            ],
          ),
          SizedBox(height: 12),
          _buildObservacionInput(item.observacion!),
        ],
      ),
    );
  }

  Widget _buildTotalRow({
    required String label,
    required String valor,
    required Color valorColor,
    bool isLabelBold = false,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: isLabelBold ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        Text(
          valor,
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
            color: valorColor,
          ),
        ),
      ],
    );
  }

  Widget _buildGastoRow(
    String label1,
    String? valor1, [
    String? label2,
    String? valor2,
  ]) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: Row(
        children: [
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('$label1:', style: const TextStyle(fontSize: 14)),
                Text(
                  ' ${valor1 ?? '0.00'}',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          if (label2 != null) ...[
            const SizedBox(width: 24),
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('$label2:', style: const TextStyle(fontSize: 14)),
                  Text(
                    ' ${valor2 ?? '0.00'}',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 10.0),
      child: Divider(height: 1, thickness: 1, color: Colors.grey),
    );
  }

  Widget _buildObservacionInput(String observacion) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Observación',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 4),
          TextField(
            controller: TextEditingController(text: observacion),
            enabled: false,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              isDense: true,
              contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 10),
              hintText: 'Máximo 150 caracteres...',
            ),
            maxLines: 3,
            maxLength: 150,
            textCapitalization: TextCapitalization.sentences,
          ),
        ],
      ),
    );
  }
}
