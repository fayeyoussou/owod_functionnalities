import 'package:get_it/get_it.dart';
import 'package:owod_functionnalities/core/common/cubits/menu/menu_cubit.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'core/common/cubits/app_user/app_user_cubit.dart';
import 'core/secrets/app_secrets.dart';
import 'features/auth/data/datasources/auth_remote_data_source.dart';
import 'features/auth/data/repositories/auth_repository.dart';
import 'features/auth/domain/repositories/auth_repository.dart';
import 'features/auth/domain/usecases/current_user.dart';
import 'features/auth/domain/usecases/user_login.dart';
import 'features/auth/domain/usecases/user_sign_up.dart';
import 'features/auth/presentation/bloc/auth_bloc.dart';
import 'features/blog/data/datasources/blog_remote_data_source.dart';
import 'features/blog/data/repositories/blog_repository_impl.dart';
import 'features/blog/domain/repositories/blog_repository.dart';
import 'features/blog/domain/usecases/upload_blog.dart';
import 'features/blog/presentation/bloc/blog_bloc.dart';
import 'features/messagerie/data/datasources/messagerie_remote_datasource.dart';
import 'features/messagerie/data/repositories/messagerie_repository_impl.dart';
import 'features/messagerie/domain/repositories/messagerie_repository.dart';
import 'features/messagerie/domain/usecases/create_message.dart';
import 'features/messagerie/domain/usecases/load_chat.dart';
import 'features/messagerie/domain/usecases/load_chat_list.dart';
import 'features/messagerie/presentation/bloc/message_bloc.dart';

final serviceLocator = GetIt.instance;

Future<void> initDependencies() async {
  _initAuth();
  _initBlog();
  _initMessagerie();
  final supabase = await Supabase.initialize(
      url: AppSecrets.supaBaseUrl, anonKey: AppSecrets.supaBaseKey);
  serviceLocator.registerLazySingleton<SupabaseClient>(() => supabase.client);
  serviceLocator.registerLazySingleton<AppUserCubit>(() => AppUserCubit());
  serviceLocator.registerLazySingleton<MenuCubit>(()=>MenuCubit());
}

void _initAuth() {
  serviceLocator
    // datasource
    ..registerFactory<AuthRemoteDataSource>(
      () => AuthRemoteDataSourceImpl(
        serviceLocator<SupabaseClient>(),
      ),
    )
    // Repository
    ..registerFactory<AuthRepository>(
      () => AuthRepositoryImpl(
        serviceLocator<AuthRemoteDataSource>(),
      ),
    )
    // Use cases
    ..registerFactory<UserSignUp>(
      () => UserSignUp(
        serviceLocator<AuthRepository>(),
      ),
    )
    ..registerFactory<UserLogin>(
      () => UserLogin(
        serviceLocator<AuthRepository>(),
      ),
    )
    ..registerFactory<CurrentUser>(
      () => CurrentUser(
        serviceLocator<AuthRepository>(),
      ),
    )
    // Bloc
    ..registerLazySingleton<AuthBloc>(
      () => AuthBloc(
          userSignUp: serviceLocator<UserSignUp>(),
          userLogin: serviceLocator<UserLogin>(),
          currentUser: serviceLocator<CurrentUser>(),
          appUserCubit: serviceLocator<AppUserCubit>()),
    );
}

void _initBlog() {
  serviceLocator
    // datasource
    ..registerFactory<BlogRemoteDataSource>(
      () => BlogRemoteDataSourceImpl(
        serviceLocator<SupabaseClient>(),
      ),
    )
    ..registerFactory<BlogRepository>(
        () => BlogRepositoryImpl(serviceLocator<BlogRemoteDataSource>()))
    ..registerFactory<UploadBlog>(
        () => UploadBlog(serviceLocator<BlogRepository>()))
    ..registerLazySingleton<BlogBloc>(
        () => BlogBloc(uploadBlog: serviceLocator<UploadBlog>()));
}

void _initMessagerie() {
  serviceLocator
    //datasource
    ..registerFactory<MessagerieDatasource>(
        () => MessagerieRemoteDatasourceImpl(
              serviceLocator<SupabaseClient>(),
            ))
    // repository
    ..registerFactory<MessagerieRepository>(
      () => MessagerieRepositoryImpl(
        serviceLocator<MessagerieDatasource>(),
      ),
    )
    // usecases
    ..registerFactory<CreateMessage>(
      () => CreateMessage(
        serviceLocator<MessagerieRepository>(),
      ),
    )
    ..registerFactory<LoadChat>(
      () => LoadChat(
        serviceLocator<MessagerieRepository>(),
      ),
    )
    ..registerFactory<LoadChatList>(
      () => LoadChatList(
        serviceLocator<MessagerieRepository>(),
      ),
    )
    // blocs
    ..registerLazySingleton<MessageBloc>(
      () => MessageBloc(
        createMessage: serviceLocator<CreateMessage>(),
        loadChat: serviceLocator<LoadChat>(),
        loadChatList: serviceLocator<LoadChatList>(),
      ),
    );
}
