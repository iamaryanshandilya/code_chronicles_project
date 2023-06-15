import 'package:code_chronicles/common/custom_loader.dart';
import 'package:code_chronicles/common/error_page.dart';
import 'package:code_chronicles/features/explore/controller/explore_controller.dart';
import 'package:code_chronicles/features/explore/widgets/search_tile.dart';
import 'package:code_chronicles/utils/color_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SearchView extends ConsumerStatefulWidget {
  const SearchView({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SearchViewState();
}

class _SearchViewState extends ConsumerState<SearchView> {
  final searchController = TextEditingController();
  bool isShowUsers = false;

  @override
  void dispose() {
    super.dispose();
    searchController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final appBarTextFieldBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(50),
      borderSide: const BorderSide(
          // color: Pallete.kBackButtonColor,
          ),
    );
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 70,
        // automaticallyImplyLeading: false,
        title: SizedBox(
          // height: 50,
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: searchController,
                  onSubmitted: (value) {
                    setState(() {
                      isShowUsers = true;
                    });
                  },
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.all(10).copyWith(
                      left: 20,
                    ),
                    // fillColor: Pallete.kBackButtonColor,
                    // filled: true,
                    enabledBorder: appBarTextFieldBorder,
                    focusedBorder: appBarTextFieldBorder,
                    hintText: 'Search',
                  ),
                ),
              ),
              const SizedBox(
                width: 5,
              ),
              IconButton(
                onPressed: () {
                  setState(() {
                    isShowUsers = true;
                  });
                },
                icon: const Icon(
                  Icons.search_rounded,
                ),
              ),
            ],
          ),
        ),
      ),
      body: isShowUsers
          ? ref.watch(searchUserProvider(searchController.text)).when(
                data: (users) {
                  return Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: ListView.builder(
                      itemCount: users.length,
                      itemBuilder: (BuildContext context, int index) {
                        final user = users[index];
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: SearchTile(userModel: user),
                        );
                      },
                    ),
                  );
                },
                error: (error, st) => ErrorText(
                  error: error.toString(),
                ),
                loading: () => const Center(
                  child: LoadingIndicator(),
                ),
              )
          : const SizedBox(),
    );
  }
}
