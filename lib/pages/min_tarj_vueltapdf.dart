import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:shimmer/shimmer.dart';
import 'package:pdf/widgets.dart' as pw;
import '../models/code_activacion/code_activacion.dart';
import '../models/min_tarj_vuelta/data_min_tarj_vuelta.dart';
import '../models/min_tarj_vuelta/min_tarj_vuelta.dart';
import '../repositories/repo_min_tar_vuelta.dart';
import '../repositories/security_data.dart';
import '../utils/colors.dart';
import '../utils/dimens.dart';


class MinTarjetasPDF_Vuelta extends StatefulWidget {
  String empresa = "";
  SecurityData oS = new SecurityData();
  final String _fechaI;
  final String _fechaF;
  final String _unidad;
  List<DatosMinTarjetasVuelta>? mList;
  MinTarjetasPDF_Vuelta(String _fechaI, String _fechaF, String _unidad)
    : this._fechaI = _fechaI,
      this._fechaF = _fechaF,
      this._unidad = _unidad;

  @override
  State<MinTarjetasPDF_Vuelta> createState() => _MinTarjetasPDF_VueltaState();
}

class _MinTarjetasPDF_VueltaState extends State<MinTarjetasPDF_Vuelta> {
  MinTarVueltaAppMovil? datoMinTarVuelta = null;
  @override
  void initState() {
    _readName();
    setState(() {
      datoMinTarVuelta = new MinTarVueltaAppMovil(statusCode: null);
    });
    _getDataReporteMinTarVuelta();

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
          title: Text('Reporte Minutos y Tarjetas Vuelta'),
          backgroundColor: Colors.blue,
          foregroundColor: Colors.white,
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.red,
          foregroundColor: Colors.white,
          heroTag: 'pdf',
          tooltip: 'PDF',
          onPressed: () async {
            if (datoMinTarVuelta!.statusCode == 200) {
              List<int> data = await createReporteMinTarjetas(widget.mList!);
              savePdfFile(
                "Reporte_Minutos_Tarjetas_Diarias_Vuelta_Resumido.pdf",
                data,
              );

              /*if (Platform.isAndroid) {
                List<int> data = await createReporteMinTarjetas(widget.mList!);
                savePdfFile(
                  "Reporte_Minutos_Tarjetas_Diarias_Vuelta_Resumido.pdf",
                  data,
                );
              } else {
                List<int> data = await createReporteMinTarjetas(widget.mList!);
                String path = await savePdfFileIOS(
                  "Reporte_Minutos_Tarjetas_Diarias_Vuelta_Resumido.pdf",
                  data,
                );
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => PdfViewIos(path)),
                );
              }*/
            } else {
              Navigator.pop(context);
            }
          },
          child: Icon(Icons.picture_as_pdf),
        ),
        body: Stack(
          children: [
            InteractiveViewer(
              boundaryMargin: EdgeInsets.all(50),
              maxScale: 4,
              minScale: 0.1,
              child: minTarVueltaPdf(),
            ),
          ],
        ),
      ),
    );
  }

  getElement<Widget>(BuildContext context, MinTarVueltaAppMovil model) {
    widget.mList = model.datos;
    createReporteMinTarjetas(widget.mList!);
    return Container(
      child: SingleChildScrollView(
        child: Column(
          children: [
            Text(
              widget.empresa,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.black,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              "Reporte de Minutos y Tarjetas",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.black,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Column(
                children: [
                  for (
                    var i = 0;
                    i < widget.mList![0].salidas!.length;
                    i++
                  ) ...[
                    const SizedBox(height: 10),
                    Column(
                      children: [
                        Row(
                          children: [
                            Text(
                              "UNIDAD N° " + widget.mList![0].unidad!,
                              style: TextStyle(fontSize: 16),
                            ),
                            Text("              "),
                            Text(
                              widget.mList![0].salidas![i].fechas! +
                                  "             ",
                              style: TextStyle(fontSize: 16),
                            ),
                            Text("               "),
                            Text(widget.mList![0].salidas![i].linea!),
                            Text("                 "),
                            Text(
                              "Salida # " +
                                  widget.mList![0].salidas![i].salida!
                                      .toString(),
                            ),
                            Text("              "),
                          ],
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              "N° Vuelta: " +
                                  widget.mList![0].salidas![i].numeVuelSaliM!
                                      .toString(),
                              style: TextStyle(fontSize: 16),
                            ),
                            Text(
                              "                                                                                                                                                                                                ",
                            ),
                          ],
                        ),
                      ],
                    ),
                    Table(
                      border: TableBorder.all(color: Colors.black),
                      columnWidths: {
                        0: FixedColumnWidth(190.0), // fixed to 100 width
                        1: FixedColumnWidth(130.0),
                        2: IntrinsicColumnWidth(),
                        3: IntrinsicColumnWidth(),
                        4: IntrinsicColumnWidth(),
                        5: IntrinsicColumnWidth(), //fixed to 100 width
                      },
                      children: <TableRow>[
                        TableRow(
                          children: [
                            TableCell(
                              child: Container(
                                padding: EdgeInsets.only(
                                  left: 0,
                                  top: 5,
                                  right: 0,
                                  bottom: 5,
                                ),
                                child: Text(
                                  "Control",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                            TableCell(
                              child: Column(
                                children: [
                                  Text(
                                    "Control",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Table(
                                    columnWidths: {
                                      0: FixedColumnWidth(
                                        65.0,
                                      ), // fixed to 100 width
                                      1: FixedColumnWidth(
                                        65.0,
                                      ), //fixed to 100 width
                                    },
                                    border: TableBorder.symmetric(
                                      outside: const BorderSide(
                                        width: 1,
                                        color: Colors.black,
                                        style: BorderStyle.solid,
                                      ),
                                      inside: const BorderSide(
                                        width: 1,
                                        color: Colors.black,
                                        style: BorderStyle.solid,
                                      ),
                                    ),
                                    children: <TableRow>[
                                      TableRow(
                                        children: [
                                          TableCell(
                                            child: Container(
                                              child: Text(
                                                "Timbrar",
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                          ),
                                          TableCell(
                                            child: Container(
                                              child: Text(
                                                "Llegó",
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            TableCell(
                              child: Column(
                                children: [
                                  Text(
                                    "FALTAS",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Table(
                                    columnWidths: {
                                      0: FixedColumnWidth(
                                        70.0,
                                      ), // fixed to 100 width
                                      1: FixedColumnWidth(
                                        70.0,
                                      ), //fixed to 100 width
                                    },
                                    border: TableBorder.symmetric(
                                      outside: const BorderSide(
                                        width: 1,
                                        color: Colors.black,
                                        style: BorderStyle.solid,
                                      ),
                                      inside: const BorderSide(
                                        width: 1,
                                        color: Colors.black,
                                        style: BorderStyle.solid,
                                      ),
                                    ),
                                    children: <TableRow>[
                                      TableRow(
                                        children: [
                                          TableCell(
                                            child: Container(
                                              padding: EdgeInsets.only(
                                                left: 15,
                                              ),
                                              child: Text(
                                                "Atraso",
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                          ),
                                          TableCell(
                                            child: Container(
                                              padding: EdgeInsets.only(
                                                right: 15,
                                              ),
                                              child: Text(
                                                "Adelanto",
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            TableCell(
                              child: Column(
                                children: [
                                  Text(
                                    "JUSTIFICACIONES",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Table(
                                    columnWidths: {
                                      0: FixedColumnWidth(
                                        70.0,
                                      ), // fixed to 100 width
                                      1: FixedColumnWidth(
                                        70.0,
                                      ), //fixed to 100 width
                                    },
                                    border: TableBorder.symmetric(
                                      outside: const BorderSide(
                                        width: 1,
                                        color: Colors.black,
                                        style: BorderStyle.solid,
                                      ),
                                      inside: const BorderSide(
                                        width: 1,
                                        color: Colors.black,
                                        style: BorderStyle.solid,
                                      ),
                                    ),
                                    children: <TableRow>[
                                      TableRow(
                                        children: [
                                          TableCell(
                                            child: Container(
                                              padding: EdgeInsets.only(
                                                left: 15,
                                              ),
                                              child: Text(
                                                "Atraso",
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                          ),
                                          TableCell(
                                            child: Container(
                                              padding: EdgeInsets.only(
                                                right: 15,
                                              ),
                                              child: Text(
                                                "Adelanto",
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            TableCell(
                              child: Container(
                                padding: EdgeInsets.all(5),
                                child: Text(
                                  "Rubros",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                            TableCell(
                              child: Container(
                                padding: EdgeInsets.all(5),
                                child: Text(
                                  "Veloc.",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        for (var item
                            in widget.mList![0].salidas![i].minutos!) ...[
                          TableRow(
                            children: [
                              Container(
                                child: Text(
                                  item.descripcionControl!,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(fontSize: 12),
                                ),
                              ),
                              Container(
                                child: Table(
                                  columnWidths: {
                                    0: FixedColumnWidth(
                                      65.0,
                                    ), // fixed to 100 width
                                    1: FixedColumnWidth(
                                      65.0,
                                    ), //fixed to 100 width
                                  },
                                  border: TableBorder.symmetric(
                                    inside: const BorderSide(
                                      width: 1,
                                      color: Colors.black,
                                      style: BorderStyle.solid,
                                    ),
                                  ),
                                  children: <TableRow>[
                                    TableRow(
                                      children: [
                                        TableCell(
                                          child: Container(
                                            child: Text(
                                              item.horaProgSaliD!,
                                              textAlign: TextAlign.center,
                                              style: TextStyle(fontSize: 12),
                                            ),
                                          ),
                                        ),
                                        TableCell(
                                          child: Container(
                                            child: Text(
                                              item.horaMarcSaliD!,
                                              textAlign: TextAlign.center,
                                              style: TextStyle(fontSize: 12),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                child: Table(
                                  columnWidths: {
                                    0: FixedColumnWidth(
                                      70.0,
                                    ), // fixed to 100 width
                                    1: FixedColumnWidth(
                                      70.0,
                                    ), //fixed to 100 width
                                  },
                                  border: TableBorder.symmetric(
                                    inside: const BorderSide(
                                      width: 1,
                                      color: Colors.black,
                                      style: BorderStyle.solid,
                                    ),
                                  ),
                                  children: <TableRow>[
                                    TableRow(
                                      children: [
                                        TableCell(
                                          child: Container(
                                            child: Text(
                                              item.atrasoFTiempo!,
                                              textAlign: TextAlign.center,
                                              style: TextStyle(fontSize: 12),
                                            ),
                                          ),
                                        ),
                                        TableCell(
                                          child: Container(
                                            child: Text(
                                              item.adelantoFTiempo!,
                                              textAlign: TextAlign.center,
                                              style: TextStyle(fontSize: 12),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                child: Table(
                                  columnWidths: {
                                    0: FixedColumnWidth(
                                      70.0,
                                    ), // fixed to 100 width
                                    1: FixedColumnWidth(
                                      70.0,
                                    ), //fixed to 100 width
                                  },
                                  border: TableBorder.symmetric(
                                    inside: const BorderSide(
                                      width: 1,
                                      color: Colors.black,
                                      style: BorderStyle.solid,
                                    ),
                                  ),
                                  children: <TableRow>[
                                    TableRow(
                                      children: [
                                        TableCell(
                                          child: Container(
                                            child: Text(
                                              item.atrasoJTiempo!,
                                              textAlign: TextAlign.center,
                                              style: TextStyle(fontSize: 12),
                                            ),
                                          ),
                                        ),
                                        TableCell(
                                          child: Container(
                                            child: Text(
                                              item.adelantoJTiempo!,
                                              textAlign: TextAlign.center,
                                              style: TextStyle(fontSize: 12),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                child: Text(
                                  item.rubroPenalidad == 0
                                      ? ""
                                      : item.rubroPenalidad.toString(),
                                  textAlign: TextAlign.center,
                                  style: TextStyle(fontSize: 12),
                                ),
                              ),
                              Container(
                                child: Text(
                                  item.velocidadPenalidad == 0
                                      ? ""
                                      : item.velocidadPenalidad.toString(),
                                  textAlign: TextAlign.center,
                                  style: TextStyle(fontSize: 12),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ],
                    ),
                  ],
                  const SizedBox(height: 40),
                  Column(
                    children: [
                      Container(
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "ATRASO : " +
                                      widget.mList![0].atrasoFTiempoCabezera! +
                                      "   ",
                                  style: TextStyle(fontSize: 13),
                                ),
                                Text(
                                  "ADELANTO: " +
                                      widget
                                          .mList![0]
                                          .adelantoFTiempoCabezera! +
                                      "      ",
                                  style: TextStyle(fontSize: 13),
                                ),
                                Text(
                                  "ATRASO JUSTIF: " +
                                      widget.mList![0].atrasoJTiempoCabezera! +
                                      "    ",
                                  style: TextStyle(fontSize: 13),
                                ),
                                Text(
                                  "ADELANTO JUSTIF: " +
                                      widget
                                          .mList![0]
                                          .adelantoJTiempoCabezera! +
                                      "    ",
                                  style: TextStyle(fontSize: 13),
                                ),
                              ],
                            ),
                            const SizedBox(height: 5),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "RUBROS: " +
                                      widget.mList![0].rubroPenalidadCabezera! +
                                      "         ",
                                  style: TextStyle(fontSize: 13),
                                ),
                                Text(
                                  "F VELOCIDAD (\$): " +
                                      widget
                                          .mList![0]
                                          .velocidadPenalidadCabezera! +
                                      "        ",
                                  style: TextStyle(fontSize: 13),
                                ),
                                Text(
                                  "TARJETA (\$): " +
                                      widget.mList![0].tarjetaDiariaCabezera! +
                                      "              ",
                                  style: TextStyle(fontSize: 13),
                                ),
                                Text(
                                  "ATRASOS (\$): " +
                                      widget
                                          .mList![0]
                                          .atrasoPenalidadCabezera! +
                                      "              ",
                                  style: TextStyle(fontSize: 13),
                                ),
                              ],
                            ),
                            const SizedBox(height: 5),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "ADELANTOS: " +
                                      widget
                                          .mList![0]
                                          .adelantoPenalidadCabezera! +
                                      "                                           ",
                                  style: TextStyle(fontSize: 13),
                                ),
                                Text(
                                  "TOTAL (\$): " +
                                      widget.mList![0].deudaTotalCabezera!,
                                  style: TextStyle(
                                    fontSize: 30,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text("                         "),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  _cardNoData() {
    return Container(
      height: 180,
      margin: const EdgeInsets.only(
        right: marginSmallSmall,
        left: marginSmallSmall,
        bottom: marginSmallSmall,
        top: marginBig,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: colorWhite,
        boxShadow: [boxShadowPersonalizado],
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          Container(
            color: Colors.white,
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  children: [
                    Container(
                      padding: EdgeInsets.all(10),
                      margin: EdgeInsets.only(top: 10),
                      child: Text(
                        'No Existen Datos ',
                        style: TextStyle(
                          fontSize: textBig,
                          color: colorBlack,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Container(
                      child: Text(
                        'El bus ${widget._unidad} en la fecha ${widget._fechaI} hasta',
                        overflow: TextOverflow.fade,
                        maxLines: 2,
                        style: TextStyle(
                          fontSize: textMedium,
                          color: colorBlack,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ),
                    Container(
                      child: Text(
                        ' ${widget._fechaF} no tiene datos por favor',
                        overflow: TextOverflow.fade,
                        maxLines: 2,
                        style: TextStyle(
                          fontSize: textMedium,
                          color: colorBlack,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ),
                    Container(
                      child: Text(
                        ' verificar la fecha',
                        overflow: TextOverflow.fade,
                        maxLines: 2,
                        style: TextStyle(
                          fontSize: textMedium,
                          color: colorBlack,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 10),
                      alignment: Alignment.bottomRight,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: const Text(
                          "Ok",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  cardShimmer() {
    return Container(
      margin: EdgeInsets.only(top: 10, left: 10, right: 10),
      child: const Column(
        children: [
          Center(child: Skelton(height: 10, width: 100)),
          Row(
            children: [
              Skelton(height: 10, width: 20),
              SizedBox(width: 10),
              Skelton(height: 10, width: 40),
              SizedBox(width: 100),
              Skelton(height: 10, width: 40),
              SizedBox(width: 10),
              Skelton(height: 10, width: 80),
            ],
          ),
          Row(
            children: [
              Skelton(height: 10, width: 20),
              SizedBox(width: 10),
              Skelton(height: 10, width: 30),
              SizedBox(width: 80),
              Skelton(height: 10, width: 40),
              SizedBox(width: 10),
              Skelton(height: 10, width: 20),
            ],
          ),
          Center(child: Skelton(height: 10, width: 200)),
          Row(
            children: [
              Skelton(height: 10, width: 40),
              SizedBox(width: 30),
              Skelton(height: 10, width: 40),
              SizedBox(width: 30),
              Skelton(height: 10, width: 80),
            ],
          ),
          Row(
            children: [
              Skelton(height: 10, width: 40),
              SizedBox(width: 30),
              Skelton(height: 10, width: 40),
              SizedBox(width: 30),
              Skelton(height: 10, width: 80),
            ],
          ),
          Row(
            children: [
              Skelton(height: 10, width: 40),
              SizedBox(width: 30),
              Skelton(height: 10, width: 40),
              SizedBox(width: 30),
              Skelton(height: 10, width: 80),
            ],
          ),
          Center(child: Skelton(height: 10, width: 200)),
          Center(child: Skelton(height: 10, width: 150)),
        ],
      ),
    );
  }

  Future<Uint8List> createReporteMinTarjetas(
    List<DatosMinTarjetasVuelta> listMintar,
  ) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        orientation: pw.PageOrientation.portrait,
        //margin: pw.EdgeInsets.only(left: 20, top: 12, right: 14, bottom: 13),
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        build: (pw.Context context) {
          return [
            pw.Column(
              children: [
                pw.Text(
                  widget.empresa,
                  style: pw.TextStyle(
                    fontSize: 14,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
                pw.Text(
                  "Reporte de Minutos y Tarjetas Vueltas",
                  style: pw.TextStyle(
                    fontSize: 14,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
                pw.Column(
                  children: [
                    for (var i = 0; i < listMintar[0].salidas!.length; i++) ...[
                      pw.SizedBox(height: 10),
                      pw.Row(
                        children: [
                          pw.Text(
                            "UNIDAD N° " + listMintar[0].unidad! + "   ",
                            style: pw.TextStyle(fontSize: 12),
                          ),
                          pw.Text(
                            listMintar[0].salidas![i].fechas! + "   ",
                            style: pw.TextStyle(fontSize: 12),
                          ),
                          pw.Text(
                            listMintar[0].salidas![i].linea! + "   ",
                            style: pw.TextStyle(fontSize: 12),
                          ),
                          pw.Text(
                            "Salida # " +
                                listMintar[0].salidas![i].salida.toString(),
                            style: pw.TextStyle(fontSize: 12),
                          ),
                        ],
                      ),
                      pw.Row(
                        children: [
                          pw.Text(
                            "N° Vuelta : " +
                                listMintar[0].salidas![i].numeVuelSaliM
                                    .toString() +
                                "   ",
                            style: pw.TextStyle(fontSize: 12),
                          ),
                        ],
                      ),
                      pw.Table(
                        border: pw.TableBorder.all(),
                        columnWidths: {
                          0: pw.FixedColumnWidth(150.0), // fixed to 100 width
                          1: pw.FixedColumnWidth(100.0),
                          2: pw.IntrinsicColumnWidth(),
                          3: pw.IntrinsicColumnWidth(),
                          4: pw.FixedColumnWidth(40.0),
                          5: pw.FixedColumnWidth(40.0), //fixed to 100 width
                        },
                        children: [
                          pw.TableRow(
                            children: [
                              pw.Column(
                                mainAxisSize: pw.MainAxisSize.min,
                                crossAxisAlignment:
                                    pw.CrossAxisAlignment.center,
                                mainAxisAlignment: pw.MainAxisAlignment.center,
                                children: [
                                  pw.Text(
                                    "Descipción Control",
                                    style: pw.TextStyle(
                                      fontSize: 10,
                                      fontWeight: pw.FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              pw.Column(
                                mainAxisSize: pw.MainAxisSize.min,
                                crossAxisAlignment:
                                    pw.CrossAxisAlignment.center,
                                mainAxisAlignment: pw.MainAxisAlignment.center,
                                children: [
                                  pw.Text(
                                    "Control",
                                    style: pw.TextStyle(
                                      fontSize: 10,
                                      fontWeight: pw.FontWeight.bold,
                                    ),
                                  ),
                                  pw.Table(
                                    border: pw.TableBorder.all(),
                                    columnWidths: {
                                      0: pw.FixedColumnWidth(60.0),
                                      1: pw.FixedColumnWidth(60.0),
                                    },
                                    children: [
                                      pw.TableRow(
                                        children: [
                                          pw.Column(
                                            mainAxisSize: pw.MainAxisSize.max,
                                            crossAxisAlignment:
                                                pw.CrossAxisAlignment.center,
                                            mainAxisAlignment:
                                                pw.MainAxisAlignment.center,
                                            children: [
                                              pw.Text(
                                                "Timbrar",
                                                style: pw.TextStyle(
                                                  fontSize: 10,
                                                  fontWeight:
                                                      pw.FontWeight.bold,
                                                ),
                                              ),
                                            ],
                                          ),
                                          pw.Column(
                                            mainAxisSize: pw.MainAxisSize.max,
                                            crossAxisAlignment:
                                                pw.CrossAxisAlignment.center,
                                            mainAxisAlignment:
                                                pw.MainAxisAlignment.center,
                                            children: [
                                              pw.Text(
                                                "Llego",
                                                style: pw.TextStyle(
                                                  fontSize: 10,
                                                  fontWeight:
                                                      pw.FontWeight.bold,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              pw.Column(
                                mainAxisSize: pw.MainAxisSize.min,
                                crossAxisAlignment:
                                    pw.CrossAxisAlignment.center,
                                mainAxisAlignment: pw.MainAxisAlignment.center,
                                children: [
                                  pw.Text(
                                    "FALTAS",
                                    style: pw.TextStyle(
                                      fontSize: 10,
                                      fontWeight: pw.FontWeight.bold,
                                    ),
                                  ),
                                  pw.Table(
                                    border: pw.TableBorder.all(),
                                    columnWidths: {
                                      0: pw.FixedColumnWidth(55.0),
                                      1: pw.FixedColumnWidth(55.0),
                                    },
                                    children: [
                                      pw.TableRow(
                                        children: [
                                          pw.Column(
                                            mainAxisSize: pw.MainAxisSize.max,
                                            crossAxisAlignment:
                                                pw.CrossAxisAlignment.center,
                                            mainAxisAlignment:
                                                pw.MainAxisAlignment.center,
                                            children: [
                                              pw.Text(
                                                "Atraso",
                                                style: pw.TextStyle(
                                                  fontSize: 10,
                                                  fontWeight:
                                                      pw.FontWeight.bold,
                                                ),
                                              ),
                                            ],
                                          ),
                                          pw.Column(
                                            mainAxisSize: pw.MainAxisSize.max,
                                            crossAxisAlignment:
                                                pw.CrossAxisAlignment.center,
                                            mainAxisAlignment:
                                                pw.MainAxisAlignment.center,
                                            children: [
                                              pw.Text(
                                                "Adelanto",
                                                style: pw.TextStyle(
                                                  fontSize: 10,
                                                  fontWeight:
                                                      pw.FontWeight.bold,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              pw.Column(
                                mainAxisSize: pw.MainAxisSize.min,
                                crossAxisAlignment:
                                    pw.CrossAxisAlignment.center,
                                mainAxisAlignment: pw.MainAxisAlignment.center,
                                children: [
                                  pw.Text(
                                    "JUSTIFICACIONES",
                                    style: pw.TextStyle(
                                      fontSize: 10,
                                      fontWeight: pw.FontWeight.bold,
                                    ),
                                  ),
                                  pw.Table(
                                    border: pw.TableBorder.all(),
                                    columnWidths: {
                                      0: pw.FixedColumnWidth(55.0),
                                      1: pw.FixedColumnWidth(55.0),
                                    },
                                    children: [
                                      pw.TableRow(
                                        children: [
                                          pw.Column(
                                            mainAxisSize: pw.MainAxisSize.max,
                                            crossAxisAlignment:
                                                pw.CrossAxisAlignment.center,
                                            mainAxisAlignment:
                                                pw.MainAxisAlignment.center,
                                            children: [
                                              pw.Text(
                                                "Atraso",
                                                style: pw.TextStyle(
                                                  fontSize: 10,
                                                  fontWeight:
                                                      pw.FontWeight.bold,
                                                ),
                                              ),
                                            ],
                                          ),
                                          pw.Column(
                                            mainAxisSize: pw.MainAxisSize.max,
                                            crossAxisAlignment:
                                                pw.CrossAxisAlignment.center,
                                            mainAxisAlignment:
                                                pw.MainAxisAlignment.center,
                                            children: [
                                              pw.Text(
                                                "Adelanto",
                                                style: pw.TextStyle(
                                                  fontSize: 10,
                                                  fontWeight:
                                                      pw.FontWeight.bold,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              pw.Column(
                                crossAxisAlignment:
                                    pw.CrossAxisAlignment.center,
                                mainAxisAlignment: pw.MainAxisAlignment.center,
                                mainAxisSize: pw.MainAxisSize.min,
                                children: [
                                  pw.Text(
                                    "Rubros",
                                    style: pw.TextStyle(
                                      fontSize: 10,
                                      fontWeight: pw.FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              pw.Column(
                                crossAxisAlignment:
                                    pw.CrossAxisAlignment.center,
                                mainAxisAlignment: pw.MainAxisAlignment.center,
                                mainAxisSize: pw.MainAxisSize.min,
                                children: [
                                  pw.Text(
                                    "Veloc.",
                                    style: pw.TextStyle(
                                      fontSize: 10,
                                      fontWeight: pw.FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          for (var item
                              in listMintar[0].salidas![i].minutos!) ...[
                            pw.TableRow(
                              children: [
                                pw.Column(
                                  crossAxisAlignment:
                                      pw.CrossAxisAlignment.center,
                                  mainAxisAlignment:
                                      pw.MainAxisAlignment.center,
                                  children: [
                                    pw.Text(
                                      item.descripcionControl!,
                                      style: pw.TextStyle(fontSize: 10),
                                    ),
                                  ],
                                ),
                                pw.Column(
                                  crossAxisAlignment:
                                      pw.CrossAxisAlignment.center,
                                  mainAxisAlignment:
                                      pw.MainAxisAlignment.center,
                                  children: [
                                    pw.Table(
                                      border: pw.TableBorder.all(),
                                      columnWidths: {
                                        0: pw.FixedColumnWidth(60.0),
                                        1: pw.FixedColumnWidth(60.0),
                                      },
                                      children: [
                                        pw.TableRow(
                                          children: [
                                            pw.Column(
                                              crossAxisAlignment:
                                                  pw.CrossAxisAlignment.center,
                                              mainAxisAlignment:
                                                  pw.MainAxisAlignment.center,
                                              children: [
                                                pw.Text(
                                                  item.horaProgSaliD!,
                                                  style: pw.TextStyle(
                                                    fontSize: 10,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            pw.Column(
                                              crossAxisAlignment:
                                                  pw.CrossAxisAlignment.center,
                                              mainAxisAlignment:
                                                  pw.MainAxisAlignment.center,
                                              children: [
                                                pw.Text(
                                                  item.horaMarcSaliD!,
                                                  style: pw.TextStyle(
                                                    fontSize: 10,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                pw.Column(
                                  crossAxisAlignment:
                                      pw.CrossAxisAlignment.center,
                                  mainAxisAlignment:
                                      pw.MainAxisAlignment.center,
                                  children: [
                                    pw.Table(
                                      border: pw.TableBorder.all(),
                                      columnWidths: {
                                        0: pw.FixedColumnWidth(55.0),
                                        1: pw.FixedColumnWidth(55.0),
                                      },
                                      children: [
                                        pw.TableRow(
                                          children: [
                                            pw.Column(
                                              crossAxisAlignment:
                                                  pw.CrossAxisAlignment.center,
                                              mainAxisAlignment:
                                                  pw.MainAxisAlignment.center,
                                              children: [
                                                pw.Text(
                                                  item.atrasoFTiempo!,
                                                  style: pw.TextStyle(
                                                    fontSize: 10,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            pw.Column(
                                              crossAxisAlignment:
                                                  pw.CrossAxisAlignment.center,
                                              mainAxisAlignment:
                                                  pw.MainAxisAlignment.center,
                                              children: [
                                                pw.Text(
                                                  item.adelantoFTiempo!,
                                                  style: pw.TextStyle(
                                                    fontSize: 10,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                pw.Column(
                                  crossAxisAlignment:
                                      pw.CrossAxisAlignment.center,
                                  mainAxisAlignment:
                                      pw.MainAxisAlignment.center,
                                  children: [
                                    pw.Table(
                                      border: pw.TableBorder.all(),
                                      columnWidths: {
                                        0: pw.FixedColumnWidth(55.0),
                                        1: pw.FixedColumnWidth(55.0),
                                      },
                                      children: [
                                        pw.TableRow(
                                          children: [
                                            pw.Column(
                                              crossAxisAlignment:
                                                  pw.CrossAxisAlignment.center,
                                              mainAxisAlignment:
                                                  pw.MainAxisAlignment.center,
                                              children: [
                                                pw.Text(
                                                  item.atrasoJTiempo!,
                                                  style: pw.TextStyle(
                                                    fontSize: 10,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            pw.Column(
                                              crossAxisAlignment:
                                                  pw.CrossAxisAlignment.center,
                                              mainAxisAlignment:
                                                  pw.MainAxisAlignment.center,
                                              children: [
                                                pw.Text(
                                                  item.adelantoJTiempo!,
                                                  style: pw.TextStyle(
                                                    fontSize: 10,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                pw.Column(
                                  crossAxisAlignment:
                                      pw.CrossAxisAlignment.center,
                                  mainAxisAlignment:
                                      pw.MainAxisAlignment.center,
                                  children: [
                                    pw.Text(
                                      item.rubroPenalidad == 0
                                          ? ""
                                          : item.rubroPenalidad.toString(),
                                      style: pw.TextStyle(fontSize: 10),
                                    ),
                                  ],
                                ),
                                pw.Column(
                                  crossAxisAlignment:
                                      pw.CrossAxisAlignment.center,
                                  mainAxisAlignment:
                                      pw.MainAxisAlignment.center,
                                  children: [
                                    pw.Text(
                                      item.velocidadPenalidad == 0
                                          ? ""
                                          : item.velocidadPenalidad.toString(),
                                      style: pw.TextStyle(fontSize: 10),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ],
                      ),
                    ],
                    //hasta aqui llega el for del j

                    //hasta aqui llega el for del i
                  ],
                ),
                pw.SizedBox(height: 30),
                pw.Column(
                  children: [
                    pw.Container(
                      child: pw.Column(
                        children: [
                          pw.Row(
                            mainAxisAlignment: pw.MainAxisAlignment.start,
                            children: [
                              pw.Text(
                                "ATRASO: " +
                                    listMintar[0].atrasoFTiempoCabezera! +
                                    "   ",
                                style: pw.TextStyle(fontSize: 11),
                              ),
                              pw.Text(
                                "ADELANTO: " +
                                    listMintar[0].adelantoFTiempoCabezera! +
                                    "    ",
                                style: pw.TextStyle(fontSize: 11),
                              ),
                              pw.Text(
                                "ATRASO JUSTIF: " +
                                    listMintar[0].atrasoJTiempoCabezera! +
                                    "   ",
                                style: pw.TextStyle(fontSize: 11),
                              ),
                              pw.Text(
                                "ADELANTO JUSTIF: " +
                                    listMintar[0].adelantoJTiempoCabezera! +
                                    "    ",
                                style: pw.TextStyle(fontSize: 11),
                              ),
                            ],
                          ),
                          pw.SizedBox(height: 5),
                          pw.Row(
                            mainAxisAlignment: pw.MainAxisAlignment.start,
                            children: [
                              pw.Text(
                                "RUBROS: " +
                                    listMintar[0].rubroPenalidadCabezera! +
                                    "         ",
                                style: pw.TextStyle(fontSize: 11),
                              ),
                              pw.Text(
                                "F VELOCIDAD (\$): " +
                                    listMintar[0].velocidadPenalidadCabezera! +
                                    "  ",
                                style: pw.TextStyle(fontSize: 11),
                              ),
                              pw.Text(
                                "TARJETA (\$): " +
                                    listMintar[0].tarjetaDiariaCabezera! +
                                    "                 ",
                                style: pw.TextStyle(fontSize: 11),
                              ),
                              pw.Text(
                                "ATRASOS (\$): " +
                                    listMintar[0].atrasoPenalidadCabezera! +
                                    "         ",
                                style: pw.TextStyle(fontSize: 11),
                              ),
                            ],
                          ),
                          pw.SizedBox(height: 5),
                          pw.Row(
                            mainAxisAlignment: pw.MainAxisAlignment.start,
                            children: [
                              pw.Text(
                                "ADELANTOS: " +
                                    widget
                                        .mList![0]
                                        .adelantoPenalidadCabezera! +
                                    "                             ",
                                style: pw.TextStyle(fontSize: 11),
                              ),
                              pw.Text(
                                "TOTAL (\$): " +
                                    listMintar[0].deudaTotalCabezera!,
                                style: pw.TextStyle(
                                  fontSize: 30,
                                  fontWeight: pw.FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ];
        },
      ),
    );
    return pdf.save();
  }

  Future<void> savePdfFile(String fileName, List<int> byteList) async {
    final output = await getExternalStorageDirectory();
    var filePath = "${output!.path}/$fileName";
    final file = File(filePath);
    await file.writeAsBytes(byteList);
    var result = await OpenFilex.open(
      filePath,
      type: "application/pdf",
      uti: "com.adobe.pdf",
    );
  }

  Future<String> savePdfFileIOS(String fileName, List<int> byteList) async {
    final output = await getTemporaryDirectory();
    var filePath = "${output.path}/$fileName";
    final file = File(filePath);
    await file.writeAsBytes(byteList);
    return filePath;
  }

  _readName() async {
    CodeActivacion empresa = await widget.oS.readDataPreferenciasEmpresa();
    print('Aca name empresa >>>>> ${empresa.data!.name!}');
    return widget.empresa = empresa.data!.name!;
  }

  _getDataReporteMinTarVuelta() async {
    ApiRepoMinTarjVuelta servicio = ApiRepoMinTarjVuelta();
    datoMinTarVuelta = await servicio.readMinTarVuelta(
      widget._fechaI,
      widget._fechaF,
      widget._unidad,
    );
    setState(() {});
  }

  Widget minTarVueltaPdf() {
    if (datoMinTarVuelta != null) {
      if (datoMinTarVuelta!.statusCode == null) {
        return cardShimmer();
      } else if (datoMinTarVuelta!.statusCode == 200) {
        return getElement(context, datoMinTarVuelta!);
      } else if (datoMinTarVuelta!.statusCode == 300) {
        return _cardNoData();
      }
    }
    return Container();
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
