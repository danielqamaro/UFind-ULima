class SolicitudRecuperacion {
  final int id;
  final int objetoId;
  final String objetoNombre;
  final String correo;
  final String nombreSolicitante;
  final String telefono;
  final String descripcion;
  final String fotoEvidencia;
  final DateTime fecha;
  final String estado;
  final String motivoRechazo;
  final DateTime? fechaResolucion;
  final bool notificacionLeida;

  const SolicitudRecuperacion({
    required this.id,
    required this.objetoId,
    required this.objetoNombre,
    required this.correo,
    required this.descripcion,
    required this.fecha,
    this.nombreSolicitante = '',
    this.telefono = '',
    this.fotoEvidencia = '',
    this.estado = 'Pendiente',
    this.motivoRechazo = '',
    this.fechaResolucion,
    this.notificacionLeida = false,
  });

  bool get resuelta => estado == 'Aprobada' || estado == 'Rechazada';

  SolicitudRecuperacion copyWith({
    String? correo,
    String? estado,
    String? motivoRechazo,
    DateTime? fechaResolucion,
    bool? notificacionLeida,
  }) => SolicitudRecuperacion(
    id: id,
    objetoId: objetoId,
    objetoNombre: objetoNombre,
    correo: correo ?? this.correo,
    nombreSolicitante: nombreSolicitante,
    telefono: telefono,
    descripcion: descripcion,
    fotoEvidencia: fotoEvidencia,
    fecha: fecha,
    estado: estado ?? this.estado,
    motivoRechazo: motivoRechazo ?? this.motivoRechazo,
    fechaResolucion: fechaResolucion ?? this.fechaResolucion,
    notificacionLeida: notificacionLeida ?? this.notificacionLeida,
  );

  factory SolicitudRecuperacion.fromJson(Map<String, dynamic> json) =>
      SolicitudRecuperacion(
        id: (json['id'] as num).toInt(),
        objetoId: (json['objetoId'] as num).toInt(),
        objetoNombre: json['objetoNombre'] as String,
        correo: json['correo'] as String,
        nombreSolicitante: json['nombreSolicitante'] as String? ?? '',
        telefono: json['telefono'] as String? ?? '',
        descripcion: json['descripcion'] as String,
        fotoEvidencia: json['fotoEvidencia'] as String? ?? '',
        fecha: DateTime.parse(json['fecha'] as String),
        estado: json['estado'] as String,
        motivoRechazo: json['motivoRechazo'] as String? ?? '',
        fechaResolucion: DateTime.tryParse(
          json['fechaResolucion'] as String? ?? '',
        ),
        notificacionLeida: json['notificacionLeida'] as bool? ?? false,
      );

  Map<String, dynamic> toJson() => {
    'id': id,
    'objetoId': objetoId,
    'objetoNombre': objetoNombre,
    'correo': correo,
    'nombreSolicitante': nombreSolicitante,
    'telefono': telefono,
    'descripcion': descripcion,
    'fotoEvidencia': fotoEvidencia,
    'fecha': fecha.toIso8601String(),
    'estado': estado,
    'motivoRechazo': motivoRechazo,
    'fechaResolucion': fechaResolucion?.toIso8601String(),
    'notificacionLeida': notificacionLeida,
  };
}
