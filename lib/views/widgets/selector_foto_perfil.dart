import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'package:ufind/services/fotos_service.dart';

/// Copia una fotografía a la carpeta privada de la aplicación.
/// Al guardarse el perfil se conserva la ruta `file:` (solo dispositivo actual).
Future<String?> seleccionarFotoPerfil(BuildContext context) async {
  final fuente = await showModalBottomSheet<ImageSource>(
    context: context,
    showDragHandle: true,
    builder: (hoja) => SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(14, 4, 14, 18),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Foto de perfil', style: Theme.of(hoja).textTheme.titleLarge),
            const SizedBox(height: 12),
            ListTile(
              leading: const Icon(Icons.camera_alt_outlined, size: 29),
              title: const Text('Tomar una foto'),
              onTap: () => Navigator.pop(hoja, ImageSource.camera),
            ),
            ListTile(
              leading: const Icon(Icons.photo_library_outlined, size: 29),
              title: const Text('Seleccionar de galería'),
              onTap: () => Navigator.pop(hoja, ImageSource.gallery),
            ),
          ],
        ),
      ),
    ),
  );
  if (fuente == null) return null;
  return FotosService().seleccionar(fuente, perfil: true);
}
