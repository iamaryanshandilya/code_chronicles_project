import 'package:code_chronicles/common/custom_loader.dart';
import 'package:code_chronicles/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:code_chronicles/features/auth/controller/auth_controller.dart';
import 'package:code_chronicles/features/user_profile/controller/user_profile_controller.dart';

class SideDrawer extends ConsumerWidget {
  const SideDrawer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUser = ref.watch(loggedInUserDetailsProvider).value;

    if (currentUser == null) {
      return const LoadingPage();
    }

    return SafeArea(
      child: Drawer(
        elevation: 10,
        backgroundColor: Colors.white.withOpacity(0.8),
        shadowColor: Colors.black,
        // shape: ,
        width: MediaQuery.of(context).size.width * 0.7,
        child: Column(
          children: [
            const SizedBox(height: 50),
            ListTile(
              leading: const Icon(
                Icons.logout,
                size: 30,
                color: Colors.black45,
              ),
              title: const Text(
                'Log Out',
                style: TextStyle(
                  fontSize: 22,
                  color: Colors.black45,
                ),
              ),
              onTap: () {
                ref.read(authControllerProvider.notifier).logout(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}