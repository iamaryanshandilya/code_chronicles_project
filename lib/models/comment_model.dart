import 'package:flutter/foundation.dart';
import 'package:code_chronicles/core/enums/comment_type_enum.dart';

@immutable
class Comment {
  final String text;
  final String authorId;
  final CommentType commentType;
  final DateTime createdAt;
  final String id;
  final List<String> likes;
  final List<String> replies;
  final String parentPostId;
  final String parentCommentId;
  const Comment({
    required this.text,
    required this.authorId,
    required this.commentType,
    required this.createdAt,
    required this.id,
    required this.likes,
    required this.replies,
    required this.parentPostId,
    required this.parentCommentId,
  });

  Comment copyWith({
    String? text,
    String? authorId,
    CommentType? commentType,
    DateTime? createdAt,
    String? id,
    List<String>? likes,
    List<String>? replies,
    String? parentPostId,
    String? parentCommentId,
  }) {
    return Comment(
      text: text ?? this.text,
      authorId: authorId ?? this.authorId,
      commentType: commentType ?? this.commentType,
      createdAt: createdAt ?? this.createdAt,
      id: id ?? this.id,
      likes: likes ?? this.likes,
      replies: replies ?? this.replies,
      parentPostId: parentPostId ?? this.parentPostId,
      parentCommentId: parentCommentId ?? this.parentCommentId,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'text': text,
      'authorId': authorId,
      'commentType': commentType.type,
      'createdAt': createdAt.millisecondsSinceEpoch,
      // 'id': id,
      'likes': likes,
      'replies': replies,
      'parentPostId': parentPostId,
      'parentCommentId': parentCommentId,
    };
  }

  factory Comment.fromMap(Map<String, dynamic> map) {
    return Comment(
      text: map['text'] ?? '',
      authorId: map['authorId'] ?? '',
      commentType: (map['commentType'] as String).toCommentTypeEnum(),
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['createdAt']),
      id: map['\$id'] ?? '',
      likes: List<String>.from(map['likes']),
      replies: List<String>.from(map['replies']),
      parentPostId: map['parentPostId'] ?? '',
      parentCommentId: map['parentCommentId'] ?? '',
    );
  }

  @override
  String toString() {
    return 'Comment(text: $text, authorId: $authorId, commentType: $commentType, createdAt: $createdAt, id: $id, likes: $likes, replies: $replies, parentPostId: $parentPostId, parentCommentId: $parentCommentId)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is Comment &&
      other.text == text &&
      other.authorId == authorId &&
      other.commentType == commentType &&
      other.createdAt == createdAt &&
      other.id == id &&
      listEquals(other.likes, likes) &&
      listEquals(other.replies, replies) &&
      other.parentPostId == parentPostId &&
      other.parentCommentId == parentCommentId;
  }

  @override
  int get hashCode {
    return text.hashCode ^
      authorId.hashCode ^
      commentType.hashCode ^
      createdAt.hashCode ^
      id.hashCode ^
      likes.hashCode ^
      replies.hashCode ^
      parentPostId.hashCode ^
      parentCommentId.hashCode;
  }

}
