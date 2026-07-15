import '../models/velocidad_maxima/velocidad_max.dart';
import '../provider/provi_velocidad_max.dart';

class ApiVelMax {
  final _provider = ProviVelocidadMax();
  Future<VelMaxAppMovil> readVelMax() async {
    return await _provider.readVelMax();
  }
}

class NetworkError extends Error {}
