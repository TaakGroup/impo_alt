
class PartnerSliderModel{
  String? image;
  String? title;
  String? subTitle;

  PartnerSliderModel({this.image,this.title,this.subTitle});

}

List<PartnerSliderModel> partnerSliderList = [
  PartnerSliderModel(
    image: 'assets/images/memory_game_partner_slider.webp',
    title: 'خاطره‌بازی با پارتنر',
    subTitle: 'یه آلبوم پر از خاطره‌های مشترک برای ثبت روزهای قشنگی که با هم گذروندید'
  ),
  PartnerSliderModel(
    image: 'assets/images/cycle_partner_slider.webp',
    title: 'دیدن چرخه همدیگه',
      subTitle: 'پارتنرت تاریخ پریود و وضعیت بیوریتمت رو می‌بینه و تو هم می‌تونی وضعیت بیورتم پارتنرت رو ببینی'
  ),
  PartnerSliderModel(
    image: 'assets/images/send_message_partner_slider.webp',
    title: 'یه پیام‌رسان خصوصی',
      subTitle: 'تو قسمت پیام به همدل می‌تونید پیام‌رسان دونفره مخصوص خودتون رو داشته باشید'
  ),
  PartnerSliderModel(
    image: 'assets/images/pregnancy_partner_slider.webp',
    title: 'برنامه‌ریزی برای بارداری',
      subTitle: 'با توجه به پیش‌بینی دوران باروری می‌تونید برای پیشگیری از بارداری یا اقدام به بارداری برنامه‌ریزی کنید'
  ),
];
