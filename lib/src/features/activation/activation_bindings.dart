
import 'package:impo/src/features/activation/controller/add_partner_controller.dart';
import 'package:impo/src/features/activation/controller/date_picker_activation_controller.dart';
import 'package:impo/src/features/activation/controller/reward_controller.dart';
import 'package:impo/src/features/activation/data/datasources/add_partner_remote_datasource.dart';
import 'package:impo/src/features/activation/data/repositories/add_partner_remote_repository.dart';
import 'package:taakitecture/taakitecture.dart';

import 'controller/question_controller.dart';
import 'controller/set_data_of_birth_controller.dart';
import 'controller/set_name_controller.dart';

class SetNameBindings extends Injection {
  @override
  initController() {
    singleton(SetNameController());
  }

  @override
  initDataSource() {}

  @override
  initRepository() {}
}

class SetDateOfBirthBindings extends Injection {
  @override
  initController() {
    singleton(SetDataOfBirthController());
  }

  @override
  initDataSource() {}

  @override
  initRepository() {}
}

class QuestionBindings extends Injection {
  @override
  initController() {
    factory(() => QuestionController(),permanent: false);
  }

  @override
  initDataSource() {}

  @override
  initRepository() {}
}

class RewardBindings extends Injection {
  @override
  initController() {
    factory(() => RewardController(),permanent: false);
  }

  @override
  initDataSource() {}

  @override
  initRepository() {}
}

class DatePickerActivationBindings extends Injection {
  @override
  initController() {
    factory(() => DatePickerActivationController(),permanent: false);
  }

  @override
  initDataSource() {}

  @override
  initRepository() {}
}

class AddPartnerBindings extends Injection {
  @override
  initController() {
    singleton(AddPartnerController(sl<AddPartnerRemoteRepository>()));

  }

  @override
  initDataSource() {
    singleton(AddPartnerRemoteDataSource(sl()));
  }

  @override
  initRepository() {
    singleton(AddPartnerRemoteRepository(sl<AddPartnerRemoteDataSource>(), sl()));
  }
}