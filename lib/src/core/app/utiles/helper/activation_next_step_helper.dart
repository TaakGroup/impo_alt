import 'package:get/get.dart';
import 'package:impo/src/core/app/constans/app_routes.dart';
import 'package:impo/src/features/activation/data/models/question_view_model.dart';
import '../../../../features/authentication/register/controller/register_controller.dart';
import '../../../../features/authentication/register/data/models/register_model.dart';

class ActivationNextStepHelper{

  RegisterModel registerModel = RegisterController.to.registerModel; // for request to server

  nextStep(int pageId,QuestionViewModel  currentQuestion){
    switch (pageId) {

      case 3: // صفحه سوال هدف نصب
        installationPurpose(currentQuestion); // انتخاب گزینه ها
        break;

      case 4: // صفحه سوال مدت بارداری
        pregnancyPeriod(currentQuestion); // انتخاب گزینه ها
        break;

      case 5: // صفحه سوال وضعیت پریود
        periodSituationIntent(currentQuestion); // انتخاب گزینه ها
        break;

      case 6: // صفحه سوال رابطه جنسی در روزهای باروری
        sexOnFertileDays(currentQuestion); // انتخاب گزینه ها
        break;

      case 7: // صفحه سوال اولین بارداریت رو تجربه میکنی
        pregnancyHistoryStatus(currentQuestion); // انتخاب گزینه ها
        break;

      case 8: //  صفحه سوال بیماری ها (اقدام به بارداری)
        sicknessIntent(currentQuestion); // انتخاب گزینه ها
        break;

      case 9: // صفحه وارد کردن آخرین پریود (اقدام به بارداری)
        goToDatePickerActivationPage(10);
        break;

      case 10: // صفحه وارد کردن طول دوره (اقدام به بارداری)
        goToDatePickerActivationPage(11);
        break;

      case 11: // صفحه وارد کردن طول پریود (اقدام به بارداری)
        goToRewardPage(13,offAll: true); // رفتن به صفحه  ارزش همدلی (اقدام به بارداری)
        break;

      case 12: // صفحه ارزش تقویم روزهای باروری (وارد کردن اطلاعات پریود)(اقدام به بارداری)
         goToDatePickerActivationPage(9); //  رفتن به روال وارد کردن اطلاعات پریود اطلاعات پریود (اقدام به بارداری)
        break;

      case 13: // صفحه ارزش همدلی (اقدام به بارداری)
         Get.toNamed(AppRoutes.addPartner); //  رفتن به روال اضافه کردن همدل (اقدام به بارداری)
        break;

      case 14: // صفحه وارد کردن شماره همدل

        break;

      case 15: // صفحه ارزش اقدام به بارداری
        goToQuestionPage(4); //  رفتن به صفحه سوال مدت بارداری
        break;

      case 16: // صفحه ارزش مدت کمتر از 6ماه
        goToQuestionPage(5); //  رفتن به صفحه سوال وضعیت پریود
        break;

      case 17: // صفحه ارزش پریودم نامنظمه
        goToQuestionPage(6); //  رفتن به صفحه سوال رابطه جنسی در روزهای باروری
        break;

      case 18: // صفحه ارزش رابطه جنسی در روزهای باروری داره
        goToQuestionPage(7); //  رفتن به صفحه سوال اولین بارداریت رو تجربه میکنی
        break;

      case 19: // صفحه ارزش اولین بارداریت رو تجربه میکنه آره
        goToQuestionPage(8); //  رفتن به صفحه سوال بیماری ها (اقدام به بارداری)
        break;

      case 20: // صفحه ارزش بیماری دارم(هر نوعش)(اقدام به بارداری)
        goToRewardPage(12); //  رفتن به صفحه ارزش تقویم روزهای باروری (وارد کردن اطلاعات پریود)(اقدام به بارداری)
        break;

      case 21: // صفحه ارزش مدت بیشتر از 6ماه
        goToQuestionPage(5); //  رفتن به صفحه سوال وضعیت پریود
        break;

      case 22: // صفحه ارزش وضعیت پریودش رو نمیدونه
        goToQuestionPage(6); //  رفتن به صفحه سوال رابطه جنسی در روزهای باروری
        break;

      case 23: // صفحه ارزش نمیدونه روزهای باروری چه روزهایی هست
        goToQuestionPage(7); //  رفتن به صفحه سوال اولین بارداریت رو تجربه میکنی
        break;

      case 24: // صفحه ارزش در حال حاضر بچه داره و اولین بارداریش نیست
        goToQuestionPage(8); //   رفتن به صفحه سوال بیماری ها (اقدام به بارداری)
        break;

      case 25: // صفحه ارزش وضعیت پریودم منظمه
        goToQuestionPage(6); //  رفتن به صفحه سوال رابطه جنسی در روزهای باروری
        break;

      case 26: // صفحه ارزش تجربه سقط داره
        goToQuestionPage(8); //  رفتن به صفحه سوال بیماری ها (اقدام به بارداری)
        break;

      case 27: // صفحه ارزش اصلی پریود ترکر
        goToDatePickerActivationPage(28); //  رفتن به صفحه سوال برنامه ریزی
        break;

      case 28: // صفحه سوال برنامه ریزی
        goToRewardPage(36); //  رفتن به صفحه ارزش برنامه ریزی
        break;

      case 29: // صفحه سوال وضعیت پریود (پریود ترکر)
        periodSituationPeriodTracker(currentQuestion); // انتخاب گزینه ها
        break;

      case 30: // صفحه سوال حس قبل از شروع پریود(PMS)
        feelingBeforeStartOfThePeriod(currentQuestion); // انتخاب گزینه ها
        break;

      case 31: // صفحه سوال بیماری ها(پریود ترکر)
        sicknessPeriodTracker(currentQuestion); // انتخاب گزینه ها
        break;

      case 32: // صفحه ارزش تقویم(وارد کردن اطلاعات پریود)(پریود ترکر)
        goToDatePickerActivationPage(33); // رفتن به روال وارد کردن اطلاعات پریود اطلاعات پریود (پریود ترکر)
        break;

      case 33: // صفحه وارد کردن آخرین پریود (پریود ترکر)

        goToDatePickerActivationPage(34);
        break;

      case 34: // صفحه وارد کردن طول دوره (پریود ترکر)
        goToDatePickerActivationPage(35);
        break;

      case 35: // صفحه وارد کردن طول پریود (پریود ترکر)
               // رفتن به صفحه  ارزش همدلی (پریود ترکر)
        break;

      case 36: // صفحه ارزش برنامه ریزی
        goToQuestionPage(30); //  رفتن به صفحه سوال حس قبل از شروع پریود(PMS)
        break;

      case 37: // صفحه ارزش PMS
        goToQuestionPage(29); //  رفتن به صفحه سوال وضعیت پریود (پریود ترکر)
        break;

      case 38: // صفحه ارزش پریود منظم(پریود ترکر)
        goToQuestionPage(31); //  رفتن به صفحه سوال بیماری ها (پریود ترکر)
        break;

      case 39: // صفحه ارزش بیماری دارم(هر نوعش)(پریود ترکر)
        goToRewardPage(32); //  رفتن به صفحه ارزش تقویم (وارد کردن اطلاعات پریود)(پریود ترکر)
        break;

      case 40: // صفحه ارزش PMDD
        goToQuestionPage(29); //  رفتن به صفحه سوال وضعیت پریود (پریود ترکر)
        break;

      case 41: // صفحه ارزش پریود نامنظم
        goToQuestionPage(31); //  رفتن به صفحه سوال بیماری ها (پریود ترکر)
        break;

      case 42: // صفحه ارزش نمیدونه پریودش در چه صورتی منظمه
        goToQuestionPage(31); //  رفتن به صفحه سوال بیماری ها (پریود ترکر)
        break;

      case 43: // صفحه ارزش جلوگیری از بارداری
        goToQuestionPage(44); //  رفتن به صفحه سوال رابطه جنسی در روزهای احتمال بارداری صفر
        break;

      case 44: // صفحه سوال رابطه جنسی در روزهای احتمال بارداری صفر
        sexOnTheDaysOfZeroChanceOfPregnancy(currentQuestion); // انتخاب گزینه ها
        break;

      case 45: // صفحه سوال روش های پیشگیری
        contraceptiveMethods(currentQuestion); // انتخاب گزینه ها
        break;

      case 46: // صفحه سوال وضعیت پریود (پیشگیری از بارداری)
        periodSituationPrevention(currentQuestion); // انتخاب گزینه ها
        break;

      case 47: // صفحه سوال بیماری ها (پیشگیری از بارداری)
        sicknessPrevention(currentQuestion); // انتخاب گزینه ها
        break;

      case 48: // صفحه ارزش تقویم روزهای باروری (وارد کردن اطلاعات پریود)(پیشگیری از بارداری)
        goToDatePickerActivationPage(49); //رفتن به روال وارد کردن اطلاعات  (پیشگیری از بارداری)
        break;

      case 49: // صفحه وارد کردن آخرین پریود(پیشگیری از بارداری)

        goToDatePickerActivationPage(50);
        break;

      case 50: // صفحه وارد کردن طول دوره(پیشگیری از بارداری)
        goToDatePickerActivationPage(51);
        break;

      case 51: // صفحه وارد کردن طول پریود (پیشگیری از بارداری)
        goToRewardPage(52,offAll: true); // رفتن به صفحه  ارزش همدلی (پیشگیری از بارداری)
        break;

      case 52: // صفحه ارزش همدلی(پیشگیری از بارداری)
        Get.toNamed(AppRoutes.addPartner); //  رفتن به روال اضافه کردن همدل (پیشگیری از بارداری)
        break;

      case 53: // صفحه ارزش بدون توجه به روزهای بارداری سکس میکنه یا نمیدونه چه روزهایی هست
        goToQuestionPage(45); // رفتن به صفحه سوال روش های پیشگیری
        break;

      case 54: // صفحه ارزش تمام گزینه های روش های پیشگیری
        goToQuestionPage(46); // رفتن به صفحه سوال منظم یا نامنظم بودن پریود (پیشگیری از بارداری)
        break;

      case 55: // صفحه ارزش پریود منظم(پیشگیری از بارداری)
        goToQuestionPage(47); // رفتن به صفحه سوال بیماری ها (پیشگیری از بارداری)
        break;

      case 56: // صفحه ارزش بیماری دارم(هر نوعش)(پیشگیری از بارداری)
        goToRewardPage(48); //  رفتن به صفحه ارزش تقویم روزهای باروری (وارد کردن اطلاعات پریود)(پیشگیری از بارداری)
        break;

      case 57: // صفحه ارزش پریود  نامنظم(پیشگیری از بارداری)
        goToQuestionPage(47); // رفتن به صفحه سوال بیماری ها (پیشگیری از بارداری)
        break;

      case 58: // صفحه ارزش نمیدونه پریودش در چه صورتی منطمه(پیشگیری از بارداری)
        goToQuestionPage(47); // رفتن به صفحه سوال بیماری ها (پیشگیری از بارداری)
        break;

      case 59: // صفحه ارزش بارداری
        goToQuestionPage(60); // رفتن به صفحه سوال سابقه زایمان
        break;

      case 60: // صفحه سوال سابقه زایمان
        pregnancyHistory(currentQuestion); // انتخاب گزینه ها
        break;

      case 61: // صفحه سوال بیماری زمینه ای خاص
        pregnancyDisease(currentQuestion); // انتخاب گزینه ها
        break;

      case 62: // صفحه ارزش برای اینکه بتوینم سن بارداریت رو بفهمیم
        goToDatePickerActivationPage(63); // رفتن به صفحه سوال محاسبه هفته بارداری
        break;

      case 63: // صفحه سوال محاسبه هفته بارداری
        goToRewardPage(64,offAll: true); // رفتن به صفحه ارزش همدلی (بارداری)
        break;

      case 64: // صفحه ارزش همدلی (بارداری)
        Get.toNamed(AppRoutes.addPartner); //  رفتن به روال اضافه کردن همدل (پیشگیری از بارداری)
        break;

      case 65: // صفحه ارزش گزینه زایمان سزارین
        goToQuestionPage(61); // رفتن به صفحه سوال بیماری زمینه ای خاص
        break;

      case 66: // صفحه ارزش بیماری زمینه ای خاص(هرنوعش)(ارزش کلینیک)
        goToRewardPage(62); // رفتن به صفحه ارزش برای اینکه بتوینم سن بارداریت رو بفهمیم
        break;

      case 67: // صفحه ارزش گزینه سابقه زایمان ندارم
        goToQuestionPage(61); // رفتن به صفحه سوال بیماری زمینه ای خاص
        break;

      case 68: // صفحه ارزش گزینه زایمان طبیعی
        goToQuestionPage(61); // رفتن به صفحه سوال بیماری زمینه ای خاص
        break;

    }
  }



