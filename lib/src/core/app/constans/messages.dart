import "package:flutter/material.dart";
import "package:get/get.dart";

class Messages extends Translations {
  static var welcomeDescription = 'ورود با شماره همراه';

  static String forgotPassword = 'رمز عبور رو فراموش کردم';

  static String passwordValidationError = 'پسوردی که وارد میکنید باید ترکیبی از اعداد و حروف باشد';

  static var paymentNotValid = 'مشکلی در پرداخت پیش آمد، دوباره تلاش کنید';

  static var file = 'فایل';
  static var camera = 'دوربین';
  static var gallery = 'گالری';
  static String veryBad = 'خیلی بد';
  static String bad = 'بد';
  static String good = 'خوب';
  static String veryGood = 'خیلی خوب';
  static String notBad = 'متوسط';

  static var know = 'دانش';

  static var uploadLimitMessage = 'فایل ارسالی، باید کمتر از 10 مگا بایت باشه';

  static String? passwordEmptyError = 'اول رمز عبورت رو وارد کن';

  static String userInformation = 'اطلاعات کاربری';
  static String partner = 'هم‌دل';
  static String setting = 'تنظیمات برنامه';
  static String interfaceCode = 'کد معرف';
  static String support = 'پشتیبانی';
  static String aboutUs = 'درباره ما';

  static String name = 'نام';
  static String nameTitle = 'دوست داری با چه نام قشنگی تو ایمپو صدات کنیم؟ 😍 ';
  static String sex = 'رابطه جنسی';
  static String sexTitle = 'برای ارائه بهترین توصیه‌ها برای رابطه جنسی بهتره که بدونیم';
  static String country = 'کشور';
  static String countryTitle = 'لطفا کشور خود را انتخاب کنید';
  static String birthdayTitle = 'تو کدوم سال و ماه و روز با اومدنت دنیا رو قشنگ تر کردی؟ 🥹 ';
  static String calendarTitle = 'نوع تقویم خود را انتخاب کنید';
  static String short = 'نزدیک به هم';
  static String long = 'دور از هم (لانگ دیستنس)';
  static String successUpdate = 'با موفقیت به روز رسانی شد';
  static String loadingUpdate = 'چرخه در حال به روز رسانی';

  static Locale get persian => const Locale('fa', 'IR');

  static Locale get china => const Locale('cn', 'CHN');

