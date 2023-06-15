import 'dart:convert';

import 'package:code_chronicles/common/custom_loader.dart';
import 'package:code_chronicles/common/error_page.dart';
import 'package:code_chronicles/features/auth/controller/auth_controller.dart';
import 'package:code_chronicles/features/post/controller/post_controller.dart';
import 'package:code_chronicles/features/post/widgets/comment_list.dart';
import 'package:code_chronicles/features/user_profile/views/user_profile_view.dart';
import 'package:code_chronicles/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:code_chronicles/models/document_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:like_button/like_button.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;
import 'package:http/http.dart' as http;
import 'package:timeago/timeago.dart' as timeago;

class PostDetails extends ConsumerStatefulWidget {
  static route(DocumentModel documentModel) => MaterialPageRoute(
        builder: (context) => PostDetails(
          documentModel: documentModel,
        ),
      );

  final DocumentModel documentModel;
  const PostDetails({super.key, required this.documentModel});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _PostDetailsState();
}

class _PostDetailsState extends ConsumerState<PostDetails> {
  quill.QuillController _controller = quill.QuillController.basic();
  TextEditingController commentController = TextEditingController(text: '');

  @override
  void initState() {
    super.initState();
    _loadJsonFile();
  }

  Future<String> downloadJsonFile() async {
    final url =
        widget.documentModel.contentURL; // Replace with your Appwrite file URL

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      return response.body;
    } else {
      throw Exception('Failed to download JSON file');
    }
  }

  Future<void> _loadJsonFile() async {
    try {
      final jsonContent = await downloadJsonFile();
      _controller.document = quill.Document.fromJson(
        jsonDecode(jsonContent),
      );
    } catch (e) {
      print('Failed to load JSON file: $e');
      // Handle error
    }
  }

  void onSubmit(UserModel currentUser) async {
    if (commentController.text == '' || commentController.text.isEmpty) {
      return;
    }

    ref.read(postControllerProvider.notifier).shareComment(
          text: commentController.text,
          parentPostId: widget.documentModel.id,
          parentCommentId: '',
          context: context,
          repliedToUserId: widget.documentModel.authorId,
        );

    ref.read(postControllerProvider.notifier).updateCommentCounts(
          widget.documentModel,
          currentUser,
        );

    final isPosted = ref.watch(postControllerProvider);
    if (isPosted) commentController.text = '';
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = ref.watch(loggedInUserDetailsProvider).value;
    final isLoading = ref.watch(postControllerProvider);

    return currentUser == null
        ? const SizedBox()
        : ref.watch(userDetailsProvider(widget.documentModel.authorId)).when(
              data: (user) {
                return Stack(
                  children: [
                    Scaffold(
                      appBar: AppBar(),
                      body: SingleChildScrollView(
                        child: Card(
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(15),
                              topRight: Radius.circular(15),
                            ),
                          ),
                          elevation: 5,
                          color: Colors.white,
                          child: Padding(
                            padding: EdgeInsets.fromLTRB(10.0, 10, 10,
                                MediaQuery.of(context).viewInsets.bottom),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      widget.documentModel.title,
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                        fontSize: 22,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        GestureDetector(
                                          onTap: () {
                                            Navigator.push(
                                              context,
                                              UserProfileView.route(user),
                                            );
                                          },
                                          child: Row(
                                            children: [
                                              CircleAvatar(
                                                radius: 17,
                                                backgroundImage: user
                                                        .profilePicture
                                                        .isNotEmpty
                                                    ? NetworkImage(
                                                        user.profilePicture)
                                                    : null,
                                                child: user
                                                        .profilePicture.isEmpty
                                                    ? const Icon(
                                                        Icons.person_2_outlined)
                                                    : null,
                                              ),
                                              const SizedBox(
                                                width: 4,
                                              ),
                                              Text(
                                                'by @${user.userId}',
                                                style: const TextStyle(
                                                  fontSize: 16.0,
                                                  fontWeight: FontWeight.w400,
                                                ),
                                              ),
                                              const SizedBox(
                                                width: 4,
                                              ),
                                              Text(
                                                // '${DateTime.now().day}.${DateTime.now().month}.${DateTime.now().year}',
                                                ' · ${timeago.format(
                                                  widget
                                                      .documentModel.createdAt,
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
                                        ),
                                        LikeButton(
                                          size: 20,
                                          onTap: (isLiked) async {
                                            ref
                                                .read(postControllerProvider
                                                    .notifier)
                                                .likePost(
                                                  widget.documentModel,
                                                  currentUser,
                                                );
                                            return !isLiked;
                                          },
                                          isLiked: widget.documentModel.likes
                                              .contains(currentUser.userId),
                                          likeBuilder: (isLiked) {
                                            return isLiked
                                                ? const Icon(
                                                    Icons.favorite_rounded,
                                                    color: Colors.red,
                                                  )
                                                : const Icon(
                                                    Icons
                                                        .favorite_border_rounded,
                                                    color: Colors.grey,
                                                  );
                                          },
                                          likeCount:
                                              widget.documentModel.likes.length,
                                          countBuilder:
                                              (likeCount, isLiked, text) {
                                            return Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 2.0),
                                              child: Text(
                                                text,
                                                style: TextStyle(
                                                  color: isLiked
                                                      ? Colors.red
                                                      : Colors.grey,
                                                  fontSize: 16,
                                                ),
                                              ),
                                            );
                                          },
                                        ),
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 2,
                                    ),
                                    Divider(
                                      indent: 5,
                                      endIndent: 5,
                                      color: Colors.black.withOpacity(0.1),
                                    ),
                                    const SizedBox(
                                      height: 2,
                                    ),
                                    (widget.documentModel.titleImageLink !=
                                                '' ||
                                            widget.documentModel.titleImageLink
                                                .isNotEmpty)
                                        ? SizedBox(
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.35,
                                            width: double.infinity,
                                            child: Image.network(widget
                                                .documentModel.titleImageLink),
                                          )
                                        : const SizedBox(),
                                    const SizedBox(
                                      height: 3,
                                    ),
                                    Container(
                                      child: quill.QuillEditor(
                                        showCursor: false,
                                        focusNode: FocusNode(),
                                        autoFocus: false,
                                        expands: false,
                                        scrollController: ScrollController(),
                                        padding: const EdgeInsets.all(7),
                                        scrollable: false,
                                        controller: _controller,
                                        readOnly:
                                            true, // true for view only mode
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 3,
                                    ),
                                    Container(
                                      // height: 70,
                                      width: double.infinity,
                                      child: SingleChildScrollView(
                                        scrollDirection: Axis.horizontal,
                                        child: Row(
                                          children: widget.documentModel.topics
                                              .map((e) {
                                            return Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 16,
                                                      vertical: 12),
                                              margin:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 5,
                                                      vertical: 10),
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(30),
                                                border: Border.all(
                                                  color: Colors.blue[300]!,
                                                ),
                                              ),
                                              child: Text(e),
                                            );
                                          }).toList(),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 2,
                                    ),
                                    Divider(
                                      indent: 5,
                                      endIndent: 5,
                                      color: Colors.black.withOpacity(0.1),
                                    ),
                                    const SizedBox(
                                      height: 2,
                                    ),
                                  ],
                                ),
                                const Text(
                                  'Comments',
                                  textAlign: TextAlign.start,
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(
                                  height: 27,
                                ),
                                Row(
                                  // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    // CircleAvatar(
                                    //   radius: 17,
                                    //   backgroundImage: currentUser
                                    //           .profilePicture.isNotEmpty
                                    //       ? NetworkImage(currentUser.profilePicture)
                                    //       : null,
                                    //   child: currentUser.profilePicture.isEmpty
                                    //       ? const Icon(Icons.person_2_outlined)
                                    //       : null,
                                    // ),
                                    ConstrainedBox(
                                      constraints: BoxConstraints(
                                        maxHeight:
                                            MediaQuery.of(context).size.height *
                                                0.3,
                                        maxWidth:
                                            MediaQuery.of(context).size.width *
                                                0.73,
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
                                              color: Color.fromARGB(
                                                  255, 178, 165, 200),
                                              width: 0.5,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(25.0),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderSide: const BorderSide(
                                              color: Color.fromARGB(
                                                  255, 178, 165, 200),
                                              width: 0.5,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(25.0),
                                          ),
                                        ),
                                        buildCounter: (context,
                                            {currentLength = 0,
                                            isFocused = false,
                                            maxLength}) {},
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 5,
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        onSubmit(currentUser);
                                      },
                                      child: const Text(
                                        'Post',
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                CommentList(
                                  documentModel: widget.documentModel,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    if (isLoading)
                      Container(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height,
                        color: Colors.black.withOpacity(0.5),
                        child: const Center(
                          child: StackLoader(),
                        ),
                      ),
                    if (!isLoading)
                      SizedBox(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height,
                      ),
                  ],
                );
              },
              error: (error, stackTrace) => ErrorText(
                error: error.toString(),
              ),
              loading: () => const StackLoader(),
            );
  }
}
