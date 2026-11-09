import 'dart:async';

import 'package:ufind/demo/publicaciones_demo.dart';

import 'package:ufind/repositories/publicaciones_repository.dart';

import 'package:flutter/material.dart';
import 'package:ufind/models/objeto_publicacion.dart';

class PublicacionesViewModel extends ChangeNotifier {
  static const String contactoAdministracion = 'objetosperdidos@ulima.edu.pe';

  final PublicacionesRepository? repository;
  PublicacionesViewModel({this.repository});

  Future<void> cargar() async {
    if (repository == null) return;
    try {
      final guardadas = await repository!.cargar();
      if (guardadas == null) return;
      _publicaciones
        ..clear()
        ..addAll(guardadas);
      for (final item in _publicaciones) {
        if (item.id >= _siguienteId) _siguienteId = item.id + 1;
      }
      notifyListeners();
    } catch (error) {
      debugPrint('No fue posible cargar las publicaciones: $error');
    }
  }

  void _persistir() {
    final repo = repository;
    if (repo == null) return;
    unawaited(
      repo.guardar(_publicaciones).catchError((Object e) {
        debugPrint('No se pudieron persistir publicaciones: $e');
      }),
    );
  }

  int _siguienteId = 8;

  final List<ObjetoPublicacion> _publicaciones = crearPublicacionesDemo(
    contactoAdministracion: contactoAdministracion,
  );

  List<ObjetoPublicacion> obtenerPublicaciones() {
    return _publicaciones.toList();
  }

  List<ObjetoPublicacion> obtenerRecientes() {
    return _publicaciones.take(3).toList();
  }

  List<ObjetoPublicacion> filtrarPublicaciones({
    required String busqueda,
    required String categoria,
    DateTime? fechaDesde,
    DateTime? fechaHasta,
  }) {
    final texto = busqueda.trim().toLowerCase();
    final desde = fechaDesde == null ? null : DateUtils.dateOnly(fechaDesde);
    final hasta = fechaHasta == null ? null : DateUtils.dateOnly(fechaHasta);

    return _publicaciones.where((objeto) {
      final coincideNombre = objeto.nombre.toLowerCase().contains(texto);
      final coincideCategoria =
          categoria == 'Todas' || objeto.categoria == categoria;
      if (!coincideNombre || !coincideCategoria) {
        return false;
      }
      if (desde == null && hasta == null) {
        return true;
      }
      final fecha = _leerFecha(objeto.fecha);
      return fecha != null &&
          (desde == null || !fecha.isBefore(desde)) &&
          (hasta == null || !fecha.isAfter(hasta));
    }).toList();
  }

  DateTime? _leerFecha(String valor) {
    final partes = RegExp(r'^(\d{1,2})/(\d{1,2})/(\d{4})$')
        .firstMatch(valor.trim());
    if (partes == null) {
      return null;
    }
    final dia = int.parse(partes[1]!);
    final mes = int.parse(partes[2]!);
    final anio = int.parse(partes[3]!);
    final fecha = DateTime(anio, mes, dia);
    return fecha.year == anio && fecha.month == mes && fecha.day == dia
        ? fecha
        : null;
  }

  List<ObjetoPublicacion> filtrarAdministracion({
    required String busqueda,
    required String estado,
  }) {
    final texto = busqueda.trim().toLowerCase();

    return _publicaciones.where((objeto) {
      final coincideTexto =
          objeto.nombre.toLowerCase().contains(texto) ||
          objeto.edificio.toLowerCase().contains(texto);
      final coincideEstado = estado == 'Todos' || objeto.estado == estado;
      return coincideTexto && coincideEstado;
    }).toList();
  }

  void agregarPublicacion({
    required String nombre,
    required String categoria,
    required String descripcion,
    required String fecha,
    required String edificio,
    required String piso,
    required String referencia,
    required String fotografia,
    required double latitud,
    required double longitud,
  }) {
    _publicaciones.insert(
      0,
      ObjetoPublicacion(
        id: _siguienteId,
        nombre: nombre,
        categoria: categoria,
        descripcion: descripcion,
        fecha: fecha,
        ubicacion: '$edificio, $piso',
        estado: 'Disponible',
        tipo: 'Encontrado',
        usuario: 'Administración ULima',
        contacto: contactoAdministracion,
        edificio: edificio,
        piso: piso,
        referencia: referencia,
        fotografia: fotografia,
        latitud: latitud,
        longitud: longitud,
      ),
    );
    _siguienteId++;
    notifyListeners();
    _persistir();
  }

  void actualizarPublicacion({
    required ObjetoPublicacion objeto,
    required String nombre,
    required String categoria,
    required String descripcion,
    required String fecha,
    required String edificio,
    required String piso,
    required String referencia,
    required String fotografia,
    required double latitud,
    required double longitud,
  }) {
    objeto.nombre = nombre;
    objeto.categoria = categoria;
    objeto.descripcion = descripcion;
    objeto.fecha = fecha;
    objeto.edificio = edificio;
    objeto.piso = piso;
    objeto.referencia = referencia;
    objeto.ubicacion = '$edificio, $piso';
    objeto.fotografia = fotografia;
    objeto.latitud = latitud;
    objeto.longitud = longitud;
    notifyListeners();
    _persistir();
  }

  void eliminarPublicacion(int id) {
    _publicaciones.removeWhere((objeto) => objeto.id == id);
    notifyListeners();
    _persistir();
  }

  void cambiarEstado(int id, String nuevoEstado) {
    for (final objeto in _publicaciones) {
      if (objeto.id == id) {
        objeto.estado = nuevoEstado;
        notifyListeners();
        _persistir();
        return;
      }
    }
  }

  int get cantidadPublicaciones => _publicaciones.length;

  int get cantidadDisponibles =>
      _publicaciones.where((objeto) => objeto.estado == 'Disponible').length;

  int get cantidadReclamados =>
      _publicaciones.where((objeto) => objeto.estado == 'Reclamado').length;

  int get cantidadEntregados =>
      _publicaciones.where((objeto) => objeto.estado == 'Entregado').length;
}
