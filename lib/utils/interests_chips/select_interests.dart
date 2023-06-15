import 'package:code_chronicles/utils/topics.dart';
import 'package:filter_list/filter_list.dart';
import 'package:flutter/material.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, this.title}) : super(key: key);
  final String? title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<String>? selectedInterests = [];

  Future<void> openFilterDelegate() async {
    await FilterListDelegate.show<String>(
      context: context,
      list: topics,
      selectedListData: selectedInterests,
      theme: FilterListDelegateThemeData(
        listTileTheme: ListTileThemeData(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          tileColor: Colors.white,
          selectedColor: Colors.red,
          selectedTileColor: const Color(0xFF649BEC).withOpacity(.5),
          textColor: Colors.blue,
        ),
      ),
      // enableOnlySingleSelection: true,
      onItemSearch: (topic, query) {
        return topics.contains(query.toLowerCase());
      },
      tileLabel: (topic) => topic,
      emptySearchChild: const Center(child: Text('No user found')),
      // enableOnlySingleSelection: true,
      searchFieldHint: 'Search Here..',
      /*suggestionBuilder: (context, user, isSelected) {
        return ListTile(
          title: Text(user.name!),
          leading: const CircleAvatar(
            backgroundColor: Colors.blue,
          ),
          selected: isSelected,
        );
      },*/
      onApplyButtonClick: (list) {
        setState(() {
          selectedInterests = list;
        });
      },
    );
  }

  Future<List<String>?> _openFilterDialog() async {
    List<String>? selectedInterestsToBeReturned = [];

    await FilterListDialog.display<String>(
      context,
      hideSelectedTextCount: true,
      themeData: FilterListThemeData(
        context,
        choiceChipTheme: ChoiceChipThemeData.light(context),
      ),
      headlineText: 'Select Users',
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
      selectedListData: selectedInterestsToBeReturned,
      choiceChipLabel: (item) => item!,
      validateSelectedItem: (list, val) => list!.contains(val),
      controlButtons: [ControlButtonType.All, ControlButtonType.Reset],
      onItemSearch: (topics, query) {
        /// When search query change in search bar then this method will be called
        ///
        /// Check if items contains query
        return topics.toLowerCase().contains(query.toLowerCase());
      },

      onApplyButtonClick: (list) {
        setState(() {
          selectedInterests = List.from(list!);
        });
        Navigator.pop(context);
      },
      // onCloseWidgetPress: () {
      //   // Do anything with the close button.
      //   //print("hello");
      //   Navigator.pop(context, null);
      // },
    );
    return selectedInterestsToBeReturned;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title!),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(bottom: 30),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            FilledButton(
              onPressed: () async {
                final list = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => FilterPage(
                      allTextList: topics,
                      selectedInterests: selectedInterests,
                    ),
                  ),
                );
                if (list != null) {
                  setState(() {
                    selectedInterests = List.from(list);
                  });
                }
              },
              child: const Text("Filter Page"),
            ),
            FilledButton(
              onPressed: _openFilterDialog,
              child: const Text("Filter Dialog"),
            ),
            FilledButton(
              onPressed: openFilterDelegate,
              child: const Text("Filter Delegate"),
            ),
          ],
        ),
      ),
      body: Column(
        children: <Widget>[
          if (selectedInterests == null || selectedInterests!.isEmpty)
            const Expanded(
              child: Center(
                child: Text('No user selected'),
              ),
            )
          else
            Expanded(
              child: ListView.separated(
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(selectedInterests![index]),
                  );
                },
                separatorBuilder: (context, index) => const Divider(),
                itemCount: selectedInterests!.length,
              ),
            ),
        ],
      ),
    );
  }
}

class FilterPage extends StatelessWidget {
  const FilterPage({Key? key, this.allTextList, this.selectedInterests})
      : super(key: key);
  final List<String>? allTextList;
  final List<String>? selectedInterests;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: FilterListWidget<String>(
          themeData: FilterListThemeData(context),
          hideSelectedTextCount: true,
          listData: topics,
          selectedListData: selectedInterests,
          onApplyButtonClick: (list) {
            Navigator.pop(context, list);
          },
          choiceChipLabel: (item) {
            /// Used to print text on chip
            return item!;
          },
          choiceChipBuilder: (context, item, isSelected) {
            return Container(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              decoration: BoxDecoration(
                  border: Border.all(
                color: isSelected! ? Colors.blue[300]! : Colors.grey[300]!,
              )),
              child: Text(item.name),
            );
          },
          validateSelectedItem: (list, val) {
            ///  identify if item is selected or not
            return list!.contains(val);
          },
          onItemSearch: (user, query) {
            /// When search query change in search bar then this method will be called
            ///
            /// Check if items contains query
            return user.toLowerCase().contains(query.toLowerCase());
          },
          // onCloseWidgetPress: () {
          //   print("hello");
          // },
        ),
      ),
    );
  }
}

