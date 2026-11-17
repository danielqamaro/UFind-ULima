import 'package:shared_preferences/shared_preferences.dart';

import 'package:ufind/repositories/local_publicaciones_repository.dart';
import 'package:ufind/repositories/local_solicitudes_repository.dart';
import 'package:ufind/repositories/local_usuarios_repository.dart';
import 'package:ufind/viewmodels/publicaciones_viewmodel.dart';
import 'package:ufind/viewmodels/solicitudes_viewmodel.dart';
import 'package:ufind/viewmodels/usuarios_viewmodel.dart';
import 'package:ufind/viewmodels/session_controller.dart';
import 'package:ufind/viewmodels/theme_controller.dart';

class AppDependencies {
  AppDependencies._({
    required this.publicaciones,
    required this.solicitudes,
    required this.usuarios,
    required this.tema,
    required this.sesion,
  });

  final PublicacionesViewModel publicaciones;
  final SolicitudesViewModel solicitudes;
  final UsuariosViewModel usuarios;
  final ThemeController tema;
  final SessionController sesion;

  static Future<AppDependencies> cargar() async {
    final preferencias = await SharedPreferences.getInstance();
    final publicaciones = PublicacionesViewModel(
      repository: LocalPublicacionesRepository(preferencias),
    );
    final solicitudes = SolicitudesViewModel(
      repository: LocalSolicitudesRepository(preferencias),
    );
    final usuarios = UsuariosViewModel(
      repository: LocalUsuariosRepository(preferencias),
    );

    await Future.wait([
      publicaciones.cargar(),
      solicitudes.cargar(),
      usuarios.cargar(),
    ]);

    return AppDependencies._(
      publicaciones: publicaciones,
      solicitudes: solicitudes,
      usuarios: usuarios,
      tema: ThemeController(preferencias),
      sesion: SessionController(),
    );
  }

  void dispose() {
    publicaciones.dispose();
    solicitudes.dispose();
    usuarios.dispose();
    tema.dispose();
    sesion.dispose();
  }
}
