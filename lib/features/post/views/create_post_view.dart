import 'dart:convert';
import 'dart:io';
import 'package:code_chronicles/common/custom_loader.dart';
import 'package:code_chronicles/core/core.dart';
import 'package:code_chronicles/features/auth/controller/auth_controller.dart';
import 'package:code_chronicles/features/post/controller/post_controller.dart';
import 'package:code_chronicles/features/post/views/preview_post.dart';
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

class CreatePostView extends ConsumerStatefulWidget {
  static route(String? id) => MaterialPageRoute(
        builder: (context) => CreatePostView(
          id: id,
        ),
      );
  final String? id;
  const CreatePostView({super.key, required this.id});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _CreatePostViewState();
}

class _CreatePostViewState extends ConsumerState<CreatePostView> {
  TextEditingController titleController = TextEditingController(text: '');
  FocusNode titleFocusNode = FocusNode();
  final quill.QuillController _controller = quill.QuillController.basic();

  List<String>? selectedTopics = [];

  bool titleNodeHasFocus = false;

  @override
  void initState() {
    super.initState();
    titleFocusNode.addListener(_onFocusChange);
  }

  void _onFocusChange() {
    if (titleFocusNode.hasFocus) {
      setState(() {
        titleNodeHasFocus = true;
      });
    } else {
      setState(() {
        titleNodeHasFocus = false;
      });
    }
  }

  File? coverImage;

  void pickCoverImage() async {
    final cover = await pickImage();
    if (cover != null) {
      final croppedImage = await imageCropper(
        cover,
        CropStyle.rectangle,
        const CropAspectRatio(ratioX: 4, ratioY: 3),
      );
      if (croppedImage != null) {
        setState(() {
          coverImage = File(croppedImage.path);
        });
      }
    }
  }

  void onCancel() async {
    if (titleController.text.isNotEmpty || titleController.text != '') {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return CustomDialogBox(
            descriptions: 'Do you want to discard this post?',
            positiveBtnText: 'Yes',
            negativeBtnText: 'No',
            title: '',
            positiveBtnPressed: () {
              Navigator.of(context)
                ..pop()
                ..pop();
            },
            negativeBtnPressed: () {
              Navigator.of(context).pop();
            },
          );
        },
      );
    }
    Navigator.of(context).pop();
  }

  void onSubmit() {
    final quillData = _controller.document.toDelta();
    final quillDataAsJson = quillData.toJson();

    if ((quillDataAsJson[0]['insert'] == null) ||
            (quillDataAsJson[0]['insert'].toString() == '') ||
            (quillDataAsJson[0]['insert'].toString() == '\n') ||
            (quillDataAsJson[0]['insert'].toString().isEmpty) ||
            (titleController.text == null) ||
            (titleController.text == '') ||
            (selectedTopics == null) ||
            (selectedTopics!.isEmpty)
        ) {
      return;
    }

    Navigator.push(
      context,
      PostPreviewView.route(
        coverImage,
        titleController.text,
        selectedTopics,
        quillDataAsJson
      ),
    );
  }

  @override
  void dispose() {
    titleFocusNode.removeListener(_onFocusChange);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(postControllerProvider);
    return Scaffold(
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
          'Create a post',
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
              'Done',
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
                Padding(
                  padding: const EdgeInsets.fromLTRB(5, 5, 5, 5),
                  child: Card(
                    elevation: 5,
                    color: Colors.white,
                    child: Column(
                      children: [
                        TitleField(
                          controller: titleController,
                          hintText: 'Add a title',
                          titleFocusNode: null,
                        ),
                        Divider(
                          color: Colors.black26.withOpacity(0.05),
                          height: 0.1,
                        ),
                        GestureDetector(
                          onTap: pickCoverImage,
                          child: Container(
                            decoration: coverImage != null
                                ? const BoxDecoration(
                                    borderRadius: BorderRadius.only(
                                      bottomLeft: Radius.circular(15),
                                      bottomRight: Radius.circular(15),
                                    ),
                                  )
                                : null,
                            child: coverImage != null
                                ? Image.file(
                                    coverImage!,
                                    fit: BoxFit.cover,
                                  )
                                : Center(
                                    widthFactor: 6,
                                    heightFactor: 6,
                                    child: Text(
                                      'click to pick a banner image',
                                      style: TextStyle(
                                          fontSize: 22,
                                          fontFamily: 'Ubuntu',
                                          fontWeight: FontWeight.w500,
                                          color: Colors.grey[500]),
                                    ),
                                  ),
                          ),
                        ),
                        Divider(
                          color: Colors.black26.withOpacity(0.05),
                          height: 0.1,
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(5, 5, 5, 5),
                          child: GestureDetector(
                            onTap: _openFilterDialog,
                            child: Container(
                              decoration: const BoxDecoration(
                                borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(15),
                                  bottomRight: Radius.circular(15),
                                ),
                              ),
                              child: selectedTopics!.isNotEmpty
                                  ? Container(
                                      // height: 70,
                                      width: double.infinity,
                                      child: SingleChildScrollView(
                                        scrollDirection: Axis.horizontal,
                                        child: Row(
                                          children: selectedTopics!.map((e) {
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
                                  // ? Container()
                                  : Center(
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 18.0, vertical: 18),
                                        child: Text(
                                          'click to select the topic this article discusses',
                                          style: TextStyle(
                                              fontSize: 18,
                                              fontFamily: 'Ubuntu',
                                              fontWeight: FontWeight.w500,
                                              color: Colors.grey[500]),
                                        ),
                                      ),
                                    ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
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
                      child: Container(
                        height: MediaQuery.of(context).size.height,
                        child: quill.QuillEditor.basic(
                          controller: _controller,
                          readOnly: false, // true for view only mode
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: MediaQuery.of(context).viewInsets,
        child: quill.QuillToolbar.basic(
          controller: _controller,
          multiRowsDisplay: false,
        ),
      ),
    );
  }

  Future<List<String>?> _openFilterDialog() async {
    // List<String>? selected = [];
    await FilterListDialog.display<String>(
      context,
      hideSelectedTextCount: true,
      themeData: FilterListThemeData(
        context,
        choiceChipTheme: ChoiceChipThemeData.light(context),
      ),
      headlineText: 'Select Topics',
      insetPadding: EdgeInsets.symmetric(horizontal: 25, vertical: 20),
      headerCloseIcon: IconButton(
        onPressed: () {},
        icon: const Icon(
          Icons.close,
        ),
      ),
      hideCloseIcon: true,
      height: 450,
      listData: topics,
      choiceChipBuilder: (context, item, isSelected) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            border: Border.all(
              color: isSelected! ? Colors.blue[300]! : Colors.grey[300]!,
            ),
          ),
          child: Text(item),
        );
      },
      selectedListData: selectedTopics,
      choiceChipLabel: (item) => item!,
      validateSelectedItem: (list, val) => list!.contains(val),
      controlButtons: [ControlButtonType.All, ControlButtonType.Reset],
      onItemSearch: (topic, query) {
        /// When search query change in search bar then this method will be called
        ///
        /// Check if items contains query
        return topic.toLowerCase().contains(query.toLowerCase());
      },
      onApplyButtonClick: (list) {
        setState(() {
          selectedTopics = List.from(list!);
        });
        Navigator.pop(context);
      },
    );

    // return selected;
  }
}
