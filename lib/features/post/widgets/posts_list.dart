import 'package:code_chronicles/common/custom_loader.dart';
import 'package:code_chronicles/common/error_page.dart';
import 'package:code_chronicles/features/auth/controller/auth_controller.dart';
import 'package:code_chronicles/features/post/controller/post_controller.dart';
import 'package:code_chronicles/features/post/widgets/post_tile.dart';
import 'package:code_chronicles/models/document_model.dart';
import 'package:code_chronicles/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PostList extends ConsumerWidget {
  const PostList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUser = ref.watch(loggedInUserDetailsProvider).value;
    return currentUser == null
        ? const LoadingPage()
        : ref.watch(getPostProvider).when(
              data: (posts) {
                return ref.watch(getLatestPostProvider).when(
                      data: (data) {
                        final latestPost = DocumentModel.fromMap(data.payload);
                        if (data.events.contains(
                            'databases.*.collections.${AppwriteConstants.postsCollectionId}.documents.*.create')) {
                          posts.insert(0, DocumentModel.fromMap(data.payload));
                        } else if (data.events.contains(
                            'databases.*.collections.${AppwriteConstants.postsCollectionId}.documents.*.update')) {
                          final startingPoint =
                              data.events[0].lastIndexOf('documents.');

                          final endPoint =
                              data.events[0].lastIndexOf('.update');

                          final postId = data.events[0]
                              .substring(startingPoint + 10, endPoint);

                          var post = posts
                              .where((element) => element.id == postId)
                              .first;
                          final postIndex = posts.indexOf(post);
                          posts.removeWhere((element) => element.id == post.id);

                          post = DocumentModel.fromMap(data.payload);
                          posts.insert(postIndex, post);
                        }

                        posts = posts.where((post) {
                          return ((currentUser.following
                                  .contains(post.authorId)) ||
                              (currentUser.userId == post.authorId));
                        }).toList();

                        if (posts.isEmpty) {
                          return Center(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 18.0, vertical: 18),
                              child: Text(
                                'Nothing to here right now',
                                style: TextStyle(
                                    fontSize: 18,
                                    fontFamily: 'Ubuntu',
                                    fontWeight: FontWeight.w500,
                                    color: Colors.grey[500]),
                              ),
                            ),
                          );
                        }

                        return ListView.builder(
                            itemCount: posts.length,
                            itemBuilder: (BuildContext context, index) {
                              final post = posts[index];
                              return PostTile(
                                documentModel: post,
                              );
                            });
                      },
                      error: (error, stackTrace) => ErrorText(
                        error: error.toString(),
                      ),
                      loading: () {
                        posts = posts.where((post) {
                          return ((currentUser.following
                                  .contains(post.authorId)) ||
                              (currentUser.userId == post.authorId));
                        }).toList();

                        if (posts.isEmpty) {
                          return Center(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 18.0, vertical: 18),
                              child: Text(
                                'Nothing to here right now',
                                style: TextStyle(
                                    fontSize: 18,
                                    fontFamily: 'Ubuntu',
                                    fontWeight: FontWeight.w500,
                                    color: Colors.grey[500]),
                              ),
                            ),
                          );
                        }

                        return ListView.builder(
                            itemCount: posts.length,
                            itemBuilder: (BuildContext context, index) {
                              final post = posts[index];
                              return PostTile(
                                documentModel: post,
                              );
                            });
                      },
                    );
              },
              error: (error, stackTrace) => ErrorText(
                error: error.toString(),
              ),
              loading: () => const Center(
                child: LoadingIndicator(),
              ),
            );
  }
}
