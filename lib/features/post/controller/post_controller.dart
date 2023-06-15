import 'dart:io';
import 'package:appwrite/appwrite.dart';
import 'package:code_chronicles/apis/post_api.dart';
import 'package:code_chronicles/apis/storage_api.dart';
import 'package:code_chronicles/core/core.dart';
import 'package:code_chronicles/core/enums/comment_type_enum.dart';
import 'package:code_chronicles/core/enums/notification_type_enum.dart';
import 'package:code_chronicles/core/enums/post_type_enum.dart';
import 'package:code_chronicles/features/home/views/home_view.dart';
import 'package:code_chronicles/models/comment_model.dart';
import 'package:code_chronicles/models/document_model.dart';
import 'package:code_chronicles/models/post_model.dart';
// import 'package:code_chronicles/models/comment_model.dart';
import 'package:code_chronicles/models/user_model.dart';
import 'package:code_chronicles/features/auth/controller/auth_controller.dart';
import 'package:code_chronicles/features/notifications/controller/notification_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';

final postControllerProvider =
    StateNotifierProvider<PostController, bool>((ref) {
  return PostController(
    ref: ref,
    documentModelAPI: ref.watch(documentModelAPIProvider),
    storageAPI: ref.watch(storageAPIProvider),
    notificationController: ref.watch(notificationControllerProvider.notifier),
  );
});

final getPostProvider = FutureProvider((ref) async {
  final postController = ref.watch(postControllerProvider.notifier);
  return postController.getPostList();
});

final getPostByIdProvider = FutureProvider.family((ref, String id) async {
  final postController = ref.watch(postControllerProvider.notifier);
  return postController.getPostById(id);
});

final getCommentProvider =
    FutureProvider.family((ref, DocumentModel documentModel) async {
  final postController = ref.watch(postControllerProvider.notifier);
  return postController.getCommentList(documentModel);
});

// final getPostsByHashtagsProvider = FutureProvider.family((ref, String hashtags) async {
//   final postController = ref.watch(postControllerProvider.notifier);
//   return postController.getAllPostsByHashtag(hashtags);
// });

final getLatestPostProvider = StreamProvider((ref) {
  final postAPI = ref.watch(documentModelAPIProvider);
  return postAPI.getLatestDocumentModel();
});

final getLatestCommentProvider = StreamProvider((ref) {
  final postAPI = ref.watch(documentModelAPIProvider);
  return postAPI.getLatestCommentModel();
});

class PostController extends StateNotifier<bool> {
  final DocumentModelAPI _documentModelAPI;
  final StorageAPI _storageAPI;
  final NotificationController _notificationController;
  final Ref _ref;

  PostController({
    required Ref ref,
    required DocumentModelAPI documentModelAPI,
    required StorageAPI storageAPI,
    required NotificationController notificationController,
  })  : _ref = ref,
        _documentModelAPI = documentModelAPI,
        _storageAPI = storageAPI,
        _notificationController = notificationController,
        super(false);

  Future<List<DocumentModel>> getPostList() async {
    final postList = await _documentModelAPI.getDocumentModels();
    return postList.map((post) => DocumentModel.fromMap(post.data)).toList();
  }

  Future<List<Comment>> getCommentList(DocumentModel documentModel) async {
    print('ewfefwew');
    final commentList = await _documentModelAPI.getCommentModels(documentModel);
    print('ewrfewfewwefewffew');
    return commentList.map((comment) => Comment.fromMap(comment.data)).toList();
  }

  void likePost(DocumentModel post, UserModel user) async {
    List<String> likes = post.likes;
    if (post.likes.contains(user.userId)) {
      likes.remove(user.userId);
    } else {
      likes.add(user.userId);
    }

    post = post.copyWith(likes: likes);
    final res = await _documentModelAPI.likeDocumentModel(post);
    res.fold(
      (l) => null,
      (r) {
        if (post.authorId != user.userId) {
          _notificationController.createNotification(
            text: '${user.userId} liked your post',
            postId: post.id,
            commentId: '',
            userId: post.authorId,
            notificationType: NotificationType.like,
          );
        }
      },
    );
  }

  void likeComment(Comment comment, UserModel user) async {
    List<String> likes = comment.likes;
    if (comment.likes.contains(user.userId)) {
      likes.remove(user.userId);
    } else {
      likes.add(user.userId);
    }

    comment = comment.copyWith(likes: likes);
    final res = await _documentModelAPI.likeComment(comment);
    res.fold(
      (l) => null,
      (r) {
        if (comment.authorId != user.userId) {
          _notificationController.createNotification(
            text: '${user.userId} liked your comment',
            postId: comment.id,
            commentId: '',
            userId: comment.authorId,
            notificationType: NotificationType.like,
          );
        }
      },
    );
  }

  void updateCommentCounts(DocumentModel post, UserModel user) async {
    List<String> commentIds = post.commentIds;
    print(commentIds);

    commentIds.add(user.userId);
    print(commentIds);

    post = post.copyWith(commentIds: commentIds);
    final res = await _documentModelAPI.updateCommentCount(post);
    res.fold(
      (l) => null,
      (r) {},
    );
  }

  void sharePost({
    required File? coverImage,
    required String title,
    required String contentAsJson,
    required List<String>? topics,
    required BuildContext context,
  }) {
    if (title.isEmpty) {
      showSnackBar(context, 'The title field cannot be empty');
      return;
    }
    if (coverImage != null) {
      _sharePostWithImage(
        coverImage: coverImage,
        title: title,
        contentAsJson: contentAsJson,
        topics: topics,
        context: context,
      );
    } else {
      _sharePostWithoutImage(
        title: title,
        contentAsJson: contentAsJson,
        topics: topics,
        context: context,
      );
    }
  }

