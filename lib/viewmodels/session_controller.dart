import 'package:flutter/foundation.dart';

import 'package:ufind/models/usuario_perfil.dart';

/// Sesión local de demostración. No equivale a autenticación o autorización.
class SessionController extends ChangeNotifier {
  String? _correo;
  UsuarioPerfil? _perfil;

  String? get correo => _correo;
  UsuarioPerfil? get perfil => _perfil;
  String get nombre =>
      _perfil?.nombre ??
      (_correo == null
          ? 'Estudiante'
          : _correo!.split('@').first.replaceAll(RegExp(r'[._-]+'), ' '));
  String get foto => _perfil?.foto ?? '';

  void ingresarDemo(String correo, {UsuarioPerfil? perfil}) {
    _correo = correo.trim().toLowerCase();
    _perfil = perfil;
    notifyListeners();
  }

  void actualizarPerfil(UsuarioPerfil perfil) {
    _perfil = perfil;
    _correo = perfil.correo;
    notifyListeners();
  }

  void salir() {
    _correo = null;
    _perfil = null;
    notifyListeners();
  }
}
