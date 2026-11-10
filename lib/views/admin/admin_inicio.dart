import 'package:flutter/material.dart';
import 'package:ufind/views/admin/formulario_publicacion.dart';
import 'package:ufind/views/admin/gestion_publicaciones.dart';


import 'package:ufind/app/app_dependencies.dart';

import 'package:ufind/views/temporal/proximamente_screen.dart';
import 'package:ufind/viewmodels/publicaciones_viewmodel.dart';

class AdminInicio extends StatelessWidget {
  final PublicacionesViewModel viewModel;
  final AppDependencies dependencias;

  const AdminInicio({super.key, required this.viewModel, required this.dependencias});

  Widget _resumen({
    required String titulo,
    required int cantidad,
    required IconData icono,
    required Color color,
  }) {
    return Expanded(
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Icon(icono, color: color, size: 30),
              const SizedBox(height: 8),
              Text(
                cantidad.toString(),
                style: const TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 3),
              Text(
                titulo,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 15),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _opcion({
    required IconData icono,
    required String titulo,
    required String subtitulo,
    required VoidCallback onTap,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        onTap: onTap,
        contentPadding: const EdgeInsets.all(14),
        leading: CircleAvatar(
          backgroundColor: const Color(0x22F36F21),
          child: Icon(icono, color: const Color(0xFFF36F21)),
        ),
        title: Text(
          titulo,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(subtitulo),
        trailing: const Icon(Icons.chevron_right),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Panel administrativo'),
        actions: [
          IconButton(
            tooltip: 'Cerrar sesión',
            onPressed: () {
              dependencias.sesion.salir();
              Navigator.pushNamedAndRemoveUntil(
                context,
                '/login',
                (route) => false,
              );
            },
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: SafeArea(
        child: ListenableBuilder(
          listenable: viewModel,
          builder: (context, child) {
            return ListView(
              padding: const EdgeInsets.all(18),
              children: [
                const Text(
                  'Resumen de publicaciones',
                  style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 14),
                Row(
                  children: [
                    _resumen(
                      titulo: 'Total',
                      cantidad: viewModel.cantidadPublicaciones,
                      icono: Icons.inventory_2_outlined,
                      color: const Color(0xFFF36F21),
                    ),
                    const SizedBox(width: 10),
                    _resumen(
                      titulo: 'Disponibles',
                      cantidad: viewModel.cantidadDisponibles,
                      icono: Icons.schedule,
                      color: Colors.blue,
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    _resumen(
                      titulo: 'Reclamados',
                      cantidad: viewModel.cantidadReclamados,
                      icono: Icons.person_search_outlined,
                      color: Colors.amber,
                    ),
                    const SizedBox(width: 10),
                    _resumen(
                      titulo: 'Entregados',
                      cantidad: viewModel.cantidadEntregados,
                      icono: Icons.check_circle_outline,
                      color: Colors.green,
                    ),
                  ],
                ),
                const SizedBox(height: 28),
                const Text(
                  'Administración',
                  style: TextStyle(fontSize: 23, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                _opcion(
                  icono: Icons.add_box_outlined,
                  titulo: 'Registrar objeto',
                  subtitulo: 'Crear una publicación y ubicarla en el mapa',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            FormularioPublicacionScreen(viewModel: viewModel),
                      ),
                    );
                  },
                ),
                _opcion(
                  icono: Icons.edit_note,
                  titulo: 'Gestionar publicaciones',
                  subtitulo: 'Buscar, editar, eliminar y cambiar estados',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            GestionPublicacionesScreen(viewModel: viewModel, dependencias: dependencias),
                      ),
                    );
                  },
                ),
                _opcion(
                  icono: Icons.mark_email_unread_outlined,
                  titulo: 'Gestionar solicitudes',
                  subtitulo: 'Revisar y responder solicitudes de los alumnos',
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const ProximamenteScreen(titulo: 'Solicitudes administrativas', descripcion: 'Esta sección estará disponible próximamente.'),
                    ),
                  ),
                ),
                _opcion(
                  icono: Icons.brightness_6_outlined,
                  titulo: 'Cambiar apariencia',
                  subtitulo: 'Alternar entre modo claro y oscuro',
                  onTap: () {
                    final controlador = dependencias.tema;
                    controlador.cambiar(
                      controlador.modo == ThemeMode.dark
                          ? ThemeMode.light
                          : ThemeMode.dark,
                    );
                  },
                ),
                _opcion(
                  icono: Icons.map_outlined,
                  titulo: 'Revisar ubicaciones',
                  subtitulo: 'Visualizar todos los objetos en el campus',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ProximamenteScreen(titulo: 'Mapa del campus', descripcion: 'Aquí podrás consultar las ubicaciones de los objetos.'),
                      ),
                    );
                  },
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
