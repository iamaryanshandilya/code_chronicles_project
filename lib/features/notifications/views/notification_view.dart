import 'package:code_chronicles/common/custom_loader.dart';
import 'package:code_chronicles/common/error_page.dart';
import 'package:code_chronicles/features/auth/controller/auth_controller.dart';
import 'package:code_chronicles/features/notifications/widgets/notification_tile.dart';
import 'package:code_chronicles/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:code_chronicles/features/notifications/controller/notification_controller.dart';
import 'package:code_chronicles/models/notification_model.dart' as model;

class NotificationView extends ConsumerWidget {
  const NotificationView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUser = ref.watch(loggedInUserDetailsProvider).value;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
      ),
      body: currentUser == null
          ? const LoadingIndicator()
          : ref.watch(getNotificationsProvider(currentUser.userId)).when(
                data: (notifications) {
                  return ref.watch(getLatestNotificationProvider).when(
                        data: (data) {
                          print('ygyggyygyg');
                          if (data.events.contains(
                            'databases.*.collections.${AppwriteConstants.notificationsCollectionId}.documents.*.create',
                          )) {
                            final latestNotification =
                                model.Notification.fromMap(data.payload);
                            if (latestNotification.userId == currentUser.userId) {
                              notifications.insert(0, latestNotification);
                            }
                          }

                          return ListView.builder(
                            itemCount: notifications.length,
                            itemBuilder: (BuildContext context, int index) {
                              final notification = notifications[index];
                              return NotificationTile(
                                notification: notification,
                              );
                            },
                          );
                        },
                        error: (error, stackTrace) => ErrorText(
                          error: error.toString(),
                        ),
                        loading: () {
                          print('asdf');
                          return ListView.builder(
                            itemCount: notifications.length,
                            itemBuilder: (BuildContext context, int index) {
                              final notification = notifications[index];
                              return NotificationTile(
                                notification: notification,
                              );
                            },
                          );
                        },
                      );
                },
                error: (error, stackTrace) => ErrorText(
                  error: error.toString(),
                ),
                loading: () => const LoadingIndicator(),
              ),
    );
  }
}
