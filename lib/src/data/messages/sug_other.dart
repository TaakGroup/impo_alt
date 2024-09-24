

import 'dart:convert';
import 'dart:math';

import 'package:impo/src/data/messages/sug_generator.dart';
import 'package:impo/src/models/circle_model.dart';

class SugOther{

  get(name,List<String> bankStr,currentDay,pmsStart,periodDay,CycleViewModel circleModel) {

    List other = circleModel.other != '' ? json.decode(circleModel.other!) : [];

    for (int i = 0; i < other.length; i++)
    {
      switch (other[i])
      {
        case 0:
          other0(name,bankStr,currentDay,pmsStart);
          break;
        case 1:
          other1(name,bankStr,currentDay,pmsStart);
          break;
        case 2:
          other2(name,bankStr,currentDay,pmsStart,periodDay);
          break;
        case 3:
          other3(name,bankStr,currentDay,pmsStart,periodDay);
          break;
      }
    }
  }

  void other0(name,List<String> bankStr,currentDay,pmsStart){
    if (currentDay >= pmsStart) {
      List<String> strItems =[];

      strItems.add("اگه داروی ضد افسردگی یا اضطراب مصرف میکنی، ممکنه نظم " +
          "پریودت به هم بخوره. با پزشکت دربارش صحبت کن \uD83D\uDE0A ");

      strItems.add("داروهای ضد افسردگی و اضطراب، میتونه روی قاعدگی تاثیر بذاره. پس اگه تغییر جدی در پریودت داشتی به پزشکت منتقل کن.");

      strItems.add("ایمپویی جان اگه زیر نظر روانپزشک داری دارو مصرف میکنی، لطفا بدون نظر متخصص تغییری در مصرفشون ایجاد نکن.");

      strItems.add("اگه اضطراب داری، مدیتیشن و نفس عمیق رو فراموش نکن ");

      strItems.add("ارتباط با روانشناس، نیاز همه ماست. نیازمون رو نادیده نگیریم.");

      bankStr.add(strItems[Random().nextInt(5)]);

    }
    else if (currentDay <= 2)
    {
      List<String> strItems =[];

      strItems.add("داروهای ضد افسردگی گاهی ممکنه خونریزی " +
          "و درد پریودت رو شدیدتر کنه. حواست به خودت باشه");

      strItems.add("داروهای ضد افسردگی و اضطراب، میتونه روی قاعدگی تاثیر بذاره. پس اگه تغییر جدی در پریودت داشتی به پزشکت منتقل کن.");

      strItems.add("اگه زیر نظر روانپزشک داری دارو مصرف میکنی، لطفا بدون نظر متخصص تغییری در مصرفشون ایجاد نکن.");

      strItems.add("اگه اضطراب داری، مدیتیشن و نفس عمیق رو فراموش نکن ");

      strItems.add("ارتباط با روانشناس، نیاز همه ماست. نیازمون رو نادیده نگیریم.");

      bankStr.add(strItems[Random().nextInt(5)]);

    }
  }

  void other1(name,List<String> bankStr,currentDay,pmsStart) {
    if (currentDay >= pmsStart) {
      List<String> strItems =[];

      strItems.add( "قرص های ضد بارداری میتونه نظم پریود رو تا حد زیادی به هم بریزه. " +
          "شاید لازم باشه به پزشک مراجعه کنی  \uD83D\uDE0A");

      strItems.add( "داروهای پیشگیری از بارداری، عوارض زیادی دارن. لطفا " +
          "مصرفشون رو کم کن و از روش های جایگزین و بهتر استفاده کن");

      strItems.add("استفاده طولانی مدت از قرص های ضد بارداری میتونه عوارض داشته باشه.");

      strItems.add("داروهای ضد بارداری میتونه نظم قاعدگی رو به هم بزنه. سعی کن بیش از حد و بدون مشورت￼با پزشک ازشون استفاده نکنی \uD83D\uDE0A");

      strItems.add("برای پیشگیری از بارداری، روش سالم و ایمنی رو انتخاب کن. مثل استفاده از کاندوم.");


      bankStr.add(strItems[new Random().nextInt(5)]);
    }
  }