  installationPurpose(QuestionViewModel  currentQuestion){
    for (var item in currentQuestion.questions){
      if(item.selected.value){
        switch (item.id) {
          case 1:
            goToRewardPage(59); // گزینه بارداری ==> رفتن به ارزش
            registerModel.status = WomanStatus.pregnancy;
            registerModel.periodStatus = PeriodStatus.notImportant;
            break;
          case 2:
            goToRewardPage(15); //  گزینه اقدام به بارداری ==> رفتن به ارزش
            registerModel.status = WomanStatus.menstruation;
            registerModel.periodStatus = PeriodStatus.intent;
            break;
          case 3:
            goToRewardPage(43); //  گزینه جلوگیری از بارداری ==> رفتن به ارزش
            registerModel.status = WomanStatus.menstruation;
            registerModel.periodStatus = PeriodStatus.prevention;
            break;
          case 4:
            goToRewardPage(27);//  گزینه قاعدگی ==> رفتن به ارزش
            registerModel.status = WomanStatus.menstruation;
            registerModel.periodStatus = PeriodStatus.notImportant;
            break;
        }
      }
    };
  } //   گزینه های صفحه سوال هدف نصب

  // سوالات مربوط به بارداری
  pregnancyHistory(QuestionViewModel  currentQuestion){
    for (var item in currentQuestion.questions){
      if(item.selected.value){
        switch (item.id) {
          case 1:
            goToRewardPage(65); // گزینه سزارین  ==> رفتن به ارزش
            registerModel.pragnencyHistoryType = PragnencyHistoryType.Caesarean;
            break;
          case 2:
            goToRewardPage(68); //  گزینه طبیعی ==> رفتن به ارزش
            registerModel.pragnencyHistoryType = PragnencyHistoryType.Natural;
            break;
          case 3:
            goToRewardPage(67); //  گزینه زایمان ندارم ==> رفتن به ارزش
            registerModel.pragnencyHistoryType = PragnencyHistoryType.NoExperienc;
            break;
        }
      }
    };
  }// گزینه های صفحه سوال سابقه زایمان
  pregnancyDisease(QuestionViewModel  currentQuestion){
    for (var item in currentQuestion.questions){
      if(item.selected.value){
        switch (item.id) {
          case 1:
            goToRewardPage(66); // گزینه فشار خون  ==> رفتن به ارزش
            registerModel.pragnencyDisease = PragnencyDisease.bloodPressure;
            break;
          case 2:
            goToRewardPage(66); //  گزینه دیابت ==> رفتن به ارزش
            registerModel.pragnencyDisease = PragnencyDisease.diabetes;
            break;
          case 3:
            goToRewardPage(66); //  گزینه چربی ==> رفتن به ارزش
            registerModel.pragnencyDisease = PragnencyDisease.fate;
            break;
          case 4:
            goToRewardPage(66);  //  گزینه بیماری قلبی ==> رفتن به ارزش
            registerModel.pragnencyDisease = PragnencyDisease.heartDisease;
            break;
          case 5:
            goToRewardPage(66);  //  گزینه آسم ==> رفتن به ارزش
            registerModel.pragnencyDisease = PragnencyDisease.asthma;
            break;
          case 6:
            goToRewardPage(66); //  گزینه نمیدونم ==> رفتن به ارزش
            registerModel.pragnencyDisease = PragnencyDisease.dontKnow;
            break;
          case 7:
            goToRewardPage(62); //  گزینه هیچ بیماری ای ندارم ==> رفتن به ارزش
            registerModel.pragnencyDisease = PragnencyDisease.noProblem;
            break;
        }
      }
    };
  } //گزینه های صفحه سوال بیماری زمینه ای خاص


