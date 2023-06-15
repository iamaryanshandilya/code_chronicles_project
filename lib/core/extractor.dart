import 'dart:core';

List<String> extractUrls(String text) {
// final urlRegExp = RegExp(
//     r"((https?:www\.)|(https?:\/\/)|(www\.))[-a-zA-Z0-9@:%._\+~#=]{1,256}\.[a-zA-Z0-9]{1,6}(\/[-a-zA-Z0-9()@:%_\+.~#?&\/=]*)?");

  String urlRegexPattern =
      r"(https?://(?:[\w-]+(?:\.[\w-]+)+)|www\.(?:[\w-]+(?:\.[\w-]+)+)|(?:[\w-]+(?:\.[\w-]+)+))(?:[\w.,@?^=%&:/~+#-]*[\w@?^=%&/~+#-])?";

  final urlRegExp = RegExp(urlRegexPattern);

  Iterable<RegExpMatch> matches = urlRegExp.allMatches(text);
  List<String> urls = [];

  for (var match in matches) {
    String val = text.substring(match.start, match.end);
    urls.add(val);
  }

  return urls;
}

List<String> extractHashtags(String text) {
  RegExp hashtagRegex = RegExp(r"#\w+");

  Iterable<RegExpMatch> matches = hashtagRegex.allMatches(text);
  List<String> hashtags = [];

  for (var match in matches) {
    String val = text.substring(match.start, match.end);
    hashtags.add(val);
  }

  return hashtags;
}

List<String> extractUsernames(String text) {

  String usernameRegexPattern =
      // r'(?<=^|\s)(@(?=.{3,17}$)(?![.])(?!.*[.]{2})[a-z0-9._]+(?<![.]))';
      r'(^\@\w+|(?<=\s)\@\w+)';

  // Regular expression to match usernames
  RegExp usernameRegex = RegExp(usernameRegexPattern);

  // Extract usernames from the string
  Iterable<RegExpMatch> matches = usernameRegex.allMatches(text);
  List<String> usernames = [];

  // Print the extracted usernames
  for (var match in matches) {
    String val = text.substring(match.start+1, match.end);
    usernames.add(val);
    print(val);
  }
  print(usernames);
  return usernames;
}

void main(List<String> argv) {
  String text = """My website url: https://blasanka.github.io/,
  aryan.shandilya14@gmail.com,
  http://localhost/console/project-6464a11c16c64a87a747/overview/platforms,
  http://127.0.0.1:8000/runcode/
Google search using: www.google.com, social media is facebook.com, http://example.com/method?param=flutter
stackoverflow.com is my greatest website. DartPad share: https://github.com/dart-lang/dart-pad/wiki/Sharing-Guide see this example and edit it here https://dartpad.dev/3d547fa15849f9794b7dbb8627499b00, Here is a URL: https://example.com and another one: www.google.com and chat.openai.com,
https://www.quora.com/qemail/tc?al_imp=eyJ0eXBlIjogMzMsICJoYXNoIjogIjIwMDM2MDU3OTI3MDI5ODM3OTJ8MXwxfDM4MTMzODYxNCJ9&al_pri=1&aoid=m2NrXHM1A8u&aoty=2&aty=4&cp=1&et=2&id=d86637a3259641429ac44944be6e1f5d&q_aid=VbBKDA4dOqB&uid=BQI6BMJ2w2,
https://docs.google.com/spreadsheets/u/1/d/e/2PACX-1vThnx32gEa_HOLNSLn1IWWgz3KTzSeVDxDIXq2Z8BgGtma4zPNxsP28tAhLrXwiMJwztQE9r7lsZrdj/pubhtml#,
https://google..............totallyrealurl,ofcourse!?
https://discord.com/channels/@me/931195240499511337
""";

  String t2 = '''Verified
THANK YOU ATL we had a BLAST #vvv 💥 WHAT A SHOW!!!!!! 🔥🔥 @theentertainerstour
@akshaykumar @dishapatani @imouniroy @sonambajwa @aparshakti_khurana @stebinben @zarakhan @jasleenroyal''';

  extractUrls(text);
  // extractHashtags(t2);
  extractUsernames(t2);
}

// void main() {
//   String text = "My email is john.doe@example.com and you can reach me at info@company.com.";
  
//   // Regular expression to match email addresses
//   RegExp emailRegex = RegExp(r"\b[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}\b");
  
//   // Extract email addresses from the string
//   Iterable<Match> matches = emailRegex.allMatches(text);
  
//   // Print the extracted email addresses
//   for (Match match in matches) {
//     print(match.group(0));
//   }
// }
