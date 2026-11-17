import 'dart:async';

import 'package:flutter/foundation.dart';

import 'package:ufind/repositories/solicitudes_repository.dart';
import 'package:ufind/repositories/memoria_solicitudes_repository.dart';
import 'package:ufind/models/objeto_publicacion.dart';
import 'package:ufind/models/solicitud_recuperacion.dart';

class SolicitudesViewModel extends ChangeNotifier {
  final SolicitudesRepository repository;
  Future<void> _colaGuardado = Future.value();
  final List<SolicitudRecuperacion> _solicitudes = [];
  int _siguienteId = 1;

  SolicitudesViewModel({SolicitudesRepository? repository})
    : repository = repository ?? MemoriaSolicitudesRepository();

  Future<void> cargar() async {
    try {
      final lista = await repository.listar();
      _solicitudes
        ..clear()
        ..addAll(lista);
      for (final solicitud in _solicitudes) {
        if (solicitud.id >= _siguienteId) _siguienteId = solicitud.id + 1;
      }
      notifyListeners();
    } catch (error) {
      debugPrint('No se pudieron recuperar las solicitudes: $error');
    }
  }

  List<SolicitudRecuperacion> obtenerTodas() =>
      List.unmodifiable(_solicitudes.reversed);
  List<SolicitudRecuperacion> porCorreo(String correo) => _solicitudes
      .where((s) => s.correo == correo.toLowerCase())
      .toList()
      .reversed
      .toList();

  bool tienePendiente(int objetoId, String correo) => _solicitudes.any(
    (s) =>
        s.objetoId == objetoId &&
        s.correo == correo.toLowerCase() &&
        s.estado == 'Pendiente',
  );

  bool registrar({
    required ObjetoPublicacion objeto,
    required String correo,
    required String descripcion,
  }) {
    if (objeto.estado != 'Disponible' ||
        correo.trim().isEmpty ||
        descripcion.trim().length < 12 ||
        tienePendiente(objeto.id, correo)) {
      return false;
    }

    _solicitudes.add(
      SolicitudRecuperacion(
        id: _siguienteId++,
        objetoId: objeto.id,
        objetoNombre: objeto.nombre,
        correo: correo.toLowerCase(),
        descripcion: descripcion.trim(),
        fecha: DateTime.now(),
      ),
    );
    notifyListeners();
    unawaited(_guardar());
    return true;
  }

  void cambiarEstado(int id, String estado) {
    if (!['Pendiente', 'Aprobada', 'Rechazada'].contains(estado)) return;
    for (final s in _solicitudes) {
      if (s.id == id) {
        s.estado = estado;
        notifyListeners();
        unawaited(_guardar());
        break;
      }
    }
  }

  /// Conserva el vínculo de las solicitudes cuando el estudiante cambia su correo.
  Future<void> actualizarCorreo(String anterior, String nuevo) async {
    final origen = anterior.trim().toLowerCase();
    final destino = nuevo.trim().toLowerCase();
    if (origen == destino) return;
    final modificadas = _solicitudes.where((s) => s.correo == origen).toList();
    if (modificadas.isEmpty) return;
    for (final solicitud in modificadas) {
      solicitud.correo = destino;
    }
    try {
      await _guardar();
      notifyListeners();
    } catch (_) {
      for (final solicitud in modificadas) {
        solicitud.correo = origen;
      }
      rethrow;
    }
  }

  Future<void> _guardar() {
    final copia = _solicitudes
        .map((s) => SolicitudRecuperacion.fromJson(s.toJson()))
        .toList();
    final operacion = _colaGuardado.then((_) => repository.guardarTodos(copia));
    // Un error se informa, pero no bloquea los siguientes guardados.
    _colaGuardado = operacion.catchError((Object error) {
      debugPrint('Error al guardar solicitudes: $error');
    });
    return operacion;
  }
}
