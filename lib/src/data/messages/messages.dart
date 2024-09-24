//
// import 'dart:io';
//
// import 'package:device_info/device_info.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:impo/src/data/helper.dart';
// import 'package:impo/src/data/http.dart';
// import 'package:impo/src/data/local/database_provider.dart';
// import 'package:impo/src/models/motival_list_model.dart';
// import 'package:impo/src/models/register_parameters_model.dart';
// import 'package:impo/src/screens/LoginAndRegister/identity/forgot_password_screen.dart';
// import 'package:page_transition/page_transition.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:impo/src/models/dashboard_messages_server_model.dart';
// import 'package:impo/src/models/dashboard_messages_local_model.dart';
// import 'package:impo/src/architecture/presenter/dashboard_presenter.dart';
// import 'package:impo/src/architecture/view/dashboard_view.dart';
// import 'package:impo/src/data/messages/generate_dashboard_notify_and_messages.dart';
// import 'package:impo/src/data/auto_backup.dart';
// import 'package:impo/src/screens/LoginAndRegister/identity/enter_number_screen.dart';
// import 'package:package_info/package_info.dart';
// import 'package:impo/src/models/calender/alarm_model.dart';
// import 'package:impo/src/components/dialogs/message_not_read_dialog.dart';
//
// class Messages implements DashboardView{
//
//   DataBaseProvider db  = new DataBaseProvider();
//
//   DashboardPresenter _presenter;
//
//
//
//   // List randomMessages = [
//   //  'لبخند یادت نره! 😊',
//   // 'امروز روز توئه پس خوشحال باش  😉',
//   // '🤔  میدونستی رویاهای امروزت، داشته های فرداته؟',
//   // 'زندگی کوتاه تر از اونه که بخوای به غصه بگذرونی!',
//   // 'میخوام بدونی موفقیت بدون تلاش ممکن نیست!  ',
//   // 'تنها راه غلبه به ترسهات ، اینه که باهاش روبرو بشی  🌱',
//   // 'یه لحظه به رویاهات فکر کن. ببین ارزش تلاش کردن نداره؟  🌱',
//   // 'گذشته تو تعیین کننده حال و آینده ت نیست! ☺',
//   // ' بهم یه قول بده! هیچ وقت ناامید نشی  ',
//   // 'میدونستی چقدر مهمی؟  🌱',
//   // ' این یه دستوره! به خودت اهمیت بده  🙃',
//   // ' شمردی امروز چند لیوان آب خوردی؟!  ',
//   // ' یه روزایی هم به خودت حق بده خسته باشی و فقط استراحت کنی! 😌 ',
//   // ' ایمپو میخواد بهت یادآوری کنه تو مهمترین آدم زندگی خودت هستی! 😊 ',
//   // ' بلدی خودت حال خودتو خوب کنی ؟  😎',
//   // 'یادمون باشه بدون نظم و برنامه ریزی، آرزوها همیشه آرزو می مونن!  📑',
//   //  'آخرین چکاپی که برای مراقبت از خودت انجام دادی کی بوده؟  🤔',
//   // '  روانشناس خودتو داری؟ 🙃' ,
//   // 'زندگی هنوز خوشگلیاشو داره!  😍',
//   //  ' امروز واسه کودک درونت چکاری کردی؟  😋' ,
//   // ' حتی ده دقیقه! مهم اینه که روز بدون کتاب نداشته باشیم  📚 ',
//   // 'اگه ورزش نمی‌کنی، حق داری از آینده بترسی!  🎾',
//   //  'تو به اندازه کافی خوب هستی   ☺',
//   // 'امروز با آدمای مهم زندگیت گپ زدی؟  🤔',
//   // ' برنامه غذایی خودتو داشته باش ',
//   // '  خودت باش! مگه خودت چشه؟!  🤗',
//   //  ' ایمپویی جان! دلت واسه خودت تنگ نشده؟  🙄 ',
//   // ' هیچ بهونه ای قابل قبول نیست برای پیشرفت نکردن! 😜' ,
//   // ' روزتو بساز! 🌹 ',
//   //  '  معاینه سینه برای پیشگیری از سرطان سینه رو فراموش نکن. ',
//   //  ' روز رو خورشید میسازه، روزگار رو تو!',
//   //  'داری برای چه هدفی می جنگی؟ 🤔',
//   //  ' انسانیت از اونجایی شروع میشه که انسان بودن آدما رو قبل از جنسیتشون ببینیم. ',
//   // '  قاعدگی های نامنظم رو جدی بگیر! بدنت باید منظم کار کنه  ',
//   // 'از پریود شدنت خجالت نکش!  😊',
//   //  ' افسردگی، از شایع ترین اختلال های جامعه بانوانه. از خودت غافل نشو. ',
//   // ' چقدر به بقیه بازخوردهای مثبت میدی؟ ',
//   // ' اگه از نیازت حرف نمیزنی، انتظار برآورده شدنش رو هم نداشته باش  🙄',
//   // ' شاد بودن یک انتخابه. واسه داشتنش منتظر کسی نباش!  😍',
//   // 'حواست هست به اندازه کافی بخوابی؟😴',
//   // 'خیلی از چیزهایی که ازشون میترسیم، هیچوقت اتفاق نمی افتن!',
//   // 'امشب چه کتابی قراره بخونی؟ 😊',
//   // 'مسئولیت انتخاب هاتو به عهده بگیر. این زندگی توئه!',
//   // 'بعضی وقتا از کارهایی که نکردیم، خیلی بیشتر از کارهایی که کردیم پشیمون میشیم!',
//   // "ایمپو، یعنی من مهم هستم! اینو با خودت تکرار کن😍",
//   // 'آره سخته، اما سخت به معنای محال نیست!',
//   // 'بازخوردهای مثبت، رابطه ها رو زنده نگه میداره!',
//   // 'مفید بودن اینجوری شروع میشه: مفید برای خودم، برای خانواده و بعد جامعه!',
//   // 'به بدنت احترام بذار و زیادی ازش ایراد نگیر!',
//   // 'چقدر با خودت مهربونی؟!',
//   // 'قاعدگی های نامنظم حتما یک پیامی داره واست! به بدنت توجه کن!',
//   // 'اگه قرار بود نویسنده باشی، چه کتابی مینوشتی؟!',
//   // 'یادت باشه هدفا رو تا ننویسیم، از ذهن به عمل تبدیل نمیشن!',
//   // 'در برنامه زندگیت، ملاقات با روانشناس رو هم دیدی؟!',
//   // 'شوخی های جنسی، مصداق کلیشه های جنسیتی هستن! حواسمون بهشون باشه.',
//   // 'به چیزایی افتخار کنیم که خودمون به دستشون آوردیم!',
//   // 'تو قشنگترین ایمپویی دنیایی 😊',
//   // 'خوشحالیم که داریمتون!',
//   // 'چرخه قاعدگی همیشه هم بد نیست! از اثرات مثبتش خبر داری؟!',
//   // 'یادمون نره خانواده از بزرگترین دارایی های ما توی این دنیان!',
//   // 'استاد تغییر باشیم، نه قربانی تغییر!',
//   // 'تغییر، از جزییات و کوچکترین انتخابها شروع میشن!',
//   // 'مهم نیست چقدر از جاده رو اشتباه پیش رفتی. همین الان دور بزن!',
//   // 'تقریبا محاله کتابی رو باز کنی و چیزی یاد نگیری!',
//   // 'حواست به قشنگی های دنیا هست؟ کتابهای خوب، موسیقی های خوب، فیلم های خوب …',
//   // 'گاهی به آسمون نگاه کن…',
//   // 'اگه می‌تونی تصورش کنی، حتما می‌تونی انجامش بدی!',
//   // 'انجامش نده، اگه میبینی این کار، دنیا رو بهتر نمیکنه!',
//   // 'خودت همون تغییری باش که می‌خوای در دنیا اتفاق بیفته!',
//   // 'برای خارق العاده بودن، باید اول دست از عادی بودن بکشی!',
//   // 'هیچ کاری رو از روی عادت انجام نده. حتی آب دادن به گل ها رو!',
//   // 'به اینستاگرام ایمپو سر زدی امروز؟!',
//   // 'بهترین راه مقابله با ترس، مواجهه با اونه!',
//   // 'مهم نیست چقدر از راه رو اشتباه رفتی، همین الان دور بزن' ,
//   // 'آفتاب به گیاهی میتابه که سر از خاک بیرون آورده باشه ',
//   // 'تو قوی ترین آدم زندگی خودتی' ,
//   // 'امروز کارهایی رو انجام بده که آینده‌ت ازت سپاسگزار باشه',
//   // 'اگه بی هدف از خواب بیدار شدی بهتره برگردی و بخوابی',
//   // 'امروز، اولین روز آینده توست!' ,
//   // 'فرق هدف با آرزو دقیقا اینه که میدونی کجا رو نشونه بری!' ,
//   // ' آخرین کاری که فقط برای خوشحالی خودت کردی چی بوده؟!',
//   // 'برای شروع نباید عالی باشی ولی برای عالی بودن باید شروع کنی!',
//   // 'جهان به اعتبار خنده تو زیباست' ,
//   // 'بهونه، رویاهات رو تبدیل به خاکستر میکنه!',
//   // 'تو تنها کسی هستی که می‌تونی به خودت کمک کنی',
//   // 'فقط غیر ممکن، غیر ممکنه!',
//   // 'لبخند بزن ای نفست صبح بهاری',
//   // 'گذشته تو تعیین کننده حال و آیندت نیست!',
//   // 'برای یاد گرفتن تنها یک راه وجود داره، اونم عمل کردنه!',
//   // 'عادت های خوب هم به اندازه عادت های بد اعتیاد آورن',
//   // 'زندگی به تلاش هات پاسخ میده نه به بهونه هات!',
//   // 'برای قوی بودن باید نقاط ضعفت رو بشناسی',
//   // 'برای رسیدن به تغییر باید از پل ترس گذشت.',
//   // 'آفتاب به گیاهی میتابه که سر از خاک بیرون آورده!',
//   // 'شیرینی یک بار موفقیت  به تلخی صدتا شکست می ارزه',
//   // 'زندگی آسون تر نمیشه، تو قوی تر میشی!',
//   // 'بزرگترین ریسک زندگی، ریسک نکردنه!',
//   // 'چقدر‌مسئولیت انتخابهاتو به عهده میگیری؟!',
//   // 'گاهی به آسمون نگاه کن .. .',
//   // 'حالم اگه با خودم خوب نباشه، با هیچ چیز و هیچ کسی هم خوب نمیشه',
//   // 'حواست به قشنگیهای فصل هست؟',
//   // 'آخرین باری که به خودت سر زدی کِی بوده؟',
//   // 'خستگی‌ها موندنی نیستن. کافیه یه خرده به خودت زمان بدی',
//   // 'معنی زندگیتو پیدا کن',
//   // 'سبک زندگیت چقدر سالمه؟ چقدر مراقب خودت هستی؟',
//   // 'آخرین باری که خودتو چکاپ کردی کی بوده؟',
//   // 'ورزش دوست بودن کافی نیست. پاشو شروع کن!',
//   // 'یه وقتهایی هم انقدر زیادی به چیزی فکر میکنیم، که فرصت نمیشه واسش اقدام کنیم!',
//   // 'روزی چند دقیقه سکوت و تفکر، فراموش نشه!',
//   // ];
//
//   List randomMessages = [
//     'خودشناسی، اصلی ترین قدم برای هر تغییریه.',
//     'هر شب قبل از خواب، روزی که گذشت رو با خودت مرور کن.',
//     'پاییز و زمستون، هر روز چند دقیقه ای آفتاب بگیر😊',
//     'ایمپویی جان نور خورشید، می‌تونه انرژیتو بیشتر کنه.',
//     'دائما یکسان نباشد حال دوران، غم مخور!',
//     'مسئولیت پذیری، همون چیزیه که می‌تونه زندگی رو بهتر کنه!',
//     'برای بهتر شدن حالِ دنیا، چه کاری می‌تونی انجام بدی؟',
//     'اگه از وضعیتت راضی نیستی تغییرش بده. تو درخت نیستی!',
//     'ایمپویی جان روز بدون کتاب نداریما!',
//     'ایمپویی عزیز بیرون از خودت دنبال شادی نگرد 😊',
//     'زندگی به تلاش‌هات پاسخ میده. نه به بهونه‌هات!',
//     'مراقبت از گل و گیاه، اضطراب رو کم می‌کنه 🌱',
//     'خوشحالی و ناراحتی، یک انتخابه. انتخاب تو چیه؟',
//     'معنای زندگیتو که پیدا کنی، سختیها کمتر میشن!',
//     'ایمپویی عزیز هر روز حداقل ده دقیقه با خودت خلوت کن.',
//     'گفتگو با خدا، دلامونو آروم میکنه ⁦♥️⁩',
//     'نمیشه که حرکتی نکنیم و از نرسیدن به مقصد، شاکی باشیم!',
//     'رفتار سالم یعنی نه به خودم آسیب بزنم، نه به دیگری!',
//     'ایمپویی جان روتین خودمراقبتیِ تو چیه؟',
//     'پریود یک چرخه طبیعیه. ازش خجالت نکشیم.',
//     'هدف گذاری روزانه و هفتگی کمک می‌کنه زندگی قشنگتری داشته باشیم.',
//     'از برنامه ریزی به روش بولت ژورنال چیزی میدونی؟',
//     'به پیج و وبسایت ایمپو سر بزن و همراهمون باش 😊',
//     'ایمپو یعنی تو مهمی. خودتو فراموش نکن!',
//     'کتاب، یک تفریح نیست. یک بخش جدی از زندگیه!',
//     'ایمپویی جان زندگی‌تو بساز. معجزه خود تویی!',
//     'مهمتر از زن بودن یا مرد بودن، انسان بودنه.',
//     'اینجاییم که با خودمون در صلح باشیم',
//     '. مدیتیشن کمک می‌کنه استرست کمتر بشه',
//     'افتخار میکنیم به همراهی‌تون 😍',
//     'با دقت به اطرافت نگاه کن تا قشنگی‌های دنیا رو ببینی 😊',
//     'آخرین باری که به خودت سر زدی کِی بوده؟',
//     'در کنار شما تلاش می‌کنیم برای صلح و آرامش 😍',
//     'هر روز، زمانی بذاریم برای گفتگو با آدمهای مهم زندگیمون.',
//     'چکاپ های منظم و ماهیانه رو فراموش نکنی',
//     'ایمپویی عزیز، حال کودک درونت چطوره؟',
//     'ایمپویی جان امروز یک هدف جدید رو شروع کن!',
//     'ایمپویی جان ورزش منظم، مسئولیت ما نسبت به بدنمونه!',
//     'بخند و از خنده بگو!😁',
//     'اگه افکار مزاحم زیادی داری، از روانشناس کمک بگیر⁦♥️⁩',
//     'گذشته مهمه، اما قرار نیست آینده رو تعیین کنه!',
//     'تغذیه سالم، ورزش منظم و مراقب از روح و روان یادمون نره!',
//     'ایمپویی جان آینده از همین الان شروع شده!',
//     'خود دوستی با خودخواهی فرق داره! حواسمون باشه 😉',
//     'کیفیت زندگی رو بیش از هرچیزی، انتخاب‌هامون تعیین می‌کنه!',
//     'دوست عزیزم خواب نامنظم می‌تونه اضطراب رو بالا ببَره.',
//     'ایمپویی جان امروز بابت داشته‌هات شکرگزاری کردی؟',
//     'به همدیگه بازخوردهای مثبت بدیم تا رابطه ها زنده بمونن 😍',
//     'ایمپویی عزیز سبک زندگی خودتو پیدا کن 😊',
//     'نقاط ضعفت رو بشناس و برای رشدشون برنامه ریزی کن.',
//     'خودتو سرزنش نکن، اما تلاش کن که اشتباه ها تکرار نشن ⁦♥️⁩',
//     'فیلم خوب، کتاب خوب، موسیقی خوب، ... اینا غذاهای روحمون هستن.',
//     'برای داشتن خانواده، شکرگزار باشیم 😍',
//     'مصرف آب کافی می‌تونه از سردرد پیشگیری کنه.',
//     'هنر روحت رو زنده نگه می‌داره! ازش غافل نشو 😍',
//     'ایمپویی جان قبل از هر کسی با خودت صادق باش.',
//     '. کاری که استرس انجام میده، ضعیف کردن نیروی اراده است.',
//     'عشق و کار برای انسان، مثل آب و آفتاب برای گیاهه.',
//     'هیچکسی به جز خودمون، ما رو نجات نمیده!',
//     'ایمپویی جان، چقدر با خودت و جهان در صلحی؟',
//     'بیاید کلیشه های جنسیتی رو از کلاممون حذف کنیم!',
//     'خودت رو نسبت به خودت رشد بده. نه هیچ آدم دیگه ای!',
//     'زندگی نه اونقدر کوتاهه که نتونی به آرزوهات برسی، نه اونقدر طولانیه که بتونی دست رو دست بذاری!',
//     'سخته، اما غیر ممکن نیست!',
//     'ایمپویی عزیز، چقدر مراقب زمین هستی؟',
//     'عزت نفس یعنی هم من ارزشمندم، هم دیگران!',
//     'برای شاد بودن، قرار نیست همه چی بی نقص باشه!',
//     'برنامت برای داشتن یک زندگی پویا و مفید چیه؟',
//     'آزادی و مسئولیت، همیشه کنار هم هستن.',
//     'ایمپویی جان خستگی ها موندگار نیستن. کمی به خودت زمان بده',
//     'به چیزهایی افتخار کنیم، که خودمون به دست آوردیمشون!',
//     'جنسیت یک انتخاب نیست. پس برتری جنسیتی بی معناست.',
//     'ایمپویی جان با جنسیتت در صلح هستی؟',
//     'مسیر اشتباه رو ادامه نده. برگرد و از اول شروع کن',
//     'غم رو تجربه کن، اما افسرده نشو.',
//     'قبل از انتخاب اهدافت، ارزشهای زندگیت رو بشناس!',
//     'یادت باشه تغییر یک شبه اتفاق نمیفته! نیاز به برنامه ریزی داره.',
//     'ایمپویی جان خوبی ها رو ببین و به زبون بیار ',
//     'اگه دنیا دست تو بود، چی رو ازش حذف میکردی؟',
//     'فردیت، یعنی مراقبت از استقلال و حریممون. فراموشش نکنیم!',
//     'از یک تا بیست، به تلاش امروزت چه نمره ای میدی؟!',
//     'دنیا هنوزم جای قشنگیه! خوب نگاه کن...',
//     'آدم ها رو از روی انتخابها و تصمیمهاشون می‌تونیم بشناسیم.',
//     'عزت نفس همون چیزیه که باعث میشه نه برنجونیم، و نه رنج بکشیم!',
//     'از خودمون بپرسیم اگه فرزندی داشته باشم، چقدر دوست دارم باورها و رفتارهاش شبیه من باشه؟',
//     'ورزش و شادی، میتونه ظرفیت روانی رو افزایش بده',
//     'اگه امروز آخرین فرصت زندگیمون بود، چطور میگذروندیمش؟',
//     'دست از تغییر دنیا بردار. قدم اول، تغییر خودته!',
//     'بیا تمرین کنیم به خودمون و دیگران احساس ارزشمندی بدیم.',
//     'زندگی بدون موسیقی چقدر خالی بود! موافقی؟',
//     'خاطره ها و یادداشت‌هات رو می‌تونی در تقویم اپلیکیشن ایمپو ثبت کنی ',
//     'ناشنوا باش وقتی همه از محال بودن آرزوهات حرف میزنن',
//     'اگه نمی‌تونی کارهای بزرگ انجام بدی، چیزهای کوچیک رو با روش عالی انجام بده',
//     'فقط غیرممکن، غیرممکنه',
//     'آینده متعلق به کسانیه که رؤیاهاشون رو باور دارن',
//     'مراقب بی نظمی های یک زندگی پرمشغله باش',
//     'از زندگی لذت ببر چون تکرار شدنی نیست',
//     'کوچکترین تغییرات میتونه بزرگترین تفاوت ها رو ایجاد کنه',
//     'بازنده ها به برنده ها توجه میکنن و برنده ها به پیروزی',
//     'وقتی ریشه ها عمیق هستن هیچ دلیلی برای ترسیدن از باد وجود نداره',
//     'در پشیمانی کارهایی که انجام ندادی زندگی نکن، انجامشون بده',
//     'زندگی کوتاهه، پرشور زندگی کن',
//     'نقطه شروع همه دستاوردها، خواستنه',
//     'خودت رو با آدمهایی که خوشحالت میکنن احاطه کن',
//     'رویاهات قوی ترن یا بهونه هات؟!',
//     'به دل ترسهات بزن و رهایی رو تجربه کن',
//     'خنده بر هر درد بی درمان؟',
//     'ببین، بخند و رد شو!',
//     'بزرگترین دشمنت، مقایسه خودته با دیگران',
//     'بهترین تصمیم، اونیه که باعث آرامش قلبت میشه',
//     'سفری به طول هزاران کیلومتر هم با قدم اول شروع میشه',
//     'تقدیر، تقویم افراد عادی و تغییر، تدبیر افراد عالی هست',
//     'اونقدر شاد باش که دیگران هم با نگاه کردن به تو شاد بشن',
//     'با چیزی که داری خوشحال باش و برای چیزی که می‌خوای، هیجان زده!',
//     'کمتر بترس و بیشتر امید داشته باش',
//     'کمتر حرف بزن و بیشتر حرف خوب بگو',
//     'کمتر نفرت داشته باش و بیشتر عشق بورز',
//     'تو همین لحظه شاد باش، این لحظه همه زندگی توئه',
//     'هیچ میدونی با خنده زیباتری؟',
//     'لبخند بزن بدون انتظار هیچ پاسخی از دنیا!',
//     'فکر کردن به گذشته مثل دویدن به دنبال باده..',
//     'هر وقت احساس تنهایی کردی یادت بیاد که ایمپو رفیقته',
//     'پیله ات را بگشا، تو به اندازه پروانه شدن زیبایی⁦♥️',
//     'لذت داشته هات رو با حسرت نداشته هات خراب نکن',
//     'خوشبختی، حسیه که میشه تولیدش کرد',
//     'باور، نیرومندتر از خوش بینی هست',
//     'شکستها از موفقیتها آموزنده ترن',
//     'از آینه بپرس، نام نجات دهنده ات را',
//     'مسیرهای سخت، اغلب به زیباترین مقصدها میرسن',
//     'سعی کن از دیروز خودت بهتر باشی',
//     'تو قویترین شخص زندگی خودت هستی',
//     'به این فکر کن سال دیگه این موقع کجایی، اگه الان جا نزنی!',
//     'برای چیزی که 5 سال دیگه ارزش نداره بیشتر از 5 دقیقه غصه نخور',
//     'کسی که بخواد همه کاره باشه، هیچ کاره‌س',
//     'دیگران رو همونجوری که هستن بپذیر',
//     'فرصتها، اتفاقی نیستن، فرصتها خلق شدنی هستن',
//     'تو ممکنه تعلل کنی، اما زمان هرگز!',
//     'اونقد قوی باش که هر روز با زندگی روبرو بشی',
//     'اگه اشتباه رفتی از برگشتن نترس',
//     'لطف بهار جز با سرمای زمستون بدست نمیاد',
//     'ناامید هرگز برنده نمیشه و برنده هرگز ناامید!'
//   ];
//
//   Future<bool> generateDashBoardAndNotifyMessages(lastCircle, RegisterParamViewModel)async{
//     _presenter = DashboardPresenter(this);
//     if(await checkConnectionInternet()){
//       // await login(lastCircle, RegisterParamViewModel,isRegistered,context,messageNotReadDialog,calenderPresenter);
//       getMessagesForServer(lastCircle, RegisterParamViewModel);
//       // await checkUserToken(currentToday, periodDay, maxDays, fertStartDays, fertEndDays, lastCircle, RegisterParamViewModel,isLoginScreen,context);
//
//     }else{
//
//       await getDateMessagesForLocal();
//
//     }
//
//     return true;
//
//   }
//
//   Future<bool> getDateMessagesForLocal()async{
//     List<MotivalListModel> motivals = await db.getAllMotival();
//     if(motivals == null){
//       for(int i=0 ; i< Messages().randomMessages.length ; i++){
//         await db.insertDb(
//             {
//               'serverId' : i.toString(),
//               'text' : Messages().randomMessages[i],
//               'isPin' : 0,
//               'link' : ''
//             },
//             'MotivalMessages'
//         );
//       }
//
//
//     }
//     return true;
//   }
//
//
//
//
//   Future<bool> getMessagesForServer(lastCircle,RegisterParamViewModel RegisterParamViewModel)async{
//       Map responseBody = await Http().sendRequest(
//           womanUrl,
//           'data/v1',
//           'GET',
//           {},
//          RegisterParamViewModel.token
//       );
//
//       // print(responseBody['motival']);
//       // print(responseBody['dashboardMessages']);
//       // print(responseBody['notifies']);
//       if(responseBody != null){
//         List<MotivalListServerModel> lists = [];
//         responseBody['motival'].forEach((item){
//           lists.add(MotivalListServerModel.fromJson(item));
//         });
//         await db.removeTable('MotivalMessages');
//         for(int i=0 ; i<lists.length ; i++){
//           await db.insertDb(
//               {
//                 'serverId' : lists[i].serverId,
//                 'text' : lists[i].text,
//                 'isPin' : lists[i].isPin ? 1 : 0,
//                 'link' : lists[i].link
//               },
//               'MotivalMessages'
//           );
//         }
//           getDashBoardMessagesForServer(responseBody['dashboardMessages']);
//           getNotifyMessagesForServer(responseBody['notifies'],lastCircle, RegisterParamViewModel);
//       }else{
//         await getDateMessagesForLocal();
//       }
//
//     return true;
//   }
//
//   getDashBoardMessagesForServer(dashBoardMessages)async{
//     List<DashBoardAndNotifyMessagesParentServerModel> lists = [];
//     dashBoardMessages.forEach((item){
//       lists.add(DashBoardAndNotifyMessagesParentServerModel.fromJson(item,'dashboardMessages'));
//     });
//     await db.removeTable('ParentDashboardMessages');
//     await db.removeTable('DashboardMessages');
//     if(lists.isNotEmpty){
//       for(int i=0 ; i<lists.length ; i++){
//         await db.insertDb(
//             {
//               'timeId' : lists[i].timeId,
//               'timeSend' : lists[i].timeSend,
//               'condition' : lists[i].condition,
//               'womanSign' : lists[i].womanSign,
//               'sexual' : lists[i].sexual,
//               'age' : lists[i].age,
//               'distance' : lists[i].distance,
//               'birth' : lists[i].birth,
//               'single' : lists[i].single
//             },
//             'ParentDashboardMessages'
//         );
//
//       }
//     }
//     List<DashBoardAndNotifyMessagesParentLocalModel> parentLocalList = await db.getAllParentDashboardMessages();
//     if(parentLocalList != null){
//       if(parentLocalList.isNotEmpty){
//         for(int i=0 ; i<parentLocalList.length ; i++){
//           for(int j=0 ; j<lists[i].dashboardMessages.length ; j++){
//             await db.insertDb(
//                 {
//                   'parentId' : parentLocalList[i].id,
//                   'strId' : lists[i].dashboardMessages[j].id,
//                   'text' : lists[i].dashboardMessages[j].text,
//                   'isPin' : lists[i].dashboardMessages[j].isPin ? 1 : 0,
//                   'link' : lists[i].dashboardMessages[j].link
//                 },
//                 'DashboardMessages'
//             );
//           }
//         }
//       }
//     }
//   }
//
//   getNotifyMessagesForServer(notifyMessages,lastCircle,RegisterParamViewModel RegisterParamViewModel)async{
//     List<DashBoardAndNotifyMessagesParentServerModel> lists = [];
//     notifyMessages.forEach((item){
//       lists.add(DashBoardAndNotifyMessagesParentServerModel.fromJson(item,'notifies'));
//     });
//     await db.removeTable('ParentNotifyMessages');
//     await db.removeTable('NotifyMessages');
//     if(lists.isNotEmpty){
//       for(int i=0 ; i<lists.length ; i++){
//         await db.insertDb(
//             {
//               'timeId' : lists[i].timeId,
//               'timeSend' : lists[i].timeSend,
//               'condition' : lists[i].condition,
//               'womanSign' : lists[i].womanSign,
//               'sexual' : lists[i].sexual,
//               'age' : lists[i].age,
//               'day' : lists[i].day,
//               'distance' : lists[i].distance,
//               'birth' : lists[i].birth,
//               'single' : lists[i].single
//             },
//             'ParentNotifyMessages'
//         );
//
//       }
//     }
//     List<DashBoardAndNotifyMessagesParentLocalModel> parentLocalList = await db.getAllParentNotifyMessages();
//     if(parentLocalList != null){
//       if(parentLocalList.isNotEmpty){
//         for(int i=0 ; i<parentLocalList.length ; i++){
//           for(int j=0 ; j<lists[i].dashboardMessages.length ; j++){
//            await db.insertDb(
//                 {
//                   'parentId' : parentLocalList[i].id,
//                   'strId' : lists[i].dashboardMessages[j].id,
//                   'text' : lists[i].dashboardMessages[j].text,
//                   'title' : lists[i].dashboardMessages[j].title
//
//                 },
//                 'NotifyMessages'
//             );
//           }
//         }
//       }
//     }
//     GenerateDashboardAndNotifyMessages().checkForNotificationMessage(lastCircle, RegisterParamViewModel);
//   }
//
//   @override
//   void onError(msg) {
//
//   }
//
//   @override
//   void onSuccess(msg) {
//
//   }
//
//
//
//   // registerToken()async{
//   //   String phoneModel = '';
//   //   // DataBaseProvider db  = new DataBaseProvider();
//   //   SharedPreferences prefs = await SharedPreferences.getInstance();
//   //   DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
//   //   if(Platform.isAndroid){
//   //     AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
//   //     phoneModel = androidInfo.model;
//   //   }else{
//   //     IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
//   //     phoneModel = iosInfo.model;
//   //   }
//   //   List<RegisterParamViewModel> RegisterParamViewModelList = await db.getAllRecordsRegister('Register');
//   //   RegisterParamViewModel RegisterParamViewModel = RegisterParamViewModelList[RegisterParamViewModelList.length-1];
//   //   // List<CircleModel> listCirclesItem = await db.getAllCirclesItem();
//   //   // CircleModel lastCircle = listCirclesItem[listCirclesItem.length-1];
//   //     prefs.setBool('isRegister',false);
//   //     print(RegisterParamViewModel.sex);
//   //     Map<String,dynamic> json = RegisterSendServerModel().generateJson(
//   //         RegisterParamViewModel.name, prefs.getString('deviceToken'),
//   //         RegisterParamViewModel.birthDay,RegisterParamViewModel.periodDay,
//   //         RegisterParamViewModel.lastPeriod, RegisterParamViewModel.circleDay,
//   //         RegisterParamViewModel.sex,phoneModel,RegisterParamViewModel.nationality
//   //     );
//   //     print(json);
//   //     Map responseBody = await Http().sendRequest(
//   //         'http://192.168.1.105:12000',
//   //         'customerAccount/registerToken',
//   //         'PUT',
//   //         json,
//   //         ''
//   //     );
//   //
//   //     print(responseBody);
//   //     print('saved to server');
//   //
//   //     if(responseBody != null){
//   //       if(responseBody['result']){
//   //         prefs.setBool('isRegister',true);
//   //         loginToken(type, value, context, animations, randomMessage);
//   //       }else{
//   //         prefs.setBool('isRegister',false);
//   //       }
//   //       // else{
//   //       if(type != 0){
//   //         animations.showShakeError('خطا در برقراری اتصال، اینترنت خود را بررسی کنید');
//   //         if(!isLoading.isClosed){
//   //           isLoading.sink.add(false);
//   //         }
//   //       }
//   //       // }
//   //     }else{
//   //       prefs.setBool('isRegister',false);
//   //     }
//   //     // else{
//   //     if(type != 0){
//   //       animations.showShakeError('خطا در برقراری اتصال، اینترنت خود را بررسی کنید');
//   //       if(!isLoading.isClosed){
//   //         isLoading.sink.add(false);
//   //       }
//   //     }
//   //     // }
//   //
//   // }
//
// }