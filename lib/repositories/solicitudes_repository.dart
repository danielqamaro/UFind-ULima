import 'package:ufind/models/solicitud_recuperacion.dart';

abstract class SolicitudesRepository {
  Future<List<SolicitudRecuperacion>> listar();
  Future<void> guardarTodos(List<SolicitudRecuperacion> solicitudes);
}
