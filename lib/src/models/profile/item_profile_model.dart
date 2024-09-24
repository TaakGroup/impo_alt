

class ItemProfileModel {

  String? title;
  String? icon;
  bool? selected;

 ItemProfileModel({this.title,this.icon,this.selected});




}

List<ItemProfileModel> dummyData = [

  // new ItemProfileModel(
  //   title: 'پشتیبان گیری',
  //   icon: 'assets/images/backUp.png',
  //   selected: false
  //
  // ),
  new ItemProfileModel(
      title: 'من و ایمپو',
      icon: 'assets/images/ic_profile_myImpo.svg',
      selected: false

  ),
  // new ItemProfileModel(
  //     title: 'رمز عبور',
  //     icon: 'assets/images/pass_icon.png',
  //     selected: false
  //
  // ),
  // new ItemProfileModel(
  //     title: 'یادآورهای روزانه',
  //     icon: 'assets/images/notif_icon.png',
  //     selected: false
  //
  // ),
  new ItemProfileModel(
      title: 'گزارش قاعدگی من',
      icon: 'assets/images/ic_profile_reporting.svg',
      selected: false

  ),
  new ItemProfileModel(
      title: 'ورود به فاز بارداری',
      icon: 'assets/images/ic_profile_pregnancy.png',
      selected: false

  ),
  new ItemProfileModel(
      title: 'همدل من',
      icon: 'assets/images/ic_profile_partner.svg',
      selected: false

  ),
  ItemProfileModel(
      title: 'معرفی به دوستان',
      icon: 'assets/images/ic_profile_enter_face_code.png',
      selected: false

  ),
  new ItemProfileModel(
      title: 'پشتیبانی',
      icon: 'assets/images/ic_profile_call.png',
      selected: false
  ),
  new ItemProfileModel(
      title: 'ارتباط با ایمپو',
      icon: 'assets/images/ic_profile_support.svg',
      selected: false

  ),
  // new ItemProfileModel(
  //     title: 'همدل من',
  //     icon: 'assets/images/support.png',
  //     selected: false
  //
  // ),
  new ItemProfileModel(
      title: 'درباره ما',
      icon: 'assets/images/ic_profile_about.svg',
      selected: false

  ),
  new ItemProfileModel(
      title: 'بروز‌رسانی ایمپو',
      icon: 'assets/images/ic_profile_update.png',
      selected: false

  ),
  /// ItemProfileModel(
  ///   title: 'امتیاز به ایمپو',
  ///   icon: 'assets/images/ic_profile_rate.png',
  ///   selected: false
  /// )

];