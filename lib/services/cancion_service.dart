import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/cancion.dart';
import '../data/canciones_data.dart'; // Lista local de respaldo

class CancionService {
  final String baseUrl;
  final bool usarFallbackLocal;

  const CancionService({
    required this.baseUrl,
    this.usarFallbackLocal = true,
  });

  Future<List<Cancion>> obtenerCanciones() async {
    try {
      final response = await http
          .get(Uri.parse(baseUrl))
          .timeout(const Duration(seconds: 3));

      if (response.statusCode != 200) {
        throw Exception('No se pudieron cargar las canciones');
      }

      final dynamic decoded = jsonDecode(response.body);

      // La respuesta debe ser una lista
      if (decoded is! List) {
        throw Exception('La respuesta no tiene el formato esperado');
      }

      return decoded
          .map((item) => Cancion.fromJson(item as Map<String, dynamic>))
          .toList();
    } catch (e) {
      if (!usarFallbackLocal) rethrow;

      // Simulamos un pequeño retraso y devolvemos los datos locales
      await Future.delayed(const Duration(seconds: 1));
      return canciones;
    }
  }
}