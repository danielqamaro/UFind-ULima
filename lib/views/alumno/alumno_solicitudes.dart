import 'package:flutter/material.dart';

import 'package:ufind/app/app_dependencies.dart';
import 'package:ufind/models/solicitud_recuperacion.dart';

import 'notificaciones.dart';

class AlumnoSolicitudes extends StatelessWidget {
  const AlumnoSolicitudes({super.key, required this.dependencias});
  final AppDependencies dependencias;

  Color _colorEstado(BuildContext context, String estado) => switch (estado) {
    'Aprobada' => Colors.green,
    'Rechazada' => Theme.of(context).colorScheme.error,
    _ => Theme.of(context).colorScheme.primary,
  };

  @override
  Widget build(BuildContext context) {
    final servicios = dependencias;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mis solicitudes'),
        actions: [CampanaNotificaciones(dependencias: dependencias)],
      ),
      body: SafeArea(
        child: ListenableBuilder(
          listenable: servicios.solicitudes,
          builder: (context, _) {
            final correo = servicios.sesion.correo ?? '';
            final solicitudes = servicios.solicitudes.porCorreo(correo);
            if (solicitudes.isEmpty) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(28),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.mark_email_unread_outlined,
                        size: 76,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      const SizedBox(height: 15),
                      Text(
                        'Aún no tienes solicitudes',
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 9),
                      Text(
                        'Abre el detalle de un objeto disponible y selecciona "Reclamar objeto".',
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                    ],
                  ),
                ),
              );
            }
            return ListView.builder(
              padding: const EdgeInsets.all(18),
              itemCount: solicitudes.length,
              itemBuilder: (context, index) =>
                  _tarjeta(context, solicitudes[index]),
            );
          },
        ),
      ),
    );
  }

  Widget _tarjeta(BuildContext context, SolicitudRecuperacion solicitud) {
    final color = _colorEstado(context, solicitud.estado);
    final fecha = solicitud.fecha;
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
                    solicitud.objetoNombre,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ),
                const SizedBox(width: 8),
                Chip(
                  label: Text(solicitud.estado),
                  backgroundColor: color.withValues(alpha: 0.13),
                  labelStyle: TextStyle(
                    color: color,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              'Enviada el ${fecha.day.toString().padLeft(2, '0')}/${fecha.month.toString().padLeft(2, '0')}/${fecha.year}',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 11),
            Text(
              solicitud.descripcion,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            if (solicitud.motivoRechazo.isNotEmpty) ...[
              const SizedBox(height: 12),
              Text('Motivo del rechazo: ${solicitud.motivoRechazo}'),
            ],
            if (solicitud.estado == 'Aprobada') ...[
              const SizedBox(height: 12),
              const Text(
                'Acércate a Administración con una identificación y pruebas de propiedad.',
              ),
            ],
          ],
        ),
      ),
    );
  }
}
