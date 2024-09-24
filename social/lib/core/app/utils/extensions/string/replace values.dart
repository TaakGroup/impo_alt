
extension ReplaceValues on String {
  String replaceValues(Map<String, dynamic> values) {
    RegExp regex = RegExp(r'@(\w+)');
    Iterable<RegExpMatch> matches = regex.allMatches(this);

    for (Match match in matches) {
      String? placeholder = match.group(1);
      dynamic value = values[placeholder];
      replaceAll(match.toString(), '$value');
    }

    return this;
  }
}
