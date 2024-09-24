import 'package:get_it/get_it.dart';
import 'package:impo/src/models/bottom_banner_model.dart';
import 'package:impo/src/models/circle_model.dart';
import 'package:impo/src/models/dashboard/dashboard_messages_and_notify_model.dart';
import 'package:impo/src/models/advertise_model.dart';
import 'package:impo/src/models/dashboard/pregnancy_numbers_model.dart';
import 'package:impo/src/models/partner/partner_model.dart';
import 'package:impo/src/models/profile/profile_all_data_model.dart';
import 'package:impo/src/models/register/register_parameters_model.dart';
import 'package:impo/src/models/signsModel/breastfeeding_signs_model.dart';
import 'package:impo/src/models/signsModel/pregnancy_signs_model.dart';
import 'package:impo/src/models/story_model.dart';

import '../models/bioRhythm/bio_model.dart';


GetIt locator = GetIt.I;

void setupLocator() {


  locator.registerLazySingleton<AdvertiseModel>(() => AdvertiseModelImplementation());
  locator.registerLazySingleton<CycleModel>(() => CycleModelImplementation());
  locator.registerLazySingleton<RegisterParamModel>(() => RegisterParamModelImplementation());
  locator.registerLazySingleton<AllDashBoardMessageAndNotifyModel>(() => AllDashBoardMessageAndNotifyModelImplementation());
  locator.registerLazySingleton<PartnerModel>(() => PartnerModelImplementation());
  locator.registerLazySingleton<PregnancySignsModel>(() => PregnancySignsModelImplementation());
  locator.registerLazySingleton<PregnancyNumberModel>(() => PregnancyNumberModelImplementation());
  locator.registerLazySingleton<BreastfeedingSignsModel>(() => BreastfeedingSignsModelImplementation());
  locator.registerLazySingleton<BioModel>(() => BioModelImplementation());
  locator.registerLazySingleton<ProfileAllDataModel>(() => ProfileAllDataModelImplementation());
  locator.registerLazySingleton<StoryLocatorModel>(() => StoryLocatorModelImplementation());
  locator.registerLazySingleton<BottomBannerModel>(() => BottomBannerModelImplementation());
  /// locator.registerLazySingleton<AlarmModel>(() => AlarmModelImplementation());
  /// locator.registerLazySingleton<AdvertiseModel>(() => AdvertiseModelImplementation());
  /// locator.registerLazySingleton<RandomMessageModel>(() => RandomMessageImplementation());

}