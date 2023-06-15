import 'package:code_chronicles/common/custom_loader.dart';
import 'package:code_chronicles/common/error_page.dart';
import 'package:code_chronicles/features/auth/controller/auth_controller.dart';
import 'package:code_chronicles/features/post/controller/post_controller.dart';
import 'package:code_chronicles/features/post/views/post_details.dart';
import 'package:code_chronicles/features/user_profile/views/user_profile_view.dart';
import 'package:flutter/material.dart';
import 'package:code_chronicles/models/document_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:like_button/like_button.dart';
import 'package:timeago/timeago.dart' as timeago;

class PostTile extends ConsumerWidget {
  final DocumentModel documentModel;
  const PostTile({super.key, required this.documentModel});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUser = ref.watch(loggedInUserDetailsProvider).value;

    return currentUser == null
        ? const SizedBox()
        : ref.watch(userDetailsProvider(documentModel.authorId)).when(
              data: (user) {
                return Padding(
                  padding: const EdgeInsets.fromLTRB(0.8, 0.5, 0.8, 0.5),
                  child: Container(
                    width: 700,
                    height: documentModel.titleImageLink.isNotEmpty ? 207 : 180,
                    child: Card(
                      elevation: 5,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  documentModel.topics.length > 1
                                      ? '${documentModel.topics[0]} + ${documentModel.topics.length - 1} more'
                                      : documentModel.topics[0],
                                  style: const TextStyle(
                                      color: Colors.black38,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 16.0),
                                ),
                                // Icon(Icons.more_horiz_outlined),
                                Icon(
                                  Icons.more_vert_outlined,
                                  color: Colors.black87.withOpacity(0.7),
                                ),
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(
                                  0.0, 12.0, 0.0, 12.0),
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    PostDetails.route(documentModel),
                                  );
                                },
                                child: Container(
                                  color: Colors.transparent,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Flexible(
                                        flex: 3,
                                        child: Text(
                                          documentModel.title,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 17.0,
                                          ),
                                        ),
                                      ),
                                      if (documentModel
                                          .titleImageLink.isNotEmpty)
                                        Flexible(
                                          flex: 1,
                                          child: documentModel
                                                  .titleImageLink.isNotEmpty
                                              ? Container(
                                                  height: 70.0,
                                                  width: 70.0,
                                                  child: Image.network(
                                                    documentModel
                                                        .titleImageLink,
                                                    fit: BoxFit.cover,
                                                  ))
                                              : const SizedBox(),
                                        ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                              context,
                                              UserProfileView.route(user),
                                            );
                                      },
                                      child: Text(
                                        'by @${documentModel.authorId}',
                                        style: const TextStyle(
                                          fontSize: 16.0,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                    ),
                                    Text(
                                      // '${documentModel.createdAt.day}.${documentModel.createdAt.month}.${documentModel.createdAt.year}',
                                      ' · ${timeago.format(
                                        documentModel.createdAt,
                                        locale: 'en',
                                      )}',
                                      style: const TextStyle(
                                        color: Colors.black45,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    )
                                  ],
                                ),
                                Row(
                                  children: [
                                    LikeButton(
                                      size: 20,
                                      onTap: (isLiked) async {
                                        ref
                                            .read(
                                                postControllerProvider.notifier)
                                            .likePost(
                                              documentModel,
                                              currentUser,
                                            );
                                        return !isLiked;
                                      },
                                      isLiked: documentModel.likes
                                          .contains(currentUser.userId),
                                      likeBuilder: (isLiked) {
                                        return isLiked
                                            ? const Icon(
                                                Icons.favorite_rounded,
                                                color: Colors.red,
                                              )
                                            : const Icon(
                                                Icons.favorite_border_rounded,
                                                color: Colors.black45,
                                              );
                                      },
                                      likeCount: documentModel.likes.length,
                                      countBuilder: (likeCount, isLiked, text) {
                                        return Padding(
                                          padding:
                                              const EdgeInsets.only(left: 2.0),
                                          child: Text(
                                            text,
                                            style: TextStyle(
                                              color: isLiked
                                                  ? Colors.red
                                                  : Colors.black45,
                                              fontSize: 16,
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    GestureDetector(
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            PostDetails.route(documentModel),
                                          );
                                        },
                                        child: const Icon(
                                          Icons.mode_comment_outlined,
                                          color: Colors.black45,
                                        )),
                                    const SizedBox(
                                      width: 2,
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          PostDetails.route(documentModel),
                                        );
                                      },
                                      child: Text(
                                        '${documentModel.commentIds.length}',
                                        style: TextStyle(color: Colors.black45),
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    // Icon(Icons.bookmark_border),
                                  ],
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
              error: (error, stackTrace) => ErrorText(
                error: error.toString(),
              ),
              loading: () => const StackLoader(),
            );
  }
}