  void _sharePostWithImage({
    required File? coverImage,
    required String title,
    required String contentAsJson,
    required List<String>? topics,
    required BuildContext context,
  }) async {
    state = true;

    final user = _ref.read(loggedInUserDetailsProvider).value!;

    var uuid = Uuid();

    var v1Exact = uuid.v1(options: {
      'node': [0x01, 0x23, 0x45, 0x67, 0x89, 0xab],
      'clockSeq': 0x1234,
      'mSecs': DateTime.utc(2011, 11, 01).millisecondsSinceEpoch,
      'nSecs': 5678
    });

    String contentURL = '';

    try {
      final directory = await getTemporaryDirectory();
      final file = File('${directory.path}/$v1Exact.json');
      await file.writeAsString(contentAsJson);
      contentURL = await _storageAPI.uploadFile(file);
    } catch (e, stackTrace) {
      state = false;
      showSnackBar(context, 'Something went wrong please try again later');
      return;
    }

    final titleImageLink = await _storageAPI.uploadFile(coverImage!);

    DocumentModel doc = DocumentModel(
      title: title,
      titleImageLink: titleImageLink,
      authorId: user.userId,
      contentURL: contentURL,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      id: '',
      topics: topics ?? [],
      views: 0,
      likes: [],
      commentIds: [],
    );
    final res = await _documentModelAPI.shareDocumentModel(doc);
    state = false;
    res.fold((l) => showSnackBar(context, l.message), (r) {
      Navigator.pushAndRemoveUntil(
        context,
        HomeView.route(),
        (route) => false,
      );
    });
  }

  void _sharePostWithoutImage({
    required String title,
    required String contentAsJson,
    required List<String>? topics,
    required BuildContext context,
  }) async {
    state = true;

    final user = _ref.read(loggedInUserDetailsProvider).value!;

    var uuid = Uuid();

    var v1Exact = uuid.v1(options: {
      'node': [0x01, 0x23, 0x45, 0x67, 0x89, 0xab],
      'clockSeq': 0x1234,
      'mSecs': DateTime.utc(2011, 11, 01).millisecondsSinceEpoch,
      'nSecs': 5678
    });

    String contentURL = '';

    try {
      final directory = await getTemporaryDirectory();
      final file = File('${directory.path}/$v1Exact.json');
      await file.writeAsString(contentAsJson);
      contentURL = await _storageAPI.uploadFile(file);
    } catch (e, stackTrace) {
      print(e);
      state = false;
      showSnackBar(context, 'Something went wrong please try again later');
      return;
    }

    DocumentModel doc = DocumentModel(
      title: title,
      titleImageLink: '',
      authorId: user.userId,
      contentURL: contentURL,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      id: '',
      topics: topics ?? [],
      views: 0,
      likes: [],
      commentIds: [],
    );
    final res = await _documentModelAPI.shareDocumentModel(doc);
    state = false;
    res.fold((l) => showSnackBar(context, l.message), (r) {
      Navigator.pushAndRemoveUntil(
        context,
        HomeView.route(),
        (route) => false,
      );
    });
  }

  void shareComment({
    required String text,
    required String parentPostId,
    required String parentCommentId,
    required String repliedToUserId,
    required BuildContext context,
  }) async {
    state = true;
    final user = _ref.read(loggedInUserDetailsProvider).value!;

    Comment comment = Comment(
      text: text,
      authorId: user.userId,
      commentType: parentCommentId == ''
          ? CommentType.comment
          : CommentType.reply_to_comment,
      createdAt: DateTime.now(),
      likes: const [],
      replies: const [],
      id: '',
      parentCommentId: parentCommentId,
      parentPostId: parentPostId,
    );
    final res = await _documentModelAPI.shareCommentModel(comment);

    res.fold((l) => showSnackBar(context, l.message), (r) {
      if (comment.authorId != user.userId) {
        _notificationController.createNotification(
          text: '${user.userId} commented on your post',
          postId: parentPostId,
          commentId: '',
          userId: repliedToUserId, //todo
          notificationType: NotificationType.comment,
        );
      }
    });
    state = false;
  }

  void shareReplyToAComment({
    required String text,
    required String parentPostId,
    required String parentCommentId,
    required String repliedToUserId,
    required BuildContext context,
  }) async {
    state = true;
    final user = _ref.read(loggedInUserDetailsProvider).value!;

    Comment comment = Comment(
      text: text,
      authorId: user.userId,
      commentType: parentCommentId == ''
          ? CommentType.comment
          : CommentType.reply_to_comment,
      createdAt: DateTime.now(),
      likes: const [],
      replies: const [],
      id: '',
      parentCommentId: parentCommentId,
      parentPostId: parentPostId,
    );
    final res = await _documentModelAPI.shareCommentModel(comment);
    res.fold((l) => showSnackBar(context, l.message), (r) {
      _notificationController.createNotification(
        text: '${user.userId} replied to your comment',
        postId: parentPostId,
        commentId: parentCommentId,
        userId: repliedToUserId, //todo
        notificationType: NotificationType.comment,
      );
    });
    state = false;
  }

  Future<DocumentModel> getPostById(String id) async {
    final tweet = await _documentModelAPI.getPostById(id);
    return DocumentModel.fromMap(tweet.data);
  }

  Future<List<Post>> getAllPostsByHashtag(String topic) async {
    final postList = await _documentModelAPI.getDocumentModelsByTopics(topic);
    return postList.map((post) => Post.fromMap(post.data)).toList();
  }
}
