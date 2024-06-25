
import '../../domain/entities/chat.dart';
import '../../domain/entities/message.dart';
import 'message_model.dart';



class ChatModel extends Chat {
   ChatModel({
    required super.id,
    required super.userId,
    required super.createdAt,
     required super.messages
  });

  factory ChatModel.fromJson(Map<String, dynamic> json) {
    return ChatModel(
      id: json['id'],
      userId: json['user_id'],
      createdAt: DateTime.parse(json['created_at'],),
      messages: [],
    );
  }


  Map<String, dynamic> toJson() {
    return {

      'user_id': userId,
      'created_at': createdAt.toIso8601String(),
    };
  }

  ChatModel copyWith({
    String? id,
    String? userId,
    DateTime? createdAt,
    List<MessageModel>? messages
  }) {
    return ChatModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      createdAt: createdAt ?? this.createdAt,
      messages: messages ?? this.messages
    );
  }

  @override
  String toString() {
    return 'ChatModel{id: $id, userId: $userId, createdAt: $createdAt}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ChatModel && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
