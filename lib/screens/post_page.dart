import 'package:flutter/material.dart';

import '../models/post.dart';
import '../services/api_services.dart';

class PostPage extends StatefulWidget {
  const PostPage({super.key});

  @override
  State<PostPage> createState() => _PostPageState();
}

class _PostPageState extends State<PostPage> {
  final ApiService api = ApiService();

  late Future<List<Post>> futurePosts;

  final TextEditingController searchController = TextEditingController();

  String selectedCategory = 'Semua';

  final List<String> categories = [
    'Semua',
    'Nasional',
    'Teknologi',
    'Ekonomi',
    'Olahraga',
    'Lifestyle',
    'Politik',
    'Hiburan',
  ];

  @override
  void initState() {
    super.initState();
    futurePosts = api.fetchPosts();
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  // REFRESH BERITA
  void refreshPosts() {
    setState(() {
      futurePosts = api.fetchPosts();
    });
  }

  // MENGIDENTIFIKASI KATEGORI BERITA
  bool categoryMatches(Post post, String category) {
    if (category == 'Semua') return true;

    final text = '${post.title} ${post.description}'.toLowerCase();

    switch (category) {
      case 'Nasional':
        return [
          'nasional',
          'indonesia',
          'pemerintah',
          'presiden',
          'menteri',
          'daerah',
          'jakarta',
          'rakyat',
          'negara',
        ].any((word) => text.contains(word));

      case 'Teknologi':
        return [
          'teknologi',
          'digital',
          'internet',
          'aplikasi',
          'gadget',
          'smartphone',
          'artificial intelligence',
          'ai',
          'komputer',
          'robot',
        ].any((word) => text.contains(word));

      case 'Ekonomi':
        return [
          'ekonomi',
          'bisnis',
          'rupiah',
          'saham',
          'investasi',
          'keuangan',
          'harga',
          'pasar',
          'bank',
          'perusahaan',
        ].any((word) => text.contains(word));

      case 'Olahraga':
        return [
          'olahraga',
          'sepak bola',
          'basket',
          'badminton',
          'bulutangkis',
          'liga',
          'timnas',
          'pemain',
          'atlet',
          'pertandingan',
        ].any((word) => text.contains(word));

      case 'Lifestyle':
        return [
          'lifestyle',
          'gaya hidup',
          'kuliner',
          'wisata',
          'fashion',
          'kesehatan',
          'makanan',
          'travel',
          'hiburan',
        ].any((word) => text.contains(word));

      case 'Politik':
        return [
          'politik',
          'pemilu',
          'partai',
          'dpr',
          'kpu',
          'pilpres',
          'pilkada',
          'legislatif',
        ].any((word) => text.contains(word));

      case 'Hiburan':
        return [
          'hiburan',
          'artis',
          'film',
          'musik',
          'selebriti',
          'konser',
          'aktor',
          'penyanyi',
        ].any((word) => text.contains(word));

      default:
        return false;
    }
  }

  // FILTER PENCARIAN DAN KATEGORI
  List<Post> filterPosts(List<Post> posts) {
    final keyword = searchController.text.toLowerCase().trim();

    return posts.where((post) {
      final matchesCategory = categoryMatches(post, selectedCategory);

      final matchesSearch =
          post.title.toLowerCase().contains(keyword) ||
          post.description.toLowerCase().contains(keyword);

      return matchesCategory && matchesSearch;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F5FA),

      // HEADER
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'UNIGALNews',
              style: TextStyle(
                color: Color(0xFF7B2CBF),
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              'Berita terkini Universitas Galuh',
              style: TextStyle(
                color: Colors.grey,
                fontSize: 11,
                fontWeight: FontWeight.normal,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            onPressed: refreshPosts,
            icon: const Icon(Icons.refresh, color: Color(0xFF7B2CBF)),
            tooltip: 'Refresh berita',
          ),
          const SizedBox(width: 8),
        ],
      ),

      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // SEARCH BAR
          Container(
            color: Colors.white,
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 18),
            child: TextField(
              controller: searchController,
              onChanged: (value) {
                setState(() {});
              },
              decoration: InputDecoration(
                hintText: 'Cari berita yang kamu inginkan...',
                hintStyle: const TextStyle(fontSize: 13, color: Colors.grey),
                prefixIcon: const Icon(Icons.search, color: Color(0xFF7B2CBF)),
                suffixIcon: searchController.text.isNotEmpty
                    ? IconButton(
                        onPressed: () {
                          searchController.clear();
                          setState(() {});
                        },
                        icon: const Icon(Icons.close),
                      )
                    : null,
                filled: true,
                fillColor: const Color(0xFFF5F1FA),
                contentPadding: const EdgeInsets.symmetric(vertical: 14),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),

          // KATEGORI
          Container(
            color: Colors.white,
            padding: const EdgeInsets.only(bottom: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.fromLTRB(16, 0, 16, 12),
                  child: Text(
                    'Kategori Berita',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF292333),
                    ),
                  ),
                ),

                SizedBox(
                  height: 38,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: categories.length,
                    itemBuilder: (context, index) {
                      final category = categories[index];

                      final active = selectedCategory == category;

                      return Padding(
                        padding: const EdgeInsets.only(right: 9),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(20),
                          onTap: () {
                            setState(() {
                              selectedCategory = category;
                            });
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 17,
                              vertical: 9,
                            ),
                            decoration: BoxDecoration(
                              color: active
                                  ? const Color(0xFF7B2CBF)
                                  : const Color(0xFFF3EFF8),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              category,
                              style: TextStyle(
                                color: active ? Colors.white : Colors.black54,
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 14),

          // DAFTAR BERITA
          Expanded(
            child: FutureBuilder<List<Post>>(
              future: futurePosts,
              builder: (context, snapshot) {
                // LOADING
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(color: Color(0xFF7B2CBF)),
                  );
                }

                // ERROR
                if (snapshot.hasError) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(25),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.error_outline,
                            size: 55,
                            color: Colors.red,
                          ),
                          const SizedBox(height: 12),
                          const Text(
                            'Gagal memuat berita',
                            style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            snapshot.error.toString(),
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.grey,
                            ),
                          ),
                          const SizedBox(height: 15),
                          ElevatedButton(
                            onPressed: refreshPosts,
                            child: const Text('Coba Lagi'),
                          ),
                        ],
                      ),
                    ),
                  );
                }

