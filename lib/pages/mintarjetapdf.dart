import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:shimmer/shimmer.dart';
import 'package:pdf/widgets.dart' as pw;

import '../models/code_activacion/code_activacion.dart';
import '../models/minutos_tarjetas/data_minutostarjetas.dart';
import '../models/minutos_tarjetas/minutostarjetas.dart';
import '../repositories/repo_minutos_tarjetas.dart';
import '../repositories/security_data.dart';
import '../utils/colors.dart';
import '../utils/dimens.dart';


class MinTarjetasPDF extends StatefulWidget {
  String empresa = "";
  SecurityData oS = new SecurityData();
  final String _fechaI;
  final String _fechaF;
  final String _unidad;
  List<DatoMinTarjeta>? mList;
  MinTarjetasPDF(String _fechaI, String _fechaF, String _unidad)
    : this._fechaI = _fechaI,
      this._fechaF = _fechaF,
      this._unidad = _unidad;

  @override
  State<MinTarjetasPDF> createState() => _MinTarjetasPDFState();
}

class _MinTarjetasPDFState extends State<MinTarjetasPDF> {
  MinutosTarjetasAppMovil? datoMinutosTarjetas = null;

  @override
  void initState() {
    _readName();
    setState(() {
      datoMinutosTarjetas = new MinutosTarjetasAppMovil(statusCode: null);
    });
    _getDataReportMinutosTarjetas();
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
          title: Text('Reporte Minutos y Tarjetas'),
          backgroundColor: Colors.blue,
          foregroundColor: Colors.white,
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.red,
          foregroundColor: Colors.white,
          heroTag: 'pdf',
          tooltip: 'PDF',
          onPressed: () async {
            if (datoMinutosTarjetas!.statusCode == 200) {
              List<int> data = await createReporteMinTarjetas(widget.mList!);
              savePdfFile(
                "Reporte_Minutos_Tarjetas_Diarias_Resumido.pdf",
                data,
              );

              /*if (Platform.isAndroid) {
                List<int> data = await createReporteMinTarjetas(widget.mList!);
                savePdfFile(
                  "Reporte_Minutos_Tarjetas_Diarias_Resumido.pdf",
                  data,
                );
              } else {
                List<int> data = await createReporteMinTarjetas(widget.mList!);
                String path = await savePdfFileIOS(
                  "Reporte_Minutos_Tarjetas_Diarias_Resumido.pdf",
                  data,
                );
                Navigator.push(
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
              child: minTarPdf(),
            ),
          ],
        ),
      ),
    );
  }

  getElement<Widget>(BuildContext context, MinutosTarjetasAppMovil model) {
    widget.mList = model.datos;
    createReporteMinTarjetas(widget.mList!);
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
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
          Container(
            child: Row(
              children: [
                const Text(
                  "Fecha: ",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(widget.mList![0].salidas![0].fechas!.substring(0, 11)),
                Text(
                  "           Frecuencia: ",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Expanded(child: Text(widget.mList![0].salidas![0].frecuencia!)),
              ],
            ),
          ),
          Container(
            child: Row(
              children: [
                const Text(
                  "Línea: ",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(widget.mList![0].salidas![0].linea!),
                Text(
                  "               Vehículo: ",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(widget.mList![0].unidad!),
              ],
            ),
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Column(
              children: [
                for (var i = 0; i < widget.mList![0].salidas!.length; i++) ...[
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Text(
                        "UNIDAD N° " + widget.mList![0].unidad!,
                        style: TextStyle(fontSize: 16),
                      ),
                      Text("     "),
                      Text(
                        widget.mList![0].salidas![i].fechas! + "   ",
                        style: TextStyle(fontSize: 16),
                      ),
                      Text("   "),
                      Text(widget.mList![0].salidas![i].linea!),
                      Text("    "),
                      Text(
                        "Salida # " +
                            widget.mList![0].salidas![i].salida!.toString(),
                      ),
                      Text("           "),
                    ],
                  ),
                  Table(
                    border: TableBorder.all(color: Colors.black),
                    columnWidths: {
                      0: FixedColumnWidth(190.0),
                      1: FixedColumnWidth(130.0),
                      2: IntrinsicColumnWidth(),
                      3: IntrinsicColumnWidth(),
                      4: IntrinsicColumnWidth(),
                      5: IntrinsicColumnWidth(),
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
                                    0: FixedColumnWidth(65.0),
                                    1: FixedColumnWidth(65.0),
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
                                    0: FixedColumnWidth(70.0),
                                    1: FixedColumnWidth(70.0),
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
                                            padding: EdgeInsets.only(left: 15),
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
                                            padding: EdgeInsets.only(right: 15),
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
                                    0: FixedColumnWidth(70.0),
                                    1: FixedColumnWidth(70.0),
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
                                            padding: EdgeInsets.only(left: 15),
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
                                            padding: EdgeInsets.only(right: 15),
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
                                  0: FixedColumnWidth(65.0),
                                  1: FixedColumnWidth(65.0),
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
                                            item.horaProgSaliD == null
                                                ? ''
                                                : item.horaProgSaliD!,
                                            textAlign: TextAlign.center,
                                            style: TextStyle(fontSize: 12),
                                          ),
                                        ),
                                      ),
                                      TableCell(
                                        child: Container(
                                          child: Text(
                                            item.horaMarcSaliD == null
                                                ? ''
                                                : item.horaMarcSaliD!,
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
                                  0: FixedColumnWidth(70.0),
                                  1: FixedColumnWidth(70.0),
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
                                  0: FixedColumnWidth(70.0),
                                  1: FixedColumnWidth(70.0),
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
                                item.rubroPenalidad!,
                                textAlign: TextAlign.center,
                                style: TextStyle(fontSize: 12),
                              ),
                            ),
                            Container(
                              child: Text(
                                item.velocidadPenalidad!,
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
                const SizedBox(height: 10),
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
                                    widget.mList![0].adelantoFTiempoCabezera! +
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
                                    widget.mList![0].adelantoJTiempoCabezera! +
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
                                    widget.mList![0].atrasoPenalidadCabezera! +
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
                          foregroundColor: Colors.white,
                          backgroundColor: Colors.blue,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: const Text("Ok"),
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
    List<DatoMinTarjeta> listMintar,
  ) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        orientation: pw.PageOrientation.portrait,
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        build: (pw.Context context) {
          List<pw.Widget> content = [];

          // Add header content
          content.add(
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
                  "Reporte de Minutos y Tarjetas",
                  style: pw.TextStyle(
                    fontSize: 14,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
                pw.Container(
                  child: pw.Row(
                    children: [
                      pw.Text(
                        "Fecha: ",
                        style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                      ),
                      pw.Text(
                        listMintar[0].salidas![0].fechas!.substring(0, 11),
                      ),
                      pw.Text(
                        "           Fecuencia: ",
                        style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                      ),
                      pw.Expanded(
                        child: pw.Text(listMintar[0].salidas![0].frecuencia!),
                      ),
                    ],
                  ),
                ),
                pw.Container(
                  child: pw.Row(
                    children: [
                      pw.Text(
                        "Línea: ",
                        style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                      ),
                      pw.Text(listMintar[0].salidas![0].linea!),
                      pw.Text(
                        "                 Vehículo: ",
                        style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                      ),
                      pw.Text(listMintar[0].unidad!),
                    ],
                  ),
                ),
              ],
            ),
          );

          // Add content for each salida
          for (var i = 0; i < listMintar[0].salidas!.length; i++) {
            content.add(pw.SizedBox(height: 10));
            content.add(
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
                    "Salida # " + listMintar[0].salidas![i].salida!.toString(),
                    style: pw.TextStyle(fontSize: 12),
                  ),
                ],
              ),
            );

            // Add table content
            content.add(
              pw.Table(
                border: pw.TableBorder.all(),
                columnWidths: {
                  0: pw.FixedColumnWidth(150.0),
                  1: pw.FixedColumnWidth(100.0),
                  2: pw.IntrinsicColumnWidth(),
                  3: pw.IntrinsicColumnWidth(),
                  4: pw.FixedColumnWidth(40.0),
                  5: pw.FixedColumnWidth(40.0),
                },
                children: [
                  pw.TableRow(
                    children: [
                      pw.Column(
                        mainAxisSize: pw.MainAxisSize.min,
                        crossAxisAlignment: pw.CrossAxisAlignment.center,
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
                        crossAxisAlignment: pw.CrossAxisAlignment.center,
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
                                          fontWeight: pw.FontWeight.bold,
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
                                          fontWeight: pw.FontWeight.bold,
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
                      // Add other columns in the same manner
                    ],
                  ),
                  for (var item in listMintar[0].salidas![i].minutos!)
                    pw.TableRow(
                      children: [
                        pw.Column(
                          crossAxisAlignment: pw.CrossAxisAlignment.center,
                          mainAxisAlignment: pw.MainAxisAlignment.center,
                          children: [
                            pw.Text(
                              item.descripcionControl!,
                              style: pw.TextStyle(fontSize: 10),
                            ),
                          ],
                        ),
                        pw.Column(
                          crossAxisAlignment: pw.CrossAxisAlignment.center,
                          mainAxisAlignment: pw.MainAxisAlignment.center,
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
                                          item.horaProgSaliD ?? '',
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
                                          item.horaMarcSaliD!,
                                          style: pw.TextStyle(fontSize: 10),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                        // Add other columns in the same manner
                      ],
                    ),
                ],
              ),
            );
          }

          // Add footer content
          content.add(pw.SizedBox(height: 10));
          content.add(
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
                                listMintar[0].adelantoPenalidadCabezera! +
                                "                             ",
                            style: pw.TextStyle(fontSize: 11),
                          ),
                          pw.Text(
                            "TOTAL (\$): " + listMintar[0].deudaTotalCabezera!,
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
          );

          return content;
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

  _getDataReportMinutosTarjetas() async {
    ApiRepoMinutosTarjetas servicio = ApiRepoMinutosTarjetas();
    datoMinutosTarjetas = await servicio.readMinutosTarjetas(
      widget._fechaI,
      widget._fechaF,
      widget._unidad,
    );
    setState(() {});
  }

  Widget minTarPdf() {
    if (datoMinutosTarjetas != null) {
      if (datoMinutosTarjetas!.statusCode == null) {
        return cardShimmer();
      } else if (datoMinutosTarjetas!.statusCode == 200) {
        return getElement(context, datoMinutosTarjetas!);
      } else if (datoMinutosTarjetas!.statusCode == 300) {
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
