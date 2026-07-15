import 'package:flutter/material.dart';
import '../utils/appInfo.dart';

class AppVersionText extends StatelessWidget {
  final Color color;

  const AppVersionText({super.key, this.color = Colors.black});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
      future: AppInfo.getAppVersion(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Text('Cargando versión...', style: TextStyle(color: color));
        } else if (snapshot.hasError) {
          return Text(
            'Error al obtener versión',
            style: TextStyle(color: Colors.red),
          );
        } else if (snapshot.hasData) {
          return Text(
            'Versión ${snapshot.data}',
            style: TextStyle(
              fontSize: 13,
              color: color,
              fontWeight: FontWeight.bold,
            ),
          );
        } else {
          return Text('Versión no disponible', style: TextStyle(color: color));
        }
      },
    );
  }
}
