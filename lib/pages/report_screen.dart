import 'package:flutter/material.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';
import '../models/code_activacion/code_activacion.dart';
import '../models/login/permisos_propietario_model.dart';
import '../repositories/security_data.dart';
import '../utils/dimens.dart';
import '../utils/iconos.dart';
import '../utils/url.dart';
import 'min_tar_vuel_resumen.dart';
import 'min_tarj_resumen.dart';
import 'min_tarj_vuelta.dart';
import 'minutos_tarjetas.dart';
import 'r_liqVueltaSB.dart';
import 'r_liquidacion_dia_page.dart';
import 'r_liquidacion_page.dart';
import 'valores_penndiente_pagado.dart';
import 'viewerPdf.dart';

class ReportScreen extends StatefulWidget {
  int isMinutosTarjeta = 0;
  int isMinutosTarjetasResumido = 0;
  int isMinutosTarjetaV = 0;
  int isMinutosTarjetasResumidoV = 0;
  int isCuadroLunesViernes = 0;
  int isCuadroFinSemana = 0;
  int isCuadroFeriados = 0;
  int active_reporte_liquidacion_ch_v = 0;
  int active_reporte_liquidacion_ch_v_2 = 0;
  int active_reporte_liquidacion_v_sb = 0;
  int active_reporte_liquidacion_dia = 0;

  int reporte_pagos_pendientes_producc = 0;
  SecurityData oS = new SecurityData();
  String codigo = "";

