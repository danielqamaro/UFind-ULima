import 'package:flutter/material.dart';

import 'package:ufind/app/app_dependencies.dart';
import 'package:ufind/views/widgets/foto_perfil.dart';
import 'package:ufind/views/widgets/objeto_card.dart';
import 'package:ufind/views/widgets/tarjeta_busqueda.dart';
import 'detalle_objeto.dart';
import 'package:ufind/viewmodels/publicaciones_viewmodel.dart';

class AlumnoHome extends StatelessWidget {
  final PublicacionesViewModel viewModel;
  final AppDependencies dependencias;
  final void Function(int) cambiarPagina;
  const AlumnoHome({
    super.key,
    required this.viewModel,
    required this.dependencias,
    required this.cambiarPagina,
  });

  @override
  Widget build(BuildContext context) {
    final colores = Theme.of(context).colorScheme;
    final sesion = dependencias.sesion;
    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(18, 18, 18, 32),
          children: [
            ListenableBuilder(
              listenable: sesion,
              builder: (context, _) => Row(
                children: [
                  Expanded(
                    child: Text(
                      '¡Hola, ${sesion.nombre}! 👋',
                      style: Theme.of(context).textTheme.headlineMedium
                          ?.copyWith(
                            fontWeight: FontWeight.w900,
                            fontSize: 31,
                            color: colores.onSurface,
                          ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Tooltip(
                    message: 'Ir a mi perfil',
                    child: InkWell(
                      onTap: () => cambiarPagina(4),
                      borderRadius: BorderRadius.circular(40),
                      child: FotoPerfil(ruta: sesion.foto, radio: 36),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),
            TarjetaBusqueda(onBuscar: () => cambiarPagina(1)),
            const SizedBox(height: 14),
            IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    child: _acceso(
                      context,
                      Icons.map_outlined,
                      'Mapa',
                      'Ver ubicaciones',
                      2,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _acceso(
                      context,
                      Icons.mark_email_unread_outlined,
                      'Solicitudes',
                      'Seguir mi caso',
                      3,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Objetos recientes',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ),
                TextButton(
                  onPressed: () => cambiarPagina(1),
                  child: const Text('Ver todos'),
                ),
              ],
            ),
            const SizedBox(height: 10),
            ListenableBuilder(
              listenable: viewModel,
              builder: (context, _) {
                final recientes = viewModel.obtenerRecientes();
                if (recientes.isEmpty) {
                  return const Text('No hay objetos publicados aún.');
                }
                return Column(
                  children: [
                    for (final objeto in recientes)
                      ObjetoCard(
                        objeto: objeto,
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => DetalleObjetoScreen(objeto: objeto, dependencias: dependencias),
                          ),
                        ),
                      ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _acceso(
    BuildContext context,
    IconData icono,
    String titulo,
    String subtitulo,
    int destino,
  ) {
    final colores = Theme.of(context).colorScheme;
    return Card(
      margin: EdgeInsets.zero,
      child: InkWell(
        borderRadius: BorderRadius.circular(23),
        onTap: () => cambiarPagina(destino),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(icono, size: 26, color: colores.primary),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      titulo,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                subtitulo,
                style: Theme.of(context).textTheme.bodyMedium
                    ?.copyWith(color: colores.onSurfaceVariant),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
