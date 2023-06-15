# Code Chronicles - Flutter

## Summary

Code Chronicles is a platform to allow users to create, and share their articles related to programming, and tech in general. Users get to choose their interests, and are displayed posts based on those topics in the explore section, they can also follow the people they want. Code Chronicles uses the Quill Editor which is a rich-text editor. More information about what it is, and what features it provides can be found [here](https://pub.dev/packages/flutter_quill).

## Requirements

Before using this project, you will need to have Appwrite instance with Code Chronicles project ready. You can visit Appwrite's website for the [documentation](https://appwrite.io/docs).

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

This project uses Flutter 3.7

Please note, this project was only configured for android, refer to [this website](https://pub.dev/), and search for all packages in the `pubspec.yaml` file, and do the necessary configurations for iOS before trying to run the program on an Apple device, some packages do not work for web currently.

A demo for the project that shows its working
- [Youtube demo](https://youtu.be/Y3cCCpES-bg)

You will also need to add a file appwrite_constants.dart in `lib/utils/appwrite_constants.dart`

```
class AppwriteConstants {
  static const String databaseId = "<your_database_id>";
  static const String projectId = "<your_project_id";
  static const String endpoint = "https://cloud.appwrite.io/v1";
  static const String usersCollectionId = "<your_users_collection_id>";
  static const String notificationsCollectionId = "<your_notifications_collection_id>";
  static const String postsCollectionId = "<your_posts_collection_id>";
  static const String commentsCollectionId = "<your_comments_collection_id>";
  static const String mediastorageBucketId = "<your_media_storage_bucket_id>";

  static String imageUrl(String imageId) =>
      '$endpoint/storage/buckets/$mediastorageBucketId/files/$imageId/view?project=$projectId&mode=admin';
}

```

You will have to create a new appwrite project from the appwrite console, and create the users, notifications, posts, comments collection. Please refer to the `lib/models/` directory, and add the attributes based on the models there. Also, you dont need to add attributes for id(for posts, notifications, comments collections), and userId(in case of users collection).

You also need to add indexes based on the code for example: 
(Please note, your index name can be anything)

```
# For posts:  
postsDesc (name)
key (type)
createdAt (attribute)
DESC (order)

index_2 (name)
key (type)
authorId (attribute)
ASC (order)

# For users:
index_2 (name)
fulltext (type)
$id (internal attribute)
ASC (order)

# For comments:
parentPost (name)
key (type)
parentPostId (attribute)
ASC (order)

# For notifications:
notifications (name)
key (type)
userId (attribute)
ASC (order)
```

## Usage

```bash
$ git clone https://github.com/iamaryanshandilya/code_chronicles_project.git
$ cd code_chronicles_project
$ flutter run
```

Make sure to update Endpoint and ProjectID in `lib/api/client.dart`.

The application will be listening on port `3000`. You can visit in on URL `http://localhost:3000`.


### `assets`

The assets directory contains your images such as logos as well as anything else you would like your project to use, be sure to update `pubspec.yaml` with any addition folders.

More information about assets can be found in [the documentation](https://docs.flutter.dev/development/ui/assets-and-images).

### `lib/api`

The `lib/api` folder contains our API request client that is used for communicating with Appwrite endpoints.

### `lib/models`

The `lib/models` folder is where we put anything that represents data such as our models

### `lib/utils`

We use the `lib/utils` folder where we add all files that are constants, or are being used everywhere in the application

### `lib/common`

We use the `lib/common` folder contains all the common widgets we use in the project like loaders, and error handling texts

### `lib/core`

Our `lib/core` folder is where put all enums, and providers, and custom type_defs. It also has a `network_service` directory which handles what to do in case the application doesnt have access to internet

### `lib/features`

Directory `lib/features` is where we place all of our top level views and responsible for laying out how we present to our users, it also contains the controllers since, we kept the apis, front-end, and controllers separate for a cleaner architecture.

It also has widgets folder that contains all the widgets related to a certain feature

For more information on Widgets can be found in the [documentation](https://docs.flutter.dev/reference/widgets)
