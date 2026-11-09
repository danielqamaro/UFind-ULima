import 'package:flutter/material.dart';

class TarjetaBusqueda extends StatelessWidget {
  const TarjetaBusqueda({super.key, required this.onBuscar});

  final VoidCallback onBuscar;

  @override
  Widget build(BuildContext context) => ClipRRect(
    borderRadius: BorderRadius.circular(27),
    child: DecoratedBox(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFFF36F21), Color(0xFFB34A17)],
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.only(left: 18, top: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 18),
              child: Row(
                children: [
                  const Icon(
                    Icons.travel_explore_rounded,
                    size: 36,
                    color: Colors.white,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      '¿Perdiste algo?',
                      style: Theme.of(context).textTheme.headlineMedium
                          ?.copyWith(
                            fontSize: 31,
                            fontWeight: FontWeight.w900,
                            color: Colors.white,
                          ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 6),
            LayoutBuilder(
              builder: (context, constraints) {
                final altoUlises = (constraints.maxWidth * 0.45).clamp(
                  144.0,
                  190.0,
                );
                return IntrinsicHeight(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Expanded(
                        flex: 11,
                        child: Padding(
                          padding: const EdgeInsets.only(right: 8, bottom: 16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Busca los objetos encontrados y descubre dónde fueron reportados.',
                                style: Theme.of(context).textTheme.bodyLarge
                                    ?.copyWith(
                                      fontSize: 17,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.white,
                                    ),
                              ),
                              const SizedBox(height: 12),
                              FilledButton.icon(
                                onPressed: onBuscar,
                                style: FilledButton.styleFrom(
                                  backgroundColor: Colors.white,
                                  foregroundColor: const Color(0xFF983B0B),
                                  minimumSize: const Size(0, 46),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 14,
                                    vertical: 10,
                                  ),
                                  textStyle: Theme.of(context)
                                      .textTheme
                                      .titleMedium
                                      ?.copyWith(
                                        fontSize: 17,
                                        fontWeight: FontWeight.w900,
                                      ),
                                ),
                                icon: const Icon(Icons.search, size: 20),
                                label: const Text('Buscar ahora'),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 9,
                        child: SizedBox(
                          height: altoUlises,
                          child: Image.asset(
                            'assets/ulises_busqueda.png',
                            width: double.infinity,
                            fit: BoxFit.cover,
                            alignment: Alignment.topCenter,
                            cacheWidth: 512,
                            excludeFromSemantics: true,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    ),
  );
}