  @override
  Map<String, Map<String, String>> get keys => {
        "fa_IR": {
          "cardPeriod": "ورود به فاز قاعدگی",
          "cardPeriodHelper": "تقویم قاعدگی و سلامت روان",
          "cardPregnancy": "ورود به فاز بارداری",
          "cardPregnancyHelper": "خودمراقبتی هفته به هفته دوران بارداری",
          "day": "روز",
          "whatDayPeriod": "روز چندمه پریودته؟",
          "notPeriod": "پریود نیستم",
          "myPeriodNow": "پریودم الان",
          "error": "خطا",
          "authError": "نام کاربری یا رمز عبور اشتباه است",
          "createCycle": "ساخت چرخه",
          "goNext": "برو بعدی",
          "menstruationTitle": "فعال کردن چرخه قاعدگی",
          "periodLengthHelper": "پریودت معمولا چند روز طول میکشه",
          "statePeriodHelper": "@user جان همین الان وضعیتت چجوریه؟",
          "cycleLengthTitle": "دوره پریود",
          "cycleLengthHelper1": "%نام کاربر% جان، هر چند روز یک بار پریود میشی؟ (فاصله از شروع یک پریود تا شروع پریود بعدی)",
          "cycleLengthHelper2": "%نام کاربر% جان، هر چند روز یک بار پریود میشی؟ (فاصله بین شروع دو پریودت متوالی)",
          "notRemember": "یادم نیست",
          "nextStep": "مرحله بعد",
          "loginHeader": "بزرگترین پلتفرم حوزه سلامت بانوان",
          "loginTitle": "ورود یا ثبت نام",
          "loginDescription": "برای مراقبت از خودت و پیوستن به جمع ایمپویی ها میتونی همین الان وارد اپلیکیشن ایمپو بشی",
          "loginEnterPhoneNumber": "ورود / ثبت نام با شماره همراه",
          "loginEnterEmail": "ورود / ثبت نام با ایمیل",
          "loginPrivacyText": "با ورود به ایمپو همه ***شرایط و قوانین*** استفاده از اپلیکیشن رو می‌پذیرم",
          "enterEmail": "ایمیلت رو وارد کن",
          "email": "ایمیل",
          "enterEmailDescription": "با وارد کردن ایمیلت، یک کد تایید به همین آدرس برات ارسال خواهد شد",
          "emailInputHintText": "اینجا وارد کن",
          "enterNumber": "شماره همراهت رو وارد کن",
          "phoneNumber": "شماره همراه",
          "enterNumberDescription": "در ادامه کد تایید به این شماره ارسال میشه",
          "numberInputHintText": "اینجا وارد کن",
          "enterNewPassword": "رمز عبور جدید رو وارد کن",
          "enterNewPasswordDescription": "رمز عبور شما باید ترکیبی از عدد و حروف و حداقل 5 کاراکتر باشه.",
          "repeatNewPasswordInputHintText": "تکرار رمز عبور",
          "verifyPhoneNumber": "تایید @platform",
          "verifyPhoneNumberDescription": "کد تاییدی که به شماره *** پیامک شده رو وارد کن",
          "notReceiveCode": "کد تایید رو دریافت نکردم",
          "enterName": "انتخاب نام",
          "enterNameDescription": "دوست داری در ایمپو چی صدات کنیم؟",
          "enterBirthDay": "انتخاب تاریخ تولد",
          "enterBirthDayDescription": "تو کدوم سال و ماه و روز دنیا رو با اومدنت قشنگ تر کردی؟",
          "enterGender": "دوست عزیزم رابطه جنسی داری؟",
          "enterGenderDescription":
              "این اطلاعات صرفا برای اینه که بتونیم بهتر راهنماییت کنیم و خریم شخصیت محسوب میشه و با کسی به اشتراک گذاشته نمیشه",
          "yesGender": "آره داشتم",
          "noGender": "نه نداشتم",
          "enterInstallPurpose": "ایمپو چطور میتونه کمکت کنه؟",
          "enterInstallPurposeDescription": "اگه بدونیم ایمپو رو با چه هدفی نصب کردی، بهتر می‌تونیم کمکت کنیم",
          "enterLastPeriodCalendar": "آخرین بار چه روزی پریودت شروع شد؟",
          "enterLastPeriodCalendarDescription":
              "به طور میانگین 70 درصد از خانم ها پریود @defaultPeriodLength روزه رو تجربه میکنن، تو میتونی این @defaultPeriodLength روز رو کم و زیاد کنی.",
          "enterNameInputHintText": "اینجا بنویس...",
          "continueStep": "ادامه",
          "emptyPhoneNumberError": "برای ادامه ثبت نام، لازمه که شماره همراهت رو وارد کنی",
          "phoneNumberErrorNotValidPrefix": "شماره همراهی که وارد میکنی باید با 09 شروع بشه",
          "phoneNumberErrorEmpty": "برای ادامه ثبت نام، لازمه که شماره همراهت رو وارد کنی",
          "phoneNumberErrorNotValidLength": "شماره همراهی که وارد کردی باید ۱۱ رقم باشه",
          "emptyEmailError": "لطفا ایمیل خود را وارد کنید",
          "emailError": "داداش داری اشتباه میزنی!!!",
          "connectionErrorTitle": "مشکلی پیش آمده",
          "connectionErrorMessage": "ارتباط با سرور دچار مشکل شد",
          "connectionErrorButtonText": "تلاش مجدد",
          "emptyUsernameError": "برای ادامه ثبت نام، لازمه که اسمت رو وارد کنی",
          "usernameError": "اسمی که انتخاب میکنی باید بیشتر از دو حرف باشه",
          "noteTitleError": "برای یاداشتت یه عنوان انتخاب کن",
          "normalDay": "روز عادی",
          "localizedReason": "امنیت ورود",
          "absencePregnancy": "عدم بارداری",
          "pregnancyIntention": "قصد بارداری",
          "pregnant": "باردار هستم",
          "signs": "نشانه ها",
          "cycleGuide": "راهنمای چرخه",
          "biorhythmTitle": "بیوریتم",
          "criticalDay": "روز بحرانی",
          "acceptPeriod": "ثبت پریود",
          "today": "امروز",
          "edit": "ویرایش",
          "returnToday": "بازگشت به امروز",
          "addNewNote": "ثبت یاداشت جدید",
          "addNote": "اضافه کردن یادداشت",
          "noteEmptyStateMessage": "یادداشتی برای امروز ثبت نکردی",
          "version": "Version",
          "cycle": "چرخه",
          "cycleLength": "طول دوره",
          "periodLength": "طول پریود",
          "enterToPregnancy": "ورود به فاز بارداری",
          "security": "امنیت",
          "connectedDevices": "دستگاه های متصل",
          "password": "رمز عبور",
          "financial": "مالی",
          "transactions": "لیست تراکنش ها",
          "sympathy": "همدلی",
          "settings": "تنظیمات",
          "notification": "اعلانات",
          "notificationSetting": "تنظیمات اعلان",
          "general": "عمومی",
          "theme": "پوسته",
          "inviteFriend": "دعوت از دوستان",
          "support": "پشتیبانی",
          "aboutUs": "درباره ما",
          "editProfile": "ویرایش پروفایل",
          "user": "کاربری",
          "logout": "خروج از کاربری",
          "dontLogoutMe": "نه، تو ایمپو می‌مونم",
          "logoutMe": "آره ولی برمی‌گردم",
          "logoutDescription": "@user 亲 你确定要从impo 退出吗？",
          "subscriptionRenewal": "تمدید اشتراک",
          "subscriptionDeadline": "تا پایان اشتراکت @day روز دیگه مونده:)",
          "shareCode": "اشتراک گذاری کد",
          "copy": "کپی کردن",
          "inviteFriendDes": "کد معرفت رو برای دوستانت بفرست و ده روز اشتراک رایگان از ایمپو هدیه بگیر.",
          "refralCode": "کد معرف",
          "dearUserExclamation": "@user عزیز!",
          "userName": "نام کاربری",
          "confirmChanges": "تایید تغییرات",
          "birthday": "تاریخ تولد",
          "disable": "غیر فعال",
          "connectedDevicesDescription": "اینجا میتونی دستگاه هایی که حساب ایمپوت روشون فعاله رو ببینی و هر کدوم که بخوای رو غیرفعال کنی",
          "currentDevice": "دستگاه کنونی",
          "availableDevice": "دستگاه‌های فعال",
          "connectedDeviceEmptyState": "دستگاه دیگه ای متصل نیست سید",
          "activePassword": "فعال کردن رمز",
          "activeBiometric": "فعال کردن اثرانگشت",
          "editPassword": "ویرایش رمز",
          "enterPrevPassword": "رمز قبلی رو وارد کن",
          "confirmPassword": "تایید رمز",
          "newPassword": "لطفا برای ورود به حساب کاربری یک رمز عبور شامل حرف و متن وارد کنید",
          "enterNewLocalPassword": "حالا رمز جدیدی که میخوای بسازی رو وارد کن",
          "repeatPassword": "تکرار رمز",
          "repeatPasswordDescription": "رمزی که در مرحله پیش وارد کردی رو دوباره تکرار کن",
          "setPassword": "ست کردن رمز",
          "enterRepeatPassword": "رمزی که در مرحله پیش وارد کردی رو دوباره تکرار کن",
          "enterNewLocalPasswordDescription": "با فعال کردن این رمز، با هر بار ورود به ایمپو لازمه که رمز رو وارد کنی",
          "confirm": "تایید",
          "repeatPasswordError": "رمز وارد شده با رمزی که انتخاب کردی مطابقت نداره",
          "dearUser": "@user عزیز",
          "remove": "حذف",
          "newReminder": "یادآور جدید",
          "study": "مطالعه",
          "workout": "ورزش",
          "water": "آب",
          "fruit": "میوه",
          "sleep": "خواب",
          "pill": "دارو",
          "pad": "تعویض پد بهداشتی",
          "mobile": "استفاده از موبایل",
          "dailyReminder": "یادآوری روزانه",
          "dailyReminderEmpty": "هنوز برای امروز یادآوری ثبت نکردی",
          "swapUpAlarm": "باشه حواسم هست",
          "addReminderDescription": "اگه یادآوری که میخوای در لیست زیر وجود نداره، یادآورجدید  مخصوص خودت رو بساز",
          "addReminder": "اضافه کردن یادآوری",
          "reminder": "یادآوری",
          "reminding": "یادآور",
          "noteTitle": "عنوان یادآور",
          "typeHere": "اینجا بنویس ...",
          "reminderTime": "ساعت یادآوری",
          "dailyReminderRepeatDays": "روزهای تکرار",
          "cancel": "انصراف",
          "state": "وضعیت",
          "active": "فعال",
          "deActive": "غیرفعال",
          "hour": "ساعت",
          "noteTextHint": "یادداشتت رو اینجا بنویس ...",
          "reminderEmptyState": "هنوز هیچ یادآوری اضافه نکردی",
          "transactionEmptyState": "لیست تراکنشی برای نمایش وجود نداره!",
          "reminderActivationMessage": "برای تنظیم ساعت لازمه که یادآور رو فعال کنی",
          "activationReminder": "تنظیم یادآور",
          "requestReminderPermissionMessage": "ایمپویی عزیز، برای فعال شدن یادآور باید از تنظیمات گوشی اجازه دسترسی بدی.",
          "requestReminderPermissionTitle": "فعال شدن یادآور",
          "dontAcceptReminderPermission": "اجازه نمیدم",
          "acceptReminderPermission": "اجازه میدم",
          "invalidTimePickedDec": "قالب ورودی زمان نادرست است.",
          "invalidTimePickedTitle": "لطفا زمان را بطور صحیح وارد کنید.",
          "am": "ق.ظ",
          "pm": "ب.ظ",
          "min": "دقیقه",
          "signsDescription": "برای اینکه بتونیم هینت‌های خوب" " برات بذاریم لازمه نشانه‌ها توی" " هر دوره رو برامون مشخص کنی!",
          "signsHelp": "راهنمای نشانه‌ها",
          "editCalendar": "ویرایش تقویم",
          "periodDays": "روزهای پریود",
          "pmsDays": "روزهای pms",
          "fertilityDays": "دوره باروری",
          "inCorrectPasswordDec": "رمز وارد شده اشتباهه",
          "inCorrectPasswordTitle": "رمز قفل",
          "careYourself": "مراقبت از خودت",
          "careYourselfDec": "ایمپو قبل از هرکاری بهت یادآوری میکنه که چقدر مهم هستی و بهت کمک میکنه تا بیشتر مراقب خودت باشی",
          "determiningFertility": "مشخص کردن دوره باروری",
          "determiningFertilityDec":
              "ایمپو با مشخص کردن دوره باروری و روز تخمک گذاری، بهترین زمان برای اقدام به بارداری  و کارهایی که باید در این روزها انجام بدی رو بهت یادآوری میکنه.",
          "periodReport": "گزارش پریودهای قبلی",
          "periodReportDec":
              "ایمپو با آماده کردن اطلاعات مربوط به پریودهای قبلیت و امکان به اشتراک گذاری اون با پزشکت، به منظم شدن پریود و بارداری کمک میکنه.",
          "absenceOfPregnancyForDeterminingFertilityDec":
              "ایمپو با مشخص کردن دوره باروری و روز تخمک گذاری، بهت یادآوری میکنه که در این روزها برای پیشگیری از بارداری بیشتر مراقبت کنی",
          "expertAdvice": "توصیه های تخصصی",
          "expertAdviceDec":
              "با ایمپو مراحل رشد جنین رو میبینی و توصیه های تخصصی برای مراقبت از خودت و جنین در هفته های مختلف بارداری رو دریافت میکنی",
          "reinderStoryTitle": "یادآوری زمان های مهم",
          "reinderStoryDec": "ایمپو زمان سونوگرافی، غربالگری و مراجعه به پزشک رو بهت یادآوری میکنه",
          "periodPrediction": "پیش بینی پریود",
          "periodPredictionDec":
              "ایمپو برات دوره های بعدی پریودت رو پیش بینی می کنه و توصیه هایی برای مراقبت از خودت در دوران پریود، pms و باروری ارسال میکنه",
          "periodReportStoryDec":
              "ایمپو با آماده کردن اطلاعات مربوط به پریودهای قبلیت و امکان به اشتراک گذاری اون با پزشکت، به منظم شدن پریودت و تشخیص اختلالات احتمالی قاعدگیت کمک میکنه",
          "report": "گزارش قاعدگی",
          "reportDec":
              "این گزارش نشون دهنده زمان های پیش بینی شده و اتفاق افتاده پریود شماست. میتونی این گزارش رو برای خودت ذخیره کنی و یا برای پزشکت بفرستی.",
          "reportTableHelper":
              "جدول زير گزارشي از تاريخ شروع پريود، طول پريود و طول دوره هاي شماست. لازم به ذكر است طول دوره اي كه شما در اپليكيشن وارد كرده ايد، n روز و طول پريود m روز است",
          "saveReportFile": "ذخیره فایل گزارش",
          "daysOfPeriodCycle": "روزهای دوره پریود",
          "dayOfStartCycle": "تاریخ شروع دوره",
          "avgCycle": "میانگین دوره",
          "abnormal": "غیر عادی",
          "pdfReportDec":
              "این گزارش نشون دهنده زمان های پیش بینی شده و اتفاق افتاده پریود شماست. میتونی این گزارش رو برای خودت ذخیره کنی و یا برای پزشکت بفرستی.",
          "period12monthReport": "گزارش دوره 12 ماهه پریود",
          "impoTitle": "بزرگترین پلتفرم حوزه سلامت قاعدگی زنان",
          "impoLink": "Impo.app",
          "readingTime": "خواندن در @n دقیقه",
          "comments": "کامنت ها",
          "category": "دسته بندی",
          "recommendedArticles": "مقالات توصیه شده",
          "articleCommentInputHint": "نظرت رو اینجا بنویس...",
          "searchArticle": "جست و جو مقالات",
          "searchResult": "نتایج جستجو",
          "recentSearch": "جستجوهای اخیر",
          "recentSearchEmpty": "هنوز مقاله ای جست و جو نکردی!",
          "searchResultEmpty": "نتیجه ای برای جست و جو پیدا نشد!",
          "articles": "مقاله های مخصوص تو",
          "recommendedArticlesDec": "این مقالات مخصوص شرایط و دوره ای هست که تجربه میکنی",
          "searchHint": "اینجا تایپ کنید",
          "averageMenstruation": "میانگین قاعدگی شما",
          "averageCycleLength": "میانگین روزهای دوره: @day روز",
          "reportLegendHelp": "راهنما:",
          "menstruationHistoryReport": "گزارش قاعدگی شما",
          "reportEmptyStateMessage":
              "برای اینکه بتونی یه گزارش از دوره های قبلی\nپریودت رو داشته باشی،\nلازمه حداقل سه دوره رو با ایمپو گذرونده باشی",
          "averagePeriodDay": "میانگین روزهای پریود: @day روز",
          "dateRangeText": "از @fromDate تا @toDate",
          "downloadingReport": "گزارش قاعدگی",
          "downloadingReportMessage": "در حال دریافت فایل گزارش قاعدگی",
          "downloadCompleteReport": "گزارش قاعدگی",
          "downloadCompleteReportMessage": "دانلود گزارش قاعدگیت کامل شد",
          "selectedDate": "روز انتخاب شده",
          "repeatPreviousPassword": "رمز قبلی",
          "repeatPreviousPreviousPasswordError": "رمز وارد شده اشتباهه",
          "repeatUpdatePassword": "تکرار رمز",
          "welcome": "به جمع ایمپویی‌ها خوش اومدی",
          "welcomeMessage": "ایمپو قبل از هرکاری بهت یادآوری میکنه که چقدر مهم هستی و بهت کمک میکنه تا بیشتر مراقب خودت باشی",
          "openOnboarding": "برو بریم",
          "calendar": "تقویم",
          "clinic": "کلینیک",
          "article": "مقالات",
          "partner": "همدلی",
          "bookmark": "ذخیره شده ها",
          "normalDays": "روز های عادی",
          "requestStoragePermissionMessage": "@user جان، اجازه دانلود فایل گزارش قاعدگیت رو به ایمپو میدی؟",
          "dontAcceptStoragePermission": "نه دانلودش نکن",
          "acceptStoragePermission": "آره، دانلودش کن",
          "commentEmpty": "برای این مقاله کامنتی نوشته نشده",
          "verifyEmailDescription": "کدتاییدی که به ایمیل @user ارسال شده رو وارد کن",
          "pregnancyDate": "ماه @month (هفته @week)",
          "childBirthDate": "@day روز تا زایمان",
          "networkFailureMessage": "به نظر میاد که دسترسیت به اینترنت قطع شده، درصورتی که فیلترشکنت روشنه خاموشش کن و دوباره امتحان کن",
          "serverFailureMessage": "مشکلی برامون پیش اومده که در حال بررسی و حلش هستیم. \nلطفا چند دقیقه دیگه دوباره امتحان کن",
          "networkFailureTitle": "اینترنتت وصل نیست",
          "serverFailureTitle": "ارتباط با ایمپو امکان پذیر نیست",
          "pregnancyTransitionMessage":
              "جوانه‌ای که در دلت پرورده میشه، به زودی نهالی سبز و تنومند میشه. دلت شاد و آینده‌اش پرفروغ. ایمپو هم به اندازه تو از این اتفاق سبز خوشحاله و در دوران بارداری هم مثل همیشه در کنارته",
          "impoUser": "ایمپویی",
          "back": "بازگشت",
          "completeInfo": "تکمیل اطلاعات",
          "breastfeedingTransitionMessage": "فرشته کوچولوی تو، این هدیه زیبای خدا، حالا\nدر آغوشته. مادر شدنت هزاران بار مبارک.",
          "bioQuestion": "درمورد بیوریتم سوال داری؟",
          "bioAnswer": "اینجا جوابش رو ببین",
          "breastfeedingCycleMessage": "روز @day مادری",
          "pregnancyWelcoming": "ورود به فاز بارداری",
          "requiredTextField": "لطفا وارد کنید",
          "createPregnancyCycle": "ورود به چرخه بارداری",
          "cycleSetting": "تنظیمات چرخه",
          "editPregnancy": "ویرایش بارداری",
          "weight": "وزن",
          "height": "قد جنین",
          "activePeriodCycle": "ثبت پریود",
          "pregnancySetting": "تنظیمات بارداری",
          "abortionTransitionMessage": "ما هم به اندازه تو برای از دست دادن فرشته کوچکت غمگینیم. در این روزهای سخت هم مثل همیشه در کناریتم",
          "onEditWeek": "تغییر هفته بارداری",
          "irPhoneNumberError": "شماره همراهی که وارد میکنی باید با 09 شروع بشه",
          "referralCodeSuccessStatusMessage": "کد معرف با موفقیت ثبت شد",
          "referralCode": "کد معرف",
          "enterReferralCode": "کد معرفت رو اینجا وارد کن",
          "writeHere": "اینجا بنویس..",
          "applyReferralCode": "اعمال کد معرف",
          "referralCodeHint": "کد معرف داری؟",
          "applyReferralCodeHint": "اینجا وارد کن",
          "notNow": "فعلا نه!",
          "notificationPermission": "دسترسی نوتیفیکیشن",
          "notificationPermissionTitle": "اگر نوتیف رو فعال کنی از این ویژگیها آگاه میشی:",
          "notificationValueForPermission1": "تغییرات جدید چرخه‌ت",
          "notificationValueForPermission2": "برنامه‌ریزی بهتر برنامه روزانه‌ت با توجه به تغییرات چرخه",
          "notificationValueForPermission3": "مطلع شدن از اتفاقات جدیدی که داخل ایمپو برات رقم میخوره ",
          "editCycle": "ویرایش چرخه",
          "setSexDescription": "ایمپویی عزیز، برای اینکه بتونیم بهت کمک کنیم لازمه جنسیتت رو بدونیم",
          "setSexTitle": "جنسیتت رو انتخاب کن",
          "male": "آقا",
          "female": "خانم",
          "menBioStoryTitle": "حال و احوال هر روزت",
          "menBioStoryDecoration":
              "در ایمپو بر اساس چرخه بیوریتم که از روز تولد هر آدمی\nمحاسبه میشه میتونی حال جسمانی، احساسی و ذهنی \nهر روزت رو متوجه بشی",
          "menPartnerStoryTitle": "بهبود رابطه جنسی و عاطفی",
          "menPartnerStory": "بهبود رابطه جنسی و عاطفی",
          "menPartnerDescription":
              "در قسمت همدل ایمپو میتونی از پریود پارتنرت باخبر بشی، بهتر بشناسیش و رابطه عاطفی و جنسی بهتری رو تجربه کنید",
          "menReminderStoryTitle": "سبک زندگی بهتر",
          "menReminderStoryDescription":
              "با ایمپو میتونی یادآورهایی برای داشتن یک سبک زندگی سالم\nرو تنظیم کنی و توصیه های تخصصی برای مراقبت از خودت\nدریافت کنی ",
          "supportDialogDescription": "مشکل شما ثبت شد . در اولین فرصت با شما تماس میگیریم",
          "enterMenBirthDayDescription": "تو کدوم سال و ماه و روز، متولد شدی؟",
          "periodTracker": "پریود ترکر",
          "ageError": "برای استفاده از ایمپو حداقل باید @n ساله باشی",
          "periodLenError": "طول پریود نباید کمتر از 3 روز  باشه",
          "healthCycleSetting": "تنظیم چرخه سلامت",
          "healthCycleSettingDes": "@user جان لطفا وضعیتت رو انتخاب کن",
          "splashNetworkFailure": "اتصال اینترنت برقرار نیست",
          "splashNetworkFailureDes": "لطفا تنظیمات اینترنت خودت رو بررسی و دوباره تلاش کن",
          "periodLenDays": "طول دوره:@day روزه",
          "daysAgo": "@day روز پیش",
          "hoursAgo": "@hour ساعت پیش",
          "minutesAgo": "@min دقیقه پیش",
          "recently": "لحظاتی پیش",
          "night": "شب",
          "afterNoon": "بعد از ظهر",
          "noon": "ظهر",
          "morning": "صبح",
          "impoSupport": "پشتیبانی ایمپو",
          "biorhythm": "بیوریتم",
          "readMore": "بیشتر بخون",
          "needToCheck": "(نیاز به بررسی)",
          "periodStartDate": "تاریخ شروع پریود :@date",
          "cycleLenDays": "طول دوره:@day روزه",
          "biorithem": "بیوریتم",
          "applyChanges": "تایید تغییرات",
          "or": "یا",
          "next": "شروع",
          "referralCodeTitle": "کد معرف داری؟",
          "enterHere": "اینجا وارد کن",
          'sa': 'شنبه',
          'su': 'یک',
          'mo': 'دو',
          'tu': 'سه',
          'we': 'چهار',
          'th': 'پنج',
          'fr': 'جمعه',
          'cycleActiveLastPeriodDescription': '(روز شروع پریود)',
          'cycleActiveNextPeriodTitle': 'تاریخ پریود بعدی',
          'cycleActiveNextPeriodDescription': 'فکر میکنی تاریخ شروع پریود بعدیت چه روزی باشه؟',
          'cycleActive2LastPeriodTitle': '@user جان،  تاریخ شروع پریود دو دوره قبلت کی بوده؟',
          'cycleActive2LastPeriodDescription': 'پریود دو دوره قبل',
          'cycleActivationNextPeriodStartTitle': '@user جان پریود بعدیت چه روزی شروع میشه؟',
          'cycleActivationNextPeriodStartDescription': 'روز شروع بعدی پریود',
          'cycleActiveLastPeriodStartTitle': '@user آخرین بار کی پریود شدی؟',
          'cycleActiveLastPeriodStartDescription': '(روز شروع پریود)',
          "ovulationDay": "روز تخمک گذاری",
          "currentDay": "روز جاری",
          "until": "تا",
          "lightMode": "حالت روز",
          "darkMode": "حالت شب",
          "systemDefault": "دیفالت سیستم",
        },
        "cn_CHN": {
          "cardPeriod": "进入月经期",
          "cardPeriodHelper": "月经规律与心理健康",
          "cardPregnancy": "进入怀孕期",
          "cardPregnancyHelper": "每周自我保健指南",
          "day": "日",
          "whatDayPeriod": "你当前月经周期第几天?",
          "notPeriod": "目前不是月经期",
          "myPeriodNow": "现在就是我的月经期",
          "error": "错误",
          "authError": "用户名或密码错误",
          "createCycle": "创建周期",
          "goNext": "进入下一步",
          "menstruationTitle": "激活月经周期",
          "periodLengthHelper": "你的月经期通常持续几天?",
          "statePeriodHelper": "@user亲,目前你的状况如何?",
          "cycleLengthTitle": "月经周期",
          "cycleLengthHelper1": "%用户名%,一般你一个周期多久(一个周期从开始到下一个开始的时间)?",
          "cycleLengthHelper2": "%用户名%,一般你一个周期多久(两个月经期之间的时间)?",
          "notRemember": "我不记得了",
          "nextStep": "下一步",
          "loginHeader": "女性健康专家平台",
          "loginTitle": "登录或注册",
          "loginDescription": "通过登录Impo应用,你可以随时照看自己并加入Impo大家族",
          "loginEnterPhoneNumber": "使用手机号码登录/注册",
          "loginEnterEmail": "通过邮箱登录/注册",
          "loginPrivacyText": "登录Impo表示你***同意所有***条款和政策",
          "enterEmail": "输入你的邮箱",
          "email": "邮箱",
          "enterEmailDescription": "输入邮箱后,我们将向该邮箱发送验证码",
          "emailInputHintText": "在这里输入",
          "enterNumber": "输入你的手机号",
          "phoneNumber": "手机号码",
          "enterNumberDescription": "我们向该号发验证码",
          "numberInputHintText": "这里输入",
          "enterNewPassword": "输入新的密码",
          "enterNewPasswordDescription": "您的密码必须包含数字和字母,至少5个字符。",
          "repeatNewPasswordInputHintText": "重复密码",
          "verifyPhoneNumber": "验证@platform",
          "verifyPhoneNumberDescription": "短信发送给***的确认码",
          "notReceiveCode": "我没有收到验证码",
          "enterName": "选择名字",
          "enterNameDescription": "您希望我们如何称呼您呢?",
          "enterBirthDay": "选择生日",
          "enterBirthDayDescription": "您是在哪一年，月、日 、让这个世界变得更美好的?",
          "enterGender": "@user朋友,您有性关系吗?",
          "enterGenderDescription": "这些信息仅用于为您提供更好的指导,它被视为个人信息并不会共享.",
          "yesGender": "有",
          "noGender": "没有",
          "enterInstallPurpose": "Impo如何能帮助你?",
          "enterInstallPurposeDescription": "如果我们了解您安装Impo的目的,我们可以更好地帮助您。",
          "enterLastPeriodCalendar": "您最近一次经期是哪一天？",
          "enterLastPeriodCalendarDescription": "平均70%的女性每个经期为@defaultPeriodLength天，你可以改变这个@defaultPeriodLength天的范围。",
          "enterNameInputHintText": "这里输入",
          "continueStep": "继续",
          "emptyPhoneNumberError": "继续注册,您需要输入您的手机号码",
          "phoneNumberErrorNotValidPrefix": "输入的手机号码应以09开头",
          "phoneNumberErrorEmpty": "继续注册,您需要输入您的手机号码",
          "phoneNumberErrorNotValidLength": "输入的手机号码应为11位",
          "emptyEmailError": "正确输入您的电子邮件",
          "emailError": "正确输入您的电子邮件",
          "connectionErrorTitle": "出现问题",
          "connectionErrorMessage": "您的互联网访问已中断，如果您的VPN已打开，请关闭它并重试",
          "connectionErrorButtonText": "重试",
          "emptyUsernameError": "继续注册需要输入用户名",
          "usernameError": "选择的用户名必须超过两个字符",
          "noteTitleError": "为笔记选择一个标题",
          "normalDay": "普通的一天",
          "localizedReason": "安全登录",
          "absencePregnancy": "不是孕育期",
          "pregnancyIntention": "意欲孕育",
          "pregnant": "我当时是孕育期",
          "signs": "症状",
          "cycleGuide": "月经周期指南",
          "biorhythmTitle": "生理节律",
          "criticalDay": "关键日期",
          "acceptPeriod": "登记月经周期",
          "today": "今天",
          "edit": "编辑",
          "returnToday": "返回今天",
          "addNewNote": "添加新的笔记",
          "addNote": "添加笔记",
          "noteEmptyStateMessage": "今天还没有添加笔记",
          "version": "版本",
          "cycle": "周期",
          "cycleLength": "月经周期长度",
          "periodLength": "经期长度",
          "enterToPregnancy": "进入妊娠期",
          "security": "安全",
          "connectedDevices": "连接设备",
          "password": "密码",
          "financial": "财务",
          "transactions": "交易列表",
          "sympathy": "同情",
          "settings": "设置",
          "notification": "通知",
          "notificationSetting": "通知设置",
          "general": "一般",
          "theme": "主题",
          "inviteFriend": "邀请朋友",
          "support": "支持",
          "aboutUs": "关于我们",
          "editProfile": "编辑个人资料",
          "user": "用户",
          "logout": "退出登录",
          "dontLogoutMe": "不  我在impo驻足",
          "logoutMe": "是 ，我一会回来",
          "logoutDescription": "亲 你确定要从impo 退出吗？",
          "subscriptionRenewal": "续订订阅",
          "subscriptionDeadline": "你的订阅还有@day天结束:",
          "shareCode": "分享代码",
          "copy": "复制",
          "inviteFriendDes": "把你的推荐码分享给朋友,他可以免费用Impo 10天。",
          "refralCode": "推荐码",
          "dearUserExclamation": "@user 亲!",
          "userName": "用户名",
          "confirmChanges": "确认更改",
          "birthday": "出生日期",
          "disable": "非激活",
          "connectedDevicesDescription": "这里你可以查看并且禁用当前impo的账户的设备。",
          "currentDevice": "当前设备",
          "availableDevice": "激活设备",
          "connectedDeviceEmptyState": "没有其他连接设备了朋友",
          "activePassword": "激活密码",
          "activeBiometric": "激活指纹",
          "editPassword": "编辑密码",
          "enterPrevPassword": "输入前一个密码",
          "confirmPassword": "确认密码",
          "newPassword": "新密码",
          "enterNewLocalPassword": "现在输入你想设置的新密码",
          "repeatPassword": "重复密码",
          "repeatPasswordDescription": "重复您在前一步输入的密码",
          "setPassword": "设置密码",
          "enterRepeatPassword": "重复输入您在前一步输入的密码",
          "enterNewLocalPasswordDescription": "通过激活密码，每次登录需要输入密码。",
          "confirm": "确认",
          "repeatPasswordError": "输入的密码与选择的密码不匹配",
          "dearUser": "@user 亲",
          "remove": "删除",
          "newReminder": "新的提醒",
          "study": "学习",
          "workout": "锻炼",
          "water": "水",
          "fruit": "水果",
          "sleep": "睡眠",
          "pill": "药",
          "pad": "更换卫生巾",
          "mobile": "使用手机",
          "dailyReminder": "每日提醒",
          "dailyReminderEmpty": "今天还没有设置提醒",
          "swapUpAlarm": "我会注意的",
          "addReminderDescription": "如果你想添加的提醒不在下面的列表中,可以创建自定义提醒。",
          "addReminder": "添加提醒",
          "reminder": "提醒",
          "reminding": "提醒",
          "noteTitle": "提醒标题",
          "typeHere": "在这里输入…",
          "reminderTime": "提醒时间",
          "dailyReminderRepeatDays": "重复日期",
          "cancel": "取消",
          "state": "状态",
          "active": "激活",
          "deActive": "禁用",
          "hour": "小时",
          "noteTextHint": "在这里输入备注…",
          "reminderEmptyState": "还没有添加任何提醒",
          "transactionEmptyState": "没有显示记录!",
          "reminderActivationMessage": "需要激活提醒才能设置时间",
          "activationReminder": "设置提醒",
          "requestReminderPermissionMessage": "亲爱的Impo,需要通过手机设置允许应用访问权限才能激活提醒。",
          "requestReminderPermissionTitle": "激活提醒",
          "dontAcceptReminderPermission": "不允许",
          "acceptReminderPermission": "允许",
          "invalidTimePickedDec": "输入的时间格式不正确。",
          "invalidTimePickedTitle": "请正确输入时间。",
          "am": "上午",
          "pm": "下午",
          "min": "分钟",
          "signsDescription": "选择症状可以让Impo提出更个性化和相关的建议。",
          "signsHelp": "症状指南",
          "editCalendar": "编辑日历",
          "periodDays": "经期天数",
          "pmsDays": "PMS天数",
          "fertilityDays": "备孕期",
          "inCorrectPasswordDec": "输入的密码错误",
          "inCorrectPasswordTitle": "锁屏密码",
          "careYourself": "自我照料",
          "careYourselfDec": "Impo首先会提醒你自己有多重要,并帮助你更好地照料自己。",
          "determiningFertility": "确定宝宝计划期",
          "determiningFertilityDec": "Impo可以帮助你确定排卵日和易孕期,提醒你这个阶段需要注意的事项以及是否可以考虑生育。",
          "periodReport": "以往经期报告",
          "periodReportDec": "Impo可以记录你以往的经期信息,并与医生共享,帮助你管理经期和查找潜在问题。",
          "absenceOfPregnancyForDeterminingFertilityDec": "Impo可以帮助你确定排卵日和易孕期,提醒在这个阶段注意避孕。",
          "expertAdvice": "专家建议",
          "expertAdviceDec": "通过Impo,你可以查看胎儿各发育阶段,并在不同孕期阶段获得相关自我照料和孕妇营养建议。",
          "reinderStoryTitle": "重要时刻提醒",
          "reinderStoryDec": "Impo会提醒你超声波检查、筛检和医生就诊的时间。",
          "periodPrediction": "经期预测",
          "periodPredictionDec": "经期预测Impo 可以预测您的下一个经期，并发送有关经期护理、经前综合症和备孕期的建议。",
          "periodReportStoryDec": "Impo可以记录你以往的经期信息,并与医生共享,帮助你管理经期并查找潜在问题。",
          "report": "经期报告",
          "reportDec": "此报告显示你的预测和实际经期时间。你可以为自己保存此报告,或发送给医生。",
          "reportTableHelper": "下表显示了你的经期开始日期、经期长度和周期长度数据。需要说明的是,您在应用程序中输入的周期长度为n天,经期长度为m天。",
          "saveReportFile": "保存报告文件",
          "daysOfPeriodCycle": "经期周期天数",
          "dayOfStartCycle": "周期开始日期",
          "avgCycle": "平均周期",
          "abnormal": "不正常",
          "pdfReportDec": "此报告显示你的预测和实际经期时间。你可以为自己保存此报告,或发送给医生。",
          "period12monthReport": "12个月经期报告",
          "impoTitle": "女性月经健康领域最大平台",
          "impoLink": "Impo.app",
          "readingTime": "阅读时长:@n分钟",
          "comments": "评论",
          "category": "分类",
          "recommendedArticles": "推荐文章",
          "articleCommentInputHint": "在这里写下你的评论…",
          "searchArticle": "搜索文章",
          "searchResult": "搜索结果",
          "recentSearch": "最近搜索",
          "recentSearchEmpty": "还没有搜索过任何文章!",
          "searchResultEmpty": "搜索结果为空!",
          "articles": "专为你准备的文章",
          "recommendedArticlesDec": "这些文章针对你现在的情况和阶段。",
          "searchHint": "在这里输入",
          "averageMenstruation": "你的平均经期",
          "averageCycleLength": "平均周期长度: @day 天",
          "reportLegendHelp": "说明:",
          "menstruationHistoryReport": "你的经期报告",
          "reportEmptyStateMessage": "为了获得以往经期报告,你需要使用Impo记录至少3个周期。",
          "averagePeriodDay": "平均经期天数: @day 天",
          "dateRangeText": "从@fromDate到@toDate",
          "downloadingReport": "下载经期报告",
          "downloadingReportMessage": "下载经期报告文件",
          "downloadCompleteReport": "经期报告",
          "downloadCompleteReportMessage": "经期报告下载完成",
          "selectedDate": "选择的日期",
          "repeatPreviousPassword": "前一个密码",
          "repeatPreviousPreviousPasswordError": "输入的密码错误",
          "repeatUpdatePassword": "重复密码",
          "welcome": "欢迎加入Impo",
          "welcomeMessage": "Impo会在第一时间提醒您自己的重要性，帮助您更好的照顾自己。",
          "openOnboarding": "开始吧",
          "calendar": "日历",
          "clinic": "门诊",
          "article": "文章",
          "partner": "同情",
          "bookmark": "收藏",
          "normalDays": "普通日子",
          "requestStoragePermissionMessage": "@user,你允许Impo下载你的经期报告吗?",
          "dontAcceptStoragePermission": "不下载",
          "acceptStoragePermission": "下载",
          "commentEmpty": "这篇文章没有评论",
          "verifyEmailDescription": "请输入发送到@user的邮箱的确认代码",
          "pregnancyDate": "@月(@周)",
          "childBirthDate": "分娩前@天",
          "networkFailureMessage": "你的网络似乎中断了,如果打开了代理软件,请关闭重试。",
          "serverFailureMessage": "我们出现问题正在修复。请几分钟后重试。",
          "networkFailureTitle": "网络未连接",
          "serverFailureTitle": "与Impo连接失败",
          "pregnancyTransitionMessage": "你腹中的种子即将发芽成草。你的母性快乐莫名其妙。Impo同样为这个绿色奇迹高兴,并会像往常一样在你的孕期陪伴左右。",
          "impoUser": "亲爱的Impo用户",
          "back": "返回",
          "completeInfo": "完成信息",
          "breastfeedingTransitionMessage": "你的小天使现在在怀里。你成为母亲的喜悦数以万计。",
          "bioQuestion": "你对本周生物节律有什么疑问吗?",
          "bioAnswer": "这里有答案",
          "breastfeedingCycleMessage": "第@天母乳喂养",
          "pregnancyWelcoming": "进入孕期",
          "requiredTextField": "请填写",
          "createPregnancyCycle": "进入孕期周期",
          "cycleSetting": "周期设置",
          "editPregnancy": "编辑孕期",
          "weight": "体重",
          "height": "胎儿身高",
          "activePeriodCycle": "记录经期",
          "pregnancySetting": "孕期设置",
          "abortionTransitionMessage": "我们同样为失去你小天使的悲伤。在这些艰难时期,我们依然与你同在。",
          "onEditWeek": "编辑孕周",
          "irPhoneNumberError": "注意：输入你的手机号应以（09）开头",
          "referralCodeSuccessStatusMessage": "推荐代码成功注册",
          "referralCode": "推荐代码",
          "enterReferralCode": "在这里输入推荐代码",
          "writeHere": "在这里写…",
          "applyReferralCode": "应用推荐代码",
          "referralCodeHint": "你有推荐代码吗?",
          "applyReferralCodeHint": "在这里输入",
          "notNow": "暂不!",
          "notificationPermission": "通知权限",
          "notificationPermissionTitle": "如果开启通知,你将了解到:",
          "notificationValueForPermission1": "你周期的最新变化",
          "notificationValueForPermission2": "基于周期变化更好地安排每日计划",
          "notificationValueForPermission3": "获悉Impo为你带来的最新消息",
          "editCycle": "编辑周期",
          "setSexDescription": "亲爱的Impo用户,为帮助你,我们需要了解你的性别",
          "setSexTitle": "选择性别",
          "male": "男士",
          "female": "女士",
          "menBioStoryTitle": "每日体验",
          "menBioStoryDecoration": "在Impo根据人员出生日计算的生物节律周期上,你可以了解每日身心状态",
          "menPartnerStoryTitle": "改善性生活与感情",
          "menPartnerStory": "改善性生活与感情",
          "menPartnerDescription": "在Impo的伴侣模块里,你可以获得你伴侣的经期信息,更好地了解她,体会更好的情感和性生活。",
          "menReminderStoryTitle": "更好的生活方式",
          "menReminderStoryDescription": "通过Impo,你可以设定提醒,养成健康生活方式,获得个性化的自我保健建议。",
          "supportDialogDescription": "我们已记录您的问题,我们将于第一时间与您联系。",
          "enterMenBirthDayDescription": "你出生在什么年月日?",
          "periodTracker": "经期跟踪",
          "ageError": "使用Impo至少要@n岁",
          "periodLenError": "经期长度不能少于3天",
          "healthCycleSetting": "健康周期设置",
          "healthCycleSettingDes": "@user,请选择你的状态",
          "splashNetworkFailure": "网络连接失败",
          "splashNetworkFailureDes": "请检查您的网络设置并重试",
          "periodLenDays": "周期长度:@day天",
          "daysAgo": "@day天前",
          "hoursAgo": "@小时前",
          "minutesAgo": "@分钟前",
          "recently": "刚才",
          "night": "晚上",
          "afterNoon": "下午",
          "noon": "中午",
          "morning": "早上",
          "impoSupport": "Impo支持",
          "biorhythm": "生物节律",
          "readMore": "阅读更多",
          "needToCheck": "(需要检查)",
          "periodStartDate": "经期开始日期:@date",
          "cycleLenDays": "周期长度:@天",
          "biorithem": "生物节律",
          "applyChanges": "确认更改",
          "or": "或者",
          "next": "下一个",
          "referralCodeTitle": "你有推荐代码吗?",
          "enterHere": "在这里输入",
          "sa": "周六",
          "su": "周日",
          "mo": "周一",
          "tu": "周二",
          "we": "周三",
          "th": "周四",
          "fr": "周五",
          "cycleActiveLastPeriodTitle": "@user, 你上次何时有月经?",
          "cycleActiveLastPeriodDescription": "(起始日期)",
          "cycleActiveNextPeriodTitle": "下一份月经的预计日期",
          "cycleActiveNextPeriodDescription": "你预测下次月经的开始日期会是哪一天?",
          "cycleActive2LastPeriodTitle": "@user, 你上上次月经开始于何时?",
          "cycleActive2LastPeriodDescription": "上上次月经",
          "cycleActivationNextPeriodStartTitle": "@user, 你下次月经开始于何日?",
          "cycleActivationNextPeriodStartDescription": "下次月经的起始日期",
          "cycleActiveLastPeriodStartTitle": "@user, 你上次何时有月经?",
          "cycleActiveLastPeriodStartDescription": "(起始日期)",
          "ovulationDay": "排卵日",
          "currentDay": "当前周期",
          "until": "到",
          "lightMode": "浅色模式",
          "darkMode": "深色模式",
          "systemDefault": "系统默认",
        },
      };

