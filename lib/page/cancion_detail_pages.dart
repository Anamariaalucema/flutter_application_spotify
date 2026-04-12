import 'package:flutter/material.dart';
import '../models/cancion.dart';

class CancionDetailPage extends StatefulWidget {
  final Cancion cancion;
  final bool esFavoritoInicial;
  final ValueChanged<bool> onFavoritoChanged;

  const CancionDetailPage({
    super.key,
    required this.cancion,
    required this.esFavoritoInicial,
    required this.onFavoritoChanged,
  });

  @override
  State<CancionDetailPage> createState() => _CancionDetailPageState();
}

class _CancionDetailPageState extends State<CancionDetailPage> {
  late bool _esFavorito;

  @override
  void initState() {
    super.initState();
    _esFavorito = widget.esFavoritoInicial;
  }

  void _toggleFavorito() {
    setState(() {
      _esFavorito = !_esFavorito;
    });

    widget.onFavoritoChanged(_esFavorito);
  }

  @override
  Widget build(BuildContext context) {
    final cancion = widget.cancion;

    return Scaffold(
      appBar: AppBar(
        title: Text(cancion.nombre),
        actions: [
          IconButton(
            onPressed: _toggleFavorito,
            icon: Icon(
              _esFavorito ? Icons.star : Icons.star_border,
              color: _esFavorito ? Colors.amber : null,
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.asset(
              cancion.imagen,
              width: double.infinity,
              height: 240,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  width: double.infinity,
                  height: 240,
                  alignment: Alignment.center,
                  color: Colors.grey.shade300,
                  child: const Icon(Icons.image_not_supported, size: 48),
                );
              },
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(
                      cancion.nombre,
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                  ),
                  IconButton(
                    onPressed: _toggleFavorito,
                    icon: Icon(
                      _esFavorito ? Icons.star : Icons.star_border,
                      color: _esFavorito ? Colors.amber : Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                'Artista: ${cancion.artista}',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.indigo.shade700,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                'Álbum: ${cancion.album}',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.indigo.shade700,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                'Esta canción se llama "${cancion.nombre}", pertenece al álbum "${cancion.album}" y es interpretada por ${cancion.artista}.',
                style: const TextStyle(
                  fontSize: 16,
                  height: 1.5,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}