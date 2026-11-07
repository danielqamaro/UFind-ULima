import 'package:flutter/material.dart';
import 'package:ufind/views/temporal/proximamente_screen.dart';
import 'app_dependencies.dart';
class AppRoutes {
  AppRoutes._();
  static const inicial = '/bienvenida';
  static Map<String, WidgetBuilder> crear(AppDependencies d) => {
    '/bienvenida': (_) => const ProximamenteScreen(titulo: 'UFind: estructura inicial', descripcion: 'La base Flutter ya funciona. Las pantallas originales se incorporarán por módulos.'),
    '/inicio': (_) => const ProximamenteScreen(titulo: 'Inicio de UFind', descripcion: 'El catálogo se incorpora en la entrega de Antonio.'),
    '/admin': (_) => const ProximamenteScreen(titulo: 'Administración', descripcion: 'El panel de administración se incorpora en la entrega de Eros.'),
  };
}
