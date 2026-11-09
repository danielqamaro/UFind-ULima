import 'package:shared_preferences/shared_preferences.dart';
import 'package:ufind/viewmodels/theme_controller.dart';
import 'package:ufind/repositories/local_usuarios_repository.dart';
import 'package:ufind/viewmodels/usuarios_viewmodel.dart';
import 'package:ufind/viewmodels/session_controller.dart';
import 'package:ufind/repositories/local_publicaciones_repository.dart';
import 'package:ufind/viewmodels/publicaciones_viewmodel.dart';

class AppDependencies {
  AppDependencies._({
    required this.tema,
    required this.usuarios,
    required this.sesion,
    required this.publicaciones,
  });

  final ThemeController tema;
  final UsuariosViewModel usuarios;
  final SessionController sesion;
  final PublicacionesViewModel publicaciones;

  static Future<AppDependencies> cargar() async {
    final preferencias = await SharedPreferences.getInstance();
    final usuarios = UsuariosViewModel(repository: LocalUsuariosRepository(preferencias));
    await usuarios.cargar();
    final publicaciones = PublicacionesViewModel(repository: LocalPublicacionesRepository(preferencias));
    await publicaciones.cargar();
    return AppDependencies._(
      tema: ThemeController(preferencias),
      usuarios: usuarios,
      sesion: SessionController(),
      publicaciones: publicaciones,
    );
  }

  void dispose() {
    tema.dispose();
    usuarios.dispose();
    sesion.dispose();
    publicaciones.dispose();
  }
}
