import 'package:flutter/material.dart';

import 'package:ufind/services/validadores.dart';

import 'package:flutter/services.dart';

import 'package:ufind/app/app_dependencies.dart';
import 'package:ufind/views/widgets/boton_tema.dart';
import 'auth_estilo.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key, required this.dependencias});
  final AppDependencies dependencias;
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _form = GlobalKey<FormState>();
  final _correo = TextEditingController();
  final _password = TextEditingController();
  bool _ocultar = true;

  @override
  void dispose() {
    _correo.dispose();
    _password.dispose();
    super.dispose();
  }

  void _entrar({String? demo}) {
    if (demo == null && !_form.currentState!.validate()) return;
    final scope = widget.dependencias;
    final correo = demo ?? _correo.text.trim().toLowerCase();
    scope.sesion.ingresarDemo(
      correo,
      perfil: scope.usuarios.buscarPorCorreo(correo),
    );
    Navigator.pushNamedAndRemoveUntil(context, '/inicio', (route) => false);
  }

  InputDecoration _campo(
    BuildContext context,
    String hint,
    IconData icon, {
    Widget? suffix,
  }) {
    final oscuro = Theme.of(context).brightness == Brightness.dark;
    final borde = OutlineInputBorder(
      borderRadius: BorderRadius.circular(30),
      borderSide: BorderSide.none,
    );
    return InputDecoration(
      hintText: hint,
      prefixIcon: Icon(icon),
      suffixIcon: suffix,
      fillColor: oscuro ? const Color(0xFF272D38) : const Color(0xFFF0F1F6),
      border: borde,
      enabledBorder: borde,
      focusedBorder: borde.copyWith(
        borderSide: BorderSide(
          color: Theme.of(context).colorScheme.primary,
          width: 2,
        ),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 22, vertical: 20),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colores = Theme.of(context).colorScheme;
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light.copyWith(
        statusBarColor: Colors.transparent,
      ),
      child: Scaffold(
        backgroundColor: colores.surface,
        body: SafeArea(
          top: false,
          child: SingleChildScrollView(
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 600),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Stack(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(bottom: 28),
                          child: AspectRatio(
                            aspectRatio: 1672 / 941,
                            child: Image.asset(
                              'assets/login_ulises.png',
                              fit: BoxFit.cover,
                              excludeFromSemantics: true,
                            ),
                          ),
                        ),
                        Positioned(
                          left: 16,
                          right: 16,
                          top: 0,
                          child: SafeArea(
                            bottom: false,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                IconButton.filledTonal(
                                  tooltip: 'Volver a la bienvenida',
                                  style: IconButton.styleFrom(
                                    backgroundColor: Colors.white,
                                    foregroundColor: const Color(0xFF20243B),
                                  ),
                                  onPressed: () {
                                    if (Navigator.canPop(context)) {
                                      Navigator.pop(context);
                                    } else {
                                      Navigator.pushReplacementNamed(
                                        context,
                                        '/bienvenida',
                                      );
                                    }
                                  },
                                  icon: const Icon(Icons.arrow_back_rounded),
                                ),
                                BotonTema(tema: widget.dependencias.tema),
                              ],
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 0,
                          left: 0,
                          right: 0,
                          child: Container(
                            height: 56,
                            decoration: BoxDecoration(
                              color: colores.surface,
                              borderRadius: const BorderRadius.vertical(
                                top: Radius.circular(34),
                              ),
                            ),
                            alignment: Alignment.bottomCenter,
                            child: const UFindLogo(tamano: 32),
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(26, 18, 26, 28),
                      child: AutofillGroup(
                        child: Form(
                          key: _form,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Text(
                                '¡Qué bueno verte!',
                                textAlign: TextAlign.center,
                                style: Theme.of(context)
                                    .textTheme
                                    .headlineMedium
                                    ?.copyWith(
                                      fontSize: 29,
                                      fontWeight: FontWeight.w900,
                                    ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                'Ingresa y encuentra lo que buscas.',
                                textAlign: TextAlign.center,
                                style: Theme.of(context).textTheme.bodyLarge
                                    ?.copyWith(color: colores.onSurfaceVariant),
                              ),
                              const SizedBox(height: 28),
                              Text(
                                'Correo institucional',
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                              const SizedBox(height: 9),
                              TextFormField(
                                controller: _correo,
                                keyboardType: TextInputType.emailAddress,
                                textInputAction: TextInputAction.next,
                                autocorrect: false,
                                autofillHints: const [AutofillHints.email],
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
                                decoration: _campo(
                                  context,
                                  'usuario@aloe.ulima.edu.pe',
                                  Icons.mail_outline_rounded,
                                ),
                                validator: (s) =>
                                    s != null &&
                                        Validadores.esCorreoInstitucional(
                                          s.trim(),
                                        )
                                    ? null
                                    : 'Ingresa un correo @aloe.ulima.edu.pe',
                              ),
                              const SizedBox(height: 18),
                              Text(
                                'Contraseña',
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                              const SizedBox(height: 9),
                              TextFormField(
                                controller: _password,
                                obscureText: _ocultar,
                                textInputAction: TextInputAction.done,
                                onFieldSubmitted: (_) => _entrar(),
                                decoration: _campo(
                                  context,
                                  'Mínimo 6 caracteres de prueba',
                                  Icons.lock_outline_rounded,
                                  suffix: IconButton(
                                    tooltip: _ocultar
                                        ? 'Mostrar contraseña'
                                        : 'Ocultar contraseña',
                                    onPressed: () =>
                                        setState(() => _ocultar = !_ocultar),
                                    icon: Icon(
                                      _ocultar
                                          ? Icons.visibility_outlined
                                          : Icons.visibility_off_outlined,
                                    ),
                                  ),
                                ),
                                validator: (s) => (s?.length ?? 0) < 6
                                    ? 'Escribe al menos 6 caracteres de prueba'
                                    : null,
                              ),
                              const SizedBox(height: 12),
                              Text(
                                'Modo demo: usa una contraseña ficticia. No se verifica en un servidor.',
                                style: Theme.of(context).textTheme.bodySmall
                                    ?.copyWith(
                                      color: colores.onSurfaceVariant,
                                      height: 1.4,
                                    ),
                              ),
                              const SizedBox(height: 24),
                              FilledButton(
                                style: botonAuth(context),
                                onPressed: () => _entrar(),
                                child: const Text('Ingresar'),
                              ),
                              const SizedBox(height: 14),
                              Wrap(
                                alignment: WrapAlignment.center,
                                crossAxisAlignment: WrapCrossAlignment.center,
                                children: [
                                  const Text('¿Aún no tienes una cuenta?'),
                                  TextButton(
                                    onPressed: () => Navigator.pushNamed(
                                      context,
                                      '/registro',
                                    ),
                                    child: const Text(
                                      'Crear una cuenta',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w900,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              Divider(color: colores.outlineVariant),
                              TextButton.icon(
                                onPressed: () =>
                                    _entrar(demo: 'demo@aloe.ulima.edu.pe'),
                                icon: const Icon(Icons.school_outlined),
                                label: const Text('Probar como estudiante'),
                              ),
                              TextButton.icon(
                                onPressed: () =>
                                    Navigator.pushNamedAndRemoveUntil(
                                      context,
                                      '/admin',
                                      (route) => false,
                                    ),
                                icon: const Icon(
                                  Icons.admin_panel_settings_outlined,
                                ),
                                label: const Text(
                                  'Acceso administrador (demo)',
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
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
}
