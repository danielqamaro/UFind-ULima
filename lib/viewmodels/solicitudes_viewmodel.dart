import 'package:flutter/foundation.dart';

import 'package:ufind/models/objeto_publicacion.dart';
import 'package:ufind/models/solicitud_recuperacion.dart';
import 'package:ufind/repositories/memoria_solicitudes_repository.dart';
import 'package:ufind/repositories/solicitudes_repository.dart';

class SolicitudesViewModel extends ChangeNotifier {
  final SolicitudesRepository repository;
  Future<void> _colaGuardado = Future.value();
  List<SolicitudRecuperacion> _solicitudes = [];
  int _siguienteId = 1;

  SolicitudesViewModel({SolicitudesRepository? repository})
    : repository = repository ?? MemoriaSolicitudesRepository();

  Future<void> cargar() async {
    try {
      _solicitudes = await repository.listar();
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

  List<SolicitudRecuperacion> porCorreo(String correo) {
    final cuenta = correo.trim().toLowerCase();
    return _solicitudes.reversed.where((s) => s.correo == cuenta).toList();
  }

  List<SolicitudRecuperacion> notificaciones(String correo) =>
      porCorreo(correo).where((s) => s.resuelta).toList()..sort(
        (a, b) => (b.fechaResolucion ?? b.fecha).compareTo(
          a.fechaResolucion ?? a.fecha,
        ),
      );

  bool tienePendiente(int objetoId, String correo) =>
      porCorreo(correo)
          .any((s) => s.objetoId == objetoId && s.estado == 'Pendiente');

  Future<bool> registrar({
    required ObjetoPublicacion objeto,
    required String correo,
    required String nombreSolicitante,
    required String descripcion,
    String telefono = '',
    String fotoEvidencia = '',
  }) => _enCola(() async {
    final cuenta = correo.trim().toLowerCase();
    if (objeto.estado != 'Disponible' ||
        cuenta.isEmpty ||
        nombreSolicitante.trim().length < 2 ||
        descripcion.trim().length < 12 ||
        tienePendiente(objeto.id, cuenta)) {
      return false;
    }

    final solicitud = SolicitudRecuperacion(
      id: _siguienteId,
      objetoId: objeto.id,
      objetoNombre: objeto.nombre,
      correo: cuenta,
      nombreSolicitante: nombreSolicitante.trim(),
      telefono: telefono.trim(),
      descripcion: descripcion.trim(),
      fotoEvidencia: fotoEvidencia,
      fecha: DateTime.now(),
    );
    await _guardar([..._solicitudes, solicitud]);
    _siguienteId++;
    return true;
  });

  Future<bool> resolver(int id, {required bool aprobar, String motivo = ''}) =>
      _enCola(() async {
        final indice = _solicitudes.indexWhere((s) => s.id == id);
        final razon = motivo.trim();
        if (indice < 0 ||
            _solicitudes[indice].estado != 'Pendiente' ||
            (!aprobar && razon.isEmpty)) {
          return false;
        }
        final actualizadas = [..._solicitudes];
        actualizadas[indice] = actualizadas[indice].copyWith(
          estado: aprobar ? 'Aprobada' : 'Rechazada',
          motivoRechazo: aprobar ? '' : razon,
          fechaResolucion: DateTime.now(),
          notificacionLeida: false,
        );
        await _guardar(actualizadas);
        return true;
      });

  Future<void> marcarNotificacionesLeidas(String correo, Set<int> ids) =>
      _enCola(() async {
        final cuenta = correo.trim().toLowerCase();
        bool aplica(SolicitudRecuperacion s) =>
            s.correo == cuenta &&
            ids.contains(s.id) &&
            s.resuelta &&
            !s.notificacionLeida;
        if (!_solicitudes.any(aplica)) return;
        await _guardar([
          for (final s in _solicitudes)
            aplica(s) ? s.copyWith(notificacionLeida: true) : s,
        ]);
      });

  /// Conserva el vínculo de las solicitudes cuando el estudiante cambia su correo.
  Future<void> actualizarCorreo(String anterior, String nuevo) =>
      _enCola(() async {
        final origen = anterior.trim().toLowerCase();
        final destino = nuevo.trim().toLowerCase();
        if (origen == destino || !_solicitudes.any((s) => s.correo == origen)) {
          return;
        }
        await _guardar([
          for (final s in _solicitudes)
            s.correo == origen ? s.copyWith(correo: destino) : s,
        ]);
      });

  Future<T> _enCola<T>(Future<T> Function() ejecutar) {
    final operacion = _colaGuardado.then((_) => ejecutar());
    _colaGuardado = operacion.then<void>(
      (_) {},
      onError: (Object error) {
        debugPrint('Error al guardar solicitudes: $error');
      },
    );
    return operacion;
  }

  Future<void> _guardar(List<SolicitudRecuperacion> solicitudes) async {
    await repository.guardarTodos(solicitudes);
    _solicitudes = solicitudes;
    notifyListeners();
  }
}
