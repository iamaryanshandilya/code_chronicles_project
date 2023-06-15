import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:code_chronicles/core/core.dart';
import 'package:code_chronicles/features/auth/controller/auth_controller.dart';
import 'package:code_chronicles/features/auth/views/login_view.dart';
import 'package:code_chronicles/common/custom_loader.dart';
import 'package:code_chronicles/utils/application_permission_handler.dart';
import 'package:code_chronicles/utils/constants.dart';
import 'package:code_chronicles/utils/topics.dart';
import 'package:filter_list/filter_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:flutter_svg/flutter_svg.dart';

class SignUpView extends ConsumerStatefulWidget {
  static route() => MaterialPageRoute(
        builder: (context) => const SignUpView(),
      );
  const SignUpView({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SignUpViewState();
}

class _SignUpViewState extends ConsumerState<SignUpView> {
  List<String>? selectedTopics = [];
  final signUpFormKey = GlobalKey<FormState>();
  late String _username, _name, _email, _password;
  bool showPassword = false;

  @override
  void initState() {
    super.initState();
    _name = '';
    _username = '';
    _email = '';
    _password = '';
    // checkallpermission(context, false);
  }

  checkFields() {
    final form = signUpFormKey.currentState;
    if (form!.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  @override
  void dispose() {
    signUpFormKey.currentState!.dispose();
    super.dispose();
  }

  void onSignUp() {
    final form = signUpFormKey.currentState;
    checkFields();
    if (form!.validate()) {
      if (selectedTopics!.isEmpty) {
        _openFilterDialog().whenComplete(() {
          if (selectedTopics == null || selectedTopics!.isEmpty) {
            showSnackBar(context, 'Please select at least 1 topic');
            return;
          }
          ref.watch(authControllerProvider.notifier).signUp(
                name: _name,
                username: _username,
                email: _email,
                password: _password,
                topics: selectedTopics!,
                context: context,
              );
        });
      }
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
                        TypewriterAnimatedText(
                            'Hey buddy! Can\'t wait for you to join us ;)'),
                      ],
                      // isRepeatingAnimation: false,
                    ),
                  ),
                ),
                Form(
                  key: signUpFormKey,
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
              labelText: "name",
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
              _name = value;
            },
            keyboardType: TextInputType.name,
            validator: (value) {
              if (value!.isEmpty) {
                return 'The name is required';
              }
              return null;
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: TextFormField(
            textInputAction: TextInputAction.next,
            decoration: InputDecoration(
              hintText: 'you cannot change it later',
              labelText: "username",
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
              _username = value;
              // formData.email = value;
            },
            keyboardType: TextInputType.text,
            validator: (value) {
              // value!.isEmpty ? 'Email is required' : validateEmail(value),
              if (value!.isEmpty) {
                return 'Username is required';
              } else {
                Pattern pattern =
                    r'^(?=.{3,17}$)(?![.])(?!.*[.]{2})[a-z0-9._]+(?<![.])$';
                RegExp regex = RegExp(pattern.toString());
                if (!regex.hasMatch(value)) {
                  return 'Enter a valid username';
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
            onTap: onSignUp,
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
                    'Sign Up',
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
            const Text('Already a member?'),
            const SizedBox(
              width: 5,
            ),
            InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  LoginView.route(),
                );
              },
              child: const Text(
                'Login',
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

  Future<List<String>?> _openFilterDialog() async {
    // List<String>? selected = [];
    await FilterListDialog.display<String>(
      context,
      hideSelectedTextCount: true,
      themeData: FilterListThemeData(
        context,
        choiceChipTheme: ChoiceChipThemeData.light(context),
      ),
      headlineText: 'Select Topics',
      insetPadding: EdgeInsets.symmetric(horizontal: 25, vertical: 20),
      headerCloseIcon: IconButton(
        onPressed: () {},
        icon: const Icon(
          Icons.close,
        ),
      ),
      hideCloseIcon: true,
      height: 450,
      listData: topics,
      choiceChipBuilder: (context, item, isSelected) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            border: Border.all(
              color: isSelected! ? Colors.blue[300]! : Colors.grey[300]!,
            ),
          ),
          child: Text(item),
        );
      },
      selectedListData: selectedTopics,
      choiceChipLabel: (item) => item!,
      validateSelectedItem: (list, val) => list!.contains(val),
      controlButtons: [ControlButtonType.All, ControlButtonType.Reset],
      onItemSearch: (topic, query) {
        /// When search query change in search bar then this method will be called
        ///
        /// Check if items contains query
        return topic.toLowerCase().contains(query.toLowerCase());
      },
      onApplyButtonClick: (list) {
        setState(() {
          selectedTopics = List.from(list!);
        });
        Navigator.pop(context);
      },
    );

    // return selected;
  }
}
