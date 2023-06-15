import 'package:flutter/foundation.dart';

@immutable
class UserModel {
  final String email;
  final String name;
  final List<String> followers;
  final List<String> following;
  final List<String> interests;
  final String profilePicture;
  final String bannerPicture;
  final String userId;
  final String bio;
  const UserModel({
    required this.email,
    required this.name,
    required this.followers,
    required this.following,
    required this.interests,
    required this.profilePicture,
    required this.bannerPicture,
    required this.userId,
    required this.bio,
  });

  UserModel copyWith({
    String? email,
    String? name,
    List<String>? followers,
    List<String>? following,
    List<String>? interests,
    String? profilePicture,
    String? bannerPicture,
    String? userId,
    String? bio,
  }) {
    return UserModel(
      email: email ?? this.email,
      name: name ?? this.name,
      followers: followers ?? this.followers,
      following: following ?? this.following,
      interests: interests ?? this.interests,
      profilePicture: profilePicture ?? this.profilePicture,
      bannerPicture: bannerPicture ?? this.bannerPicture,
      userId: userId ?? this.userId,
      bio: bio ?? this.bio,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'name': name,
      'followers': followers,
      'following': following,
      'interests': interests,
      'profilePicture': profilePicture,
      'bannerPicture': bannerPicture,
      'bio': bio,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      email: map['email'] ?? '',
      name: map['name'] ?? '',
      followers: List<String>.from(map['followers']),
      following: List<String>.from(map['following']),
      interests: List<String>.from(map['interests']),
      profilePicture: map['profilePicture'] ?? '',
      bannerPicture: map['bannerPicture'] ?? '',
      userId: map['\$id'] ?? '',
      bio: map['bio'] ?? '',
    );
  }

  // String toJson() => json.encode(toMap());

  // factory UserModel.fromJson(String source) =>
  //     UserModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'UserModel(email: $email, name: $name, followers: $followers, following: $following, interests: $interests, profilePicture: $profilePicture, bannerPicture: $bannerPicture, userId: $userId, bio: $bio)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is UserModel &&
        other.email == email &&
        other.name == name &&
        listEquals(other.followers, followers) &&
        listEquals(other.following, following) &&
        listEquals(other.interests, interests) &&
        other.profilePicture == profilePicture &&
        other.bannerPicture == bannerPicture &&
        other.userId == userId &&
        other.bio == bio;
  }

  @override
  int get hashCode {
    return email.hashCode ^
        name.hashCode ^
        followers.hashCode ^
        following.hashCode ^
        interests.hashCode ^
        profilePicture.hashCode ^
        bannerPicture.hashCode ^
        userId.hashCode ^
        bio.hashCode;
  }

}
