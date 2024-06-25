import 'package:owod_functionnalities/core/common/entities/user.dart';

class UserModel extends User {
  UserModel({required super.id, required super.email, required super.name});
  factory UserModel.fromJson(Map<String, dynamic> userMap) {
    return UserModel(
        id: userMap['id'] ?? '',
        email: userMap['email'] ?? '',
        name: userMap['name'] ?? '');
  }
}
