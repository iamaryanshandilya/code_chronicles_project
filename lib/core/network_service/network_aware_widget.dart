import 'package:code_chronicles/common/custom_loader.dart';
import 'package:code_chronicles/common/error_page.dart';
import 'package:code_chronicles/core/network_service/network_status_service.dart';
import 'package:code_chronicles/features/auth/controller/auth_controller.dart';
import 'package:code_chronicles/features/auth/views/sign_up_view.dart';
import 'package:code_chronicles/features/home/views/home_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class NetworkManager extends ConsumerWidget {

  const NetworkManager(
      {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final networkStatus = ref.watch(networkStatusController);

    return networkStatus.when(
      data: (status) {
        if (status == NetworkStatus.online) {
          return ref.watch(currentUserAccountProvider).when(
                data: (user) {
                  if (user != null) {
                    return const HomeView();
                  }
                  return const SignUpView();
                },
                error: (error, stackTrace) => ErrorPage(
                  error: error.toString(),
                ),
                loading: () => const LoadingPage(),
              );
        } else {
          return const LoadingPage();
        }
      },
      loading: () => const LoadingPage(), // Handle loading state if needed
      error: (error, stackTrace) {
        return const LoadingPage();
      },
    );
  }
}
