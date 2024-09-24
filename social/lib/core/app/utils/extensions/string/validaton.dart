extension Validation on String {
  bool get isValidPhoneNumber {
    final regex = RegExp(r'^[0][9][0-9]{9}$');
    return regex.hasMatch(this);
  }

  bool get isValidPrefixPhoneNumber {
    final regex = RegExp(r'^[0][9].*$');
    return regex.hasMatch(this);
  }
}
