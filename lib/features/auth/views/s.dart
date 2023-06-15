import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:code_chronicles/utils/constants.dart';
import 'package:flutter/material.dart';


class Sin extends StatefulWidget {
  const Sin({super.key});

  @override
  State<Sin> createState() => _SinState();
}

class _SinState extends State<Sin> {
  final _formKey = GlobalKey<FormState>();
  late String _username, _name, _email, _password;

  @override
  void initState() {
    super.initState();
  }

  checkFields() {
    final form = _formKey.currentState;
    if (form!.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return _body(context);
  }
  // r'^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$'

  Widget _body(BuildContext context) {
    return Scaffold(
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
                vertical: 29,
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
                padding: const EdgeInsets.fromLTRB(34, 17, 34, 34),
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
              key: _formKey,
              child: _loginForm(context),
            )
          ],
        ),
      ),
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
            validator: (value) {
              // value!.isEmpty ? 'Email is required' : validateEmail(value),
              if (value!.isEmpty) {
                return 'Email is required';
              } else {
                Pattern pattern =
                    r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
                RegExp regex = RegExp(pattern.toString());
                if (!regex.hasMatch(value)) {
                  return 'Enter Valid Email';
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
            validator: (value) {
              // value!.isEmpty ? 'Email is required' : validateEmail(value),
              if (value!.isEmpty) {
                return 'Email is required';
              } else {
                Pattern pattern =
                    r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
                RegExp regex = RegExp(pattern.toString());
                if (!regex.hasMatch(value)) {
                  return 'Enter Valid Email';
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
              this._email = value;
              // formData.email = value;
            },
            validator: (value) {
              // value!.isEmpty ? 'Email is required' : validateEmail(value),
              if (value!.isEmpty) {
                return 'Email is required';
              } else {
                Pattern pattern =
                    r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
                RegExp regex = new RegExp(pattern.toString());
                if (!regex.hasMatch(value)) {
                  return 'Enter Valid Email';
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
            ),
            obscureText: true,
            onChanged: (value) {
              this._password = value;
              // formData.password = value;
            },
            validator: (value) {
              // value!.isEmpty ? 'Email is required' : validateEmail(value),
              if (value!.isEmpty) {
                return 'Password is required';
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
        SizedBox(
          height: 20,
        ),
        Padding(
          padding: const EdgeInsets.all(14.0),
          child: GestureDetector(
            onTap: () {},
            child: Container(
              height: 50,
              child: Material(
                borderRadius: BorderRadius.circular(25),
                // shadowColor: Colors.lightBlueAccent,
                shadowColor: Pallete.kShadowColor,
                color: Pallete.kButtonColor,
                elevation: 7,
                child: Center(
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
        SizedBox(
          height: 20,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Already a member?'),
            SizedBox(
              width: 5,
            ),
            InkWell(
              onTap: () {
                // // todo
                // Navigator.of(context).push(
                //     MaterialPageRoute(builder: (context) => LoginScreen()));
              },
              child: Text(
                'Login',
                style: TextStyle(
                  color: Color(0xffff3E7BFA),
                  fontFamily: 'Ubuntu',
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
          ],
        ),
        SizedBox(
          height: 10,
        ),
      ],
    );
  }

  String validateEmail(String value) {
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern.toString());
    if (!regex.hasMatch(value))
      return 'Enter Valid Email';
    else
      // return null.toString();
      return 'All clear';
  }

  String validatePassword(String value) {
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern.toString());
    if (!regex.hasMatch(value))
      return 'Enter Valid Email';
    else
      // return null.toString();
      return '';
  }
}
