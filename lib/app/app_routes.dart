
import 'package:flutter/material.dart';
import 'package:ufind/views/auth/bienvenida.dart';
import 'package:ufind/views/auth/login.dart';
import 'package:ufind/views/auth/registro.dart';
import 'package:ufind/views/temporal/proximamente_screen.dart';

import 'app_dependencies.dart';

class AppRoutes {
  AppRoutes._();

  static const inicial = '/bienvenida';

  static Map<String, WidgetBuilder> crear(AppDependencies d) => {
    '/bienvenida': (_) => const BienvenidaScreen(),

    '/login': (_) => LoginScreen(dependencias: d),

    '/registro': (_) => RegistroScreen(dependencias: d),

    '/inicio': (_) => const ProximamenteScreen(
      titulo: 'Objetos perdidos',
      descripcion: 'Aquí podrás buscar los objetos perdidos en la universidad.',
    ),

    '/admin': (_) => const ProximamenteScreen(
      titulo: 'Administración',
      descripcion: 'Aquí podrás gestionar los objetos encontrados.',
    ),
  };
}
