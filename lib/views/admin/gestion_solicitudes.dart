import 'package:flutter/material.dart';

import 'package:ufind/app/app_dependencies.dart';
import 'package:ufind/models/solicitud_recuperacion.dart';

class GestionSolicitudesScreen extends StatelessWidget {
  const GestionSolicitudesScreen({super.key, required this.dependencias});
  final AppDependencies dependencias;

  Future<void> _decidir(
    BuildContext context,
    SolicitudRecuperacion solicitud,
    String estado,
  ) async {
    final aceptar = await showDialog<bool>(
      context: context,
      builder: (d) => AlertDialog(
        title: Text('$estado solicitud'),
        content: Text(
          '¿Confirmas el cambio de estado de la solicitud de ${solicitud.correo}?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(d, false),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(d, true),
            child: const Text('Confirmar'),
          ),
        ],
      ),
    );
    if (aceptar != true || !context.mounted) return;
    dependencias.solicitudes.cambiarEstado(solicitud.id, estado);
    // Aprobar una solicitud NO prueba que el objeto se haya entregado.
    // El administrador debe actualizar el estado del objeto por separado.
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Solicitud ${estado.toLowerCase()} correctamente.',
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final vm = dependencias.solicitudes;
    return Scaffold(
      appBar: AppBar(title: const Text('Solicitudes recibidas')),
      body: SafeArea(
        child: ListenableBuilder(
          listenable: vm,
          builder: (context, _) {
            final datos = vm.obtenerTodas();
            if (datos.isEmpty) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Text(
                    'Todavía no se registraron solicitudes.',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ),
              );
            }
            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: datos.length,
              itemBuilder: (context, index) {
                final s = datos[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 14),
                  child: Padding(
                    padding: const EdgeInsets.all(18),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                s.objetoNombre,
                                style: Theme.of(context).textTheme.titleLarge,
                              ),
                            ),
                            Chip(label: Text(s.estado)),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          s.correo,
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          s.descripcion,
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                        if (s.estado == 'Pendiente') ...[
                          const SizedBox(height: 12),
                          Wrap(
                            spacing: 10,
                            runSpacing: 8,
                            children: [
                              FilledButton.tonalIcon(
                                onPressed: () =>
                                    _decidir(context, s, 'Aprobada'),
                                icon: const Icon(Icons.check_circle_outline),
                                label: const Text('Aprobar'),
                              ),
                              OutlinedButton.icon(
                                onPressed: () =>
                                    _decidir(context, s, 'Rechazada'),
                                icon: const Icon(Icons.cancel_outlined),
                                label: const Text('Rechazar'),
                              ),
                            ],
                          ),
                        ],
                      ],
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
