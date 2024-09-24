class ApiPaths {
  static String auth = '/customerAccount/status';
  static String forgotAuth = '/customerAccount/getIdentity';
  static String setIdentity = '/customerAccount/setIdentity';
  static String otp = '/customerAccount/ValidateIdentity';
  static String forgotOtp = '/customerAccount/Validate';
  static String login = '/customerAccount/loginv3';
  static String register = '/CustomerAccount/v2/Register';
  static String forgotPassword = '/customerAccount/forgot';
  static String allData = '/info/allDatav5';
  static String generalInfo = '/info/generalInfov3';
  static String alram = '/date/alram';

  //Woman
  static String questions = '/woman/account/questions';
  static String createPartner = '/partner/create';
  static String subscription = '/info/subscribtions_v5';
  static String directSubscriptions = '/financial/subscribtiondiscount';
  static String freeSubscription = '/info/subscribtions/free';

  static const info = '/api/v1/info';
  static const calendar = '/api/v1/calendar';
  static const editCalendar = '/api/v1/calendar/edit';
  static const note = '/date/note';
  static const profile = '/api/v1/profile';
  static const cycleSetting = '/api/v1/profile/cycle';
  static const cycleEnable = '/api/dashboard/cycle/enable';
  static const devices = '/api/v1/profile/devices';
  static const transaction = '/api/v1/profile/transactions';
  static const invite = '/api/v1/profile/invite';
  static const reminder = '/api/v1/reminder';
  static const signs = '/api/v1/symptoms';
  static const report = '/api/v1/report';
  static var articles = '/info/posts';
  static var searchArticle = '/api/v1/articles/search';
  static var articleCategory = '/api/v1/articles/categories';
  static const pregnancy = '/api/v1/pregnancy';
  static var support = '/info/support';

  static var shareExperience = '/api/v1/shareExperience';

  static String token = '/api/v1/firebaseToken';

  static var clinic = '/advice/newclinicv1';
  static var clinicInfo = '/advice/ticketInfo';
  static var clinicPayment = '/advice/new';
  static var clinicDiscount = '/advice/applyDiscount';
  static var doctorProfile = '/advice/drInfo';
  static var clinicHistory = '/advice/tickets';
  static var file = '/file/private';
  static var filePrivate = '/man/private';
  static var chat = '/advice/ticket';
  static var clinicRate = '/advice/ticket';

  static var memory = '/memory';

  static var challenge = '/challenge';
  static var dailyChallenge = '/challenge/form';

  static var partnerMessenger = '/message';

  static var unpairPartner = '/info/unpair';

  static var partnerDistance = '/partner/type';

  static var partnerInfo = '/partner';

  static var index = '/wigets';

  static var story = '/story';

  static var editCycle = '/';
}
