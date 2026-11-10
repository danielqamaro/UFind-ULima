import 'package:flutter/material.dart';
import 'package:ufind/app/app_dependencies.dart';
import 'package:ufind/models/objeto_publicacion.dart';
import 'package:ufind/views/admin/formulario_publicacion.dart';
import 'package:ufind/views/alumno/detalle_objeto.dart';
import 'package:ufind/viewmodels/publicaciones_viewmodel.dart';

class GestionPublicacionesScreen extends StatefulWidget {
  final PublicacionesViewModel viewModel;
  final AppDependencies dependencias;

  const GestionPublicacionesScreen({super.key, required this.viewModel, required this.dependencias});

  @override
  State<GestionPublicacionesScreen> createState() =>
      _GestionPublicacionesScreenState();
}

class _GestionPublicacionesScreenState
    extends State<GestionPublicacionesScreen> {
  final TextEditingController _busquedaController = TextEditingController();
  final List<String> _estados = const [
    'Todos',
    'Disponible',
    'Reclamado',
    'Entregado',
  ];

  String _estadoSeleccionado = 'Todos';

  @override
  void dispose() {
    _busquedaController.dispose();
    super.dispose();
  }

  Color _colorEstado(String estado) {
    if (estado == 'Entregado') {
      return Colors.green;
    }
    if (estado == 'Reclamado') {
      return Colors.amber;
    }
    return const Color(0xFFF36F21);
  }

  void _seleccionarFiltro() {
    showModalBottomSheet(
      context: context,
      builder: (bottomSheetContext) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Padding(
                padding: EdgeInsets.all(16),
                child: Text(
                  'Filtrar por estado',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              for (final estado in _estados)
                ListTile(
                  title: Text(estado),
                  trailing: _estadoSeleccionado == estado
                      ? const Icon(Icons.check)
                      : null,
                  onTap: () {
                    setState(() {
                      _estadoSeleccionado = estado;
                    });
                    Navigator.pop(bottomSheetContext);
                  },
                ),
            ],
          ),
        );
      },
    );
  }

  void _confirmarEliminacion(ObjetoPublicacion objeto) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Eliminar publicación'),
          content: Text('¿Deseas eliminar definitivamente “${objeto.nombre}”?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                widget.viewModel.eliminarPublicacion(objeto.id);
                Navigator.pop(dialogContext);
              },
              child: const Text(
                'Eliminar',
                style: TextStyle(color: Color(0xFFFF6B6B)),
              ),
            ),
          ],
        );
      },
    );
  }

  void _confirmarEstado(ObjetoPublicacion objeto, String nuevoEstado) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Cambiar estado'),
          content: Text(
            '¿Deseas cambiar “${objeto.nombre}” de '
            '${objeto.estado} a $nuevoEstado?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () {
                widget.viewModel.cambiarEstado(objeto.id, nuevoEstado);
                Navigator.pop(dialogContext);
              },
              child: const Text('Confirmar'),
            ),
          ],
        );
      },
    );
  }

  void _seleccionarEstado(ObjetoPublicacion objeto) {
    const estados = ['Disponible', 'Reclamado', 'Entregado'];

    showModalBottomSheet(
      context: context,
      builder: (bottomSheetContext) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Padding(
                padding: EdgeInsets.all(16),
                child: Text(
                  'Nuevo estado',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              for (final estado in estados)
                ListTile(
                  leading: Icon(
                    Icons.circle,
                    color: _colorEstado(estado),
                    size: 16,
                  ),
                  title: Text(estado),
                  trailing: objeto.estado == estado
                      ? const Icon(Icons.check)
                      : null,
                  onTap: objeto.estado == estado
                      ? null
                      : () {
                          Navigator.pop(bottomSheetContext);
                          _confirmarEstado(objeto, estado);
                        },
                ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Gestión de publicaciones')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
          child: Column(
            children: [
              TextField(
                controller: _busquedaController,
                onChanged: (valor) => setState(() {}),
                decoration: InputDecoration(
                  hintText: 'Buscar por objeto o edificio',
                  prefixIcon: const Icon(Icons.search),
                  suffixIcon: _busquedaController.text.isEmpty
                      ? null
                      : IconButton(
                          onPressed: () {
                            _busquedaController.clear();
                            setState(() {});
                          },
                          icon: const Icon(Icons.close),
                        ),
                ),
              ),
              const SizedBox(height: 10),
              Card(
                margin: EdgeInsets.zero,
                child: ListTile(
                  onTap: _seleccionarFiltro,
                  leading: const Icon(
                    Icons.filter_list,
                    color: Color(0xFFF36F21),
                  ),
                  title: const Text('Estado'),
                  subtitle: Text(_estadoSeleccionado),
                  trailing: const Icon(Icons.expand_more),
                ),
              ),
              const SizedBox(height: 12),
              Expanded(
                child: ListenableBuilder(
                  listenable: widget.viewModel,
                  builder: (context, child) {
                    final publicaciones = widget.viewModel
                        .filtrarAdministracion(
                          busqueda: _busquedaController.text,
                          estado: _estadoSeleccionado,
                        );

                    if (publicaciones.isEmpty) {
                      return const Center(
                        child: Text('No hay publicaciones para este filtro.'),
                      );
                    }

                    return ListView.builder(
                      itemCount: publicaciones.length,
                      itemBuilder: (context, index) {
                        final objeto = publicaciones[index];

                        return Card(
                          margin: const EdgeInsets.only(bottom: 12),
                          child: Padding(
                            padding: const EdgeInsets.all(14),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        objeto.nombre,
                                        style: const TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    Text(
                                      objeto.estado,
                                      style: TextStyle(
                                        color: _colorEstado(objeto.estado),
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  '${objeto.categoria} • ${objeto.edificio}',
                                  style: Theme.of(context).textTheme.bodyLarge,
                                ),
                                const SizedBox(height: 12),
                                Row(
                                  children: [
                                    Expanded(
                                      child: TextButton.icon(
                                        onPressed: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  FormularioPublicacionScreen(
                                                    viewModel: widget.viewModel,
                                                    objeto: objeto,
                                                  ),
                                            ),
                                          );
                                        },
                                        icon: const Icon(Icons.edit_outlined),
                                        label: const Text('Editar'),
                                      ),
                                    ),
                                    Expanded(
                                      child: TextButton.icon(
                                        onPressed: () =>
                                            _seleccionarEstado(objeto),
                                        icon: const Icon(Icons.swap_horiz),
                                        label: const Text('Estado'),
                                      ),
                                    ),
                                    IconButton(
                                      tooltip: 'Ver detalle',
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                DetalleObjetoScreen(
                                                  objeto: objeto,
                                                  dependencias: widget.dependencias,
                                                ),
                                          ),
                                        );
                                      },
                                      icon: const Icon(
                                        Icons.visibility_outlined,
                                      ),
                                    ),
                                    IconButton(
                                      tooltip: 'Eliminar',
                                      onPressed: () =>
                                          _confirmarEliminacion(objeto),
                                      icon: const Icon(
                                        Icons.delete_outline,
                                        color: Color(0xFFFF6B6B),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
