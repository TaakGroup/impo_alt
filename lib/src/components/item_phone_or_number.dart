class ItemsPhoneNumberOrPhone{

  String? title;
  String? icon;
  bool? selected = false;

  ItemsPhoneNumberOrPhone({this.title,this.icon,this.selected});


}

List<ItemsPhoneNumberOrPhone> itemsPhoneNumberOrPhone = [
  ItemsPhoneNumberOrPhone(
      title: 'شماره تلفن',
      icon: 'assets/images/ic_call.svg',
      selected: true
  ),
  ItemsPhoneNumberOrPhone(
      title: 'ایمیل',
      icon: 'assets/images/ic_email.svg',
      selected: false
  ),
];

int typeValue = 0;