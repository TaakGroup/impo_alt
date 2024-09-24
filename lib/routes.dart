import 'package:get/get_navigation/src/routes/get_route.dart';
import 'package:get/get_navigation/src/routes/transitions_type.dart';
import 'package:impo/src/features/activation/activation_bindings.dart';
import 'package:impo/src/features/activation/view/pages/date_picker_activation_page.dart';
import 'package:impo/src/features/activation/view/pages/reward_page.dart';
import 'package:impo/src/features/authentication/register/view/pages/register_email_page.dart';
import 'package:impo/src/features/authentication/register/view/pages/register_number_page.dart';
import 'package:impo/src/features/activation/view/pages/question_page.dart';
import 'package:impo/src/features/activation/view/pages/set_date_of_birth_page.dart';
import 'package:impo/src/features/activation/view/pages/set_name_page.dart';
import 'package:impo/src/features/authentication/register/view/pages/verify_code_page.dart';
import 'package:impo/src/features/authentication/register/view/pages/welcoming_page.dart';
import 'package:impo/src/features/index/index_bindings.dart';
import 'package:impo/src/features/index/view/pages/index_page.dart';
import 'package:impo/src/features/subscription/subscription_bindings.dart';
import 'package:impo/src/features/subscription/view/pages/subscription_page.dart';
import 'src/core/app/constans/app_routes.dart';
import 'src/features/activation/view/pages/add_partner_page.dart';
import 'src/features/authentication/register/register_bindings.dart';

class Routs {
  static List<GetPage> routs = <GetPage>[
    GetPage(
      name: AppRoutes.welcoming,
      page: () => const WelcomingPage(),
      binding: WelcomingBindings(),
    ),
    GetPage(
      name: AppRoutes.number,
      page: () => const RegisterNumberPage(),
      binding: RegisterOtpBindings(),
      transition: Transition.noTransition
    ),
    GetPage(
        name: AppRoutes.email,
        page: () => const RegisterEmailPage(),
        binding: RegisterOtpBindings(),
        transition: Transition.noTransition
    ),
    GetPage(
      name: AppRoutes.verifyCode,
      page: () => const VerifyCodePage(),
      binding: VerifyCodeBindings(),
      transition: Transition.noTransition
    ),
    GetPage(
      name: AppRoutes.setName,
      page: () => const SetNamePage(),
      binding: SetNameBindings(),
      transition: Transition.noTransition
    ),
    GetPage(
        name: AppRoutes.setBirth,
        page: () => const SetDateOfBirthPage(),
        binding: SetDateOfBirthBindings(),
        transition: Transition.noTransition
    ),
    GetPage(
        name: AppRoutes.question,
        page: () => const QuestionPage(),
        binding: QuestionBindings(),
        transition: Transition.rightToLeft
    ),
    GetPage(
        name: AppRoutes.reward,
        page: () => const RewardPage(),
        binding: RewardBindings(),
        transition: Transition.rightToLeft
    ),
    GetPage(
        name: AppRoutes.datePickerActivation,
        page: () => const DatePickerActivationPage(),
        transition: Transition.rightToLeft,
        binding: DatePickerActivationBindings()
    ),
    GetPage(
        name: AppRoutes.addPartner,
        page: () => const AppPartnerPage(),
        transition: Transition.rightToLeft,
        binding: AddPartnerBindings()
    ),
    GetPage(
        name: AppRoutes.subscription,
        page: () => const SubscriptionPage(),
        binding: SubscriptionBindings(),
        transition: Transition.noTransition
    ),
    GetPage(
        name: AppRoutes.index,
        page: () => IndexPage(),
        bindings: [IndexBindings(), StoryBindings(), EditCycleBindings()],
        transition: Transition.noTransition
    ),
  ];
}