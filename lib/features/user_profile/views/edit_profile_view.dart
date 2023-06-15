import 'dart:convert';
import 'dart:io';

import 'package:code_chronicles/common/custom_loader.dart';
import 'package:code_chronicles/common/error_page.dart';
import 'package:code_chronicles/core/core.dart';
import 'package:code_chronicles/features/auth/controller/auth_controller.dart';
import 'package:code_chronicles/features/post/controller/post_controller.dart';
import 'package:code_chronicles/features/post/widgets/comment_list.dart';
import 'package:code_chronicles/features/user_profile/controller/user_profile_controller.dart';
import 'package:code_chronicles/features/user_profile/views/user_profile_view.dart';
import 'package:code_chronicles/models/user_model.dart';
import 'package:code_chronicles/utils/constants.dart';
import 'package:code_chronicles/utils/topics.dart';
import 'package:filter_list/filter_list.dart';
import 'package:flutter/material.dart';
import 'package:code_chronicles/models/document_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:like_button/like_button.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;
import 'package:http/http.dart' as http;
import 'package:timeago/timeago.dart' as timeago;

class ProfileEditPage extends ConsumerStatefulWidget {
  static route(UserModel userModel) => MaterialPageRoute(
        builder: (context) => ProfileEditPage(
          userModel: userModel,
        ),
      );

  final UserModel userModel;
  const ProfileEditPage({super.key, required this.userModel});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _ProfileEditPageState();
}

class _ProfileEditPageState extends ConsumerState<ProfileEditPage> {
  final _formKey = GlobalKey<FormState>();
  late String _bio, _name;
  List<String>? selectedTopics = [];

  @override
  void initState() {
    super.initState();
    initialize();
  }

  void initialize() {
    final currentUser = ref.read(loggedInUserDetailsProvider).value;
    if (currentUser != null) {
      setState(() {
        selectedTopics = currentUser.interests;
        _name = currentUser.name;
        _bio = currentUser.bio;
      });
    }
  }

