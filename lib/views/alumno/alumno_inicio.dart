import 'package:flutter/material.dart';
import 'package:ufind/app/app_dependencies.dart';

import 'package:ufind/views/alumno/alumno_home.dart';
import 'package:ufind/views/temporal/proximamente_screen.dart';
import 'package:ufind/views/alumno/alumno_perfil.dart';
import 'package:ufind/views/alumno/alumno_solicitudes.dart';
import 'package:ufind/views/alumno/lista_objetos.dart';
import 'package:ufind/viewmodels/publicaciones_viewmodel.dart';

class AlumnoInicio extends StatefulWidget {
  final PublicacionesViewModel viewModel;
  final AppDependencies dependencias;
  const AlumnoInicio({
    super.key,
    required this.viewModel,
    required this.dependencias,
  });
  @override
  State<AlumnoInicio> createState() => _AlumnoInicioState();
}

class _AlumnoInicioState extends State<AlumnoInicio> {
  int _indice = 0;
  void _irA(int i) => setState(() => _indice = i);

  @override
  Widget build(BuildContext context) {
    final paginas = [
      AlumnoHome(
        viewModel: widget.viewModel,
        cambiarPagina: _irA,
        dependencias: widget.dependencias,
      ),
      ListaObjetosScreen(
        viewModel: widget.viewModel,
        dependencias: widget.dependencias,
      ),
      const ProximamenteScreen(
        titulo: 'Mapa del campus',
        descripcion:
            'Próximamente podrás consultar las ubicaciones del campus.',
      ),
      AlumnoSolicitudes(dependencias: widget.dependencias),
      AlumnoPerfil(dependencias: widget.dependencias),
    ];
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          IndexedStack(index: _indice, children: paginas),
          Positioned(
            left: 0,
            right: 0,
            bottom: 2,
            child: IgnorePointer(
              child: Row(
                children: [
                  const Spacer(flex: 4),
                  Expanded(
                    child: Image.asset(
                      'gif/ulises-animado.gif',
                      height: 82,
                      fit: BoxFit.contain,
                      excludeFromSemantics: true,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
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
