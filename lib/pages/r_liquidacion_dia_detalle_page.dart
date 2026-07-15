import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/liquidacionDia/detalle_liquidacion_dia.dart'
    as detalle;
import '../models/liquidacionDia/evidencia_liquidacion_dia.dart'
    as evidencia;
import 'package:cached_network_image/cached_network_image.dart';
import '../repositories/repo_liquidacion_dia.dart';
import '../utils/colors.dart';
import '../utils/dimens.dart';
import '../utils/iconos.dart';

class DetalleLiquidacionDiaPage extends StatefulWidget {
  final int id;
  final String titulo;

  const DetalleLiquidacionDiaPage({
    Key? key,
    required this.id,
    required this.titulo,
  }) : super(key: key);

  @override
  State<DetalleLiquidacionDiaPage> createState() =>
      _DetalleLiquidacionDiaPageState();
}

class _DetalleLiquidacionDiaPageState extends State<DetalleLiquidacionDiaPage> {
  final ApiRepositorioLiquidacionDespacho _repo =
      ApiRepositorioLiquidacionDespacho();

  bool _cargando = true;
  detalle.Dato? _dato;
  evidencia.Dato? _evidenciasData;
  String? _error;

  @override
  void initState() {
    super.initState();
    _cargar();
  }

  Future<void> _cargar() async {
    final result = await _repo.fetchDetalleLiquidacionDia(widget.id);
    final resultEvidencias = await _repo.fetchEvidenciaLiquidacionDia(
      widget.id,
    );

    setState(() {
      _cargando = false;
      if (result.statusCode == 200 && result.datos!.isNotEmpty) {
        _dato = result.datos!.first;
      } else {
        _error = result.msm ?? "Sin datos";
      }

      if (resultEvidencias.statusCode == 200 &&
          resultEvidencias.datos!.isNotEmpty) {
        _evidenciasData = resultEvidencias.datos!.first;
      }
    });
  }

