import 'package:code_chronicles/core/utils.dart';
import 'package:code_chronicles/features/post/views/create_post_view.dart';
import 'package:code_chronicles/utils/custom_dialog_box.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

Future<void> checkallpermission(BuildContext context, bool isHome) async {
  List<Permission> permissions = [];

  permissions.addAll([
    Permission.storage,
    Permission.accessMediaLocation,
    Permission.manageExternalStorage,
  ]);

  int count = 1;

  for (var permission in permissions) {
    final permissionStatus = await permission.status;
    if (permissionStatus.isGranted) {
      count++;
    } else if (permissionStatus.isPermanentlyDenied && isHome) {
      if (context.mounted) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return CustomDialogBox(
              descriptions:
                  'We require access to the storage for creating, and sharing the posts',
              positiveBtnText: 'Open settings',
              negativeBtnText: 'Cancel',
              title: '',
              positiveBtnPressed: () {
                openAppSettings();
                Navigator.of(context).pop();
              },
              negativeBtnPressed: () {
                Navigator.of(context).pop();
              },
            );
          },
        );
      }
    } else if (permissionStatus.isDenied) {
      await permission.request();
      if (permissionStatus.isDenied && isHome) {
        if (context.mounted) {
          showSnackBar(context,
              'We dont have the required permissions to perform this operation');
        }
        openAppSettings();
      }
      if (permissionStatus.isPermanentlyDenied && isHome) {
        if (context.mounted) {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return CustomDialogBox(
                descriptions:
                    'We require access to the storage for creating, and sharing the posts',
                positiveBtnText: 'Open settings',
                negativeBtnText: 'Cancel',
                title: '',
                positiveBtnPressed: () {
                  openAppSettings();
                  Navigator.of(context).pop();
                },
                negativeBtnPressed: () {
                  Navigator.of(context).pop();
                },
              );
            },
          );
        }
      }
    }
  }

  if (count == 3 && context.mounted && isHome) {
    Navigator.push(
      context,
      CreatePostView.route(''),
    );
  }
}
