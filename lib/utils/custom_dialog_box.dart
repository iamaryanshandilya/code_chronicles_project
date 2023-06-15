import 'package:code_chronicles/utils/constants.dart';
import 'package:flutter/material.dart';

class CustomDialogBox extends StatefulWidget {
  final String? title, descriptions, positiveBtnText, negativeBtnText;
  final GestureTapCallback? positiveBtnPressed, negativeBtnPressed;

  const CustomDialogBox(
      {Key? key,
      this.title,
      this.descriptions,
      this.positiveBtnText,
      this.negativeBtnText,
      this.negativeBtnPressed,
      this.positiveBtnPressed})
      : super(key: key);

  @override
  _CustomDialogBoxState createState() => _CustomDialogBoxState();
}

class _CustomDialogBoxState extends State<CustomDialogBox> {
  @override
  Widget build(BuildContext conpositiveBtnText) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Pallete.padding),
      ),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: contentBox(context),
    );
  }

  contentBox(context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          margin: const EdgeInsets.only(top: Pallete.avatarRadius),
          decoration: BoxDecoration(
            shape: BoxShape.rectangle,
            color: const Color.fromARGB(255, 178, 165, 200),
            borderRadius: BorderRadius.circular(Pallete.padding),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                widget.title!,
                style:
                    const TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
              ),
              const SizedBox(
                height: 15,
              ),
              Text(
                widget.descriptions!,
                style: const TextStyle(fontSize: 14),
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                height: 22,
              ),
              ButtonBar(
                buttonMinWidth: 100,
                alignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  TextButton(
                    child: Text(widget.negativeBtnText!),
                    onPressed: () {
                      if (widget.negativeBtnPressed == null) {
                        Navigator.of(context).pop();
                      } else {
                        widget.negativeBtnPressed!();
                      }
                    },
                  ),
                  TextButton(
                    onPressed: widget.positiveBtnPressed,
                    child: Text(widget.positiveBtnText!),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
