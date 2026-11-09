import 'package:flutter/material.dart';
import 'package:ufind/app/app_dependencies.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:ufind/views/alumno/detalle_objeto.dart';
import 'package:ufind/views/widgets/categoria_item.dart';
import 'package:ufind/views/widgets/objeto_card.dart';
import 'package:ufind/viewmodels/publicaciones_viewmodel.dart';

class ListaObjetosScreen extends StatefulWidget {
  final PublicacionesViewModel viewModel;
  final AppDependencies dependencias;

  const ListaObjetosScreen({super.key, required this.viewModel, required this.dependencias});

  @override
  State<ListaObjetosScreen> createState() => _ListaObjetosScreenState();
}

class _ListaObjetosScreenState extends State<ListaObjetosScreen> {
  final TextEditingController _busquedaController = TextEditingController();
  String _categoriaSeleccionada = 'Todas';
  DateTimeRange? _rangoFechas;

  final List<String> _categorias = const [
    'Todas',
    'Tecnología',
    'Mochilas',
    'Llaves',
    'Documentos',
    'Ropa',
    'Otros',
  ];

  @override
  void dispose() {
    _busquedaController.dispose();
    super.dispose();
  }

  String _formatoFecha(DateTime fecha) =>
      '${fecha.day.toString().padLeft(2, '0')}/'
      '${fecha.month.toString().padLeft(2, '0')}/${fecha.year}';

  String get _textoFechas {
    final rango = _rangoFechas!;
    return rango.start == rango.end
        ? 'Fecha: ${_formatoFecha(rango.start)}'
        : '${_formatoFecha(rango.start)} – ${_formatoFecha(rango.end)}';
  }

  Widget _calendarioEnEspanol(BuildContext context, Widget? child) =>
      Localizations.override(
        context: context,
        locale: const Locale('es'),
        delegates: GlobalMaterialLocalizations.delegates,
        child: child!,
      );

  Future<void> _filtrarPorFecha() async {
    FocusScope.of(context).unfocus();
    final opcion = await showModalBottomSheet<String>(
      context: context,
      showDragHandle: true,
      builder: (hoja) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 12),
              child: Text(
                'Filtrar por fecha',
                style: Theme.of(hoja).textTheme.titleLarge,
              ),
            ),
            ListTile(
              leading: const Icon(Icons.event_outlined),
              title: const Text('Una fecha'),
              onTap: () => Navigator.pop(hoja, 'dia'),
            ),
            ListTile(
              leading: const Icon(Icons.date_range_outlined),
              title: const Text('Rango de fechas'),
              onTap: () => Navigator.pop(hoja, 'rango'),
            ),
            if (_rangoFechas != null)
              ListTile(
                leading: const Icon(Icons.filter_alt_off_outlined),
                title: const Text('Quitar filtro de fecha'),
                onTap: () => Navigator.pop(hoja, 'quitar'),
              ),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
    if (!mounted || opcion == null) return;
    if (opcion == 'quitar') {
      setState(() => _rangoFechas = null);
      return;
    }

