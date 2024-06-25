import 'package:owod_functionnalities/core/error/server_exception.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/user_model.dart';

abstract interface class AuthRemoteDataSource {
  Session? get currentUserSession;
  Future<UserModel> signUpWithEmailPassword(
      {required String name, required String email, required String password});

  Future<UserModel> loginWithEmailPassword(
      {required String email, required String password});
  Future<UserModel?> getCurrentUserData();
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final SupabaseClient supabaseClient;
  @override
  Session? get currentUserSession => supabaseClient.auth.currentSession;

  AuthRemoteDataSourceImpl(this.supabaseClient);

  @override
  Future<UserModel> loginWithEmailPassword(
      {required String email, required String password}) async {
    try {
      var auth = await supabaseClient.auth
          .signInWithPassword(password: password, email: email);
      if (auth.user == null) {
        throw const ServerException('Authentication failed');
      }
      return UserModel.fromJson(auth.user!.toJson());
    } on AuthException catch (exception) {
      throw const ServerException('Login Failed please Check information');
    }
  }

  @override
  Future<UserModel> signUpWithEmailPassword(
      {required String name,
      required String email,
      required String password}) async {
    try {
      var auth = await supabaseClient.auth
          .signUp(password: password, email: email, data: {'name': name});
      if (auth.user == null) {
        throw const ServerException('Authentication failed');
      }
      return UserModel.fromJson(auth.user!.toJson());
    } on AuthException catch (exception) {
      throw ServerException(exception.message);
    }
  }

  @override
  Future<UserModel?> getCurrentUserData() async {
    try {
      if (currentUserSession != null) {
        final userData = await supabaseClient
            .from('profiles')
            .select()
            .eq('id', currentUserSession!.user.id);
        if (userData.isNotEmpty) {
          return UserModel.fromJson(userData.first);
        }
      }
    } catch (e) {
      throw ServerException(e.toString());
    }
    return null;
  }
}
