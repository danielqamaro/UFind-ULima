import 'package:shared_preferences/shared_preferences.dart';

import 'package:ufind/models/solicitud_recuperacion.dart';
import 'package:ufind/services/preferencias_service.dart';
import 'solicitudes_repository.dart';

class LocalSolicitudesRepository implements SolicitudesRepository {
  LocalSolicitudesRepository(SharedPreferences preferencias)
    : _servicio = PreferenciasService(preferencias);
  // Se conserva la clave anterior para mantener las solicitudes existentes.
  static const clave = 'ufind_solicitudes_v1';
  final PreferenciasService _servicio;
  @override
  Future<List<SolicitudRecuperacion>> listar() async {
    final datos = await _servicio.leerLista(clave);
    return datos?.map(SolicitudRecuperacion.fromJson).toList() ?? [];
  }

  @override
  Future<void> guardarTodos(List<SolicitudRecuperacion> solicitudes) =>
      _servicio.guardarLista(
        clave,
        solicitudes.map((s) => s.toJson()).toList(),
      );
}
