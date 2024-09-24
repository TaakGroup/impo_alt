
import 'package:impo/src/features/activation/controller/get_questions_controller.dart';
import 'package:impo/src/features/authentication/register/controller/register_controller.dart';
import 'package:impo/src/features/authentication/register/controller/register_number_controller.dart';
import 'package:impo/src/features/authentication/register/controller/welcoming_controller.dart';
import 'package:impo/src/features/authentication/register/data/datasources/auth_datasource.dart';
import 'package:impo/src/features/authentication/register/data/datasources/otp_remote_datasource.dart';
import 'package:impo/src/features/authentication/register/data/datasources/register_remote_datasource.dart';
import 'package:impo/src/features/authentication/register/data/repositories/auth_repository.dart';
import 'package:impo/src/features/authentication/register/data/repositories/otp_remote_repository.dart';
import 'package:impo/src/features/activation/data/repositories/questions_remote_repository.dart';
import 'package:impo/src/features/authentication/register/data/repositories/register_remote_repository.dart';
import 'package:taakitecture/taakitecture.dart';
import '../../activation/data/datasources/questions_remote_datasource.dart';
import 'controller/register_email_controller.dart';
import 'controller/resend_code_controller.dart';
import 'controller/verify_code_controller.dart';
import 'data/datasources/validate_identity_datasource.dart';
import 'data/repositories/validate_identiry_repository.dart';

class WelcomingBindings extends Injection {
  @override
  initController() {
    singleton(WelcomingController());
  }

  @override
  initDataSource() {}

  @override
  initRepository() {}
}

class RegisterOtpBindings extends Injection {
  @override
  initController() {
    singleton(RegisterNumberController(sl<OtpRemoteRepository>(), sl<AuthRemoteRepository>()));
    singleton(RegisterEmailController(sl<OtpRemoteRepository>(), sl<AuthRemoteRepository>()));
  }

  @override
  initDataSource() {
    singleton(AuthRemoteDataSource(sl()));
    singleton(OtpRemoteDataSource(sl()));
  }

  @override
  initRepository() {
    singleton(AuthRemoteRepository(sl<AuthRemoteDataSource>(), sl()));
    singleton(OtpRemoteRepository(sl<OtpRemoteDataSource>(), sl()));
  }
}

class VerifyCodeBindings extends Injection {
  @override
  initController() {
    singleton(VerifyCodeController(sl<ValidateIdentityRepository>()));
    singleton(ResendCodeController(sl<OtpRemoteRepository>()));
    singleton(GetQuestionsController(sl<QuestionsRemoteRepository>()),permanent: true);
    singleton(RegisterController(sl<RegisterRemoteRemoteRepository>()),permanent: true);
  }

  @override
  initDataSource() {
    singleton(ValidateIdentityDataSource(sl()));
    // singleton(RegisterRemoteDataSource(sl()));
    singleton(QuestionsRemoteDataSource(sl()));
    singleton(RegisterRemoteDataSource(sl()));
  }

  @override
  initRepository() {
    singleton(ValidateIdentityRepository(sl<ValidateIdentityDataSource>(), sl()));
    // singleton(RegisterRemoteRepository(sl<RegisterRemoteDataSource>(), sl()));
    singleton(QuestionsRemoteRepository(sl<QuestionsRemoteDataSource>(), sl()));
    singleton(RegisterRemoteRemoteRepository(sl<RegisterRemoteDataSource>(), sl()));
  }
}

