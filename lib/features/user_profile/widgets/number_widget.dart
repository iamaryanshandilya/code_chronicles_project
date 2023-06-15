import 'package:code_chronicles/models/user_model.dart';
import 'package:flutter/material.dart';

class NumbersWidget extends StatelessWidget {
  final UserModel user;

  const NumbersWidget({Key? key, required this.user})
      : super(key: key);

  @override
  Widget build(BuildContext context) => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          // buildButton(context, number(1), 'posts'),
          // buildDivider(),
          buildButton(context, number(user.following.length), 'following'),
          buildDivider(),
          buildButton(context, number(user.followers.length), 'followers'),
        ],
      );
  Widget buildDivider() => Container(
        height: 24,
        child: VerticalDivider(),
      );

  Widget buildButton(
    BuildContext context,
    String value,
    String text,
  ) =>
      MaterialButton(
        splashColor: Colors.transparent,
        padding: EdgeInsets.symmetric(vertical: 4),
        onPressed: () {
          if (text == 'followers') {
            user.followers.forEach((element) {
            });
            // Navigator.of(context).push(
            //   MaterialPageRoute(
            //     builder: (context) => FollowingListPage(
            //         title: text, profile: user, userList: user.followers),
            //   ),
            // );
            // Navigator.push(
            //     context,
            //     FollowerListPage.getRoute(
            //         title: text, profile: user, userList: user.followersList));
          } else if (text == 'following') {
            user.following.forEach((element) {
            });
            // Navigator.of(context).push(
            //   MaterialPageRoute(
            //     builder: (context) => FollowingListPage(
            //         title: text, profile: user, userList: user.following),
            //   ),
            // );
            // Navigator.push(
            //     context,
            //     FollowerListPage.getRoute(
            //         title: text, profile: user, userList: user.followingList));
          }
        },
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Text(
              value,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            ),
            SizedBox(height: 2),
            Text(
              text,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
      );

  String number(int n) {
    late String numAsString;
    if (n < 1000) {
      numAsString = n.toString();
    } else if ((n >= 1000) && (n < 1000000)) {
      numAsString = (n / 1000).toStringAsFixed(1) + 'k';
    } else if (n >= 1000000) {
      numAsString = (n / 1000000).toStringAsFixed(1) + 'm';
    }
    return numAsString;
  }
}