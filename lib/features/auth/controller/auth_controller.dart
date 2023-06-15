import 'package:appwrite/models.dart';
import 'package:code_chronicles/apis/auth_api.dart';
import 'package:code_chronicles/apis/user_api.dart';
import 'package:code_chronicles/core/utils.dart';
import 'package:code_chronicles/features/auth/views/login_view.dart';
import 'package:code_chronicles/features/auth/views/sign_up_view.dart';
import 'package:code_chronicles/features/home/views/home_view.dart';
import 'package:code_chronicles/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:appwrite/models.dart' as model;

final authControllerProvider =
    StateNotifierProvider<AuthController, bool>((ref) {
  return AuthController(
    authAPI: ref.watch(authAPIProvider),
    userAPI: ref.watch(userAPIProvider),
  );
});

final currentUserAccountProvider = FutureProvider((ref) {
  final authController = ref.watch(authControllerProvider.notifier);
  return authController.currentUser();
});

final userDetailsProvider = FutureProvider.family((ref, String uid) {
  final authController = ref.watch(authControllerProvider.notifier);
  return authController.getUserData(uid);
});

final loggedInUserDetailsProvider = FutureProvider((ref) {
  final currentUserId = ref.watch(currentUserAccountProvider).value!.$id;
  final userDetails = ref.watch(userDetailsProvider(currentUserId));
  return userDetails.value;
});

class AuthController extends StateNotifier<bool> {
  final AuthAPI _authAPI;
  final UserAPI _userAPI;
  AuthController({
    required AuthAPI authAPI,
    required UserAPI userAPI,
  })  : _authAPI = authAPI,
        _userAPI = userAPI,
        super(false);

  Future<User?> currentUser() => _authAPI.currentUserAccount();

  void signUp({
    required String name,
    required String username,
    required String email,
    required String password,
    required List<String> topics,
    required BuildContext context,
  }) async {
    state = true;
    final res = await _authAPI.signUp(
      name: name,
      username: username,
      email: email,
      password: password,
    );
    // await Future.delayed(Duration(seconds: 5));
    state = false;

    res.fold(
      (l) {
        print(l
            .message);
        if (l.message.contains(' A user with the same email already exists in your project.')) {
          showSnackBar(context, ' A user with the same email\\username already exists');
        }
      },
      (r) async {
        UserModel userModel = UserModel(
          email: email,
          name: name,
          followers: const [],
          following: const [],
          profilePicture: '',
          bannerPicture: '',
          interests: topics,
          userId: username,
          bio: '',
        );
        final userResult = await _userAPI.saveUserData(userModel);
        userResult.fold((l) => showSnackBar(context, l.message), (r) {
          showSnackBar(context, 'Account created. Please login.');
          Navigator.push(
            context,
            LoginView.route(),
          );
        });
      },
    );
  }

  void login({
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    state = true;
    final res = await _authAPI.login(
      email: email,
      password: password,
    );
    state = false;
    res.fold(
      (l) => showSnackBar(context, l.message),
      (r) {
        // showSnackBar(context, 'Account created. Please login.');
        Navigator.push(
          context,
          HomeView.route(),
        );
      },
    );
  }

  void logout(BuildContext context) async {
    final res = await _authAPI.logoutUser();
    res.fold((l) => null, (r) {
      Navigator.pushAndRemoveUntil(
        context,
        SignUpView.route(),
        (route) => false,
      );
    });
  }

  Future<UserModel> getUserData(String uid) async {
    final document = await _userAPI.getUserData(uid);
    final userData = UserModel.fromMap(document.data);
    return userData;
  }
}
