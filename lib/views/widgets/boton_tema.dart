import 'package:flutter/material.dart';

import 'package:ufind/viewmodels/theme_controller.dart';

/// Botón sencillo de tema; el controlador llega por constructor (semana 6).
class BotonTema extends StatelessWidget {
  const BotonTema({super.key, required this.tema});

  final ThemeController tema;

  @override
  Widget build(BuildContext context) => ListenableBuilder(
    listenable: tema,
    builder: (context, _) {
      final oscuro = Theme.of(context).brightness == Brightness.dark;
      return IconButton.filledTonal(
        tooltip: oscuro ? 'Activar modo claro' : 'Activar modo oscuro',
        iconSize: 29,
        icon: Icon(oscuro ? Icons.light_mode_rounded : Icons.dark_mode_rounded),
        onPressed: () => tema.cambiar(oscuro ? ThemeMode.light : ThemeMode.dark),
      );
    },
  );
}
