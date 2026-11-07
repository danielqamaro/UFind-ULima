import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

/// Servicio local: codifica/decodifica JSON, sin reglas de negocio.
class PreferenciasService {
  PreferenciasService(this._preferencias);
  final SharedPreferences _preferencias;

  Future<List<Map<String, dynamic>>?> leerLista(String clave) async {
    final texto = _preferencias.getString(clave);
    if (texto == null) return null;
    final datos = jsonDecode(texto);
    if (datos is! List || datos.any((item) => item is! Map)) {
      throw FormatException('Formato local inválido en $clave.');
    }
    return datos.map((item) => Map<String, dynamic>.from(item as Map)).toList();
  }

  Future<void> guardarLista(
    String clave,
    List<Map<String, dynamic>> datos,
  ) async {
    final guardado = await _preferencias.setString(clave, jsonEncode(datos));
    if (!guardado) {
      throw StateError('No se pudieron guardar los datos locales.');
    }
  }
}
