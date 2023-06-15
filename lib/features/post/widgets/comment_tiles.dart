import 'package:code_chronicles/common/custom_loader.dart';
import 'package:code_chronicles/common/error_page.dart';
import 'package:code_chronicles/features/auth/controller/auth_controller.dart';
import 'package:code_chronicles/features/post/controller/post_controller.dart';
import 'package:code_chronicles/features/post/views/post_details.dart';
import 'package:code_chronicles/features/user_profile/views/user_profile_view.dart';
import 'package:code_chronicles/models/comment_model.dart';
import 'package:flutter/material.dart';
import 'package:code_chronicles/models/document_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:like_button/like_button.dart';
import 'package:timeago/timeago.dart' as timeago;

class CommentTile extends ConsumerStatefulWidget {
  final Comment commentModel;
  final DocumentModel documentModel;
  const CommentTile(
      {super.key, required this.commentModel, required this.documentModel});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _CommentTileState();
}

class _CommentTileState extends ConsumerState<CommentTile> {
  TextEditingController commentController = TextEditingController(text: '');
  bool showReplyTextField = false;

  onClick() {
    setState(() {
      showReplyTextField = !showReplyTextField;
      commentController.text =
          showReplyTextField ? '@${widget.commentModel.authorId} ' : '';
    });
  }

