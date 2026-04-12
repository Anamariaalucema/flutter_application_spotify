import 'package:flutter/material.dart';
import '../models/cancion.dart';

class CancionCard extends StatelessWidget {
  final Cancion cancion;
  final bool esFavorito;
  final VoidCallback onTap;

  const CancionCard({
    super.key,
    required this.cancion,
    required this.esFavorito,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.asset(
                    cancion.imagen,
                    width: 95,
                    height: 95,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        width: 95,
                        height: 95,
                        alignment: Alignment.center,
                        color: Colors.grey.shade300,
                        child: const Icon(Icons.image_not_supported, size: 28),
                      );
                    },
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(
                      cancion.nombre,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(width: 6),
                  Icon(
                    esFavorito ? Icons.star : Icons.star_border,
                    color: esFavorito ? Colors.amber : Colors.grey,
                    size: 20,
                  ),
                ],
              ),
              const SizedBox(height: 6),
              Text(
                cancion.artista,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: Colors.indigo.shade700,
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                cancion.album,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: Colors.indigo.shade700,
                  fontWeight: FontWeight.w500,
                  fontSize: 13,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}