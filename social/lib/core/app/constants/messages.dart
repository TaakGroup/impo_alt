import "package:flutter/material.dart";
import "package:get/get.dart";

class Messages extends Translations {
  static String wempo = 'اشتراک تجربه';
  static String statistics = 'آمار';
  static String tickets = 'تیکت‌ها';
  static String welcomeDescription = 'لطفا نام کاربری و رمز عبور رو وارد کن';
  static String forgotPassword = 'فراموشی رمز عبور';
  static String gallery = 'گالری';
  static String camera = 'دوربین';
  static String attachFile = 'پیوست فایل';
  static String file = 'فایل';
  static String passwordValidationError = 'پسوردی که وارد میکنید باید ترکیبی از اعداد و حروف باشد';

  static String experienceEmptyError = 'بدون نوشتن تجربه، نمی‌تونی ثبتش کنی';

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
          "numberInputHintText": "نام کاربری",
          "enterNewPassword": "رمز عبور جدید رو وارد کن",
          "enterNewPasswordDescription": "رمز عبور شما باید ترکیبی از عدد و حروف و حداقل 6 کاراکتر باشه.",
          "repeatNewPasswordInputHintText": "تکرار رمز عبور",
          "verifyPhoneNumber": "تایید @platform",
          "verifyPhoneNumberDescription": "کد تاییدی که به شماره *** پیامک شده رو وارد کن",
          "notReceiveCode": "کد تایید رو دریافت نکردم",
          "enterName": "انتخاب نام",
          "enterNameDescription": "دوست داری در ایمپو چی صدات کنیم؟",
          "enterBirthDay": "انتخاب تاریخ تولد",
          "enterBirthDayDescription": "تو کدوم سال و ماه و روز دنیا رو با اومدنت قشنگ تر کردی؟",
          "enterGender": "@user جان  آیا رابطه جنسی داری؟",
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
          "logoutDescription": "@user جان مطمئنی میخوای از ایمپو خارج بشی؟",
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
          "newPassword": "رمز جدید",
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
          "fertilityDays": "روز تخمک‌گذاری",
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
          "welcomeMessage": "به اپلیکیشن ایمپو دکتر خوش اومدی",
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
          "notificationPermissionTitle": "با فعال کردن نوتیفیکیشن:",
          "notificationValueForPermission1": "تغییرات جدید چرخه‌ت",
          "notificationValueForPermission2": "به محض اینکه تیکت جدیدی از سمت کاربر بیاد، ازش مطلع میشی",
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
          "next": "بعدی",
          "referralCodeTitle": "کد معرف داری؟",
          "enterHere": "اینجا وارد کن",
          'sa': 'شنبه',
          'su': 'یک',
          'mo': 'دو',
          'tu': 'سه',
          'we': 'چهار',
          'th': 'پنج',
          'fr': 'جمعه',
          'cycleActiveLastPeriodTitle': '@user جان آخرین بار کی پریود شدی؟',
          'cycleActiveLastPeriodDescription': '(روز شروع پریود)',
          'cycleActiveNextPeriodTitle': 'تاریخ پریود بعدی',
          'cycleActiveNextPeriodDescription': 'فکر میکنی تاریخ شروع پریود بعدیت چه روزی باشه؟',
          'cycleActive2LastPeriodTitle': '@user جان،  تاریخ شروع پریود دو دوره قبلت کی بوده؟',
          'cycleActive2LastPeriodDescription': 'پریود دو دوره قبل',
          'cycleActivationNextPeriodStartTitle': '@user جان پریود بعدیت چه روزی شروع میشه؟',
          'cycleActivationNextPeriodStartDescription': 'روز شروع بعدی پریود',
          'cycleActiveLastPeriodStartTitle': '@user جان آخرین بار کی پریود شدی؟',
          'cycleActiveLastPeriodStartDescription': '(روز شروع پریود)',
          "ovulationDay" : "روز تخمک گذاری",
          "currentDay" : "روز جاری",
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
  static String support = "support".tr;
  static String aboutUs = "aboutUs".tr;
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
  static const String newReminder = "newReminder";
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
  static String partner = "partner".tr;
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
}
