import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:ufind/models/objeto_publicacion.dart';

class MapaBase extends StatelessWidget {
  static const LatLng centroUlima = LatLng(-12.08553, -76.97077);

  final List<ObjetoPublicacion> objetos;
  final LatLng centroInicial;
  final double zoomInicial;
  final LatLng? puntoSeleccionado;
  final void Function(ObjetoPublicacion)? onObjetoTap;
  final void Function(LatLng)? onMapaTap;

  const MapaBase({
    super.key,
    required this.objetos,
    this.centroInicial = centroUlima,
    this.zoomInicial = 17.5,
    this.puntoSeleccionado,
    this.onObjetoTap,
    this.onMapaTap,
  });

  Color _colorMarcador(ObjetoPublicacion objeto) {
    if (objeto.estado == 'Entregado') {
      return Colors.green;
    }

    if (objeto.estado == 'Reclamado') {
      return Colors.amber.shade800;
    }

    return const Color(0xFFF36F21);
  }

  @override
  Widget build(BuildContext context) {
    final List<Marker> marcadores = objetos.map((objeto) {
      return Marker(
        point: LatLng(objeto.latitud, objeto.longitud),
        width: 50,
        height: 50,
        child: IconButton(
          tooltip: objeto.nombre,
          padding: EdgeInsets.zero,
          onPressed: onObjetoTap == null
              ? null
              : () {
                  onObjetoTap!(objeto);
                },
          icon: Icon(
            Icons.location_on,
            color: _colorMarcador(objeto),
            size: 42,
            shadows: const [
              Shadow(
                color: Colors.black54,
                blurRadius: 5,
                offset: Offset(0, 2),
              ),
            ],
          ),
        ),
      );
    }).toList();

    if (puntoSeleccionado != null) {
      marcadores.add(
        Marker(
          point: puntoSeleccionado!,
          width: 52,
          height: 52,
          child: const Icon(
            Icons.add_location_alt,
            color: Colors.blue,
            size: 44,
            shadows: [
              Shadow(
                color: Colors.black54,
                blurRadius: 5,
                offset: Offset(0, 2),
              ),
            ],
          ),
        ),
      );
    }

    return FlutterMap(
      options: MapOptions(
        initialCenter: centroInicial,
        initialZoom: zoomInicial,
        minZoom: 15,
        maxZoom: 19,

        onTap: onMapaTap == null
            ? null
            : (tapPosition, punto) {
                onMapaTap!(punto);
              },
      ),
      children: [
        TileLayer(
          urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
          userAgentPackageName: 'pe.edu.ulima.lostfound',
        ),

        MarkerLayer(markers: marcadores),

        const SimpleAttributionWidget(
          source: Text(
            '© OpenStreetMap contributors',
            style: TextStyle(fontSize: 10, color: Colors.black),
          ),
        ),
      ],
    );
  }
}