  static String cardPeriod = "cardPeriod".tr;
  static String cardPeriodHelper = "cardPeriodHelper".tr;
  static String cardPregnancy = "cardPregnancy".tr;
  static String cardPregnancyHelper = "cardPregnancyHelper".tr;
  static String day = "day".tr;
  static String whatDayPeriod = "whatDayPeriod".tr;
  static String notPeriod = "notPeriod".tr;
  static String myPeriodNow = "myPeriodNow".tr;
  static String error = "error".tr;
  static String authError = "authError".tr;
  static String createCycle = "createCycle".tr;
  static String goNext = "goNext".tr;
  static String menstruationTitle = "menstruationTitle".tr;
  static String periodLengthHelper = "periodLengthHelper".tr;
  static String statePeriodHelper = "statePeriodHelper".tr;
  static String cycleLengthTitle = "cycleLengthTitle".tr;
  static String cycleLengthHelper1 = "cycleLengthHelper1".tr;
  static String cycleLengthHelper2 = "cycleLengthHelper2".tr;
  static String notRemember = "notRemember".tr;
  static String nextStep = "nextStep".tr;
  static String loginHeader = "loginHeader".tr;
  static String loginTitle = "loginTitle".tr;
  static String loginDescription = "loginDescription".tr;
  static String loginEnterPhoneNumber = "loginEnterPhoneNumber".tr;
  static String loginEnterEmail = "loginEnterEmail".tr;
  static String loginPrivacyText = "loginPrivacyText".tr;
  static String enterEmail = "enterEmail".tr;
  static String email = "email".tr;
  static String enterEmailDescription = "enterEmailDescription".tr;
  static String emailInputHintText = "emailInputHintText".tr;
  static String enterNumber = "enterNumber".tr;
  static String phoneNumber = "phoneNumber".tr;
  static String enterNumberDescription = "enterNumberDescription".tr;
  static String numberInputHintText = "numberInputHintText".tr;
  static String enterNewPassword = "enterNewPassword".tr;
  static String enterNewPasswordDescription = "enterNewPasswordDescription".tr;
  static String repeatNewPasswordInputHintText = "repeatNewPasswordInputHintText".tr;
  static String verifyPhoneNumber = "verifyPhoneNumber".tr;
  static String verifyPhoneNumberDescription = "verifyPhoneNumberDescription".tr;
  static String notReceiveCode = "notReceiveCode".tr;
  static String enterName = "enterName".tr;
  static String enterNameDescription = "enterNameDescription".tr;
  static String enterBirthDay = "enterBirthDay".tr;
  static String enterBirthDayDescription = "enterBirthDayDescription".tr;
  static String enterGender = "enterGender".tr;
  static String enterGenderDescription = "enterGenderDescription".tr;
  static String yesGender = "yesGender".tr;
  static String noGender = "noGender".tr;
  static String enterInstallPurpose = "enterInstallPurpose".tr;
  static String enterInstallPurposeDescription = "enterInstallPurposeDescription".tr;
  static String enterLastPeriodCalendar = "enterLastPeriodCalendar".tr;
  static String enterLastPeriodCalendarDescription = "enterLastPeriodCalendarDescription".tr;
  static String enterNameInputHintText = "enterNameInputHintText".tr;
  static String continueStep = "continueStep".tr;
  static String emptyPhoneNumberError = "emptyPhoneNumberError".tr;
  static String phoneNumberErrorNotValidPrefix = "phoneNumberErrorNotValidPrefix".tr;
  static String phoneNumberErrorEmpty = "phoneNumberErrorEmpty".tr;
  static String phoneNumberErrorNotValidLength = "phoneNumberErrorNotValidLength".tr;
  static String emptyEmailError = "emptyEmailError".tr;
  static String emailError = "emailError".tr;
  static String connectionErrorTitle = "connectionErrorTitle".tr;
  static String connectionErrorMessage = "connectionErrorMessage".tr;
  static String connectionErrorButtonText = "connectionErrorButtonText".tr;
  static String emptyUsernameError = "emptyUsernameError".tr;
  static String usernameError = "usernameError".tr;
  static String noteTitleError = "noteTitleError".tr;
  static String normalDay = "normalDay".tr;
  static String localizedReason = "localizedReason".tr;
  static String absencePregnancy = "absencePregnancy".tr;
  static String pregnancyIntention = "pregnancyIntention".tr;
  static String pregnant = "pregnant".tr;
  static String signs = "signs".tr;
  static String cycleGuide = "cycleGuide".tr;
  static String biorhythmTitle = "biorhythmTitle".tr;
  static String criticalDay = "criticalDay".tr;
  static String acceptPeriod = "acceptPeriod".tr;
  static String today = "today".tr;
  static String edit = "edit".tr;
  static String returnToday = "returnToday".tr;
  static String addNewNote = "addNewNote".tr;
  static String addNote = "addNote".tr;
  static String noteEmptyStateMessage = "noteEmptyStateMessage".tr;
  static String version = "version".tr;
  static String cycle = "cycle".tr;
  static String cycleLength = "cycleLength".tr;
  static String periodLength = "periodLength".tr;
  static String enterToPregnancy = "enterToPregnancy".tr;
  static String security = "security".tr;
  static String connectedDevices = "connectedDevices".tr;
  static String password = "password".tr;
  static String financial = "financial".tr;
  static String transactions = "transactions".tr;
  static String sympathy = "sympathy".tr;
  static String settings = "settings".tr;
  static String notification = "notification".tr;
  static String notificationSetting = "notificationSetting".tr;
  static String general = "general".tr;
  static String theme = "theme".tr;
  static String inviteFriend = "inviteFriend".tr;

