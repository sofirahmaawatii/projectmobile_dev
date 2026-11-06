class Post {
  final String title;
  final String link;
  final String image;
  final String description;
  final String date;

  Post({
    required this.title,
    required this.link,
    required this.image,
    required this.description,
    required this.date,
  });

  // Mengambil field pertama yang memiliki isi
  static String getValue(Map<String, dynamic> json, List<String> keys) {
    for (final key in keys) {
      final value = json[key];

      if (value != null && value.toString().trim().isNotEmpty) {
        return value.toString();
      }
    }

    return '';
  }

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      title: getValue(json, ['title', 'headline']),
      link: getValue(json, ['link', 'url']),
      image: getValue(json, [
        'imageUrl',
        'image_url',
        'image',
        'thumbnail',
        'thumbnail_url',
      ]),
      description: getValue(json, [
        'description',
        'content',
        'summary',
        'excerpt',
        'full_text',
        'body',
      ]),
      date: getValue(json, ['date', 'pubDate', 'published_at', 'timestamp']),
    );
  }
}
