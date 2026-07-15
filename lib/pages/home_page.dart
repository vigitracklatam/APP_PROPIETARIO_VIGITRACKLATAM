import 'dart:convert';

import 'package:flutter/material.dart';
import '../models/code_activacion/code_activacion.dart';
import '../models/login/permisos_propietario_model.dart';
import '../repositories/security_data.dart';
import '../utils/colors.dart';
import '../utils/dimens.dart';
import '../utils/iconos.dart';
import '../widget/app_version.dart';
import '../widget/headerlogin.dart';
import 'conteo_page.dart';
import 'despacho_page.dart';
import 'liquidacion_page.dart';
import 'liquidacion_page2.dart';
import 'logo_page.dart';
import 'notification_page.dart';
import 'produccion_basic.dart';
import 'rastreo_page.dart';
import 'salidas_page.dart';
import 'login_page.dart';
import 'monitoreo_page.dart';
import 'report_screen.dart';
import 'simulador_page.dart';

class HomePage extends StatefulWidget {
  int isMonitoreo = 0;
  int isConteo = 0;
  int isSalida = 0;
  int isRecorido = 0;
  int isSimulador = 0;
  //int isProduccion = 0;
  int isLiquidacion = 0;
  //int isLiquidacion2 = 0;
  int isMinutosTarjeta = 0;
  int activeReporte = 0;
  int isMinutosTarjetasResumido = 0;
  int isMinutosTarjetaV = 0;
  int isMinutosTarjetasResumidoV = 0;
  int isCuadroLunesViernes = 0;
  int isCuadroFinSemana = 0;
  int isCuadroFeriados = 0;
  bool showIcon = false;
  bool _menuCargado = false;

  int reporte_pagos_pendientes_producc = 0;

  HomePage({super.key});
  bool isActivated = false;
  bool isActivated0 = false;
  SecurityData oS = new SecurityData();

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  BuildContext? _mBuilderGeneral;
  String nombreEmpresa = "";
  String codigoEmpresa = "";
  String pathImagen = "";
  int _selectDrawerItem = 0;
  int statePage = 0;
  bool _cargado = false;
  bool _mostrarLogo = false;

  @override
  void initState() {
    super.initState();
    _readMarca();
    _initMenu();
    _leerPermisos();
  }

