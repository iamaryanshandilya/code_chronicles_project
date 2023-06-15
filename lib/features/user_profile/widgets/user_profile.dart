import 'package:code_chronicles/common/custom_loader.dart';
import 'package:code_chronicles/features/auth/controller/auth_controller.dart';
import 'package:code_chronicles/features/post/widgets/posts_list.dart';
import 'package:code_chronicles/features/user_profile/controller/user_profile_controller.dart';
import 'package:code_chronicles/features/user_profile/views/edit_profile_view.dart';
import 'package:code_chronicles/features/user_profile/widgets/number_widget.dart';
import 'package:code_chronicles/features/user_profile/widgets/users_posts.dart';
import 'package:code_chronicles/models/user_model.dart';
import 'package:code_chronicles/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:readmore/readmore.dart';

class UserProfile extends ConsumerWidget {
  static route(UserModel userModel) => MaterialPageRoute(
        builder: (context) => UserProfile(
          userModel: userModel,
        ),
      );

  final UserModel userModel;
  UserProfile({super.key, required this.userModel});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUser = ref.watch(loggedInUserDetailsProvider).value;
    return currentUser == null
        ? const LoadingIndicator()
        : NestedScrollView(
            headerSliverBuilder:
                (BuildContext context, bool innerBoxIsScrolled) {
              return [
                SliverAppBar(
                  
                  pinned: false,
                  // backgroundColor: Color(0xff1C1C28),
                  automaticallyImplyLeading: true,
                  // actions: isMyProfile
                  //     ? [
                  //         IconButton(
                  //           icon: Icon(Icons.menu),
                  //           onPressed: () {
                  //             final _state = _endSideMenuKey.currentState;
                  //             if (_state!.isOpened)
                  //               _state.closeSideMenu();
                  //             else
                  //               _state.openSideMenu();
                  //           },
                  //         ),
                  //       ]
                  //     : null,
                  flexibleSpace: FlexibleSpaceBar(
                    collapseMode: CollapseMode.pin,
                    background: Column(
                      children: [
                        const SizedBox(
                          height: 50,
                        ),
                        SizedBox(
                          height: 340,
                          child: Container(
                            // color: Color(0xff1C1C28),
                            child: SingleChildScrollView(
                              child: Column(
                                children: [
                                  CircleAvatar(
                                    radius: 60,
                                    backgroundImage: userModel
                                            .profilePicture.isNotEmpty
                                        ? NetworkImage(userModel.profilePicture)
                                        : null,
                                    child: userModel.profilePicture.isEmpty
                                        ? const Icon(Icons.person_2_outlined, size: 60,)
                                        : null,
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Column(
                                    children: [
                                      Text(
                                        userModel.name,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        // '@interkith',
                                        '@${userModel.userId}',
                                        // style: TextStyle(color: Colors.grey),
                                      )
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 7,
                                  ),
                                  NumbersWidget(
                                    user: userModel,
                                  ),
                                  const SizedBox(
                                    height: 9,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      userModel.userId == currentUser.userId
                                          ? ElevatedButton(
                                              style: ElevatedButton.styleFrom(
                                                fixedSize: const Size(120, 30),
                                                backgroundColor:
                                                    Pallete.kButtonColor,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          7.0),
                                                ),
                                                // foregroundColor: Pallete.kButtonColor,
                                                // padding: EdgeInsets.symmetric(
                                                //     horizontal: 32, vertical: 12),
                                              ),
                                              child: const Text(
                                                'Edit Profile',
                                                style: TextStyle(
                                                    color: Colors.white),
                                              ),
                                              onPressed: () {
                                                Navigator.push(
                                                  context,
                                                  ProfileEditPage.route(
                                                      userModel),
                                                );
                                              },
                                            )
                                          : currentUser.following.contains(userModel.userId)
                                              ? ElevatedButton(
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                    fixedSize:
                                                        const Size(120, 30),
                                                    backgroundColor:
                                                        Pallete.kButtonColor,
                                                    // shape: StadiumBorder(),
                                                    shape:
                                                        RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              7.0),
                                                    ),
                                                    // onPrimary: kButtonColor,
                                                    // padding: EdgeInsets.symmetric(
                                                    //     horizontal: 32, vertical: 12),
                                                  ),
                                                  child: const Text(
                                                    'Following',
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                  onPressed: () {
                                                    ref
                                                        .read(
                                                            userProfileControllerProvider
                                                                .notifier)
                                                        .followUser(
                                                          user: userModel,
                                                          context: context,
                                                          currentUser:
                                                              currentUser,
                                                        );
                                                  },
                                                )
                                              : ElevatedButton(
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                    fixedSize:
                                                        const Size(120, 30),
                                                    // backgroundColor: Pallete.kButtonColor,
                                                    // shape: StadiumBorder(),
                                                    shape:
                                                        RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              7.0),
                                                    ),
                                                    backgroundColor:
                                                        Pallete.kButtonColor,
                                                    // padding: EdgeInsets.symmetric(
                                                    //     horizontal: 32, vertical: 12),
                                                  ),
                                                  child: const Text(
                                                    'Follow',
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                  onPressed: () {
                                                    ref
                                                        .read(
                                                            userProfileControllerProvider
                                                                .notifier)
                                                        .followUser(
                                                          user: userModel,
                                                          context: context,
                                                          currentUser:
                                                              currentUser,
                                                        );
                                                  },
                                                ),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 7,
                                  ),
                                  // Text('Hello!!!!'),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 50,
                                    ),
                                    child: Center(
                                      child: ReadMoreText(
                                        userModel.bio,
                                        trimLines: 2,
                                        colorClickableText:
                                            Pallete.kButtonColor,
                                        trimMode: TrimMode.Line,
                                        trimCollapsedText: '...Show more',
                                        trimExpandedText: ' show less',
                                        style: const TextStyle(
                                            color: Colors.black),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  expandedHeight: 380.0,
                )
              ];
            },
            body: Container(
              color: Colors.white,
              child: PostListByAUser(
                userModel: userModel,
              ),
            ),
          );
  }
}
