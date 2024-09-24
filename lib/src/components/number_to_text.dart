

class NumberToText{

  String Convert(int t) {
    int Val = t;
    if (Val < 20)
      return Yek(Val);
    else if (Val >= 20 && Val < 100)
      return Dah(Val);
    else if (Val  >= 100 && Val  < 1000 )
      return Sad(Val);
    else if (Val  >= 1000 && Val < 1000000 )
      return Hezar(Val);
    else
      return Melion(Val);
  }


  String Yek(int t)
  {
    List<String> a = ["صفر", "یک", "دو", "سه", "چهار", "پنج", "شش", "هفت", "هشت", "نه", "ده", "یازده", "دوازده", "سیزده", "چهارده", "پانزده", "شانزده", "هفده", "هجده", "نوزده"];
    return a[t];
  }

  String Dah(int t)
  {
    List<String> b = ["صفر", "ده", "بیست", "سی", "چهل", "پنجاه", "شصت", "هفتاد", "هشتاد", "نود"];
    if(t % 10 == 0)
      return b[(t/10).floor()];
    else
      return b[(t/10).floor()] + " و " + Yek(t%10);
  }

  String Sad(int t)
 {
   List<String> c  = ["صفر", "صد", "دویست", "سیصد", "چهارصد", "پانصد", "ششصد", "هفتصد", "هشتصد", "نهصد"];
   if (t % 10 == 0 && t % 100 == 0)
     return c[(t / 100).floor()];
   else if (t > ((t / 100) * 100) && t < ((t / 100) * 100 + 20))
     return c[(t / 100).floor()] + " و " + Yek(t% 100);
   else
     return c[(t / 100).floor()] + " و " + Dah(t % 100);
 }

  String Hezar(int t)
 {
   if(t % 1000 == 0)
     return Convert((t/1000).floor()) + " هزار";
   else
     return Convert((t/1000).floor()) + " هزار و " + Convert(t%1000);
 }

 String Melion(int t)
 {
   if(t % 1000000 == 0)
     return Convert((t/1000000).floor()) + " میلیون";
   else
     return Convert((t/1000000).floor()) + " میلیون و " + Convert(t%1000000);
 }

}