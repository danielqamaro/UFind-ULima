import 'package:flutter/material.dart';
import 'package:ufind/app/app_dependencies.dart';

import 'package:ufind/views/alumno/alumno_home.dart';
import 'package:ufind/views/temporal/proximamente_screen.dart';


import 'package:ufind/views/alumno/lista_objetos.dart';
import 'package:ufind/viewmodels/publicaciones_viewmodel.dart';

class AlumnoInicio extends StatefulWidget {
  final PublicacionesViewModel viewModel;
  final AppDependencies dependencias;
  const AlumnoInicio({super.key, required this.viewModel, required this.dependencias});
  @override
  State<AlumnoInicio> createState() => _AlumnoInicioState();
}

class _AlumnoInicioState extends State<AlumnoInicio> {
  int _indice = 0;
  void _irA(int i) => setState(() => _indice = i);

  @override
  Widget build(BuildContext context) {
    final paginas = [
      AlumnoHome(viewModel: widget.viewModel, cambiarPagina: _irA, dependencias: widget.dependencias),
      ListaObjetosScreen(viewModel: widget.viewModel, dependencias: widget.dependencias),
      const ProximamenteScreen(titulo: 'Mapa del campus', descripcion: 'Próximamente podrás consultar las ubicaciones del campus.'),
      const ProximamenteScreen(titulo: 'Mis solicitudes', descripcion: 'Aquí podrás revisar tus solicitudes de recuperación.'),
      const ProximamenteScreen(titulo: 'Mi perfil', descripcion: 'Aquí podrás consultar y editar tu perfil.'),
    ];
    return Scaffold(
      body: IndexedStack(index: _indice, children: paginas),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _indice,
        onDestinationSelected: _irA,
        labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home_rounded),
            label: 'Inicio',
          ),
          NavigationDestination(
            icon: Icon(Icons.search_rounded),
            label: 'Objetos',
          ),
          NavigationDestination(icon: Icon(Icons.map_outlined), label: 'Mapa'),
          NavigationDestination(
            icon: Icon(Icons.mark_email_unread_outlined),
            selectedIcon: Icon(Icons.mark_email_read_rounded),
            label: 'Solicitudes',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline_rounded),
            label: 'Perfil',
          ),
        ],
      ),
    );
  }
}