  void onSubmit() async {
    final currentUser = ref.read(loggedInUserDetailsProvider).value;

    if (commentController.text == '' ||
        commentController.text.isEmpty ||
        commentController.text.endsWith('@${widget.commentModel.authorId} ') ||
        currentUser == null) {
      return;
    }

    ref.read(postControllerProvider.notifier).shareComment(
          text: commentController.text,
          parentPostId: widget.commentModel.parentPostId,
          parentCommentId: widget.commentModel.parentCommentId.isEmpty
              ? widget.commentModel.id
              : widget.commentModel.parentCommentId,
          context: context,
          repliedToUserId: widget.commentModel.authorId,
        );

    ref.read(postControllerProvider.notifier).updateCommentCounts(
          widget.documentModel,
          currentUser,
        );

    final isPosted = ref.watch(postControllerProvider);
    if (isPosted) {
      commentController.text = '';
      setState(() {
        onClick();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(postControllerProvider);
    final currentUser = ref.read(loggedInUserDetailsProvider).value;
    return ref.watch(userDetailsProvider(widget.commentModel.authorId)).when(
          data: (user) {
            return Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 5,
                  ),
                  TextFormField(
                    readOnly: true,
                    enabled: false,
                    autofocus: false,
                    initialValue: // comment
                        widget.commentModel.text,
                    maxLines: null,
                    decoration: InputDecoration(
                      icon: InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            UserProfileView.route(user),
                          );
                        },
                        child: CircleAvatar(
                          radius: 17,
                          backgroundImage: user.profilePicture.isNotEmpty
                              ? NetworkImage(user.profilePicture)
                              : null,
                          child: user.profilePicture.isEmpty
                              ? const Icon(Icons.person_2_outlined)
                              : null,
                        ),
                      ),
                      labelText: widget.commentModel.authorId, // username
                      fillColor: Colors.transparent,
                      border: OutlineInputBorder(
                        borderSide: const BorderSide(
                            color: Color(0xff3E7BFA), width: 2.0),
                        borderRadius: BorderRadius.circular(25.0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                            color: Color(0xff3E7BFA), width: 2.0),
                        borderRadius: BorderRadius.circular(25.0),
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 50),
                        // const EdgeInsets.all(0),
                        child: Text(
                          // '${DateTime.now().day}.${DateTime.now().month}.${DateTime.now().year}',
                          ' ${timeago.format(
                            widget.commentModel.createdAt,
                            locale: 'en',
                          )}',
                          style: const TextStyle(
                            color: Colors.black45,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 7,
                      ),
                      LikeButton(
                        size: 20,
                        onTap: (isLiked) async {
                          ref.read(postControllerProvider.notifier).likeComment(
                                widget.commentModel,
                                currentUser,
                              );
                          return !isLiked;
                        },
                        isLiked: widget.commentModel.likes
                            .contains(currentUser!.userId),
                        likeBuilder: (isLiked) {
                          return isLiked
                              ? const Icon(
                                  Icons.favorite_rounded,
                                  color: Colors.red,
                                  size: 14,
                                )
                              : const Icon(
                                  Icons.favorite_border_rounded,
                                  color: Colors.black45,
                                  size: 17,
                                );
                        },
                        likeCount: widget.commentModel.likes.length,
                        // likeCount: 1,
                        countBuilder: (likeCount, isLiked, text) {
                          return Padding(
                            padding: const EdgeInsets.only(left: 2.0),
                            child: Text(
                              likeCount! > 1 ? '$text likes' : '$text like',
                              style: TextStyle(
                                color: isLiked ? Colors.red : Colors.black45,
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          );
                        },
                      ),
                      TextButton(
                        onPressed: onClick,
                        child: Text(
                          !showReplyTextField ? 'reply' : 'cancel',
                          style: const TextStyle(
                            color: Colors.black45,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 4,
                  ),
                  if (showReplyTextField)
                    Row(
                      children: [
                        ConstrainedBox(
                          constraints: BoxConstraints(
                            maxHeight: MediaQuery.of(context).size.height * 0.3,
                            maxWidth:
                                widget.commentModel.parentCommentId.isEmpty
                                    ? MediaQuery.of(context).size.width * 0.72
                                    : MediaQuery.of(context).size.width * 0.62,
                          ),
                          child: TextFormField(
                            controller: commentController,
                            autofocus: false,
                            maxLines: null,
                            maxLength: 70,
                            decoration: InputDecoration(
                              hintText: 'Express your thoughts',
                              fillColor: Colors.transparent,
                              border: OutlineInputBorder(
                                borderSide: const BorderSide(
                                  color: Color.fromARGB(255, 178, 165, 200),
                                  width: 0.5,
                                ),
                                borderRadius: BorderRadius.circular(25.0),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: const BorderSide(
                                  color: Color.fromARGB(255, 178, 165, 200),
                                  width: 0.5,
                                ),
                                borderRadius: BorderRadius.circular(25.0),
                              ),
                            ),
                            buildCounter: (context,
                                {currentLength = 0,
                                isFocused = false,
                                maxLength}) {},
                          ),
                        ),
                        const SizedBox(
                          width: 2,
                        ),
                        TextButton(
                          onPressed: onSubmit,
                          child: const Text(
                            'Post',
                          ),
                        ),
                      ],
                    ),
                ],
              ),
            );
          },
          error: (error, stackTrace) => ErrorText(
            error: error.toString(),
          ),
          loading: () => const LoadingIndicator(),
        );
  }
}

class CommentsWithRepliesWidget extends ConsumerStatefulWidget {
  final Comment commentModel;
  final DocumentModel documentModel;
  final List<Comment> replies;
  const CommentsWithRepliesWidget(
      {super.key,
      required this.commentModel,
      required this.replies,
      required this.documentModel});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _CommentWithRepliesTile();
}

class _CommentWithRepliesTile extends ConsumerState<CommentsWithRepliesWidget> {
  @override
  Widget build(BuildContext context) {
    TextEditingController repliesController = TextEditingController(text: '');

    return Column(
      children: [
        CommentTile(
          commentModel: widget.commentModel,
          documentModel: widget.documentModel,
        ),
        const SizedBox(height: 8),
        Padding(
          padding: const EdgeInsets.only(left: 25),
          child: ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: widget.replies.length,
            itemBuilder: (context, index) {
              final reply = widget.replies[index];
              return CommentTile(
                commentModel: reply,
                documentModel: widget.documentModel,
              );
            },
          ),
        ),
      ],
    );
  }
}