  void other2(name,List<String> bankStr,currentDay,pmsStart,periodDay) {
    if (currentDay >= pmsStart) {
      List<String> strItems =[];

      strItems.add( "چون یائسگیت نزدیکه، ممکنه لکه بینی یا پریود نامنظم " +
          "رو تجربه کنی. حتما همین روزا با پزشک مشورت کن تا این روزا رو راحت تر بگذرونی");

      strItems.add( "چون به یائسگی نزدیکی، لازمه برنامه غذایی و سبک زندگیت رو " +
          "تا حدی تغییر بدی. دربارش مطالعه کن و یا با پزشک مشورت کن");

      strItems.add( "اگه داری به یائسگی نزدیک میشی، ممکنه گاهی دیر و زود پریود بشی و یا حجمخونریزیت تغییر کنه.");

      strItems.add("بهتره با پزشک در ارتباط باشی تا تجربه یائسگی رو بهتر مدیریت کنی \uD83D\uDE0A");

      strItems.add("نزدیک شدن به یائسگی میتونه کمی روح و روانتو به هم بریزه. لطفا با خودت مهربون تر باش \uD83D\uDE0A");

      strItems.add("یائسگی با تغییرات خلقی و روحی همراهه. با خودت مهربون تر باش.");

      strItems.add("اگه به یائسگی نزدیکی، برنامه غذاییت رو بهبود بده تا دچار پوکی استخوان نشی.");

      bankStr.add(strItems[new Random().nextInt(7)]);

    }
    else if (currentDay <= periodDay)
    {
      List<String> strItems =[];

      strItems.add( "نشانه های یائسگی فشار روحی پریود رو بیشتر میکنه. لطفا حواست " +
          "به خودت باشه و با خودت مهربون باش");

      strItems.add( "اگه داری به یائسگی نزدیک میشی، ممکنه گاهی دیر و زود پریود بشی و یا حجمخونریزیت تغییر کنه.");

      strItems.add("بهتره با پزشک در ارتباط باشی تا تجربه یائسگی رو بهتر مدیریت کنی \uD83D\uDE0A");

      strItems.add("نزدیک شدن به یائسگی میتونه کمی روح و روانتو به هم بریزه. لطفا با خودت مهربون تر باش \uD83D\uDE0A");

      strItems.add("یائسگی با تغییرات خلقی و روحی همراهه. با خودت مهربون تر باش.");

      strItems.add("اگه به یائسگی نزدیکی، برنامه غذاییت رو بهبود بده تا دچار پوکی استخوان نشی.");

      bankStr.add(strItems[new Random().nextInt(6)]);

    }
  }

  void other3(name,List<String> bankStr,currentDay,pmsStart,periodDay) {
    if (currentDay >= pmsStart) {
      List<String> strItems =[];

      strItems.add( "اگه تنبلی تخمدان داری، احتمال داره پریودت نامنظم بشه. عوارضش رو " +
          "جدی بگیر و حتما برای درمان اقدام کن");

      strItems.add("تنبلی تخمدان میتونه نظم قاعدگی رو به هم بزنه. اگه قاعدگی های نامنظم داری حتما با پزشک مشورت کن.");

      strItems.add( "اگه اضافه وزن داری، برای پیشگیری و مدیریت تنبلی تخمدان، وزنتو کم کن \uD83D\uDE0A");

      strItems.add("اگه نشانه های تنبلی تخمدان رو داری، زودتر به پزشکت سر بزن.");

      strItems.add("قاعدگی های نامنظم رو جدی بگیر.");

      bankStr.add(strItems[Random().nextInt(5)]);

    }
    else if (currentDay <= 2)
    {
      List<String> strItems =[];

      strItems.add( "تنبلی تخمدان، خونریزی قاعدگی رو شدیدتر میکنه. جدی " +
          "بگیرش!");

      strItems.add("تنبلی تخمدان میتونه نظم قاعدگی رو به هم بزنه. اگه قاعدگی های نامنظم داری حتما با پزشک مشورت کن.");

      strItems.add( "اگه اضافه وزن داری، برای پیشگیری و مدیریت تنبلی تخمدان، وزنتو کم کن \uD83D\uDE0A");

      strItems.add("اگه نشانه های تنبلی تخمدان رو داری، زودتر به پزشکت سر بزن.");

      strItems.add("قاعدگی های نامنظم رو جدی بگیر.");

      bankStr.add(strItems[Random().nextInt(5)]);

    }
    else if (currentDay == periodDay)
    {

      List<String> strItems =[];

      strItems.add( "تنبلی تخمدان احتمال ابتلا به سرطان رحم رو " +
          "زیاد میکنه. لطفا درمانش رو جدی بگیر");

      strItems.add("تنبلی تخمدان میتونه نظم قاعدگی رو به هم بزنه. اگه قاعدگی های نامنظم داری حتما با پزشک مشورت کن.");

      strItems.add( "اگه اضافه وزن داری، برای پیشگیری و مدیریت تنبلی تخمدان، وزنتو کم کن \uD83D\uDE0A");

      strItems.add("اگه نشانه های تنبلی تخمدان رو داری، زودتر به پزشکت سر بزن.");

      strItems.add("قاعدگی های نامنظم رو جدی بگیر.");

      bankStr.add(strItems[Random().nextInt(5)]);

    }

  }


}


