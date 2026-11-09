class ObjetoPublicacion {
  final int id;
  String nombre;
  String categoria;
  String descripcion;
  String fecha;
  String ubicacion;
  String estado;
  String tipo;
  String usuario;
  String contacto;
  String edificio;
  String piso;
  String referencia;
  String fotografia;
  double latitud;
  double longitud;

  ObjetoPublicacion({
    required this.id,
    required this.nombre,
    required this.categoria,
    required this.descripcion,
    required this.fecha,
    required this.ubicacion,
    required this.estado,
    required this.tipo,
    required this.usuario,
    required this.contacto,
    required this.edificio,
    required this.piso,
    required this.referencia,
    required this.fotografia,
    required this.latitud,
    required this.longitud,
  });

  factory ObjetoPublicacion.fromJson(Map<String, dynamic> json) =>
      ObjetoPublicacion(
        id: (json['id'] as num).toInt(),
        nombre: json['nombre'] as String,
        categoria: json['categoria'] as String,
        descripcion: json['descripcion'] as String,
        fecha: json['fecha'] as String,
        ubicacion: json['ubicacion'] as String,
        estado: json['estado'] as String,
        tipo: json['tipo'] as String,
        usuario: json['usuario'] as String,
        contacto: json['contacto'] as String,
        edificio: json['edificio'] as String,
        piso: json['piso'] as String,
        referencia: json['referencia'] as String,
        fotografia: json['fotografia'] as String,
        latitud: (json['latitud'] as num).toDouble(),
        longitud: (json['longitud'] as num).toDouble(),
      );

  Map<String, dynamic> toJson() => {
    'id': id,
    'nombre': nombre,
    'categoria': categoria,
    'descripcion': descripcion,
    'fecha': fecha,
    'ubicacion': ubicacion,
    'estado': estado,
    'tipo': tipo,
    'usuario': usuario,
    'contacto': contacto,
    'edificio': edificio,
    'piso': piso,
    'referencia': referencia,
    'fotografia': fotografia,
    'latitud': latitud,
    'longitud': longitud,
  };
}
