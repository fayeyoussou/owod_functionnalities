import 'dart:io';

import 'package:owod_functionnalities/features/blog/domain/entities/blog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fpdart/fpdart.dart';

import '../../../../core/error/failure.dart';
import '../../../messagerie/data/models/chat_model.dart';
import '../../domain/usecases/upload_blog.dart';

part 'blog_event.dart';
part 'blog_state.dart';

class BlogBloc extends Bloc<BlogEvent, BlogState> {
  final UploadBlog _uploadBlog;

  BlogBloc({required UploadBlog uploadBlog})
      : _uploadBlog = uploadBlog,
        super(BlogInitial()) {
    on<BlogEvent>((event, emit) async {
      // Ensuring the bloc is not closed before emitting a new state
      if (!emit.isDone) {
        emit(BlogLoading());
      }
    });

    on<BlogUploading>((event, emit) async {
      // Using async-await to handle the future returned by _performAuthAction
      await _performAuthAction(
          () => _uploadBlog(UploadBlogParams(
                posterId: event.posterId,
                title: event.title,
                content: event.content,
                image: event.image,
                topics: event.topics,
              )),
          emit);
    });
  }

  Future<void> _performAuthAction(
      Future<Either<Failure, Blog>> Function() action,
      Emitter<BlogState> emit) async {
    final res = await action();
    res.fold(
      (failure) {
        // Checking if the bloc is not closed before emitting a new state
        if (!emit.isDone) {
          emit(BlogFailure(failure.message));
        }
      },
      (blog) {
        // Checking if the bloc is not closed before emitting a new state
        if (!emit.isDone) {
          emit(BlogSuccess());
        }
      },
    );
  }
}
