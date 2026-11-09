import 'package:flutter/material.dart';

import 'package:ufind/app/app_dependencies.dart';
import 'package:ufind/models/objeto_publicacion.dart';
import 'package:ufind/views/widgets/foto_objeto.dart';
import 'package:ufind/views/widgets/etiqueta_estado.dart';
import 'mapa_detalle.dart';

class DetalleObjetoScreen extends StatelessWidget {
  final ObjetoPublicacion objeto;
  final AppDependencies dependencias;
  const DetalleObjetoScreen({super.key, required this.objeto, required this.dependencias});

  Future<void> _solicitar(BuildContext context) async {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Próximamente podrás solicitar la recuperación de este objeto.')),
    );
  }

  Widget _dato(
    BuildContext context,
    IconData icono,
    String titulo,
    String valor,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icono, color: Theme.of(context).colorScheme.primary, size: 26),
          const SizedBox(width: 13),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  titulo,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 3),
                Text(valor, style: Theme.of(context).textTheme.titleMedium),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Detalle del objeto')),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(18),
          children: [
            FotoObjeto(ruta: objeto.fotografia, alto: 290),
            const SizedBox(height: 18),
            Wrap(
              spacing: 10,
              runSpacing: 8,
              children: [
                Chip(
                  avatar: const Icon(Icons.category_outlined, size: 20),
                  label: Text(objeto.categoria),
                ),
                EtiquetaEstado(estado: objeto.estado),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              objeto.nombre,
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 14),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(17),
                child: Column(
                  children: [
                    _dato(
                      context,
                      Icons.description_outlined,
                      'Descripción',
                      objeto.descripcion,
                    ),
                    _dato(
                      context,
                      Icons.calendar_today_outlined,
                      'Fecha',
                      objeto.fecha,
                    ),
                    _dato(
                      context,
                      Icons.location_on_outlined,
                      'Edificio',
                      objeto.edificio,
                    ),
                    _dato(context, Icons.layers_outlined, 'Zona', objeto.piso),
                    _dato(
                      context,
                      Icons.near_me_outlined,
                      'Referencia',
                      objeto.referencia,
                    ),
                    _dato(
                      context,
                      Icons.person_outline,
                      'Publicado por',
                      objeto.usuario,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 15),
            FilledButton.icon(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => MapaDetalleScreen(objeto: objeto),
                ),
              ),
              icon: const Icon(Icons.map_outlined),
              label: const Text('Ver ubicación en el mapa'),
            ),
            const SizedBox(height: 12),
            OutlinedButton.icon(
              onPressed: () => showDialog<void>(
                context: context,
                builder: (d) => AlertDialog(
                  title: const Text('Oficina de objetos perdidos'),
                  content: Text(
                    'Contacto: ${objeto.contacto}\n\nDeberás acreditar la propiedad antes de recogerlo.',
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(d),
                      child: const Text('Entendido'),
                    ),
                  ],
                ),
              ),
              icon: const Icon(Icons.mail_outline),
              label: const Text('Contactar a Administración'),
            ),
            const SizedBox(height: 12),
            if (objeto.estado == 'Disponible')
              FilledButton.tonalIcon(
                onPressed: () => _solicitar(context),
                icon: const Icon(Icons.assignment_turned_in_outlined),
                label: const Text('Solicitar recuperación'),
              )
            else
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(15),
                  child: Text(
                    'Este objeto no está disponible para nuevas solicitudes.',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ),
              ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
