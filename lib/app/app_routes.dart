import 'package:flutter/material.dart';
import 'package:ufind/views/temporal/proximamente_screen.dart';
import 'app_dependencies.dart';
class AppRoutes {
  AppRoutes._();
  static const inicial = '/bienvenida';
  static Map<String, WidgetBuilder> crear(AppDependencies d) => {
    '/bienvenida': (_) => const ProximamenteScreen(titulo: 'Bienvenido a UFind', descripcion: 'Encuentra tus objetos perdidos en la universidad de Lima'),
    '/inicio': (_) => const ProximamenteScreen(titulo: 'Objetos perdidos', descripcion: 'Aquí podrás buscar los objetos perdidos en la universidad.'),
    '/admin': (_) => const ProximamenteScreen(titulo: 'Administración', descripcion: 'Aquí podrás gestionar los objetos encontrados.'),
  };
}
