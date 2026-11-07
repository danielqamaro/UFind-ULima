import 'package:flutter/foundation.dart';

import 'package:ufind/services/validadores.dart';
import 'package:ufind/repositories/usuarios_repository.dart';
import 'package:ufind/models/usuario_perfil.dart';

/// Maneja cuentas y perfiles de prueba. No comprueba contraseñas ni roles.
class UsuariosViewModel extends ChangeNotifier {
  final UsuariosRepository repository;
  final List<UsuarioPerfil> _usuarios = [];
  UsuariosViewModel({required this.repository});

  Future<void> cargar() async {
    _usuarios
      ..clear()
      ..addAll(await repository.listar());
    notifyListeners();
  }

  UsuarioPerfil? buscarPorCorreo(String correo) {
    final normalizado = correo.trim().toLowerCase();
    for (final perfil in _usuarios) {
      if (perfil.correo == normalizado) return perfil;
    }
    return null;
  }

  Future<UsuarioPerfil> registrar({
    required String nombre,
    required String correo,
    String carrera = '',
    String telefono = '',
    String foto = '',
  }) async {
    final normalizado = correo.trim().toLowerCase();
    if (!Validadores.esCorreoInstitucional(normalizado)) {
      throw ArgumentError('Usa tu correo institucional @aloe.ulima.edu.pe.');
    }
    if (nombre.trim().length < 3) {
      throw ArgumentError('Escribe un nombre válido.');
    }
    if (buscarPorCorreo(normalizado) != null) {
      throw StateError('Ya existe un perfil local con ese correo.');
    }
    final perfil = UsuarioPerfil(
      id: 'demo_${DateTime.now().microsecondsSinceEpoch}',
      nombre: nombre.trim(),
      correo: normalizado,
      carrera: carrera.trim(),
      telefono: telefono.trim(),
      foto: foto,
      fechaRegistro: DateTime.now(),
    );
    final nuevaLista = [..._usuarios, perfil];
    await repository.guardarTodos(nuevaLista);
    _usuarios
      ..clear()
      ..addAll(nuevaLista);
    notifyListeners();
    return perfil;
  }

  /// También permite crear el perfil de un estudiante que entró con acceso demo.
  Future<UsuarioPerfil> actualizar({
    required String correoAnterior,
    required String nombre,
    required String correo,
    required String carrera,
    required String telefono,
    required String foto,
  }) async {
    final nuevoCorreo = correo.trim().toLowerCase();
    if (!Validadores.esCorreoInstitucional(nuevoCorreo)) {
      throw ArgumentError('Usa tu correo institucional @aloe.ulima.edu.pe.');
    }
    if (nombre.trim().length < 3) {
      throw ArgumentError('Escribe un nombre válido.');
    }
    final actual = buscarPorCorreo(correoAnterior);
    final existe = buscarPorCorreo(nuevoCorreo);
    if (existe != null && existe.id != actual?.id) {
      throw StateError('Ese correo pertenece a otro perfil local.');
    }
    final editado = actual == null
        ? UsuarioPerfil(
            id: 'demo_${DateTime.now().microsecondsSinceEpoch}',
            nombre: nombre.trim(),
            correo: nuevoCorreo,
            carrera: carrera.trim(),
            telefono: telefono.trim(),
            foto: foto,
            fechaRegistro: DateTime.now(),
          )
        : actual.copyWith(
            nombre: nombre.trim(),
            correo: nuevoCorreo,
            carrera: carrera.trim(),
            telefono: telefono.trim(),
            foto: foto,
          );
    final nuevaLista = [
      for (final usuario in _usuarios)
        if (usuario.id == actual?.id) editado else usuario,
      if (actual == null) editado,
    ];
    await repository.guardarTodos(nuevaLista);
    _usuarios
      ..clear()
      ..addAll(nuevaLista);
    notifyListeners();
    return editado;
  }
}
