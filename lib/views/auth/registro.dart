import 'package:flutter/material.dart';

import 'package:ufind/services/validadores.dart';
import 'package:ufind/app/app_dependencies.dart';
import 'package:ufind/views/widgets/boton_tema.dart';

class RegistroScreen extends StatefulWidget {
  const RegistroScreen({super.key, required this.dependencias});
  final AppDependencies dependencias;

  @override
  State<RegistroScreen> createState() => _RegistroScreenState();
}

class _RegistroScreenState extends State<RegistroScreen> {
  final _form = GlobalKey<FormState>();
  final _nombre = TextEditingController();
  final _correo = TextEditingController();
  final _carrera = TextEditingController();
  final _password = TextEditingController();
  final _confirmacion = TextEditingController();
  bool _ocultar = true;
  bool _guardando = false;

  @override
  void dispose() {
    _nombre.dispose();
    _correo.dispose();
    _carrera.dispose();
    _password.dispose();
    _confirmacion.dispose();
    super.dispose();
  }

  Future<void> _crear() async {
    if (!_form.currentState!.validate() || _guardando) return;
    setState(() => _guardando = true);
    try {
      final scope = widget.dependencias;
      final usuario = await scope.usuarios.registrar(
        nombre: _nombre.text,
        correo: _correo.text,
        carrera: _carrera.text,
      );
      if (!mounted) return;
      scope.sesion.ingresarDemo(usuario.correo, perfil: usuario);
      Navigator.pushNamedAndRemoveUntil(context, '/inicio', (r) => false);
    } catch (error) {
      if (!mounted) return;
      final mensaje = error is StateError
          ? error.message
          : error is ArgumentError
          ? error.message
          : 'No se pudo guardar el perfil.';
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('$mensaje')));
    } finally {
      if (mounted) setState(() => _guardando = false);
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: const Text('Crear cuenta'),
      actions: [BotonTema(tema: widget.dependencias.tema), const SizedBox(width: 14)],
    ),
    body: SafeArea(
      child: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 30),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 500),
            child: Form(
              key: _form,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Icon(
                    Icons.person_add_alt_1_rounded,
                    size: 66,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Únete a UFind',
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Crea tu perfil para identificar tus solicitudes.',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  const SizedBox(height: 18),
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(15),
                      child: Text(
                        'Cuenta de demostración: los datos quedan solo en este móvil. '
                        'La contraseña no se almacena ni se valida al ingresar. '
                        'Usa una contraseña ficticia.',
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: _nombre,
                    textCapitalization: TextCapitalization.words,
                    decoration: const InputDecoration(
                      labelText: 'Nombre completo *',
                      prefixIcon: Icon(Icons.badge_outlined),
                    ),
                    validator: (v) => (v?.trim().length ?? 0) < 3
                        ? 'Escribe tu nombre completo'
                        : null,
                  ),
                  const SizedBox(height: 14),
                  TextFormField(
                    controller: _correo,
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(
                      labelText: 'Correo institucional *',
                      hintText: 'usuario@aloe.ulima.edu.pe',
                      prefixIcon: Icon(Icons.alternate_email_rounded),
                    ),
                    validator: (v) =>
                        Validadores.esCorreoInstitucional(v?.trim() ?? '')
                        ? null
                        : 'Usa un correo @aloe.ulima.edu.pe',
                  ),
                  const SizedBox(height: 14),
                  TextFormField(
                    controller: _carrera,
                    decoration: const InputDecoration(
                      labelText: 'Carrera (opcional)',
                      prefixIcon: Icon(Icons.school_outlined),
                    ),
                  ),
                  const SizedBox(height: 14),
                  TextFormField(
                    controller: _password,
                    obscureText: _ocultar,
                    decoration: InputDecoration(
                      labelText: 'Contraseña ficticia *',
                      prefixIcon: const Icon(Icons.lock_outline),
                      suffixIcon: IconButton(
                        onPressed: () => setState(() => _ocultar = !_ocultar),
                        tooltip: _ocultar
                            ? 'Mostrar contraseña'
                            : 'Ocultar contraseña',
                        icon: Icon(
                          _ocultar
                              ? Icons.visibility_outlined
                              : Icons.visibility_off_outlined,
                        ),
                      ),
                    ),
                    validator: (v) => (v?.length ?? 0) < 6
                        ? 'Mínimo 6 caracteres de prueba'
                        : null,
                  ),
                  const SizedBox(height: 14),
                  TextFormField(
                    controller: _confirmacion,
                    obscureText: _ocultar,
                    decoration: const InputDecoration(
                      labelText: 'Confirmar contraseña *',
                      prefixIcon: Icon(Icons.verified_user_outlined),
                    ),
                    validator: (v) => v != _password.text
                        ? 'Las contraseñas no coinciden'
                        : null,
                  ),
                  const SizedBox(height: 22),
                  FilledButton.icon(
                    onPressed: _guardando ? null : _crear,
                    icon: _guardando
                        ? const SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Icon(Icons.check_circle_outline_rounded),
                    label: Text(
                      _guardando ? 'Guardando...' : 'Crear perfil y continuar',
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Ya tengo una cuenta: volver al inicio'),
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
