import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeController extends ChangeNotifier {
  static const _clave = 'ufind_modo_tema';
  final SharedPreferences preferencias;
  late ThemeMode _modo;

  ThemeController(this.preferencias) {
    final nombre = preferencias.getString(_clave);
    _modo = ThemeMode.values.firstWhere(
      (value) => value.name == nombre,
      orElse: () => ThemeMode.dark,
    );
  }

  ThemeMode get modo => _modo;

  Future<void> cambiar(ThemeMode nuevo) async {
    if (nuevo == _modo) return;
    _modo = nuevo;
    notifyListeners();
    await preferencias.setString(_clave, nuevo.name);
  }
}
