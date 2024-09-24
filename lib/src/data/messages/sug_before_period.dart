

import 'dart:convert';
import 'dart:math';

import 'package:impo/src/data/messages/sug_generator.dart';
import 'package:impo/src/models/circle_model.dart';

class SugBeforePeriod{

  get(name,List<String> bankStr,currentDay,maxDay,periodDay,pmsStart,CycleViewModel circleModel) {

    List before = circleModel.before != '' ? json.decode(circleModel.before!) : [];

    for (int i = 0; i < before.length; i++)
    {
      switch (before[i])
      {
        case 0:
          before0(name,bankStr,currentDay,periodDay,pmsStart);
          break;
        case 1:
          before1(name,bankStr,currentDay,maxDay);
          break;
        case 2:
          before2(name,bankStr,currentDay,maxDay);
          break;
        case 3:
          before3(name,bankStr,currentDay,periodDay);
          break;
      }
    }
  }

  void before0(name,List<String> bankStr,currentDay,periodDay,pmsStart){
    if (currentDay >= pmsStart) {
      List<String> strItems =[];
      // strItems.add(SugGenerator().randomNameGET(name) + " امروز احتمالا دردهای شکمی رو تجربه " + "میکنی.\uD83D\uDE41 استفاده از کیسه آب گرم، و استراحت " + "میتونه شرایط رو بهتر کنه \uD83D\uDE0D");
      strItems.add("کیسه آب گرم میتونه دل دردت رو کمتر کنه");

      strItems.add("امروز احتمالا دچار دردهای شکمی میشی، " +
          "پس سعی کن از خوردنی های کافئین دار مثل چای " +
          "و قهوه و نوشابه کمتر استفاده کنی، دوش آب گرم " +
          "هم میتونه بهت کمک کنه");

      strItems.add( "نرمش و پیاده روی، انقباض های بدنی رو کمتر میکنه. \uD83D\uDCAA");

      strItems.add("حوله گرم و ماساژ زیر شکم میتونه دل درد رو کمتر کنه \uD83D\uDE0A");

      strItems.add("اینروزا بیشتر حواست به برنامه غذاییت باشه، تا درد کمتری رو تجربه کنی");

      strItems.add("سعی کن بدنتو گرم نگه داری تا دردهات کمتر بشن.");

//    if (periodDay >= 3 || currentDay <= 2) {
      bankStr.add(strItems[new Random().nextInt(6)]);
//      }
    }
  }


  void before1(name,List<String> bankStr,currentDay,maxDay) {
    if (currentDay == 1 || currentDay >= (maxDay-3)) {
      List<String> strItems =[];
      strItems.add("سعی کن امروز بیشتر آب بخوری تا سردرد " +
          "نشی. " +
          "مصرف ویتامین ها و مکمل ها مثلا ویتامین E" +
          "میتونه سردردت رو کم کنه");
      strItems.add("اگه نگران سردردت هستی، سعی کن آب " +
          "بیشتری بخوری. این روزا بدنت به ویتامین ها و " +
          " مکمل های بیشتری هم نیاز داره! \uD83D\uDC8A");

      strItems.add("برنامه خوابت رو تنظیم کن که " +
          "سردرد، کمتر بیاد سراغت!");

      strItems.add("زمان هایی رو در طول روز، چشماتو ببند و به ذهنت استراحت بده.");

      strItems.add("اگه سردردهای شدید و طولانی رو تجربه میکنی، بهتره با پزشکت درمیون بذاری.");

      strItems.add("سردرد میتونه با مصرف مایعات کمی اروم تر بشه \uD83D\uDE0A");

      strItems.add("سردردهای شدید میتونه نشونه کم خونی باشه. چکاپ یادت نره!");

      strItems.add("از سر و صدا و شلوغی کمی فاصله بگیر تا کمتر دچار سردرد بشی.");

      strItems.add("حواست باشه به اندازه کافی آب و مایعات بنوشی ");


      bankStr.add(strItems[new Random().nextInt(9)]);
    }
  }


  void before2(name,List<String> bankStr,currentDay,maxDay) {
    if (currentDay >= maxDay - 3) {
      List<String> strItems =[];
      strItems.add("حساسیت و درد سینه این روزهات بخاطر " +
          "تغییرات هورمونیه و طبیعیه. فقط سعی کن لباسهای " +
          "آزادتر و راحت تر بپوشی.");

      strItems.add("اگه حساسیت و درد سینه اذیتت " +
          "میکنه، از دوش یا کمپرس آب گرم استفاده کن.");

      strItems.add("کمتر از سوتین های تنگ استفاده کن تا درد کمتری در ناحیه سینه داشته باشی.");

      strItems.add("دوست عزیزم دوش آب گرم و لباس راحت، حساسیت و درد سینه رو کمتر میکنه.");

      strItems.add("درد سینه در این روزها طبیعیه. با بدنت مهربون باش و باهاش کنار بیا ");

      strItems.add("کمی به خودت استراحت بده این روزا");

      bankStr.add(strItems[new Random().nextInt(6)]);
    }
  }

  void before3(name,List<String> bankStr,currentDay,periodDay) {
    if (currentDay <= 3) {
      List<String> strItems =[];
      strItems.add("بدن درد و کوفتگی این روزا رو می‌تونی با دوش " +
          "آب گرم و ورزش سبک التیام بدی");

      strItems.add("ماساژ، استراحت، یوگا و حمام آب گرم میتونه " +
          "کوفتگی اینروزا رو بشوره ببره \uD83D\uDE0E");

      if (periodDay >= 3 || currentDay <= 2)
        bankStr.add(strItems[new Random().nextInt(2)]);
    }
  }


}

