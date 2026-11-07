import 'package:flutter/material.dart';

/// Identidad compartida por la bienvenida y el formulario de ingreso.
class UFindLogo extends StatelessWidget {
  const UFindLogo({super.key, this.claro = false, this.tamano = 42});

  final bool claro;
  final double tamano;

  @override
  Widget build(BuildContext context) {
    final color = claro
        ? Colors.white
        : Theme.of(context).colorScheme.onSurface;
    return Semantics(
      label: 'UFind',
      image: true,
      child: ExcludeSemantics(
        child: FittedBox(
          fit: BoxFit.scaleDown,
          alignment: Alignment.centerLeft,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.travel_explore_rounded,
                size: tamano + 6,
                color: color,
              ),
              const SizedBox(width: 10),
              Text(
                'UFind',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontSize: tamano,
                  fontWeight: FontWeight.w900,
                  letterSpacing: -1.5,
                  color: color,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

ButtonStyle botonAuth(BuildContext context, {bool secundario = false}) =>
    FilledButton.styleFrom(
      backgroundColor: secundario ? Colors.white : const Color(0xFF20243B),
      foregroundColor: secundario ? const Color(0xFF20243B) : Colors.white,
      minimumSize: const Size(double.infinity, 64),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 17),
      textStyle: Theme.of(context).textTheme.titleLarge
          ?.copyWith(fontSize: 21, fontWeight: FontWeight.w900),
      shape: const StadiumBorder(),
    );
