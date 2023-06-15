import 'package:code_chronicles/core/enums/notification_type_enum.dart';

class Notification {
  final String text;
  final String postId;
  final String commentId;
  final String id;
  final String userId;
  final NotificationType notificationType;
  Notification({
    required this.text,
    required this.postId,
    required this.commentId,
    required this.id,
    required this.userId,
    required this.notificationType,
  });

  Notification copyWith({
    String? text,
    String? postId,
    String? commentId,
    String? id,
    String? userId,
    NotificationType? notificationType,
  }) {
    return Notification(
      text: text ?? this.text,
      postId: postId ?? this.postId,
      commentId: commentId ?? this.commentId,
      id: id ?? this.id,
      userId: userId ?? this.userId,
      notificationType: notificationType ?? this.notificationType,
    );
  }

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'text': text});
    result.addAll({'postId': postId});
    result.addAll({'commentId': commentId});
    result.addAll({'userId': userId});
    result.addAll({'notificationType': notificationType.type});

    return result;
  }

  factory Notification.fromMap(Map<String, dynamic> map) {
    return Notification(
      text: map['text'] ?? '',
      postId: map['postId'] ?? '',
      commentId: map['commentId'] ?? '',
      id: map['\$id'] ?? '',
      userId: map['userId'] ?? '',
      notificationType:
          (map['notificationType'] as String).toNotificationTypeEnum(),
    );
  }

  @override
  String toString() {
    return 'Notification(text: $text, postId: $postId, commentId: $commentId, id: $id, userId: $userId, notificationType: $notificationType)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Notification &&
        other.text == text &&
        other.postId == postId &&
        other.commentId == commentId &&
        other.id == id &&
        other.userId == userId &&
        other.notificationType == notificationType;
  }

  @override
  int get hashCode {
    return text.hashCode ^
        postId.hashCode ^
        commentId.hashCode ^
        id.hashCode ^
        userId.hashCode ^
        notificationType.hashCode;
  }
}