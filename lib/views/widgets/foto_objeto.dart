import 'dart:io';

import 'package:flutter/material.dart';

/// Presenta fotos de assets y fotos capturadas localmente de manera uniforme.
class FotoObjeto extends StatelessWidget {
  final String ruta;
  final double alto;
  final IconData reemplazo;
  const FotoObjeto({
    super.key,
    required this.ruta,
    this.alto = 210,
    this.reemplazo = Icons.inventory_2_rounded,
  });

  @override
  Widget build(BuildContext context) {
    Widget foto;
    if (ruta.startsWith('file:')) {
      foto = Image.file(
        File(ruta.substring(5)),
        fit: BoxFit.cover,
        width: double.infinity,
        height: alto,
        errorBuilder: (_, _, _) => _fallback(context),
      );
    } else if (ruta.trim().isNotEmpty) {
      foto = Image.asset(
        'assets/$ruta',
        fit: BoxFit.cover,
        width: double.infinity,
        height: alto,
        errorBuilder: (_, _, _) => _fallback(context),
      );
    } else {
      foto = _fallback(context);
    }
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: SizedBox(height: alto, width: double.infinity, child: foto),
    );
  }

  Widget _fallback(BuildContext context) => DecoratedBox(
    decoration: BoxDecoration(
      gradient: LinearGradient(
        colors: [
          Theme.of(context).colorScheme.primary.withValues(alpha: 0.24),
          Theme.of(context).colorScheme.primary.withValues(alpha: 0.07),
        ],
      ),
    ),
    child: Center(
      child: Icon(
        reemplazo,
        size: 86,
        color: Theme.of(context).colorScheme.primary,
      ),
    ),
  );
}
