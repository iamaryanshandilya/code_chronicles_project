import 'dart:io';
import 'package:code_chronicles/apis/post_api.dart';
import 'package:code_chronicles/apis/storage_api.dart';
import 'package:code_chronicles/apis/user_api.dart';
import 'package:code_chronicles/core/core.dart';
import 'package:code_chronicles/core/enums/notification_type_enum.dart';
import 'package:code_chronicles/features/notifications/controller/notification_controller.dart';
import 'package:code_chronicles/models/document_model.dart';
import 'package:code_chronicles/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


final userProfileControllerProvider =
    StateNotifierProvider<UserProfileController, bool>((ref) {
  return UserProfileController(
    DocumentModelAPI: ref.watch(documentModelAPIProvider),
    storageAPI: ref.watch(storageAPIProvider),
    userAPI: ref.watch(userAPIProvider),
    notificationController: ref.watch(notificationControllerProvider.notifier),
  );
});

final getUserDocumentModelsProvider = FutureProvider.family((ref, String uid) async {
  final userProfileController =
      ref.watch(userProfileControllerProvider.notifier);
  return userProfileController.getUserDocumentModels(uid);
});

final getLatestUserProfileDataProvider = StreamProvider((ref) {
  final userAPI = ref.watch(userAPIProvider);
  return userAPI.getLatestUserProfileData();
});

class UserProfileController extends StateNotifier<bool> {
  final DocumentModelAPI _documentModelAPI;
  final StorageAPI _storageAPI;
  final UserAPI _userAPI;
  final NotificationController _notificationController;
  UserProfileController({
    required DocumentModelAPI DocumentModelAPI,
    required StorageAPI storageAPI,
    required UserAPI userAPI,
    required NotificationController notificationController,
  })  : _documentModelAPI = DocumentModelAPI,
        _storageAPI = storageAPI,
        _userAPI = userAPI,
        _notificationController = notificationController,
        super(false);

  Future<List<DocumentModel>> getUserDocumentModels(String uid) async {
    final DocumentModels = await _documentModelAPI.getDocumentModelsByAUser(uid);
    return DocumentModels.map((e) => DocumentModel.fromMap(e.data)).toList();
  }

  void updateUserProfile({
    required UserModel userModel,
    required BuildContext context,
    required File? profileFile,
  }) async {
    state = true;

    if (profileFile != null) {
      final profileUrl = await _storageAPI.uploadFile(profileFile);
      userModel = userModel.copyWith(
        profilePicture: profileUrl,
      );
    }

    final res = await _userAPI.updateUserData(userModel);
    state = false;
    res.fold(
      (l) => showSnackBar(context, l.message),
      (r) => Navigator.pop(context),
    );
  }

  void followUser({
    required UserModel user,
    required BuildContext context,
    required UserModel currentUser,
  }) async {
    // already following
    if (currentUser.following.contains(user.userId)) {
      user.followers.remove(currentUser.userId);
      currentUser.following.remove(user.userId);
    } else {
      user.followers.add(currentUser.userId);
      currentUser.following.add(user.userId);
    }

    user = user.copyWith(followers: user.followers);
    currentUser = currentUser.copyWith(
      following: currentUser.following,
    );

    final res = await _userAPI.followUser(user);
    res.fold((l) => showSnackBar(context, l.message), (r) async {
      final res2 = await _userAPI.addToFollowing(currentUser);
      res2.fold((l) => showSnackBar(context, l.message), (r) {
        _notificationController.createNotification(
          text: '@${currentUser.userId} started following you!',
          postId: '',
          notificationType: NotificationType.follow,
          commentId: '',
          userId: user.userId,
        );
      });
    });
  }
}