    DateTimeRange? seleccion;
    if (opcion == 'dia') {
      final fecha = await _seleccionarDia(
        titulo: 'Selecciona una fecha',
        inicial: _rangoFechas?.start,
      );
      if (fecha != null) {
        seleccion = DateTimeRange(start: fecha, end: fecha);
      }
    } else {
      final desde = await _seleccionarDia(
        titulo: 'Desde: fecha inicial',
        inicial: _rangoFechas?.start,
      );
      if (!mounted || desde == null) return;
      final finAnterior = _rangoFechas?.end;
      final hasta = await _seleccionarDia(
        titulo: 'Hasta: fecha final',
        inicial: finAnterior != null && !finAnterior.isBefore(desde)
            ? finAnterior
            : desde,
        primera: desde,
      );
      if (hasta != null) {
        seleccion = DateTimeRange(start: desde, end: hasta);
      }
    }
    if (!mounted || seleccion == null) return;
    setState(() => _rangoFechas = seleccion);
  }

  Future<DateTime?> _seleccionarDia({
    required String titulo,
    DateTime? inicial,
    DateTime? primera,
  }) => showDatePicker(
    context: context,
    initialDate: inicial ?? DateTime.now(),
    firstDate: primera ?? DateTime(1900),
    lastDate: DateTime(2100, 12, 31),
    helpText: titulo,
    cancelText: 'Cancelar',
    confirmText: 'Aplicar',
    fieldLabelText: 'Fecha',
    fieldHintText: 'dd/mm/aaaa',
    errorFormatText: 'Usa el formato dd/mm/aaaa',
    errorInvalidText: primera == null
        ? 'Selecciona una fecha válida'
        : 'Elige una fecha igual o posterior al inicio',
    builder: _calendarioEnEspanol,
  );

  IconData _iconoCategoria(String categoria) {
    if (categoria == 'Tecnología') {
      return Icons.devices;
    }
    if (categoria == 'Mochilas') {
      return Icons.backpack_outlined;
    }
    if (categoria == 'Llaves') {
      return Icons.key;
    }
    if (categoria == 'Documentos') {
      return Icons.badge_outlined;
    }
    if (categoria == 'Ropa') {
      return Icons.checkroom;
    }
    if (categoria == 'Otros') {
      return Icons.inventory_2_outlined;
    }
    return Icons.apps;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Objetos encontrados'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: IconButton.filledTonal(
              tooltip: 'Filtrar por fecha',
              isSelected: _rangoFechas != null,
              icon: const Icon(Icons.date_range_outlined),
              selectedIcon: const Icon(Icons.event_available_rounded),
              onPressed: _filtrarPorFecha,
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
          child: Column(
            children: [
              TextField(
                controller: _busquedaController,
                onChanged: (valor) {
                  setState(() {});
                },
                decoration: InputDecoration(
                  hintText: 'Buscar por nombre',
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
              if (_rangoFechas != null)
                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: Material(
                    color: Theme.of(context).colorScheme.primaryContainer,
                    borderRadius: BorderRadius.circular(16),
                    child: Row(
                      children: [
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 12),
                          child: Icon(Icons.date_range_outlined, size: 22),
                        ),
                        Expanded(
                          child: Text(
                            _textoFechas,
                            style: Theme.of(context).textTheme.bodyMedium
                                ?.copyWith(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onPrimaryContainer,
                                  fontWeight: FontWeight.w800,
                                ),
                          ),
                        ),
                        IconButton(
                          tooltip: 'Quitar filtro de fecha',
                          onPressed: () => setState(() => _rangoFechas = null),
                          icon: const Icon(Icons.close_rounded),
                        ),
                      ],
                    ),
                  ),
                ),
              const SizedBox(height: 12),
              SizedBox(
                height: 78,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: _categorias.length,
                  itemBuilder: (context, index) {
                    final categoria = _categorias[index];
                    return CategoriaItem(
                      icono: _iconoCategoria(categoria),
                      nombre: categoria,
                      seleccionado: _categoriaSeleccionada == categoria,
                      onTap: () {
                        setState(() {
                          _categoriaSeleccionada = categoria;
                        });
                      },
                    );
                  },
                ),
              ),
              const SizedBox(height: 12),
              Expanded(
                child: ListenableBuilder(
                  listenable: widget.viewModel,
                  builder: (context, child) {
                    final objetos = widget.viewModel.filtrarPublicaciones(
                      busqueda: _busquedaController.text,
                      categoria: _categoriaSeleccionada,
                      fechaDesde: _rangoFechas?.start,
                      fechaHasta: _rangoFechas?.end,
                    );

                    if (objetos.isEmpty) {
                      return Center(
                        child: Text(
                          _rangoFechas == null
                              ? 'No se encontraron publicaciones.'
                              : 'No hay objetos que coincidan con las fechas y filtros seleccionados.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Theme.of(context)
                                .colorScheme
                                .onSurfaceVariant,
                          ),
                        ),
                      );
                    }

                    return ListView.builder(
                      itemCount: objetos.length,
                      itemBuilder: (context, index) {
                        final objeto = objetos[index];
                        return ObjetoCard(
                          objeto: objeto,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    DetalleObjetoScreen(objeto: objeto, dependencias: widget.dependencias),
                              ),
                            );
                          },
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
