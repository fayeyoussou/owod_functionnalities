part of 'blog_bloc.dart';

@immutable
sealed class BlogEvent {}

final class BlogUploading extends BlogEvent{
  final String posterId,title,content;
  final File image;
  final List<String> topics;

  BlogUploading({required this.posterId, required this.title, required this.content, required this.image, required this.topics});


}

