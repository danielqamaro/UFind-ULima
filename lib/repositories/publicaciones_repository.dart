import 'package:ufind/models/objeto_publicacion.dart';

abstract class PublicacionesRepository {
  Future<List<ObjetoPublicacion>?> cargar();
  Future<void> guardar(List<ObjetoPublicacion> publicaciones);
}
