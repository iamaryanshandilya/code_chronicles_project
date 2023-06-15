import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:code_chronicles/features/auth/controller/auth_controller.dart';
import 'package:code_chronicles/common/custom_loader.dart';
import 'package:code_chronicles/features/auth/views/sign_up_view.dart';
import 'package:code_chronicles/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:flutter_svg/flutter_svg.dart';

class LoginView extends ConsumerStatefulWidget {
  static route() => MaterialPageRoute(
        builder: (context) => const LoginView(),
      );
  const LoginView({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _LoginViewState();
}

class _LoginViewState extends ConsumerState<LoginView> {
    final GlobalKey<FormState> _loginFormKey =
      GlobalKey<FormState>(debugLabel: '_loginFormKey');
  late String _email, _password;
  bool showPassword = false;

  @override
  void initState() {
    super.initState();
    _email = '';
    _password = '';
  }

  @override
  void dispose() {
    _loginFormKey.currentState!.dispose();
    super.dispose();
  }

  checkFields() {
    final form = _loginFormKey.currentState;
    if (form!.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  void onLogin() {
    final form = _loginFormKey.currentState;
    checkFields();
    if (form!.validate()) {
      ref.watch(authControllerProvider.notifier).login(
            email: _email,
            password: _password,
            context: context,
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    return _body(context);
  }

  Widget _body(BuildContext context) {
    final isLoading = ref.watch(authControllerProvider);
    return Stack(
      children: [
        Scaffold(
          body: SingleChildScrollView(
            // physics: const NeverScrollableScrollPhysics(),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 58.0,
                    vertical: 20,
                  ),
                  child: Image.asset(
                    "assets/logos/light.png",
                    // width: 770,
                    // height: 140,
                  ),
                ),
                DefaultTextStyle(
                  style: const TextStyle(
                      fontSize: 14,
                      fontFamily: 'Ubuntu',
                      fontWeight: FontWeight.w700,
                      color: Colors.black
                      // fontStyle: FontStyle.italic,
                      ),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(34, 5, 34, 34),
                    child: AnimatedTextKit(
                      animatedTexts: [
                        // TypewriterAnimatedText(
                        //     'Everyone has a story, and we believe that the best way to tell it is through your own voice. That\'s why we bring Interkith to you. So, that you could share yours in your voice.'),
                        TypewriterAnimatedText('Welcome back!'),
                      ],
                      // isRepeatingAnimation: false,
                    ),
                  ),
                ),
                Form(
                  key: _loginFormKey,
                  child: _loginForm(context),
                )
              ],
            ),
          ),
        ),
        if (isLoading)
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            color: Colors.black.withOpacity(0.5),
            child: const Center(
              child: StackLoader(),
            ),
          ),
        if (!isLoading)
          SizedBox(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
          ),
      ],
    );
  }

  _loginForm(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: TextFormField(
            textInputAction: TextInputAction.next,
            decoration: InputDecoration(
              labelText: "email",
              fillColor: Colors.transparent,
              border: OutlineInputBorder(
                borderSide:
                    const BorderSide(color: Color(0xff3E7BFA), width: 2.0),
                borderRadius: BorderRadius.circular(25.0),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide:
                    const BorderSide(color: Color(0xff3E7BFA), width: 2.0),
                borderRadius: BorderRadius.circular(25.0),
              ),
            ),
            onChanged: (value) {
              _email = value;
              // formData.email = value;
            },
            keyboardType: TextInputType.emailAddress,
            validator: (value) {
              // value!.isEmpty ? 'Email is required' : validateEmail(value),
              if (value!.isEmpty) {
                return 'Your email is required';
              } else {
                Pattern pattern =
                    r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
                RegExp regex = RegExp(pattern.toString());
                if (!regex.hasMatch(value)) {
                  return 'Enter a valid email';
                } else
                // return null.toString();
                {
                  return null;
                }
              }
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: TextFormField(
            decoration: InputDecoration(
              labelText: "password",
              fillColor: Colors.transparent,
              border: OutlineInputBorder(
                borderSide:
                    const BorderSide(color: Color(0xff3E7BFA), width: 2.0),
                borderRadius: BorderRadius.circular(25.0),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide:
                    const BorderSide(color: Color(0xff3E7BFA), width: 2.0),
                borderRadius: BorderRadius.circular(25.0),
              ),
              suffixIcon: IconButton(
                icon: showPassword
                    ? const Icon(
                        Icons.visibility,
                        color: Colors.black,
                        size: 25,
                      )
                    : const Icon(
                        Icons.visibility_off,
                        color: Colors.black,
                        size: 25,
                      ),
                onPressed: () {
                  setState(() {
                    showPassword = !showPassword;
                  });
                },
              ),
            ),
            keyboardType: TextInputType.visiblePassword,
            obscureText: !showPassword,
            onChanged: (value) {
              _password = value;
              // formData.password = value;
            },
            validator: (value) {
              // value!.isEmpty ? 'Email is required' : validateEmail(value),
              if (value!.isEmpty) {
                return 'The password is required';
              } else {
                if (value.length < 8) {
                  return 'The password should be at least 8 characters long.';
                } else {
                  return null;
                }
              }
            },
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        Padding(
          padding: const EdgeInsets.all(14.0),
          child: GestureDetector(
            onTap: onLogin,
            child: Container(
              height: 50,
              child: Material(
                borderRadius: BorderRadius.circular(25),
                // shadowColor: Colors.lightBlueAccent,
                shadowColor: Pallete.kShadowColor,
                color: Pallete.kButtonColor,
                elevation: 7,
                child: const Center(
                  child: Text(
                    'Login',
                    style: TextStyle(
                      color: Colors.white,
                      fontFamily: 'Ubuntu',
                      // fontStyle: FontStyle.italic,
                      fontWeight: FontWeight.w100,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('New here?'),
            const SizedBox(
              width: 5,
            ),
            InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  SignUpView.route(),
                );
              },
              child: const Text(
                'Sign Up',
                style: TextStyle(
                  // color: Color(0xFFC12053FA),
                  fontFamily: 'Ubuntu',
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(
          height: 10,
        ),
      ],
    );
  }

  // void message(BuildContext context) {
  //   showDialog(
  //       context: context,
  //       builder: (BuildContext context) {
  //         return DBox(
  //           title: "Welcome",
  //           descriptions:
  //               "\"Everyone has stories to share, share yours in your voice and make new friends along the way using Interkith.\"",
  //           text: "OK",
  //         );
  //       });
  // }
}
