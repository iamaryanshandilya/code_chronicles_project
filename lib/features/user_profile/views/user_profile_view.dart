import 'package:code_chronicles/common/custom_loader.dart';
import 'package:code_chronicles/common/error_page.dart';
import 'package:code_chronicles/features/user_profile/controller/user_profile_controller.dart';
import 'package:code_chronicles/features/user_profile/widgets/user_profile.dart';
import 'package:code_chronicles/models/user_model.dart';
import 'package:code_chronicles/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UserProfileView extends ConsumerWidget {
  static route(UserModel userModel) => MaterialPageRoute(
        builder: (context) => UserProfileView(
          userModel: userModel,
        ),
      );

  final UserModel userModel;
  const UserProfileView({super.key, required this.userModel});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    UserModel copyOfUserModel = userModel;
    return ref.watch(getLatestUserProfileDataProvider).when(
          data: (data) {
            if (data.events.contains(
                'databases.*.collections.${AppwriteConstants.usersCollectionId}.documents.${copyOfUserModel.userId}.update')) {
              copyOfUserModel = UserModel.fromMap(data.payload);
            }
            return UserProfile(
              userModel: copyOfUserModel,
            );
          },
          error: (error, stackTrace) => ErrorText(
            error: error.toString(),
          ),
          loading: () {
            return UserProfile(
              userModel: copyOfUserModel,
            );
          },
        );
  }
}