  // static String support = "support".tr;
  // static String aboutUs = "aboutUs".tr;
  static String editProfile = "editProfile".tr;
  static String user = "user".tr;
  static String logout = "logout".tr;
  static String dontLogoutMe = "dontLogoutMe".tr;
  static String logoutMe = "logoutMe".tr;
  static String logoutDescription = "logoutDescription".tr;
  static String subscriptionRenewal = "subscriptionRenewal".tr;
  static String subscriptionDeadline = "subscriptionDeadline".tr;
  static String shareCode = "shareCode".tr;
  static String copy = "copy".tr;
  static String inviteFriendDes = "inviteFriendDes".tr;
  static String refralCode = "refralCode".tr;
  static String dearUserExclamation = "dearUserExclamation".tr;
  static String userName = "userName".tr;
  static String confirmChanges = "confirmChanges".tr;
  static String birthday = "birthday".tr;
  static String disable = "disable".tr;
  static String connectedDevicesDescription = "connectedDevicesDescription".tr;
  static String currentDevice = "currentDevice".tr;
  static String availableDevice = "availableDevice".tr;
  static String connectedDeviceEmptyState = "connectedDeviceEmptyState".tr;
  static String activePassword = "activePassword".tr;
  static String activeBiometric = "activeBiometric".tr;
  static String editPassword = "editPassword".tr;
  static String enterPrevPassword = "enterPrevPassword".tr;
  static String confirmPassword = "confirmPassword".tr;
  static String newPassword = "newPassword".tr;
  static String enterNewLocalPassword = "enterNewLocalPassword".tr;
  static String repeatPassword = "repeatPassword".tr;
  static String repeatPasswordDescription = "repeatPasswordDescription".tr;
  static String setPassword = "setPassword".tr;
  static String enterRepeatPassword = "enterRepeatPassword".tr;
  static String enterNewLocalPasswordDescription = "enterNewLocalPasswordDescription".tr;
  static String confirm = "confirm".tr;
  static String repeatPasswordError = "repeatPasswordError".tr;
  static String dearUser = "dearUser".tr;
  static String remove = "remove".tr;
  static const String newReminder = "یادداشت";
  static const String study = "مطالعه";
  static const String workout = "ورزش";
  static const String water = "آب";
  static const String fruit = "میوه";
  static const String sleep = "خواب";
  static const String pill = "دارو";
  static const String pad = "تعویض پد بهداشتی";
  static const String mobile = "استفاده از موبایل";
  static String dailyReminder = "dailyReminder".tr;
  static String dailyReminderEmpty = "dailyReminderEmpty".tr;
  static String swapUpAlarm = "swapUpAlarm".tr;
  static String addReminderDescription = "addReminderDescription".tr;
  static String addReminder = "addReminder".tr;
  static String reminder = "reminder".tr;
  static String reminding = "reminding".tr;
  static String noteTitle = "noteTitle".tr;
  static String typeHere = "typeHere".tr;
  static String reminderTime = "reminderTime".tr;
  static String dailyReminderRepeatDays = "dailyReminderRepeatDays".tr;
  static String cancel = "cancel".tr;
  static String state = "state".tr;
  static String active = "active".tr;
  static String deActive = "deActive".tr;
  static String hour = "hour".tr;
  static String timeFormatError = "timeFormatError".tr;
  static String noteTextHint = "noteTextHint".tr;
  static String reminderEmptyState = "reminderEmptyState".tr;
  static String transactionEmptyState = "transactionEmptyState".tr;
  static String reminderActivationMessage = "reminderActivationMessage".tr;
  static String activationReminder = "activationReminder".tr;
  static String requestReminderPermissionMessage = "requestReminderPermissionMessage".tr;
  static String requestReminderPermissionTitle = "requestReminderPermissionTitle".tr;
  static String dontAcceptReminderPermission = "dontAcceptReminderPermission".tr;
  static String acceptReminderPermission = "acceptReminderPermission".tr;
  static String invalidTimePickedDec = "invalidTimePickedDec".tr;
  static String invalidTimePickedTitle = "invalidTimePickedTitle".tr;
  static String am = "am".tr;
  static String pm = "pm".tr;
  static String min = "min".tr;
  static String signsDescription = "signsDescription".tr;
  static String signsHelp = "signsHelp".tr;
  static String editCalendar = "editCalendar".tr;
  static String periodDays = "periodDays".tr;
  static String pmsDays = "pmsDays".tr;
  static String fertilityDays = "fertilityDays".tr;
  static String inCorrectPasswordDec = "inCorrectPasswordDec".tr;
  static String inCorrectPasswordTitle = "inCorrectPasswordTitle".tr;
  static String careYourself = "careYourself".tr;
  static String careYourselfDec = "careYourselfDec".tr;
  static String determiningFertility = "determiningFertility".tr;
  static String determiningFertilityDec = "determiningFertilityDec".tr;
  static String periodReport = "periodReport".tr;
  static String periodReportDec = "periodReportDec".tr;
  static String absenceOfPregnancyForDeterminingFertilityDec = "absenceOfPregnancyForDeterminingFertilityDec".tr;
  static String expertAdvice = "expertAdvice".tr;
  static String expertAdviceDec = "expertAdviceDec".tr;
  static String reinderStoryTitle = "reinderStoryTitle".tr;
  static String reinderStoryDec = "reinderStoryDec".tr;
  static String periodPrediction = "periodPrediction".tr;
  static String periodPredictionDec = "periodPredictionDec".tr;
  static String periodReportStoryDec = "periodReportStoryDec".tr;
  static String report = "report".tr;
  static String reportDec = "reportDec".tr;
  static String reportTableHelper = "reportTableHelper".tr;
  static String saveReportFile = "saveReportFile".tr;
  static String daysOfPeriodCycle = "daysOfPeriodCycle".tr;
  static String dayOfStartCycle = "daysOfPeriodCycle".tr;
  static String avgCycle = "avgCycle".tr;
  static String abnormal = "abnormal".tr;
  static String pdfReportDec = "pdfReportDec".tr;
  static String period12monthReport = "period12monthReport".tr;
  static String impoTitle = "impoTitle".tr;
  static String impoLink = "impoLink".tr;
  static String readingTime = "readingTime".tr;
  static String comments = "comments".tr;
  static String category = "category".tr;
  static String recommendedArticles = "recommendedArticles".tr;
  static String articleCommentInputHint = "articleCommentInputHint".tr;
  static String searchArticle = "searchArticle".tr;
  static String searchResult = "searchResult".tr;
  static String recentSearch = "recentSearch".tr;
  static String recentSearchEmpty = "recentSearchEmpty".tr;
  static String searchResultEmpty = "searchResultEmpty".tr;
  static String articles = "articles".tr;
  static String recommendedArticlesDec = "recommendedArticlesDec".tr;
  static String searchHint = "searchHint".tr;
  static String averageMenstruation = "averageMenstruation".tr;
  static String averageCycleLength = "averageCycleLength".tr;
  static String reportLegendHelp = "reportLegendHelp".tr;
  static String menstruationHistoryReport = "menstruationHistoryReport".tr;
  static String reportEmptyStateMessage = "reportEmptyStateMessage".tr;
  static String averagePeriodDay = "averagePeriodDay".tr;
  static String dateRangeText = "dateRangeText".tr;
  static String downloadingReport = "downloadingReport".tr;
  static String downloadingReportMessage = "downloadingReportMessage".tr;
  static String downloadCompleteReport = "downloadCompleteReport".tr;
  static String downloadCompleteReportMessage = "downloadCompleteReportMessage".tr;
  static String selectedDate = "selectedDate".tr;
  static String repeatPreviousPassword = "repeatPreviousPassword".tr;
  static String repeatPreviousPreviousPasswordError = "repeatPreviousPreviousPasswordError".tr;
  static String repeatUpdatePassword = "repeatUpdatePassword".tr;
  static String welcome = "welcome".tr;
  static String welcomeMessage = "welcomeMessage".tr;
  static String openOnboarding = "openOnboarding".tr;
  static String calendar = "calendar".tr;
  static String clinic = "clinic".tr;
  static String article = "article".tr;

