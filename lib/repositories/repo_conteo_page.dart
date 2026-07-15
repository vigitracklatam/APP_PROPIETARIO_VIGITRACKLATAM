import '../models/conteo/conteo_page.dart';
import '../provider/provi_conteo_page.dart';

class ApiRepositorioConteoPage {
  final _provider = ProviContePage();
  Future<ConteoPageAppMovil> fetchConteoPage(unidad, ruta, fechaI, fechaF) {
    return _provider.readConteoPage(unidad, ruta, fechaI, fechaF);
  }
}

class NetworkError extends Error {}
