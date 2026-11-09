import 'package:flutter/material.dart';
import 'package:ufind/models/objeto_publicacion.dart';
import 'package:ufind/views/temporal/proximamente_screen.dart';

class MapaDetalleScreen extends StatelessWidget {
  const MapaDetalleScreen({super.key, required this.objeto});
  final ObjetoPublicacion objeto;

  @override
  Widget build(BuildContext context) => ProximamenteScreen(
    titulo: 'Ubicación: ${objeto.nombre}',
    descripcion: 'Próximamente podrás ver la ubicación de este objeto en el mapa.',
  );
}
