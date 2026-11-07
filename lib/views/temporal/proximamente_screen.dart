import 'package:flutter/material.dart';
/// Pantalla provisional usada solo durante la migración incremental.
/// Se elimina al recuperar las rutas originales de UFind.
class ProximamenteScreen extends StatelessWidget {
  const ProximamenteScreen({super.key, required this.titulo, required this.descripcion});
  final String titulo;
  final String descripcion;

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('UFind')),
    body: SafeArea(
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 530),
          child: ListView(
            padding: const EdgeInsets.all(24),
            shrinkWrap: true,
            children: [
              Image.asset('assets/ulises_busqueda.png', height: 215, fit: BoxFit.contain),
              const SizedBox(height: 22),
              Text(titulo, textAlign: TextAlign.center, style: Theme.of(context).textTheme.headlineMedium),
              const SizedBox(height: 12),
              Text(descripcion, textAlign: TextAlign.center, style: Theme.of(context).textTheme.bodyLarge),
              const SizedBox(height: 20),
              Card(child: Padding(padding: const EdgeInsets.all(18), child: Column(children: const [
                Icon(Icons.construction_outlined, size: 35),
                SizedBox(height: 8),
                Text('Proximamente tendras mas funciones disponibles', textAlign: TextAlign.center),
              ]))),
              const SizedBox(height: 16),
              OutlinedButton.icon(
                onPressed: () => Navigator.pushNamedAndRemoveUntil(context, '/bienvenida', (_) => false),
                icon: const Icon(Icons.home_outlined),
                label: const Text('Volver al inicio'),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}
