import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ufind/app/app_dependencies.dart';
import 'package:ufind/views/admin/gestion_solicitudes.dart';
import 'package:ufind/views/alumno/detalle_objeto.dart';
import 'package:ufind/views/alumno/notificaciones.dart';

void main() {
  testWidgets(
    'El reclamo llega a administración y avisa al alumno del rechazo',
    (tester) async {
      SharedPreferences.setMockInitialValues({});
      final d = await AppDependencies.cargar();
      addTearDown(d.dispose);

      const correo = 'alumno@aloe.ulima.edu.pe';
      const prueba = 'El estuche tiene mi nombre grabado.';
      const motivo = 'La descripción no coincide con el objeto.';
      d.sesion.ingresarDemo(correo);
      final objeto = d.publicaciones.obtenerPublicaciones().firstWhere(
        (objeto) => objeto.estado == 'Disponible',
      );

      await tester.pumpWidget(
        MaterialApp(
          home: DetalleObjetoScreen(objeto: objeto, dependencias: d),
        ),
      );
      final reclamar = find.text('Reclamar objeto');
      await tester.scrollUntilVisible(reclamar, 230);
      await tester.pumpAndSettle();
      final mapa = find.text('Ver ubicación en el mapa');
      final contacto = find.text('Contactar a Administración');
      expect(
        tester.getTopLeft(mapa).dy,
        lessThan(tester.getTopLeft(reclamar).dy),
      );
      expect(
        tester.getTopLeft(reclamar).dy,
        lessThan(tester.getTopLeft(contacto).dy),
      );
      await tester.tap(reclamar);
      await tester.pumpAndSettle();

      final descripcion = find.widgetWithText(
        TextFormField,
        'Prueba de propiedad',
      );
      await tester.enterText(descripcion, prueba);
      final enviar = find.text('Enviar reclamo');
      await tester.drag(find.byType(ListView), const Offset(0, -360));
      await tester.pumpAndSettle();
      await tester.tap(enviar);
      await tester.pumpAndSettle();
      expect(d.solicitudes.tienePendiente(objeto.id, correo), isTrue);
      expect(d.solicitudes.notificaciones(correo), isEmpty);

      await tester.pumpWidget(
        MaterialApp(home: GestionSolicitudesScreen(dependencias: d)),
      );
      await tester.pumpAndSettle();
      expect(find.text(correo), findsOneWidget);
      expect(find.text(prueba), findsOneWidget);
      await tester.ensureVisible(find.text('Rechazar'));
      await tester.tap(find.text('Rechazar'));
      await tester.pumpAndSettle();
      final rechazar = find.widgetWithText(FilledButton, 'Rechazar');
      await tester.tap(rechazar);
      await tester.pumpAndSettle();
      expect(find.text('Escribe el motivo del rechazo'), findsOneWidget);
      await tester.enterText(find.byType(TextFormField), motivo);
      await tester.tap(rechazar);
      await tester.pumpAndSettle();

      final recargada = await AppDependencies.cargar();
      addTearDown(recargada.dispose);
      final notificacion = recargada.solicitudes.notificaciones(correo).single;
      expect(notificacion.motivoRechazo, motivo);
      expect(
        recargada.solicitudes.notificaciones('otro@aloe.ulima.edu.pe'),
        isEmpty,
      );
      recargada.sesion.ingresarDemo(correo);
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            appBar: AppBar(
              actions: [CampanaNotificaciones(dependencias: recargada)],
            ),
          ),
        ),
      );
      final campana = find.byIcon(Icons.notifications_outlined);
      expect(campana, findsOneWidget);
      expect(notificacion.notificacionLeida, isFalse);
      await tester.tap(campana);
      await tester.pumpAndSettle();
      expect(find.text('Solicitud rechazada'), findsOneWidget);
      expect(find.text('Motivo: $motivo'), findsOneWidget);
      expect(
        recargada.solicitudes.notificaciones(correo).single.notificacionLeida,
        isTrue,
      );
    },
  );

  test(
    'La aprobación se guarda y crea una notificación para el titular',
    () async {
      SharedPreferences.setMockInitialValues({});
      final d = await AppDependencies.cargar();
      addTearDown(d.dispose);
      const correo = 'alumno@aloe.ulima.edu.pe';
      final objeto = d.publicaciones.obtenerPublicaciones().firstWhere(
        (objeto) => objeto.estado == 'Disponible',
      );
      expect(
        await d.solicitudes.registrar(
          objeto: objeto,
          correo: correo,
          nombreSolicitante: 'Nombre de prueba',
          descripcion: 'El estuche tiene mi nombre grabado.',
          fotoEvidencia: 'file:adjunto.jpg',
        ),
        isTrue,
      );
      final solicitud = d.solicitudes.obtenerTodas().single;
      expect(await d.solicitudes.resolver(solicitud.id, aprobar: true), isTrue);
      expect(
        await d.solicitudes.resolver(
          solicitud.id,
          aprobar: false,
          motivo: 'Otro',
        ),
        isFalse,
      );

      final recargada = await AppDependencies.cargar();
      addTearDown(recargada.dispose);
      final resultado = recargada.solicitudes.notificaciones(correo).single;
      expect(resultado.estado, 'Aprobada');
      expect(resultado.fotoEvidencia, 'file:adjunto.jpg');
      expect(resultado.motivoRechazo, isEmpty);
      expect(resultado.notificacionLeida, isFalse);
    },
  );
}
