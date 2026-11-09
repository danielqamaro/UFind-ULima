import 'package:shared_preferences/shared_preferences.dart';

import 'package:ufind/models/objeto_publicacion.dart';
import 'package:ufind/services/preferencias_service.dart';
import 'publicaciones_repository.dart';

class LocalPublicacionesRepository implements PublicacionesRepository {
  LocalPublicacionesRepository(SharedPreferences preferencias)
    : _servicio = PreferenciasService(preferencias);
  static const clave = 'ufind_publicaciones_v1';
  final PreferenciasService _servicio;
  @override
  Future<List<ObjetoPublicacion>?> cargar() async {
    final datos = await _servicio.leerLista(clave);
    return datos?.map(ObjetoPublicacion.fromJson).toList();
  }

  @override
  Future<void> guardar(List<ObjetoPublicacion> publicaciones) => _servicio
      .guardarLista(clave, publicaciones.map((p) => p.toJson()).toList());
}
