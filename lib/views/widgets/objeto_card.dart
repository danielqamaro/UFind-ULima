import 'package:flutter/material.dart';

import 'package:ufind/models/objeto_publicacion.dart';
import 'foto_objeto.dart';
import 'etiqueta_estado.dart';

class ObjetoCard extends StatelessWidget {
  final ObjetoPublicacion objeto;
  final VoidCallback onTap;
  const ObjetoCard({super.key, required this.objeto, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).colorScheme;
    final oscuro = Theme.of(context).brightness == Brightness.dark;
    return Card(
      margin: const EdgeInsets.only(bottom: 17),
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(23),
        side: BorderSide(
          width: 1.5,
          color: oscuro ? const Color(0xFF4A5869) : const Color(0xFFADB8C7),
        ),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(23),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(22),
              ),
              child: FotoObjeto(ruta: objeto.fotografia, alto: 225),
            ),
            Padding(
              padding: const EdgeInsets.all(18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Wrap(
                    spacing: 8,
                    runSpacing: 6,
                    children: [
                      Chip(
                        label: Text(objeto.categoria),
                        backgroundColor: oscuro
                            ? const Color(0xFF422B20)
                            : const Color(0xFFFFF0E5),
                        side: BorderSide(
                          color: oscuro
                              ? const Color(0xFF8F4C25)
                              : const Color(0xFFF5BD91),
                        ),
                        labelStyle: Theme.of(context).textTheme.labelLarge
                            ?.copyWith(
                              fontSize: 15,
                              fontWeight: FontWeight.w800,
                              color: oscuro
                                  ? const Color(0xFFFFBE8C)
                                  : const Color(0xFF963F0C),
                            ),
                      ),
                      EtiquetaEstado(estado: objeto.estado),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(
                    objeto.nombre,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontSize: 25,
                      fontWeight: FontWeight.w900,
                      color: c.onSurface,
                    ),
                  ),
                  const SizedBox(height: 9),
                  Text(
                    objeto.descripcion,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  const SizedBox(height: 13),
                  Row(
                    children: [
                      Icon(Icons.location_on_outlined, color: c.primary),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          objeto.ubicacion,
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 7),
                  Row(
                    children: [
                      Icon(Icons.calendar_month_outlined, color: c.primary),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          objeto.fecha,
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 15),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton.icon(
                      onPressed: onTap,
                      style: FilledButton.styleFrom(
                        backgroundColor: oscuro
                            ? const Color(0xFFFFB26F)
                            : const Color(0xFF20243B),
                        foregroundColor: oscuro
                            ? const Color(0xFF281A10)
                            : Colors.white,
                        minimumSize: const Size(double.infinity, 56),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 18,
                          vertical: 14,
                        ),
                        textStyle: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(
                              fontSize: 20,
                              fontWeight: FontWeight.w900,
                            ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(17),
                        ),
                      ),
                      icon: const Icon(Icons.arrow_forward_rounded, size: 23),
                      label: const Text('Ver detalle'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
