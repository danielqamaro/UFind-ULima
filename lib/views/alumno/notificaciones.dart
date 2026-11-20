import 'package:flutter/material.dart';

import 'package:ufind/app/app_dependencies.dart';

class CampanaNotificaciones extends StatelessWidget {
  const CampanaNotificaciones({super.key, required this.dependencias});

  final AppDependencies dependencias;

  Future<void> _abrir(BuildContext context, String correo) async {
    final solicitudes = dependencias.solicitudes;
    final pendientes = solicitudes
        .notificaciones(correo)
        .where((s) => !s.notificacionLeida)
        .map((s) => s.id)
        .toSet();
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) =>
            NotificacionesScreen(dependencias: dependencias, correo: correo),
      ),
    );
    try {
      await solicitudes.marcarNotificacionesLeidas(correo, pendientes);
    } catch (_) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('No se pudo marcar las notificaciones como leídas.'),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) => ListenableBuilder(
    listenable: Listenable.merge([
      dependencias.solicitudes,
      dependencias.sesion,
    ]),
    builder: (context, _) {
      final correo = dependencias.sesion.correo;
      if (correo == null) return const SizedBox.shrink();
      final nuevas = dependencias.solicitudes
          .notificaciones(correo)
          .where((s) => !s.notificacionLeida)
          .length;
      return IconButton(
        tooltip: nuevas == 0
            ? 'Notificaciones'
            : 'Notificaciones ($nuevas nuevas)',
        onPressed: () => _abrir(context, correo),
        icon: Badge.count(
          count: nuevas,
          isLabelVisible: nuevas > 0,
          child: const Icon(Icons.notifications_outlined),
        ),
      );
    },
  );
}

class NotificacionesScreen extends StatelessWidget {
  const NotificacionesScreen({
    super.key,
    required this.dependencias,
    required this.correo,
  });

  final AppDependencies dependencias;
  final String correo;

  @override
  Widget build(BuildContext context) {
    final solicitudes = dependencias.solicitudes;
    return Scaffold(
      appBar: AppBar(title: const Text('Notificaciones')),
      body: SafeArea(
        child: ListenableBuilder(
          listenable: solicitudes,
          builder: (context, _) {
            final datos = solicitudes.notificaciones(correo);
            if (datos.isEmpty) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.notifications_none,
                        size: 60,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Todavía no tienes notificaciones.',
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                    ],
                  ),
                ),
              );
            }
            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: datos.length,
              itemBuilder: (context, index) {
                final solicitud = datos[index];
                final aprobada = solicitud.estado == 'Aprobada';
                final fecha = MaterialLocalizations.of(
                  context,
                ).formatShortDate(solicitud.fechaResolucion ?? solicitud.fecha);
                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: ListTile(
                    leading: Icon(
                      aprobada
                          ? Icons.check_circle_outline
                          : Icons.cancel_outlined,
                      color: aprobada
                          ? Theme.of(context).colorScheme.primary
                          : Theme.of(context).colorScheme.error,
                    ),
                    title: Text(
                      aprobada ? 'Solicitud aprobada' : 'Solicitud rechazada',
                    ),
                    subtitle: Padding(
                      padding: const EdgeInsets.only(top: 6),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(solicitud.objetoNombre),
                          if (aprobada)
                            const Text(
                              'Acércate a Administración para coordinar el recojo.',
                            ),
                          if (!aprobada && solicitud.motivoRechazo.isNotEmpty)
                            Text('Motivo: ${solicitud.motivoRechazo}'),
                          Text(
                            fecha,
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ],
                      ),
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
