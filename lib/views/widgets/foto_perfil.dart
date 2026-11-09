import 'package:flutter/material.dart';

/// Marcador temporal. El widget definitivo viene con el módulo de perfil.
class FotoPerfil extends StatelessWidget {
  const FotoPerfil({super.key, required this.ruta, this.radio = 36});
  final String ruta;
  final double radio;
  @override
  Widget build(BuildContext context) => CircleAvatar(
    radius: radio,
    backgroundColor: Theme.of(context).colorScheme.primaryContainer,
    child: Icon(Icons.person_outline_rounded, size: radio, color: Theme.of(context).colorScheme.onPrimaryContainer),
  );
}
