// ignore_for_file: prefer_if_null_operators

import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:simple_fontellico_progress_dialog/simple_fontico_loading.dart';
import '../models/cDeviceInfoModel.dart';
import '../models/code_activacion/code_activacion.dart';
import '../models/login/login_propietario.dart';
import '../repositories/repo_login_propietario.dart';
import '../repositories/security_data.dart';
import '../utils/colors.dart';
import '../utils/dimens.dart';
import '../utils/iconos.dart';
import '../utils/infodevicenetwork.dart';
import '../utils/textos.dart';
import '../widget/app_version.dart';
import '../widget/headerlogin.dart';

class LoginPage extends StatefulWidget {
  cDeviceInfoModel? oDeviceInfoModel;
  final emailUsuario = TextEditingController();
  final passwordUsuario = TextEditingController();
  String nameCompania = '';
  var _formKey = GlobalKey<FormState>();
  SecurityData oS = new SecurityData();

  SimpleFontelicoProgressDialog? _dialog;

  bool isShowPassword = true;

  LoginPage({super.key});
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  void initState() {
    super.initState();
    _obtenerIdDevice();
    _readMarca();
    _initConfigData();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.blue,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () async {
            await _deleteSharedPrferencesCodeAct();
            Navigator.pushReplacementNamed(context, 'codeActivacion');
          },
        ),
        title: Text(
          widget.nameCompania,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.w700,
            fontStyle: FontStyle.normal,
            color: Colors.white,
          ),
        ),
      ),
      backgroundColor: colorGrey,
      bottomNavigationBar: Container(
        child: Padding(
          padding: EdgeInsetsGeometry.all(15),
          child: Text(
            "ID : ${widget.oDeviceInfoModel?.getImei ?? "Desconocido"}",
            maxLines: 2,
          ),
        ),
      ),
      body: SafeArea(
        child: Stack(
          children: [
            getHeaderHomePage(context),
            Positioned(
              top: 10,
              right: 10,
              child: AppVersionText(color: Colors.black),
            ),
            _getFormLogin(context),
          ],
        ),
      ),
    );
  }

  Widget _getFormLogin(context) {
    return Container(
      padding: EdgeInsets.all(marginSmallSmall),
      margin: EdgeInsets.only(
        right: marginSmallSmall,
        top: MediaQuery.of(context).size.height * 0.30,
        left: marginSmallSmall,
      ),
      decoration: BoxDecoration(
        color: colorWhite,
        boxShadow: [boxShadowPersonalizado],
        borderRadius: BorderRadius.circular(borderRadiusSmall),
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            RichText(
              text: TextSpan(
                // Note: Styles for TextSpans must be explicitly defined.
                // Child text spans will inherit styles from parent
                style: TextStyle(fontSize: textBig, color: colorBlack),
                children: <TextSpan>[
                  TextSpan(
                    text: 'Iniciar ',
                    style: TextStyle(
                      fontSize: textBig,
                      color: colorBlack,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  TextSpan(
                    text: 'Sesión',
                    style: TextStyle(fontSize: textBig, color: colorBlack),
                  ),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 16),
              child: Form(
                //autovalidateMode: AutovalidateMode.onUserInteraction,
                key: widget._formKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: widget.emailUsuario,
                      //textAlign: TextAlign.start,
                      keyboardType: TextInputType.text,
                      maxLines: 1,
                      validator: (value) {
                        if (value != null && value.isEmpty) {
                          return 'Ingrese el usuario';
                        }
                      },
                      decoration: const InputDecoration(
                        labelStyle: TextStyle(fontSize: textBigMedium),
                        labelText: 'Usuario',
                        border: OutlineInputBorder(),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.blue),
                        ),
                        prefixIcon: Icon(IconUser),
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      obscureText: widget.isShowPassword,
                      controller: widget.passwordUsuario,
                      keyboardType: TextInputType.text,
                      maxLines: 1,
                      validator: (value) {
                        if (value != null && value.isEmpty) {
                          return 'Ingrese la contraseña';
                        }
                      },
                      decoration: InputDecoration(
                        labelText: 'Contraseña',
                        labelStyle: const TextStyle(fontSize: textBigMedium),
                        border: const OutlineInputBorder(),
                        focusedBorder: const OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.blue),
                        ),
                        prefixIcon: const Icon(IconCandado),
                        suffixIcon: GestureDetector(
                          child: Icon(
                            !widget.isShowPassword ? IconOjo : IconOjoCerrado,
                          ),
                          onTap: () {
                            widget.isShowPassword = !widget.isShowPassword;
                            setState(() {});
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                final isValidForm = widget._formKey.currentState!.validate();
                final usuario = widget.emailUsuario.text.replaceAll(' ', '');
                final password = widget.passwordUsuario.text.replaceAll(
                  ' ',
                  '',
                );
                if (isValidForm) {
                  _readLoginPropietario(usuario, password);
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue, // Color de fondo azul
                foregroundColor: Colors.white, // Color del texto blanco
                minimumSize: Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5.0),
                ),
              ),
              child: const Text(
                "Ingresar",
                style: TextStyle(fontSize: textBigMedium),
              ),
            ),
          ],
        ),
      ),
    );
  }

  _readLoginPropietario(email, password) async {
    try {
      print('Aca usuario ${email}');
      print('Aca contraseña ${password}');
      _showAlertProgress();
      cDeviceInfoModel oDeviceInfoModel =
          await InfoDeviceNetWork().getImeiInfoDevice();
      String? ipaccess = await InfoDeviceNetWork.getIpAddress();
      String packageName = await InfoDeviceNetWork().getPackageName();
      String plataforma =
          Platform.isAndroid
              ? "andorid"
              : Platform.isIOS
              ? "ios"
              : "otro";

      LoginPropietario oC = await RepoLoginPropietario.readLoginPropietario(
        email,
        password,
        oDeviceInfoModel.getImei ?? "Desconocido",
        oDeviceInfoModel.getModelo ?? "Desconocido",
        ipaccess ?? "NO_IP",
        packageName,
        plataforma,
      );
      print('Aca statusCode ${oC.statusCode}');

      widget._dialog!.hide();
      if (oC.statusCode == 200) {
        Navigator.pop(context);
        Navigator.of(context).pushNamed("homePage");
      } else {
        Alert(
          context: context,
          type: AlertType.error,
          style: AlertStyle(
            descStyle: TextStyle(fontSize: 15),
            titleStyle: TextStyle(fontSize: 16),
          ),
          title: "${namecompany}",
          desc: oC.sms == null ? "NO SMS" : "${oC.sms}",
          buttons: [
            DialogButton(
              child: Text(
                "Aceptar",
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
              onPressed: () => Navigator.pop(context),
              width: 120,
            ),
          ],
        ).show();
      }
    } catch (e) {
      Alert(
        context: context,
        type: AlertType.warning,
        title: namecompany,
        desc: "${e.toString()}",
        buttons: [
          DialogButton(
            child: Text(
              "Aceptar",
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
            onPressed: () => Navigator.pop(context),
            width: 120,
          ),
        ],
      ).show();
    }
  }

  _initConfigData() async {
    String email_ = await widget.oS.readDataPreferenciasLoginPropietario(
      'dataLoginPropietarioLoginUsuario',
    );
    String pass_ = await widget.oS.readDataPreferenciasLoginPropietario(
      'dataLoginPropietarioLoginPassword',
    );
    if (email_.isNotEmpty && pass_.isNotEmpty) {
      widget.emailUsuario.text = email_;
      widget.passwordUsuario.text = pass_;
      _readLoginPropietario(email_, pass_);
    }
  }

  _showAlertProgress() async {
    widget._dialog = SimpleFontelicoProgressDialog(
      context: context,
      barrierDimisable: true,
    );
    widget._dialog!.show(
      message: 'Cargando Datos...',
      type: SimpleFontelicoProgressDialogType.spinner,
    );
  }

  _readMarca() async {
    CodeActivacion nameEmpresa = await widget.oS.readDataPreferenciasEmpresa();
    setState(() {
      widget.nameCompania = nameEmpresa.data!.name!;
    });
    print('Data del name >>>>> ${jsonEncode(nameEmpresa.data!.name)}');
  }

  _deleteSharedPrferencesCodeAct() async {
    SecurityData oS = new SecurityData();
    try {
      await oS.deleteDataPreferenciasCodeActivacion();
    } catch (e) {
      print(e);
    }
  }

  _obtenerIdDevice() async {
    try {
      widget.oDeviceInfoModel = await InfoDeviceNetWork().getImeiInfoDevice();
      setState(() {});
    } catch (e) {
      print(e);
    }
  }
}