//  private static void ment2(List<String> BankStr, Points_Item item)
//  {
//    if (item.getCurrentDay() >= (item.getMaxDays()-3)) {
//      String[] strItems = new String[]{ "میدونی " + RandomName.GET() + "! تغییرات هورمونی میتونه باعث " +
//          "نگرانی و دلشوره بشه. به خودت یادآوری کن قرار " +
//          "نیست اتفاق بدی بیفته و احساسات این روزات " +
//          "موقتیه. \uD83D\uDE0E", RandomName.GET() + " کارهای جدید و گفتگوهای جدی رو این " +
//    "روزا شروع نکن. ممکنه اضطرابت رو بیشتر کنه.", RandomName.GET() + " یوگا، مدیتیشن، پیاده روی و گفتگو می " +
//  "تونه اضطراب این روزا رو کمتر کنه! یکیشو امتحان " +
//  "کن" };
//
//  BankStr.add(strItems[new Random().nextInt(3)]);
//  }
//  }
//  private static void ment3(List<String> BankStr, Points_Item item)
//  {
//    if (item.getCurrentDay() >= (item.getMaxDays()-2) || item.getCurrentDay() <= 2) {
//      String[] strItems = new String[]{RandomName.GET() + " میفهمم که دلت میخواد گریه کنی یا " +
//          "احساس نا امیدی داری! درموردش صحبت کن و به " +
//          "خودت فرصت بده که بگذره.", RandomName.GET() + " قاعدگی و تغییرات هورمونی گاهی باعث میشه فکر " +
//    "کنیم همه درها بسته شده و همه چیز ناامید کننده س! " +
//    "یادت باشه چند روز دیگه همه چی عوض میشه.", RandomName.GET() + " سعی کن این روزا یه خرده وقتتو صرف " +
//  "کارهایی کنی که علاقه داری، تا انرژی بگیری. \uD83D\uDE09"};
//
//  BankStr.add(strItems[new Random().nextInt(3)]);
//  }
//  }
//
//  private static void ment4(List<String> BankStr, Points_Item item)
//  {
//    if (item.getCurrentDay() >= (item.getMaxDays()-2) || item.getCurrentDay() <= 2) {
//      String[] strItems = new String[]{RandomName.GET() + " اگه از من بپرسی، میگم همین امروز نیم ساعت با " +
//          "خودت خلوت کن. یک مدیتیشن حسابی میتونه شارژت " +
//          "کنه.", RandomName.GET() + " درمورد احساس خشمی که اینروزا تجربه میکنی، با " +
//    "اطرافیانت صحبت کن \uD83D\uDE44 " };
//
//    BankStr.add(strItems[new Random().nextInt(2)]);
//  }
//  }
//
//  private static void ment5(List<String> BankStr, Points_Item item)
//  {
//    if (item.getCurrentDay() >= (item.getMaxDays()-2) || item.getCurrentDay() <= 2) {
//      String[] strItems = new String[]{RandomName.GET() + " این روزا به خودت و اطرافیانت یادآوری " +
//          "کن که نیاز به صبر و محبت بیشتری داری .", RandomName.GET() +" سعی کن این روزا زیاد وارد بحث نشی که " +
//    "ناراحتی رو تجربه نکنی", RandomName.GET() + " تو خیلی توانمند و باهوشی! فقط این " +
//  "روزا تمرکزت اومده پایین. پس از خودت تکالیف سخت " +
//  "نخواه!"};
//
//  BankStr.add(strItems[new Random().nextInt(3)]);
//  }
//  }
//
//  private static void ment6(List<String> BankStr, Points_Item item)
//  {
//    if (item.getCurrentDay() >= (item.getMaxDays()-2)) {
//      String[] strItems = new String[]{RandomName.GET() + " پریودت نزدیکه. پیشنهاد میکنم بیشتر با " +
//          "خودت خلوت کنی.", RandomName.GET() +"تنهایی و آرامش میتونه حالتو بهتر کنه. " +
//    "واسه خودت وقت بذار", RandomName.GET() + "درسته این روزا نیاز به تنهایی داری، " +
//  "اما حواست باشه از اهداف مهمت عقب نمونی!"};
//
//  BankStr.add(strItems[new Random().nextInt(3)]);
//  }
//  }
//
//  private static void ment7(List<String> BankStr, Points_Item item)
//  {
//    if (item.getCurrentDay() >= (item.getMaxDays()-3)) {
//      String[] strItems = new String[]{RandomName.GET() + " طبیعیه که میل جنسیت کم شده باشه. " +
//          "درموردش با همسرت (همدلت) صحبت کن و ازش " +
//          "بخواه درکت کنه.", RandomName.GET() +" ممکنه این روزا رابطه جنسیت خیلی " +
//    "موفق و مطلوب نباشه. خودتو سرزنش نکن.", RandomName.GET() + "، اگه تا حالا درمورد میل جنسیت با همسرت " +
//  "صحبت نکردی، زودتر تجربه ش کن!"};
//
//  BankStr.add(strItems[new Random().nextInt(3)]);
//  }
//  }

