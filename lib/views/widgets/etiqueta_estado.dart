import 'package:flutter/material.dart';

/// Los estados mantienen el mismo color en el catálogo y en el detalle.
class EtiquetaEstado extends StatelessWidget {
  const EtiquetaEstado({super.key, required this.estado});

  final String estado;

  @override
  Widget build(BuildContext context) {
    final (color, icono) = switch (estado) {
      'Disponible' => (
        const Color(0xFF15803D),
        Icons.check_circle_outline_rounded,
      ),
      'Reclamado' => (const Color(0xFF1D4ED8), Icons.person_outline_rounded),
      'Entregado' => (const Color(0xFF7E22CE), Icons.task_alt_rounded),
      _ => (const Color(0xFFA5440E), Icons.info_outline_rounded),
    };
    return Chip(
      avatar: Icon(icono, size: 19, color: Colors.white),
      label: Text(estado),
      backgroundColor: color,
      side: BorderSide.none,
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 4),
      labelStyle: Theme.of(context).textTheme.labelLarge?.copyWith(
        fontSize: 15,
        color: Colors.white,
        fontWeight: FontWeight.w900,
      ),
    );
  }
}
