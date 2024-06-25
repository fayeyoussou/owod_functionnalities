import 'dart:io';

import 'package:owod_functionnalities/core/error/failure.dart';
import 'package:owod_functionnalities/core/error/server_exception.dart';
import 'package:owod_functionnalities/features/blog/data/datasources/blog_remote_data_source.dart';
import 'package:owod_functionnalities/features/blog/data/models/blog_model.dart';
import 'package:owod_functionnalities/features/blog/domain/entities/blog.dart';
import 'package:owod_functionnalities/features/blog/domain/repositories/blog_repository.dart';
import 'package:fpdart/src/either.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';

class BlogRepositoryImpl implements BlogRepository {
  final BlogRemoteDataSource blogRemoteDataSource;

  BlogRepositoryImpl(this.blogRemoteDataSource);

  @override
  Future<Either<Failure, Blog>> uploadBlog(
      {required File image,
      required String title,
      required String content,
      required String posterId,
      required List<String> topics}) async {
    try {
      BlogModel blogModel = BlogModel(
          id: const Uuid().v1(),
          poster_id: posterId,
          title: title,
          content: content,
          imageUrl: '',
          topics: topics,
          updatedAt: DateTime.now());
      String imageUrl = await blogRemoteDataSource.uploadBlogImage(
          image: image, blog: blogModel);
      blogModel = blogModel.copyWith(imageUrl: imageUrl);
      BlogModel uploadedBlogModel =
          await blogRemoteDataSource.uploadBlog(blogModel);
      return right(uploadedBlogModel);
    } on ServerException catch (e) {
      return left(Failure('ServerException : ${e.message}'));
    } on PostgrestException catch (e) {
      return left(
        Failure(
          'PostgrestException : ${e.message}',
        ),
      );
    } catch (e) {
      return left(
        Failure(
          e.toString(),
        ),
      );
    }
  }
}
