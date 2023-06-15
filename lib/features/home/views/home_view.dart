import 'package:code_chronicles/common/custom_button.dart';
import 'package:code_chronicles/common/custom_loader.dart';
import 'package:code_chronicles/features/auth/controller/auth_controller.dart';
import 'package:code_chronicles/features/explore/views/explore_page.dart';
import 'package:code_chronicles/features/explore/views/search_view.dart';
import 'package:code_chronicles/features/home/widgets/custom_navigation_bar.dart';
import 'package:code_chronicles/features/notifications/views/notification_view.dart';
import 'package:code_chronicles/features/post/views/create_post_view.dart';
import 'package:code_chronicles/features/post/widgets/post_tile.dart';
import 'package:code_chronicles/features/post/widgets/posts_list.dart';
import 'package:code_chronicles/features/user_profile/views/user_profile_view.dart';
import 'package:code_chronicles/features/user_profile/widgets/side_drawer.dart';
import 'package:code_chronicles/models/document_model.dart';
import 'package:code_chronicles/utils/application_permission_handler.dart';
import 'package:code_chronicles/utils/color_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';

class HomeView extends ConsumerStatefulWidget {
  static route() => MaterialPageRoute(
        builder: (context) => const HomeView(),
      );
  const HomeView({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HomeViewState();
}

class _HomeViewState extends ConsumerState<HomeView> {
  int _page = 0;

  void onPageChange(int index) {
    if (index != 2) {
      setState(() {
        _page = index;
      });
    }
    if (index == 2) {
      checkallpermission(context, true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = ref.watch(loggedInUserDetailsProvider).value;

    return currentUser == null
        ? const LoadingPage()
        : Scaffold(
            appBar: null,
            drawer: _page == 4 ? const SideDrawer() : null,
            extendBody: true,
            body: IndexedStack(
              index: _page,
              children: [
                const PostList(),
                // const ExploreView(),
                ExplorePageView(userModel: currentUser),
                Center(
                  child: CustomButton(
                      onTap: () {
                        // ref.watch(authControllerProvider.notifier).logout(context);
                      },
                      text: '3'),
                ),
                const NotificationView(),
                UserProfileView(
                  userModel: currentUser,
                ),
              ],
            ),
            bottomNavigationBar: _buildFloatingBar(),
          );
  }

  Widget _buildFloatingBar() {
    return Padding(
      padding: const EdgeInsets.only(
        bottom: 10,
      ),
      child: CustomNavigationBar(
        iconSize: 30.0,
        selectedColor: Pallete.kButtonColor,
        strokeColor: const Color(0x300c18fb),
        unSelectedColor: Colors.grey[600],
        backgroundColor: Colors.white,
        borderRadius: const Radius.circular(20.0),
        items: [
          CustomNavigationBarItem(
            icon: const Icon(
              Icons.home_outlined,
            ),
          ),
          CustomNavigationBarItem(
            icon: const Icon(
              Icons.explore_outlined,
            ),
          ),
          CustomNavigationBarItem(
            icon: const Icon(
              Icons.add,
            ),
          ),
          CustomNavigationBarItem(
            icon: const Icon(
              Icons.notifications_outlined,
            ),
          ),
          CustomNavigationBarItem(
            icon: const Icon(
              Icons.person_2_outlined,
            ),
          ),
        ],
        currentIndex: _page,
        onTap: onPageChange,
        isFloating: true,
        // blurEffect: true,
      ),
    );
  }
}
