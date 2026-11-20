import 'package:flutter/material.dart';

import 'package:ufind/app/app_dependencies.dart';
import 'package:ufind/models/solicitud_recuperacion.dart';
import 'package:ufind/views/widgets/foto_objeto.dart';

class GestionSolicitudesScreen extends StatelessWidget {
  const GestionSolicitudesScreen({super.key, required this.dependencias});
  final AppDependencies dependencias;

  Future<void> _decidir(
    BuildContext context,
    SolicitudRecuperacion solicitud, {
    required bool aprobar,
  }) async {
    final motivo = await showDialog<String>(
      context: context,
      builder: (_) => _DialogoDecision(solicitud: solicitud, aprobar: aprobar),
    );
    if (motivo == null || !context.mounted) return;
    try {
      final exito = await dependencias.solicitudes.resolver(
        solicitud.id,
        aprobar: aprobar,
        motivo: motivo,
      );
      if (!context.mounted) return;
      _avisar(
        context,
        !exito
            ? 'La solicitud ya fue revisada.'
            : aprobar
            ? 'Solicitud aprobada.'
            : 'Solicitud rechazada.',
      );
    } catch (_) {
      if (context.mounted) _avisar(context, 'No se pudo guardar la decisión.');
    }
  }

  void _avisar(BuildContext context, String mensaje) =>
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(mensaje)));

  @override
  Widget build(BuildContext context) {
    final vm = dependencias.solicitudes;
    return Scaffold(
      appBar: AppBar(title: const Text('Solicitudes recibidas')),
      body: SafeArea(
        child: ListenableBuilder(
          listenable: vm,
          builder: (context, _) {
            final solicitudes = vm.obtenerTodas();
            if (solicitudes.isEmpty) {
              return const Center(
                child: Padding(
                  padding: EdgeInsets.all(24),
                  child: Text(
                    'Todavía no se registraron solicitudes.',
                    textAlign: TextAlign.center,
                  ),
                ),
              );
            }
            return ListView.builder(
              padding: const EdgeInsets.all(16),
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
    final textos = Theme.of(context).textTheme;
    final fecha = MaterialLocalizations.of(context)
        .formatShortDate(solicitud.fecha);
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
                  child: Text(solicitud.objetoNombre, style: textos.titleLarge),
                ),
                const SizedBox(width: 8),
                Chip(label: Text(solicitud.estado)),
              ],
            ),
            Text('Recibida el $fecha', style: textos.bodyMedium),
            const SizedBox(height: 12),
            if (solicitud.nombreSolicitante.isNotEmpty)
              SelectableText(
                solicitud.nombreSolicitante,
                style: textos.titleMedium,
              ),
            SelectableText(solicitud.correo),
            if (solicitud.telefono.isNotEmpty)
              SelectableText('Teléfono: ${solicitud.telefono}'),
            const SizedBox(height: 12),
            Text('Prueba de propiedad', style: textos.titleMedium),
            SelectableText(solicitud.descripcion),
            if (solicitud.fotoEvidencia.isNotEmpty) ...[
              const SizedBox(height: 12),
              Text('Imagen adjunta', style: textos.titleMedium),
              FotoObjeto(
                ruta: solicitud.fotoEvidencia,
                alto: 230,
                ajuste: BoxFit.contain,
                reemplazo: Icons.image_not_supported_outlined,
              ),
            ],
            if (solicitud.motivoRechazo.isNotEmpty) ...[
              const SizedBox(height: 12),
              Text('Motivo del rechazo', style: textos.titleMedium),
              SelectableText(solicitud.motivoRechazo),
            ],
            if (solicitud.estado == 'Pendiente') ...[
              const SizedBox(height: 12),
              Wrap(
                spacing: 10,
                runSpacing: 8,
                children: [
                  FilledButton.tonalIcon(
                    onPressed: () =>
                        _decidir(context, solicitud, aprobar: true),
                    icon: const Icon(Icons.check_circle_outline),
                    label: const Text('Aprobar'),
                  ),
                  OutlinedButton.icon(
                    onPressed: () =>
                        _decidir(context, solicitud, aprobar: false),
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
  }
}

class _DialogoDecision extends StatefulWidget {
  const _DialogoDecision({required this.solicitud, required this.aprobar});
  final SolicitudRecuperacion solicitud;
  final bool aprobar;

  @override
  State<_DialogoDecision> createState() => _DialogoDecisionState();
}

class _DialogoDecisionState extends State<_DialogoDecision> {
  final _formulario = GlobalKey<FormState>();
  final _motivo = TextEditingController();

  @override
  void dispose() {
    _motivo.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => AlertDialog(
    scrollable: true,
    title: Text(widget.aprobar ? 'Aprobar solicitud' : 'Rechazar solicitud'),
    content: widget.aprobar
        ? Text('¿Quieres aprobar el reclamo de ${widget.solicitud.correo}?')
        : Form(
            key: _formulario,
            child: TextFormField(
              controller: _motivo,
              minLines: 2,
              maxLines: 5,
              maxLength: 500,
              decoration: const InputDecoration(
                labelText: 'Motivo del rechazo',
                helperText: 'El estudiante recibirá este mensaje.',
                helperMaxLines: 2,
                alignLabelWithHint: true,
              ),
              validator: (texto) => (texto?.trim().isEmpty ?? true)
                  ? 'Escribe el motivo del rechazo'
                  : null,
            ),
          ),
    actions: [
      TextButton(
        onPressed: () => Navigator.pop(context),
        child: const Text('Cancelar'),
      ),
      FilledButton(
        onPressed: () {
          if (widget.aprobar || _formulario.currentState!.validate()) {
            Navigator.pop(context, _motivo.text.trim());
          }
        },
        child: Text(widget.aprobar ? 'Aprobar' : 'Rechazar'),
      ),
    ],
  );
}
