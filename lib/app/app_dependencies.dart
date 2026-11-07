import 'package:shared_preferences/shared_preferences.dart';
import 'package:ufind/viewmodels/theme_controller.dart';
import 'package:ufind/repositories/local_usuarios_repository.dart';
import 'package:ufind/viewmodels/usuarios_viewmodel.dart';
import 'package:ufind/viewmodels/session_controller.dart';

class AppDependencies {
  AppDependencies._({
    required this.tema,
    required this.usuarios,
    required this.sesion,
  });

  final ThemeController tema;
  final UsuariosViewModel usuarios;
  final SessionController sesion;

  static Future<AppDependencies> cargar() async {
    final preferencias = await SharedPreferences.getInstance();
    final usuarios = UsuariosViewModel(repository: LocalUsuariosRepository(preferencias));
    await usuarios.cargar();
    return AppDependencies._(
      tema: ThemeController(preferencias),
      usuarios: usuarios,
      sesion: SessionController(),
    );
  }

  void dispose() {
    tema.dispose();
    usuarios.dispose();
    sesion.dispose();
  }
}
