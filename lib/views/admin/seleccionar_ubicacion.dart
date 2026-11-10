import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:ufind/views/widgets/mapa_base.dart';
import 'package:ufind/viewmodels/publicaciones_viewmodel.dart';

class SeleccionarUbicacionScreen extends StatefulWidget {
  final PublicacionesViewModel viewModel;
  final LatLng? ubicacionInicial;

  const SeleccionarUbicacionScreen({
    super.key,
    required this.viewModel,
    this.ubicacionInicial,
  });

  @override
  State<SeleccionarUbicacionScreen> createState() =>
      _SeleccionarUbicacionScreenState();
}

class _SeleccionarUbicacionScreenState
    extends State<SeleccionarUbicacionScreen> {
  LatLng? _ubicacionSeleccionada;

  @override
  void initState() {
    super.initState();
    _ubicacionSeleccionada = widget.ubicacionInicial;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Seleccionar ubicación')),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            color: const Color(0xFF202328),
            child: const Text(
              'Toca un punto del mapa para indicar dónde se encontró el objeto.',
              textAlign: TextAlign.center,
            ),
          ),
          Expanded(
            child: MapaBase(
              objetos: widget.viewModel.obtenerPublicaciones(),
              centroInicial: widget.ubicacionInicial ?? MapaBase.centroUlima,
              puntoSeleccionado: _ubicacionSeleccionada,
              onMapaTap: (punto) {
                setState(() {
                  _ubicacionSeleccionada = punto;
                });
              },
            ),
          ),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(14),
            color: const Color(0xFF1C1F24),
            child: ElevatedButton.icon(
              onPressed: _ubicacionSeleccionada == null
                  ? null
                  : () => Navigator.pop(context, _ubicacionSeleccionada),
              icon: const Icon(Icons.check),
              label: const Text('Confirmar ubicación'),
            ),
          ),
        ],
      ),
    );
  }
}
