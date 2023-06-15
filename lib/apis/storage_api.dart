import 'package:appwrite/appwrite.dart';
import 'package:code_chronicles/core/core.dart';
import 'package:code_chronicles/utils/constants.dart';
import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final storageAPIProvider = Provider((ref) {
  return StorageAPI(
    storage: ref.watch(appwriteStorageProvider),
  );
});

class StorageAPI {
  final Storage _storage;
  StorageAPI({required Storage storage})
      : _storage = storage,
        super();

  Future<List<String>> uploadImages(List<File> files) async {
    List<String> imageLinks = [];
    for (var file in files) {
      final uploadedImage = await _storage.createFile(
        bucketId: AppwriteConstants.mediastorageBucketId,
        fileId: ID.unique(),
        file: InputFile.fromPath(path: file.path),
      );
      imageLinks.add(
        AppwriteConstants.imageUrl(uploadedImage.$id),
      );
    }
    return imageLinks;
  }

  Future<String> uploadFile(File file) async {
    String imageLink = '';
    final uploadedImage = await _storage.createFile(
      bucketId: AppwriteConstants.mediastorageBucketId,
      fileId: ID.unique(),
      file: InputFile.fromPath(path: file.path),
    );
    imageLink = AppwriteConstants.imageUrl(uploadedImage.$id);
    return imageLink;
  }

  Future<String> uploadJson(String doc) async {
    String docLink = '';
    final uploadedImage = await _storage.createFile(
      bucketId: AppwriteConstants.mediastorageBucketId,
      fileId: ID.unique(),
      file: InputFile.fromPath(path: doc),
    );
    docLink = AppwriteConstants.imageUrl(uploadedImage.$id);
    
    // _storage.updateFile(bucketId: bucketId, fileId: fileId);

    return docLink;
  }
}
