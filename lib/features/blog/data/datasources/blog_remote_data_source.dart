import 'dart:io';

import 'package:owod_functionnalities/core/error/server_exception.dart';
import 'package:owod_functionnalities/features/blog/data/models/blog_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract interface class BlogRemoteDataSource {
  Future<BlogModel> uploadBlog(BlogModel blog);
  Future<String> uploadBlogImage(
      {required File image, required BlogModel blog});
}

class BlogRemoteDataSourceImpl implements BlogRemoteDataSource {
  final SupabaseClient supabaseClient;

  BlogRemoteDataSourceImpl(this.supabaseClient);
  @override
  Future<BlogModel> uploadBlog(BlogModel blog) async {
    try {
      var jsonBlog = blog.toJson();
      final blogData =
          await supabaseClient.from('blogs').insert(jsonBlog).select();
      return BlogModel.fromJson(blogData.first);
    } on PostgrestException catch (e) {
      throw ServerException('PostgresException : ${e.message}');
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<String> uploadBlogImage(
      {required File image, required BlogModel blog}) async {
    await supabaseClient.storage.from('blog_images').upload(blog.id, image);
    return supabaseClient.storage.from('blog_images').getPublicUrl(blog.id);
  }
}
