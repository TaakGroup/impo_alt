import 'package:taakitecture/taakitecture.dart';

import '../../../../core/app/constans/api_paths.dart';
import '../models/index_model.dart';

class IndexDatasource extends BaseRemoteDatasource {
  IndexDatasource(IClient client)
      : super(
          client: client,
          model: IndexModel(),
          path: ApiPaths.index,
        );

  // @override
  // Future<IndexModel> find([String? params]) {
  //   return Future.value(
  //     IndexModel().fromJson(
  //       {
  //         "date": "امروز . 4 خرداد",
  //         "backgroundColor": "0xFFE9F6F5",
  //         "actions": [
  //           // {
  //           //   'type': 0,
  //           //   'data': {
  //           //     'title': 'آیا طبق پیش بینی ایمپو، دیروز پریود شدی؟',
  //           //     'submitText': 'تایید',
  //           //     'items': [
  //           //       {
  //           //         'title': 'آره دیروز پریود شدم',
  //           //         'url': 'some/url/1',
  //           //       },
  //           //       {
  //           //         'title': 'نه هنوز پریود نشدم',
  //           //         'pageType': 0,
  //           //       },
  //           //       {
  //           //         'title': 'تو یه تاریخ دیگه پریود شدم',
  //           //         'pageType': 1,
  //           //       },
  //           //     ]
  //           //   },
  //           // },
  //           // {
  //           //   'type': 1,
  //           //   'data': {
  //           //     'object': 'https://storage.googleapis.com/cms-storage-bucket/847ae81f5430402216fd.svg',
  //           //     'title': 'تایتل بزرگ',
  //           //     'buttonText': 'ورود به صفحه اشتراک',
  //           //     'description': 'مریم خانم جان این روزا ممکنه یکم اذیت بشی چون میدونی دیگه پی ام اس شرو میشه و مشکلات عدیده میاد سراغت، قوربونت برم یادت نره',
  //           //     'pageType': 0,
  //           //     'url': 'some/url/1',
  //           //     'isDismissible': true
  //           //   },
  //           // }
  //         ],
  //         "wigets": [
  //           {
  //             "order": 1,
  //             "type": 0,
  //             "data": {
  //               "backgroundColor": "0xFFC8F7F3",
  //               "foregroundColor": "0xFF2DD4BF",
  //               "leading": "احتمال بارداری: متوسط",
  //               "textColor": "0xFF2F4341",
  //               "button": [
  //                 // {
  //                 //   'backgroundColor': '0xFF2DD4BF',
  //                 //   'foregroundColor': '0xFFC8F7F3',
  //                 //   'action': {
  //                 //     'actionType': 3,
  //                 //     'nextStep': {
  //                 //       'type': 2,
  //                 //       'data': {
  //                 //         'title': 'برو درسته',
  //                 //         'description': ' بزن روش!!!!!!!!!!',
  //                 //         'first': {
  //                 //           'backgroundColor': '0xFF2DD4BF',
  //                 //           'foregroundColor': '0xFFC8F7F3',
  //                 //           'text': 'بمال روش',
  //                 //           'action': {
  //                 //             'actionType': 0,
  //                 //           }
  //                 //         },
  //                 //         'second': {
  //                 //           'backgroundColor': '0xFF2DD4BF',
  //                 //           'foregroundColor': '0xFFC8F7F3',
  //                 //           'text': 'بمال روش',
  //                 //           'action': {
  //                 //             'actionType': 0,
  //                 //           }
  //                 //         }
  //                 //       }
  //                 //     }
  //                 //   }
  //                 // }
  //               ],
  //               "title": "2",
  //               "description": "تست ویجت چرخه",
  //             }
  //           },
  //           {
  //             "order": 2,
  //             "type": 1,
  //             "data": {
  //               "list": [
  //                 {
  //                   "id": "67220203-00e3-46b3-b1a4-0224068c3890",
  //                   "events": [
  //                     {"type": 2, "url": "https://c328642.parspack.net/c328642/stories/Exercise%21/content.webp"}
  //                   ],
  //                   "isViewed": true,
  //                   "coverImage": "https://c328642.parspack.net/c328642/stories/Exercise%21/cover.png",
  //                   "text": "ورزش کن!",
  //                   "time": 10000,
  //                   "duration": 20000
  //                 },
  //                 {
  //                   "id": "9f52c56c-ea79-460c-827d-668ecce85779",
  //                   "events": [
  //                     {"type": 2, "url": "https://c328642.parspack.net/c328642/stories/periodpain/content.webp"}
  //                   ],
  //                   "isViewed": false,
  //                   "coverImage": "https://c328642.parspack.net/c328642/stories/periodpain/cover.png",
  //                   "text": "درد پریود",
  //                   "time": 10000,
  //                   "duration": 20000
  //                 },
  //                 {
  //                   "id": "4a4d67c0-6fa5-4709-929f-fdbae5f6a695",
  //                   "events": [
  //                     {
  //                       "type": 2,
  //                       "url": "https://c328642.parspack.net/c328642/stories/periodbloodcolor/content.webp",
  //                     }
  //                   ],
  //                   "isViewed": false,
  //                   "coverImage": "https://c328642.parspack.net/c328642/stories/periodbloodcolor/cover.png",
  //                   "text": "رنگ خون پریود ",
  //                   "time": 10000,
  //                   "duration": 20000
  //                 },
  //                 {
  //                   "id": "751ca913-9539-4d64-a1a8-6f3b83b0cf42",
  //                   "events": [
  //                     {"type": 2, "url": "https://c328642.parspack.net/c328642/stories/storyartichel/usecup/usecup.webp"}
  //                   ],
  //                   "isViewed": true,
  //                   "coverImage": "https://c328642.parspack.net/c328642/stories/storyartichel/usecup/usecup.png",
  //                   "text": "مراحل استفاده از کاپ",
  //                   "time": 10000,
  //                   "duration": 20000
  //                 }
  //               ],
  //               "title": "استوری",
  //               "description": "تست استوری"
  //             }
  //           },
  //           {
  //             "order": 6,
  //             "type": 5,
  //             "data": {
  //               "list": [
  //                 {
  //                   "icon": "https://www.svgrepo.com/show/532032/cloud-moon.svg",
  //                   "title": "پریود بعدی",
  //                   "backgroundColor": "0xFFFFEFEF",
  //                   "text": "5 اردیبهشت تا 3 خرداد",
  //                   "trailing": "27 روز"
  //                 },
  //                 {
  //                   "icon": "https://www.svgrepo.com/show/532032/cloud-moon.svg",
  //                   "title": "غیرطبیعی",
  //                   "backgroundColor": "0xFFFFEFEF",
  //                   "text": "5 اردیبهشت تا 3 خرداد",
  //                   "trailing": "87 روز"
  //                 },
  //                 {
  //                   "icon": "https://www.svgrepo.com/show/532032/cloud-moon.svg",
  //                   "title": "نرمال",
  //                   "backgroundColor": "0xFFFFEFEF",
  //                   "text": "5 اردیبهشت تا 3 خرداد",
  //                   "trailing": "27 روز"
  //                 },
  //               ],
  //               "title": "گزارش چرخه هات",
  //               "description": "در زیر گزارش 3 دوره قبلت رو میتونی ببینی تا بفهمی چرخه های قاعدگیت دچار اختلال مادرزادی هست یا نه",
  //               "buttonText": "مشاهده گزارش گیری",
  //             }
  //           },
  //           {
  //             "order": 3,
  //             "type": 2,
  //             "data": {
  //               "list": [
  //                 {
  //                   "id": "600f15c6e1669acbc06fc648",
  //                   "text": "بهتره این روزها که خون‌ریزی بیشتری داری به خودت استراحت بیشتری بدی و با خودت مهربون‌تر باشی",
  //                   "title": null,
  //                   "internalLink": null,
  //                   "externalLink": ""
  //                 },
  //                 {
  //                   "id": "600f15ebe1669acbc06fc649",
  //                   "text": "اگه دل درد داری کیسه آب گرم بهترین گزینه برای تسکین دردته!",
  //                   "title": null,
  //                   "internalLink": null,
  //                   "externalLink": ""
  //                 }
  //               ],
  //               "title": "امروز یادت باشه",
  //               "description": ""
  //             }
  //           },
  //           // TODOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOO
  //           {
  //             "type": 9,
  //             "data": {
  //               "title": '291 روز مانده تا پایان اشتراک',
  //               'package': {
  //                 "id" : 'id',
  //                 "realValue" : 0,
  //                 "realValueText" : 'realValueText',
  //                 "value" : 0,
  //                 "valueText" : 'valueText',
  //                 "unit" : 'unit',
  //                 "text" : 'text',
  //                 "isFree" : true,
  //                 "isSpecific" : true,
  //                 "specificText" : 'specificText',
  //                 "inAppPurchase" : true,
  //                 "discountText" : 'discountText',
  //                 "discount" : 0,
  //                 "vatText" : 'vatText',
  //                 "vat" : 0,
  //                 "totalPayText" : 'totalPayText',
  //                 "totalPay" : 0,
  //                 "payButtonText" : 'payButtonText',
  //                 "viewId" : 'viewId',
  //               },
  //               "headlineButton": {
  //                 'backgroundColor': '0xFF2DD4BF',
  //                 'foregroundColor': '0xFFC8F7F3',
  //                 'text': 'تمدید اشتراک',
  //                 'action' : {
  //                   'actionType': 0,
  //                 }
  //               },
  //               "submitButton": {
  //                 'backgroundColor': '0xFF2DD4BF',
  //                 'foregroundColor': '0xFFC8F7F3',
  //                 'text': 'ورود به صفحه پرداخت',
  //                 'action' : {
  //                   'actionType': 0,
  //                 }
  //               },
  //             },
  //           },
  //           {
  //             "order": 4,
  //             "type": 3,
  //             "data": {
  //               "items": [
  //                 {
  //                   "icon": "https://www.svgrepo.com/show/532032/cloud-moon.svg",
  //                   "title": "پریود بعدی",
  //                   "backgroundColor": "0xFFFFEFEF",
  //                   "trailingUp": "21 تیر",
  //                   "trailingDown": "8 روز دیگه"
  //                 },
  //                 {
  //                   "icon": "https://www.svgrepo.com/show/532032/cloud-moon.svg",
  //                   "title": "تخمک گذاری بعدی",
  //                   "backgroundColor": "0xFFF1FCFB",
  //                   "trailingUp": "3 مرداد",
  //                   "trailingDown": "12 روز دیگه"
  //                 },
  //                 {
  //                   "icon": "https://www.svgrepo.com/show/532032/cloud-moon.svg",
  //                   "title": "PMS بعدی",
  //                   "backgroundColor": "0xFFF7F5FF",
  //                   "trailingUp": "3 مرداد",
  //                   "trailingDown": "12 روز دیگه"
  //                 }
  //               ],
  //               "title": "تاریخ های آینده",
  //               "description": ""
  //             }
  //           },
  //           {
  //             "order": 5,
  //             "type": 4,
  //             "data": {
  //               "items": [
  //                 {
  //                   "image":
  //                       "https://impo.app/_next/image?url=https%3A%2F%2Fweareimpo.ir%2Fsupport%2Farticle%2Fpanel%2Fimage%2F6f2669533ae44cbeb16bbe6c1bb3c5af.webp&w=1080&q=75",
  //                   "title": "خونریزی لانه گزینی چیست؟",
  //                   "link": "https://impo.app/bleeding-nesting",
  //                 },
  //                 {
  //                   "image":
  //                       "https://impo.app/_next/image?url=https%3A%2F%2Fweareimpo.ir%2Fsupport%2Farticle%2Fpanel%2Fimage%2Fae0ccda401154e29bd6bba4e6ab7ecc6.jpg&w=1080&q=75",
  //                   "title": "خونریزی لانه",
  //                   "link": "https://impo.app/bleeding-nesting",
  //                 },
  //                 {
  //                   "image":
  //                       "https://impo.app/_next/image?url=https%3A%2F%2Fweareimpo.ir%2Fsupport%2Farticle%2Fpanel%2Fimage%2F64954205f8a141379236e495d066f96f.webp&w=1080&q=75",
  //                   "title": "اندازه نرمال آلت تناسلی، نحوه اندازه‌گیری و روش افزایش سایز",
  //                   "link": "https://impo.app/bleeding-nesting",
  //                 },
  //               ],
  //               "title": "مقاله های دوره باروری",
  //               "description": ""
  //             }
  //           },
  //           {
  //             "type": 7,
  //             "data": {
  //               "title": "هفته پنجم بارداری",
  //               "description": "(قد و وزن جنین)",
  //               "image": "https://upload.wikimedia.org/wikipedia/commons/thumb/7/79/Flutter_logo.svg/2048px-Flutter_logo.svg.png",
  //               'tiles': [
  //                 {
  //                   "name": "قد:",
  //                   "text": "3 سانتی‌متر",
  //                   "icon": 'https://www.svgrepo.com/show/532034/cloud-arrow-down.svg',
  //                 },
  //                 {
  //                   "name": "وزن:",
  //                   "text": "4 گرم",
  //                   "icon": 'https://www.svgrepo.com/show/532034/cloud-arrow-down.svg',
  //                 },
  //               ],
  //               "trailing": 'این هفته کوچولوی قشنگت اندازه یک هندونه شده.',
  //               "trailingIcon":
  //                   'https://static.wikia.nocookie.net/minecraft_gamepedia/images/f/f2/Melon_Slice_JE2_BE2.png/revision/latest/thumbnail/width/360/height/360?cb=20190505051737',
  //             },
  //           },
  //           {
  //             "type": 6,
  //             "data": {
  //               "title": "گزارش چرخه هات",
  //               "description": "تا آماده‌شدن گزارش قاعدگی شما 28 روز مانده است.",
  //               "image": "https://gratisography.com/wp-content/uploads/2024/01/gratisography-cyber-kitty-800x525.jpg",
  //               "percent": 50,
  //               "days": 28,
  //             },
  //           }
  //         ]
  //       },
  //     ),
  //   );
  // }
}
