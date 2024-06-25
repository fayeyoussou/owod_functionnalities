class Blog {
  final String id;
  final String poster_id,title,content,imageUrl;
  final List<String> topics;
  final DateTime updatedAt;

  Blog({required this.id, required this.poster_id, required this.title, required this.content, required this.imageUrl, required this.topics, required this.updatedAt});

}