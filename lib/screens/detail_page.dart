import 'package:flutter/material.dart';

import '../models/post.dart';

class DetailPage extends StatelessWidget {
  final Post post;

  const DetailPage({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F5FC),
      appBar: AppBar(
        title: const Text('Detail Berita'),
        backgroundColor: const Color(0xFF7B2CBF),
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                post.image,
                width: double.infinity,
                height: 230,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return const SizedBox(
                    height: 230,
                    child: Center(
                      child: Icon(Icons.image_not_supported, size: 50),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 20),
            Text(
              post.title,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Text(post.date, style: const TextStyle(color: Colors.grey)),
            const SizedBox(height: 20),
            const Text(
              'Isi Berita',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Text(
              post.description.isNotEmpty
                  ? post.description
                  : 'Deskripsi berita belum tersedia.',
              textAlign: TextAlign.justify,
              style: const TextStyle(fontSize: 15, height: 1.8),
            ),
          ],
        ),
      ),
    );
  }
}
