import 'package:flutter/material.dart';
import '../data/canciones_data.dart';
import '../widgets/cancion_card.dart';
import '../page/cancion_detail_pages.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final Set<int> favoritos = {};

  void _actualizarFavorito(int idCancion, bool esFavorito) {
    setState(() {
      if (esFavorito) {
        favoritos.add(idCancion);
      } else {
        favoritos.remove(idCancion);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('PLAYLIST SPOTIFY'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: GridView.builder(
          itemCount: canciones.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3, // 2 cards por fila
            crossAxisSpacing: 12, // espacio horizontal
            mainAxisSpacing: 12, // espacio vertical
            childAspectRatio: 0.85, // forma de la card
          ),
          itemBuilder: (context, index) {
            final cancion = canciones[index];
            final esFavorito = favoritos.contains(cancion.id);

            return CancionCard(
              cancion: cancion,
              esFavorito: esFavorito,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CancionDetailPage(
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
  }
}