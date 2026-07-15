import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:shimmer/shimmer.dart';
import '../models/liquidacionDia/liquidacion_dia.dart';
import '../models/login/login_propietario.dart';
import '../repositories/repo_liquidacion_dia.dart';
import '../repositories/security_data.dart';
import '../utils/colors.dart';
import '../utils/dimens.dart';
import '../utils/iconos.dart';
import 'r_liquidacion_dia_detalle_page.dart';

class ReporteLiquidacionDiaPage extends StatefulWidget {
  ReporteLiquidacionDiaPage({Key? key});

  SecurityData oS = new SecurityData();

  @override
  _LiquidacionDiaPageState createState() => _LiquidacionDiaPageState();
}

class _LiquidacionDiaPageState extends State<ReporteLiquidacionDiaPage> {
  List<DropdownMenuItem<String>> lista_unidades = [];

  //Estados
  String _unidad = "*";
  int position = 0;
  String _date = "";
  bool _cargando = false;
  LiquidacionDia? _resultado;

  final TextEditingController _dateInputController = TextEditingController();
  final ApiRepositorioLiquidacionDespacho _repo =
      ApiRepositorioLiquidacionDespacho();

  //Helpers
  Color _colorTotal(String? total) {
    if (total == null) return Colors.black;
    final value = double.tryParse(total) ?? 0;
    if (value > 0) return Colors.green;
    if (value < 0) return Colors.red;
    return Colors.black;
  }

  @override
  void initState() {
    super.initState();
    _getItemDropdownButton();
    _getFechaActual();
  }

