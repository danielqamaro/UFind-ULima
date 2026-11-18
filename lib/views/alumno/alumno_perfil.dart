import 'package:flutter/material.dart';

import 'package:ufind/app/app_dependencies.dart';
import 'package:ufind/views/widgets/foto_perfil.dart';
import 'editar_perfil.dart';

class AlumnoPerfil extends StatelessWidget {
  const AlumnoPerfil({super.key, required this.dependencias});
  final AppDependencies dependencias;

  Future<void> _salir(BuildContext context) async {
    final salir = await showDialog<bool>(
      context: context,
      builder: (d) => AlertDialog(
        title: const Text('Cerrar sesión'),
        content: const Text('¿Deseas regresar a la pantalla de inicio?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(d, false),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(d, true),
            child: const Text('Salir'),
          ),
        ],
      ),
    );
    if (salir != true || !context.mounted) return;
    dependencias.sesion.salir();
    Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
  }

  Future<void> _editar(BuildContext context) async {
    final guardado = await Navigator.push<bool>(
      context,
      MaterialPageRoute(builder: (_) => EditarPerfilScreen(dependencias: dependencias)),
    );
    if (guardado == true && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Tu perfil se actualizó correctamente.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final scope = dependencias;
    final tema = scope.tema;
    final colores = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(title: const Text('Mi perfil')),
      body: SafeArea(
        child: ListenableBuilder(
          listenable: scope.sesion,
          builder: (context, _) {
            final usuario = scope.sesion.perfil;
            return ListView(
              padding: const EdgeInsets.all(20),
              children: [
                Center(child: FotoPerfil(ruta: scope.sesion.foto, radio: 60)),
                const SizedBox(height: 14),
                Text(
                  scope.sesion.nombre,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                const SizedBox(height: 6),
                Text(
                  scope.sesion.correo ?? 'Sin sesión',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                if (usuario?.carrera.isNotEmpty ?? false) ...[
                  const SizedBox(height: 7),
                  Text(
                    usuario!.carrera,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyLarge
                        ?.copyWith(color: colores.onSurfaceVariant),
                  ),
                ],
                const SizedBox(height: 19),
                FilledButton.icon(
                  onPressed: () => _editar(context),
                  icon: const Icon(Icons.edit_outlined),
                  label: const Text('Editar mis datos y foto'),
                ),
                const SizedBox(height: 15),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: Column(
                      children: [
                        ListTile(
                          leading: const Icon(Icons.person_outline_rounded),
                          title: const Text('Nombre completo'),
                          subtitle: Text(scope.sesion.nombre),
                        ),
                        ListTile(
                          leading: const Icon(Icons.alternate_email_rounded),
                          title: const Text('Correo institucional'),
                          subtitle: Text(scope.sesion.correo ?? '—'),
                        ),
                        ListTile(
                          leading: const Icon(Icons.school_outlined),
                          title: const Text('Carrera'),
                          subtitle: Text(
                            usuario?.carrera.isNotEmpty == true
                                ? usuario!.carrera
                                : 'No especificada',
                          ),
                        ),
                        ListTile(
                          leading: const Icon(Icons.phone_outlined),
                          title: const Text('Teléfono'),
                          subtitle: Text(
                            usuario?.telefono.isNotEmpty == true
                                ? usuario!.telefono
                                : 'No especificado',
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 13),
                Card(
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(17),
                    leading: const Icon(Icons.verified_user_outlined),
                    title: const Text('Datos del perfil'),
                    subtitle: const Text(
                      'Tus datos se guardan en este dispositivo.',
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  'Apariencia',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 8),
                ListenableBuilder(
                  listenable: tema,
                  builder: (context, child) => Card(
                    child: RadioGroup<ThemeMode>(
                      groupValue: tema.modo,
                      onChanged: (valor) {
                        if (valor != null) tema.cambiar(valor);
                      },
                      child: Column(
                        children: const [
                          RadioListTile<ThemeMode>(
                            title: Text('Modo oscuro'),
                            secondary: Icon(Icons.dark_mode_outlined),
                            value: ThemeMode.dark,
                          ),
                          RadioListTile<ThemeMode>(
                            title: Text('Modo claro'),
                            secondary: Icon(Icons.light_mode_outlined),
                            value: ThemeMode.light,
                          ),
                          RadioListTile<ThemeMode>(
                            title: Text('Según el sistema'),
                            secondary: Icon(Icons.settings_brightness_outlined),
                            value: ThemeMode.system,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 23),
                OutlinedButton.icon(
                  onPressed: () => _salir(context),
                  icon: const Icon(Icons.logout_rounded),
                  label: const Text('Cerrar sesión'),
                ),
                const SizedBox(height: 14),
              ],
            );
          },
        ),
      ),
    );
  }
}
