//
//
// import 'dart:convert';
// import 'dart:math';
//
// import 'package:impo/src/data/messages/sug_generator.dart';
// import 'package:impo/src/models/circle_model.dart';
//
// class SugAfterPeriod{
//
//   get(name,List<String> bankStr,currentDay,maxDay,periodDay,CycleViewModel circleModel) {
//
//     List after = circleModel.after != '' ? json.decode(circleModel.after) : [];
//
//     for (int i = 0; i < after.length; i++)
//     {
//       switch (after[i])
//       {
//         case 0:
//           after0(name,bankStr,currentDay,periodDay);
//           break;
//         case 1:
//           after1(name,bankStr,currentDay,periodDay);
//           break;
//         case 2:
//           after2(name,bankStr,currentDay,maxDay);
//           break;
//         case 3:
//           after3(name,bankStr,currentDay,maxDay);
//           break;
//         case 4:
//           after4(name,bankStr,currentDay,periodDay);
//           break;
//         case 5:
//           after5(name,bankStr,currentDay,periodDay);
//           break;
//         case 6:
//           after6(name,bankStr,currentDay,maxDay);
//           break;
//       }
//     }
//   }
//
//   after0(name,List<String> bankStr,currentDay,periodDay){
//     if (currentDay <= 3) {
//       List<String> strItems =[];
//       // strItems.add(SugGenerator().randomNameGET(name) + " امروز احتمالا دردهای شکمی رو تجربه " + "میکنی.\uD83D\uDE41 استفاده از کیسه آب گرم، و استراحت " + "میتونه شرایط رو بهتر کنه \uD83D\uDE0D");
//       strItems.add("کیسه آب گرم میتونه دل دردت رو کمتر کنه");
//
//       strItems.add(" امروز احتمالا دچار دردهای شکمی میشی، " +
//           "پس سعی کن از خوردنی های کافئین دار مثل چای " +
//           "و قهوه و نوشابه کمتر استفاده کنی، دوش آب گرم " +
//           "هم میتونه بهت کمک کنه");
//
//       strItems.add( " نرمش و پیاده روی، انقباض های بدنی رو کمتر میکنه. \uD83D\uDCAA");
//
//       strItems.add("حوله گرم و ماساژ زیر شکم میتونه دل درد رو کمتر کنه \uD83D\uDE0A");
//
//       strItems.add("اینروزا بیشتر حواست به برنامه غذاییت باشه، تا درد کمتری رو تجربه کنی");
//
//       strItems.add("ایمپویی عزیز، سعی کن بدنتو گرم نگه داری تا دردهات کمتر بشن.");
//
//       if (periodDay >= 3 || currentDay <= 2) {
//         bankStr.add(strItems[new Random().nextInt(6)]);
//       }
//     }
//   }
//
//   after1(name,List<String> bankStr,currentDay,periodDay) {
//     if (currentDay <= 3) {
//       List<String> strItems =[];
//       strItems.add(" گفته بودی این روزا کمردرد داری! " +
//           "حواست باشه فعالیت و کار سنگین نکنی!");
//       strItems.add(" مکمل های ویتامین ب، دوش آب گرم و پیاده روی " +
//           "سبک میتونه کمر دردی رو که امروز باهاش درگیری " +
//           "رو تسکین بده");
//       strItems.add(" این روزا باید حسابی حواست به خودت باشه. " +
//           "استراحتتو بیشتر کن . کار سنگین رو کمتر! این " +
//           "تنها راه تسکین کمردردته!");
//
//       strItems.add("کمردرد داری؟ فعالیت های سنگین ممنوع!");
//
//       strItems.add("ایمپویی عزیز اینروزها کمی نرمش کن که کمردرد کمتری رو تجربه کنی.");
//
//       strItems.add(" لباسها و شلوارهای خیلی تنگ، میتونه دردهای بدنی این روزا رو بیشتر کنه.");
//
//       strItems.add("ماساژ، پیاده روی، و نفس عمیق فراموش نشه! ");
//
//       if (periodDay >= 3 || currentDay <= 2)
//         bankStr.add(strItems[new Random().nextInt(7)]);
//     }
//   }
//
//   after2(name,List<String> bankStr,currentDay,maxDay) {
//     if (currentDay >= (maxDay-3)) {
//       List<String> strItems =[];
//       strItems.add(" این چند روز احتمالا جوش صورت رو تجربه " +
//           "میکنی، خواستم بهت بگم که طبیعیه، باهاش کنار " +
//           "بیا. " + SugGenerator().randomNameGET(name) + " تو با جوش هم زیبایی! \uD83D\uDE0D ");
//
//       strItems.add(" اگه این روزها جلوی آینه رفتی به " +
//           "جوش های روی صورتت لبخند بزن. این چند روز " +
//           "مهمون ناخونده صورتت هستن پس باهاشون مدارا " +
//           "کن \uD83D\uDE0D");
//
//       strItems.add("عزیزم جوش صورت، یک مهمون موقته! باهاش دوست باش \uD83D\uDE0A");
//
//       strItems.add("کی میگه جوش صورت، زشتت میکنه؟ با خودت مهربون باش دختر زیبا \uD83D\uDE0A");
//
//       strItems.add("اگه صورتت خیلی جوش میزنه، با پزشک مشورت کن تا بتونی بهتر از پوستت مراقبت کنی \uD83D\uDE0A");
//
//       strItems.add("تغییرات پوستی این روزا طبیعی و موقتیه. با خودت مهربون باش.");
//
//       strItems.add("ماسک صورت، شستشوی منظم صورت و مراقبت از پوست فراموش نشه!");
//
//       bankStr.add(strItems[new Random().nextInt(7)]);
//     }
//   }
//
//   after3(name,List<String> bankStr,currentDay,maxDay) {
//     if (currentDay == 1 || currentDay >= (maxDay-3)) {
//       List<String> strItems =[];
//       strItems.add(" اگه اینروزا نگران نفخ هستی، فراموش نکنی که " +
//           "از غذاهای کم نمک استفاده کنی.");
//       strItems.add( " اگه قبل از قاعدگی دچار نفخ میشی، یادت باشه " +
//           "استرس میتونه نفخ رو شدید کنه!");
//       strItems.add(" ورزش منظم و سبک میتونه بهت کمک کنه تا کمتر " +
//           "دچار نفخ بشی" );
//
//       strItems.add("نمک و ادویه غذاتوکم کن. احتمالا به کاهش نفخ کمک میکنه \uD83D\uDE0A");
//
//       strItems.add(" عدم تحرک کافی، عوارض مختلفی داره. یکیش میتونه نفخ باشه!");
//
//       strItems.add("اگه نفخ خیلی اذیتت میکنه، با متخصص تغذیه مشورت کن که برنامه غذاییت بررسی بشه.");
//
//       strItems.add("برنامه غذایی مناسب و منظم، از مسئولیت های ما نسبت به خودمونه");
//
//       strItems.add("سعی کن این روزا غذاهای سبک تر و سالم تری بخوری ");
//
//       bankStr.add(strItems[new Random().nextInt(8)]);
//     }
//   }
//
//   after4(name,List<String> bankStr,currentDay,periodDay) {
//     if (currentDay <= 3) {
//       List<String> strItems =[];
//       strItems.add(" بهمون گفته بودی که اینروزا احتمالا دچار اسهال " +
//           "و مشکلات روده میشی. پس حتما بیشتر آب بخور و " +
//           "کمتر از مواد غذایی کافئین دار مثل قهوه و چای " +
//           "استفاده کن!");
//       strItems.add(" هوای گرم، احتمال حساس شدن روده ها و " +
//           "اسهال رو بیشتر میکنه. پس اگه لازم بود، سعی کن " +
//           "بیشتر خونه باشی");
//       strItems.add(" میدونستی استرس به تنهایی میتونه تحریک " +
//           "پذیری روده رو بیشتر کنه؟ \uD83D\uDE0C ");
//
//       if (periodDay >= 3 || currentDay <= 2)
//         bankStr.add(strItems[new Random().nextInt(3)]);
//     }
//   }
//
//   after5(name,List<String> bankStr,currentDay,periodDay) {
//     if (currentDay <= 3) {
//       List<String> strItems =[];
//       strItems.add(" مشکل یبوستی که امروز احتمالا تجربه میکنی رو " +
//           "با مصرف غذاهای فیبردار مثل میوه و سبزیجات " +
//           "می‌تونی حل کنی!");
//       strItems.add(" حواست هست که به اندازه کافی آب بخوری؟ " +
//           "آخه مهم ترین درمان یبوستی که این روزا دچارش " +
//           "شدی همین مصرف آب به میزان کافیه");
//       strItems.add(" اگه این ماه هم دچار یبوست شدی، از نظم و " +
//           "کیفیت برنامه غذاییت غافل نشی! تو داری روزای " +
//           "سختی رو میگذرونی.");
//
//       strItems.add(" یبوست خیلی مهمه! برنامه غذاییتو مدیریت کن و نذار طولانی بشه.");
//
//       strItems.add("بیشتر مایعات گرم مصرف کن، تا این روزا کمتر دچار یبوست بشی.");
//
//       strItems.add("شمردی چند لیوان آب خوردی امروز؟");
//
//       strItems.add("یبوست ممکنه از عوارض مصرف داروهای مکمل هم باشه. پس در صورت نیاز با پزشکت مشورت کن \uD83D\uDE0A");
//
//       strItems.add("بدنت رو بشناس، و به نیازهاش درست پاسخ بده.");
//
//       strItems.add("یبوست های طولانی میتونه زمینه ساز بیماری باشه. نادیده نگیرش!");
//
//       strItems.add("یبوست میتونه گاهی هم به دلیل اضطراب باشه. حواست به حال دلت باشه ");
//
//
//       if (periodDay >= 3 || currentDay <= 2)
//         bankStr.add(strItems[new Random().nextInt(10)]);
//     }
//   }
//
//   after6(name,List<String> bankStr,currentDay,maxDay) {
//     if (currentDay <= 2 || currentDay >= (maxDay-2)) {
//       List<String> strItems =[];
//       strItems.add(" اگه از اون دسته خانومایی هستی که خوابت " +
//           "زیاد میشه دوران قاعدگی، لطفا خودتو سرزنش نکن " +
//           "و تا جایی که می‌تونی زمان بیشتری بذار برای " +
//           "خواب. \uD83D\uDE34 ");
//       strItems.add(" خوابت زیاد شده؟ بدنت به استراحت نیاز داره! " +
//           "لطفا به نیاز بدنت توجه کن \uD83D\uDE0C");
//       strItems.add(" تازگیا آزمایش دادی که مطمئن بشی کم خونی " +
//           "نداری؟");
//
//       strItems.add("حالا یکی دو روزم یه خرده بیشتر بخوابی طوری نمیشه! \uD83D\uDE0A");
//
//       strItems.add("سعی کن شب ها به موقع بخوابی تا صبح کسالت کمتری داشته باشی.");
//
//       strItems.add("خوابت به هم میریزه اینروزا؟ سعی کن به موقع بری تو رختخواب و قبل خواب مدیتیشن کنی.");
//
//       strItems.add("اگه اینروزا بیش از حد نیاز به خواب داری، با پزشک مشورت کن. شاید به مکمل و ویتامین نیاز داشته باشی.");
//
//       strItems.add("خواب آلودگی تا حدی از تجربه‌های طبیعی دوران قاعدگیه ");
//
//
//       bankStr.add(strItems[new Random().nextInt(8)]);
//     }
//   }
//
//
//
// }
//
//
