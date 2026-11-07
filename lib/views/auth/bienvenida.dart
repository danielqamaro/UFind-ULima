import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'auth_estilo.dart';

class BienvenidaScreen extends StatelessWidget {
  const BienvenidaScreen({super.key});

  @override
  Widget build(BuildContext context) => AnnotatedRegion<SystemUiOverlayStyle>(
    value: SystemUiOverlayStyle.light.copyWith(
      statusBarColor: Colors.transparent,
      systemNavigationBarColor: const Color(0xFFF85B06),
    ),
    child: Scaffold(
      backgroundColor: const Color(0xFFFF6508),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 600),
          child: Stack(
            fit: StackFit.expand,
            children: [
              Image.asset(
                'assets/bienvenida_ulises.png',
                fit: BoxFit.cover,
                alignment: Alignment.topCenter,
                excludeFromSemantics: true,
              ),
              const DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Color(0x18000000),
                      Colors.transparent,
                      Color(0x23000000),
                    ],
                    stops: [0, 0.55, 1],
                  ),
                ),
              ),
              SafeArea(
                child: LayoutBuilder(
                  builder: (context, constraints) => SingleChildScrollView(
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        minHeight: constraints.maxHeight,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(28, 20, 28, 26),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            const Align(
                              alignment: Alignment.center,
                              child: UFindLogo(claro: true, tamano: 44),
                            ),
                            SizedBox(height: constraints.maxHeight * 0.40),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Text(
                                  'Encuentra lo\nque importa.',
                                  style: Theme.of(context)
                                      .textTheme
                                      .headlineMedium
                                      ?.copyWith(
                                        color: Colors.white,
                                        fontSize: 36,
                                        fontWeight: FontWeight.w900,
                                        height: 1.12,
                                      ),
                                ),
                                const SizedBox(height: 12),
                                Text(
                                  'Tu campus. Tus cosas. Un solo lugar.',
                                  style: Theme.of(context).textTheme.bodyLarge
                                      ?.copyWith(
                                        color: Colors.white,
                                        fontSize: 17,
                                      ),
                                ),
                                const SizedBox(height: 28),
                                FilledButton(
                                  style: botonAuth(context),
                                  onPressed: () =>
                                      Navigator.pushNamed(context, '/login'),
                                  child: const Text('Ingresar'),
                                ),
                                const SizedBox(height: 14),
                                FilledButton(
                                  style: botonAuth(context, secundario: true),
                                  onPressed: () =>
                                      Navigator.pushNamed(context, '/registro'),
                                  child: const Text('Crear una cuenta'),
                                ),
                                const SizedBox(height: 22),
                                Text(
                                  'UNIVERSIDAD DE LIMA',
                                  textAlign: TextAlign.center,
                                  style: Theme.of(context).textTheme.labelMedium
                                      ?.copyWith(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w800,
                                        letterSpacing: 2,
                                      ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}
