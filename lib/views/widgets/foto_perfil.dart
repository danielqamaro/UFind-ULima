import 'dart:io';

import 'package:flutter/material.dart';

class FotoPerfil extends StatelessWidget {
  const FotoPerfil({super.key, required this.ruta, this.radio = 50});
  final String ruta;
  final double radio;

  @override
  Widget build(BuildContext context) {
    final colores = Theme.of(context).colorScheme;
    Widget respaldo() => ColoredBox(
      color: colores.primary.withValues(alpha: 0.13),
      child: Center(
        child: Icon(
          Icons.person_rounded,
          size: radio * 1.05,
          color: colores.primary,
        ),
      ),
    );

    return ClipOval(
      child: SizedBox(
        width: radio * 2,
        height: radio * 2,
        child: ruta.startsWith('file:')
            ? Image.file(
                File(ruta.substring(5)),
                fit: BoxFit.cover,
                errorBuilder: (_, _, _) => respaldo(),
              )
            : respaldo(),
      ),
    );
  }
}
