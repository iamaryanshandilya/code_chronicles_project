import 'package:code_chronicles/common/custom_loader.dart';
import 'package:code_chronicles/features/auth/controller/auth_controller.dart';
import 'package:code_chronicles/features/explore/views/search_view.dart';
import 'package:code_chronicles/features/explore/widgets/customTabView.dart';
import 'package:code_chronicles/features/explore/widgets/tab_post_view.dart';
import 'package:code_chronicles/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ExplorePageView extends ConsumerStatefulWidget {
  final UserModel userModel;
  const ExplorePageView({super.key, required this.userModel});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _ExplorePageViewState();
}

class _ExplorePageViewState extends ConsumerState<ExplorePageView>
    with SingleTickerProviderStateMixin {
  TabController? _tabController;

  int initPosition = 0;

  @override
  void initState() {
    super.initState();
    _tabController =
        TabController(vsync: this, length: widget.userModel.interests.length);
  }

  @override
  void dispose() {
    _tabController!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final appBarTextFieldBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(50),
      borderSide: const BorderSide(
          // color: Pallete.kBackButtonColor,
          ),
    );
    final currentUser = ref.watch(loggedInUserDetailsProvider).value;
    return currentUser == null
        ? const LoadingIndicator()
        : SafeArea(
            child: Scaffold(
              appBar: AppBar(
                automaticallyImplyLeading: false,
                toolbarHeight: 70,
                title: SizedBox(
                  // height: 50,
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => const SearchView(),
                              ),
                            );
                          },
                          readOnly: true,
                          autofocus: false,
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
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => const SearchView(),
                            ),
                          );
                        },
                        icon: const Icon(
                          Icons.search_rounded,
                        ),
                      ),
                    ],
                  ),
                ),

                // bottom: TabBar(
                //   controller: _tabController,
                //   unselectedLabelColor: Color(0xff3E7BFA),
                //   indicatorSize: TabBarIndicatorSize.label,
                //   indicatorPadding:
                //       EdgeInsets.only(top: 8, bottom: 8, right: 17, left: 17),
                //   indicator: BoxDecoration(
                //       borderRadius: BorderRadius.circular(50),
                //       color: Color(0xff3E7BFA)),
                //   tabs:
                //   ListView.builder(
                //                     itemCount: widget.userModel.interests.length,
                //                     itemBuilder: (BuildContext context, index) {
                //                       final post =  widget.userModel.interests[index];
                //                       return Tab(
                //       child: Padding(
                //         padding: const EdgeInsets.only(
                //             top: 8, bottom: 8, right: 17, left: 17),
                //         child: Container(
                //           constraints: const BoxConstraints(
                //             // maxHeight: 200.0,
                //             maxWidth: 140.0,
                //           ),
                //           decoration: BoxDecoration(
                //               borderRadius: BorderRadius.circular(50),
                //               border: Border.all(color: Color(0xff3E7BFA), width: 1)),
                //           child: Align(
                //             alignment: Alignment.center,
                //             child: Text("Accounts"),
                //             // child: Icon(Icons.person),
                //           ),
                //         ),
                //       ),
                //     );
                //                     })
                //   // [
                //   //   Tab(
                //   //     child: Padding(
                //   //       padding: const EdgeInsets.only(
                //   //           top: 8, bottom: 8, right: 17, left: 17),
                //   //       child: Container(
                //   //         constraints: const BoxConstraints(
                //   //           // maxHeight: 200.0,
                //   //           maxWidth: 140.0,
                //   //         ),
                //   //         decoration: BoxDecoration(
                //   //             borderRadius: BorderRadius.circular(50),
                //   //             border: Border.all(color: Color(0xff3E7BFA), width: 1)),
                //   //         child: Align(
                //   //           alignment: Alignment.center,
                //   //           child: Text("Accounts"),
                //   //           // child: Icon(Icons.person),
                //   //         ),
                //   //       ),
                //   //     ),
                //   //   ),
                //   //   Tab(
                //   //     child: Padding(
                //   //       padding: const EdgeInsets.only(
                //   //           top: 8, bottom: 8, right: 17, left: 17),
                //   //       child: Container(
                //   //         decoration: BoxDecoration(
                //   //             borderRadius: BorderRadius.circular(50),
                //   //             border: Border.all(color: Color(0xff3E7BFA), width: 1)),
                //   //         child: Align(
                //   //           alignment: Alignment.center,
                //   //           child: Text("Posts"),
                //   //           // child: Icon(Icons.radio_button_off),
                //   //         ),
                //   //       ),
                //   //     ),
                //   //   ),
                //   // ],
                // ),
              ),
              body: CustomTabView(
                initPosition: initPosition,
                itemCount: widget.userModel.interests.length,
                tabBuilder: (context, index) {
                  return Tab(
                    child: Padding(
                      padding: const EdgeInsets.only(
                          top: 8, bottom: 8, right: 0, left: 0),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: const Color(0xff3E7BFA),
                            width: 1,
                          ),
                        ),
                        child: Align(
                          alignment: Alignment.center,
                          child: Text(
                            widget.userModel.interests[index],
                          ),
                          // child: Icon(Icons.person),
                        ),
                      ),
                    ),
                  );
                },
                pageBuilder: (context, index) {
                  return TabPostView(
                    topic: widget.userModel.interests[index],
                  );
                  // return Center(
                  //   child: Text(
                  //     widget.userModel.interests[index],
                  //   ),
                  // );
                },
                onPositionChange: (index) {
                  initPosition = index;
                },
                // onScroll: (position) => print('$position'),
              ),
            ),
          );
  }
}
