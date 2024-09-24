
class SubBannerModel {
  String? image;
  String? title;

  SubBannerModel({this.image, this.title});
}

 List<SubBannerModel> imgList = [
   SubBannerModel(
     image: 'assets/images/period_banner.webp',
     title: 'راحت گذروندن دوران پریود',
   ),
   SubBannerModel(
     image: 'assets/images/fert_banner.webp',
     title: 'برنامه ریزی برای پیشگیری یا اقدام به بارداری',
   ),
   SubBannerModel(
     image: 'assets/images/partner_banner.webp',
     title: 'افزایش صمیمیت و لذت در رابطه',
   ),
   SubBannerModel(
     image: 'assets/images/pregnancy_banner.webp',
     title: 'مراقبت هفته به هفته دوران بارداری و شیردهی',
   ),
   SubBannerModel(
     image: 'assets/images/reporting_banner.webp',
     title: 'گزارش‌گیری و تشخیص پریود نامنظم',
   ),
   SubBannerModel(
     image: 'assets/images/clinic_banner.webp',
     title: 'مشاوره‌های آنلاین با پزشکان متخصص',
   ),
   SubBannerModel(
     image: 'assets/images/calendar_pregnancy_banner.webp',
     title: 'محاسبه سن بارداری و روز زایمان',
   ),
];