  // سوالات مربطه به اقدام به بارداری
  pregnancyPeriod(QuestionViewModel  currentQuestion){
    for (var item in currentQuestion.questions){
      if(item.selected.value){
        switch (item.id) {
          case 1:
            goToRewardPage(16); // گزینه کم تر از 6ماه ==> رفتن به ارزش
            registerModel.pregnencyCommite = PregnancyCommit.lessThan6Month;
            break;
          case 2:
            goToRewardPage(21); //  گزینه بیش تر از 6ماه ==> رفتن به ارزش
            registerModel.pregnencyCommite = PregnancyCommit.moreThan6Month;
            break;
        }
      }
    };
  } //  گزینه های صفحه سوال مدت بارداری
  periodSituationIntent(QuestionViewModel  currentQuestion){
    for (var item in currentQuestion.questions){
      if(item.selected.value){
        switch (item.id) {
          case 1:
            goToRewardPage(25); // گزینه پریود منظم  ==> رفتن به ارزش
            registerModel.periodSituation = PeriodSituation.regular;
            break;
          case 2:
            goToRewardPage(17); //  گزینه پریود نامنظم ==> رفتن به ارزش
            registerModel.periodSituation = PeriodSituation.irregular;
            break;
          case 3:
            goToRewardPage(22); //  گزینه نمیدونه در چه صورتی پریود منظمه ==> رفتن به ارزش
            registerModel.periodSituation = PeriodSituation.dontKnow;
            break;
        }
      }
    };
  } // گزینه های صفحه سوال وضعیت پریود (اقدام به بارداری)
  sexOnFertileDays(QuestionViewModel  currentQuestion){
    for (var item in currentQuestion.questions){
      if(item.selected.value){
        switch (item.id) {
          case 1:
            goToRewardPage(18); // گزینه آره  ==> رفتن به ارزش
            registerModel.onFertilitySex = OnFertilitySex.haveSex;
            break;
          case 2:
            goToRewardPage(23); //  گزینه نه نمیدونم روزهای باروری چه روزهایی هست ==> رفتن به ارزش
            registerModel.onFertilitySex = OnFertilitySex.dontKnow;
            break;
        }
      }
    };
  } // گزینه های صفحه سوال رابطه جنسی در روزهای باروری
  pregnancyHistoryStatus(QuestionViewModel  currentQuestion){
    for (var item in currentQuestion.questions){
      if(item.selected.value){
        switch (item.id) {
          case 1:
            goToRewardPage(19); // گزینه آره  ==> رفتن به ارزش
            registerModel.pragnencyHistoryStatus = PregnancyHistoryStatus.fistTime;
            break;
          case 2:
            goToRewardPage(24); //  گزینه نه بچه دارم الان ==> رفتن به ارزش
            registerModel.pragnencyHistoryStatus = PregnancyHistoryStatus.haveKid;
            break;
          case 3:
            goToRewardPage(26); //  گزینه تجربه سقط دارم ==> رفتن به ارزش
            registerModel.pragnencyHistoryStatus = PregnancyHistoryStatus.abortingExperience;
            break;
          case 4:
            goToQuestionPage(8); //  گزینه دوست ندارم به این سوال پاسخ بدم ==> رفتن به سوال بعدی
            registerModel.pragnencyHistoryStatus = PregnancyHistoryStatus.notMatter;
            break;
        }
      }
    };
  } // گزینه های صفحه سوال اولین بارداریت رو تجربه میکنی
  sicknessIntent(QuestionViewModel  currentQuestion){
    for (var item in currentQuestion.questions){
      if(item.selected.value){
        switch (item.id) {
          case 1:
            goToRewardPage(20); // گزینه تنبلی یا کیست تخمدان  ==> رفتن به ارزش
            registerModel.sickness = Sickness.ovarianLaziness;
            break;
          case 2:
            goToRewardPage(20); //  گزینه فیبروم رحم ==> رفتن به ارزش
            registerModel.sickness = Sickness.uterineFibrosis;
            break;
          case 3:
            goToRewardPage(20); //  گزینه مشکلات تیروئید ==> رفتن به ارزش
            registerModel.sickness = Sickness.thyroidProblems;
            break;
          case 4:
            goToRewardPage(20);  //  گزینه آندومتریوز ==> رفتن به ارزش
            registerModel.sickness = Sickness.endometriosis;
            break;
          case 5:
            goToRewardPage(20);  //  گزینه اضافه وزن ==> رفتن به ارزش
            registerModel.sickness = Sickness.overweight;
            break;
          case 6:
            goToRewardPage(12); //  گزینه هیچ مشکلی ندارم ==> ررفتن به ارزش
            registerModel.sickness = Sickness.noProblem;
            break;
        }
      }
    };
  } // گزینه های صفحه سوال بیماری ها (اقدام به بارداری)


