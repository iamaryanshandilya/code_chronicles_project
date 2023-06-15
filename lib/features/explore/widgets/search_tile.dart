import 'package:code_chronicles/features/home/views/home_view.dart';
import 'package:code_chronicles/features/user_profile/views/user_profile_view.dart';
import 'package:code_chronicles/models/user_model.dart';
import 'package:flutter/material.dart';

class SearchTile extends StatelessWidget {
  final UserModel userModel;
  const SearchTile({
    super.key,
    required this.userModel,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        Navigator.push(
          context,
          UserProfileView.route(userModel),
        );
      },
      leading: CircleAvatar(
        radius: 30,
        backgroundImage: userModel.profilePicture.isNotEmpty
            ? NetworkImage(userModel.profilePicture)
            : null,
        child: userModel.profilePicture.isEmpty
            ? const Icon(Icons.person_2_outlined, size: 30,)
            : null,
      ),
      // title: Text(
      //   userModel.name,
      //   style: const TextStyle(
      //     fontSize: 18,
      //     fontWeight: FontWeight.w600,
      //   ),
      // ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '@${userModel.userId}',
            style: const TextStyle(
              fontSize: 16,
            ),
          ),
          Text(
            userModel.name,
          ),
        ],
      ),
    );
  }
}