  @override
  Widget build(BuildContext context) {
    _mBuilderGeneral = context;

    // Mientras aún no se carga
    if (!_cargado) {
      return Scaffold(
        appBar: AppBar(
          elevation: 1,
          foregroundColor: Colors.white,
          backgroundColor: Colors.blue,
          automaticallyImplyLeading: false,
        ),
        body: const Center(
          child: CircularProgressIndicator(color: Colors.blue),
        ),
      );
    }

    // App principal normal con navegación y Drawer funcionando
    return PopScope(
      canPop: false,
      child: Scaffold(
        appBar: AppBar(
          elevation: 1,
          foregroundColor: Colors.white,
          backgroundColor: Colors.blue,
          actions: [
            if (widget.showIcon)
              IconButton(
                icon: Icon(Icons.notifications),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => NotificationPage()),
                  );
                },
              ),
            const Center(
              // Para centrarlo verticalmente en la barra
              child: Padding(
                padding: EdgeInsets.only(right: 16.0), // Espaciado a la derecha
                child: AppVersionText(color: Colors.white),
              ),
            ),
          ],
        ),
        drawer: _getDrawerMenu(),
        body: _getSelectedPage(), // ✅ Aquí va LogoPage si statePage == 10
      ),
    );
  }

  Widget _getSelectedPage() {
    switch (statePage) {
      case 0:
        return MonitoreoPage();
      case 1:
        return SalidasPage();
      case 2:
        return DespachoPage();
      case 3:
        return ConteoPage();
      case 4:
        return RastreoPage();
      case 5:
        return SimuladorPage();
      case 6:
        return ProduccionBasica();
      case 7:
        return LiquidacionPage();
      case 8:
        return LiquidacionPage2();
      case 9:
        return ReportScreen();
      case 10:
        return LogoPage();
      default:
        return LogoPage();
    }
  }

  _getDrawerMenu() {
    return Drawer(
      child: Column(
        children: [
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                getHeaderDrawer(),
                Visibility(
                  visible: widget.isMonitoreo == 1,
                  child: ListTile(
                    selected: (_selectDrawerItem == 0),
                    leading: Icon(
                      IconGlobal,
                      color: (statePage == 0) ? Colors.blue : Colors.black54,
                    ),
                    title: Text(
                      "Monitoreo",
                      style: TextStyle(
                        fontSize: textBigMedium,
                        color: (statePage == 0) ? Colors.blue : Colors.black54,
                      ),
                    ),
                    onTap: () {
                      setState(() {
                        _selectDrawerItem = 0;
                        statePage = 0;
                        Navigator.of(context).pop();
                      });
                    },
                  ),
                ),
                Visibility(
                  visible: widget.isSalida == 1,
                  child: ListTile(
                    selected: (_selectDrawerItem == 1),
                    leading: Icon(
                      IconNote,
                      color: (statePage == 1) ? Colors.blue : Colors.black54,
                    ),
                    title: Text(
                      "Salida",
                      style: TextStyle(
                        fontSize: textBigMedium,
                        color: (statePage == 1) ? Colors.blue : Colors.black54,
                      ),
                    ),
                    onTap: () {
                      setState(() {
                        _selectDrawerItem = 1;
                        statePage = 1;
                        Navigator.of(context).pop();
                      });
                    },
                  ),
                ),
                Visibility(
                  visible: codigoEmpresa == "ttisaleo",
                  child: ListTile(
                    selected: (_selectDrawerItem == 2),
                    leading: Icon(
                      IconDespacho,
                      color: (statePage == 2) ? Colors.blue : Colors.black54,
                    ),
                    onTap: () {
                      setState(() {
                        _selectDrawerItem = 2;
                        statePage = 2;
                        Navigator.of(context).pop();
                      });
                    },
                    title: Text(
                      "Despacho",
                      style: TextStyle(
                        fontSize: textBigMedium,
                        color: (statePage == 2) ? Colors.blue : Colors.black54,
                      ),
                    ),
                  ),
                ),
                Visibility(
                  visible: widget.isConteo == 1,
                  child: ListTile(
                    selected: (_selectDrawerItem == 3),
                    leading: Icon(
                      IconConteo,
                      color: (statePage == 3) ? Colors.blue : Colors.black54,
                    ),
                    onTap: () {
                      setState(() {
                        _selectDrawerItem = 3;
                        statePage = 3;
                        Navigator.of(context).pop();
                      });
                    },
                    title: Text(
                      "Conteo",
                      style: TextStyle(
                        fontSize: textBigMedium,
                        color: (statePage == 3) ? Colors.blue : Colors.black54,
                      ),
                    ),
                  ),
                ),
                Visibility(
                  visible: widget.isRecorido == 1,
                  child: ListTile(
                    selected: (_selectDrawerItem == 4),
                    leading: Icon(
                      Icontrazado,
                      color: (statePage == 4) ? Colors.blue : Colors.black54,
                    ),
                    onTap: () {
                      setState(() {
                        _selectDrawerItem = 4;
                        statePage = 4;
                        Navigator.of(context).pop();
                      });
                    },
                    title: Text(
                      "Recorrido",
                      style: TextStyle(
                        fontSize: textBigMedium,
                        color: (statePage == 4) ? Colors.blue : Colors.black54,
                      ),
                    ),
                  ),
                ),
                Visibility(
                  visible: widget.isSimulador == 1,
                  child: ListTile(
                    selected: (_selectDrawerItem == 5),
                    leading: Icon(
                      IconPlay,
                      color: (statePage == 5) ? Colors.blue : Colors.black54,
                    ),
                    onTap: () {
                      setState(() {
                        _selectDrawerItem = 5;
                        statePage = 5;
                        Navigator.of(context).pop();
                      });
                    },
                    title: Text(
                      "Simulador",
                      style: TextStyle(
                        fontSize: textBigMedium,
                        color: (statePage == 5) ? Colors.blue : Colors.black54,
                      ),
                    ),
                  ),
                ),
                /*Visibility(
                  visible: widget.isProduccion == 1,
                  child: ListTile(
                    selected: (_selectDrawerItem == 6),
                    leading: Icon(
                      IconConteo,
                      color: (statePage == 6) ? Colors.blue : Colors.black54,
                    ),
                    onTap: () {
                      setState(() {
                        _selectDrawerItem = 6;
                        statePage = 6;
                        Navigator.of(context).pop();
                      });
                    },
                    title: Text(
                      "Liquidación CH D",
                      style: TextStyle(
                        fontSize: textBigMedium,
                        color: (statePage == 6) ? Colors.blue : Colors.black54,
                      ),
                    ),
                  ),
                ),*/
                Visibility(
                  visible: widget.isLiquidacion == 1,
                  child: ListTile(
                    selected: (_selectDrawerItem == 7),
                    leading: Icon(
                      IconLiquidacion,
                      color: (statePage == 7) ? Colors.blue : Colors.black54,
                    ),
                    onTap: () {
                      setState(() {
                        _selectDrawerItem = 7;
                        statePage = 7;
                        Navigator.of(context).pop();
                      });
                    },
                    title: Text(
                      "Liquidacion CH V",
                      style: TextStyle(
                        fontSize: textBigMedium,
                        color: (statePage == 7) ? Colors.blue : Colors.black54,
                      ),
                    ),
                  ),
                ),
                /*Visibility(
                  visible: widget.isLiquidacion2 == 1,
                  child: ListTile(
                    selected: (_selectDrawerItem == 8),
                    leading: Icon(
                      IconLiquidacion,
                      color: (statePage == 8) ? Colors.blue : Colors.black54,
                    ),
                    onTap: () {
                      setState(() {
                        _selectDrawerItem = 8;
                        statePage = 8;
                        Navigator.of(context).pop();
                      });
                    },
                    title: Text(
                      "Liquidacion CH V 2",
                      style: TextStyle(
                        fontSize: textBigMedium,
                        color: (statePage == 8) ? Colors.blue : Colors.black54,
                      ),
                    ),
                  ),
                ),*/

                Visibility(
                  visible: widget.activeReporte == 1,
                  child: ListTile(
                    selected: (_selectDrawerItem == 9),
                    leading: Icon(
                      IconReporte,
                      color: (statePage == 9) ? Colors.blue : Colors.black54,
                    ),
                    onTap: () {
                      setState(() {
                        _selectDrawerItem = 9;
                        statePage = 9;
                        Navigator.of(context).pop();
                      });
                    },
                    title: Text(
                      "Reporte",
                      style: TextStyle(
                        fontSize: textBigMedium,
                        color: (statePage == 9) ? Colors.blue : Colors.black54,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          AppVersionText(),
          const SizedBox(height: 10), // Espacio entre el ListView y el botón
          buttonSalirDrawer(context),
        ],
      ),
    );
  }

  _initMenu() async {
    var conteo = 0;
    var salida = 0;
    var monitoreo = 0;
    var recorido = 0;
    var simulador = 0;
    var mintar = null;
    var mintarV = null;
    var mintar_resumido = null;
    var mintar_resumidoV = null;
    var PathPhoto = null;
    var active_reporte = null;
    var isCuadroLunes = 0;
    var isCuadroFinSemana = 0;
    var isCuadroFeriado = 0;
    //var produccion = 0;
    var liquidacion = 0;
    var liquidacion2 = 0;
    var reporte_pagos_pendientes_producc = 0;

    try {
      CodeActivacion empresa = await widget.oS.readDataPreferenciasEmpresa();
      var datosE = await widget.oS.readDataPreferenciasEmpresa();
      cPermisosPropietario? oPermisosPropietario =
          await widget.oS.readPermisosObservador();
      conteo = oPermisosPropietario?.activeConteo ?? 0;
      monitoreo = oPermisosPropietario?.activeMonitoreo ?? 0;
      salida = oPermisosPropietario?.activeSalidas ?? 0;
      recorido = oPermisosPropietario?.activeRecorrido ?? 0;
      simulador = oPermisosPropietario?.activeSimulador ?? 0;
      liquidacion =
          oPermisosPropietario?.activeLiquidacionChV ??
          0;
          
      /*liquidacion2 =
          oPermisosPropietario?.active_liquidacion_ch_v_2 ??
          0;*/
      /*produccion =
          oPermisosPropietario?.active_liquidacion_ch_d ??
          0;*/

      active_reporte = oPermisosPropietario?.active_reporte ?? 0;

      PathPhoto = await datosE.data!.logo;
      print(PathPhoto);

      /*  mintar = datosE.data!.movil!.minutosTar;
      mintarV = datosE.data!.movil!.minutosTarVuelta;
      mintar_resumido = datosE.data!.movil!.minutosTarResumido!['active'];
      mintar_resumidoV =
          datosE.data!.movil!.minutosTarResumidoVuelta!['active'];
      isCuadroLunes = datosE.data!.movil!.cuadroTrabajoLunesViernes!.activo!;
      isCuadroFinSemana = datosE.data!.movil!.cuadroTrabajoFinSemana!.activo!;
      isCuadroFeriado = datosE.data!.movil!.cuadroTrabajoFeriado!.activo!;
      reporte_pagos_pendientes_producc =
          datosE.data!.movil!.reportePagosPendienteProduccion!; */
    } catch (e) {
      monitoreo = 0;
      salida = 0;
      conteo = 0;
      recorido = 0;
      simulador = 0;
      mintar = 0;
      mintar_resumido = 0;
      mintarV = 0;
      mintar_resumidoV = 0;
      //produccion = 0;
    }
    setState(() {
      widget.isMonitoreo = monitoreo == null ? 0 : monitoreo;
      widget.isConteo = conteo == null ? 0 : conteo;
      widget.isSalida = salida == null ? 0 : salida;
      widget.isRecorido = recorido == null ? 0 : recorido;
      widget.isSimulador = simulador == null ? 0 : simulador;
      //widget.isProduccion = produccion ?? 0;
      widget.isLiquidacion = liquidacion ?? 0;
      //widget.isLiquidacion2 = liquidacion2 ?? 0;
      //pathImagen = PathPhoto;
      print("object");
      print(pathImagen);

      widget.activeReporte = active_reporte == null ? 0 : active_reporte;
      /* widget.isMinutosTarjeta = mintar == null ? 0 : mintar;
      widget.isMinutosTarjetasResumido =
          mintar_resumido == null ? 0 : mintar_resumido;
      widget.isMinutosTarjetaV = mintarV == null ? 0 : mintarV;
      widget.isMinutosTarjetasResumidoV =
          mintar_resumidoV == null ? 0 : mintar_resumidoV;

      widget.isCuadroLunesViernes = isCuadroLunes ?? 0;
      widget.isCuadroFinSemana = isCuadroFinSemana ?? 0;
      widget.isCuadroFeriados = isCuadroFeriado ?? 0;

      widget.reporte_pagos_pendientes_producc =
          reporte_pagos_pendientes_producc ?? 0; */
      widget._menuCargado = true;
    });
  }

  void _leerPermisos() async {
    final oPermisos = await widget.oS.readPermisosObservador();

    setState(() {
      if (oPermisos!.activeMonitoreo == 0) {
        _mostrarLogo = true;
        statePage = 10; // Mostrar LogoPage si no hay permisos
        _selectDrawerItem = 10; // Seleccionar LogoPage en el Drawer
      }
      _cargado = true; // ✅ Marcamos que terminó de cargar
    });
  }

  circleLogoDrawer(BuildContext context) {
    return Container(
      alignment: Alignment.topRight,
      height: 90,
      width: 90,
      decoration: BoxDecoration(
        color: Colors.grey,
        shape: BoxShape.circle,
        image: DecorationImage(
          repeat: ImageRepeat.noRepeat,
          fit: BoxFit.cover,
          image: NetworkImage(pathImagen),
        ),
      ),
    );
  }

  _readMarca() async {
    CodeActivacion empresa = await widget.oS.readDataPreferenciasEmpresa();
    setState(() {
      nombreEmpresa = empresa.data!.name!;
      pathImagen = empresa.data!.logo!;
      codigoEmpresa = empresa.data!.codigo!;
    });
  }

  textLogoDrawer(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 5),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            nombreEmpresa ?? 'No data',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: textBigMedium,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  buttonSalirDrawer(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(
        right: marginSmallSmall,
        left: marginSmallSmall,
        bottom: marginSmallSmall,
      ),
      child: ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
          backgroundColor: colorRed,
          padding: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          minimumSize: const Size(double.infinity, 50),
        ),
        onPressed: () {
          _showAlerSignOut(context);
        },
        icon: const Icon(IconSalir, color: Colors.white),
        label: const Text(
          "Cerrar sesión",
          style: TextStyle(fontSize: textBigMedium, color: Colors.white),
        ),
      ),
    );
  }

  getHeaderDrawer() {
    return Container(
      height: 160,
      color: Colors.transparent,
      child: Stack(
        children: [
          Center(child: getHeaderHomePage(context)),
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [circleLogoDrawer(context), textLogoDrawer(context)],
            ),
          ),
        ],
      ),
    );
  }

  _showAlerSignOut(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: const Text("Cerrar Sesión"),
          content: const Text("¿Desea finalizar su sesión de usuario?"),
          actionsAlignment: MainAxisAlignment.center, // Centra las acciones
          actions: [
            ElevatedButton(
              onPressed: () async {
                await _deleteSharedPrferences();
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => LoginPage()),
                  (route) => false,
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue, // Fondo azul
                foregroundColor: Colors.white, // Letras blancas
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10), // Radio de borde
                ),
              ),
              child: const Text("Continuar"),
            ),
          ],
        );
      },
    );
  }

  _deleteSharedPrferences() async {
    SecurityData oS = new SecurityData();
    try {
      await oS.deleteDataPreferenciasLoginPropietario();
      Navigator.pop(this._mBuilderGeneral!);
      Navigator.pop(this._mBuilderGeneral!);
    } catch (e) {
      print(e);
    }
  }
}
