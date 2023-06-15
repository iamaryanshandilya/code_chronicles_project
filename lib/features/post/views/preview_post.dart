import 'dart:convert';
import 'dart:io';
import 'package:code_chronicles/common/custom_loader.dart';
import 'package:code_chronicles/core/core.dart';
import 'package:code_chronicles/features/auth/controller/auth_controller.dart';
import 'package:code_chronicles/features/post/controller/post_controller.dart';
import 'package:code_chronicles/features/post/widgets/post_preview_tile.dart';
import 'package:code_chronicles/features/post/widgets/title_field.dart';
import 'package:code_chronicles/models/document_model.dart';
import 'package:code_chronicles/utils/color_constants.dart';
import 'package:code_chronicles/utils/custom_dialog_box.dart';
import 'package:code_chronicles/utils/topics.dart';
import 'package:filter_list/filter_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:timeago/timeago.dart' as timeago;

class PostPreviewView extends ConsumerStatefulWidget {
  static route(
    File? coverImage,
    String title,
    List<String>? topics,
    List<dynamic> quillDataAsJson,
  ) =>
      MaterialPageRoute(
        builder: (context) => PostPreviewView(
          coverImage: coverImage,
          title: title,
          topics: topics,
          quillDataAsJson: quillDataAsJson,
        ),
      );

  final File? coverImage;
  final String title;
  final List<String>? topics;
  final List<dynamic> quillDataAsJson;

  const PostPreviewView({
    required this.coverImage,
    required this.title,
    required this.topics,
    required this.quillDataAsJson,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _PostPreviewViewState();
}

class _PostPreviewViewState extends ConsumerState<PostPreviewView> {
  final quill.QuillController _controller = quill.QuillController.basic();

  @override
  void initState() {
    super.initState();
    _controller.document = quill.Document.fromJson(widget.quillDataAsJson);
    setState(() {});
  }

  void onCancel() async {
    Navigator.of(context).pop();
  }

  void onSubmit() async {
    final contentAsJson = jsonEncode(widget.quillDataAsJson);

    ref.read(postControllerProvider.notifier).sharePost(
          coverImage: widget.coverImage,
          title: widget.title,
          contentAsJson: contentAsJson,
          context: context,
          topics: widget.topics,
        );
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final userData = ref.watch(loggedInUserDetailsProvider).value;
    final isLoading = ref.watch(postControllerProvider);
    return (userData == null)
        ? const LoadingPage()
        : Stack(
            children: [
              Scaffold(
                extendBody: true,
                resizeToAvoidBottomInset: true,
                appBar: AppBar(
                  backgroundColor: Colors.white,
                  elevation: 15,
                  centerTitle: false,
                  leading: IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: onCancel,
                  ),
                  title: const Text(
                    'Preview',
                    style: TextStyle(
                        fontSize: 22,
                        // fontFamily: 'Ubuntu',
                        fontWeight: FontWeight.w400,
                        color: Colors.black
                        // fontStyle: FontStyle.italic,
                        ),
                  ),
                  actions: [
                    TextButton(
                      onPressed: onSubmit,
                      child: const Text(
                        'Post',
                        style: TextStyle(
                          color: Pallete.kButtonColor,
                        ),
                      ),
                    ),
                  ],
                  bottom: PreferredSize(
                    preferredSize: const Size.fromHeight(1),
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.grey.shade800.withOpacity(.5),
                          width: 0.2,
                        ),
                      ),
                    ),
                  ),
                ),
                backgroundColor: Colors.grey[100],
                body: Center(
                  child: SizedBox(
                    // width: MediaQuery.of(context).size.width * 0.95,
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          const SizedBox(
                            height: 2,
                          ),
                          PostPreviewTile(
                            coverImage: widget.coverImage,
                            title: widget.title,
                            topics: widget.topics,
                            username: userData.userId,
                          ),
                          const SizedBox(
                            height: 2,
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(5, 5, 5, 5),
                            child: Card(
                              elevation: 5,
                              color: Colors.white,
                              child: Padding(
                                padding: EdgeInsets.fromLTRB(10.0, 10, 10,
                                    MediaQuery.of(context).viewInsets.bottom),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      widget.title,
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
                                        Row(
                                          children: [
                                            CircleAvatar(
                                              radius: 17,
                                              backgroundImage: userData
                                                      .profilePicture.isNotEmpty
                                                  ? NetworkImage(
                                                      userData.profilePicture)
                                                  : null,
                                              child: userData
                                                      .profilePicture.isEmpty
                                                  ? const Icon(
                                                      Icons.person_2_outlined)
                                                  : null,
                                            ),
                                            const SizedBox(
                                              width: 4,
                                            ),
                                            Text(
                                              'by @${userData.userId}',
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
                                                DateTime.now(),
                                                locale: 'en_short',
                                              )}',
                                              style: const TextStyle(
                                                color: Colors.black45,
                                                fontSize: 16,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ],
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
                                    (widget.coverImage != null)
                                        ? SizedBox(
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.35,
                                            width: double.infinity,
                                            child:
                                                Image.file(widget.coverImage!),
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
                                          children: widget.topics!.map((e) {
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
                                    )
                                  ],
                                ),
                              ),
                            ),
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
  }
}
