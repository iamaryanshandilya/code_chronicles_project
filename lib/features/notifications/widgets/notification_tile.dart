import 'package:code_chronicles/features/auth/controller/auth_controller.dart';
import 'package:code_chronicles/features/post/controller/post_controller.dart';
import 'package:code_chronicles/features/post/views/post_details.dart';
import 'package:code_chronicles/features/user_profile/views/user_profile_view.dart';
import 'package:code_chronicles/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:code_chronicles/core/enums/notification_type_enum.dart';
import 'package:code_chronicles/models/notification_model.dart' as model;

class NotificationTile extends ConsumerWidget {
  final model.Notification notification;
  const NotificationTile({
    super.key,
    required this.notification,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      children: [
        ListTile(
          splashColor: Colors.transparent,
          onTap: () {
            if (NotificationType.follow == notification.notificationType) {
              final user =
                  ref.watch(userDetailsProvider(notification.userId)).value;
              if (user != null) {
                Navigator.push(
                  context,
                  UserProfileView.route(user),
                );
              }
            } else {
              if (notification.postId.isNotEmpty) {
                final post =
                    ref.watch(getPostByIdProvider(notification.postId)).value;
                if (post != null) {
                  Navigator.push(
                    context,
                    PostDetails.route(post),
                  );
                }
              }
            }
          },
          leading: notification.notificationType == NotificationType.follow
              ? const Icon(
                  Icons.person,
                  color: Colors.black45,
                )
              : notification.notificationType == NotificationType.like
                  ? const Icon(
                      Icons.favorite_rounded,
                      color: Colors.red,
                      size: 20,
                    )
                  : notification.notificationType == NotificationType.comment
                      ? const Icon(
                          Icons.mode_comment_outlined,
                          color: Colors.black45,
                          size: 20,
                        )
                      : notification.notificationType == NotificationType.reply
                          ? const Icon(
                              Icons.mode_comment_outlined,
                              color: Colors.black45,
                              size: 20,
                            )
                          : null,
          title: Text(notification.text),
        ),
        Divider(
          color: Colors.black26.withOpacity(0.1),
        ),
      ],
    );
  }
}
