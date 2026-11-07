/// Perfil de demostración guardado solo en el teléfono.
/// Este modelo NO representa una cuenta autenticada en un servidor.
class UsuarioPerfil {
  final String id;
  final String nombre;
  final String correo;
  final String carrera;
  final String telefono;
  final String foto;
  final DateTime fechaRegistro;

  const UsuarioPerfil({
    required this.id,
    required this.nombre,
    required this.correo,
    this.carrera = '',
    this.telefono = '',
    this.foto = '',
    required this.fechaRegistro,
  });

  UsuarioPerfil copyWith({
    String? nombre,
    String? correo,
    String? carrera,
    String? telefono,
    String? foto,
  }) => UsuarioPerfil(
    id: id,
    nombre: nombre ?? this.nombre,
    correo: correo ?? this.correo,
    carrera: carrera ?? this.carrera,
    telefono: telefono ?? this.telefono,
    foto: foto ?? this.foto,
    fechaRegistro: fechaRegistro,
  );

  factory UsuarioPerfil.fromJson(Map<String, dynamic> json) => UsuarioPerfil(
    id: json['id'] as String,
    nombre: json['nombre'] as String,
    correo: json['correo'] as String,
    carrera: json['carrera'] as String? ?? '',
    telefono: json['telefono'] as String? ?? '',
    foto: json['foto'] as String? ?? '',
    fechaRegistro: DateTime.parse(json['fechaRegistro'] as String),
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'nombre': nombre,
    'correo': correo,
    'carrera': carrera,
    'telefono': telefono,
    'foto': foto,
    'fechaRegistro': fechaRegistro.toIso8601String(),
  };
}