  // BUILD
  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark, // íconos blancos (Android)
        statusBarBrightness: Brightness.light, // íconos blancos (iOS)
      ),
      child: Scaffold(
        body: SafeArea(
          child: Column(
            children: [
              _buildHeader(),
              Expanded(
                child:
                    _cargando
                        ? const Center(child: CircularProgressIndicator())
                        : _error != null
                        ? Center(child: Text(_error!))
                        : ListView(
                          padding: const EdgeInsets.fromLTRB(14, 14, 14, 14),
                          children: [
                            _buildConductorField(),
                            const SizedBox(height: 12),
                            _buildRutaRow(),
                            const SizedBox(height: 12),
                            _buildIngresosRow(),
                            const SizedBox(height: 12),
                            _buildGastosSection(),
                            if (_evidencias.isNotEmpty) ...[
                              const SizedBox(height: 14),
                              _buildEvidenciasSection(),
                            ],
                            const SizedBox(height: 14),
                          ],
                        ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Header
  Widget _buildHeader() {
    final d = _dato;
    return Container(
      padding: const EdgeInsets.fromLTRB(14, 9, 14, 9),
      decoration: BoxDecoration(
        color: Colors.blue,
        border: Border(bottom: BorderSide(color: colorBorder)),
      ),
      child: Row(
        children: [
          IconButton(
            padding: EdgeInsets.zero,
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
          const SizedBox(width: 4),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (d?.fecha != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 2),
                    child: Row(
                      children: [
                        Icon(IconCalendario, size: 13, color: Colors.white),
                        const SizedBox(width: 4),
                        Text(
                          d!.fecha!.toString().split(' ')[0] ?? '-',
                          style: TextStyle(
                            fontSize: textMedium,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Conductor (solo lectura)
  Widget _buildConductorField() {
    return _section(
      label: 'Conductor',
      child: _readField(icon: IconPerfil, value: _dato?.nombre ?? '-'),
    );
  }

  // Ruta (solo lectura)
  Widget _buildRutaRow() {
    return _section(
      label: 'Ruta',
      child: _readField(icon: Icontrazado, value: _dato?.descRuta ?? '-'),
    );
  }

  // Ingresos + Ahorro Corporativo
  Widget _buildIngresosRow() {
    return _section(
      label: 'Ingresos y Ahorro',
      child: Row(
        children: [
          Expanded(
            child: _readField(
              icon: IconDolar,
              label: 'Ingresos',
              value: _formatMonto(_dato?.ingresos),
              valueColor: colorSuccess,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: _readField(
              icon: IconAhorro,
              label: 'Ahorro Corp.',
              value: _formatMonto(_dato?.ahorroCorporativo),
            ),
          ),
        ],
      ),
    );
  }

  // Gastos (solo lectura)
  Widget _buildGastosSection() {
    return _section(
      label: 'Gastos',
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: _readField(
                  icon: IconPerfil,
                  label: 'Chofer',
                  value: _formatMonto(_dato?.gastoChofer),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _readField(
                  icon: IconPerfilMas,
                  label: 'Ayudante',
                  value: _formatMonto(_dato?.gastoAyudante),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: _readField(
                  icon: IconCombustible,
                  label: 'Combustible',
                  value: _formatMonto(_dato?.gastoCombustible),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _readField(
                  icon: IconComida,
                  label: 'Alimentación',
                  value: _formatMonto(_dato?.gastoAlimentacion),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: _readField(
                  icon: IconReloj,
                  label: 'Minutos',
                  value: _formatMonto(_dato?.gastoMinutos),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _readField(
                  icon: IconDolar,
                  label: 'Otros',
                  value: _formatMonto(_dato?.gastoOtros),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          _readField(
            icon: IconCuadroFinS,
            label: 'Observación',
            value:
                (_dato?.observacion == null || _dato!.observacion!.isEmpty)
                    ? 'Sin observaciones'
                    : _dato!.observacion!,
            maxLines: 4,
          ),
        ],
      ),
    );
  }

  // Evidencias
  List<String> get _evidencias =>
      [
        _evidenciasData?.urlEvidencia1,
        _evidenciasData?.urlEvidencia2,
        _evidenciasData?.urlEvidencia3,
        _evidenciasData?.urlEvidencia4,
      ].whereType<String>().where((u) => u.isNotEmpty).toList();

  Widget _buildEvidenciasSection() {
    return _section(
      label: 'Evidencias',
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: _evidencias.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 8,
          mainAxisSpacing: 8,
          childAspectRatio: 1.3,
        ),
        itemBuilder:
            (_, i) => ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: GestureDetector(
                onTap: () => _verImagen(_evidencias[i]),
                child: CachedNetworkImage(
                  imageUrl: _evidencias[i],
                  fit: BoxFit.cover,
                  placeholder:
                      (_, __) => Container(
                        color: bgField,
                        child: const Center(
                          child: SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          ),
                        ),
                      ),
                  errorWidget:
                      (_, __, ___) => Container(
                        color: bgField,
                        child: Icon(Icons.broken_image, color: colorLabel),
                      ),
                ),
              ),
            ),
      ),
    );
  }

  void _verImagen(String url) {
    showDialog(
      context: context,
      builder:
          (_) => Dialog(
            backgroundColor: Colors.transparent,
            insetPadding: const EdgeInsets.all(12),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: CachedNetworkImage(
                imageUrl: url,
                fit: BoxFit.contain,
                placeholder:
                    (_, __) => const Padding(
                      padding: EdgeInsets.all(24),
                      child: CircularProgressIndicator(),
                    ),
                errorWidget:
                    (_, __, ___) => const Icon(
                      Icons.broken_image,
                      size: 48,
                      color: Colors.white,
                    ),
              ),
            ),
          ),
    );
  }

  // Widgets helper
  Widget _section({required String label, required Widget child}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: textMediumSmall,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 9),
        child,
      ],
    );
  }

  // Campo de solo lectura, mismo estilo visual que _textField pero sin edición
  Widget _readField({
    required IconData icon,
    required String value,
    String label = "",
    Color? valueColor,
    int maxLines = 1,
  }) {
    if (maxLines > 1) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
        decoration: BoxDecoration(
          color: bgField,
          border: Border.all(color: colorBorder),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, size: 17, color: colorLabel),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                value,
                style: const TextStyle(
                  fontSize: textMedium,
                  color: Colors.black87,
                ),
              ),
            ),
          ],
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
      decoration: BoxDecoration(
        color: bgField,
        border: Border.all(color: colorBorder),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(icon, size: 17, color: colorLabel),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                if (label.isNotEmpty)
                  Text(
                    label,
                    style: TextStyle(
                      fontSize: textMedium - 1,
                      color: colorLabel,
                    ),
                  ),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: textMedium,
                    fontWeight: FontWeight.w600,
                    color: valueColor ?? Colors.black87,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatMonto(String? valor) {
    final v = double.tryParse(valor ?? '0') ?? 0;
    return v == 0 ? '-' : '${v.toStringAsFixed(2)}';
  }

  Color _colorTotal(String? total) {
    final v = double.tryParse(total ?? '0') ?? 0;
    if (v > 0) return Colors.green;
    if (v < 0) return colorDanger;
    return Colors.black87;
  }
}
