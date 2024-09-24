



class ItemMyImpoModel {

  String? title;
  String? icon;
  bool? selected;

  ItemMyImpoModel({this.title,this.icon,this.selected});




}

List<ItemMyImpoModel> itemsMyImpo = [
  ItemMyImpoModel(
      title: 'اطلاعات کاربری',
      icon: 'assets/images/ic_myimpo_account.svg',
      selected: false

  ),
  ItemMyImpoModel(
      title: 'رمز قفل',
      icon: 'assets/images/ic_myimpo_pass.svg',
      selected: false

  ),
  ItemMyImpoModel(
      title: 'نوع تقویم',
      icon: 'assets/images/ic_myimpo_calanderType.svg',
      selected: false

  ),
  ItemMyImpoModel(
      title: 'وضعیت نوتیفای',
      icon: 'assets/images/ic_myimpo_pass.svg',
      selected: false

  ),

  ItemMyImpoModel(
      title: 'طول دوره',
      icon: 'assets/images/ic_myimpo_cycle.svg',
      selected: false

  ),

  ItemMyImpoModel(
      title: 'طول پریود',
      icon: 'assets/images/ic_myimpo_period.svg',
      selected: false

  ),

  ItemMyImpoModel(
      title: '',
      icon: 'assets/images/ic_myimpo_sub.svg',
      selected: false

  ),

];