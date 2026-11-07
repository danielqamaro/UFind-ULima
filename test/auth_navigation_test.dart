import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ufind/app/app_dependencies.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ufind/views/auth/bienvenida.dart';
import 'package:ufind/views/auth/login.dart';
import 'package:ufind/views/auth/registro.dart';

Future<Widget> crearAppAuth({
  bool oscuro = false,
  String ruta = '/bienvenida',
}) async {
  SharedPreferences.setMockInitialValues({
    'ufind_modo_tema': oscuro ? 'dark' : 'light',
  });
  final d = await AppDependencies.cargar();
  final tema = d.tema;
  ThemeData estilo(Brightness brillo) {
    final base = ThemeData(
      useMaterial3: true,
      brightness: brillo,
      colorScheme: ColorScheme.fromSeed(
        seedColor: const Color(0xFFF36F21),
        primary: const Color(0xFFF36F21),
        brightness: brillo,
        surface: brillo == Brightness.light
            ? Colors.white
            : const Color(0xFF1C222A),
      ),
    );
    final textos = base.textTheme;
    return base.copyWith(
      textTheme: textos.copyWith(
        headlineMedium: textos.headlineMedium?.copyWith(
          fontSize: 30,
          fontWeight: FontWeight.w900,
        ),
        titleLarge: textos.titleLarge?.copyWith(
          fontSize: 23,
          fontWeight: FontWeight.w900,
        ),
        titleMedium: textos.titleMedium?.copyWith(
          fontSize: 19,
          fontWeight: FontWeight.w800,
        ),
        bodyLarge: textos.bodyLarge?.copyWith(
          fontSize: 17,
          fontWeight: FontWeight.w600,
        ),
        bodyMedium: textos.bodyMedium?.copyWith(
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
      inputDecorationTheme: const InputDecorationTheme(filled: true),
    );
  }

  return ListenableBuilder(
    listenable: tema,
    builder: (context, _) => MaterialApp(
      debugShowCheckedModeBanner: false,
      themeMode: tema.modo,
      theme: estilo(Brightness.light),
      darkTheme: estilo(Brightness.dark),
      initialRoute: ruta,
      routes: {
        '/bienvenida': (_) => const BienvenidaScreen(),
        '/login': (_) => LoginScreen(dependencias: d),
        '/registro': (_) => RegistroScreen(dependencias: d),
        '/inicio': (_) => const Scaffold(body: Text('Sesión iniciada')),
        '/admin': (_) => const Scaffold(body: Text('Panel administrador')),
      },
    ),
  );
}

void configurarPantalla(WidgetTester tester, Size size) {
  tester.view.devicePixelRatio = 1;
  tester.view.physicalSize = size;
  tester.view.padding = const FakeViewPadding(top: 24, bottom: 20);
  addTearDown(tester.view.reset);
}

void main() {
  testWidgets('La bienvenida abre login y permite volver o crear cuenta', (
    tester,
  ) async {
    configurarPantalla(tester, const Size(390, 844));
    await tester.pumpWidget(await crearAppAuth());
    await tester.pumpAndSettle();
    expect(find.byType(BienvenidaScreen), findsOneWidget);
    await tester.tap(find.text('Ingresar'));
    await tester.pumpAndSettle();
    expect(find.byType(LoginScreen), findsOneWidget);
    await tester.tap(find.byTooltip('Volver a la bienvenida'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Crear una cuenta'));
    await tester.pumpAndSettle();
    expect(find.byType(RegistroScreen), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('Login valida datos y entra sin regresar a bienvenida', (
    tester,
  ) async {
    configurarPantalla(tester, const Size(390, 844));
    await tester.pumpWidget(await crearAppAuth());
    await tester.pumpAndSettle();
    await tester.tap(find.text('Ingresar'));
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.text('Ingresar'));
    await tester.tap(find.text('Ingresar'));
    await tester.pumpAndSettle();
    expect(find.text('Ingresa un correo @aloe.ulima.edu.pe'), findsOneWidget);
    expect(
      find.text('Escribe al menos 6 caracteres de prueba'),
      findsOneWidget,
    );
    await tester.enterText(
      find.byType(TextFormField).at(0),
      'alumno@aloe.ulima.edu.pe',
    );
    await tester.enterText(find.byType(TextFormField).at(1), 'prueba123');
    await tester.ensureVisible(find.text('Ingresar'));
    await tester.tap(find.text('Ingresar'));
    await tester.pumpAndSettle();
    expect(find.text('Sesión iniciada'), findsOneWidget);
    expect(
      Navigator.of(tester.element(find.text('Sesión iniciada'))).canPop(),
      isFalse,
    );
    expect(tester.takeException(), isNull);
  });

  testWidgets('Pantalla pequeña, letra ampliada, modo oscuro y teclado', (
    tester,
  ) async {
    configurarPantalla(tester, const Size(320, 568));
    tester.platformDispatcher.textScaleFactorTestValue = 1.5;
    addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
    await tester.pumpWidget(await crearAppAuth(oscuro: true));
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.text('Ingresar'));
    await tester.tap(find.text('Ingresar'));
    await tester.pumpAndSettle();
    tester.view.viewInsets = const FakeViewPadding(bottom: 280);
    await tester.showKeyboard(find.byType(TextFormField).last);
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.text('Ingresar'));
    await tester.pumpAndSettle();
    expect(find.text('Ingresar').hitTestable(), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
