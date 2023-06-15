import 'dart:io';
import 'package:filter_list/filter_list.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

void showSnackBar(BuildContext context, String content) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    elevation: 20,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(24),
    ),
    content: Text(
      content,
      // style: const TextStyle(color: Colors.white),
    ),
    behavior: SnackBarBehavior.floating,
    // backgroundColor: const Color(0xff28293D),
  ));
}

String getNameFromEmail(String email) {
  return email.split('@')[0];
}

Future<List<File>> pickImages() async {
  List<File> images = [];
  final ImagePicker picker = ImagePicker();
  final imageFiles = await picker.pickMultiImage(
    imageQuality: 70,
  );
  if (imageFiles.isNotEmpty) {
    for (final image in imageFiles) {
      images.add(
        File(image.path),
      );
    }
  }
  return images;
}

Future<File?> pickImage() async {
  final ImagePicker picker = ImagePicker();
  final imageFile = await picker.pickImage(
    source: ImageSource.gallery,
    imageQuality: 70,
  );
  if (imageFile != null) {
    return File(imageFile.path);
  }
  return null;
}

Future<CroppedFile?> imageCropper(File image, CropStyle cropStyle, CropAspectRatio cropAspectRatio) async {
  final ImageCropper imageCropper = ImageCropper();
  final croppedFile = imageCropper.cropImage(
      sourcePath: image.path, cropStyle: cropStyle, aspectRatio: cropAspectRatio);
  return croppedFile;
}


Future<List<String>?> _openFilterDialog(List<String> topics, BuildContext context) async {
    List<String>? selected = [];
    await FilterListDialog.display<String>(
      context,
      hideSelectedTextCount: true,
      themeData: FilterListThemeData(
        context,
        choiceChipTheme: ChoiceChipThemeData.light(context),
      ),
      headlineText: 'Select Topics',
      insetPadding: EdgeInsets.symmetric(horizontal: 40, vertical: 20),

      headerCloseIcon: IconButton(
        onPressed: () {},
        icon: Icon(
          Icons.close,
        ),
      ),
      hideCloseIcon: true,

      height: 800,
      listData: topics,
      choiceChipBuilder: (context, item, isSelected) {
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            border: Border.all(
              color: isSelected! ? Colors.blue[300]! : Colors.grey[300]!,
            ),
          ),
          child: Text(item.name),
        );
      },
      selectedListData: selected,
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
        selected = List.from(list!);
        Navigator.pop(context);
      },
    );

    return selected;
  }