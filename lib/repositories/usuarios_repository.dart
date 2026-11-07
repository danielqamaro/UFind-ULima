import 'package:ufind/models/usuario_perfil.dart';

/// Sustituir esta interfaz por una implementación remota cuando exista API.
abstract class UsuariosRepository {
  Future<List<UsuarioPerfil>> listar();
  Future<void> guardarTodos(List<UsuarioPerfil> usuarios);
}
