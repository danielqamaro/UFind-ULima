import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'package:ufind/services/fotos_service.dart';
import 'package:ufind/views/widgets/foto_objeto.dart';

import 'package:latlong2/latlong.dart';
import 'package:ufind/models/objeto_publicacion.dart';
import 'package:ufind/views/admin/seleccionar_ubicacion.dart';
import 'package:ufind/viewmodels/publicaciones_viewmodel.dart';

class FormularioPublicacionScreen extends StatefulWidget {
  final PublicacionesViewModel viewModel;
  final ObjetoPublicacion? objeto;

  const FormularioPublicacionScreen({
    super.key,
    required this.viewModel,
    this.objeto,
  });

  @override
  State<FormularioPublicacionScreen> createState() =>
      _FormularioPublicacionScreenState();
}

class _FormularioPublicacionScreenState
    extends State<FormularioPublicacionScreen> {
  final TextEditingController _nombreController = TextEditingController();
  final TextEditingController _descripcionController = TextEditingController();
  final TextEditingController _fechaController = TextEditingController();
  final TextEditingController _edificioController = TextEditingController();
  final TextEditingController _pisoController = TextEditingController();
  final TextEditingController _referenciaController = TextEditingController();
  String _foto = '';
  bool _cargandoFoto = false;

  final List<String> _categorias = const [
    'Tecnología',
    'Mochilas',
    'Llaves',
    'Documentos',
    'Ropa',
    'Otros',
  ];

  String _categoria = 'Tecnología';
  String _mensajeError = '';
  LatLng? _ubicacionMapa;

  bool get _esEdicion => widget.objeto != null;

  @override
  void initState() {
    super.initState();
    final objeto = widget.objeto;

    if (objeto == null) {
      final hoy = DateTime.now();
      _fechaController.text =
          '${hoy.day.toString().padLeft(2, '0')}/'
          '${hoy.month.toString().padLeft(2, '0')}/${hoy.year}';
    } else {
      _nombreController.text = objeto.nombre;
      _descripcionController.text = objeto.descripcion;
      _fechaController.text = objeto.fecha;
      _edificioController.text = objeto.edificio;
      _pisoController.text = objeto.piso;
      _referenciaController.text = objeto.referencia;
      _foto = objeto.fotografia;
      _categoria = objeto.categoria;
      _ubicacionMapa = LatLng(objeto.latitud, objeto.longitud);
    }
  }

  @override
  void dispose() {
    _nombreController.dispose();
    _descripcionController.dispose();
    _fechaController.dispose();
    _edificioController.dispose();
    _pisoController.dispose();
    _referenciaController.dispose();

    super.dispose();
  }

  void _seleccionarCategoria() {
    showModalBottomSheet(
      context: context,
      builder: (bottomSheetContext) {
        return SafeArea(
          child: ListView(
            shrinkWrap: true,
            children: [
              const Padding(
                padding: EdgeInsets.all(16),
                child: Text(
                  'Selecciona una categoría',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              for (final categoria in _categorias)
                ListTile(
                  leading: const Icon(
                    Icons.category_outlined,
                    color: Color(0xFFF36F21),
                  ),
                  title: Text(categoria),
                  trailing: _categoria == categoria
                      ? const Icon(Icons.check)
                      : null,
                  onTap: () {
                    setState(() {
                      _categoria = categoria;
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

  Future<void> _abrirSelectorMapa() async {
    final resultado = await Navigator.push<LatLng>(
      context,
      MaterialPageRoute(
        builder: (context) => SeleccionarUbicacionScreen(
          viewModel: widget.viewModel,
          ubicacionInicial: _ubicacionMapa,
        ),
      ),
    );

    if (!mounted || resultado == null) {
      return;
    }

    setState(() {
      _ubicacionMapa = resultado;
    });
  }

  Future<void> _elegirFoto(ImageSource origen) async {
    setState(() => _cargandoFoto = true);
    try {
      final ruta = await FotosService().seleccionar(origen);
      if (ruta != null && mounted) setState(() => _foto = ruta);
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('No se pudo obtener la fotografía: $error')),
        );
      }
    } finally {
      if (mounted) setState(() => _cargandoFoto = false);
    }
  }

  Future<void> _elegirFecha() async {
    final hoy = DateTime.now();
    final seleccion = await showDatePicker(
      context: context,
      initialDate: hoy,
      firstDate: DateTime(2020),
      lastDate: DateTime(hoy.year + 1),
    );
    if (seleccion != null && mounted) {
      _fechaController.text =
          '${seleccion.day.toString().padLeft(2, '0')}/'
          '${seleccion.month.toString().padLeft(2, '0')}/${seleccion.year}';
    }
  }

  bool _camposValidos() {
    return _nombreController.text.trim().isNotEmpty &&
        _descripcionController.text.trim().isNotEmpty &&
        _fechaController.text.trim().isNotEmpty &&
        _edificioController.text.trim().isNotEmpty &&
        _pisoController.text.trim().isNotEmpty &&
        _referenciaController.text.trim().isNotEmpty &&
        _ubicacionMapa != null;
  }

  void _guardar() {
    if (!_camposValidos()) {
      setState(() {
        _mensajeError = 'Completa los campos obligatorios y selecciona un punto en el mapa.';
      });
      return;
    }

    setState(() {
      _mensajeError = '';
    });

    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: Text(_esEdicion ? 'Guardar cambios' : 'Registrar publicación'),
          content: Text(
            _esEdicion
                ? '¿Deseas actualizar esta publicación?'
                : '¿Deseas publicar este objeto para los estudiantes?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () {
                final punto = _ubicacionMapa!;

                if (_esEdicion) {
                  widget.viewModel.actualizarPublicacion(
                    objeto: widget.objeto!,
                    nombre: _nombreController.text.trim(),
                    categoria: _categoria,
                    descripcion: _descripcionController.text.trim(),
                    fecha: _fechaController.text.trim(),
                    edificio: _edificioController.text.trim(),
                    piso: _pisoController.text.trim(),
                    referencia: _referenciaController.text.trim(),
                    fotografia: _foto,
                    latitud: punto.latitude,
                    longitud: punto.longitude,
                  );
                } else {
                  widget.viewModel.agregarPublicacion(
                    nombre: _nombreController.text.trim(),
                    categoria: _categoria,
                    descripcion: _descripcionController.text.trim(),
                    fecha: _fechaController.text.trim(),
                    edificio: _edificioController.text.trim(),
                    piso: _pisoController.text.trim(),
                    referencia: _referenciaController.text.trim(),
                    fotografia: _foto,
                    latitud: punto.latitude,
                    longitud: punto.longitude,
                  );
                }

                Navigator.pop(dialogContext);
                Navigator.pop(context);
              },
              child: const Text('Confirmar'),
            ),
          ],
        );
      },
    );
  }

  Widget _etiqueta(String texto) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 7),
      child: Text(texto, style: Theme.of(context).textTheme.titleMedium),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_esEdicion ? 'Editar publicación' : 'Registrar objeto'),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            _etiqueta('Nombre del objeto *'),
            TextField(
              controller: _nombreController,
              decoration: const InputDecoration(
                hintText: 'Ejemplo: Mochila negra',
              ),
            ),
            const SizedBox(height: 18),
            _etiqueta('Categoría *'),
            Card(
              margin: EdgeInsets.zero,
              child: ListTile(
                onTap: _seleccionarCategoria,
                leading: const Icon(
                  Icons.category_outlined,
                  color: Color(0xFFF36F21),
                ),
                title: Text(_categoria),
                trailing: const Icon(Icons.expand_more),
              ),
            ),
            const SizedBox(height: 18),
            _etiqueta('Descripción *'),
            TextField(
              controller: _descripcionController,
              maxLines: 4,
              decoration: const InputDecoration(
                hintText: 'Características que permitan identificarlo',
              ),
            ),
            const SizedBox(height: 18),
            _etiqueta('Fecha *'),
            TextField(
              controller: _fechaController,
              readOnly: true,
              onTap: _elegirFecha,
              decoration: const InputDecoration(
                hintText: 'DD/MM/AAAA',
                prefixIcon: Icon(Icons.calendar_today_outlined),
              ),
            ),
            const SizedBox(height: 18),
            _etiqueta('Edificio *'),
            TextField(
              controller: _edificioController,
              decoration: const InputDecoration(
                hintText: 'Ejemplo: Biblioteca',
              ),
            ),
            const SizedBox(height: 18),
            _etiqueta('Piso o zona *'),
            TextField(
              controller: _pisoController,
              decoration: const InputDecoration(
                hintText: 'Ejemplo: Segundo piso',
              ),
            ),
            const SizedBox(height: 18),
            _etiqueta('Referencia adicional *'),
            TextField(
              controller: _referenciaController,
              decoration: const InputDecoration(
                hintText: 'Ejemplo: Cerca de la sala de lectura',
              ),
            ),
            const SizedBox(height: 18),
            _etiqueta('Fotografía (opcional)'),
            FotoObjeto(ruta: _foto, alto: 220),
            const SizedBox(height: 10),
            Wrap(
              spacing: 10,
              runSpacing: 8,
              children: [
                OutlinedButton.icon(
                  onPressed: _cargandoFoto
                      ? null
                      : () => _elegirFoto(ImageSource.camera),
                  icon: const Icon(Icons.photo_camera_outlined),
                  label: const Text('Tomar foto'),
                ),
                OutlinedButton.icon(
                  onPressed: _cargandoFoto
                      ? null
                      : () => _elegirFoto(ImageSource.gallery),
                  icon: const Icon(Icons.photo_library_outlined),
                  label: const Text('Galería'),
                ),
              ],
            ),
            if (_cargandoFoto) const LinearProgressIndicator(),
            const SizedBox(height: 8),
            Text(
              'La foto se conserva en el almacenamiento privado de la aplicación.',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 18),
            _etiqueta('Punto en el mapa *'),
            Card(
              margin: EdgeInsets.zero,
              child: ListTile(
                onTap: _abrirSelectorMapa,
                leading: const Icon(
                  Icons.add_location_alt_outlined,
                  color: Color(0xFFF36F21),
                ),
                title: Text(
                  _ubicacionMapa == null
                      ? 'Seleccionar ubicación'
                      : 'Ubicación seleccionada',
                ),
                subtitle: _ubicacionMapa == null
                    ? const Text('Toca para abrir el mapa del campus')
                    : Text(
                        '${_ubicacionMapa!.latitude.toStringAsFixed(6)}, '
                        '${_ubicacionMapa!.longitude.toStringAsFixed(6)}',
                      ),
                trailing: const Icon(Icons.chevron_right),
              ),
            ),
            if (_mensajeError.isNotEmpty) ...[
              const SizedBox(height: 14),
              Text(
                _mensajeError,
                style: const TextStyle(color: Color(0xFFFF6B6B)),
              ),
            ],
            const SizedBox(height: 24),
            SizedBox(
              height: 56,
              child: ElevatedButton(
                onPressed: _cargandoFoto ? null : _guardar,
                child: Text(
                  _esEdicion ? 'Guardar cambios' : 'Crear publicación',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
