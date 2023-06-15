import 'package:code_chronicles/utils/constants.dart';
import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onTap;
  const CustomButton({super.key, required this.onTap, required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(14.0),
      child: GestureDetector(
        onTap: onTap,
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
                text,
                style: const TextStyle(
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
    );
  }
}
