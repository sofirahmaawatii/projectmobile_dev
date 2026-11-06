import 'package:flutter/material.dart';

import '../models/post.dart';
import '../services/api_services.dart';

class DashboardScreen extends StatefulWidget {
  final Function(int) onNavigate;

  const DashboardScreen({super.key, required this.onNavigate});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  static const Color purple = Color(0xFF6741A5);
  static const Color darkPurple = Color(0xFF452477);
  static const Color background = Color(0xFFF8F7FB);

  final ApiService api = ApiService();
  late Future<List<Post>> futurePosts;

  @override
  void initState() {
    super.initState();
    futurePosts = api.fetchPosts();
  }

  Future<void> refreshNews() async {
    final request = api.fetchPosts();

    setState(() {
      futurePosts = request;
    });

    try {
      await request;
    } catch (_) {}
  }

  // HEADER APLIKASI
  Widget buildHeader() {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 18, 20, 18),
      decoration: const BoxDecoration(color: Colors.white),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: purple,
              borderRadius: BorderRadius.circular(13),
            ),
            child: const Icon(
              Icons.newspaper_rounded,
              color: Colors.white,
              size: 28,
            ),
          ),

          const SizedBox(width: 12),

          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'UNIGAL APPS',
                  style: TextStyle(
                    color: darkPurple,
                    fontSize: 21,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 0.7,
                  ),
                ),
                Text(
                  'Sistem Universitas Galuh',
                  style: TextStyle(color: Colors.grey, fontSize: 10),
                ),
              ],
            ),
          ),

          IconButton(
            onPressed: refreshNews,
            icon: const Icon(Icons.refresh_rounded, color: darkPurple),
          ),
        ],
      ),
    );
  }

  // SHORTCUT TAMBAH BERITA
  Widget buildShortcut() {
    return InkWell(
      onTap: () => widget.onNavigate(1),
      borderRadius: BorderRadius.circular(15),
      child: Container(
        padding: const EdgeInsets.all(17),
        decoration: BoxDecoration(
          color: purple,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: purple.withOpacity(0.18),
              blurRadius: 12,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: const Row(
          children: [
            CircleAvatar(
              backgroundColor: Colors.white,
              child: Icon(Icons.add, color: purple),
            ),

            SizedBox(width: 13),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Tambah Berita Baru',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Klik untuk menambahkan berita',
                    style: TextStyle(color: Colors.white70, fontSize: 11),
                  ),
                ],
              ),
            ),

            Icon(Icons.arrow_forward_ios, color: Colors.white, size: 16),
          ],
        ),
      ),
    );
  }

  // JUDUL SECTION
  Widget sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 13),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: darkPurple,
        ),
      ),
    );
  }

  // GAMBAR BERITA
  Widget newsImage(String image, {double height = 170}) {
    if (image.isEmpty) {
      return Container(
        height: height,
        color: Colors.grey.shade200,
        child: const Center(
          child: Icon(
            Icons.image_not_supported_outlined,
            color: Colors.grey,
            size: 35,
          ),
        ),
      );
    }

    return Image.network(
      image,
      height: height,
      width: double.infinity,
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) {
        return Container(
          height: height,
          color: Colors.grey.shade200,
          child: const Center(
            child: Icon(
              Icons.broken_image_outlined,
              color: Colors.grey,
              size: 35,
            ),
          ),
        );
      },
    );
  }

  // KARTU BERITA
  Widget buildNewsCard(Post post) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(13),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          newsImage(post.image, height: 175),

          Padding(
            padding: const EdgeInsets.all(13),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'BERITA TERBARU',
                  style: TextStyle(
                    color: purple,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.7,
                  ),
                ),

                const SizedBox(height: 8),

                Text(
                  post.title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: darkPurple,
                    height: 1.4,
                  ),
                ),

                const SizedBox(height: 8),

                Text(
                  post.description.isEmpty
                      ? 'Baca informasi berita terbaru.'
                      : post.description,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 12,
                    height: 1.5,
                  ),
                ),

                if (post.date.isNotEmpty) ...[
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      const Icon(
                        Icons.calendar_today_outlined,
                        size: 13,
                        color: purple,
                      ),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          post.date,
                          style: const TextStyle(
                            fontSize: 10,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  // DAFTAR BERITA
  Widget buildNewsList() {
    return FutureBuilder<List<Post>>(
      future: futurePosts,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Padding(
            padding: EdgeInsets.all(40),
            child: Center(child: CircularProgressIndicator(color: purple)),
          );
        }

        if (snapshot.hasError) {
          return Center(
            child: Column(
              children: [
                const Icon(
                  Icons.cloud_off_outlined,
                  size: 45,
                  color: Colors.grey,
                ),
                const SizedBox(height: 10),
                const Text('Gagal memuat berita'),
                TextButton(
                  onPressed: refreshNews,
                  child: const Text(
                    'Coba Lagi',
                    style: TextStyle(color: purple),
                  ),
                ),
              ],
            ),
          );
        }

        final posts = snapshot.data ?? [];

        if (posts.isEmpty) {
          return const Padding(
            padding: EdgeInsets.all(25),
            child: Center(child: Text('Belum ada berita tersedia')),
          );
        }

        return Column(
          children: posts.take(5).map((post) => buildNewsCard(post)).toList(),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      body: SafeArea(
        child: RefreshIndicator(
          color: purple,
          onRefresh: refreshNews,
          child: ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.only(bottom: 25),
            children: [
              buildHeader(),

              Padding(
                padding: const EdgeInsets.fromLTRB(16, 20, 16, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // SELAMAT DATANG
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF0EAF7),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Selamat Datang Mahasiswa Unigal!',
                            style: TextStyle(
                              color: darkPurple,
                              fontSize: 19,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 6),
                          Text(
                            'Temukan informasi dan berita terkini melalui Unigal News.',
                            style: TextStyle(
                              color: Colors.black54,
                              fontSize: 12,
                              height: 1.5,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),

                    // SHORTCUT
                    buildShortcut(),

                    const SizedBox(height: 25),

                    // BERITA TERBARU
                    sectionTitle('Berita Terbaru'),

                    buildNewsList(),

                    const SizedBox(height: 15),

                    Center(
                      child: Text(
                        'UNIGAL NEWS • UNIVERSITAS GALUH',
                        style: TextStyle(
                          color: Colors.grey.shade500,
                          fontSize: 10,
                          letterSpacing: 1,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
