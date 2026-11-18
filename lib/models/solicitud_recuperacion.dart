class SolicitudRecuperacion {
  final int id;
  final int objetoId;
  final String objetoNombre;
  String correo;
  final String descripcion;
  final DateTime fecha;
  String estado;

  SolicitudRecuperacion({
    required this.id,
    required this.objetoId,
    required this.objetoNombre,
    required this.correo,
    required this.descripcion,
    required this.fecha,
    this.estado = 'Pendiente',
  });

  factory SolicitudRecuperacion.fromJson(Map<String, dynamic> json) =>
      SolicitudRecuperacion(
        id: (json['id'] as num).toInt(),
        objetoId: (json['objetoId'] as num).toInt(),
        objetoNombre: json['objetoNombre'] as String,
        correo: json['correo'] as String,
        descripcion: json['descripcion'] as String,
        fecha: DateTime.parse(json['fecha'] as String),
        estado: json['estado'] as String,
      );

  Map<String, dynamic> toJson() => {
    'id': id,
    'objetoId': objetoId,
    'objetoNombre': objetoNombre,
    'correo': correo,
    'descripcion': descripcion,
    'fecha': fecha.toIso8601String(),
    'estado': estado,
  };
}