  // سوالات مربوط به پیشگیری از بارداری
  sexOnTheDaysOfZeroChanceOfPregnancy(QuestionViewModel  currentQuestion){
    for (var item in currentQuestion.questions){
      if(item.selected.value){
        switch (item.id) {
          case 1:
            goToQuestionPage(45); // گزینه آره  ==> رفتن به سوال روش های پیشگیری
            registerModel.preventionSexCommited = PreventionSexCommited.safeDays;
            break;
          case 2:
            goToRewardPage(53); //  گزینه بدون توجه به این موضوع رابطه جنسی انجام میدیم ==> رفتن به ارزش
            registerModel.preventionSexCommited = PreventionSexCommited.dontCare;
            break;
          case 3:
            goToRewardPage(53); //  گزینه نمیدونم باردار شدن در چه روزهایی کمتره ==> رفتن به ارزش
            registerModel.preventionSexCommited = PreventionSexCommited.dontKnow;
            break;
        }
      }
    };
  } // گزینه های صفحه سوال رابطه جنسی در روزهای باروری
  contraceptiveMethods(QuestionViewModel  currentQuestion){
    for (var item in currentQuestion.questions){
      if(item.selected.value){
        switch (item.id) {
          case 1:
            goToRewardPage(54); // گزینه کاندوم  ==> رفتن به ارزش
            registerModel.preventionWays = PreventionWays.condom;
            break;
          case 2:
            goToRewardPage(54); //  گزینه پیشگیری طبیعی ==> رفتن به ارزش
            registerModel.preventionWays = PreventionWays.naturalPervention;
            break;
          case 3:
            goToRewardPage(54); //  گزینه قرص پیشگیری از بارداری ==> رفتن به ارزش
            registerModel.preventionWays = PreventionWays.birthControlPills;
            break;
          case 4:
            goToRewardPage(54); //  گزینه آی یو دی ==> رفتن به ارزش
            registerModel.preventionWays = PreventionWays.IUD;
            break;
          case 5:
            goToRewardPage(54); //  گزینه قرص اورژانسی ==> رفتن به ارزش
            registerModel.preventionWays = PreventionWays.emergencyPill;
            break;
          case 6:
            goToRewardPage(54); //  گزینه سایر روش‍های پیشگیری ==> رفتن به ارزش
            registerModel.preventionWays = PreventionWays.otherWays;
            break;
        }
      }
    };
  } // گزینه های صفحه سوال روش های پیشگیری
  periodSituationPrevention(QuestionViewModel  currentQuestion){
    for (var item in currentQuestion.questions){
      if(item.selected.value){
        switch (item.id) {
          case 1:
            goToRewardPage(55); // گزینه پریود منظم  ==> رفتن به ارزش
            registerModel.periodSituation = PeriodSituation.regular;
            break;
          case 2:
            goToRewardPage(57); //  گزینه پریود نامنظم ==> رفتن به ارزش
            registerModel.periodSituation = PeriodSituation.irregular;
            break;
          case 3:
            goToRewardPage(58); //  گزینه نمیدونه در چه صورتی پریود منظمه ==> رفتن به ارزش
            registerModel.periodSituation = PeriodSituation.dontKnow;
            break;
        }
      }
    };
  } // گزینه های صفحه سوال وضعیت پریود (پیشگیری از بارداری)
  sicknessPrevention(QuestionViewModel  currentQuestion){
    for (var item in currentQuestion.questions){
      if(item.selected.value){
        switch (item.id) {
          case 1:
            goToRewardPage(56); // گزینه تنبلی یا کیست تخمدان  ==> رفتن به ارزش
            registerModel.sickness = Sickness.ovarianLaziness;
            break;
          case 2:
            goToRewardPage(56); //  گزینه فیبروم رحم ==> رفتن به ارزش
            registerModel.sickness = Sickness.uterineFibrosis;
            break;
          case 3:
            goToRewardPage(56); //  گزینه مشکلات تیروئید ==> رفتن به ارزش
            registerModel.sickness = Sickness.thyroidProblems;
            break;
          case 4:
            goToRewardPage(56);  //  گزینه آندومتریوز ==> رفتن به ارزش
            registerModel.sickness = Sickness.endometriosis;
            break;
          case 5:
            goToRewardPage(56);  //  گزینه اضافه وزن ==> رفتن به ارزش
            registerModel.sickness = Sickness.overweight;
            break;
          case 6:
            goToRewardPage(48); //  گزینه هیچ مشکلی ندارم ==> ررفتن به ارزش
            registerModel.sickness = Sickness.noProblem;
            break;
        }
      }
    };
  } // گزینه های صفحه سوال بیماری ها (پیشگیری از بارداری)
  

