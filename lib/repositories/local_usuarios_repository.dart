import 'package:shared_preferences/shared_preferences.dart';

import 'package:ufind/models/usuario_perfil.dart';
import 'package:ufind/services/preferencias_service.dart';
import 'usuarios_repository.dart';

/// Perfiles de demostración; no guarda contraseñas ni tokens.
class LocalUsuariosRepository implements UsuariosRepository {
  LocalUsuariosRepository(SharedPreferences preferencias)
    : _servicio = PreferenciasService(preferencias);
  static const clave = 'ufind_usuarios_demo_v1';
  final PreferenciasService _servicio;
  @override
  Future<List<UsuarioPerfil>> listar() async {
    final datos = await _servicio.leerLista(clave);
    return datos?.map(UsuarioPerfil.fromJson).toList() ?? [];
  }

  @override
  Future<void> guardarTodos(List<UsuarioPerfil> usuarios) =>
      _servicio.guardarLista(clave, usuarios.map((p) => p.toJson()).toList());
}