                // DATA KOSONG
                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('Belum ada berita'));
                }

                final allPosts = snapshot.data!;
                final posts = filterPosts(allPosts);

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // JUDUL DAFTAR
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Berita Terbaru',
                            style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF292333),
                            ),
                          ),
                          Text(
                            '${posts.length} berita',
                            style: const TextStyle(
                              fontSize: 11,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // LIST BERITA
                    Expanded(
                      child: posts.isEmpty
                          ? const Center(
                              child: Text(
                                'Berita tidak ditemukan',
                                style: TextStyle(color: Colors.grey),
                              ),
                            )
                          : ListView.builder(
                              padding: const EdgeInsets.fromLTRB(14, 0, 14, 20),
                              itemCount: posts.length,
                              itemBuilder: (context, index) {
                                final post = posts[index];

                                return buildNewsCard(post);
                              },
                            ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // CARD BERITA
  Widget buildNewsCard(Post post) {
    return Card(
      margin: const EdgeInsets.only(bottom: 15),
      color: Colors.white,
      elevation: 2,
      shadowColor: Colors.black12,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () {
          tampilkanDetail(post);
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // FOTO
            SizedBox(
              height: 185,
              width: double.infinity,
              child: post.image.isNotEmpty
                  ? Image.network(
                      post.image,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return imagePlaceholder();
                      },
                    )
                  : imagePlaceholder(),
            ),

            Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // KATEGORI DAN SUMBER
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 5,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF0E6FA),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          selectedCategory == 'Semua'
                              ? 'UNIGALNews'
                              : selectedCategory.toUpperCase(),
                          style: const TextStyle(
                            color: Color(0xFF7B2CBF),
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),

                      const Spacer(),

                      const Icon(
                        Icons.access_time,
                        size: 13,
                        color: Colors.grey,
                      ),

                      const SizedBox(width: 4),

                      Flexible(
                        child: Text(
                          post.date,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 10,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 10),

                  // JUDUL
                  Text(
                    post.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      height: 1.4,
                      color: Color(0xFF292333),
                    ),
                  ),

                  const SizedBox(height: 8),

                  // DESKRIPSI
                  Text(
                    post.description.isNotEmpty
                        ? post.description
                        : 'Deskripsi berita belum tersedia.',
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.justify,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.black54,
                      height: 1.6,
                    ),
                  ),

                  const SizedBox(height: 12),

                  // BACA SELENGKAPNYA
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        'Baca selengkapnya',
                        style: TextStyle(
                          color: Color(0xFF7B2CBF),
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(width: 5),
                      Icon(
                        Icons.arrow_forward,
                        size: 14,
                        color: Color(0xFF7B2CBF),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // PLACEHOLDER GAMBAR
  Widget imagePlaceholder() {
    return Container(
      color: const Color(0xFFF0E6FA),
      width: double.infinity,
      child: const Center(
        child: Icon(Icons.image_outlined, color: Color(0xFF7B2CBF), size: 55),
      ),
    );
  }

  // DETAIL BERITA
  void tampilkanDetail(Post post) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
      ),
      builder: (context) {
        return FractionallySizedBox(
          heightFactor: 0.9,
          child: Column(
            children: [
              // GARIS ATAS
              Padding(
                padding: const EdgeInsets.only(top: 12),
                child: Container(
                  width: 45,
                  height: 5,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),

              // ISI DETAIL
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // FOTO BESAR
                      ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        child: SizedBox(
                          width: double.infinity,
                          height: 210,
                          child: post.image.isNotEmpty
                              ? Image.network(
                                  post.image,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return imagePlaceholder();
                                  },
                                )
                              : imagePlaceholder(),
                        ),
                      ),

                      const SizedBox(height: 20),

                      // LABEL
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF0E6FA),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: const Text(
                          'UNIGALNews',
                          style: TextStyle(
                            color: Color(0xFF7B2CBF),
                            fontWeight: FontWeight.bold,
                            fontSize: 11,
                          ),
                        ),
                      ),

                      const SizedBox(height: 14),

                      // JUDUL
                      Text(
                        post.title,
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          height: 1.4,
                          color: Color(0xFF292333),
                        ),
                      ),

                      const SizedBox(height: 12),

                      // TANGGAL
                      Row(
                        children: [
                          const Icon(
                            Icons.calendar_today,
                            size: 14,
                            color: Colors.grey,
                          ),
                          const SizedBox(width: 7),
                          Text(
                            post.date,
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 18),

                      const Divider(),

                      const SizedBox(height: 15),

                      // DESKRIPSI LENGKAP
                      Text(
                        post.description.isNotEmpty
                            ? post.description
                            : 'Deskripsi lengkap berita belum tersedia.',
                        textAlign: TextAlign.justify,
                        style: const TextStyle(
                          fontSize: 15,
                          height: 1.8,
                          color: Color(0xFF444444),
                        ),
                      ),

                      const SizedBox(height: 25),
                    ],
                  ),
                ),
              ),

              // TOMBOL TUTUP
              SafeArea(
                top: false,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 10, 20, 15),
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF7B2CBF),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'Tutup',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
