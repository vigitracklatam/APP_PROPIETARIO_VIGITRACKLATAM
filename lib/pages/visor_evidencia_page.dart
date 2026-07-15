import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class VisorEvidenciaPage extends StatelessWidget {
  final String unidadLiquidacionM;
  final String fechaLiquidacionM;
  final String? evidencia1;
  final String? evidencia2;
  final String? evidencia3;

  const VisorEvidenciaPage({
    super.key,
    required this.unidadLiquidacionM,
    required this.fechaLiquidacionM,
    this.evidencia1,
    this.evidencia2,
    this.evidencia3,
  });

  bool isUrlValida(String? url) {
    if (url == null || url.trim().isEmpty) return false;
    try {
      final uri = Uri.parse(url);
      return (uri.scheme == 'http' || uri.scheme == 'https') &&
          uri.host.isNotEmpty;
    } catch (e) {
      return false;
    }
  }

  void _verImagenCompleta(BuildContext context, String imageUrl) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder:
            (context) => FullScreenImageViewer(
              imageUrl: imageUrl,
              // Usamos la propia URL como 'tag' única para la animación Hero
              heroTag: imageUrl,
            ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final List<String?> urls = [evidencia1, evidencia2, evidencia3];
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Evidencias'),
        elevation: 1,
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: Colors.black,
          statusBarIconBrightness: Brightness.light,
          statusBarBrightness: Brightness.dark,
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Unidad : $unidadLiquidacionM',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'Fecha : $fechaLiquidacionM',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 12),

              Text(
                'Estas son las evidencias registradas.',
                style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
              ),
              const SizedBox(height: 24),

              Expanded(
                child: GridView.count(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  children: List.generate(urls.length, (index) {
                    final url = urls[index];
                    return _buildImageDisplayBox(
                      context,
                      url,
                      'Evidencia ${index + 1}',
                    );
                  }),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImageDisplayBox(
    BuildContext context,
    String? url,
    String label,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(12.0),
        border: Border.all(color: Colors.grey.shade300, width: 1.5),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(11.0),
        child:
            isUrlValida(url)
                ? _buildImagePreview(
                  context,
                  url!,
                ) // Pasamos 'context' y la URL
                : _buildPlaceholder(label),
      ),
    );
  }

  Widget _buildImagePreview(BuildContext context, String networkUrl) {
    return GestureDetector(
      onTap: () {
        _verImagenCompleta(context, networkUrl);
        //_verImagenEnDialogo(context, networkUrl);
      },

      child: Hero(
        tag: networkUrl,
        child: Image.network(
          networkUrl,
          fit: BoxFit.cover,
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) return child;
            return const Center(
              child: CircularProgressIndicator(color: Colors.blue),
            );
          },
          errorBuilder:
              (context, error, stackTrace) =>
                  const Icon(Icons.broken_image, size: 40, color: Colors.grey),
        ),
      ),
    );
  }

  Widget _buildPlaceholder(String label) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.image_not_supported_outlined,
            color: Colors.grey.shade500,
            size: 40,
          ),
          const SizedBox(height: 8),
          Text(
            'No hay $label',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.grey.shade600,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class FullScreenImageViewer extends StatelessWidget {
  final String imageUrl;
  final String heroTag;

  const FullScreenImageViewer({
    super.key,
    required this.imageUrl,
    required this.heroTag,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text('Evidencias'),
        elevation: 0,
        foregroundColor: Colors.white,
        iconTheme: const IconThemeData(
          color: Colors.white,
        ), // Flecha de retroceso blanca
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: Colors.black,
          statusBarIconBrightness: Brightness.light,
          statusBarBrightness: Brightness.dark,
        ),
      ),
      body: GestureDetector(
        onTap: () {
          Navigator.pop(context);
        },
        child: Center(
          child: Hero(
            tag: heroTag,
            child: InteractiveViewer(
              panEnabled: true,
              minScale: 0.5,
              maxScale: 4,
              child: Image.network(
                imageUrl,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return const Center(
                    child: CircularProgressIndicator(color: Colors.white),
                  );
                },
                errorBuilder:
                    (context, error, stackTrace) => const Icon(
                      Icons.broken_image,
                      size: 60,
                      color: Colors.white,
                    ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