  @override
  State<ReportScreen> createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {

  @override
  void initState() {
    super.initState();
    _initMenu();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            Expanded(
              child: ListView(
                children: [
                  Column(
                    children: [
                      Visibility(
                        visible: widget.isMinutosTarjeta == 1,
                        child: ListTile(
                          leading: Icon(
                            IconMinutos,
                            color:Colors.black54,
                          ),
                          title: Text(
                            "Minutos y tarjetas",
                            style: TextStyle(
                              fontSize: textBigMedium,
                              color:Colors.black54,
                            ),
                          ),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => MinutosTarjetas(),
                              ),
                            );
                          },
                        ),
                      ),
                      Visibility(
                        visible: widget.isMinutosTarjeta == 1,
                        child: const Divider(thickness: 1),
                      ),
                      Visibility(
                        visible:
                            widget.isMinutosTarjetasResumido == 1
                                ? true
                                : false,
                        child: ListTile(
                          leading: Icon(
                            IconMinutos,
                            color:Colors.black54,
                          ),
                          title: Text(
                            "Minutos y Tarjetas Resumidas",
                            style: TextStyle(
                              fontSize: textBigMedium,
                              color:Colors.black54,
                            ),
                          ),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => MinuTarjeResumen(),
                              ),
                            );
                          },
                        ),
                      ),
                      Visibility(
                        visible: widget.isMinutosTarjetasResumido == 1,
                        child: Divider(thickness: 1),
                      ),
                      Visibility(
                        visible: widget.isCuadroLunesViernes == 1,
                        child: ListTile(
                          leading: Icon(
                            IconCuadroLunVie,
                            color:Colors.black54,
                          ),
                          title: Text(
                            "Cuadro Lunes a Viernes",
                            style: TextStyle(
                              fontSize: textBigMedium,
                              color:Colors.black54,
                            ),
                          ),
                          onTap: () {
                            _showOpenCuadroTrabajo(1);
                          },
                        ),
                      ),
                      Visibility(
                        visible: widget.isCuadroLunesViernes == 1,
                        child: Divider(thickness: 1),
                      ),
                      Visibility(
                        visible: widget.isCuadroFinSemana == 1,
                        child: ListTile(
                          leading: Icon(
                            IconCuadroFinS,
                            color:Colors.black54,
                          ),
                          title: Text(
                            "Cuadro Fines de Semana",
                            style: TextStyle(
                              fontSize: textBigMedium,
                              color:Colors.black54,
                            ),
                          ),
                          onTap: () {
                            _showOpenCuadroTrabajo(2);
                          },
                        ),
                      ),
                      Visibility(
                        visible: widget.isCuadroFinSemana == 1,
                        child: Divider(thickness: 1),
                      ),
                      Visibility(
                        visible: widget.isCuadroFeriados == 1,
                        child: ListTile(
                          leading: Icon(
                            IconCuadroFer,
                            color:Colors.black54,
                          ),
                          title: Text(
                            "Cuadro Feriado",
                            style: TextStyle(
                              fontSize: textBigMedium,
                              color:Colors.black54,
                            ),
                          ),
                          onTap: () {
                            _showOpenCuadroTrabajo(3);
                          },
                        ),
                      ),
                      Visibility(
                        visible: widget.isCuadroFeriados == 1,
                        child: Divider(thickness: 1),
                      ),
                      Visibility(
                        visible: widget.isMinutosTarjetaV == 1,
                        child: ListTile(
                          leading: Icon(
                            IconTicket,
                            color:Colors.black54,
                          ),
                          title: Text(
                            "Minutos Tarjeta Vuelta",
                            style: TextStyle(
                              fontSize: textBigMedium,
                              color:Colors.black54,
                            ),
                          ),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => MinTarjetasVuelta(),
                              ),
                            );
                          },
                        ),
                      ),
                      Visibility(
                        visible: widget.isMinutosTarjetaV == 1,
                        child: Divider(thickness: 1),
                      ),
                      Visibility(
                        visible: widget.isMinutosTarjetasResumidoV == 1,
                        child: ListTile(
                          leading: Icon(
                            IconTicketStart,
                            color:Colors.black54,
                          ),
                          title: Text(
                            "Minutos Tarjeta Vuelta Resumen",
                            style: TextStyle(
                              fontSize: textBigMedium,
                              color:Colors.black54,
                            ),
                          ),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => MinTarjetasVuelResumen(),
                              ),
                            );
                          },
                        ),
                      ),
                      Visibility(
                        visible: widget.isMinutosTarjetasResumidoV == 1,
                        child: Divider(thickness: 1),
                      ),
                      Visibility(
                        visible: widget.reporte_pagos_pendientes_producc == 1,
                        child: ListTile(
                          leading: Icon(
                            IconValoresPagPen,
                            color:Colors.black54,
                          ),
                          title: Text(
                            "Valores Pagados / Valores Pendiente",
                            style: TextStyle(
                              fontSize: textBigMedium,
                              color: Colors.black54,
                            ),
                          ),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ValoresPenPagados(),
                              ),
                            );
                          },
                        ),
                      ),
                      Visibility(
                        visible: widget.active_reporte_liquidacion_ch_v == 1,
                        child: Divider(thickness: 1),
                      ),
                      Visibility(
                        visible: widget.active_reporte_liquidacion_ch_v == 1,
                        child: ListTile(
                          leading: Icon(
                            IconRLiquidacion,
                            color: Colors.black54,
                          ),
                          title: Text(
                            "R. Liquidación CH V",
                            style: TextStyle(
                              fontSize: textBigMedium,
                              color:Colors.black54,
                            ),
                          ),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ReporteLiquidacionPage(),
                              ),
                            );
                          },
                        ),
                      ),

                      /*Visibility(
                        visible: widget.active_reporte_liquidacion_ch_v_2 == 1,
                        child: Divider(thickness: 1),
                      ),
                      Visibility(
                        visible: widget.active_reporte_liquidacion_ch_v_2 == 1,
                        child: ListTile(
                          leading: Icon(
                            IconRLiquidacion,
                            color: Colors.black54,
                          ),
                          title: Text(
                            "R. Liquidación CH V 2",
                            style: TextStyle(
                              fontSize: textBigMedium,
                              color:Colors.black54,
                            ),
                          ),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ReporteLiquidacionPage2(),
                              ),
                            );
                          },
                        ),
                      ),*/
                      Visibility(
                        visible: widget.reporte_pagos_pendientes_producc == 1,
                        child: Divider(thickness: 1),
                      ),

                      Visibility(
                        visible: widget.active_reporte_liquidacion_v_sb == 1,
                        child: ListTile(
                          leading: Icon(
                            IconRLiquidacion,
                            color:Colors.black54,
                          ),
                          title: Text(
                            "R. Liquidación Vuelta (SB)",
                            style: TextStyle(
                              fontSize: textBigMedium,
                              color: Colors.black54,
                            ),
                          ),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ReportLiqVueltaSB(),
                              ),
                            );
                          },
                        ),
                      ),
                      Visibility(
                        visible: widget.active_reporte_liquidacion_v_sb == 1,
                        child: Divider(thickness: 1),
                      ),

                      Visibility(
                        visible: widget.active_reporte_liquidacion_dia == 1,
                        child: ListTile(
                          leading: Icon(
                            IconRLiquidacionDia,
                            color:Colors.black54,
                          ),
                          title: Text(
                            "R. Liquidación Diaria",
                            style: TextStyle(
                              fontSize: textBigMedium,
                              color:Colors.black54,
                            ),
                          ),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder:
                                    (context) => ReporteLiquidacionDiaPage(),
                              ),
                            );
                          },
                        ),
                      ),
                      Visibility(
                        visible: widget.active_reporte_liquidacion_dia == 1,
                        child: Divider(thickness: 1),
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

  _showOpenCuadroTrabajo(int i) async {
    CodeActivacion oC = await widget.oS.readDataPreferenciasEmpresa();
    cPermisosPropietario? oP = await widget.oS.readPermisosObservador();
    widget.codigo = oC.data!.codigo.toString();
    String? url_cuadro = null;
    switch (i) {
      case 1:
        url_cuadro = oP?.urlCuadroLv;
        //(oC.data!.movil!.cuadroTrabajoLunesViernes!.pdf.toString());
        break;
      case 2:
        url_cuadro =
            oP?.urlCuadroFs; //(oC.data!.movil!.cuadroTrabajoFinSemana!.pdf.toString());
        break;
      case 3:
        url_cuadro =
            oP?.urlCuadroFeri; //(oC.data!.movil!.cuadroTrabajoFeriado!.pdf.toString());
        break;
    }

    if (url_cuadro == null || !isUrlValida(url_cuadro)) {
      showTopSnackBar(
        Overlay.of(context),
        CustomSnackBar.error(
          maxLines: 3,
          message:
              "Parece que la URL ingresada no es válida. Por favor, verifica e inténtalo nuevamente.",
        ),
      );
    } else {
      final route = MaterialPageRoute(
        builder: (context) {
          return ViewerPDF(url_cuadro!);
        },
      );
      Navigator.push(context, route);
    }
  }

  _initMenu() async {
    var mintar = null;
    var mintarV = null;
    var mintar_resumido = null;
    var mintar_resumidoV = null;

    var reporte_liquidacion_ch_v = null;
    var reporte_liquidacion_v_sb = null;

    var isCuadroLunes = 0;
    var isCuadroFinSemana = 0;
    var isCuadroFeriado = 0;

    var reporte_pagos_pendientes_producc = 0;
    var reporte_liquidacion_ch_v2 = 0;

    var active_reporte_liquidacion_dia = 0;

    try {
      var datosE = await widget.oS.readDataPreferenciasEmpresa();
      cPermisosPropietario? oPermisosPropietario =
          await widget.oS.readPermisosObservador();

      mintar = oPermisosPropietario!.activeMinTarjetaDia;
      mintarV = oPermisosPropietario!.activeMinTarjetaVuelta;
      mintar_resumido = oPermisosPropietario!.activeMinTarjetaDiaResu;
      mintar_resumidoV = oPermisosPropietario!.activeMinTarjetaVueltaResu;
      isCuadroLunes = oPermisosPropietario!.activeCuadroLv!;
      isCuadroFinSemana = oPermisosPropietario!.activeCuadroFs!;
      isCuadroFeriado = oPermisosPropietario!.activeCuadroFeri!;

      reporte_pagos_pendientes_producc =
          oPermisosPropietario!.activePagoMinTarRuDia!;

      // PRIMERA VERSION DE LIQUIDACION_DONDE EL CONDUCTOR ES PROPIETARIO    

      reporte_liquidacion_ch_v =
          oPermisosPropietario == null
              ? 0
              : oPermisosPropietario.activeReporteLiquidacionChV == null
              ? 0
              : oPermisosPropietario.activeReporteLiquidacionChV!;

      /*reporte_liquidacion_ch_v2 =
          oPermisosPropietario.active_reporte_liquidacion_ch_v_2 == null
              ? 0
              : oPermisosPropietario.active_reporte_liquidacion_ch_v_2!;*/

      // SEGUNDA VERSION DE LIQUIDACION                

      reporte_liquidacion_v_sb =
          oPermisosPropietario.activeReporteLiquidacionVueltaSB == null
              ? 0
              : oPermisosPropietario.activeReporteLiquidacionVueltaSB!;

              active_reporte_liquidacion_dia = oPermisosPropietario.activeReporteLiquidacionVueltaSB == null
              ? 0
              : oPermisosPropietario.active_reporte_liquidacion_dia!;

    } catch (e) {
      print("____________________________________________");
      print(e.toString());
      mintar = 0;
      mintar_resumido = 0;
      mintarV = 0;
      mintar_resumidoV = 0;
      reporte_liquidacion_ch_v = 0;
      reporte_liquidacion_ch_v2 = 0;
    }
    setState(() {
      widget.isMinutosTarjeta = mintar == null ? 0 : mintar;
      widget.isMinutosTarjetasResumido =
          mintar_resumido == null ? 0 : mintar_resumido;
      widget.isMinutosTarjetaV = mintarV == null ? 0 : mintarV;
      widget.isMinutosTarjetasResumidoV =
          mintar_resumidoV == null ? 0 : mintar_resumidoV;

      widget.isCuadroLunesViernes = isCuadroLunes == null ? 0 : isCuadroLunes;
      widget.isCuadroFinSemana =
          isCuadroFinSemana == null ? 0 : isCuadroFinSemana;
      widget.isCuadroFeriados = isCuadroFeriado == null ? 0 : isCuadroFeriado;

      widget.reporte_pagos_pendientes_producc =
          reporte_pagos_pendientes_producc == null
              ? 0
              : reporte_pagos_pendientes_producc;

      widget.active_reporte_liquidacion_ch_v = reporte_liquidacion_ch_v;
      widget.active_reporte_liquidacion_ch_v_2 = reporte_liquidacion_ch_v2;
      widget.active_reporte_liquidacion_v_sb = reporte_liquidacion_v_sb;
      widget.active_reporte_liquidacion_dia = active_reporte_liquidacion_dia;
    });
  }
}
