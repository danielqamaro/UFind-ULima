import 'package:flutter/material.dart';

import 'app/app_dependencies.dart';
import 'app/app_routes.dart';
import 'app/app_theme.dart';

/// Inicia la aplicación y libera los ViewModels al cerrarse.
class UFindRoot extends StatefulWidget {
  const UFindRoot({super.key, required this.dependencias});

  final AppDependencies dependencias;

  @override
  State<UFindRoot> createState() => _UFindRootState();
}

class _UFindRootState extends State<UFindRoot> {
  @override
  void dispose() {
    widget.dependencias.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) =>
      LostFoundApp(dependencias: widget.dependencias);
}

/// MaterialApp, tema y rutas, igual que los ejemplos de clase.
class LostFoundApp extends StatelessWidget {
  const LostFoundApp({super.key, required this.dependencias});

  final AppDependencies dependencias;
  static const naranja = AppTheme.naranja;

  @override
  Widget build(BuildContext context) => ListenableBuilder(
    listenable: dependencias.tema,
    builder: (context, _) => MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'UFind · Universidad de Lima',
      themeMode: dependencias.tema.modo,
      theme: AppTheme.crear(Brightness.light),
      darkTheme: AppTheme.crear(Brightness.dark),
      initialRoute: AppRoutes.inicial,
      routes: AppRoutes.crear(dependencias),
    ),
  );
}
