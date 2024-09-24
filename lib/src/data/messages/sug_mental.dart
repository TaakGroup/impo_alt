//
//
//
//
// import 'dart:convert';
// import 'dart:math';
//
// import 'package:impo/src/data/messages/sug_generator.dart';
// import 'package:impo/src/models/circle_model.dart';
//
// class SugMental{
//
//   get(name,List<String> bankStr,currentDay,maxDay,CycleViewModel circleModel) {
//
//     List mental = circleModel.mental != '' ? json.decode(circleModel.mental) : [];
//
//     for (int i = 0; i < mental.length; i++)
//     {
//       switch (mental[i])
//       {
//         case 0:
//           mental0(name,bankStr,currentDay,maxDay);
//           break;
//         case 1:
//           mental1(name,bankStr,currentDay,maxDay);
//           break;
//         case 2:
//           mental2(name,bankStr,currentDay,maxDay);
//           break;
//         case 3:
//           mental3(name,bankStr,currentDay,maxDay);
//           break;
//         case 4:
//           mental4(name,bankStr,currentDay,maxDay);
//           break;
//         case 5:
//           mental5(name,bankStr,currentDay,maxDay);
//           break;
//         case 6:
//           mental6(name,bankStr,currentDay,maxDay);
//           break;
//       }
//     }
//   }
//
//   mental0(name,List<String> bankStr,currentDay,maxDay){
//
//     if (currentDay <= 2 || currentDay >= (maxDay- 3)) {
//       List<String> strItems =[];
//       strItems.add( "این روزا، روزای خوبی برای ذهن و روحت " +
//           "نیست. سعی کن با خودت مهربون تر باشی!");
//       strItems.add( "چی میتونه اینروزا خوشحالت کنه؟! یه کاری رو فقط " +
//           "و فقط واسه خودت انجام بده \uD83D\uDE0E");
//       strItems.add( "اگه درگیر تجربه هیجانات منفی هستی، " +
//           "درموردش با اطرافیانت صحبت کن.");
//
//       strItems.add( "آخرین باری که واسه خودت هدیه گرفتی کی بوده؟ \uD83D\uDE0A");
//
//       strItems.add("یهو غمگین یا بی قرار میشی؟ میفهمم. این چند روز که بگذره آروم میشی \uD83D\uDE0A");
//
//       strItems.add("اما یادت نره اگه خیلی تحت فشاری، دست رو دست نذاری و از یک روانشناس خوب کمک بگیری!");
//
//       strItems.add("یه خرده با خودت خلوت کن ");
//
//       strItems.add("میدونی چیه؟ آدمیزاد همینه دیگه! گاهی خوشحال، گاهی غمگین!");
//
//       strItems.add("از اطرافیانت بخواه که این روزا بیشتر درکت کنن.");
//
//
//       bankStr.add(strItems[new Random().nextInt(9)]);
//     }
//
//   }
//
//   mental1(name,List<String> bankStr,currentDay,maxDay) {
//     if (currentDay >= (maxDay-3)) {
//       List<String> strItems =[];
//       strItems.add("تغییرات هورمونی میتونه باعث " +
//           "نگرانی و دلشوره بشه. به خودت یادآوری کن قرار " +
//           "نیست اتفاق بدی بیفته و احساسات این روزات " +
//           "موقتیه. \uD83D\uDE0E");
//       strItems.add( "کارهای جدید و گفتگوهای جدی رو این " +
//           "روزا شروع نکن. ممکنه اضطرابت رو بیشتر کنه.");
//       strItems.add( "یوگا، مدیتیشن، پیاده روی و گفتگو می " +
//           "تونه اضطراب این روزا رو کمتر کنه! یکیشو امتحان " +
//           "کن");
//
//       strItems.add("فکر کنم یک موزیک لایت، یک دمنوش و یک مدیتیشن کوتاه، میتونه یه خرده حالتو بهتر کنه \uD83D\uDE0A");
//
//       strItems.add("اگه اضطرابت روی عملکرد روزانه ت تاثیر میذاره، از یک مشاور کمک بگیر!");
//
//       strItems.add("بهتره اینروزا کمتر کارهای جدی انجام بدی!");
//
//       strItems.add("اضطراب طولانی رو جدی بگیر عزیزم. روزهای زندگی میتونه آروم تر بگذره ");
//
//       strItems.add("خودت رو به خاطر حال اینروزات سرزنش نکن. تغییرات هورمونیه دیگه ");
//
//       bankStr.add(strItems[new Random().nextInt(8)]);
//     }
//   }
//
//   mental2(name,List<String> bankStr,currentDay,maxDay) {
//     if (currentDay >= (maxDay-2) || currentDay <= 2) {
//       List<String> strItems =[];
//       strItems.add( "میفهمم که دلت میخواد گریه کنی یا " +
//           "احساس نا امیدی داری! درموردش صحبت کن و به " +
//           "خودت فرصت بده که بگذره.");
//       strItems.add( "قاعدگی و تغییرات هورمونی گاهی باعث میشه فکر " +
//           "کنیم همه درها بسته شده و همه چیز ناامید کننده س! " +
//           "یادت باشه چند روز دیگه همه چی عوض میشه.");
//       strItems.add( "سعی کن این روزا یه خرده وقتتو صرف " +
//           "کارهایی کنی که علاقه داری، تا انرژی بگیری. \uD83D\uDE09");
//
//       strItems.add("پاشو یه کاری کن فقط و فقط واسه خودت و دلت! پا شدی؟ \uD83D\uDE0A");
//
//       strItems.add("غم هم یک احساسه. مثل بقیه احساسها. ازش فرار نکن. همیشه که قرار نیست خوشحال باشیم! \uD83D\uDE0A");
//
//       strItems.add("حتی اگه سرحال نیستی، یادت باشه: زندگی هنووووز خوشگلیاشو داره!");
//
//       strItems.add("اگه غممون رو جدی بگیریم و بهش بپردازیم، غم تبدیل به افسرذگی نمیشه!");
//
//       strItems.add("زندگی هنوز خوشگلیاشو داره ");
//
//       strItems.add("اگه اینروزا خیلی از نظر روحی به هم میریزی، با یک روانشناس گفتگو کن.");
//
//       strItems.add("چندتا دوست خوب و واقعی در زندگیت داری؟");
//
//
//       bankStr.add(strItems[new Random().nextInt(10)]);
//     }
//   }
//
//   mental3(name,List<String> bankStr,currentDay,maxDay) {
//     if (currentDay >= (maxDay-2) || currentDay <= 2) {
//       List<String> strItems =[];
//       strItems.add( "این روزا به خودت و اطرافیانت یادآوری " +
//           "کن که نیاز به صبر و محبت بیشتری داری .");
//       strItems.add("سعی کن این روزا زیاد وارد بحث نشی که " +
//           "ناراحتی رو تجربه نکنی");
//       strItems.add( "تو خیلی توانمند و باهوشی! فقط این " +
//           "روزا تمرکزت اومده پایین. پس از خودت تکالیف سخت " +
//           "نخواه!");
//
//       strItems.add("همیشه که قرار نیست همه چیز عالی باشه! به خودت حق بده گاهی هم خسته باشی \uD83D\uDE0A");
//
//       strItems.add("میدونستی ورزش همونقدر که به جسمت کمک میکنه، روانتم قوی میکنه؟");
//
//       strItems.add("تاب آوری، یعنی در اثر طوفان خمیده میشم اما نمیشکنم!");
//
//       strItems.add("اگه اینروزا کمی کم تحمل شدی، از گفتگوها و تصمیم های مهم فاصله بگیر.");
//
//       strItems.add("درباره حس و حال اینروزات با آدمهای دور و برت حرف بزن.");
//
//       strItems.add("گاهی هم چند قطره اشک، میتونه ظرفیت روانی مون رو ببره بالا و روحمون رو سبک کنه");
//
//       bankStr.add(strItems[new Random().nextInt(9)]);
//     }
//   }
//
//   mental4(name,List<String> bankStr,currentDay,maxDay) {
//     if (currentDay >= (maxDay-2) || currentDay <= 2) {
//       List<String> strItems =[];
//       strItems.add( "اگه از من بپرسی، میگم همین امروز نیم ساعت با " +
//           "خودت خلوت کن. یک مدیتیشن حسابی میتونه شارژت " +
//           "کنه.");
//       strItems.add( "درمورد احساس خشمی که اینروزا تجربه میکنی، با " +
//           "اطرافیانت صحبت کن \uD83D\uDE44 ");
//
//       strItems.add("یادمون نره! تجربه احساس خشم، با پرخاشگری و بدرفتاری فرق داره!");
//
//       strItems.add("عصبانی هستی؟ یه خرده با خودت خلوت کن.");
//
//       strItems.add("درسته قاعدگی شرایط روحیمونو به هم میریزه. اما یادمون باشه ما همیشه مسئول رفتارهامون هستیم \uD83D\uDE0A");
//
//       strItems.add("درسته قاعدگی روحمون رو آزرده میکنه، اما معنیش این نیست که قابل مدیریت نیست!");
//
//       strItems.add("گاهی به یک شنونده خوب نیاز داریم. فقط همین!");
//
//       strItems.add("حرف بزن. با آدمهای امن زندگیت حرف بزن!");
//
//       bankStr.add(strItems[new Random().nextInt(8)]);
//     }
//   }
//
//   mental5(name,List<String> bankStr,currentDay,maxDay) {
//     if (currentDay >= (maxDay-2)) {
//       List<String> strItems =[];
//       strItems.add( "پریودت نزدیکه. پیشنهاد میکنم بیشتر با " +
//           "خودت خلوت کنی.");
//       strItems.add("تنهایی و آرامش میتونه حالتو بهتر کنه. " +
//           "واسه خودت وقت بذار");
//       strItems.add( "درسته این روزا نیاز به تنهایی داری، " +
//           "اما حواست باشه از اهداف مهمت عقب نمونی!");
//
//       bankStr.add(strItems[new Random().nextInt(3)]);
//     }
//   }
//
//   mental6(name,List<String> bankStr,currentDay,maxDay) {
//     if (currentDay >= (maxDay-3)) {
//       List<String> strItems =[];
//       strItems.add( "طبیعیه که میل جنسیت کم شده باشه. " +
//           "درموردش با همسرت (همدلت) صحبت کن و ازش " +
//           "بخواه درکت کنه.");
//       strItems.add("ممکنه این روزا رابطه جنسیت خیلی " +
//           "موفق و مطلوب نباشه. خودتو سرزنش نکن.");
//       strItems.add( "اگه تا حالا درمورد میل جنسیت با همسرت " +
//           "صحبت نکردی، زودتر تجربه ش کن!");
//       bankStr.add(strItems[new Random().nextInt(3)]);
//     }
//   }
//
//
//
// }
//
//
