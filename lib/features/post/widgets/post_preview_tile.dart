import 'dart:io';
import 'package:code_chronicles/features/auth/controller/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:timeago/timeago.dart' as timeago;

class PostPreviewTile extends ConsumerWidget {
  final File? coverImage;
  final String title;
  final List<String>? topics;
  final String username;
  const PostPreviewTile({
    super.key,
    required this.coverImage,
    required this.title,
    required this.topics,
    required this.username,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0.8, 0.5, 0.8, 0.5),
      child: Container(
        width: 700,
        height: coverImage != null ? 207 : 180,
        child: Card(
          elevation: 5,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      topics!.length > 1
                          ? '${topics![0]} + ${topics!.length - 1} more'
                          : topics![0],
                      style: const TextStyle(
                          color: Colors.black38,
                          fontWeight: FontWeight.w500,
                          fontSize: 16.0),
                    ),
                    // Icon(Icons.more_horiz_outlined),
                    Icon(
                      Icons.more_vert_outlined,
                      color: Colors.black87.withOpacity(0.7),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0.0, 12.0, 0.0, 12.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Flexible(
                        flex: 3,
                        child: Text(
                          title,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 17.0,
                          ),
                        ),
                      ),
                      if (coverImage != null)
                        Flexible(
                          flex: 1,
                          child: coverImage != null
                              ? Container(
                                  height: 70.0,
                                  width: 70.0,
                                  child: Image.file(
                                    coverImage!,
                                    fit: BoxFit.cover,
                                  ))
                              : const SizedBox(),
                        ),
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          'by @$username',
                          style: const TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        Text(
                          // '${DateTime.now().day}.${DateTime.now().month}.${DateTime.now().year}',
                          ' · ${timeago.format(
                            DateTime.now(),
                            locale: 'en_short',
                          )}',
                          style: const TextStyle(
                            color: Colors.black45,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Icon(Icons.favorite_border),
                        Text('999'),
                        SizedBox(
                          width: 10,
                        ),
                        Icon(Icons.mode_comment_outlined),
                        Text('10k'),
                        SizedBox(
                          width: 10,
                        ),
                        // Icon(Icons.bookmark_border),
                      ],
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
    ;
  }
}