  // سوالات مربوط به پریود ترکر
  feelingBeforeStartOfThePeriod(QuestionViewModel  currentQuestion){
    for (var item in currentQuestion.questions){
      if(item.selected.value){
        switch (item.id) {
          case 1:
            goToRewardPage(37); // گزینه حس خاصی ندارم  ==> رفتن به ارزش
            registerModel.pmsStatus = PmsStatus.None;
            break;
          case 2:
            goToRewardPage(37); //  گزینه عصبی و حساس میشم ==> رفتن به ارزش
            registerModel.pmsStatus = PmsStatus.Pms;
            break;
          case 3:
            goToRewardPage(40); //  گزینه افسردگی شدید میگیرم و افکار خودکشی دارم ==> رفتن به ارزش
            registerModel.pmsStatus = PmsStatus.Pmdd;
            break;
        }
      }
    };
  }// گزینه های صفحه سوال حس قبل از شروع پریود(PMS)
  periodSituationPeriodTracker(QuestionViewModel  currentQuestion){
    for (var item in currentQuestion.questions){
      if(item.selected.value){
        switch (item.id) {
          case 1:
            goToRewardPage(38); // گزینه پریود منظم  ==> رفتن به ارزش
            registerModel.periodSituation = PeriodSituation.regular;
            break;
          case 2:
            goToRewardPage(41); //  گزینه پریود نامنظم ==> رفتن به ارزش
            registerModel.periodSituation = PeriodSituation.irregular;
            break;
          case 3:
            goToRewardPage(42); //  گزینه نمیدونه در چه صورتی پریود منظمه ==> رفتن به ارزش
            registerModel.periodSituation = PeriodSituation.dontKnow;
            break;
        }
      }
    };
  } // گزینه های صفحه سوال وضعیت پریود (پریود ترکر)
  sicknessPeriodTracker(QuestionViewModel  currentQuestion){
    for (var item in currentQuestion.questions){
      if(item.selected.value){
        switch (item.id) {
          case 1:
            goToRewardPage(39); // گزینه تنبلی یا کیست تخمدان  ==> رفتن به ارزش
            registerModel.sickness = Sickness.ovarianLaziness;
            break;
          case 2:
            goToRewardPage(39); //  گزینه فیبروم رحم ==> رفتن به ارزش
            registerModel.sickness = Sickness.uterineFibrosis;
            break;
          case 3:
            goToRewardPage(39); //  گزینه مشکلات تیروئید ==> رفتن به ارزش
            registerModel.sickness = Sickness.thyroidProblems;
            break;
          case 4:
            goToRewardPage(39);  //  گزینه آندومتریوز ==> رفتن به ارزش
            registerModel.sickness = Sickness.endometriosis;
            break;
          case 5:
            goToRewardPage(39);  //  گزینه اضافه وزن ==> رفتن به ارزش
            registerModel.sickness = Sickness.overweight;
            break;
          case 6:
            goToRewardPage(32); //  گزینه هیچ مشکلی ندارم ==> ررفتن به ارزش
            registerModel.sickness = Sickness.noProblem;
            break;
        }
      }
    };
  } // گزینه های صفحه سوال بیماری ها (پریود ترکر)


  goToRewardPage(int pageId,{bool offAll = false}){
    if(offAll){
      Get.offAllNamed(AppRoutes.reward, arguments:pageId);
    }else{
      if(Get.currentRoute == AppRoutes.reward){
        Get.offNamed(
            AppRoutes.reward,
            arguments:pageId,
            preventDuplicates: false
        );
      }else{
        Get.toNamed(
          AppRoutes.reward,
          arguments:pageId,
        );
      }
    }
  } // رفتن به صفحه ارزش
  goToQuestionPage (int pageId) async {
    if(Get.currentRoute == AppRoutes.question){
        Get.toNamed(AppRoutes.question,
          arguments: pageId,
          preventDuplicates: false
      );
    }else{
        Get.offNamed(AppRoutes.question,
          arguments: pageId,
      );
    }
  } // رفتن به صفحه سوال
  goToDatePickerActivationPage(int pageId){
    if(Get.currentRoute == AppRoutes.datePickerActivation){
      Get.toNamed(AppRoutes.datePickerActivation,
          arguments: pageId,
          preventDuplicates: false
      );
    }else{
      Get.offNamed(AppRoutes.datePickerActivation,
        arguments: pageId,
      );
    }
  } // رفتن به صفحه سوال دیت پیکری
}