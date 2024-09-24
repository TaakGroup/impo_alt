
import '../../../../features/authentication/register/controller/register_controller.dart';

String replaceName(String text) {
  String newText = text.replaceAll('@اسم',RegisterController.to.registerModel.firstName!);
  return newText;
}