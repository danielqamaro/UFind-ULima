import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'package:ufind/app/app_dependencies.dart';
import 'package:ufind/models/objeto_publicacion.dart';
import 'package:ufind/services/fotos_service.dart';
import 'package:ufind/views/widgets/foto_objeto.dart';

class FormularioReclamoScreen extends StatefulWidget {
  const FormularioReclamoScreen({
    super.key,
    required this.objeto,
    required this.dependencias,
    required this.correo,
  });

  final ObjetoPublicacion objeto;
  final AppDependencies dependencias;
  final String correo;

  @override
  State<FormularioReclamoScreen> createState() =>
      _FormularioReclamoScreenState();
}

class _FormularioReclamoScreenState extends State<FormularioReclamoScreen> {
  final _formulario = GlobalKey<FormState>();
  final _selector = ImagePicker();
  final _fotos = FotosService();
  late final _nombre = TextEditingController(
    text: widget.dependencias.sesion.nombre,
  );
  late final _telefono = TextEditingController(
    text: widget.dependencias.sesion.perfil?.telefono ?? '',
  );
  final _descripcion = TextEditingController();
  XFile? _imagen;
  bool _enviando = false;
  bool _seleccionando = false;

  @override
  void dispose() {
    _nombre.dispose();
    _telefono.dispose();
    _descripcion.dispose();
    super.dispose();
  }

  Future<void> _elegirImagen() async {
    setState(() => _seleccionando = true);
    try {
      final imagen = await _selector.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1600,
        imageQuality: 80,
      );
      if (mounted && imagen != null) setState(() => _imagen = imagen);
    } catch (_) {
      if (mounted) _avisar('No se pudo adjuntar la imagen.');
    } finally {
      if (mounted) setState(() => _seleccionando = false);
    }
  }

  Future<void> _enviar() async {
    if (_enviando || _seleccionando || !_formulario.currentState!.validate()) {
      return;
    }
    FocusScope.of(context).unfocus();
    setState(() => _enviando = true);
    var ruta = '';
    var guardado = false;
    try {
      final imagen = _imagen;
      if (imagen != null) ruta = await _fotos.conservar(imagen);
      guardado = await widget.dependencias.solicitudes.registrar(
        objeto: widget.objeto,
        correo: widget.correo,
        nombreSolicitante: _nombre.text,
        telefono: _telefono.text,
        descripcion: _descripcion.text,
        fotoEvidencia: ruta,
      );
      if (!mounted) return;
      if (guardado) {
        Navigator.of(context).pop(true);
      } else {
        _avisar(
          'El objeto ya no está disponible o tienes un reclamo pendiente.',
        );
      }
    } catch (_) {
      if (mounted) _avisar('No se pudo guardar el reclamo. Intenta de nuevo.');
    } finally {
      if (!guardado && ruta.startsWith('file:')) {
        try {
          await File(ruta.substring(5)).delete();
        } on FileSystemException catch (error) {
          debugPrint('No se pudo borrar el adjunto temporal: $error');
        }
      }
      if (mounted && !guardado) setState(() => _enviando = false);
    }
  }

  void _avisar(String mensaje) =>
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(mensaje)));

  @override
  Widget build(BuildContext context) {
    final ocupado = _enviando || _seleccionando;
    final imagen = _imagen;
    return PopScope(
      canPop: !_enviando,
      child: Scaffold(
        appBar: AppBar(title: const Text('Reclamar objeto')),
        body: SafeArea(
          child: Form(
            key: _formulario,
            child: ListView(
              padding: const EdgeInsets.all(18),
              children: [
                Text(
                  widget.objeto.nombre,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 8),
                const Text(
                  'Indica cómo podemos verificar que el objeto es tuyo.',
                ),
                const SizedBox(height: 18),
                TextFormField(
                  controller: _nombre,
                  enabled: !ocupado,
                  textCapitalization: TextCapitalization.words,
                  textInputAction: TextInputAction.next,
                  maxLength: 100,
                  decoration: const InputDecoration(
                    labelText: 'Nombre completo',
                  ),
                  validator: (texto) => (texto?.trim().length ?? 0) < 2
                      ? 'Ingresa tu nombre completo'
                      : null,
                ),
                const SizedBox(height: 10),
                TextFormField(
                  initialValue: widget.correo,
                  readOnly: true,
                  decoration: const InputDecoration(
                    labelText: 'Correo institucional',
                  ),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _telefono,
                  enabled: !ocupado,
                  keyboardType: TextInputType.phone,
                  textInputAction: TextInputAction.next,
                  maxLength: 30,
                  decoration: const InputDecoration(
                    labelText: 'Teléfono (opcional)',
                  ),
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _descripcion,
                  enabled: !ocupado,
                  minLines: 3,
                  maxLines: 6,
                  maxLength: 1500,
                  textCapitalization: TextCapitalization.sentences,
                  decoration: const InputDecoration(
                    labelText: 'Prueba de propiedad',
                    hintText: 'Describe una marca, accesorio o detalle que permita identificarlo',
                    alignLabelWithHint: true,
                  ),
                  validator: (texto) => (texto?.trim().length ?? 0) < 12
                      ? 'Escribe al menos 12 caracteres'
                      : null,
                ),
                const SizedBox(height: 10),
                if (imagen != null) ...[
                  FotoObjeto(
                    ruta: 'file:${imagen.path}',
                    alto: 180,
                    ajuste: BoxFit.contain,
                    reemplazo: Icons.image_not_supported_outlined,
                  ),
                  TextButton.icon(
                    onPressed: ocupado
                        ? null
                        : () => setState(() => _imagen = null),
                    icon: const Icon(Icons.close),
                    label: const Text('Quitar imagen'),
                  ),
                ],
                OutlinedButton.icon(
                  onPressed: ocupado ? null : _elegirImagen,
                  icon: const Icon(Icons.add_photo_alternate_outlined),
                  label: Text(
                    imagen == null
                        ? 'Adjuntar imagen (opcional)'
                        : 'Cambiar imagen',
                  ),
                ),
                const SizedBox(height: 16),
                FilledButton.icon(
                  onPressed: ocupado ? null : _enviar,
                  icon: const Icon(Icons.send_outlined),
                  label: Text(_enviando ? 'Enviando…' : 'Enviar reclamo'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