  // static String partner = "partner".tr;
  static String bookmark = "bookmark".tr;
  static String normalDays = "normalDays".tr;
  static String requestStoragePermissionMessage = "requestStoragePermissionMessage".tr;
  static String dontAcceptStoragePermission = "dontAcceptStoragePermission".tr;
  static String acceptStoragePermission = "acceptStoragePermission".tr;
  static String commentEmpty = "commentEmpty".tr;
  static String verifyEmailDescription = "verifyEmailDescription".tr;
  static String pregnancyDate = "pregnancyDate".tr;
  static String childBirthDate = "childBirthDate".tr;
  static String networkFailureMessage = "networkFailureMessage".tr;
  static String serverFailureMessage = "serverFailureMessage".tr;
  static String networkFailureTitle = "networkFailureTitle".tr;
  static String serverFailureTitle = "serverFailureTitle".tr;
  static String pregnancyTransitionMessage = "pregnancyTransitionMessage".tr;
  static String impoUser = "impoUser".tr;
  static String back = "back".tr;
  static String completeInfo = "completeInfo".tr;
  static String breastfeedingTransitionMessage = "breastfeedingTransitionMessage".tr;
  static String bioQuestion = "bioQuestion".tr;
  static String bioAnswer = "bioAnswer".tr;
  static String breastfeedingCycleMessage = "breastfeedingCycleMessage".tr;
  static String pregnancyWelcoming = "pregnancyWelcoming".tr;
  static String requiredTextField = "requiredTextField".tr;
  static String createPregnancyCycle = "createPregnancyCycle".tr;
  static String cycleSetting = "cycleSetting".tr;
  static String editPregnancy = "editPregnancy".tr;
  static String weight = "weight".tr;
  static String height = "height".tr;
  static String activePeriodCycle = "activePeriodCycle".tr;
  static String pregnancySetting = "pregnancySetting".tr;
  static String abortionTransitionMessage = "abortionTransitionMessage".tr;
  static String onEditWeek = "onEditWeek".tr;
  static String irPhoneNumberError = "irPhoneNumberError".tr;
  static String referralCodeSuccessStatusMessage = "referralCodeSuccessStatusMessage".tr;
  static String referralCode = "referralCode".tr;
  static String enterReferralCode = "enterReferralCode".tr;
  static String writeHere = "writeHere".tr;
  static String applyReferralCode = "applyReferralCode".tr;
  static String referralCodeHint = "referralCodeHint".tr;
  static String applyReferralCodeHint = "applyReferralCodeHint".tr;
  static String notNow = "notNow".tr;
  static String notificationPermission = "notificationPermission".tr;
  static String notificationPermissionTitle = "notificationPermissionTitle".tr;
  static String notificationValueForPermission1 = "notificationValueForPermission1".tr;
  static String notificationValueForPermission2 = "notificationValueForPermission2".tr;
  static String notificationValueForPermission3 = "notificationValueForPermission3".tr;
  static String editCycle = "editCycle".tr;
  static String setSexDescription = "setSexDescription".tr;
  static String setSexTitle = "setSexTitle".tr;
  static String male = "male".tr;
  static String female = "female".tr;
  static String menBioStoryTitle = "menBioStoryTitle".tr;
  static String menBioStoryDecoration = "menBioStoryDecoration".tr;
  static String menPartnerStoryTitle = "menPartnerStoryTitle".tr;
  static String menPartnerStory = "menPartnerStory".tr;
  static String menPartnerDescription = "menPartnerDescription".tr;
  static String menReminderStoryTitle = "menReminderStoryTitle".tr;
  static String menReminderStoryDescription = "menReminderStoryDescription".tr;
  static String supportDialogDescription = "supportDialogDescription".tr;
  static String enterMenBirthDayDescription = "enterMenBirthDayDescription".tr;
  static String periodTracker = "periodTracker".tr;
  static String ageError = "ageError".tr;
  static String periodLenError = "periodLenError".tr;
  static String healthCycleSetting = 'healthCycleSetting'.tr;
  static String healthCycleSettingDes = 'healthCycleSettingDes'.tr;
  static String splashNetworkFailure = 'splashNetworkFailure'.tr;
  static String splashNetworkFailureDes = 'splashNetworkFailureDes'.tr;
  static String periodLenDays = 'periodLenDays'.tr;
  static String daysAgo = 'daysAgo'.tr;
  static String hoursAgo = 'hoursAgo'.tr;
  static String minutesAgo = 'minutesAgo'.tr;
  static String recently = 'recently'.tr;
  static String night = 'night'.tr;
  static String afterNoon = 'afterNoon'.tr;
  static String noon = 'noon'.tr;
  static String morning = 'morning'.tr;
  static String impoSupport = 'impoSupport'.tr;
  static String biorhythm = 'biorhythm'.tr;
  static String readMore = 'readMore'.tr;
  static String needToCheck = 'needToCheck'.tr;
  static String periodStartDate = 'periodStartDate'.tr;
  static String cycleLenDays = 'cycleLenDays'.tr;
  static String biorithem = 'biorithem'.tr;
  static String applyChanges = 'applyChanges'.tr;
  static String or = 'or'.tr;
  static String next = 'next'.tr;
  static String referralCodeTitle = 'referralCodeTitle'.tr;
  static String enterHere = 'enterHere'.tr;
  static String su = 'su'.tr;
  static String mo = 'mo'.tr;
  static String tu = 'tu'.tr;
  static String we = 'we'.tr;
  static String th = 'th'.tr;
  static String fr = 'fr'.tr;
  static String sa = 'sa'.tr;
  static String cycleActiveLastPeriodTitle = 'cycleActiveLastPeriodTitle'.tr;
  static String cycleActiveLastPeriodDescription = 'cycleActiveLastPeriodDescription'.tr;
  static String cycleActiveNextPeriodTitle = 'cycleActiveNextPeriodTitle'.tr;
  static String cycleActiveNextPeriodDescription = 'cycleActiveNextPeriodDescription'.tr;
  static String cycleActive2LastPeriodTitle = 'cycleActive2LastPeriodTitle'.tr;
  static String cycleActive2LastPeriodDescription = 'cycleActive2LastPeriodDescription'.tr;
  static String cycleActivationNextPeriodStartTitle = 'cycleActivationNextPeriodStartTitle'.tr;
  static String cycleActivationNextPeriodStartDescription = 'cycleActivationNextPeriodStartDescription'.tr;
  static String cycleActiveLastPeriodStartTitle = 'cycleActiveLastPeriodStartTitle'.tr;
  static String cycleActiveLastPeriodStartDescription = 'cycleActiveLastPeriodStartDescription'.tr;
  static String ovulationDay = 'ovulationDay'.tr;
  static String currentDay = 'currentDay'.tr;
  static var lightMode = 'lightMode'.tr;
  static var darkMode = 'darkMode'.tr;
  static var until = 'until'.tr;
  static var systemDefault = 'systemDefault'.tr;
}
