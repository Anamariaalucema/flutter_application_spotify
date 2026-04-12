class Cancion {
  final int id;
  final String nombre; 
  final String artista;
  final String album;
  final String imagen;

  const Cancion({
    required this.id,
    required this.nombre,
    required this.artista,
    required this.album,
    required this.imagen,
  });

  factory Cancion.fromJson(Map<String, dynamic> json) {
    return Cancion(
      id: json['id'] as int,
      nombre: (json['nombre'] ?? '') as String,
      artista: (json['artista'] ?? '') as String,
      album: (json['album'] ?? '') as String,
      imagen: (json['imagen'] ?? '') as String,
    );
  }


  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nombre': nombre,
      'artista': artista,
      'album': album,
      'imagen': imagen,
    };
  }
}