  @override
  void dispose() {
    _dateInputController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light, // íconos blancos (Android)
        statusBarBrightness: Brightness.dark, // íconos blancos (iOS)
      ),
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            iconTheme: IconThemeData(color: colorWhite),
            backgroundColor: Colors.blue,
            title: Text(
              "R. Liquidación Diaria",
              style: TextStyle(color: colorWhite),
            ),
          ),
          resizeToAvoidBottomInset: false,
          backgroundColor: colorGrey,
          body: Column(
            children: [
              // Filtros
              (_cargando || lista_unidades.isEmpty)
                  ? _buildShimmerFiltros()
                  : Container(
                    margin: const EdgeInsets.only(
                      right: marginSmallSmall,
                      left: marginSmallSmall,
                      top: marginSmallSmall,
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
                            ),
                            child: DropdownButton<String>(
                              isExpanded: true,
                              underline: Container(height: 0),
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
                child: ElevatedButton.icon(
                  onPressed: _cargando ? null : _buscar,
                  icon:
                      _cargando
                          ? SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(
                              color: colorWhite,
                              strokeWidth: 2,
                            ),
                          )
                          : Icon(IconBuscar),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: colorWhite,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    minimumSize: const Size(double.infinity, 50),
                  ),
                  label: Text(
                    _cargando ? "Buscando..." : "Buscar",
                    style: const TextStyle(fontSize: textBigMedium),
                  ),
                ),
              ),
              const SizedBox(height: marginSmallSmall),
              // Resultado
              Expanded(child: _buildResultado()),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildResultado() {
    if (_cargando) {
      return _buildShimmerList();
    }

    if (_resultado == null) {
      return const Center(child: Text("Ingrese los filtros y presione Buscar"));
    }

    if (_resultado!.statusCode != 200) {
      return Center(child: Text(_resultado!.msm ?? "Sin datos"));
    }

    final datos = _resultado!.datos ?? [];

    if (datos.isEmpty) {
      return const Center(child: Text("No se encontraron registros"));
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: marginSmallSmall),
      itemCount: datos.length,
      itemBuilder: (context, index) {
        final dato = datos[index];

        return Card(
          margin: const EdgeInsets.only(bottom: 8),
          elevation: 1,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          child: InkWell(
            borderRadius: BorderRadius.circular(8),
            onTap:
                () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder:
                        (_) => DetalleLiquidacionDiaPage(
                          id: dato.id!,
                          titulo:
                              "${dato.DescRuta ?? '-'} · ${dato.fecha?.toString().split(' ')[0] ?? '-'}",
                        ),
                  ),
                ),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                children: [
                  const SizedBox(width: 10),
                  // Info central
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          dato.DescRuta ?? '-',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                          maxLines: 1,
                        ),
                        const SizedBox(height: 2),
                        Text(
                          dato.nombre ?? '-',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade600,
                          ),
                          maxLines: 1,
                        ),
                        const SizedBox(height: 2),
                        Text(
                          dato.fecha?.toString().split(' ')[0] ?? '-',
                          style: TextStyle(
                            fontSize: 11,
                            color: Colors.grey.shade400,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Total
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: _colorTotal(dato.total).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      "\$${dato.total ?? '0'}",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                        color: _colorTotal(dato.total),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildShimmerFiltros() {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: Container(
        margin: const EdgeInsets.only(
          right: marginSmallSmall,
          left: marginSmallSmall,
          top: marginSmallSmall,
        ),
        child: Row(
          children: [
            Expanded(
              child: Container(
                height: 48,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
            const SizedBox(width: marginSmallSmall),
            Expanded(
              child: Container(
                height: 48,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildShimmerList() {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: marginSmallSmall),
        itemCount: 6,
        itemBuilder: (context, index) {
          return Card(
            margin: const EdgeInsets.only(bottom: 8),
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 140,
                          height: 14,
                          decoration: BoxDecoration(
                            color: Colors.grey.shade300,
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                        const SizedBox(height: 6),
                        Container(
                          width: 100,
                          height: 12,
                          decoration: BoxDecoration(
                            color: Colors.grey.shade300,
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                        const SizedBox(height: 6),
                        Container(
                          width: 70,
                          height: 11,
                          decoration: BoxDecoration(
                            color: Colors.grey.shade300,
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: 60,
                    height: 24,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Future<void> _buscar() async {
    setState(() {
      _cargando = true;
      _resultado = null;
    });

    final resultado = await _repo.fetchLiquidacionDia(_unidad, _date);

    setState(() {
      _cargando = false;
      _resultado = resultado;
    });

    final datos = resultado.datos ?? [];

    if (resultado.statusCode == 200 && datos.isNotEmpty) {
      showTopSnackBar(
        Overlay.of(context),
        CustomSnackBar.success(
          message: "Se encontraron ${datos.length} registro(s)",
        ),
      );
    } else {
      showTopSnackBar(
        Overlay.of(context),
        CustomSnackBar.error(
          message: resultado.msm ?? "No se encontraron registros",
        ),
      );
    }
  }

  int _getPosition(String value) {
    for (var i = 0; i < lista_unidades.length; i++) {
      if (lista_unidades[i].value == value) return i;
    }
    return 0;
  }

  _getSelectDate(BuildContext context) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2050),
      locale: const Locale('es'),
    );
    if (picked != null) {
      setState(() {
        _date = DateFormat('yyyy-MM-dd').format(picked);
        _dateInputController.text = _date;
      });
    }
  }

  _getFechaActual() {
    setState(() {
      _date = DateFormat('yyyy-MM-dd').format(DateTime.now());
      _dateInputController.text = _date;
    });
  }

  _getItemDropdownButton() async {
    var jsonDataL = await widget.oS.readDataPreferenciasLoginPropietario(
      'dataLoginPropietarioLoginUnidadesd',
    );
    LoginPropietario listabuses = LoginPropietario.fromRawJson(jsonDataL);

    setState(() {
      lista_unidades.add(
        DropdownMenuItem<String>(child: Text('*'), value: '*'),
      );
      listabuses.data!.forEach((element) {
        lista_unidades.add(
          DropdownMenuItem<String>(
            child: Row(
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
}
