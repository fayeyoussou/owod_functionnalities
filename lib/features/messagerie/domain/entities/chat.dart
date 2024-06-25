import 'dart:core';

import 'message.dart';

class Chat {
  final String? id;
  final String userId;
  final DateTime createdAt;

  final List<Message> messages;

  Chat({required this.id, required this.userId, required this.createdAt,required this.messages});
}