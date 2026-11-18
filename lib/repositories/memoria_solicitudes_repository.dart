import 'package:ufind/models/solicitud_recuperacion.dart';
import 'solicitudes_repository.dart';

class MemoriaSolicitudesRepository implements SolicitudesRepository {
  List<Map<String, dynamic>> _datos = [];
  @override
  Future<List<SolicitudRecuperacion>> listar() async =>
      _datos.map(SolicitudRecuperacion.fromJson).toList();
  @override
  Future<void> guardarTodos(List<SolicitudRecuperacion> solicitudes) async {
    _datos = solicitudes.map((s) => s.toJson()).toList();
  }
}
