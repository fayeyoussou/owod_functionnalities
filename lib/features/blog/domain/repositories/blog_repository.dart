import 'dart:io';

import 'package:owod_functionnalities/core/error/failure.dart';
import 'package:owod_functionnalities/features/blog/domain/entities/blog.dart';
import 'package:fpdart/fpdart.dart';

abstract interface class BlogRepository {
  Future<Either<Failure, Blog>> uploadBlog(
      {required File image,
      required String title,
      required String content,
      required String posterId,
      required List<String> topics});
}
