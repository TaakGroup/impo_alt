//
//
// import 'dart:math';
//
// import 'package:impo/src/data/messages/sug_after_period.dart';
// import 'package:impo/src/data/messages/sug_before_period.dart';
// import 'package:impo/src/data/messages/sug_mental.dart';
// import 'package:impo/src/data/messages/sug_other.dart';
// import 'package:impo/src/models/dashboard_messages_local_model.dart';
//
// class SugGenerator {
//
//
//   List<DashBoardAndNotifyMessagesLocalModel> getTwoSug(name,periodDay,currentDay,ovumDay,fertStart,fertEnd,pmsStart,maxDay,sex,circleModel) {
//
//     List<String> all = getAllSug(name,periodDay,currentDay,ovumDay,fertStart,fertEnd,pmsStart,maxDay,sex,circleModel);
//     List<DashBoardAndNotifyMessagesLocalModel> messages = [];
//     for(int i=0 ; i<all.length ; i++){
//       messages.add(
//           DashBoardAndNotifyMessagesLocalModel.fromJson(
//         {
//          'id' : 0,
//          'parentId' : 0,
//          'strId' : '',
//          'text' : all[i],
//          'isPin' : 0,
//           'link' : ''
//         },
//         false
//       )
//       );
//     }
//     if (messages.length <= 2) {
//       return messages;
//     }
//     else {
//       return getTwoRandom(messages);
//     }
//   }
//
//   List<DashBoardAndNotifyMessagesLocalModel> getTwoRandom(List<DashBoardAndNotifyMessagesLocalModel> bankStr) {
//     int random1 = new Random().nextInt(bankStr.length);
//     int random2 = new Random().nextInt(bankStr.length);
//     if (random1 == random2)
//       return getTwoRandom(bankStr);
//     else {
//       List<DashBoardAndNotifyMessagesLocalModel> twoStr = [];
//       twoStr.add(bankStr[random1]);
//       twoStr.add(bankStr[random2]);
//       return twoStr;
//     }
//   }
//
//
//   List<String> getAllSug(name,periodDay,currentDay,ovumDay,fertStart,fertEnd,pmsStart,maxDay,sex,circleModel) {
//     List<String> allStr = [];
//     normalMessage(name,allStr,periodDay,currentDay,ovumDay,fertStart,fertEnd,sex);
// //    NotifyMessage(allStr, points_item);
//     needMessage(name,allStr,periodDay,currentDay,ovumDay,fertStart,fertEnd,pmsStart,sex);
//     SugBeforePeriod().get(name,allStr,currentDay,maxDay,periodDay,pmsStart,circleModel);
//     SugAfterPeriod().get(name, allStr, currentDay, maxDay, periodDay, circleModel);
//     SugMental().get(name, allStr, currentDay, maxDay, circleModel);
//     SugOther().get(name, allStr, currentDay,pmsStart,periodDay, circleModel);
//     return allStr;
//   }
//
//
//   void normalMessage(name,List<String> bankStr,periodDay,currentDay,ovumDay,fertStart,fertEnd,sex){
//     // NORM 1 AND 2
//     if (periodDay > 6)
//     {
//       if (currentDay >= 6 && currentDay <= 13)
//         norm_1_2(name,bankStr);
//     }
//     else if (currentDay >= (periodDay + 1) && currentDay <= (periodDay+ 8))
//     {
//       norm_1_2(name,bankStr);
//     }
//
//     //NORM 3
//     if((ovumDay - 3) > periodDay)
//     {
//       if (currentDay >= (ovumDay - 3) && currentDay <= (ovumDay + 3) && sex == 1)
//       {
//         bankStr.add(" این هفته، فرصت خوبیه برای اقدام به " +
//             "بارداری. " +
//             "استروژن افزایش پیدا میکنه و حال و حوصله " +
//             "خوبی پیدا می کنی.");
//       }
//     }
//     else if (currentDay >= (periodDay+1) && currentDay <= (ovumDay + 3) && sex == 1)
//     {
//       bankStr.add(" این هفته، فرصت خوبیه برای اقدام به " +
//           "بارداری. " +
//           "استروژن افزایش پیدا میکنه و حال و حوصله " +
//           "خوبی پیدا می کنی.");
//     }
//
//     //NORM 4 AND 6
//
//     if (currentDay >= fertStart && currentDay <= fertEnd && sex == 1)
//     {
//       List<String> strItems =[];
//
//       strItems.add(" رابطه جنسی در این روزها خیلی لذت " +
//           "بخشه و ارگاسم بهتری می‌تونی داشه باشی.");
//
//       strItems.add("اگه داری به باردار شدن فکر میکنی، حتما شروع کن به یادگیری مهارتهای فرزندپروری.");
//
//       strItems.add("هدف بارداری داری؟ حواست باشه اتفاق خیلی مهمیه. لازمه آمادگی جسمی، روحی و فکریشو داشته باشی!");
//
//       strItems.add("اگه نمی‌خوای باردار بشی، این روزا بیشتر مراقب باش \uD83D\uDE0A");
//
//       strItems.add("ایمپویی عزیز این روزا از نظر ذهنی روزای خیلی خوبیه. سعی کن بیشتر واسه اهدافت وقت بذاری \uD83D\uDE0A");
//
//       strItems.add("این روزها بدنت آماده بارور شدنه. لازمه اینو بدونی ");
//
//       bankStr.add(strItems[Random().nextInt(5)]);
//
//     }
//     if (currentDay >= fertStart && currentDay <= fertEnd)
//     {
//       bankStr.add(" به شروع یک هدف جدی فکر " +
//           "کن! اینروزا می تونه فرصت خوبی باشه.");
//
//       bankStr.add("ایمپویی عزیز این روزا از نظر ذهنی روزای خیلی خوبیه. سعی کن بیشتر واسه اهدافت وقت بذاری \uD83D\uDE0A");
//
//       bankStr.add("از حال خوب این روزات حسابی استفاده کن!");
//
//       bankStr.add("وضعیت هورمون ها اینروزا خوبه. و این یعنی می‌تونیم به اهداف و تصمیم های جدید فکر کنیم");
//
//       bankStr.add("فکری برای فایلهای باز و کارهای نیمه تمام کن!");
//     }
//
//     //NORM 5
//     if((ovumDay - 3) > periodDay)
//     {
//       if (currentDay >= (ovumDay - 3) && currentDay <= ovumDay)
//       {
//         bankStr.add(" این هفته، فرصت خوبیه واسه " +
//             "صحبت های جدی، و تصمیمات جدی. بهش " +
//             "فکر کن!");
//       }
//     }
//     else if (currentDay >= (periodDay +1) && currentDay <= ovumDay)
//     {
//       bankStr.add(" این هفته، فرصت خوبیه واسه " +
//           "صحبت های جدی، و تصمیمات جدی. بهش " +
//           "فکر کن!");
//     }
//
//     if (currentDay == periodDay)
//     {
//       bankStr.add(" از فردا تا 3 روز آینده، بهترین زمان برای انجام چکاپ سرطان سینه ست. از سلامتیت غافل نشی!");
//     }
//
//
//   }
//
//   void norm_1_2(name,List<String> bankStr){
//
//     bankStr.add(" این روزها و این هفته، هفته خوبی برای مغز و " +
//         "ذهنته. دوران آرومی رو میگذرونی و می‌تونی " +
//         "درست تر فکر کنی و تصمیم بگیری");
//
//     bankStr.add(" هر چی به دوره تخمک گذاری " +
//         "نزدیک تر میشی، خلاقیت و ابتکارت بیشتر " +
//         "میشه و بهتر از عهده چالش ها بر میای");
//   }
//
//   void needMessage(name,List<String> bankStr,periodDay,currentDay,ovumDay,fertStart,fertEnd,pmsStart,sex) {
//
//     bool notInPeriod = currentDay > periodDay;
//     bool notInFert = (currentDay < fertStart) || (currentDay > fertEnd);
//     bool notInPms = currentDay < pmsStart;
//
//     if (notInPeriod && notInFert && notInPms)
//     {
//       bankStr.add(" هدف هاتو روی کاغذ بنویس تا بهتر بتونی برای رسیدن بهشون تمرکز کنی!");
//       bankStr.add("  کارهای روزانه ت رو اول صبح لیست و زمانبندی کن! مطمئنم تا شب همه رو انجام میدی!");
//       bankStr.add("  سپاسگزار بودن و شکرگزاری برای نعمت های زندگیت حالتو بهتر میکنه!");
//       bankStr.add("  یادت نره امروز برای خانواده و عزیزانت وقت بذاری!");
//       bankStr.add("  با چرخه هورمونی و تغییرات ماهیانه خودت آشنا هستی؟ حتما دربارش بیشتر مطالعه کن.");
//       bankStr.add("  اینروزا از نظر هورمونی کمترین نوسان و تغییر رو داری. از آرامشت برای تکمیل کارهای عقب افتاده ت استفاده کن.");
//       bankStr.add(" موفقیت بدون برنامه ریزی نداریما! نگی نگفتی! \uD83D\uDE0A");
//       bankStr.add("لازم نیست از همه بهتر باشیم! کافیه خودمون با خودمون رقابت کنیم \uD83D\uDE0A");
//       bankStr.add("ایمپویی عزیز خودمراقبتی یک مسئولیته. ازش غافل نشو \uD83D\uDE0A");
//       bankStr.add("زندگی سالم، زندگی معتدله! یعنی تقسیم زمان و انرژی، برای همه بخش های زندگی!");
//       bankStr.add("قبل از خواب، لیست کارهاتو بنویس. اینجوری با ذهن آروم تری میخوابی ");
//       bankStr.add("چرخه قاعدگیت رو بیشتر بشناس تا بهره وری بیشتری در کارهات داشته باشی.");
//       bankStr.add(" یادمون نره: گفتگو، شفاست....");
//       bankStr.add("شب های طولانی، خودت رو دعوت کن به کتابهای خواندنی، و فیلم های تماشایی");
//       bankStr.add("چقد بدنت رو میشناسی؟ چقدر درست ازش مراقبت می کنی؟");
//       bankStr.add("به حرف های بدنت گوش کن. خشم ها و رنج ها میتونن تبدیل به آزردگی های جسمی بشن.");
//       bankStr.add("می‌تونی با سر زدن به صفحه تقویم اپلیکیشن، اطلاعات دوره های قبلت رو ببینی.");
//       bankStr.add(" با پریودت نجنگ. پذیرش و صلح، آرومت میکنه.");
//       bankStr.add("پاییز و زمستون بهتره برنامه غذایی سبک تری داشته باشی.");
//       bankStr.add("بهتره چکاپ های مورد نظرت رو لیست کنی و منظم انجامشون بدی تا فراموش نشن.");
//       bankStr.add("کیف قاعدگی بساز و وسایل مورد نیازت رو بذار داخلش.");
//       bankStr.add("اهدافت رو بنویس، و واسشون برنامه ریزی کن. به این میگن عمل گرایی!");
//       bankStr.add("برنامه غذایی سالم،خواب کافی، مطالعه، ورزش و گفتگو! اینا در زندگی فراموش نشه");
//       bankStr.add("مشغول خوندن چه کتابی هستی؟");
//       bankStr.add("رهرو آنست که آهسته و پیوسته رود...");
//       bankStr.add("آخرین کاری که برای رشد فردیت انجام دادی چی بوده؟!");
//       bankStr.add("هر روز سعی کن یه چیز جدید یاد بگیری!");
//
//     }
//
//
//     bool InPeriod = currentDay <= periodDay;
//     bool InPms = currentDay >= pmsStart;
//
//     if (InPeriod) {
//       bankStr.add("تو باهوشی! فقط پریود میتونه اینروزا تمرکزت رو بیاره پایین.");
//       bankStr.add("  حداکثر هر 5-4 ساعت پد بهداشتی یا تامپونت رو عوض کن تا احتمال عفونت و حساسیت های پوستی رو " +
//           "کاهش بدی.");
//       bankStr.add("  قاعدگی شدید، میتونه ناشی از بیماری کم خونی، تورم گردنه رحم، پولیپ، فیبروم، یا کیست باشه. لطفا نسبت " +
//           "بهش بی توجه نباش.");
//       bankStr.add("  مدیتیشن یک راه عالی برای کاهش عصبانیته. خیلی هم ساده ست! چشاتو ببند، و روی تنفست تمرکز کن \uD83D\uDE0A");
//       bankStr.add("   بهتره یادداشت کنی هر روز چند لیوان آب میخوری، تا لابلای مشغله هات ازش غافل نشی. همراه با خونریزی، " +
//           "آب بدنت رو هم تا حدی از دست میدی.");
//       bankStr.add("  شستشوی واژن رو در دوران خونریزی جدی بگیر. آب ولرم میتونه گزینه خوبی باشه.");
//     }
//
//     if (InPms)
//     {
//       bankStr.add("  علاوه بر پریود، افسردگی، دوران پیش از یائسگی یا بیماری های تیروئیدی هم علائمی مثل PMS رو ایجاد " +
//           "میکنه. پس اگه این روزا خیلی اذیت میشی، همه علائم رو بررسی کن.");
//       bankStr.add("  سعی کن تا حد ممکن به جای دارو، دردتو با یوگا، استراحت و برنامه غذایی خوب آروم تر کنی.");
//       bankStr.add("  اینروزا مصرف چربی، شکر، کافئین و الکل رو خیلی کم کن.");
//       bankStr.add("  اصلی ترین تغییر اینروزا چیه؟ ناپایداری عاطفی، نوسان خلق، و ناراحتی های ناگهانی. با خودت مهربون باش " +
//           "\uD83D\uDE0A");
//       bankStr.add("  سندروم پیش از قاعدگی سخت هست، اما غیر قابل مدیریت نیست! لازمه بیشتر با خودت و نیازهای جسمی و " +
//           "روانیت آشنا بشی.");
//     }
//
//   }
//
//
//
//   String randomNameGET(name){
//     List<String> names = [];
//     names.add("ایمپویی عزیز");
//     names.add("دوست خوبم");
//     names.add(name);
//     names.add("$name جان")   ;
//     return names[new Random().nextInt(4)];
//   }
//
// }