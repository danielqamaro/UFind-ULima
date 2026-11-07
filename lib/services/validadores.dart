class Validadores {
  Validadores._();
  static final _correo = RegExp(
    r'^[^\s@]+@aloe\.ulima\.edu\.pe$',
    caseSensitive: false,
  );
  static String normalizarCorreo(String correo) => correo.trim().toLowerCase();
  static bool esCorreoInstitucional(String correo) =>
      _correo.hasMatch(correo.trim());
}
