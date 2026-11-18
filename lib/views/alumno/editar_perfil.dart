import 'package:flutter/material.dart';

import 'package:ufind/services/validadores.dart';
import 'package:ufind/app/app_dependencies.dart';
import 'package:ufind/views/widgets/foto_perfil.dart';
import 'package:ufind/views/widgets/selector_foto_perfil.dart';

class EditarPerfilScreen extends StatefulWidget {
  const EditarPerfilScreen({super.key, required this.dependencias});
  final AppDependencies dependencias;
  @override
  State<EditarPerfilScreen> createState() => _EditarPerfilScreenState();
}

class _EditarPerfilScreenState extends State<EditarPerfilScreen> {
  final _form = GlobalKey<FormState>();
  final _nombre = TextEditingController();
  final _correo = TextEditingController();
  final _carrera = TextEditingController();
  final _telefono = TextEditingController();
  String _foto = '';
  bool _procesandoFoto = false;
  bool _guardando = false;


  bool _cargado = false;
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_cargado) return;
    final sesion = widget.dependencias.sesion;
    final usuario = sesion.perfil;
    _nombre.text = usuario?.nombre ?? sesion.nombre;
    _correo.text = sesion.correo ?? '';
    _carrera.text = usuario?.carrera ?? '';
    _telefono.text = usuario?.telefono ?? '';
    _foto = usuario?.foto ?? '';
    _cargado = true;
  }

  @override
  void dispose() {
    _nombre.dispose();
    _correo.dispose();
    _carrera.dispose();
    _telefono.dispose();
    super.dispose();
  }

  Future<void> _elegirFoto() async {
    if (_procesandoFoto) return;
    setState(() => _procesandoFoto = true);
    try {
      final foto = await seleccionarFotoPerfil(context);
      if (mounted && foto != null) setState(() => _foto = foto);
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('No fue posible abrir la cámara o la galería.'),
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _procesandoFoto = false);
    }
  }

  Future<void> _guardar() async {
    if (_guardando || !_form.currentState!.validate()) return;
    setState(() => _guardando = true);
    try {
      final scope = widget.dependencias;
      final correoAnterior = scope.sesion.correo ?? '';
      final perfil = await scope.usuarios.actualizar(
        correoAnterior: correoAnterior,
        nombre: _nombre.text,
        correo: _correo.text,
        carrera: _carrera.text,
        telefono: _telefono.text,
        foto: _foto,
      );
      await scope.solicitudes.actualizarCorreo(correoAnterior, perfil.correo);
      if (!mounted) return;
      scope.sesion.actualizarPerfil(perfil);
      Navigator.pop(context, true);
    } catch (error) {
      if (!mounted) return;
      final mensaje = error is StateError
          ? error.message
          : error is ArgumentError
          ? error.message
          : 'No se pudieron guardar los cambios.';
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('$mensaje')));
    } finally {
      if (mounted) setState(() => _guardando = false);
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Editar mi perfil')),
    body: SafeArea(
      child: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 26),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 540),
            child: Form(
              key: _form,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Center(
                    child: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        FotoPerfil(ruta: _foto, radio: 60),
                        Positioned(
                          right: -4,
                          bottom: -3,
                          child: IconButton.filled(
                            tooltip: 'Cambiar foto de perfil',
                            onPressed: _procesandoFoto ? null : _elegirFoto,
                            icon: const Icon(Icons.camera_alt_rounded),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 9),
                  TextButton.icon(
                    onPressed: _procesandoFoto ? null : _elegirFoto,
                    icon: const Icon(Icons.photo_library_outlined),
                    label: const Text('Cambiar fotografía'),
                  ),
                  if (_foto.isNotEmpty)
                    TextButton.icon(
                      onPressed: () => setState(() => _foto = ''),
                      icon: const Icon(Icons.delete_outline),
                      label: const Text('Quitar foto'),
                    ),
                  const SizedBox(height: 18),
                  Text(
                    'Información personal',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 15),
                  TextFormField(
                    controller: _nombre,
                    textCapitalization: TextCapitalization.words,
                    decoration: const InputDecoration(
                      labelText: 'Nombre completo *',
                      prefixIcon: Icon(Icons.person_outline_rounded),
                    ),
                    validator: (v) => (v?.trim().length ?? 0) < 3
                        ? 'El nombre debe tener al menos 3 caracteres'
                        : null,
                  ),
                  const SizedBox(height: 15),
                  TextFormField(
                    controller: _correo,
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(
                      labelText: 'Correo institucional *',
                      prefixIcon: Icon(Icons.email_outlined),
                    ),
                    validator: (v) =>
                        Validadores.esCorreoInstitucional(v?.trim() ?? '')
                        ? null
                        : 'Usa un correo @aloe.ulima.edu.pe',
                  ),
                  const SizedBox(height: 15),
                  TextFormField(
                    controller: _carrera,
                    decoration: const InputDecoration(
                      labelText: 'Carrera',
                      prefixIcon: Icon(Icons.school_outlined),
                    ),
                  ),
                  const SizedBox(height: 15),
                  TextFormField(
                    controller: _telefono,
                    keyboardType: TextInputType.phone,
                    decoration: const InputDecoration(
                      labelText: 'Teléfono (opcional)',
                      prefixIcon: Icon(Icons.phone_outlined),
                    ),
                    validator: (v) =>
                        (v == null ||
                            v.trim().isEmpty ||
                            RegExp(r'^\+?[0-9 ]{7,15}$').hasMatch(v.trim()))
                        ? null
                        : 'Ingresa un número válido',
                  ),
                  const SizedBox(height: 17),
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(15),
                      child: Text(
                        'Tu fotografía y datos se guardan solo en este dispositivo. '
                        'Para sincronizarlos hará falta un backend.',
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  FilledButton.icon(
                    onPressed: _guardando ? null : _guardar,
                    icon: const Icon(Icons.save_outlined),
                    label: Text(
                      _guardando ? 'Guardando...' : 'Guardar cambios',
                    ),
                  ),
                  const SizedBox(height: 10),
                  OutlinedButton(
                    onPressed: _guardando ? null : () => Navigator.pop(context),
                    child: const Text('Cancelar'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    ),
  );
}
