import 'package:flutter/material.dart';

class CategoriaItem extends StatelessWidget {
  final IconData icono;
  final String nombre;
  final bool seleccionado;
  final VoidCallback? onTap;

  const CategoriaItem({
    super.key,
    required this.icono,
    required this.nombre,
    this.seleccionado = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 110,
      child: TextButton(
        onPressed: onTap,
        style: TextButton.styleFrom(
          foregroundColor: seleccionado
              ? Theme.of(context).colorScheme.primary
              : Theme.of(context).colorScheme.onSurfaceVariant,
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 6),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          backgroundColor: seleccionado
              ? Theme.of(context).colorScheme.primary.withValues(alpha: 0.14)
              : Colors.transparent,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icono, size: 27),
            const SizedBox(height: 6),
            Text(
              nombre,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w800),
            ),
          ],
        ),
      ),
    );
  }
}
