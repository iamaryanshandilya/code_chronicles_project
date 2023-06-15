import 'package:code_chronicles/utils/color_constants.dart';
import 'package:flutter/material.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';

class Loader {
  void x(BuildContext context, String x) {
    if (x == 'loader') {
      Navigator.of(context).pop();
    }
  }

  Future<dynamic> loader(BuildContext context) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return WillPopScope(
          onWillPop: () async {
            return false;
          },
          child: Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(17),
            ),
            elevation: 0,
            backgroundColor: Colors.transparent,
            child: StackLoader(),
          ),
        );
      },
    );
  }

  Widget customLoader(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(17),
      ),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: Container(
        padding: EdgeInsets.only(left: 17, top: 31 + 17, right: 17, bottom: 17),
        margin: EdgeInsets.only(top: 31),
        decoration: BoxDecoration(
            shape: BoxShape.rectangle,
            // color: Colors.black87,
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(17),
            boxShadow: [
              BoxShadow(
                  color: Colors.transparent,
                  // Colors.black,
                  offset: Offset(0, 10),
                  blurRadius: 10),
            ]),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            SleekCircularSlider(
              onChange: null,
              // innerWidget: viewModel.innerWidget,
              appearance: CircularSliderAppearance(
                  customWidths: CustomSliderWidths(
                      trackWidth: 1, progressBarWidth: 10, shadowWidth: 31),
                  customColors: CustomSliderColors(
                      dotColor: Colors.transparent,
                      trackColor: Colors.transparent,
                      progressBarColor: Pallete.kButtonColor,

                      // shadowColor: Pallete.kButtonColor.withOpacity(0.4),
                      shadowColor: Pallete.kButtonColor,
                      shadowMaxOpacity: 0.02),
                  size: 69.0,
                  spinnerMode: true,
                  spinnerDuration: 1000),
            ),
            SizedBox(
              height: 17,
            ),
            Text(
              'Please wait...',
              style: TextStyle(fontSize: 14),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget waitingScreenLoader(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 17, top: 31 + 17, right: 17, bottom: 17),
      margin: EdgeInsets.only(top: 31),
      decoration: BoxDecoration(
          shape: BoxShape.rectangle,
          // color: Colors.black87,
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(17),
          boxShadow: [
            BoxShadow(
                // color: Colors.black,
                color: Colors.transparent,
                offset: Offset(0, 10),
                blurRadius: 10),
          ]),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          SleekCircularSlider(
            onChange: null,
            // innerWidget: viewModel.innerWidget,
            appearance: CircularSliderAppearance(
                customWidths: CustomSliderWidths(
                    trackWidth: 1, progressBarWidth: 10, shadowWidth: 31),
                customColors: CustomSliderColors(
                    dotColor: Colors.transparent,
                    trackColor: Colors.transparent,
                    progressBarColor: Pallete.kButtonColor,

                    // shadowColor: Pallete.kButtonColor.withOpacity(0.4),
                    shadowColor: Pallete.kButtonColor,
                    shadowMaxOpacity: 0.02),
                size: 69.0,
                spinnerMode: true,
                spinnerDuration: 1000),
          ),
          SizedBox(
            height: 17,
          ),
          Text(
            'Please wait...',
            style: TextStyle(fontSize: 14),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class StackLoader extends StatelessWidget {
  const StackLoader({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 17, top: 31 + 17, right: 17, bottom: 17),
      margin: EdgeInsets.only(top: 31),
      decoration: BoxDecoration(
          shape: BoxShape.rectangle,
          // color: Colors.black87,
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(17),
          boxShadow: [
            BoxShadow(
                // color: Colors.black,
                color: Colors.transparent,
                offset: Offset(0, 10),
                blurRadius: 10),
          ]),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          SleekCircularSlider(
            onChange: null,
            // innerWidget: viewModel.innerWidget,
            appearance: CircularSliderAppearance(
                customWidths: CustomSliderWidths(
                    trackWidth: 1, progressBarWidth: 10, shadowWidth: 31),
                customColors: CustomSliderColors(
                    dotColor: Colors.transparent,
                    trackColor: Colors.transparent,
                    progressBarColor: Pallete.kButtonColor,

                    // shadowColor: Pallete.kButtonColor.withOpacity(0.4),
                    shadowColor: Pallete.kButtonColor,
                    shadowMaxOpacity: 0.02),
                size: 69.0,
                spinnerMode: true,
                spinnerDuration: 1000),
          ),
          const SizedBox(
            height: 17,
          ),
          const Material(
            color: Colors.transparent,
            child: Text(
              'Please wait...',
              style: TextStyle(
                fontSize: 14,
                // color: Colors.black,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}

class LoadingPage extends StatelessWidget {
  const LoadingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: StackLoader(),
      ),
    );
  }
}

class LoadingIndicator extends StatelessWidget {
  const LoadingIndicator({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 17, top: 31 + 17, right: 17, bottom: 17),
      margin: EdgeInsets.only(top: 31),
      decoration: BoxDecoration(
          shape: BoxShape.rectangle,
          // color: Colors.black87,
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(17),
          boxShadow: [
            BoxShadow(
                // color: Colors.black,
                color: Colors.transparent,
                offset: Offset(0, 10),
                blurRadius: 10),
          ]),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          SleekCircularSlider(
            onChange: null,
            // innerWidget: viewModel.innerWidget,
            appearance: CircularSliderAppearance(
                customWidths: CustomSliderWidths(
                    trackWidth: 1, progressBarWidth: 10, shadowWidth: 31),
                customColors: CustomSliderColors(
                    dotColor: Colors.transparent,
                    trackColor: Colors.transparent,
                    progressBarColor: Pallete.kButtonColor,

                    // shadowColor: Pallete.kButtonColor.withOpacity(0.4),
                    shadowColor: Pallete.kButtonColor,
                    shadowMaxOpacity: 0.02),
                size: 69.0,
                spinnerMode: true,
                spinnerDuration: 1000),
          )
        ],
      ),
    );
  }
}
