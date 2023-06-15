import 'package:code_chronicles/common/custom_loader.dart';
import 'package:code_chronicles/common/error_page.dart';
import 'package:code_chronicles/core/enums/comment_type_enum.dart';
import 'package:code_chronicles/features/post/controller/post_controller.dart';
import 'package:code_chronicles/features/post/widgets/comment_tiles.dart';
import 'package:code_chronicles/models/comment_model.dart';
import 'package:code_chronicles/models/document_model.dart';
import 'package:code_chronicles/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CommentList extends ConsumerWidget {
  final DocumentModel documentModel;
  const CommentList({super.key, required this.documentModel});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ref.watch(getCommentProvider(documentModel)).when(
          data: (comments) {
            // print(comments);
            final topLevelComments = <Comment>[];

            for (final comment in comments) {
              if (comment.commentType == CommentType.comment) {
                topLevelComments.add(comment);
              }
            }

            return ConstrainedBox(
              constraints: BoxConstraints(
                  maxHeight: MediaQuery.of(context).size.height * 0.5),
              child: ListView.builder(
                  // itemCount: comments.length,
                  itemCount: topLevelComments.length,
                  itemBuilder: (BuildContext context, index) {
                    final comment = topLevelComments[index];
                    final replies = comments
                        .where((c) =>
                            c.commentType == CommentType.reply_to_comment &&
                            c.parentCommentId == comment.id)
                        .toList();
                    return CommentsWithRepliesWidget(
                      commentModel: comment,
                      replies: replies,
                      documentModel: documentModel,
                    );
                  }),
            );
            return ref.watch(getLatestCommentProvider).when(
                  data: (data) {
                    if (data.events.contains(
                        'databases.*.collections.${AppwriteConstants.commentsCollectionId}.documents.*.create')) {
                      print(
                          '++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++');
                      comments.insert(0, Comment.fromMap(data.payload));
                    } else if (data.events.contains(
                        'databases.*.collections.${AppwriteConstants.commentsCollectionId}.documents.*.update')) {
                      print(
                          '--------------------------------------------------------------------------------------');
                      final startingPoint =
                          data.events[0].lastIndexOf('documents.');

                      final endPoint = data.events[0].lastIndexOf('.update');

                      final commentId = data.events[0]
                          .substring(startingPoint + 10, endPoint);

                      var comment = comments
                          .where((element) => element.id == commentId)
                          .first;
                      final commentIndex = comments.indexOf(comment);
                      comments
                          .removeWhere((element) => element.id == comment.id);

                      comment = Comment.fromMap(data.payload);
                      comments.insert(commentIndex, comment);
                    }
                    final topLevelComments = <Comment>[];

                    for (final comment in comments) {
                      if (comment.commentType == CommentType.comment) {
                        topLevelComments.add(comment);
                      }
                    }

                    return ConstrainedBox(
                      constraints: BoxConstraints(
                          maxHeight: MediaQuery.of(context).size.height * 0.5),
                      child: ListView.builder(
                          // itemCount: comments.length,
                          itemCount: topLevelComments.length,
                          itemBuilder: (BuildContext context, index) {
                            final comment = topLevelComments[index];
                            final replies = comments
                                .where((c) =>
                                    c.commentType ==
                                        CommentType.reply_to_comment &&
                                    c.parentCommentId == comment.id)
                                .toList();
                            return CommentsWithRepliesWidget(
                              commentModel: comment,
                              replies: replies,
                              documentModel: documentModel,
                            );
                          }),
                    );
                  },
                  error: (error, stackTrace) => ErrorText(
                    error: error.toString(),
                  ),
                  loading: () {
                    final topLevelComments = <Comment>[];

                    for (final comment in comments) {
                      if (comment.commentType == CommentType.comment) {
                        // commentMap[comment.id] = [];
                        topLevelComments.add(comment);
                      }
                    }

                    return ConstrainedBox(
                      constraints: BoxConstraints(
                          maxHeight: MediaQuery.of(context).size.height * 0.5),
                      child: ListView.builder(
                          // itemCount: comments.length,
                          itemCount: topLevelComments.length,
                          itemBuilder: (BuildContext context, index) {
                            final comment = topLevelComments[index];
                            final replies = comments
                                .where((c) =>
                                    c.commentType ==
                                        CommentType.reply_to_comment &&
                                    c.parentCommentId == comment.id)
                                .toList();
                            return CommentsWithRepliesWidget(
                              commentModel: comment,
                              replies: replies,
                              documentModel: documentModel,
                            );
                          }),
                    );
                  },
                );
          },
          error: (error, stackTrace) => ErrorText(
            error: error.toString(),
          ),
          loading: () => const Center(
            child: LoadingIndicator(),
          ),
        );
  }
}
