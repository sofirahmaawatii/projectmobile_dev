import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/post.dart';
import '../models/item_model.dart';

class ApiService {
  static const String baseUrl = 'https://ikhlasapi.web.id/api/berita/sindonews';

  // Mengambil daftar berita dari API
  Future<List<Post>> fetchPosts() async {
    try {
      final response = await http
          .get(Uri.parse(baseUrl), headers: {'Accept': 'application/json'})
          .timeout(const Duration(seconds: 30));

      print('STATUS API: ${response.statusCode}');

      if (response.statusCode != 200) {
        throw Exception('Gagal mengambil berita. HTTP ${response.statusCode}');
      }

      final decoded = jsonDecode(response.body);

      print('RESPONSE API: ${response.body}');

      final data = _extractPosts(decoded);

      final posts = data.map((item) {
        return Post.fromJson(item);
      }).toList();

      // Debugging hasil parsing
      print('JUMLAH BERITA: ${posts.length}');

      for (final post in posts) {
        print('JUDUL: ${post.title}');
        print('GAMBAR: ${post.image}');
        print('DESKRIPSI: ${post.description}');
        print('TANGGAL: ${post.date}');
        print('LINK: ${post.link}');
        print('---------------------------');
      }

      return posts;
    } catch (e) {
      print('ERROR API: $e');
      rethrow;
    }
  }

  // Membaca berbagai kemungkinan struktur JSON
  List<Map<String, dynamic>> _extractPosts(dynamic result) {
    if (result is List) {
      return result
          .whereType<Map>()
          .map((item) => Map<String, dynamic>.from(item))
          .toList();
    }

    if (result is Map) {
      final json = Map<String, dynamic>.from(result);

      // Jika objek sudah merupakan satu berita
      if (json.containsKey('title') ||
          json.containsKey('headline') ||
          json.containsKey('judul')) {
        return [json];
      }

      // Kemungkinan nama pembungkus data dari API
      const keys = [
        'data',
        'payload',
        'result',
        'results',
        'articles',
        'posts',
        'items',
        'news',
      ];

      for (final key in keys) {
        if (json.containsKey(key) && json[key] != null) {
          final extracted = _extractPosts(json[key]);

          if (extracted.isNotEmpty) {
            return extracted;
          }
        }
      }
    }

    return [];
  }

  // Mengambil data berita untuk Dashboard
  Future<List<ItemModel>> fetchNews() async {
    final posts = await fetchPosts();

    return posts.asMap().entries.map((entry) {
      final index = entry.key;
      final post = entry.value;

      return ItemModel(
        id: (index + 1).toString(),
        title: post.title,
        description: post.description,
      );
    }).toList();
  }
}
