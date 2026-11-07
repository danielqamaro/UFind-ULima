import 'package:flutter/material.dart';

import 'app.dart';
import 'app/app_dependencies.dart';

export 'app.dart' show LostFoundApp;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final dependencias = await AppDependencies.cargar();
  runApp(UFindRoot(dependencias: dependencias));
}
