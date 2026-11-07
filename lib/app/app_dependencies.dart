import 'package:shared_preferences/shared_preferences.dart';
import 'package:ufind/viewmodels/theme_controller.dart';

class AppDependencies {
  AppDependencies._({
    required this.tema,
  });

  final ThemeController tema;

  static Future<AppDependencies> cargar() async {
    final preferencias = await SharedPreferences.getInstance();

    return AppDependencies._(
      tema: ThemeController(preferencias),
    );
  }

  void dispose() {
    tema.dispose();
  }
}
