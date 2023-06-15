import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_quill/flutter_quill.dart';

class DocumentModel {
  final String title;
  final String titleImageLink;
  final String authorId;
  final String contentURL;
  // final Delta content;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String id;
  final List<String> topics;
  final int views;
  final List<String> likes;
  final List<String> commentIds;
  DocumentModel({
    required this.title,
    required this.titleImageLink,
    required this.authorId,
    // required this.content,
    required this.contentURL,
    required this.createdAt,
    required this.updatedAt,
    required this.id,
    required this.topics,
    required this.views,
    required this.likes,
    required this.commentIds,
  });

  DocumentModel copyWith({
    String? title,
    String? titleImageLink,
    String? authorId,
    String? contentURL,
    Delta? content,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? id,
    List<String>? topics,
    int? views,
    List<String>? likes,
    List<String>? commentIds,
  }) {
    return DocumentModel(
      title: title ?? this.title,
      titleImageLink: titleImageLink ?? this.titleImageLink,
      authorId: authorId ?? this.authorId,
      contentURL: contentURL ?? this.contentURL,
      // content: content ?? this.content,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      id: id ?? this.id,
      topics: topics ?? this.topics,
      views: views ?? this.views,
      likes: likes ?? this.likes,
      commentIds: commentIds ?? this.commentIds,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'titleImageLink': titleImageLink,
      'authorId': authorId,
      'contentURL': contentURL,
      // 'content': jsonEncode(content.toJson()),
      'createdAt': createdAt.millisecondsSinceEpoch,
      'updatedAt': updatedAt.millisecondsSinceEpoch,
      // 'id': id,
      'topics': topics,
      'views': views,
      'likes': likes,
      'commentIds': commentIds,
    };
  }

  factory DocumentModel.fromMap(Map<String, dynamic> map) {
    final contentJson =
        (map['content'] == null) ? [] : jsonDecode(map['content']);
    return DocumentModel(
      title: map['title'] ?? '',
      titleImageLink: map['titleImageLink'] ?? '',
      authorId: map['authorId'] ?? '',
      contentURL: map['contentURL'] ?? '',
      // content: Delta.fromJson(contentJson),
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['createdAt']),
      updatedAt: DateTime.fromMillisecondsSinceEpoch(map['updatedAt']),
      id: map['\$id'] ?? '',
      topics: List<String>.from(map['topics']),
      views: map['views']?.toInt() ?? 0,
      likes: List<String>.from(map['likes']),
      commentIds: List<String>.from(map['commentIds']),
    );
  }

  String toJson() => json.encode(toMap());

  factory DocumentModel.fromJson(String source) =>
      DocumentModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'DocumentModel(title: $title, titleImageLink: $titleImageLink, authorId: $authorId, contentURL: $contentURL, createdAt: $createdAt, updatedAt: $updatedAt, id: $id, topics: $topics, views: $views, likes: $likes, commentIds: $commentIds)';
  }

  // @override
  // List<Object?> get props => [title, content];

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is DocumentModel &&
      other.title == title &&
      other.titleImageLink == titleImageLink &&
      other.authorId == authorId &&
      // other.content == content &&
      other.contentURL == contentURL &&
      other.createdAt == createdAt &&
      other.updatedAt == updatedAt &&
      other.id == id &&
      listEquals(other.topics, topics) &&
      other.views == views &&
      listEquals(other.likes, likes) &&
      listEquals(other.commentIds, commentIds);
  }

  @override
  int get hashCode {
    return title.hashCode ^
      titleImageLink.hashCode ^
      authorId.hashCode ^
      contentURL.hashCode ^
      // content.hashCode ^
      createdAt.hashCode ^
      updatedAt.hashCode ^
      id.hashCode ^
      topics.hashCode ^
      views.hashCode ^
      likes.hashCode ^
      commentIds.hashCode;
  }
}