  checkFields() {
    final form = _formKey.currentState;
    if (form!.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  File? profileImage;

  void pickProfileImage() async {
    final cover = await pickImage();
    if (cover != null) {
      final croppedImage = await imageCropper(
        cover,
        CropStyle.circle,
        const CropAspectRatio(ratioX: 16, ratioY: 16),
      );
      if (croppedImage != null) {
        setState(() {
          profileImage = File(croppedImage.path);
        });
      }
    }
  }

  void onSubmit(UserModel currentUser) async {
    if (selectedTopics != null) {
      if (_name == '' || _name.isEmpty || selectedTopics!.isEmpty) {
        return;
      }
    }
    currentUser =
        currentUser.copyWith(name: _name, bio: _bio, interests: selectedTopics);

    ref.read(userProfileControllerProvider.notifier).updateUserProfile(
        userModel: currentUser, profileFile: profileImage, context: context);
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = ref.watch(loggedInUserDetailsProvider).value;
    final isLoading = ref.watch(userProfileControllerProvider);
    return currentUser == null
        ? const SizedBox()
        : ref.watch(loggedInUserDetailsProvider).when(
              data: (user) {
                return Stack(
                  children: [
                    Scaffold(
                      body: SingleChildScrollView(
                        child: Container(
                          padding: const EdgeInsets.only(
                              left: 16, top: 25, right: 16),
                          child: GestureDetector(
                            onTap: () {
                              FocusScope.of(context).unfocus();
                            },
                            child: SingleChildScrollView(
                              physics: const NeverScrollableScrollPhysics(),
                              child: Column(
                                // scrollDirection: Axis.vertical,
                                // shrinkWrap: true,
                                children: [
                                  const Text(
                                    "Edit Profile",
                                    style: TextStyle(
                                        fontSize: 25,
                                        fontWeight: FontWeight.w500),
                                  ),
                                  const SizedBox(
                                    height: 15,
                                  ),
                                  Center(
                                    child: Stack(
                                      children: [
                                        profileImage != null
                                            ? CircleAvatar(
                                                radius: 60,
                                                backgroundImage:
                                                    FileImage(profileImage!),
                                              )
                                            : CircleAvatar(
                                                radius: 60,
                                                backgroundImage: user!
                                                            .profilePicture
                                                            .isNotEmpty &&
                                                        (profileImage == null)
                                                    ? NetworkImage(
                                                        user.profilePicture)
                                                    : null,
                                                child: user
                                                        .profilePicture.isEmpty
                                                    ? const Icon(
                                                        Icons.person_2_outlined)
                                                    : null,
                                              ),
                                        Positioned(
                                          bottom: 0,
                                          right: 4,
                                          child: SizedBox(
                                            // width: MediaQuery.of(context)
                                            //         .size
                                            //         .width *
                                            //     0.1,
                                            // height: MediaQuery.of(context)
                                            //         .size
                                            //         .width *
                                            //     0.1,
                                            width: 40,
                                            height: 40,
                                            child: buildEditIcon(Colors.blue),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  Form(
                                    key: _formKey,
                                    child: _editInfoForm(currentUser),
                                  ),
                                  const SizedBox(
                                    height: 35,
                                  ),
                                ],
                              ),
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

  _editInfoForm(UserModel userModel) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: TextFormField(
            initialValue: userModel.name,
            decoration: InputDecoration(
              labelText: "name",
              fillColor: Colors.transparent,
              border: OutlineInputBorder(
                borderSide:
                    const BorderSide(color: Color(0xff3E7BFA), width: 2.0),
                borderRadius: BorderRadius.circular(25.0),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide:
                    const BorderSide(color: Color(0xff3E7BFA), width: 2.0),
                borderRadius: BorderRadius.circular(25.0),
              ),
            ),
            onChanged: (value) {
              _name = value;
              // formData.password = value;
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: TextFormField(
            maxLength: 70,
            initialValue: userModel.bio,
            maxLines: null,
            decoration: InputDecoration(
              labelText: "bio",
              fillColor: Colors.transparent,
              border: OutlineInputBorder(
                borderSide:
                    const BorderSide(color: Color(0xff3E7BFA), width: 2.0),
                borderRadius: BorderRadius.circular(25.0),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide:
                    const BorderSide(color: Color(0xff3E7BFA), width: 2.0),
                borderRadius: BorderRadius.circular(25.0),
              ),
            ),
            onChanged: (value) {
              _bio = value;
              // formData.password = value;
            },
            validator: (value) {
              // value!.isEmpty ? 'Email is required' : validateEmail(value),
              if (value!.isEmpty) {
                // return 'Name is required';
                _bio = ' ';
              } else {
                return null;
              }
            },
          ),
        ),
        const SizedBox(
          height: 15,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24),
              border: Border.all(
                color: Colors.black45, // Change border color here
                width: 1.0, // Change border width here
              ),
              // border
            ),
            child: GestureDetector(
              onTap: _openFilterDialog,
              child: (selectedTopics!.isNotEmpty)
                  ? Wrap(
                      children: selectedTopics!.map(
                        (topic) {
                          return Container(
                              margin: const EdgeInsets.symmetric(
                                  horizontal: 5, vertical: 4),
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 5, horizontal: 12),
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(18),
                                    border: Border.all(
                                      color: Colors.black45,
                                      width: 1,
                                    )),
                                child: Text(
                                  topic,
                                  style: const TextStyle(
                                    color: Colors.black45,
                                    fontSize: 14,
                                  ),
                                ),
                              ));
                        },
                      ).toList(),
                    )
                  : Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 18.0, vertical: 18),
                        child: Text(
                          'click to select the topics that interest you',
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
        const SizedBox(
          height: 5,
        ),
        Padding(
          padding: const EdgeInsets.all(14.0),
          child: GestureDetector(
            onTap: () {
              onSubmit(userModel);
            },
            child: Container(
              height: 50,
              child: Material(
                borderRadius: BorderRadius.circular(25),
                // shadowColor: Colors.lightBlueAccent,
                shadowColor: Pallete.kShadowColor,
                color: Pallete.kButtonColor,
                elevation: 7,
                child: const Center(
                  child: Text(
                    'Continue',
                    style: TextStyle(
                      color: Colors.white,
                      fontFamily: 'Ubuntu',
                      // fontStyle: FontStyle.italic,
                      fontWeight: FontWeight.w100,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(14.0).copyWith(top: 5),
          child: GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: Container(
              height: 50,
              child: Material(
                borderRadius: BorderRadius.circular(25),
                shadowColor: Pallete.kBackButtonShadowColor,
                color: Pallete.kBackButtonColor,
                elevation: 7,
                child: const Center(
                  child: Text(
                    'Cancel',
                    style: TextStyle(
                      color: Colors.white,
                      fontFamily: 'Ubuntu',
                      fontWeight: FontWeight.w100,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget buildCircle({
    required Widget child,
    required double all,
    required Color color,
  }) =>
      ClipOval(
        child: Container(
          padding: EdgeInsets.all(all),
          color: color,
          child: child,
        ),
      );

  Widget buildEditIcon(Color color) => buildCircle(
        color: Colors.white,
        all: 1,
        child: buildCircle(
          color: color,
          all: 1,
          child: IconButton(
            icon: const Icon(
              Icons.edit,
              color: Colors.white,
              size: 17,
            ),
            onPressed: pickProfileImage,
          ),
        ),
      );

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
