import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/cancion_service.dart';
import '../models/cancion.dart';
import '../widgets/cancion_card.dart';
import 'cancion_detail_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final Set<int> _favoritos = {};

  late final CancionService _service;
  late Future<List<Cancion>> _futureCanciones;

  @override
  void initState() {
    super.initState();
    // Misma URL base que en el ejemplo, pero con el sufijo /canciones
    _service = const CancionService(
      baseUrl: ' https://dummyjson.com/c/6049-967a-42f9-94f9',
      usarFallbackLocal: true,
    );
    _futureCanciones = _service.obtenerCanciones();
    _cargarFavoritos();
  }

  Future<void> _cargarFavoritos() async {
    final prefs = await SharedPreferences.getInstance();
    final ids = prefs.getStringList('favoritos') ?? [];

    setState(() {
      _favoritos
        ..clear()
        ..addAll(ids.map(int.parse));
    });
  }

  Future<void> _guardarFavoritos() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(
      'favoritos',
      _favoritos.map((id) => id.toString()).toList(),
    );
  }

  void _actualizarFavorito(int cancionId, bool esFavorito) {
    setState(() {
      if (esFavorito) {
        _favoritos.add(cancionId);
      } else {
        _favoritos.remove(cancionId);
      }
    });
    _guardarFavoritos();
  }

  Future<void> _recargarCanciones() async {
    setState(() {
      _futureCanciones = _service.obtenerCanciones();
    });
    await _futureCanciones;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('PLAYLIST SPOTIFY'),
        centerTitle: true,
      ),
      body: FutureBuilder<List<Cancion>>(
        future: _futureCanciones,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.error_outline, size: 48),
                    const SizedBox(height: 12),
                    const Text(
                      'Ocurrió un error al cargar las canciones.',
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 12),
                    FilledButton(
                      onPressed: () {
                        setState(() {
                          _futureCanciones = _service.obtenerCanciones();
                        });
                      },
                      child: const Text('Reintentar'),
                    ),
                  ],
                ),
              ),
            );
          }

          final canciones = snapshot.data ?? [];

          if (canciones.isEmpty) {
            return const Center(
              child: Text('No hay canciones disponibles.'),
            );
          }

          return RefreshIndicator(
            onRefresh: _recargarCanciones,
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: GridView.builder(
                itemCount: canciones.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 0.85,
                ),
                itemBuilder: (context, index) {
                  final cancion = canciones[index];
                  final esFavorito = _favoritos.contains(cancion.id);

                  return CancionCard(
                    cancion: cancion,
                    esFavorito: esFavorito,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => CancionDetailPage(
                            cancion: cancion,
                            esFavoritoInicial: esFavorito,
                            onFavoritoChanged: (nuevoValor) {
                              _actualizarFavorito(cancion.id, nuevoValor);
                            },
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }
}