
class AboutIc {

  String? icon;
  String? url;
  bool isSelected;

  AboutIc({this.icon,this.isSelected = false,this.url});

}


 List<AboutIc> aboutIcons = [

   AboutIc(
     icon: 'assets/images/browser.svg',
     url: 'https://impo.app',
     isSelected: false,
   ),
   AboutIc(
     icon: 'assets/images/telegram.svg',
     url: 'https://t.me/impo_app',
     isSelected: false,
   ),
   AboutIc(
     icon: 'assets/images/twitter.svg',
     url: 'https://twitter.com/impoapp/',
     isSelected: false,
   ),
   AboutIc(
     icon: 'assets/images/insta.svg',
     url: 'https://www.instagram.com/impo.app/',
     isSelected: false,
   ),

 ];