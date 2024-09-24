import 'package:get/get.dart';
import 'package:social/core/app/utils/extensions/string/validaton.dart';
import '../../constants/messages.dart';

class Validation {
  static String? requiredTextField(String? value) {
    if (value == null || value.isEmpty) {
      return Messages.requiredTextField;
    }

    return null;
  }

  static String? usernameValidation(String? value) {
    if (value == null || value.isEmpty) {
      return Messages.emptyUsernameError;
    } else if (value.length == 1) {
      return Messages.usernameError;
    }
    return null;
  }

  static String? noteTitleValidator(String? value) {
    if (value == null || value.isEmpty) {
      return Messages.noteTitleError;
    }
    return null;
  }

  static String? phoneNumberValidator(
    String? value, {
    String? Function()? onEmpty,
    String? Function()? onSuccess,
    String? Function()? onNotValidPrefix,
    String? Function()? onNotValidLength,
  }) {
    if (value != null && value.isEmpty) {
      return onEmpty?.call();
    } else if (!value!.isValidPrefixPhoneNumber) {
      return onNotValidPrefix?.call();
    } else if (!value.isValidPhoneNumber) {
      return onNotValidLength?.call();
    } else {
      return onSuccess?.call();
    }
  }

  static String? emailValidator(String? value) {
    if (value == null || value.isEmpty) {
      return Messages.emptyEmailError;
    } else if (!GetUtils.isEmail(value)) {
      return Messages.enterEmail;
    }
    return null;
  }

  static String? passwordValidator(String? value) {
    String pattern = r'^(?=.*[a-zA-Z])(?=.*[0-9]).{6,}$';
    RegExp regExp = RegExp(pattern);

    if (value == null || value.isEmpty) {
      return Messages.passwordValidationError;
    } else if (!regExp.hasMatch(value)) {
      return Messages.passwordValidationError;
    }
    return null;
  }
}
