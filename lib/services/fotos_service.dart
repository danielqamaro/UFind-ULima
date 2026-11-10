import 'dart:io';

import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

class FotosService {
  FotosService({ImagePicker? picker, Future<Directory> Function()? documentos})
    : _picker = picker ?? ImagePicker(),
      _documentos = documentos ?? getApplicationDocumentsDirectory;
  final ImagePicker _picker;
  final Future<Directory> Function() _documentos;

  Future<String?> seleccionar(ImageSource origen, {bool perfil = false}) async {
    final seleccion = await _picker.pickImage(
      source: origen,
      imageQuality: perfil ? 78 : 76,
      maxWidth: perfil ? 1000 : 1600,
    );
    if (seleccion == null) return null;
    return conservar(seleccion, perfil: perfil);
  }

  Future<String> conservar(XFile imagen, {bool perfil = false}) async {
    final documentos = await _documentos();
    final carpeta = Directory(
      '${documentos.path}/${perfil ? 'ufind_perfiles' : 'ufind_fotos'}',
    );
    await carpeta.create(recursive: true);
    final extension =
        RegExp(r'\.(jpe?g|png|webp|heic|heif)$')
            .firstMatch(imagen.name.toLowerCase())
            ?.group(1) ??
        'jpg';
    final nombre = perfil ? 'perfil' : 'foto';
    final destino =
        '${carpeta.path}/${nombre}_${DateTime.now().microsecondsSinceEpoch}.$extension';
    await File(imagen.path).copy(destino);
    return 'file:$destino';
  }
}
