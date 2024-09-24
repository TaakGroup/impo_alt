// ignore_for_file: non_constant_identifier_names, duplicate_ignore

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';


class AnalyticsHelper {
  bool _activateErrorLogs = true;
  bool _activateEnableTriggerLogs = true;
  bool _justShowSuccessLogs = false;

  bool isFirebaseInitialized() {
    return Firebase.apps.length != 0;
  }

  void log(String eventName, {bool remainEventActive = true, Map<String, dynamic>? parameters}) {
    try {
      if (!isFirebaseInitialized()) {
        errorLog('Analytics log rejected, because firebase service not initialized!');
        return;
      }
      // if (Api.baseUrlIndex != 0) {
      //   errorLog('Analytics log rejected, because base url is not server!');
      //   return;
      // }

      AnalyticsEvent? event = AnalyticsEvents().map[eventName]!;
      if (event == null) {
        errorLog('$eventName\'s log rejected, because event\'s name not found!');
        return;
      }
      if (event.enableTrigger == false) {
        errorLog('$eventName\'s log rejected, because event trigger is disabled yet!');
        return;
      }

      //main log method
      FirebaseAnalytics.instance.logEvent(name: eventName, parameters: parameters);
      debugPrint('*** => ANALYTICS[SUCCESS](log) => $eventName logged!');

      if (!remainEventActive) {
        event.enableTrigger = false;
      }
      return;
    } catch (e) {
      print(e);
      errorLog('$eventName\'s log failed because something went wrong!');
    }
  }

  void enableEventsList(List<String> eventsNames) {
    eventsNames.forEach((eventsName) {
      if (AnalyticsEvents().map[eventsName] != null) {
        AnalyticsEvents().map[eventsName]!.enableTrigger = true;
        if (_activateEnableTriggerLogs && !_justShowSuccessLogs) {
          debugPrint(
              '*** => ANALYTICS[SUCCESS](trigger activating) => $eventsName trigger enabled!');
        }
      }
    });
  }

  void enableAllEvents() {
    AnalyticsEvents().map.forEach((key, event) {
      event.enableTrigger = true;
      if (_activateEnableTriggerLogs && !_justShowSuccessLogs) {
        debugPrint('*** => ANALYTICS[SUCCESS](trigger activating) => all events triggers enabled!');
      }
    });
  }

  void errorLog(String message) {
    if (_activateErrorLogs && !_justShowSuccessLogs)
      debugPrint('*** => ANALYTICS[REJECTED](log) => $message');
  }
}

class AnalyticsEvent {
  final String? title;
  bool enableTrigger = true;

  AnalyticsEvent({this.title});
}


// ignore: duplicate_ignore
class AnalyticsEvents {
  static final AnalyticsEvents _instance = AnalyticsEvents._internal();

  factory AnalyticsEvents() {
    return _instance;
  }

  static  String setTitleName(String whichPage, String whichItem, String uiName, String actionName, [String? additionalDefinition]) {
    String additionalTag = additionalDefinition != null ? '_$additionalDefinition' : '';
    return '$whichPage\_$whichItem $uiName\_$actionName$additionalTag'.replaceAll(' ', '');
  }

  AnalyticsEvents._internal();
  // Map<String, AnalyticsEvent> map;


  Map<String, AnalyticsEvent> map = {
    EnterNumberPg_Phone_Btn_Clk:AnalyticsEvent(title:EnterNumberPg_Phone_Btn_Clk),
    EnterNumberPg_Email_Btn_Clk:AnalyticsEvent(title:EnterNumberPg_Email_Btn_Clk),
    EnterNumberPg_Cont_Btn_Clk:AnalyticsEvent(title:EnterNumberPg_Cont_Btn_Clk),
    EnterNumberPg_Privacy_Text_Clk:AnalyticsEvent(title:EnterNumberPg_Privacy_Text_Clk),
    EnterNumberPg_Back_NavBar_Clk:AnalyticsEvent(title:EnterNumberPg_Back_NavBar_Clk),
    EnterNumberPg_ExitImpoYesDlg_Btn_Clk:AnalyticsEvent(title:EnterNumberPg_ExitImpoYesDlg_Btn_Clk),
    EnterNumberPg_ExitImpoNoDlg_Btn_Clk:AnalyticsEvent(title:EnterNumberPg_ExitImpoNoDlg_Btn_Clk),
    LoginPg_Self_Pg_Load:AnalyticsEvent(title:LoginPg_Self_Pg_Load),
    LoginPg_Back_NavBar_Clk:AnalyticsEvent(title:LoginPg_Back_NavBar_Clk),
    LoginPg_Phone_Btn_Clk:AnalyticsEvent(title:LoginPg_Phone_Btn_Clk),
    LoginPg_Email_Btn_Clk:AnalyticsEvent(title:LoginPg_Email_Btn_Clk),
    LoginPg_LoginToImpo_Btn_Clk:AnalyticsEvent(title:LoginPg_LoginToImpo_Btn_Clk),
    LoginPg_ForgotPassword_Text_Clk:AnalyticsEvent(title:LoginPg_ForgotPassword_Text_Clk),
    ForgotPasswordPg_Self_Pg_Load:AnalyticsEvent(title:ForgotPasswordPg_Self_Pg_Load),
    ForgotPasswordPg_Back_NavBar_Clk:AnalyticsEvent(title:ForgotPasswordPg_Back_NavBar_Clk),
    ForgotPasswordPg_Phone_Btn_Clk:AnalyticsEvent(title:ForgotPasswordPg_Phone_Btn_Clk),
    ForgotPasswordPg_Email_Btn_Clk:AnalyticsEvent(title:ForgotPasswordPg_Email_Btn_Clk),
    ForgotPasswordPg_continue_Btn_Clk:AnalyticsEvent(title:ForgotPasswordPg_continue_Btn_Clk),
    VerifyCodePg_Self_Pg_Load:AnalyticsEvent(title:VerifyCodePg_Self_Pg_Load),
    VerifyCodePg_Back_NavBar_Clk:AnalyticsEvent(title:VerifyCodePg_Back_NavBar_Clk),
    VerifyCodePg_VerifyCode_Btn_Clk:AnalyticsEvent(title:VerifyCodePg_VerifyCode_Btn_Clk),
    SetPasswordPg_Self_Pg_Load:AnalyticsEvent(title:SetPasswordPg_Self_Pg_Load),
    SetPasswordPg_Back_NavBar_Clk:AnalyticsEvent(title:SetPasswordPg_Back_NavBar_Clk),
    SetPasswordPg_Reg_Btn_Clk:AnalyticsEvent(title:SetPasswordPg_Reg_Btn_Clk),
    NameRegPg_Self_Pg_Load:AnalyticsEvent(title:NameRegPg_Self_Pg_Load),
    NameRegPg_Back_NavBar_Clk:AnalyticsEvent(title:NameRegPg_Back_NavBar_Clk),
    NameRegPg_Cont_Btn_Clk:AnalyticsEvent(title:NameRegPg_Cont_Btn_Clk),
    NationalityRegPg_Cont_Btn_Clk:AnalyticsEvent(title:NationalityRegPg_Cont_Btn_Clk),
    NationalityRegPg_Back_NavBar_Clk:AnalyticsEvent(title:NationalityRegPg_Back_NavBar_Clk),
    BirthdayRegPg_Cont_Btn_Clk:AnalyticsEvent(title:BirthdayRegPg_Cont_Btn_Clk),
    BirthdayRegPg_Back_NavBar_Clk:AnalyticsEvent(title:BirthdayRegPg_Back_NavBar_Clk),
    SexualRegPg_Cont_Btn_Clk:AnalyticsEvent(title:SexualRegPg_Cont_Btn_Clk),
    SexualRegPg_Back_NavBar_Clk:AnalyticsEvent(title:SexualRegPg_Back_NavBar_Clk),
    SelectStatusPg_Back_NavBar_Clk:AnalyticsEvent(title:SelectStatusPg_Back_NavBar_Clk),
    SelectStatusPgPeriodState_Btn_Clk:AnalyticsEvent(title:SelectStatusPgPeriodState_Btn_Clk),
    SelectStatusPgPregnancyState_Btn_Clk:AnalyticsEvent(title:SelectStatusPgPregnancyState_Btn_Clk),
    PeriodDayRegPg_Self_Pg_Load:AnalyticsEvent(title:PeriodDayRegPg_Self_Pg_Load),
    PeriodDayRegPg_Back_NavBar_Clk:AnalyticsEvent(title:PeriodDayRegPg_Back_NavBar_Clk),
    PeriodDayRegPg_Back_Btn_Clk:AnalyticsEvent(title:PeriodDayRegPg_Back_Btn_Clk),
    PeriodDayRegPg_PeriodLengthList_Picker_Scr:AnalyticsEvent(title:PeriodDayRegPg_PeriodLengthList_Picker_Scr),
    PeriodDayRegPg_Cont_Btn_Clk:AnalyticsEvent(title:PeriodDayRegPg_Cont_Btn_Clk),
    CycleDayRegPg_Back_NavBar_Clk:AnalyticsEvent(title:CycleDayRegPg_Back_NavBar_Clk),
    CycleDayRegPg_Back_Btn_Clk:AnalyticsEvent(title:CycleDayRegPg_Back_Btn_Clk),
    CycleDayRegPg_CycleLengthList_Picker_Scr:AnalyticsEvent(title:CycleDayRegPg_CycleLengthList_Picker_Scr),
    CycleDayRegPg_Cont_Btn_Clk:AnalyticsEvent(title:CycleDayRegPg_Cont_Btn_Clk),
    LastPeriodRegPg_Back_NavBar_Clk:AnalyticsEvent(title:LastPeriodRegPg_Back_NavBar_Clk),
    LastPeriodRegPg_Back_Btn_Clk:AnalyticsEvent(title:LastPeriodRegPg_Back_Btn_Clk),
    LastPeriodRegPg_LastPeriodList_Picker_Scr:AnalyticsEvent(title:LastPeriodRegPg_LastPeriodList_Picker_Scr),
    LastPeriodRegPg_Cont_Btn_Clk:AnalyticsEvent(title:LastPeriodRegPg_Cont_Btn_Clk),
    BardariRegPg_Self_Pg_Load:AnalyticsEvent(title:BardariRegPg_Self_Pg_Load),
    BardariRegPg_Back_NavBar_Clk:AnalyticsEvent(title:BardariRegPg_Back_NavBar_Clk),
    BardariRegPg_Back_Btn_Clk:AnalyticsEvent(title:BardariRegPg_Back_Btn_Clk),
    BardariRegPg_DateofBirth_Btn_Clk:AnalyticsEvent(title:BardariRegPg_DateofBirth_Btn_Clk),
    BardariRegPg_LastPeriod_Btn_Clk:AnalyticsEvent(title:BardariRegPg_LastPeriod_Btn_Clk),
    BardariRegPg_Cont_Btn_Clk:AnalyticsEvent(title:BardariRegPg_Cont_Btn_Clk),
    NumberBardariRegPg_Back_NavBar_Clk:AnalyticsEvent(title:NumberBardariRegPg_Back_NavBar_Clk),
    NumberBardariRegPg_Back_Btn_Clk:AnalyticsEvent(title:NumberBardariRegPg_Back_Btn_Clk),
    NumberBardariRegPg_Cont_Btn_Clk:AnalyticsEvent(title:NumberBardariRegPg_Cont_Btn_Clk),
    AbortionRegPg_Back_NavBar_Clk:AnalyticsEvent(title:AbortionRegPg_Back_NavBar_Clk),
    AbortionRegPg_Back_Btn_Clk:AnalyticsEvent(title:AbortionRegPg_Back_Btn_Clk),
    AbortionRegPg_Cont_Btn_Clk:AnalyticsEvent(title:AbortionRegPg_Cont_Btn_Clk),
    DashPgPeriod_Self_Pg_Load:AnalyticsEvent(title:DashPgPeriod_Self_Pg_Load),
    DashPgPeriod_AdvBanner_Banner_Clk:AnalyticsEvent(title:DashPgPeriod_AdvBanner_Banner_Clk),
    DashPgPeriod_Profile_Btn_Clk:AnalyticsEvent(title:DashPgPeriod_Profile_Btn_Clk),
    DashPgPeriod_Alarms_Btn_Clk:AnalyticsEvent(title:DashPgPeriod_Alarms_Btn_Clk),
    DashPgPeriod_Calendar_Btn_Clk:AnalyticsEvent(title:DashPgPeriod_Calendar_Btn_Clk),
    DashPgPeriod_MyChange_Btn_Clk:AnalyticsEvent(title:DashPgPeriod_MyChange_Btn_Clk),
    DashPgPeriod_Help_Btn_Clk:AnalyticsEvent(title:DashPgPeriod_Help_Btn_Clk),
    DashPgPeriod_HintMessage1_Btn_Clk:AnalyticsEvent(title:DashPgPeriod_HintMessage1_Btn_Clk),
    DashPgPeriod_HintMessage2_Btn_Clk:AnalyticsEvent(title:DashPgPeriod_HintMessage2_Btn_Clk),
    DashPgPeriod_Signs_Btn_Clk:AnalyticsEvent(title:DashPgPeriod_Signs_Btn_Clk),
    DashPgPeriod_ShareExp_Btn_Clk:AnalyticsEvent(title:DashPgPeriod_ShareExp_Btn_Clk),
    DashPgPeriod_Body_Item_Clk:AnalyticsEvent(title:DashPgPeriod_Body_Item_Clk),
    DashPgPeriod_Emotional_Item_Clk:AnalyticsEvent(title:DashPgPeriod_Emotional_Item_Clk),
    DashPgPeriod_Mental_Item_Clk:AnalyticsEvent(title:DashPgPeriod_Mental_Item_Clk),
    DashPgPeriod_EndScrollBio_Pg_Scr:AnalyticsEvent(title:DashPgPeriod_EndScrollBio_Pg_Scr),
    DashPgPeriod_ImPregnant_Btn_Clk_BtmSht:AnalyticsEvent(title:DashPgPeriod_ImPregnant_Btn_Clk_BtmSht),
    DashPgPeriod_ImPeriod_Btn_Clk_BtmSht:AnalyticsEvent(title:DashPgPeriod_ImPeriod_Btn_Clk_BtmSht),
    DashPgPeriod_NotPeriod_Btn_Clk_BtmSht:AnalyticsEvent(title:DashPgPeriod_NotPeriod_Btn_Clk_BtmSht),
    DashPgPeriod_EndPeriod_Btn_Clk_BtmSht:AnalyticsEvent(title:DashPgPeriod_EndPeriod_Btn_Clk_BtmSht),
    DashPgPeriod_ContPeriod_Btn_Clk_BtmSht:AnalyticsEvent(title:DashPgPeriod_ContPeriod_Btn_Clk_BtmSht),
    DashPgPeriod_ImPregnantYesDlg_Btn_Clk_BtmSht:AnalyticsEvent(title:DashPgPeriod_ImPregnantYesDlg_Btn_Clk_BtmSht),
    DashPgPeriod_ImPregnantNoDlg_Btn_Clk_BtmSht:AnalyticsEvent(title:DashPgPeriod_ImPregnantNoDlg_Btn_Clk_BtmSht),
    DashPgPeriod_ImPeriodYesDlg_Btn_Clk_BtmSht:AnalyticsEvent(title:DashPgPeriod_ImPeriodYesDlg_Btn_Clk_BtmSht),
    DashPgPeriod_ImPeriodNoDlg_Btn_Clk_BtmSht:AnalyticsEvent(title:DashPgPeriod_ImPeriodNoDlg_Btn_Clk_BtmSht),
    DashPgPeriod_NotPeriodYesDlg_Btn_Clk_BtmSht:AnalyticsEvent(title:DashPgPeriod_NotPeriodYesDlg_Btn_Clk_BtmSht),
    DashPgPeriod_NotPeriodNoDlg_Btn_Clk_BtmSht:AnalyticsEvent(title:DashPgPeriod_NotPeriodNoDlg_Btn_Clk_BtmSht),
    DashPgPeriod_EndPeriodYesDlg_Btn_Clk_BtmSht:AnalyticsEvent(title:DashPgPeriod_EndPeriodYesDlg_Btn_Clk_BtmSht),
    DashPgPeriod_EndPeriodNoDlg_Btn_Clk_BtmSht:AnalyticsEvent(title:DashPgPeriod_EndPeriodNoDlg_Btn_Clk_BtmSht),
    DashPgPeriod_ContPeriodYesDlg_Btn_Clk_BtmSht:AnalyticsEvent(title:DashPgPeriod_ContPeriodYesDlg_Btn_Clk_BtmSht),
    DashPgPeriod_ContPeriodNoDlg_Btn_Clk_BtmSht:AnalyticsEvent(title:DashPgPeriod_ContPeriodNoDlg_Btn_Clk_BtmSht),
    DashPgPeriod_CheckReportingDlg_Dlg_Load:AnalyticsEvent(title:DashPgPeriod_CheckReportingDlg_Dlg_Load),
    DashPgPeriod_CheckReportingYesDlg_Btn_Clk:AnalyticsEvent(title:DashPgPeriod_CheckReportingYesDlg_Btn_Clk),
    DashPgPeriod_CheckReportingNoDlg_Btn_Clk:AnalyticsEvent(title:DashPgPeriod_CheckReportingNoDlg_Btn_Clk),
    DashPgPeriod_RateStoreDlg_Dlg_Load:AnalyticsEvent(title:DashPgPeriod_RateStoreDlg_Dlg_Load),
    DashPgPeriod_RateStoreYesDlg_Btn_Clk:AnalyticsEvent(title:DashPgPeriod_RateStoreYesDlg_Btn_Clk),
    DashPgPeriod_RateStoreNoDlg_Btn_Clk:AnalyticsEvent(title:DashPgPeriod_RateStoreNoDlg_Btn_Clk),
    ChangeCyclePgPeriod_Back_Btn_Clk:AnalyticsEvent(title:ChangeCyclePgPeriod_Back_Btn_Clk),
    ChangeCyclePgPeriod_Back_NavBar_Clk:AnalyticsEvent(title:ChangeCyclePgPeriod_Back_NavBar_Clk),
    ChangeCyclePgPeriod_Profile_Btn_Clk:AnalyticsEvent(title:ChangeCyclePgPeriod_Profile_Btn_Clk),
    ChangeCyclePgPeriod_SaveAndAccept_Btn_Clk:AnalyticsEvent(title:ChangeCyclePgPeriod_SaveAndAccept_Btn_Clk),
    ChangeCyclePgPeriod_StartPeriod_Btn_Clk:AnalyticsEvent(title:ChangeCyclePgPeriod_StartPeriod_Btn_Clk),
    ChangeCyclePgPeriod_EndPeriod_Btn_Clk:AnalyticsEvent(title:ChangeCyclePgPeriod_EndPeriod_Btn_Clk),
    ChangeCyclePgPeriod_EndCycle_Btn_Clk:AnalyticsEvent(title:ChangeCyclePgPeriod_EndCycle_Btn_Clk),
    SignsPgPeriod_Back_Btn_Clk:AnalyticsEvent(title:SignsPgPeriod_Back_Btn_Clk),
    SignsPgPeriod_Back_NavBar_Clk:AnalyticsEvent(title:SignsPgPeriod_Back_NavBar_Clk),
    SignsPgPeriod_SaveChanges_Btn_Clk:AnalyticsEvent(title:SignsPgPeriod_SaveChanges_Btn_Clk),
    SignsPgPeriod_SaveChangeDlgYes_Btn_Clk:AnalyticsEvent(title:SignsPgPeriod_SaveChangeDlgYes_Btn_Clk),
    SignsPgPeriod_SaveChangesDlgNo_Btn_Clk:AnalyticsEvent(title:SignsPgPeriod_SaveChangesDlgNo_Btn_Clk),
    SignsPgPeriod_AddSign_Item_Clk:AnalyticsEvent(title:SignsPgPeriod_AddSign_Item_Clk),
    SignsPgPeriod_RemoveSign_Item_Clk:AnalyticsEvent(title:SignsPgPeriod_RemoveSign_Item_Clk),
    ChangeStatusPgPeriod_Self_Pg_Load:AnalyticsEvent(title:ChangeStatusPgPeriod_Self_Pg_Load),
    ChangeStatusPgPeriod_Back_NavBar_Clk:AnalyticsEvent(title:ChangeStatusPgPeriod_Back_NavBar_Clk),
    ChangeStatusPgPeriod_Back_Btn_Clk:AnalyticsEvent(title:ChangeStatusPgPeriod_Back_Btn_Clk),
    ChangeStatusPgPeriod_Complete_Btn_Clk:AnalyticsEvent(title:ChangeStatusPgPeriod_Complete_Btn_Clk),
    DashPgPregnancy_Self_Pg_Load:AnalyticsEvent(title:DashPgPregnancy_Self_Pg_Load),
    DashPgPregnancy_AdvBanner_Banner_Clk:AnalyticsEvent(title:DashPgPregnancy_AdvBanner_Banner_Clk),
    DashPgPregnancy_Profile_Btn_Clk:AnalyticsEvent(title:DashPgPregnancy_Profile_Btn_Clk),
    DashPgPregnancy_Alarms_Btn_Clk:AnalyticsEvent(title:DashPgPregnancy_Alarms_Btn_Clk),
    DashPgPregnancy_Calendar_Btn_Clk:AnalyticsEvent(title:DashPgPregnancy_Calendar_Btn_Clk),
    DashPgPregnancy_MyChange_Btn_Clk:AnalyticsEvent(title:DashPgPregnancy_MyChange_Btn_Clk),
    DashPgPregnancy_HintMessage1_Btn_Clk:AnalyticsEvent(title:DashPgPregnancy_HintMessage1_Btn_Clk),
    DashPgPregnancy_HintMessage2_Btn_Clk:AnalyticsEvent(title:DashPgPregnancy_HintMessage2_Btn_Clk),
    DashPgPregnancy_Signs_Btn_Clk:AnalyticsEvent(title:DashPgPregnancy_Signs_Btn_Clk),
    DashPgPregnancy_ShareExp_Btn_Clk:AnalyticsEvent(title:DashPgPregnancy_ShareExp_Btn_Clk),
    DashPgPregnancy_Body_Item_Clk:AnalyticsEvent(title:DashPgPregnancy_Body_Item_Clk),
    DashPgPregnancy_Emotional_Item_Clk:AnalyticsEvent(title:DashPgPregnancy_Emotional_Item_Clk),
    DashPgPregnancy_Mental_Item_Clk:AnalyticsEvent(title:DashPgPregnancy_Mental_Item_Clk),
    DashPgPregnancy_EndScrollBio_Pg_Scr:AnalyticsEvent(title:DashPgPregnancy_EndScrollBio_Pg_Scr),
    DashPgPregnancy_GivingBirth_Btn_Clk_BtmSht:AnalyticsEvent(title:DashPgPregnancy_GivingBirth_Btn_Clk_BtmSht),
    DashPgPregnancy_Abrt_Btn_Clk_BtmSht:AnalyticsEvent(title:DashPgPregnancy_Abrt_Btn_Clk_BtmSht),
    DashPgPregnancy_AbrtYesDlg_Btn_Clk_BtmSht:AnalyticsEvent(title:DashPgPregnancy_AbrtYesDlg_Btn_Clk_BtmSht),
    DashPgPregnancy_AbrtNoDlg_Btn_Clk_BtmSht:AnalyticsEvent(title:DashPgPregnancy_AbrtNoDlg_Btn_Clk_BtmSht),
    DashPgPregnancy_Set_Btn_Clk_BtmSht:AnalyticsEvent(title:DashPgPregnancy_Set_Btn_Clk_BtmSht),
    DashPgPregnancy_PregnancyLimitWeek_Dlg_Load:AnalyticsEvent(title:DashPgPregnancy_PregnancyLimitWeek_Dlg_Load),
    DashPgPregnancy_PrgcLtWkChBirth_Btn_Clk_Dlg:AnalyticsEvent(title:DashPgPregnancy_PrgcLtWkChBirth_Btn_Clk_Dlg),
    DashPgPregnancy_PrgcLtWkAbrt_Btn_Clk_Dlg:AnalyticsEvent(title:DashPgPregnancy_PrgcLtWkAbrt_Btn_Clk_Dlg),
    SetBardariPg_Back_Btn_Clk:AnalyticsEvent(title:SetBardariPg_Back_Btn_Clk),
    SetBardariPg_Back_NavBar_Clk:AnalyticsEvent(title:SetBardariPg_Back_NavBar_Clk),
    SetBardariPg_Profile_Btn_Clk:AnalyticsEvent(title:SetBardariPg_Profile_Btn_Clk),
    SetBardariPg_PregnancyWeek_Btn_Clk:AnalyticsEvent(title:SetBardariPg_PregnancyWeek_Btn_Clk),
    SetBardariPg_DateOfBirth_Btn_Clk_BtmSht:AnalyticsEvent(title:SetBardariPg_DateOfBirth_Btn_Clk_BtmSht),
    SetBardariPg_LastPeriod_Btn_Clk_BtmSht:AnalyticsEvent(title:SetBardariPg_LastPeriod_Btn_Clk_BtmSht),
    SetBardariPg_AcptPrgcWk_Btn_Clk_BtmSht:AnalyticsEvent(title:SetBardariPg_AcptPrgcWk_Btn_Clk_BtmSht),
    SetBardariPg_HistoryOfPregnancy_Btn_Clk:AnalyticsEvent(title:SetBardariPg_HistoryOfPregnancy_Btn_Clk),
    SetBardariPg_HisPrgcList_Picker_Scr_BtmSht:AnalyticsEvent(title:SetBardariPg_HisPrgcList_Picker_Scr_BtmSht),
    SetBardariPg_AcptHisPrgc_Btn_Clk_BtmSht:AnalyticsEvent(title:SetBardariPg_AcptHisPrgc_Btn_Clk_BtmSht),
    SetBardariPg_HistoryOfAbortion_Btn_Clk:AnalyticsEvent(title:SetBardariPg_HistoryOfAbortion_Btn_Clk),
    SetBardariPg_HisAbrList_Picker_Scr_BtmSht:AnalyticsEvent(title:SetBardariPg_HisAbrList_Picker_Scr_BtmSht),
    SetBardariPg_AcptHisAbr_Btn_Clk_BtmSht:AnalyticsEvent(title:SetBardariPg_AcptHisAbr_Btn_Clk_BtmSht),
    SetBardariPg_SaveAndAccept_Btn_Clk:AnalyticsEvent(title:SetBardariPg_SaveAndAccept_Btn_Clk),
    SetBardariPg_SaveChangeDlgYes_Btn_Clk:AnalyticsEvent(title:SetBardariPg_SaveChangeDlgYes_Btn_Clk),
    SetBardariPg_SaveChangesDlgNo_Btn_Clk:AnalyticsEvent(title:SetBardariPg_SaveChangesDlgNo_Btn_Clk),
    SignsPgPregnancy_Back_Btn_Clk:AnalyticsEvent(title:SignsPgPregnancy_Back_Btn_Clk),
    SignsPgPregnancy_Back_NavBar_Clk:AnalyticsEvent(title:SignsPgPregnancy_Back_NavBar_Clk),
    SignsPgPregnancy_SaveChanges_Btn_Clk:AnalyticsEvent(title:SignsPgPregnancy_SaveChanges_Btn_Clk),
    SignsPgPregnancy_SaveChangeDlgYes_Btn_Clk:AnalyticsEvent(title:SignsPgPregnancy_SaveChangeDlgYes_Btn_Clk),
    SignsPgPregnancy_SaveChangesDlgNo_Btn_Clk:AnalyticsEvent(title:SignsPgPregnancy_SaveChangesDlgNo_Btn_Clk),
    SignsPgPregnancy_AddSign_Item_Clk:AnalyticsEvent(title:SignsPgPregnancy_AddSign_Item_Clk),
    SignsPgPregnancy_RemoveSign_Item_Clk:AnalyticsEvent(title:SignsPgPregnancy_RemoveSign_Item_Clk),
    ChangeStatusPgPregnancy_Self_Pg_Load:AnalyticsEvent(title:ChangeStatusPgPregnancy_Self_Pg_Load),
    ChangeStatusPgPregnancy_Back_NavBar_Clk:AnalyticsEvent(title:ChangeStatusPgPregnancy_Back_NavBar_Clk),
    ChangeStatusPgPregnancy_Back_Btn_Clk:AnalyticsEvent(title:ChangeStatusPgPregnancy_Back_Btn_Clk),
    ChangeStatusPgPregnancy_Complete_Btn_Clk:AnalyticsEvent(title:ChangeStatusPgPregnancy_Complete_Btn_Clk),
    PregnancyDateRegPg_Back_Btn_Clk:AnalyticsEvent(title:PregnancyDateRegPg_Back_Btn_Clk),
    PregnancyDateRegPg_Back_NavBar_Clk:AnalyticsEvent(title:PregnancyDateRegPg_Back_NavBar_Clk),
    PregnancyDateRegPg_Profile_Btn_Clk:AnalyticsEvent(title:PregnancyDateRegPg_Profile_Btn_Clk),
    PregnancyDateRegPg_Cont_Btn_Clk:AnalyticsEvent(title:PregnancyDateRegPg_Cont_Btn_Clk),
    SpecificationBabyRegPg_Back_Btn_Clk:AnalyticsEvent(title:SpecificationBabyRegPg_Back_Btn_Clk),
    SpecificationBabyRegPg_Back_NavBar_Clk:AnalyticsEvent(title:SpecificationBabyRegPg_Back_NavBar_Clk),
    SpecificationBabyRegPg_Profile_Btn_Clk:AnalyticsEvent(title:SpecificationBabyRegPg_Profile_Btn_Clk),
    SpecificationBabyRegPg_Girl_Btn_Clk:AnalyticsEvent(title:SpecificationBabyRegPg_Girl_Btn_Clk),
    SpecificationBabyRegPg_Boy_Btn_Clk:AnalyticsEvent(title:SpecificationBabyRegPg_Boy_Btn_Clk),
    SpecificationBabyRegPg_TwinsOrMore_Btn_Clk:AnalyticsEvent(title:SpecificationBabyRegPg_TwinsOrMore_Btn_Clk),
    SpecificationBabyRegPg_Accept_Btn_Clk:AnalyticsEvent(title:SpecificationBabyRegPg_Accept_Btn_Clk),
    TpBirthRegPg_Back_Btn_Clk:AnalyticsEvent(title:TpBirthRegPg_Back_Btn_Clk),
    TpBirthRegPg_Back_NavBar_Clk:AnalyticsEvent(title:TpBirthRegPg_Back_NavBar_Clk),
    TpBirthRegPg_Profile_Btn_Clk:AnalyticsEvent(title:TpBirthRegPg_Profile_Btn_Clk),
    TpBirthRegPg_TpBirthList_Picker_Scr:AnalyticsEvent(title:TpBirthRegPg_TpBirthList_Picker_Scr),
    TpBirthRegPg_Accept_Btn_Clk:AnalyticsEvent(title:TpBirthRegPg_Accept_Btn_Clk),
    DashPgBrstfeed_BrstfeedDlg_Dlg_Load:AnalyticsEvent(title:DashPgBrstfeed_BrstfeedDlg_Dlg_Load),
    DashPgBrstfeed_BrstfeedOkDlg_Btn_Clk:AnalyticsEvent(title:DashPgBrstfeed_BrstfeedOkDlg_Btn_Clk),
    DashPgBrstfeed_Self_Pg_Load:AnalyticsEvent(title:DashPgBrstfeed_Self_Pg_Load),
    DashPgBrstfeed_AdvBanner_Banner_Clk:AnalyticsEvent(title:DashPgBrstfeed_AdvBanner_Banner_Clk),
    DashPgBrstfeed_Profile_Btn_Clk:AnalyticsEvent(title:DashPgBrstfeed_Profile_Btn_Clk),
    DashPgBrstfeed_Alarms_Btn_Clk:AnalyticsEvent(title:DashPgBrstfeed_Alarms_Btn_Clk),
    DashPgBrstfeed_Calendar_Btn_Clk:AnalyticsEvent(title:DashPgBrstfeed_Calendar_Btn_Clk),
    DashPgBrstfeed_MyChange_Btn_Clk:AnalyticsEvent(title:DashPgBrstfeed_MyChange_Btn_Clk),
    DashPgBrstfeed_HintMessage1_Btn_Clk:AnalyticsEvent(title:DashPgBrstfeed_HintMessage1_Btn_Clk),
    DashPgBrstfeed_HintMessage2_Btn_Clk:AnalyticsEvent(title:DashPgBrstfeed_HintMessage2_Btn_Clk),
    DashPgBrstfeed_Signs_Btn_Clk:AnalyticsEvent(title:DashPgBrstfeed_Signs_Btn_Clk),
    DashPgBrstfeed_ShareExp_Btn_Clk:AnalyticsEvent(title:DashPgBrstfeed_ShareExp_Btn_Clk),
    DashPgBrstfeed_Body_Item_Clk:AnalyticsEvent(title:DashPgBrstfeed_Body_Item_Clk),
    DashPgBrstfeed_Emotional_Item_Clk:AnalyticsEvent(title:DashPgBrstfeed_Emotional_Item_Clk),
    DashPgBrstfeed_Mental_Item_Clk:AnalyticsEvent(title:DashPgBrstfeed_Mental_Item_Clk),
    DashPgBrstfeed_EndScrollBio_Pg_Scr:AnalyticsEvent(title:DashPgBrstfeed_EndScrollBio_Pg_Scr),
    DashPgBrstfeed_ImPeriod_Btn_Clk_BtmSht:AnalyticsEvent(title:DashPgBrstfeed_ImPeriod_Btn_Clk_BtmSht),
    DashPgBrstfeed_ImPeriodYesDlg_Btn_Clk_BtmSht:AnalyticsEvent(title:DashPgBrstfeed_ImPeriodYesDlg_Btn_Clk_BtmSht),
    DashPgBrstfeed_ImPeriodNoDlg_Btn_Clk_BtmSht:AnalyticsEvent(title:DashPgBrstfeed_ImPeriodNoDlg_Btn_Clk_BtmSht),
    DashPgBrstfeed_Set_Btn_Clk_BtmSht:AnalyticsEvent(title:DashPgBrstfeed_Set_Btn_Clk_BtmSht),
    DashPgBrstfeed_BrstfeedLimitWeek_Dlg_Load:AnalyticsEvent(title:DashPgBrstfeed_BrstfeedLimitWeek_Dlg_Load),
    DashPgBrstfeed_CompletePeriodFaz_Btn_Clk_Dlg:AnalyticsEvent(title:DashPgBrstfeed_CompletePeriodFaz_Btn_Clk_Dlg),
    SetBrstfeedPg_Back_Btn_Clk:AnalyticsEvent(title:SetBrstfeedPg_Back_Btn_Clk),
    SetBrstfeedPg_Back_NavBar_Clk:AnalyticsEvent(title:SetBrstfeedPg_Back_NavBar_Clk),
    SetBrstfeedPg_Profile_Btn_Clk:AnalyticsEvent(title:SetBrstfeedPg_Profile_Btn_Clk),
    SetBrstfeedPg_DateOfBirth_Btn_Clk:AnalyticsEvent(title:SetBrstfeedPg_DateOfBirth_Btn_Clk),
    SetBrstfeedPg_AcptDateOfBirth_Btn_Clk_BtmSht:AnalyticsEvent(title:SetBrstfeedPg_AcptDateOfBirth_Btn_Clk_BtmSht),
    SetBrstfeedPg_GenderOfTheBaby_Btn_Clk:AnalyticsEvent(title:SetBrstfeedPg_GenderOfTheBaby_Btn_Clk),
    SetBrstfeedPg_Girl_Btn_Clk_BtmSht:AnalyticsEvent(title:SetBrstfeedPg_Girl_Btn_Clk_BtmSht),
    SetBrstfeedPg_Boy_Btn_Clk_BtmSht:AnalyticsEvent(title:SetBrstfeedPg_Boy_Btn_Clk_BtmSht),
    SetBrstfeedPg_TwinsOrMore_Btn_Clk_BtmSht:AnalyticsEvent(title:SetBrstfeedPg_TwinsOrMore_Btn_Clk_BtmSht),
    SetBrstfeedPg_AcptGenderBaby_Btn_Clk_BtmSht:AnalyticsEvent(title:SetBrstfeedPg_AcptGenderBaby_Btn_Clk_BtmSht),
    SetBrstfeedPg_TpDelivery_Btn_Clk:AnalyticsEvent(title:SetBrstfeedPg_TpDelivery_Btn_Clk),
    SetBrstfeedPg_TpDlvrList_Picker_Scr_BtmSht:AnalyticsEvent(title:SetBrstfeedPg_TpDlvrList_Picker_Scr_BtmSht),
    SetBrstfeedPg_AcptTpDlvr_Btn_Clk_BtmSht:AnalyticsEvent(title:SetBrstfeedPg_AcptTpDlvr_Btn_Clk_BtmSht),
    SetBrstfeedPg_SaveAndAccept_Btn_Clk:AnalyticsEvent(title:SetBrstfeedPg_SaveAndAccept_Btn_Clk),
    SetBrstfeedPg_SaveChangeDlgYes_Btn_Clk:AnalyticsEvent(title:SetBrstfeedPg_SaveChangeDlgYes_Btn_Clk),
    SetBrstfeedPg_SaveChangesDlgNo_Btn_Clk:AnalyticsEvent(title:SetBrstfeedPg_SaveChangesDlgNo_Btn_Clk),
    SignsPgBrstfeed_Back_Btn_Clk:AnalyticsEvent(title:SignsPgBrstfeed_Back_Btn_Clk),
    SignsPgBrstfeed_Back_NavBar_Clk:AnalyticsEvent(title:SignsPgBrstfeed_Back_NavBar_Clk),
    SignsPgBrstfeed_SaveChanges_Btn_Clk:AnalyticsEvent(title:SignsPgBrstfeed_SaveChanges_Btn_Clk),
    SignsPgBrstfeed_SaveChangeDlgYes_Btn_Clk:AnalyticsEvent(title:SignsPgBrstfeed_SaveChangeDlgYes_Btn_Clk),
    SignsPgBrstfeed_SaveChangesDlgNo_Btn_Clk:AnalyticsEvent(title:SignsPgBrstfeed_SaveChangesDlgNo_Btn_Clk),
    SignsPgBrstfeed_AddSign_Item_Clk:AnalyticsEvent(title:SignsPgBrstfeed_AddSign_Item_Clk),
    SignsPgBrstfeed_RemoveSign_Item_Clk:AnalyticsEvent(title:SignsPgBrstfeed_RemoveSign_Item_Clk),
    BlogPg_Self_Pg_Load:AnalyticsEvent(title:BlogPg_Self_Pg_Load),
    BlogPg_AdvBanner_Banner_Clk:AnalyticsEvent(title:BlogPg_AdvBanner_Banner_Clk),
    BlogPg_BlogList_Item_Clk:AnalyticsEvent(title:BlogPg_BlogList_Item_Clk),
    BlogPg_Profile_Btn_Clk:AnalyticsEvent(title:BlogPg_Profile_Btn_Clk),
    BlogPg_Calendar_Btn_Clk:AnalyticsEvent(title:BlogPg_Calendar_Btn_Clk),
    PartnerTabPg_Self_Pg_Load:AnalyticsEvent(title:PartnerTabPg_Self_Pg_Load),
    PartnerTabPg_Profile_Btn_Clk:AnalyticsEvent(title:PartnerTabPg_Profile_Btn_Clk),
    PartnerTabPg_Alarms_Btn_Clk:AnalyticsEvent(title:PartnerTabPg_Alarms_Btn_Clk),
    PartnerTabPg_SendMessage_Btn_Clk:AnalyticsEvent(title:PartnerTabPg_SendMessage_Btn_Clk),
    PartnerTabPg_MemoryGame_Btn_Clk:AnalyticsEvent(title:PartnerTabPg_MemoryGame_Btn_Clk),
    PartnerTabPg_Whatisabiorhythm_Text_Clk:AnalyticsEvent(title:PartnerTabPg_Whatisabiorhythm_Text_Clk),
    PartnerTabPg_Body_Item_Clk:AnalyticsEvent(title:PartnerTabPg_Body_Item_Clk),
    PartnerTabPg_Emotional_Item_Clk:AnalyticsEvent(title:PartnerTabPg_Emotional_Item_Clk),
    PartnerTabPg_Mental_Item_Clk:AnalyticsEvent(title:PartnerTabPg_Mental_Item_Clk),
    PartnerTabPg_HintMessage1_Btn_Clk:AnalyticsEvent(title:PartnerTabPg_HintMessage1_Btn_Clk),
    PartnerTabPg_HintMessage2_Btn_Clk:AnalyticsEvent(title:PartnerTabPg_HintMessage2_Btn_Clk),
    PartnerTabPg_Whatisacriticalday_Text_Clk:AnalyticsEvent(title:PartnerTabPg_Whatisacriticalday_Text_Clk),
    PartnerTabPg_AddPartner_Btn_Clk:AnalyticsEvent(title:PartnerTabPg_AddPartner_Btn_Clk),
    PartnerTabPg_RefreshRequests_Icon_Clk:AnalyticsEvent(title:PartnerTabPg_RefreshRequests_Icon_Clk),
    PartnerTabPg_AcceptPartner_Btn_Clk:AnalyticsEvent(title:PartnerTabPg_AcceptPartner_Btn_Clk),
    PartnerTabPg_RejectPartner_Btn_Clk:AnalyticsEvent(title:PartnerTabPg_RejectPartner_Btn_Clk),
    PartnerTabPg_RejectPartnerYesDlg_Btn_Clk:AnalyticsEvent(title:PartnerTabPg_RejectPartnerYesDlg_Btn_Clk),
    PartnerTabPg_RejectPartnerNoDlg_Btn_Clk:AnalyticsEvent(title:PartnerTabPg_RejectPartnerNoDlg_Btn_Clk),
    PartnerTabPg_CancelPartner_Btn_Clk:AnalyticsEvent(title:PartnerTabPg_CancelPartner_Btn_Clk),
    PartnerTabPg_CancelPartnerYesDlg_Btn_Clk:AnalyticsEvent(title:PartnerTabPg_CancelPartnerYesDlg_Btn_Clk),
    PartnerTabPg_CancelPartnerNoDlg_Btn_Clk:AnalyticsEvent(title:PartnerTabPg_CancelPartnerNoDlg_Btn_Clk),
    PartnerTabPg_NoticeToPartner_Btn_Clk:AnalyticsEvent(title:PartnerTabPg_NoticeToPartner_Btn_Clk),
    PartnerTabPg_PartnerAdvBanner_Banner_Clk:AnalyticsEvent(title:PartnerTabPg_PartnerAdvBanner_Banner_Clk),
    PartnerTabPg_NoPartnerAdvBanner_Banner_Clk:AnalyticsEvent(title:PartnerTabPg_NoPartnerAdvBanner_Banner_Clk),
    SendMessagePg_Self_Pg_Load:AnalyticsEvent(title:SendMessagePg_Self_Pg_Load),
    SendMessagePg_Back_Btn_Clk:AnalyticsEvent(title:SendMessagePg_Back_Btn_Clk),
    SendMessagePg_Back_NavBar_Clk:AnalyticsEvent(title:SendMessagePg_Back_NavBar_Clk),
    SendMessagePg_Profile_Btn_Clk:AnalyticsEvent(title:SendMessagePg_Profile_Btn_Clk),
    SendMessagePg_SendMessage_Btn_Clk:AnalyticsEvent(title:SendMessagePg_SendMessage_Btn_Clk),
    MemoryGamePg_Self_Pg_Load:AnalyticsEvent(title:MemoryGamePg_Self_Pg_Load),
    MemoryGamePg_Back_Btn_Clk:AnalyticsEvent(title:MemoryGamePg_Back_Btn_Clk),
    MemoryGamePg_Back_NavBar_Clk:AnalyticsEvent(title:MemoryGamePg_Back_NavBar_Clk),
    MemoryGamePg_Profile_Btn_Clk:AnalyticsEvent(title:MemoryGamePg_Profile_Btn_Clk),
    MemoryGamePg_Startthememorygame_Btn_Clk:AnalyticsEvent(title:MemoryGamePg_Startthememorygame_Btn_Clk),
    MemoryGamePg_MemoryList_Item_Clk:AnalyticsEvent(title:MemoryGamePg_MemoryList_Item_Clk),
    AddMemoryPg_Back_Btn_Clk:AnalyticsEvent(title:AddMemoryPg_Back_Btn_Clk),
    AddMemoryPg_Back_NavBar_Clk:AnalyticsEvent(title:AddMemoryPg_Back_NavBar_Clk),
    AddMemoryPg_Profile_Btn_Clk:AnalyticsEvent(title:AddMemoryPg_Profile_Btn_Clk),
    AddMemoryPg_UploadImage_Btn_Clk:AnalyticsEvent(title:AddMemoryPg_UploadImage_Btn_Clk),
    AddMemoryPg_GalleryUploadImage_Btn_Clk:AnalyticsEvent(title:AddMemoryPg_GalleryUploadImage_Btn_Clk),
    AddMemoryPg_CameraUploadImage_Btn_Clk:AnalyticsEvent(title:AddMemoryPg_CameraUploadImage_Btn_Clk),
    AddMemoryPg_RecordMemory_Btn_Clk:AnalyticsEvent(title:AddMemoryPg_RecordMemory_Btn_Clk),
    ProfileMemoryPg_Back_Btn_Clk:AnalyticsEvent(title:ProfileMemoryPg_Back_Btn_Clk),
    ProfileMemoryPg_Back_NavBar_Clk:AnalyticsEvent(title:ProfileMemoryPg_Back_NavBar_Clk),
    ProfileMemoryPg_Profile_Btn_Clk:AnalyticsEvent(title:ProfileMemoryPg_Profile_Btn_Clk),
    ProfileMemoryPg_RemoveMemory_Btn_Clk:AnalyticsEvent(title:ProfileMemoryPg_RemoveMemory_Btn_Clk),
    ProfileMemoryPg_RemoveMemoryYesDlg_Btn_Clk:AnalyticsEvent(title:ProfileMemoryPg_RemoveMemoryYesDlg_Btn_Clk),
    ProfileMemoryPg_RemoveMemoryNoDlg_Btn_Clk:AnalyticsEvent(title:ProfileMemoryPg_RemoveMemoryNoDlg_Btn_Clk),
    ProfileMemoryPg_whatdoyouthink_Btn_Clk:AnalyticsEvent(title:ProfileMemoryPg_whatdoyouthink_Btn_Clk),
    SendCommitPg_Back_Btn_Clk:AnalyticsEvent(title:SendCommitPg_Back_Btn_Clk),
    SendCommitPg_Back_NavBar_Clk:AnalyticsEvent(title:SendCommitPg_Back_NavBar_Clk),
    SendCommitPg_Profile_Btn_Clk:AnalyticsEvent(title:SendCommitPg_Profile_Btn_Clk),
    SendCommitPg_whatdoyouthink_Btn_Clk:AnalyticsEvent(title:SendCommitPg_whatdoyouthink_Btn_Clk),
    MainClinicPg_Self_Pg_Load:AnalyticsEvent(title:MainClinicPg_Self_Pg_Load),
    MainClinicPg_HelpClinic_Btn_Clk:AnalyticsEvent(title:MainClinicPg_HelpClinic_Btn_Clk),
    MainClinicPg_PolarBank_Btn_Clk:AnalyticsEvent(title:MainClinicPg_PolarBank_Btn_Clk),
    MainClinicPg_HistoryTickets_Btn_Clk:AnalyticsEvent(title:MainClinicPg_HistoryTickets_Btn_Clk),
    MainClinicPg_ClinicList_Item_Clk:AnalyticsEvent(title:MainClinicPg_ClinicList_Item_Clk),
    MainClinicPg_ActiveTicketsMore_Btn_Clk:AnalyticsEvent(title: MainClinicPg_ActiveTicketsMore_Btn_Clk),
    MainClinicPg_ActiveTicketList_Item_Clk:AnalyticsEvent(title:MainClinicPg_ActiveTicketList_Item_Clk),
    ActiveClinicPg_Back_Btn_Clk:AnalyticsEvent(title:ActiveClinicPg_Back_Btn_Clk),
    ActiveClinicPg_Back_NavBar_Clk:AnalyticsEvent(title:ActiveClinicPg_Back_NavBar_Clk),
    ActiveClinicPg_ActiveTicketList_Item_Clk:AnalyticsEvent(title:ActiveClinicPg_ActiveTicketList_Item_Clk),
    ClinicQuestionPg_Back_Btn_Clk:AnalyticsEvent(title:ClinicQuestionPg_Back_Btn_Clk),
    ClinicQuestionPg_Back_NavBar_Clk:AnalyticsEvent(title:ClinicQuestionPg_Back_NavBar_Clk),
    ClinicQuestionPg_Profile_Btn_Clk:AnalyticsEvent(title:ClinicQuestionPg_Profile_Btn_Clk),
    ClinicQuestionPg_PolarBank_Btn_Clk:AnalyticsEvent(title:ClinicQuestionPg_PolarBank_Btn_Clk),
    ClinicQuestionPg_ChangeDoctor_Btn_Clk:AnalyticsEvent(title:ClinicQuestionPg_ChangeDoctor_Btn_Clk),
    ClinicQuestionPg_DoctorProfile_Btn_Clk:AnalyticsEvent(title:ClinicQuestionPg_DoctorProfile_Btn_Clk),
    ClinicQuestionPg_AttachFile_Btn_Clk:AnalyticsEvent(title:ClinicQuestionPg_AttachFile_Btn_Clk),
    ClinicQuestionPg_next_Btn_Clk:AnalyticsEvent(title:ClinicQuestionPg_next_Btn_Clk),
    ClinicPaymentPg_Back_Btn_Clk:AnalyticsEvent(title:ClinicPaymentPg_Back_Btn_Clk),
    ClinicPaymentPg_Back_NavBar_Clk:AnalyticsEvent(title:ClinicPaymentPg_Back_NavBar_Clk),
    ClinicPaymentPg_applyDiscount_Btn_Clk:AnalyticsEvent(title:ClinicPaymentPg_applyDiscount_Btn_Clk),
    ClinicPaymentPg_callSupport_Btn_Clk:AnalyticsEvent(title:ClinicPaymentPg_callSupport_Btn_Clk),
    ClinicPaymentPg_sendQuestion_Btn_Clk:AnalyticsEvent(title:ClinicPaymentPg_sendQuestion_Btn_Clk),
    DoctorListPg_Back_Btn_Clk:AnalyticsEvent(title:DoctorListPg_Back_Btn_Clk),
    DoctorListPg_Back_NavBar_Clk:AnalyticsEvent(title:DoctorListPg_Back_NavBar_Clk),
    DoctorListPg_Profile_Btn_Clk:AnalyticsEvent(title:DoctorListPg_Profile_Btn_Clk),
    DoctorListPg_PolarBank_Btn_Clk:AnalyticsEvent(title:DoctorListPg_PolarBank_Btn_Clk),
    DoctorListPg_DoctorList_Item_Clk:AnalyticsEvent(title:DoctorListPg_DoctorList_Item_Clk),
    ProfileDoctorPg_Back_Btn_Clk:AnalyticsEvent(title:ProfileDoctorPg_Back_Btn_Clk),
    ProfileDoctorPg_Back_NavBar_Clk:AnalyticsEvent(title:ProfileDoctorPg_Back_NavBar_Clk),
    ProfileDoctorPg_Profile_Btn_Clk:AnalyticsEvent(title:ProfileDoctorPg_Profile_Btn_Clk),
    ProfileDoctorPg_PolarBank_Btn_Clk:AnalyticsEvent(title:ProfileDoctorPg_PolarBank_Btn_Clk),
    ProfileDoctorPg_CommentList_List_Scr:AnalyticsEvent(title:ProfileDoctorPg_CommentList_List_Scr),
    ClinicQuestionList_Back_Btn_Clk:AnalyticsEvent(title:ClinicQuestionList_Back_Btn_Clk),
    ClinicQuestionList_Back_NavBar_Clk:AnalyticsEvent(title:ClinicQuestionList_Back_NavBar_Clk),
    ClinicQuestionList_Profile_Btn_Clk:AnalyticsEvent(title:ClinicQuestionList_Profile_Btn_Clk),
    ClinicQuestionList_PolarBank_Btn_Clk:AnalyticsEvent(title:ClinicQuestionList_PolarBank_Btn_Clk),
    ClinicQuestionList_TicketList_Item_Clk:AnalyticsEvent(title:ClinicQuestionList_TicketList_Item_Clk),
    ChatPg_Self_Pg_Load:AnalyticsEvent(title:ChatPg_Self_Pg_Load),
    ChatPg_Back_Btn_Clk:AnalyticsEvent(title:ChatPg_Back_Btn_Clk),
    ChatPg_Back_NavBar_Clk:AnalyticsEvent(title:ChatPg_Back_NavBar_Clk),
    ChatPg_Profile_Btn_Clk:AnalyticsEvent(title:ChatPg_Profile_Btn_Clk),
    ChatPg_PolarBank_Btn_Clk:AnalyticsEvent(title:ChatPg_PolarBank_Btn_Clk),
    ChatPg_RemoveTicket_Btn_Clk:AnalyticsEvent(title:ChatPg_RemoveTicket_Btn_Clk),
    ChatPg_RemoveTicketYesDlg_Btn_Clk:AnalyticsEvent(title:ChatPg_RemoveTicketYesDlg_Btn_Clk),
    ChatPg_RemoveTicketNoDlg_Btn_Clk:AnalyticsEvent(title:ChatPg_RemoveTicketNoDlg_Btn_Clk),
    ChatPg_DownloadImage_Btn_Clk:AnalyticsEvent(title:ChatPg_DownloadImage_Btn_Clk),
    ChatPg_ShowImage_Btn_Clk:AnalyticsEvent(title:ChatPg_ShowImage_Btn_Clk),
    ChatPg_DownloadFile_Btn_Clk:AnalyticsEvent(title:ChatPg_DownloadFile_Btn_Clk),
    ChatPg_ShowFile_Btn_Clk:AnalyticsEvent(title:ChatPg_ShowFile_Btn_Clk),
    ChatPg_SendMessage_Btn_Clk:AnalyticsEvent(title:ChatPg_SendMessage_Btn_Clk),
    ChatPg_Attach_Btn_Clk:AnalyticsEvent(title:ChatPg_Attach_Btn_Clk),
    ChatPg_CameraAttach_Btn_Clk:AnalyticsEvent(title:ChatPg_CameraAttach_Btn_Clk),
    ChatPg_GalleryAttach_Btn_Clk:AnalyticsEvent(title:ChatPg_GalleryAttach_Btn_Clk),
    ChatPg_DocumentAttack_Btn_Clk:AnalyticsEvent(title:ChatPg_DocumentAttack_Btn_Clk),
    ChatPg_RegComment_Btn_Clk:AnalyticsEvent(title:ChatPg_RegComment_Btn_Clk),
    RatePg_Back_Btn_Clk:AnalyticsEvent(title:RatePg_Back_Btn_Clk),
    RatePg_Back_NavBar_Clk:AnalyticsEvent(title:RatePg_Back_NavBar_Clk),
    RatePg_RegComment_Btn_Clk:AnalyticsEvent(title:RatePg_RegComment_Btn_Clk),
    RatePg_ChangeRateValue_Icon_Clk:AnalyticsEvent(title:RatePg_ChangeRateValue_Icon_Clk),
    RatePg_AddPositiveFeedback_Item_Clk:AnalyticsEvent(title:RatePg_AddPositiveFeedback_Item_Clk),
    RatePg_RemovePositiveFeedback_Item_Clk:AnalyticsEvent(title:RatePg_RemovePositiveFeedback_Item_Clk),
    RatePg_AddNegativeFeedback_Item_Clk:AnalyticsEvent(title:RatePg_AddNegativeFeedback_Item_Clk),
    RatePg_RemoveNegativeFeedback_Item_Clk:AnalyticsEvent(title:RatePg_RemoveNegativeFeedback_Item_Clk),
    RatePg_SendFeedback_Btn_Clk:AnalyticsEvent(title:RatePg_SendFeedback_Btn_Clk),
    CalendarJalaliPg_Self_Pg_Load:AnalyticsEvent(title:CalendarJalaliPg_Self_Pg_Load),
    CalendarJalaliPg_Profile_Btn_Clk:AnalyticsEvent(title:CalendarJalaliPg_Profile_Btn_Clk),
    CalendarJalaliPg_Alarms_Btn_Clk:AnalyticsEvent(title:CalendarJalaliPg_Alarms_Btn_Clk),
    CalendarJalaliPg_NextMonth_Btn_Clk:AnalyticsEvent(title:CalendarJalaliPg_NextMonth_Btn_Clk),
    CalendarJalaliPg_LastMonth_Btn_Clk:AnalyticsEvent(title:CalendarJalaliPg_LastMonth_Btn_Clk),
    CalendarJalaliPg_ItemDate_Item_Clk:AnalyticsEvent(title:CalendarJalaliPg_ItemDate_Item_Clk),
    CalendarJalaliPg_RecordNotes_Btn_Clk:AnalyticsEvent(title:CalendarJalaliPg_RecordNotes_Btn_Clk),
    CalendarJalaliPg_Notes_Btn_Clk:AnalyticsEvent(title:CalendarJalaliPg_Notes_Btn_Clk),
    CalendarJalaliPg_AdvBanner_Banner_Clk:AnalyticsEvent(title:CalendarJalaliPg_AdvBanner_Banner_Clk),
    CalendarMiladiPg_Self_Pg_Load:AnalyticsEvent(title:CalendarMiladiPg_Self_Pg_Load),
    CalendarMiladiPg_Profile_Btn_Clk:AnalyticsEvent(title:CalendarMiladiPg_Profile_Btn_Clk),
    CalendarMiladiPg_Alarms_Btn_Clk:AnalyticsEvent(title:CalendarMiladiPg_Alarms_Btn_Clk),
    CalendarMiladiPg_NextMonth_Btn_Clk:AnalyticsEvent(title:CalendarMiladiPg_NextMonth_Btn_Clk),
    CalendarMiladiPg_LastMonth_Btn_Clk:AnalyticsEvent(title:CalendarMiladiPg_LastMonth_Btn_Clk),
    CalendarMiladiPg_ItemDate_Item_Clk:AnalyticsEvent(title:CalendarMiladiPg_ItemDate_Item_Clk),
    CalendarMiladiPg_RecordNotes_Btn_Clk:AnalyticsEvent(title:CalendarMiladiPg_RecordNotes_Btn_Clk),
    CalendarMiladiPg_Notes_Btn_Clk:AnalyticsEvent(title:CalendarMiladiPg_Notes_Btn_Clk),
    CalendarMiladiPg_AdvBanner_Banner_Clk:AnalyticsEvent(title:CalendarMiladiPg_AdvBanner_Banner_Clk),
    NotePg_Self_Pg_Load:AnalyticsEvent(title:NotePg_Self_Pg_Load),
    NotePg_Back_Btn_Clk:AnalyticsEvent(title:NotePg_Back_Btn_Clk),
    NotePg_Back_NavBar_Clk:AnalyticsEvent(title:NotePg_Back_NavBar_Clk),
    NotePg_Profile_Btn_Clk:AnalyticsEvent(title:NotePg_Profile_Btn_Clk),
    NotePg_SetTheDate_Btn_Clk:AnalyticsEvent(title:NotePg_SetTheDate_Btn_Clk),
    NotePg_SetTheDateYesBtmSht_Btn_Clk:AnalyticsEvent(title:NotePg_SetTheDateYesBtmSht_Btn_Clk),
    NotePg_SetTheDateNoBtmSht_Btn_Clk:AnalyticsEvent(title:NotePg_SetTheDateNoBtmSht_Btn_Clk),
    NotePg_TurnOnTheAlarmCalendar_Switch_Clk:AnalyticsEvent(title:NotePg_TurnOnTheAlarmCalendar_Switch_Clk),
    NotePg_TurnOffTheAlarmCalendar_Switch_Clk:AnalyticsEvent(title:NotePg_TurnOffTheAlarmCalendar_Switch_Clk),
    NotePg_PermAlarmCalendar_Dlg_Load:AnalyticsEvent(title:NotePg_PermAlarmCalendar_Dlg_Load),
    NotePg_IAllowPermAlarmCalendar_Btn_Clk_Dlg:AnalyticsEvent(title:NotePg_IAllowPermAlarmCalendar_Btn_Clk_Dlg),
    NotePg_NoPermAlarmCalendar_Btn_Clk_Dlg:AnalyticsEvent(title:NotePg_NoPermAlarmCalendar_Btn_Clk_Dlg),
    NotePg_AcceptAndSave_Btn_Clk:AnalyticsEvent(title:NotePg_AcceptAndSave_Btn_Clk),
    NotePg_Edit_Btn_Clk:AnalyticsEvent(title:NotePg_Edit_Btn_Clk),
    NotePg_No_Btn_Clk:AnalyticsEvent(title:NotePg_No_Btn_Clk),
    NotePg_RemoveNote_Btn_Clk:AnalyticsEvent(title:NotePg_RemoveNote_Btn_Clk),
    NotePg_RemoveNoteYesDlg_Btn_Clk:AnalyticsEvent(title:NotePg_RemoveNoteYesDlg_Btn_Clk),
    NotePg_RemoveNoteNoDlg_Btn_Clk:AnalyticsEvent(title:NotePg_RemoveNoteNoDlg_Btn_Clk),
    NoteListPg_Self_Pg_Load:AnalyticsEvent(title:NoteListPg_Self_Pg_Load),
    NoteListPg_Back_Btn_Clk:AnalyticsEvent(title:NoteListPg_Back_Btn_Clk),
    NoteListPg_Back_NavBar_Clk:AnalyticsEvent(title:NoteListPg_Back_NavBar_Clk),
    NoteListPg_Profile_Btn_Clk:AnalyticsEvent(title:NoteListPg_Profile_Btn_Clk),
    NoteListPg_NotesList_Item_Clk:AnalyticsEvent(title:NoteListPg_NotesList_Item_Clk),
    NoteListPg_AddNote_Btn_Clk:AnalyticsEvent(title:NoteListPg_AddNote_Btn_Clk),
    ProfilePg_Self_Pg_Load:AnalyticsEvent(title:ProfilePg_Self_Pg_Load),
    ProfilePg_Back_Btn_Clk:AnalyticsEvent(title:ProfilePg_Back_Btn_Clk),
    ProfilePg_Back_NavBar_Clk:AnalyticsEvent(title:ProfilePg_Back_NavBar_Clk),
    ProfilePg_CycleLength_Btn_Clk:AnalyticsEvent(title:ProfilePg_CycleLength_Btn_Clk),
    ProfilePg_PeriodLength_Btn_Clk:AnalyticsEvent(title:ProfilePg_PeriodLength_Btn_Clk),
    ProfilePg_Subscribe_Btn_Clk:AnalyticsEvent(title:ProfilePg_Subscribe_Btn_Clk),
    ProfilePg_MyImpoItem_Btn_Clk:AnalyticsEvent(title:ProfilePg_MyImpoItem_Btn_Clk),
    ProfilePg_ReportingItem_Btn_Clk:AnalyticsEvent(title:ProfilePg_ReportingItem_Btn_Clk),
    ProfilePg_PartnerItem_Btn_Clk:AnalyticsEvent(title:ProfilePg_PartnerItem_Btn_Clk),
    ProfilePg_EnterFaceCode_Btn_Clk:AnalyticsEvent(title:ProfilePg_EnterFaceCode_Btn_Clk),
    ProfilePg_Support_Btn_Clk:AnalyticsEvent(title:ProfilePg_Support_Btn_Clk),
    ProfilePg_ContactImpo_Btn_Clk:AnalyticsEvent(title:ProfilePg_ContactImpo_Btn_Clk),
    ProfilePg_AboutItem_Btn_Clk:AnalyticsEvent(title:ProfilePg_AboutItem_Btn_Clk),
    ProfilePg_Update_Btn_Clk:AnalyticsEvent(title:ProfilePg_Update_Btn_Clk),
    ProfilePg_SendRate_Btn_Clk:AnalyticsEvent(title:ProfilePg_SendRate_Btn_Clk),
    ProfilePg_Browser_Icon_Clk:AnalyticsEvent(title:ProfilePg_Browser_Icon_Clk),
    ProfilePg_Telegram_Icon_Clk:AnalyticsEvent(title:ProfilePg_Telegram_Icon_Clk),
    ProfilePg_Twitter_Icon_Clk:AnalyticsEvent(title:ProfilePg_Twitter_Icon_Clk),
    ProfilePg_Instagram_Icon_Clk:AnalyticsEvent(title:ProfilePg_Instagram_Icon_Clk),
    ProfilePg_AdvBanner_Banner_Clk:AnalyticsEvent(title:ProfilePg_AdvBanner_Banner_Clk),
    ProfilePg_Pregnancy_Btn_Clk:AnalyticsEvent(title:ProfilePg_Pregnancy_Btn_Clk),
    ChangeCycleValuePg_Back_Btn_Clk:AnalyticsEvent(title:ChangeCycleValuePg_Back_Btn_Clk),
    ChangeCycleValuePg_Back_NavBar_Clk:AnalyticsEvent(title:ChangeCycleValuePg_Back_NavBar_Clk),
    ChangeCycleValuePg_CyclesLength_Picker_Scr:AnalyticsEvent(title:ChangeCycleValuePg_CyclesLength_Picker_Scr),
    ChangeCycleValuePg_Edit_Btn_Clk:AnalyticsEvent(title:ChangeCycleValuePg_Edit_Btn_Clk),
    ChangePeriodValuePg_Back_Btn_Clk:AnalyticsEvent(title:ChangePeriodValuePg_Back_Btn_Clk),
    ChangePeriodValuePg_Back_NavBar_Clk:AnalyticsEvent(title:ChangePeriodValuePg_Back_NavBar_Clk),
    ChangePeriodValuePg_PeriodLength_Picker_Scr:AnalyticsEvent(title:ChangePeriodValuePg_PeriodLength_Picker_Scr),
    ChangePeriodValuePg_Edit_Btn_Clk:AnalyticsEvent(title:ChangePeriodValuePg_Edit_Btn_Clk),
    MyImpoPg_Back_Btn_Clk:AnalyticsEvent(title:MyImpoPg_Back_Btn_Clk),
    MyImpoPg_Back_NavBar_Clk:AnalyticsEvent(title:MyImpoPg_Back_NavBar_Clk),
    MyImpoPg_Account_Btn_Clk:AnalyticsEvent(title:MyImpoPg_Account_Btn_Clk),
    MyImpoPg_Pass_Btn_Clk:AnalyticsEvent(title:MyImpoPg_Pass_Btn_Clk),
    MyImpoPg_CalendarTp_Btn_Clk:AnalyticsEvent(title:MyImpoPg_CalendarTp_Btn_Clk),
    MyImpoPg_PeriodLength_Btn_Clk:AnalyticsEvent(title:MyImpoPg_PeriodLength_Btn_Clk),
    MyImpoPg_CycleLength_Btn_Clk:AnalyticsEvent(title:MyImpoPg_CycleLength_Btn_Clk),
    MyImpoPg_Sub_Btn_Clk:AnalyticsEvent(title:MyImpoPg_Sub_Btn_Clk),
    MyImpoPg_TurnOffNotify_Switch_Clk:AnalyticsEvent(title:MyImpoPg_TurnOffNotify_Switch_Clk),
    MyImpoPg_OffNotifyYesDlg_Btn_Clk:AnalyticsEvent(title:MyImpoPg_OffNotifyYesDlg_Btn_Clk),
    MyImpoPg_OffNotifyNoDlg_Btn_Clk:AnalyticsEvent(title:MyImpoPg_OffNotifyNoDlg_Btn_Clk),
    MyImpoPg_TurnOnNotify_Switch_Clk:AnalyticsEvent(title:MyImpoPg_TurnOnNotify_Switch_Clk),
    MyImpoPg_Logout_Btn_Clk:AnalyticsEvent(title:MyImpoPg_Logout_Btn_Clk),
    MyImpoPg_LogoutYesDlg_Btn_Clk:AnalyticsEvent(title:MyImpoPg_LogoutYesDlg_Btn_Clk),
    MyImpoPg_LogoutNoDlg_Btn_Clk:AnalyticsEvent(title:MyImpoPg_LogoutNoDlg_Btn_Clk),
    EditProfilePg_Back_Btn_Clk:AnalyticsEvent(title:EditProfilePg_Back_Btn_Clk),
    EditProfilePg_Back_NavBar_Clk:AnalyticsEvent(title:EditProfilePg_Back_NavBar_Clk),
    EditProfilePg_EditName_Btn_Clk:AnalyticsEvent(title:EditProfilePg_EditName_Btn_Clk),
    EditProfilePg_EditCountry_Btn_Clk:AnalyticsEvent(title:EditProfilePg_EditCountry_Btn_Clk),
    EditProfilePg_EditBirthday_Btn_Clk:AnalyticsEvent(title:EditProfilePg_EditBirthday_Btn_Clk),
    EditProfilePg_EditSexTp_Btn_Clk:AnalyticsEvent(title:EditProfilePg_EditSexTp_Btn_Clk),
    EditProfilePg_GoalInstall_Btn_Clk:AnalyticsEvent(title:EditProfilePg_GoalInstall_Btn_Clk),
    EditValueNamePg_Back_Btn_Clk:AnalyticsEvent(title:EditValueNamePg_Back_Btn_Clk),
    EditValueNamePg_Back_NavBar_Clk:AnalyticsEvent(title:EditValueNamePg_Back_NavBar_Clk),
    EditValueNamePg_Edit_Btn_Clk:AnalyticsEvent(title:EditValueNamePg_Edit_Btn_Clk),
    EditValueGoalInstallPg_Back_Btn_Clk:AnalyticsEvent(title:EditValueGoalInstallPg_Back_Btn_Clk),
    EditValueGoalInstallPg_Back_NavBar_Clk:AnalyticsEvent(title:EditValueGoalInstallPg_Back_NavBar_Clk),
    EditValueGoalInstallPg_Edit_Btn_Clk:AnalyticsEvent(title:EditValueGoalInstallPg_Edit_Btn_Clk),
    EditValueCountryPg_Back_Btn_Clk:AnalyticsEvent(title:EditValueCountryPg_Back_Btn_Clk),
    EditValueCountryPg_Back_NavBar_Clk:AnalyticsEvent(title:EditValueCountryPg_Back_NavBar_Clk),
    EditValueCountryPg_CountryList_Picker_Scr:AnalyticsEvent(title:EditValueCountryPg_CountryList_Picker_Scr),
    EditValueCountryPg_Edit_Btn_Clk:AnalyticsEvent(title:EditValueCountryPg_Edit_Btn_Clk),
    EditValueBirthdayPg_Back_Btn_Clk:AnalyticsEvent(title:EditValueBirthdayPg_Back_Btn_Clk),
    EditValueBirthdayPg_Back_NavBar_Clk:AnalyticsEvent(title:EditValueBirthdayPg_Back_NavBar_Clk),
    EditValueBirthdayPg_Edit_Btn_Clk:AnalyticsEvent(title:EditValueBirthdayPg_Edit_Btn_Clk),
    EditValueSexTpPg_Back_Btn_Clk:AnalyticsEvent(title:EditValueSexTpPg_Back_Btn_Clk),
    EditValueSexTpPg_Back_NavBar_Clk:AnalyticsEvent(title:EditValueSexTpPg_Back_NavBar_Clk),
    EditValueSexTpPg_SexTpList_Picker_Scr:AnalyticsEvent(title:EditValueSexTpPg_SexTpList_Picker_Scr),
    EditValueSexTpPg_Edit_Btn_Clk:AnalyticsEvent(title:EditValueSexTpPg_Edit_Btn_Clk),
    PasswordPg_Back_Btn_Clk:AnalyticsEvent(title:PasswordPg_Back_Btn_Clk),
    PasswordPg_Back_NavBar_Clk:AnalyticsEvent(title:PasswordPg_Back_NavBar_Clk),
    PasswordPg_TurnOnThePass_Switch_Clk:AnalyticsEvent(title:PasswordPg_TurnOnThePass_Switch_Clk),
    PasswordPg_TurnOffThePass_Switch_Clk:AnalyticsEvent(title:PasswordPg_TurnOffThePass_Switch_Clk),
    PasswordPg_EditPass_Btn_Clk:AnalyticsEvent(title:PasswordPg_EditPass_Btn_Clk),
    PasswordPg_TurnOnTheFinger_Switch_Clk:AnalyticsEvent(title:PasswordPg_TurnOnTheFinger_Switch_Clk),
    PasswordPg_TurnOffTheFinger_Switch_Clk:AnalyticsEvent(title:PasswordPg_TurnOffTheFinger_Switch_Clk),
    SetPassPg_Back_Btn_Clk:AnalyticsEvent(title:SetPassPg_Back_Btn_Clk),
    SetPassPg_Back_NavBar_Clk:AnalyticsEvent(title:SetPassPg_Back_NavBar_Clk),
    SetPassPg_PasswordRegistration_Btn_Clk:AnalyticsEvent(title:SetPassPg_PasswordRegistration_Btn_Clk),
    EnterFaceCodePg_Back_Btn_Clk:AnalyticsEvent(title:EnterFaceCodePg_Back_Btn_Clk),
    EnterFaceCodePg_Back_NavBar_Clk:AnalyticsEvent(title:EnterFaceCodePg_Back_NavBar_Clk),
    EnterFaceCodePg_CopyCode_Icon_Clk:AnalyticsEvent(title:EnterFaceCodePg_CopyCode_Icon_Clk),
    EnterFaceCodePg_ShareCode_Btn_Clk:AnalyticsEvent(title:EnterFaceCodePg_ShareCode_Btn_Clk),
    ChangeCalendarTpPg_Back_Btn_Clk:AnalyticsEvent(title:ChangeCalendarTpPg_Back_Btn_Clk),
    ChangeCalendarTpPg_Back_NavBar_Clk:AnalyticsEvent(title:ChangeCalendarTpPg_Back_NavBar_Clk),
    ChangeCalendarTpPg_ClndTpList_Picker_Scr:AnalyticsEvent(title:ChangeCalendarTpPg_ClndTpList_Picker_Scr),
    ChangeCalendarTpPg_Edit_Btn_Clk:AnalyticsEvent(title:ChangeCalendarTpPg_Edit_Btn_Clk),
    SupportPg_Back_Btn_Clk:AnalyticsEvent(title:SupportPg_Back_Btn_Clk),
    SupportPg_Back_NavBar_Clk:AnalyticsEvent(title:SupportPg_Back_NavBar_Clk),
    SupportPg_Self_Pg_Load:AnalyticsEvent(title:SupportPg_Self_Pg_Load),
    SupportPg_HistorySupport_Icon_Clk:AnalyticsEvent(title:SupportPg_HistorySupport_Icon_Clk),
    SupportPg_CategoriesList_Item_Clk:AnalyticsEvent(title:SupportPg_CategoriesList_Item_Clk),
    SupportPg_ContactSupport_Btn_Clk:AnalyticsEvent(title:SupportPg_ContactSupport_Btn_Clk),
    SupportHistoryPg_Back_Btn_Clk:AnalyticsEvent(title:SupportHistoryPg_Back_Btn_Clk),
    SupportHistoryPg_Back_NavBar_Clk:AnalyticsEvent(title:SupportHistoryPg_Back_NavBar_Clk),
    SupportHistoryPg_Self_Pg_Load:AnalyticsEvent(title:SupportHistoryPg_Self_Pg_Load),
    SupportHistoryPg_HistoryList_Item_Clk:AnalyticsEvent(title:SupportHistoryPg_HistoryList_Item_Clk),
    SupportHistoryPg_HistoryList_List_Scr:AnalyticsEvent(title:SupportHistoryPg_HistoryList_List_Scr),
    SupportCategoryPg_Back_Btn_Clk:AnalyticsEvent(title:SupportCategoryPg_Back_Btn_Clk),
    SupportCategoryPg_Back_NavBar_Clk:AnalyticsEvent(title:SupportCategoryPg_Back_NavBar_Clk),
    SupportCategoryPg_Self_Pg_Load:AnalyticsEvent(title:SupportCategoryPg_Self_Pg_Load),
    SupportCategoryPg_CategoryItems_Item_Clk:AnalyticsEvent(title:SupportCategoryPg_CategoryItems_Item_Clk),
    SupportCategoryPg_ContactSupport_Btn_Clk:AnalyticsEvent(title:SupportCategoryPg_ContactSupport_Btn_Clk),
    SendSupportPg_Back_Btn_Clk:AnalyticsEvent(title:SendSupportPg_Back_Btn_Clk),
    SendSupportPg_Back_NavBar_Clk:AnalyticsEvent(title:SendSupportPg_Back_NavBar_Clk),
    SendSupportPg_Self_Pg_Load:AnalyticsEvent(title:SendSupportPg_Self_Pg_Load),
    SendSupportPg_SelectCategory_Btn_Clk:AnalyticsEvent(title:SendSupportPg_SelectCategory_Btn_Clk),
    SendSupportPg_CategoriesList_Item_Clk:AnalyticsEvent(title:SendSupportPg_CategoriesList_Item_Clk),
    SendSupportPg_FileUpload_Btn_Clk:AnalyticsEvent(title:SendSupportPg_FileUpload_Btn_Clk),
    SendSupportPg_DeleteFile_Btn_Clk:AnalyticsEvent(title:SendSupportPg_DeleteFile_Btn_Clk),
    SendSupportPg_Send_Btn_Clk:AnalyticsEvent(title:SendSupportPg_Send_Btn_Clk),
    ContactImpoPg_Back_Btn_Clk:AnalyticsEvent(title:ContactImpoPg_Back_Btn_Clk),
    ContactImpoPg_Back_NavBar_Clk:AnalyticsEvent(title:ContactImpoPg_Back_NavBar_Clk),
    ContactImpoPg_RegCommit_Btn_Clk:AnalyticsEvent(title:ContactImpoPg_RegCommit_Btn_Clk),
    ContactImpoPg_Call_Text_Clk:AnalyticsEvent(title:ContactImpoPg_Call_Text_Clk),
    AboutPg_Back_Btn_Clk:AnalyticsEvent(title:AboutPg_Back_Btn_Clk),
    AboutPg_Back_NavBar_Clk:AnalyticsEvent(title:AboutPg_Back_NavBar_Clk),
    UpdatePg_Back_Btn_Clk:AnalyticsEvent(title: UpdatePg_Back_Btn_Clk),
    UpdatePg_Back_NavBar_Clk:AnalyticsEvent(title: UpdatePg_Back_NavBar_Clk),
    UpdatePg_Update_Btn_Clk:AnalyticsEvent(title: UpdatePg_Update_Btn_Clk),
    ReportingPg_Back_Btn_Clk:AnalyticsEvent(title:ReportingPg_Back_Btn_Clk),
    ReportingPg_Back_NavBar_Clk:AnalyticsEvent(title:ReportingPg_Back_NavBar_Clk),
    ReportingPg_Reporting_Tab_Load:AnalyticsEvent(title:ReportingPg_Reporting_Tab_Load),
    ReportingPg_HistoryReporting_Tab_Load:AnalyticsEvent(title:ReportingPg_HistoryReporting_Tab_Load),
    ReportingPg_ReportingList_Item_Clk:AnalyticsEvent(title:ReportingPg_ReportingList_Item_Clk),
    ReportingPg_HistoryReportingList_Item_Clk:AnalyticsEvent(title:ReportingPg_HistoryReportingList_Item_Clk),
    ChartPg_Self_Pg_Load:AnalyticsEvent(title:ChartPg_Self_Pg_Load),
    ChartPg_Back_Btn_Clk:AnalyticsEvent(title:ChartPg_Back_Btn_Clk),
    ChartPg_Back_NavBar_Clk:AnalyticsEvent(title:ChartPg_Back_NavBar_Clk),
    ChartPg_SharePDF_Btn_Clk:AnalyticsEvent(title:ChartPg_SharePDF_Btn_Clk),
    ChartPg_ViewPDF_Btn_Clk:AnalyticsEvent(title:ChartPg_ViewPDF_Btn_Clk),
    ChartPg_AskNowDoctor_Btn_Clk:AnalyticsEvent(title:ChartPg_AskNowDoctor_Btn_Clk),
    PartnerPg_Back_Btn_Clk:AnalyticsEvent(title:PartnerPg_Back_Btn_Clk),
    PartnerPg_Back_NavBar_Clk:AnalyticsEvent(title:PartnerPg_Back_NavBar_Clk),
    PartnerPg_CreatePartner_Btn_Clk:AnalyticsEvent(title:PartnerPg_CreatePartner_Btn_Clk),
    PartnerPg_RefreshCode_Btn_Clk:AnalyticsEvent(title:PartnerPg_RefreshCode_Btn_Clk),
    PartnerPg_CopyCode_Icon_Clk:AnalyticsEvent(title:PartnerPg_CopyCode_Icon_Clk),
    PartnerPg_ShareCode_Btn_Clk:AnalyticsEvent(title:PartnerPg_ShareCode_Btn_Clk),
    PartnerPg_EditDistance_Btn_Clk:AnalyticsEvent(title:PartnerPg_EditDistance_Btn_Clk),
    PartnerPg_RemovePartner_Btn_Clk:AnalyticsEvent(title:PartnerPg_RemovePartner_Btn_Clk),
    PartnerPg_RemovePartnerYesDlg_Btn_Clk:AnalyticsEvent(title:PartnerPg_RemovePartnerYesDlg_Btn_Clk),
    PartnerPg_RemovePartnerNoDlg_Btn_Clk:AnalyticsEvent(title:PartnerPg_RemovePartnerNoDlg_Btn_Clk),
    ChangeDistancePg_Self_Pg_Load:AnalyticsEvent(title:ChangeDistancePg_Self_Pg_Load),
    ChangeDistancePg_Back_Btn_Clk:AnalyticsEvent(title:ChangeDistancePg_Back_Btn_Clk),
    ChangeDistancePg_Back_NavBar_Clk:AnalyticsEvent(title:ChangeDistancePg_Back_NavBar_Clk),
    ChangeDistancePg_DistanceTpList_Picker_Scr:AnalyticsEvent(title:ChangeDistancePg_DistanceTpList_Picker_Scr),
    ChangeDistancePg_Accept_Btn_Clk:AnalyticsEvent(title:ChangeDistancePg_Accept_Btn_Clk),
    ChangeDistancePg_Edit_Btn_Clk:AnalyticsEvent(title:ChangeDistancePg_Edit_Btn_Clk),
    AlarmsPg_Self_Pg_Load:AnalyticsEvent(title:AlarmsPg_Self_Pg_Load),
    AlarmsPg_Back_Btn_Clk:AnalyticsEvent(title:AlarmsPg_Back_Btn_Clk),
    AlarmsPg_Back_NavBar_Clk:AnalyticsEvent(title:AlarmsPg_Back_NavBar_Clk),
    AlarmsPg_Profile_Btn_Clk:AnalyticsEvent(title:AlarmsPg_Profile_Btn_Clk),
    AlarmsPg_IProblemReceivingReminder_Btn_Clk:AnalyticsEvent(title:AlarmsPg_IProblemReceivingReminder_Btn_Clk),
    AlarmsPg_AlarmsList_Item_Clk:AnalyticsEvent(title:AlarmsPg_AlarmsList_Item_Clk),
    HelpAlarmsPg_Back_Btn_Clk:AnalyticsEvent(title:HelpAlarmsPg_Back_Btn_Clk),
    HelpAlarmsPg_Back_NavBar_Clk:AnalyticsEvent(title:HelpAlarmsPg_Back_NavBar_Clk),
    HelpAlarmsPg_Profile_Btn_Clk:AnalyticsEvent(title:HelpAlarmsPg_Profile_Btn_Clk),
    ListAlarmsPg_Back_Btn_Clk:AnalyticsEvent(title:ListAlarmsPg_Back_Btn_Clk),
    ListAlarmsPg_Back_NavBar_Clk:AnalyticsEvent(title:ListAlarmsPg_Back_NavBar_Clk),
    ListAlarmsPg_Profile_Btn_Clk:AnalyticsEvent(title:ListAlarmsPg_Profile_Btn_Clk),
    ListAlarmsPg_AlarmsList_Item_Clk:AnalyticsEvent(title:ListAlarmsPg_AlarmsList_Item_Clk),
    ListAlarmsPg_TurnOnTheAlarm_Switch_Clk:AnalyticsEvent(title:ListAlarmsPg_TurnOnTheAlarm_Switch_Clk),
    ListAlarmsPg_TurnOffTheAlarm_Switch_Clk:AnalyticsEvent(title:ListAlarmsPg_TurnOffTheAlarm_Switch_Clk),
    ListAlarmsPg_TurnOnTheSoundAlarm_Btn_Clk:AnalyticsEvent(title:ListAlarmsPg_TurnOnTheSoundAlarm_Btn_Clk),
    ListAlarmsPg_TurnOffTheSoundAlarm_Btn_Clk:AnalyticsEvent(title:ListAlarmsPg_TurnOffTheSoundAlarm_Btn_Clk),
    ListAlarmsPg_RemoveAlarm_Btn_Clk:AnalyticsEvent(title:ListAlarmsPg_RemoveAlarm_Btn_Clk),
    ListAlarmsPg_RemoveAlarmYesDlg_Btn_Clk:AnalyticsEvent(title:ListAlarmsPg_RemoveAlarmYesDlg_Btn_Clk),
    ListAlarmsPg_RemoveAlarmNoDlg_Btn_Clk:AnalyticsEvent(title:ListAlarmsPg_RemoveAlarmNoDlg_Btn_Clk),
    ListAlarmsPg_PermAlarm_Dlg_Load:AnalyticsEvent(title:ListAlarmsPg_PermAlarm_Dlg_Load),
    ListAlarmsPg_IAllowPermAlarm_Btn_Clk_Dlg:AnalyticsEvent(title:ListAlarmsPg_IAllowPermAlarm_Btn_Clk_Dlg),
    ListAlarmsPg_NoPermAlarm_Btn_Clk_Dlg:AnalyticsEvent(title:ListAlarmsPg_NoPermAlarm_Btn_Clk_Dlg),
    ListAlarmsPg_AddAlarm_Btn_Clk:AnalyticsEvent(title:ListAlarmsPg_AddAlarm_Btn_Clk),
    AddAlarmPg_Self_Pg_Load:AnalyticsEvent(title:AddAlarmPg_Self_Pg_Load),
    AddAlarmPg_Back_Btn_Clk:AnalyticsEvent(title:AddAlarmPg_Back_Btn_Clk),
    AddAlarmPg_Back_NavBar_Clk:AnalyticsEvent(title:AddAlarmPg_Back_NavBar_Clk),
    AddAlarmPg_Profile_Btn_Clk:AnalyticsEvent(title:AddAlarmPg_Profile_Btn_Clk),
    AddAlarmPg_ShowDatePicker_Text_Clk:AnalyticsEvent(title:AddAlarmPg_ShowDatePicker_Text_Clk),
    AddAlarmPg_WeekList_Item_Clk:AnalyticsEvent(title:AddAlarmPg_WeekList_Item_Clk),
    AddAlarmPg_RemoveAlarm_Btn_Clk:AnalyticsEvent(title:AddAlarmPg_RemoveAlarm_Btn_Clk),
    AddAlarmPg_RemoveAlarmYesDlg_Btn_Clk:AnalyticsEvent(title:AddAlarmPg_RemoveAlarmYesDlg_Btn_Clk),
    AddAlarmPg_RemoveAlarmNoDlg_Btn_Clk:AnalyticsEvent(title:AddAlarmPg_RemoveAlarmNoDlg_Btn_Clk),
    AddAlarmPg_SaveAlarm_Btn_Clk:AnalyticsEvent(title:AddAlarmPg_SaveAlarm_Btn_Clk),
    ChooseSubscriptionPg_Self_Pg_Load:AnalyticsEvent(title:ChooseSubscriptionPg_Self_Pg_Load),
    ChooseSubscriptionPg_Back_NavBar_Clk:AnalyticsEvent(title:ChooseSubscriptionPg_Back_NavBar_Clk),
    ChooseSubscriptionPg_FreeSub_Item_Clk:AnalyticsEvent(title:ChooseSubscriptionPg_FreeSub_Item_Clk),
    ChooseSubscriptionPg_PaySub_Item_Clk:AnalyticsEvent(title:ChooseSubscriptionPg_PaySub_Item_Clk),
    ChooseSubscriptionPg_Close_Icon_Clk:AnalyticsEvent(title:ChooseSubscriptionPg_Close_Icon_Clk),
    ChooseSubscriptionPg_Profile_Icon_Clk:AnalyticsEvent(title:ChooseSubscriptionPg_Profile_Icon_Clk),
    ChooseSubscriptionPg_ExitYesDlg_Btn_Clk:AnalyticsEvent(title:ChooseSubscriptionPg_ExitYesDlg_Btn_Clk),
    ChooseSubscriptionPg_ExitNoDlg_Btn_Clk:AnalyticsEvent(title:ChooseSubscriptionPg_ExitNoDlg_Btn_Clk),
    SubNotActivatedPg_Back_Btn_Clk:AnalyticsEvent(title:SubNotActivatedPg_Back_Btn_Clk),
    SubNotActivatedPg_Back_NavBar_Clk:AnalyticsEvent(title:SubNotActivatedPg_Back_NavBar_Clk),
    SubNotActivatedPg_SendToken_Btn_Clk:AnalyticsEvent(title:SubNotActivatedPg_SendToken_Btn_Clk),
    ShareExpPg_Self_Pg_Load:AnalyticsEvent(title:ShareExpPg_Self_Pg_Load),
    ShareExpPg_Back_Btn_Clk:AnalyticsEvent(title:ShareExpPg_Back_Btn_Clk),
    ShareExpPg_Back_NavBar_Clk:AnalyticsEvent(title:ShareExpPg_Back_NavBar_Clk),
    ShareExpPg_Info_Btn_Clk:AnalyticsEvent(title:ShareExpPg_Info_Btn_Clk),
    ShareExpPg_ChangeSigns_Btn_Clk:AnalyticsEvent(title:ShareExpPg_ChangeSigns_Btn_Clk),
    ShareExpPg_ViewAll_Btn_Clk:AnalyticsEvent(title:ShareExpPg_ViewAll_Btn_Clk),
    ShareExpPg_SelfExp_List_Scr:AnalyticsEvent(title:ShareExpPg_SelfExp_List_Scr),
    ShareExpPg_OtherExp_List_Scr:AnalyticsEvent(title:ShareExpPg_OtherExp_List_Scr),
    ShareExpPg_TopicsExp_List_Scr:AnalyticsEvent(title:ShareExpPg_TopicsExp_List_Scr),
    ShareExpPg_Like_Icon_Clk:AnalyticsEvent(title:ShareExpPg_Like_Icon_Clk),
    ShareExpPg_Dislike_Icon_Clk:AnalyticsEvent(title:ShareExpPg_Dislike_Icon_Clk),
    ShareExpPg_RemoveLike_Icon_Clk:AnalyticsEvent(title:ShareExpPg_RemoveLike_Icon_Clk),
    ShareExpPg_RemoveDislike_Icon_Clk:AnalyticsEvent(title:ShareExpPg_RemoveDislike_Icon_Clk),
    ShareExpPg_SendExp_Btn_Clk:AnalyticsEvent(title:ShareExpPg_SendExp_Btn_Clk),
    SelfShareExpPg_Self_Pg_Load:AnalyticsEvent(title:SelfShareExpPg_Self_Pg_Load),
    SelfShareExpPg_Back_Btn_Clk:AnalyticsEvent(title:SelfShareExpPg_Back_Btn_Clk),
    SelfShareExpPg_Back_NavBar_Clk:AnalyticsEvent(title:SelfShareExpPg_Back_NavBar_Clk),
    SelfShareExpPg_AllSelfExp_List_Scr:AnalyticsEvent(title:SelfShareExpPg_AllSelfExp_List_Scr),
    SelfShareExpPg_RemoveExp_Btn_Clk:AnalyticsEvent(title:SelfShareExpPg_RemoveExp_Btn_Clk),
    SelfShareExpPg_RemoveExpYesDlg_Btn_Clk:AnalyticsEvent(title:SelfShareExpPg_RemoveExpYesDlg_Btn_Clk),
    SelfShareExpPg_RemoveExpNoDlg_Btn_Clk:AnalyticsEvent(title:SelfShareExpPg_RemoveExpNoDlg_Btn_Clk),
    ComntShareExpPg_Self_Pg_Load:AnalyticsEvent(title:ComntShareExpPg_Self_Pg_Load),
    ComntShareExpPg_Back_Btn_Clk:AnalyticsEvent(title:ComntShareExpPg_Back_Btn_Clk),
    ComntShareExpPg_Back_NavBar_Clk:AnalyticsEvent(title:ComntShareExpPg_Back_NavBar_Clk),
    ComntShareExpPg_AllCommentExp_List_Scr:AnalyticsEvent(title:ComntShareExpPg_AllCommentExp_List_Scr),
    ComntShareExpPg_Like_Icon_Clk:AnalyticsEvent(title:ComntShareExpPg_Like_Icon_Clk),
    ComntShareExpPg_Dislike_Icon_Clk:AnalyticsEvent(title:ComntShareExpPg_Dislike_Icon_Clk),
    ComntShareExpPg_RemoveLike_Icon_Clk:AnalyticsEvent(title:ComntShareExpPg_RemoveLike_Icon_Clk),
    ComntShareExpPg_RemoveDislike_Icon_Clk:AnalyticsEvent(title:ComntShareExpPg_RemoveDislike_Icon_Clk),
    ComntShareExpPg_ComntLike_Icon_Clk:AnalyticsEvent(title:ComntShareExpPg_ComntLike_Icon_Clk),
    ComntShareExpPg_ComntDislike_Icon_Clk:AnalyticsEvent(title:ComntShareExpPg_ComntDislike_Icon_Clk),
    ComntShareExpPg_ComntRemoveLike_Icon_Clk:AnalyticsEvent(title:ComntShareExpPg_ComntRemoveLike_Icon_Clk),
    ComntShareExpPg_ComntRemoveDislike_Icon_Clk:AnalyticsEvent(title:ComntShareExpPg_ComntRemoveDislike_Icon_Clk),
    ComntShareExpPg_RemoveExp_Btn_Clk:AnalyticsEvent(title:ComntShareExpPg_RemoveExp_Btn_Clk),
    ComntShareExpPg_RemoveExpYesDlg_Btn_Clk:AnalyticsEvent(title:ComntShareExpPg_RemoveExpYesDlg_Btn_Clk),
    ComntShareExpPg_RemoveExpNoDlg_Btn_Clk:AnalyticsEvent(title:ComntShareExpPg_RemoveExpNoDlg_Btn_Clk),
    ComntShareExpPg_SendExp_Btn_Clk:AnalyticsEvent(title:ComntShareExpPg_SendExp_Btn_Clk),
    TopicShareExpPg_Self_Pg_Load:AnalyticsEvent(title:TopicShareExpPg_Self_Pg_Load),
    TopicShareExpPg_Back_Btn_Clk:AnalyticsEvent(title:TopicShareExpPg_Back_Btn_Clk),
    TopicShareExpPg_Back_NavBar_Clk:AnalyticsEvent(title:TopicShareExpPg_Back_NavBar_Clk),
    TopicShareExpPg_TopicsExp_List_Scr:AnalyticsEvent(title:TopicShareExpPg_TopicsExp_List_Scr),
    TopicShareExpPg_Like_Icon_Clk:AnalyticsEvent(title:TopicShareExpPg_Like_Icon_Clk),
    TopicShareExpPg_Dislike_Icon_Clk:AnalyticsEvent(title:TopicShareExpPg_Dislike_Icon_Clk),
    TopicShareExpPg_RemoveLike_Icon_Clk:AnalyticsEvent(title:TopicShareExpPg_RemoveLike_Icon_Clk),
    TopicShareExpPg_RemoveDislike_Icon_Clk:AnalyticsEvent(title:TopicShareExpPg_RemoveDislike_Icon_Clk),
    TopicShareExpPg_SendExp_Btn_Clk:AnalyticsEvent(title:TopicShareExpPg_SendExp_Btn_Clk),
  };


   // ignore: non_constant_identifier_names
  static String EnterNumberPg_Phone_Btn_Clk = setTitleName('EnterNumberPg','Phone','Btn','Clk');
  static String EnterNumberPg_Email_Btn_Clk = setTitleName('EnterNumberPg','Email','Btn','Clk');
  static String EnterNumberPg_Cont_Btn_Clk = setTitleName('EnterNumberPg','Cont','Btn','Clk');
  static String EnterNumberPg_Privacy_Text_Clk = setTitleName('EnterNumberPg','Privacy','Text','Clk');
  static String EnterNumberPg_Back_NavBar_Clk = setTitleName('EnterNumberPg','Back','NavBar','Clk');
  static String EnterNumberPg_ExitImpoYesDlg_Btn_Clk = setTitleName('EnterNumberPg','ExitImpoYesDlg','Btn','Clk');
  static String EnterNumberPg_ExitImpoNoDlg_Btn_Clk = setTitleName('EnterNumberPg','ExitImpoNoDlg','Btn','Clk');
  static String LoginPg_Self_Pg_Load = setTitleName('LoginPg','Self','Pg','Load');
  static String LoginPg_Back_NavBar_Clk = setTitleName('LoginPg','Back','NavBar','Clk');
  static String LoginPg_Phone_Btn_Clk = setTitleName('LoginPg','Phone','Btn','Clk');
  static String LoginPg_Email_Btn_Clk = setTitleName('LoginPg','Email','Btn','Clk');
  static String LoginPg_LoginToImpo_Btn_Clk = setTitleName('LoginPg','LoginToImpo','Btn','Clk');
  static String LoginPg_ForgotPassword_Text_Clk = setTitleName('LoginPg','ForgotPassword','Text','Clk');
  static String ForgotPasswordPg_Self_Pg_Load = setTitleName('ForgotPasswordPg','Self','Pg','Load');
  static String ForgotPasswordPg_Back_NavBar_Clk = setTitleName('ForgotPasswordPg','Back','NavBar','Clk');
  static String ForgotPasswordPg_Phone_Btn_Clk = setTitleName('ForgotPasswordPg','Phone','Btn','Clk');
  static String ForgotPasswordPg_Email_Btn_Clk = setTitleName('ForgotPasswordPg','Email','Btn','Clk');
  static String ForgotPasswordPg_continue_Btn_Clk = setTitleName('ForgotPasswordPg','continue','Btn','Clk');
  static String VerifyCodePg_Self_Pg_Load = setTitleName('VerifyCodePg','Self','Pg','Load');
  static String VerifyCodePg_Back_NavBar_Clk = setTitleName('VerifyCodePg','Back','NavBar','Clk');
  static String VerifyCodePg_VerifyCode_Btn_Clk = setTitleName('VerifyCodePg','VerifyCode','Btn','Clk');
  static String SetPasswordPg_Self_Pg_Load = setTitleName('SetPasswordPg','Self','Pg','Load');
  static String SetPasswordPg_Back_NavBar_Clk = setTitleName('SetPasswordPg','Back','NavBar','Clk');
  static String SetPasswordPg_Reg_Btn_Clk = setTitleName('SetPasswordPg','Reg','Btn','Clk');
  static String NameRegPg_Self_Pg_Load = setTitleName('NameRegPg','Self','Pg','Load');
  static String NameRegPg_Back_NavBar_Clk = setTitleName('NameRegPg','Back','NavBar','Clk');
  static String NameRegPg_Cont_Btn_Clk = setTitleName('NameRegPg','Cont','Btn','Clk');
  static String NationalityRegPg_Cont_Btn_Clk = setTitleName('NationalityRegPg','Cont','Btn','Clk');
  static String NationalityRegPg_Back_NavBar_Clk = setTitleName('NationalityRegPg','Back','NavBar','Clk');
  static String BirthdayRegPg_Cont_Btn_Clk = setTitleName('BirthdayRegPg','Cont','Btn','Clk');
  static String BirthdayRegPg_Back_NavBar_Clk = setTitleName('BirthdayRegPg','Back','NavBar','Clk');
  static String SexualRegPg_Cont_Btn_Clk = setTitleName('SexualRegPg','Cont','Btn','Clk');
  static String SexualRegPg_Back_NavBar_Clk = setTitleName('SexualRegPg','Back','NavBar','Clk');
  static String SelectStatusPg_Back_NavBar_Clk = setTitleName('SelectStatusPg','Back','NavBar','Clk');
  static String SelectStatusPgPeriodState_Btn_Clk = setTitleName('SelectStatusPg','PeriodState','Btn','Clk');
  static String SelectStatusPgPregnancyState_Btn_Clk = setTitleName('SelectStatusPg','PregnancyState','Btn','Clk');
  static String PeriodDayRegPg_Self_Pg_Load = setTitleName('PeriodDayRegPg','Self','Pg','Load');
  static String PeriodDayRegPg_Back_NavBar_Clk = setTitleName('PeriodDayRegPg','Back','NavBar','Clk');
  static String PeriodDayRegPg_Back_Btn_Clk = setTitleName('PeriodDayRegPg','Back','Btn','Clk');
  static String PeriodDayRegPg_PeriodLengthList_Picker_Scr = setTitleName('PeriodDayRegPg','PeriodLengthList','Picker','Scr');
  static String PeriodDayRegPg_Cont_Btn_Clk = setTitleName('PeriodDayRegPg','Cont','Btn','Clk');
  static String CycleDayRegPg_Back_NavBar_Clk = setTitleName('CycleDayRegPg','Back','NavBar','Clk');
  static String CycleDayRegPg_Back_Btn_Clk = setTitleName('CycleDayRegPg','Back','Btn','Clk');
  static String CycleDayRegPg_CycleLengthList_Picker_Scr = setTitleName('CycleDayRegPg','CycleLengthList','Picker','Scr');
  static String CycleDayRegPg_Cont_Btn_Clk = setTitleName('CycleDayRegPg','Cont','Btn','Clk');
  static String LastPeriodRegPg_Back_NavBar_Clk = setTitleName('LastPeriodRegPg','Back','NavBar','Clk');
  static String LastPeriodRegPg_Back_Btn_Clk = setTitleName('LastPeriodRegPg','Back','Btn','Clk');
  static String LastPeriodRegPg_LastPeriodList_Picker_Scr = setTitleName('LastPeriodRegPg','LastPeriodList','Picker','Scr');
  static String LastPeriodRegPg_Cont_Btn_Clk = setTitleName('LastPeriodRegPg','Cont','Btn','Clk');
  static String BardariRegPg_Self_Pg_Load = setTitleName('BardariRegPg','Self','Pg','Load');
  static String BardariRegPg_Back_NavBar_Clk = setTitleName('BardariRegPg','Back','NavBar','Clk');
  static String BardariRegPg_Back_Btn_Clk = setTitleName('BardariRegPg','Back','Btn','Clk');
  static String BardariRegPg_DateofBirth_Btn_Clk = setTitleName('BardariRegPg','DateofBirth','Btn','Clk');
  static String BardariRegPg_LastPeriod_Btn_Clk = setTitleName('BardariRegPg','LastPeriod','Btn','Clk');
  static String BardariRegPg_Cont_Btn_Clk = setTitleName('BardariRegPg','Cont','Btn','Clk');
  static String NumberBardariRegPg_Back_NavBar_Clk = setTitleName('NumberBardariRegPg','Back','NavBar','Clk');
  static String NumberBardariRegPg_Back_Btn_Clk = setTitleName('NumberBardariRegPg','Back','Btn','Clk');
  static String NumberBardariRegPg_Cont_Btn_Clk = setTitleName('NumberBardariRegPg','Cont','Btn','Clk');
  static String AbortionRegPg_Back_NavBar_Clk = setTitleName('AbortionRegPg','Back','NavBar','Clk');
  static String AbortionRegPg_Back_Btn_Clk = setTitleName('AbortionRegPg','Back','Btn','Clk');
  static String AbortionRegPg_Cont_Btn_Clk = setTitleName('AbortionRegPg','Cont','Btn','Clk');
  static String DashPgPeriod_Self_Pg_Load = setTitleName('DashPgPeriod','Self','Pg','Load');
  static String DashPgPeriod_AdvBanner_Banner_Clk = setTitleName('DashPgPeriod','AdvBanner','Banner','Clk');
  static String DashPgPeriod_Profile_Btn_Clk = setTitleName('DashPgPeriod','Profile','Btn','Clk');
  static String DashPgPeriod_Alarms_Btn_Clk = setTitleName('DashPgPeriod','Alarms','Btn','Clk');
  static String DashPgPeriod_Calendar_Btn_Clk = setTitleName('DashPgPeriod','Calendar','Btn','Clk');
  static String DashPgPeriod_MyChange_Btn_Clk = setTitleName('DashPgPeriod','MyChange','Btn','Clk');
  static String DashPgPeriod_Help_Btn_Clk = setTitleName('DashPgPeriod','Help','Btn','Clk');
  static String DashPgPeriod_HintMessage1_Btn_Clk = setTitleName('DashPgPeriod','HintMessage1','Btn','Clk');
  static String DashPgPeriod_HintMessage2_Btn_Clk = setTitleName('DashPgPeriod','HintMessage2','Btn','Clk');
  static String DashPgPeriod_Signs_Btn_Clk = setTitleName('DashPgPeriod','Signs','Btn','Clk');
  static String DashPgPeriod_ShareExp_Btn_Clk = setTitleName('DashPgPeriod','ShareExp','Btn','Clk');
  static String DashPgPeriod_Body_Item_Clk = setTitleName('DashPgPeriod','Body','Item','Clk');
  static String DashPgPeriod_Emotional_Item_Clk = setTitleName('DashPgPeriod','Emotional','Item','Clk');
  static String DashPgPeriod_Mental_Item_Clk = setTitleName('DashPgPeriod','Mental','Item','Clk');
  static String DashPgPeriod_EndScrollBio_Pg_Scr = setTitleName('DashPgPeriod','EndScrollBio','Pg','Scr');
  static String DashPgPeriod_ImPregnant_Btn_Clk_BtmSht = setTitleName('DashPgPeriod','ImPregnant','Btn','Clk','BtmSht');
  static String DashPgPeriod_ImPeriod_Btn_Clk_BtmSht = setTitleName('DashPgPeriod','ImPeriod','Btn','Clk','BtmSht');
  static String DashPgPeriod_NotPeriod_Btn_Clk_BtmSht = setTitleName('DashPgPeriod','NotPeriod','Btn','Clk','BtmSht');
  static String DashPgPeriod_EndPeriod_Btn_Clk_BtmSht = setTitleName('DashPgPeriod','EndPeriod','Btn','Clk','BtmSht');
  static String DashPgPeriod_ContPeriod_Btn_Clk_BtmSht = setTitleName('DashPgPeriod','ContPeriod','Btn','Clk','BtmSht');
  static String DashPgPeriod_ImPregnantYesDlg_Btn_Clk_BtmSht = setTitleName('DashPgPeriod','ImPregnantYesDlg','Btn','Clk','BtmSht');
  static String DashPgPeriod_ImPregnantNoDlg_Btn_Clk_BtmSht = setTitleName('DashPgPeriod','ImPregnantNoDlg','Btn','Clk','BtmSht');
  static String DashPgPeriod_ImPeriodYesDlg_Btn_Clk_BtmSht = setTitleName('DashPgPeriod','ImPeriodYesDlg','Btn','Clk','BtmSht');
  static String DashPgPeriod_ImPeriodNoDlg_Btn_Clk_BtmSht = setTitleName('DashPgPeriod','ImPeriodNoDlg','Btn','Clk','BtmSht');
  static String DashPgPeriod_NotPeriodYesDlg_Btn_Clk_BtmSht = setTitleName('DashPgPeriod','NotPeriodYesDlg','Btn','Clk','BtmSht');
  static String DashPgPeriod_NotPeriodNoDlg_Btn_Clk_BtmSht = setTitleName('DashPgPeriod','NotPeriodNoDlg','Btn','Clk','BtmSht');
  static String DashPgPeriod_EndPeriodYesDlg_Btn_Clk_BtmSht = setTitleName('DashPgPeriod','EndPeriodYesDlg','Btn','Clk','BtmSht');
  static String DashPgPeriod_EndPeriodNoDlg_Btn_Clk_BtmSht = setTitleName('DashPgPeriod','EndPeriodNoDlg','Btn','Clk','BtmSht');
  static String DashPgPeriod_ContPeriodYesDlg_Btn_Clk_BtmSht = setTitleName('DashPgPeriod','ContPeriodYesDlg','Btn','Clk','BtmSht');
  static String DashPgPeriod_ContPeriodNoDlg_Btn_Clk_BtmSht = setTitleName('DashPgPeriod','ContPeriodNoDlg','Btn','Clk','BtmSht');
  static String DashPgPeriod_CheckReportingDlg_Dlg_Load = setTitleName('DashPgPeriod','CheckReportingDlg','Dlg','Load');
  static String DashPgPeriod_CheckReportingYesDlg_Btn_Clk = setTitleName('DashPgPeriod','CheckReportingYesDlg','Btn','Clk');
  static String DashPgPeriod_CheckReportingNoDlg_Btn_Clk = setTitleName('DashPgPeriod','CheckReportingNoDlg','Btn','Clk');
  static String DashPgPeriod_RateStoreDlg_Dlg_Load = setTitleName('DashPgPeriod','RateStoreDlg','Dlg','Load');
  static String DashPgPeriod_RateStoreYesDlg_Btn_Clk = setTitleName('DashPgPeriod','RateStoreYesDlg','Btn','Clk');
  static String DashPgPeriod_RateStoreNoDlg_Btn_Clk = setTitleName('DashPgPeriod','RateStoreNoDlg','Btn','Clk');
  static String ChangeCyclePgPeriod_Back_Btn_Clk = setTitleName('ChangeCyclePgPeriod','Back','Btn','Clk');
  static String ChangeCyclePgPeriod_Back_NavBar_Clk = setTitleName('ChangeCyclePgPeriod','Back','NavBar','Clk');
  static String ChangeCyclePgPeriod_Profile_Btn_Clk = setTitleName('ChangeCyclePgPeriod','Profile','Btn','Clk');
  static String ChangeCyclePgPeriod_SaveAndAccept_Btn_Clk = setTitleName('ChangeCyclePgPeriod','SaveAndAccept','Btn','Clk');
  static String ChangeCyclePgPeriod_StartPeriod_Btn_Clk = setTitleName('ChangeCyclePgPeriod','StartPeriod','Btn','Clk');
  static String ChangeCyclePgPeriod_EndPeriod_Btn_Clk = setTitleName('ChangeCyclePgPeriod','EndPeriod','Btn','Clk');
  static String ChangeCyclePgPeriod_EndCycle_Btn_Clk = setTitleName('ChangeCyclePgPeriod','EndCycle','Btn','Clk');
  static String SignsPgPeriod_Back_Btn_Clk = setTitleName('SignsPgPeriod','Back','Btn','Clk');
  static String SignsPgPeriod_Back_NavBar_Clk = setTitleName('SignsPgPeriod','Back','NavBar','Clk');
  static String SignsPgPeriod_SaveChanges_Btn_Clk = setTitleName('SignsPgPeriod','SaveChanges','Btn','Clk');
  static String SignsPgPeriod_SaveChangeDlgYes_Btn_Clk = setTitleName('SignsPgPeriod','SaveChangeDlg'
      'Yes','Btn','Clk');
  static String SignsPgPeriod_SaveChangesDlgNo_Btn_Clk = setTitleName('SignsPgPeriod','SaveChangesDlgNo','Btn','Clk');
  static String SignsPgPeriod_AddSign_Item_Clk = setTitleName('SignsPgPeriod','AddSign','Item','Clk');
  static String SignsPgPeriod_RemoveSign_Item_Clk = setTitleName('SignsPgPeriod','RemoveSign','Item','Clk');
  static String ChangeStatusPgPeriod_Self_Pg_Load = setTitleName('ChangeStatusPgPeriod','Self','Pg','Load');
  static String ChangeStatusPgPeriod_Back_NavBar_Clk = setTitleName('ChangeStatusPgPeriod','Back','NavBar','Clk');
  static String ChangeStatusPgPeriod_Back_Btn_Clk = setTitleName('ChangeStatusPgPeriod','Back','Btn','Clk');
  static String ChangeStatusPgPeriod_Complete_Btn_Clk = setTitleName('ChangeStatusPgPeriod','Complete','Btn','Clk');
  static String DashPgPregnancy_Self_Pg_Load = setTitleName('DashPgPregnancy','Self','Pg','Load');
  static String DashPgPregnancy_AdvBanner_Banner_Clk = setTitleName('DashPgPregnancy','AdvBanner','Banner','Clk');
  static String DashPgPregnancy_Profile_Btn_Clk = setTitleName('DashPgPregnancy','Profile','Btn','Clk');
  static String DashPgPregnancy_Alarms_Btn_Clk = setTitleName('DashPgPregnancy','Alarms','Btn','Clk');
  static String DashPgPregnancy_Calendar_Btn_Clk = setTitleName('DashPgPregnancy','Calendar','Btn','Clk');
  static String DashPgPregnancy_MyChange_Btn_Clk = setTitleName('DashPgPregnancy','MyChange','Btn','Clk');
  static String DashPgPregnancy_HintMessage1_Btn_Clk = setTitleName('DashPgPregnancy','HintMessage1','Btn','Clk');
  static String DashPgPregnancy_HintMessage2_Btn_Clk = setTitleName('DashPgPregnancy','HintMessage2','Btn','Clk');
  static String DashPgPregnancy_Signs_Btn_Clk = setTitleName('DashPgPregnancy','Signs','Btn','Clk');
  static String DashPgPregnancy_ShareExp_Btn_Clk = setTitleName('DashPgPregnancy','ShareExp','Btn','Clk');
  static String DashPgPregnancy_Body_Item_Clk = setTitleName('DashPgPregnancy','Body','Item','Clk');
  static String DashPgPregnancy_Emotional_Item_Clk = setTitleName('DashPgPregnancy','Emotional','Item','Clk');
  static String DashPgPregnancy_Mental_Item_Clk = setTitleName('DashPgPregnancy','Mental','Item','Clk');
  static String DashPgPregnancy_EndScrollBio_Pg_Scr = setTitleName('DashPgPregnancy','EndScrollBio','Pg','Scr');
  static String DashPgPregnancy_GivingBirth_Btn_Clk_BtmSht = setTitleName('DashPgPregnancy','GivingBirth','Btn','Clk','BtmSht');
  static String DashPgPregnancy_Abrt_Btn_Clk_BtmSht = setTitleName('DashPgPregnancy','Abrt','Btn','Clk','BtmSht');
  static String DashPgPregnancy_AbrtYesDlg_Btn_Clk_BtmSht = setTitleName('DashPgPregnancy','AbrtYesDlg','Btn','Clk','BtmSht');
  static String DashPgPregnancy_AbrtNoDlg_Btn_Clk_BtmSht = setTitleName('DashPgPregnancy','AbrtNoDlg','Btn','Clk','BtmSht');
  static String DashPgPregnancy_Set_Btn_Clk_BtmSht = setTitleName('DashPgPregnancy','Set','Btn','Clk','BtmSht');
  static String DashPgPregnancy_PregnancyLimitWeek_Dlg_Load = setTitleName('DashPgPregnancy','PregnancyLimitWeek','Dlg','Load');
  static String DashPgPregnancy_PrgcLtWkChBirth_Btn_Clk_Dlg = setTitleName('DashPgPregnancy','PrgcLtWkChBirth','Btn','Clk','Dlg');
  static String DashPgPregnancy_PrgcLtWkAbrt_Btn_Clk_Dlg = setTitleName('DashPgPregnancy','PrgcLtWkAbrt','Btn','Clk','Dlg');
  static String SetBardariPg_Back_Btn_Clk = setTitleName('SetBardariPg','Back','Btn','Clk');
  static String SetBardariPg_Back_NavBar_Clk = setTitleName('SetBardariPg','Back','NavBar','Clk');
  static String SetBardariPg_Profile_Btn_Clk = setTitleName('SetBardariPg','Profile','Btn','Clk');
  static String SetBardariPg_PregnancyWeek_Btn_Clk = setTitleName('SetBardariPg','PregnancyWeek','Btn','Clk');
  static String SetBardariPg_DateOfBirth_Btn_Clk_BtmSht = setTitleName('SetBardariPg','DateOfBirth','Btn','Clk','BtmSht');
  static String SetBardariPg_LastPeriod_Btn_Clk_BtmSht = setTitleName('SetBardariPg','LastPeriod','Btn','Clk','BtmSht');
  static String SetBardariPg_AcptPrgcWk_Btn_Clk_BtmSht = setTitleName('SetBardariPg','AcptPrgcWk','Btn','Clk','BtmSht');
  static String SetBardariPg_HistoryOfPregnancy_Btn_Clk = setTitleName('SetBardariPg','HistoryOfPregnancy','Btn','Clk');
  static String SetBardariPg_HisPrgcList_Picker_Scr_BtmSht = setTitleName('SetBardariPg','HisPrgcList','Picker','Scr','BtmSht');
  static String SetBardariPg_AcptHisPrgc_Btn_Clk_BtmSht = setTitleName('SetBardariPg','AcptHisPrgc','Btn','Clk','BtmSht');
  static String SetBardariPg_HistoryOfAbortion_Btn_Clk = setTitleName('SetBardariPg','HistoryOfAbortion','Btn','Clk');
  static String SetBardariPg_HisAbrList_Picker_Scr_BtmSht = setTitleName('SetBardariPg','HisAbrList','Picker','Scr','BtmSht');
  static String SetBardariPg_AcptHisAbr_Btn_Clk_BtmSht = setTitleName('SetBardariPg','AcptHisAbr','Btn','Clk','BtmSht');
  static String SetBardariPg_SaveAndAccept_Btn_Clk = setTitleName('SetBardariPg','SaveAndAccept','Btn','Clk');
  static String SetBardariPg_SaveChangeDlgYes_Btn_Clk = setTitleName('SetBardariPg','SaveChangeDlgYes','Btn','Clk');
  static String SetBardariPg_SaveChangesDlgNo_Btn_Clk = setTitleName('SetBardariPg','SaveChangesDlgNo','Btn','Clk');
  static String SignsPgPregnancy_Back_Btn_Clk = setTitleName('SignsPgPregnancy','Back','Btn','Clk');
  static String SignsPgPregnancy_Back_NavBar_Clk = setTitleName('SignsPgPregnancy','Back','NavBar','Clk');
  static String SignsPgPregnancy_SaveChanges_Btn_Clk = setTitleName('SignsPgPregnancy','SaveChanges','Btn','Clk');
  static String SignsPgPregnancy_SaveChangeDlgYes_Btn_Clk = setTitleName('SignsPgPregnancy','SaveChangeDlgYes','Btn','Clk');
  static String SignsPgPregnancy_SaveChangesDlgNo_Btn_Clk = setTitleName('SignsPgPregnancy','SaveChangesDlgNo','Btn','Clk');
  static String SignsPgPregnancy_AddSign_Item_Clk = setTitleName('SignsPgPregnancy','AddSign','Item','Clk');
  static String SignsPgPregnancy_RemoveSign_Item_Clk = setTitleName('SignsPgPregnancy','RemoveSign','Item','Clk');
  static String ChangeStatusPgPregnancy_Self_Pg_Load = setTitleName('ChangeStatusPgPregnancy','Self','Pg','Load');
  static String ChangeStatusPgPregnancy_Back_NavBar_Clk = setTitleName('ChangeStatusPgPregnancy','Back','NavBar','Clk');
  static String ChangeStatusPgPregnancy_Back_Btn_Clk = setTitleName('ChangeStatusPgPregnancy','Back','Btn','Clk');
  static String ChangeStatusPgPregnancy_Complete_Btn_Clk = setTitleName('ChangeStatusPgPregnancy','Complete','Btn','Clk');
  static String PregnancyDateRegPg_Back_Btn_Clk = setTitleName('PregnancyDateRegPg','Back','Btn','Clk');
  static String PregnancyDateRegPg_Back_NavBar_Clk = setTitleName('PregnancyDateRegPg','Back','NavBar','Clk');
  static String PregnancyDateRegPg_Profile_Btn_Clk = setTitleName('PregnancyDateRegPg','Profile','Btn','Clk');
  static String PregnancyDateRegPg_Cont_Btn_Clk = setTitleName('PregnancyDateRegPg','Cont','Btn','Clk');
  static String SpecificationBabyRegPg_Back_Btn_Clk = setTitleName('SpecificationBabyRegPg','Back','Btn','Clk');
  static String SpecificationBabyRegPg_Back_NavBar_Clk = setTitleName('SpecificationBabyRegPg','Back','NavBar','Clk');
  static String SpecificationBabyRegPg_Profile_Btn_Clk = setTitleName('SpecificationBabyRegPg','Profile','Btn','Clk');
  static String SpecificationBabyRegPg_Girl_Btn_Clk = setTitleName('SpecificationBabyRegPg','Girl','Btn','Clk');
  static String SpecificationBabyRegPg_Boy_Btn_Clk = setTitleName('SpecificationBabyRegPg','Boy','Btn','Clk');
  static String SpecificationBabyRegPg_TwinsOrMore_Btn_Clk = setTitleName('SpecificationBabyRegPg','TwinsOrMore','Btn','Clk');
  static String SpecificationBabyRegPg_Accept_Btn_Clk = setTitleName('SpecificationBabyRegPg','Accept','Btn','Clk');
  static String TpBirthRegPg_Back_Btn_Clk = setTitleName('TpBirthRegPg','Back','Btn','Clk');
  static String TpBirthRegPg_Back_NavBar_Clk = setTitleName('TpBirthRegPg','Back','NavBar','Clk');
  static String TpBirthRegPg_Profile_Btn_Clk = setTitleName('TpBirthRegPg','Profile','Btn','Clk');
  static String TpBirthRegPg_TpBirthList_Picker_Scr = setTitleName('TpBirthRegPg','TpBirthList','Picker','Scr');
  static String TpBirthRegPg_Accept_Btn_Clk = setTitleName('TpBirthRegPg','Accept','Btn','Clk');
  static String DashPgBrstfeed_BrstfeedDlg_Dlg_Load = setTitleName('DashPgBrstfeed','BrstfeedDlg','Dlg','Load');
  static String DashPgBrstfeed_BrstfeedOkDlg_Btn_Clk = setTitleName('DashPgBrstfeed','BrstfeedOkDlg','Btn','Clk');
  static String DashPgBrstfeed_Self_Pg_Load = setTitleName('DashPgBrstfeed','Self','Pg','Load');
  static String DashPgBrstfeed_AdvBanner_Banner_Clk = setTitleName('DashPgBrstfeed','AdvBanner','Banner','Clk');
  static String DashPgBrstfeed_Profile_Btn_Clk = setTitleName('DashPgBrstfeed','Profile','Btn','Clk');
  static String DashPgBrstfeed_Alarms_Btn_Clk = setTitleName('DashPgBrstfeed','Alarms','Btn','Clk');
  static String DashPgBrstfeed_Calendar_Btn_Clk = setTitleName('DashPgBrstfeed','Calendar','Btn','Clk');
  static String DashPgBrstfeed_MyChange_Btn_Clk = setTitleName('DashPgBrstfeed','MyChange','Btn','Clk');
  static String DashPgBrstfeed_HintMessage1_Btn_Clk = setTitleName('DashPgBrstfeed','HintMessage1','Btn','Clk');
  static String DashPgBrstfeed_HintMessage2_Btn_Clk = setTitleName('DashPgBrstfeed','HintMessage2','Btn','Clk');
  static String DashPgBrstfeed_Signs_Btn_Clk = setTitleName('DashPgBrstfeed','Signs','Btn','Clk');
  static String DashPgBrstfeed_ShareExp_Btn_Clk = setTitleName('DashPgBrstfeed','ShareExp','Btn','Clk');
  static String DashPgBrstfeed_Body_Item_Clk = setTitleName('DashPgBrstfeed','Body','Item','Clk');
  static String DashPgBrstfeed_Emotional_Item_Clk = setTitleName('DashPgBrstfeed','Emotional','Item','Clk');
  static String DashPgBrstfeed_Mental_Item_Clk = setTitleName('DashPgBrstfeed','Mental','Item','Clk');
  static String DashPgBrstfeed_EndScrollBio_Pg_Scr = setTitleName('DashPgBrstfeed','EndScrollBio','Pg','Scr');
  static String DashPgBrstfeed_ImPeriod_Btn_Clk_BtmSht = setTitleName('DashPgBrstfeed','ImPeriod','Btn','Clk','BtmSht');
  static String DashPgBrstfeed_ImPeriodYesDlg_Btn_Clk_BtmSht = setTitleName('DashPgBrstfeed','ImPeriodYesDlg','Btn','Clk','BtmSht');
  static String DashPgBrstfeed_ImPeriodNoDlg_Btn_Clk_BtmSht = setTitleName('DashPgBrstfeed','ImPeriodNoDlg','Btn','Clk','BtmSht');
  static String DashPgBrstfeed_Set_Btn_Clk_BtmSht = setTitleName('DashPgBrstfeed','Set','Btn','Clk','BtmSht');
  static String DashPgBrstfeed_BrstfeedLimitWeek_Dlg_Load = setTitleName('DashPgBrstfeed','BrstfeedLimitWeek','Dlg','Load');
  static String DashPgBrstfeed_CompletePeriodFaz_Btn_Clk_Dlg = setTitleName('DashPgBrstfeed','CompletePeriodFaz','Btn','Clk','Dlg');
  static String SetBrstfeedPg_Back_Btn_Clk = setTitleName('SetBrstfeedPg','Back','Btn','Clk');
  static String SetBrstfeedPg_Back_NavBar_Clk = setTitleName('SetBrstfeedPg','Back','NavBar','Clk');
  static String SetBrstfeedPg_Profile_Btn_Clk = setTitleName('SetBrstfeedPg','Profile','Btn','Clk');
  static String SetBrstfeedPg_DateOfBirth_Btn_Clk = setTitleName('SetBrstfeedPg','DateOfBirth','Btn','Clk');
  static String SetBrstfeedPg_AcptDateOfBirth_Btn_Clk_BtmSht = setTitleName('SetBrstfeedPg','AcptDateOfBirth','Btn','Clk','BtmSht');
  static String SetBrstfeedPg_GenderOfTheBaby_Btn_Clk = setTitleName('SetBrstfeedPg','GenderOfTheBaby','Btn','Clk');
  static String SetBrstfeedPg_Girl_Btn_Clk_BtmSht = setTitleName('SetBrstfeedPg','Girl','Btn','Clk','BtmSht');
  static String SetBrstfeedPg_Boy_Btn_Clk_BtmSht = setTitleName('SetBrstfeedPg','Boy','Btn','Clk','BtmSht');
  static String SetBrstfeedPg_TwinsOrMore_Btn_Clk_BtmSht = setTitleName('SetBrstfeedPg','TwinsOrMore','Btn','Clk','BtmSht');
  static String SetBrstfeedPg_AcptGenderBaby_Btn_Clk_BtmSht = setTitleName('SetBrstfeedPg','AcptGenderBaby','Btn','Clk','BtmSht');
  static String SetBrstfeedPg_TpDelivery_Btn_Clk = setTitleName('SetBrstfeedPg','TpDelivery','Btn','Clk');
  static String SetBrstfeedPg_TpDlvrList_Picker_Scr_BtmSht = setTitleName('SetBrstfeedPg','TpDlvrList','Picker','Scr','BtmSht');
  static String SetBrstfeedPg_AcptTpDlvr_Btn_Clk_BtmSht = setTitleName('SetBrstfeedPg','AcptTpDlvr','Btn','Clk','BtmSht');
  static String SetBrstfeedPg_SaveAndAccept_Btn_Clk = setTitleName('SetBrstfeedPg','SaveAndAccept','Btn','Clk');
  static String SetBrstfeedPg_SaveChangeDlgYes_Btn_Clk = setTitleName('SetBrstfeedPg','SaveChangeDlgYes','Btn','Clk');
  static String SetBrstfeedPg_SaveChangesDlgNo_Btn_Clk = setTitleName('SetBrstfeedPg','SaveChangesDlgNo','Btn','Clk');
  static String SignsPgBrstfeed_Back_Btn_Clk = setTitleName('SignsPgBrstfeed','Back','Btn','Clk');
  static String SignsPgBrstfeed_Back_NavBar_Clk = setTitleName('SignsPgBrstfeed','Back','NavBar','Clk');
  static String SignsPgBrstfeed_SaveChanges_Btn_Clk = setTitleName('SignsPgBrstfeed','SaveChanges','Btn','Clk');
  static String SignsPgBrstfeed_SaveChangeDlgYes_Btn_Clk = setTitleName('SignsPgBrstfeed','SaveChangeDlgYes','Btn','Clk');
  static String SignsPgBrstfeed_SaveChangesDlgNo_Btn_Clk = setTitleName('SignsPgBrstfeed','SaveChangesDlgNo','Btn','Clk');
  static String SignsPgBrstfeed_AddSign_Item_Clk = setTitleName('SignsPgBrstfeed','AddSign','Item','Clk');
  static String SignsPgBrstfeed_RemoveSign_Item_Clk = setTitleName('SignsPgBrstfeed','RemoveSign','Item','Clk');
  static String BlogPg_Self_Pg_Load = setTitleName('BlogPg','Self','Pg','Load');
  static String BlogPg_AdvBanner_Banner_Clk = setTitleName('BlogPg','AdvBanner','Banner','Clk');
  static String BlogPg_BlogList_Item_Clk = setTitleName('BlogPg','BlogList','Item','Clk');
  static String BlogPg_Profile_Btn_Clk = setTitleName('BlogPg','Profile','Btn','Clk');
  static String BlogPg_Calendar_Btn_Clk = setTitleName('BlogPg','Calendar','Btn','Clk');
  static String PartnerTabPg_Self_Pg_Load = setTitleName('PartnerTabPg','Self','Pg','Load');
  static String PartnerTabPg_Profile_Btn_Clk = setTitleName('PartnerTabPg','Profile','Btn','Clk');
  static String PartnerTabPg_Alarms_Btn_Clk = setTitleName('PartnerTabPg','Alarms','Btn','Clk');
  static String PartnerTabPg_SendMessage_Btn_Clk = setTitleName('PartnerTabPg','SendMessage','Btn','Clk');
  static String PartnerTabPg_MemoryGame_Btn_Clk = setTitleName('PartnerTabPg','MemoryGame','Btn','Clk');
  static String PartnerTabPg_Whatisabiorhythm_Text_Clk = setTitleName('PartnerTabPg','Whatisabiorhythm','Text','Clk');
  static String PartnerTabPg_Body_Item_Clk = setTitleName('PartnerTabPg','Body','Item','Clk');
  static String PartnerTabPg_Emotional_Item_Clk = setTitleName('PartnerTabPg','Emotional','Item','Clk');
  static String PartnerTabPg_Mental_Item_Clk = setTitleName('PartnerTabPg','Mental','Item','Clk');
  static String PartnerTabPg_HintMessage1_Btn_Clk = setTitleName('PartnerTabPg','HintMessage1','Btn','Clk');
  static String PartnerTabPg_HintMessage2_Btn_Clk = setTitleName('PartnerTabPg','HintMessage2','Btn','Clk');
  static String PartnerTabPg_Whatisacriticalday_Text_Clk = setTitleName('PartnerTabPg','Whatisacriticalday','Text','Clk');
  static String PartnerTabPg_AddPartner_Btn_Clk = setTitleName('PartnerTabPg','AddPartner','Btn','Clk');
  static String PartnerTabPg_RefreshRequests_Icon_Clk = setTitleName('PartnerTabPg','RefreshRequests','Icon','Clk');
  static String PartnerTabPg_AcceptPartner_Btn_Clk = setTitleName('PartnerTabPg','AcceptPartner','Btn','Clk');
  static String PartnerTabPg_RejectPartner_Btn_Clk = setTitleName('PartnerTabPg','RejectPartner','Btn','Clk');
  static String PartnerTabPg_RejectPartnerYesDlg_Btn_Clk = setTitleName('PartnerTabPg','RejectPartnerYesDlg','Btn','Clk');
  static String PartnerTabPg_RejectPartnerNoDlg_Btn_Clk = setTitleName('PartnerTabPg','RejectPartnerNoDlg','Btn','Clk');
  static String PartnerTabPg_CancelPartner_Btn_Clk = setTitleName('PartnerTabPg','CancelPartner','Btn','Clk');
  static String PartnerTabPg_CancelPartnerYesDlg_Btn_Clk = setTitleName('PartnerTabPg','CancelPartnerYesDlg','Btn','Clk');
  static String PartnerTabPg_CancelPartnerNoDlg_Btn_Clk = setTitleName('PartnerTabPg','CancelPartnerNoDlg','Btn','Clk');
  static String PartnerTabPg_NoticeToPartner_Btn_Clk = setTitleName('PartnerTabPg','NoticeToPartner','Btn','Clk');
  static String PartnerTabPg_PartnerAdvBanner_Banner_Clk = setTitleName('PartnerTabPg','PartnerAdvBanner','Banner','Clk');
  static String PartnerTabPg_NoPartnerAdvBanner_Banner_Clk = setTitleName('PartnerTabPg','NoPartnerAdvBanner','Banner','Clk');
  static String SendMessagePg_Self_Pg_Load = setTitleName('SendMessagePg','Self','Pg','Load');
  static String SendMessagePg_Back_Btn_Clk = setTitleName('SendMessagePg','Back','Btn','Clk');
  static String SendMessagePg_Back_NavBar_Clk = setTitleName('SendMessagePg','Back','NavBar','Clk');
  static String SendMessagePg_Profile_Btn_Clk = setTitleName('SendMessagePg','Profile','Btn','Clk');
  static String SendMessagePg_SendMessage_Btn_Clk = setTitleName('SendMessagePg','SendMessage','Btn','Clk');
  static String MemoryGamePg_Self_Pg_Load = setTitleName('MemoryGamePg','Self','Pg','Load');
  static String MemoryGamePg_Back_Btn_Clk = setTitleName('MemoryGamePg','Back','Btn','Clk');
  static String MemoryGamePg_Back_NavBar_Clk = setTitleName('MemoryGamePg','Back','NavBar','Clk');
  static String MemoryGamePg_Profile_Btn_Clk = setTitleName('MemoryGamePg','Profile','Btn','Clk');
  static String MemoryGamePg_Startthememorygame_Btn_Clk = setTitleName('MemoryGamePg','Startthememorygame','Btn','Clk');
  static String MemoryGamePg_MemoryList_Item_Clk = setTitleName('MemoryGamePg','MemoryList','Item','Clk');
  static String AddMemoryPg_Back_Btn_Clk = setTitleName('AddMemoryPg','Back','Btn','Clk');
  static String AddMemoryPg_Back_NavBar_Clk = setTitleName('AddMemoryPg','Back','NavBar','Clk');
  static String AddMemoryPg_Profile_Btn_Clk = setTitleName('AddMemoryPg','Profile','Btn','Clk');
  static String AddMemoryPg_UploadImage_Btn_Clk = setTitleName('AddMemoryPg','UploadImage','Btn','Clk');
  static String AddMemoryPg_GalleryUploadImage_Btn_Clk = setTitleName('AddMemoryPg','GalleryUploadImage','Btn','Clk');
  static String AddMemoryPg_CameraUploadImage_Btn_Clk = setTitleName('AddMemoryPg','CameraUploadImage','Btn','Clk');
  static String AddMemoryPg_RecordMemory_Btn_Clk = setTitleName('AddMemoryPg','RecordMemory','Btn','Clk');
  static String ProfileMemoryPg_Back_Btn_Clk = setTitleName('ProfileMemoryPg','Back','Btn','Clk');
  static String ProfileMemoryPg_Back_NavBar_Clk = setTitleName('ProfileMemoryPg','Back','NavBar','Clk');
  static String ProfileMemoryPg_Profile_Btn_Clk = setTitleName('ProfileMemoryPg','Profile','Btn','Clk');
  static String ProfileMemoryPg_RemoveMemory_Btn_Clk = setTitleName('ProfileMemoryPg','RemoveMemory','Btn','Clk');
  static String ProfileMemoryPg_RemoveMemoryYesDlg_Btn_Clk = setTitleName('ProfileMemoryPg','RemoveMemoryYesDlg','Btn','Clk');
  static String ProfileMemoryPg_RemoveMemoryNoDlg_Btn_Clk = setTitleName('ProfileMemoryPg','RemoveMemoryNoDlg','Btn','Clk');
  static String ProfileMemoryPg_whatdoyouthink_Btn_Clk = setTitleName('ProfileMemoryPg','whatdoyouthink','Btn','Clk');
  static String SendCommitPg_Back_Btn_Clk = setTitleName('SendCommitPg','Back','Btn','Clk');
  static String SendCommitPg_Back_NavBar_Clk = setTitleName('SendCommitPg','Back','NavBar','Clk');
  static String SendCommitPg_Profile_Btn_Clk = setTitleName('SendCommitPg','Profile','Btn','Clk');
  static String SendCommitPg_whatdoyouthink_Btn_Clk = setTitleName('SendCommitPg','whatdoyouthink','Btn','Clk');
  static String MainClinicPg_Self_Pg_Load = setTitleName('MainClinicPg','Self','Pg','Load');
  static String MainClinicPg_HelpClinic_Btn_Clk = setTitleName('MainClinicPg','HelpClinic','Btn','Clk');
  static String MainClinicPg_PolarBank_Btn_Clk = setTitleName('MainClinicPg','PolarBank','Btn','Clk');
  static String MainClinicPg_HistoryTickets_Btn_Clk = setTitleName('MainClinicPg','HistoryTickets','Btn','Clk');
  static String MainClinicPg_ClinicList_Item_Clk = setTitleName('MainClinicPg','ClinicList','Item','Clk');
  static String MainClinicPg_ActiveTicketsMore_Btn_Clk = setTitleName('MainClinicPg','ActiveTicketsMore','Btn','Clk');
  static String MainClinicPg_ActiveTicketList_Item_Clk = setTitleName('MainClinicPg','ActiveTicketList','Item','Clk');
  static String ActiveClinicPg_Back_Btn_Clk = setTitleName('ActiveClinicPg','Back','Btn','Clk');
  static String ActiveClinicPg_Back_NavBar_Clk = setTitleName('ActiveClinicPg','Back','NavBar','Clk');
  static String ActiveClinicPg_ActiveTicketList_Item_Clk = setTitleName('ActiveClinicPg','ActiveTicketList','Item','Clk');
  static String ClinicQuestionPg_Back_Btn_Clk = setTitleName('ClinicQuestionPg','Back','Btn','Clk');
  static String ClinicQuestionPg_Back_NavBar_Clk = setTitleName('ClinicQuestionPg','Back','NavBar','Clk');
  static String ClinicQuestionPg_Profile_Btn_Clk = setTitleName('ClinicQuestionPg','Profile','Btn','Clk');
  static String ClinicQuestionPg_PolarBank_Btn_Clk = setTitleName('ClinicQuestionPg','PolarBank','Btn','Clk');
  static String ClinicQuestionPg_ChangeDoctor_Btn_Clk = setTitleName('ClinicQuestionPg','ChangeDoctor','Btn','Clk');
  static String ClinicQuestionPg_DoctorProfile_Btn_Clk = setTitleName('ClinicQuestionPg','DoctorProfile','Btn','Clk');
  static String ClinicQuestionPg_AttachFile_Btn_Clk = setTitleName('ClinicQuestionPg','AttachFile','Btn','Clk');
  static String ClinicQuestionPg_next_Btn_Clk = setTitleName('ClinicQuestionPg','next','Btn','Clk');
  static String ClinicPaymentPg_Back_Btn_Clk = setTitleName('ClinicPaymentPg','Back','Btn','Clk');
  static String ClinicPaymentPg_Back_NavBar_Clk = setTitleName('ClinicPaymentPg','Back','NavBar','Clk');
  static String ClinicPaymentPg_applyDiscount_Btn_Clk = setTitleName('ClinicPaymentPg','applyDiscount','Btn','Clk');
  static String ClinicPaymentPg_callSupport_Btn_Clk = setTitleName('ClinicPaymentPg','callSupport','Btn','Clk');
  static String ClinicPaymentPg_sendQuestion_Btn_Clk = setTitleName('ClinicPaymentPg','sendQuestion','Btn','Clk');
  static String DoctorListPg_Back_Btn_Clk = setTitleName('DoctorListPg','Back','Btn','Clk');
  static String DoctorListPg_Back_NavBar_Clk = setTitleName('DoctorListPg','Back','NavBar','Clk');
  static String DoctorListPg_Profile_Btn_Clk = setTitleName('DoctorListPg','Profile','Btn','Clk');
  static String DoctorListPg_PolarBank_Btn_Clk = setTitleName('DoctorListPg','PolarBank','Btn','Clk');
  static String DoctorListPg_DoctorList_Item_Clk = setTitleName('DoctorListPg','DoctorList','Item','Clk');
  static String ProfileDoctorPg_Back_Btn_Clk = setTitleName('ProfileDoctorPg','Back','Btn','Clk');
  static String ProfileDoctorPg_Back_NavBar_Clk = setTitleName('ProfileDoctorPg','Back','NavBar','Clk');
  static String ProfileDoctorPg_Profile_Btn_Clk = setTitleName('ProfileDoctorPg','Profile','Btn','Clk');
  static String ProfileDoctorPg_PolarBank_Btn_Clk = setTitleName('ProfileDoctorPg','PolarBank','Btn','Clk');
  static String ProfileDoctorPg_CommentList_List_Scr = setTitleName('ProfileDoctorPg','CommentList','List','Scr');
  static String ClinicQuestionList_Back_Btn_Clk = setTitleName('ClinicQuestionList','Back','Btn','Clk');
  static String ClinicQuestionList_Back_NavBar_Clk = setTitleName('ClinicQuestionList','Back','NavBar','Clk');
  static String ClinicQuestionList_Profile_Btn_Clk = setTitleName('ClinicQuestionList','Profile','Btn','Clk');
  static String ClinicQuestionList_PolarBank_Btn_Clk = setTitleName('ClinicQuestionList','PolarBank','Btn','Clk');
  static String ClinicQuestionList_TicketList_Item_Clk = setTitleName('ClinicQuestionList','TicketList','Item','Clk');
  static String ChatPg_Self_Pg_Load = setTitleName('ChatPg','Self','Pg','Load');
  static String ChatPg_Back_Btn_Clk = setTitleName('ChatPg','Back','Btn','Clk');
  static String ChatPg_Back_NavBar_Clk = setTitleName('ChatPg','Back','NavBar','Clk');
  static String ChatPg_Profile_Btn_Clk = setTitleName('ChatPg','Profile','Btn','Clk');
  static String ChatPg_PolarBank_Btn_Clk = setTitleName('ChatPg','PolarBank','Btn','Clk');
  static String ChatPg_RemoveTicket_Btn_Clk = setTitleName('ChatPg','RemoveTicket','Btn','Clk');
  static String ChatPg_RemoveTicketYesDlg_Btn_Clk = setTitleName('ChatPg','RemoveTicketYesDlg','Btn','Clk');
  static String ChatPg_RemoveTicketNoDlg_Btn_Clk = setTitleName('ChatPg','RemoveTicketNoDlg','Btn','Clk');
  static String ChatPg_DownloadImage_Btn_Clk = setTitleName('ChatPg','DownloadImage','Btn','Clk');
  static String ChatPg_ShowImage_Btn_Clk = setTitleName('ChatPg','ShowImage','Btn','Clk');
  static String ChatPg_DownloadFile_Btn_Clk = setTitleName('ChatPg','DownloadFile','Btn','Clk');
  static String ChatPg_ShowFile_Btn_Clk = setTitleName('ChatPg','ShowFile','Btn','Clk');
  static String ChatPg_SendMessage_Btn_Clk = setTitleName('ChatPg','SendMessage','Btn','Clk');
  static String ChatPg_Attach_Btn_Clk = setTitleName('ChatPg','Attach','Btn','Clk');
  static String ChatPg_CameraAttach_Btn_Clk = setTitleName('ChatPg','CameraAttach','Btn','Clk');
  static String ChatPg_GalleryAttach_Btn_Clk = setTitleName('ChatPg','GalleryAttach','Btn','Clk');
  static String ChatPg_DocumentAttack_Btn_Clk = setTitleName('ChatPg','DocumentAttack','Btn','Clk');
  static String ChatPg_RegComment_Btn_Clk = setTitleName('ChatPg','RegComment','Btn','Clk');
  static String RatePg_Back_Btn_Clk = setTitleName('RatePg','Back','Btn','Clk');
  static String RatePg_Back_NavBar_Clk = setTitleName('RatePg','Back','NavBar','Clk');
  static String RatePg_RegComment_Btn_Clk = setTitleName('RatePg','RegComment','Btn','Clk');
  static String RatePg_ChangeRateValue_Icon_Clk = setTitleName('RatePg','ChangeRateValue','Icon','Clk');
  static String RatePg_AddPositiveFeedback_Item_Clk = setTitleName('RatePg','AddPositiveFeedback','Item','Clk');
  static String RatePg_RemovePositiveFeedback_Item_Clk = setTitleName('RatePg','RemovePositiveFeedback','Item','Clk');
  static String RatePg_AddNegativeFeedback_Item_Clk = setTitleName('RatePg','AddNegativeFeedback','Item','Clk');
  static String RatePg_RemoveNegativeFeedback_Item_Clk = setTitleName('RatePg','RemoveNegativeFeedback','Item','Clk');
  static String RatePg_SendFeedback_Btn_Clk = setTitleName('RatePg','SendFeedback','Btn','Clk');
  static String CalendarJalaliPg_Self_Pg_Load = setTitleName('CalendarJalaliPg','Self','Pg','Load');
  static String CalendarJalaliPg_Profile_Btn_Clk = setTitleName('CalendarJalaliPg','Profile','Btn','Clk');
  static String CalendarJalaliPg_Alarms_Btn_Clk = setTitleName('CalendarJalaliPg','Alarms','Btn','Clk');
  static String CalendarJalaliPg_NextMonth_Btn_Clk = setTitleName('CalendarJalaliPg','NextMonth','Btn','Clk');
  static String CalendarJalaliPg_LastMonth_Btn_Clk = setTitleName('CalendarJalaliPg','LastMonth','Btn','Clk');
  static String CalendarJalaliPg_ItemDate_Item_Clk = setTitleName('CalendarJalaliPg','ItemDate','Item','Clk');
  static String CalendarJalaliPg_RecordNotes_Btn_Clk = setTitleName('CalendarJalaliPg','RecordNotes','Btn','Clk');
  static String CalendarJalaliPg_Notes_Btn_Clk = setTitleName('CalendarJalaliPg','Notes','Btn','Clk');
  static String CalendarJalaliPg_AdvBanner_Banner_Clk = setTitleName('CalendarJalaliPg','AdvBanner','Banner','Clk');
  static String CalendarMiladiPg_Self_Pg_Load = setTitleName('CalendarMiladiPg','Self','Pg','Load');
  static String CalendarMiladiPg_Profile_Btn_Clk = setTitleName('CalendarMiladiPg','Profile','Btn','Clk');
  static String CalendarMiladiPg_Alarms_Btn_Clk = setTitleName('CalendarMiladiPg','Alarms','Btn','Clk');
  static String CalendarMiladiPg_NextMonth_Btn_Clk = setTitleName('CalendarMiladiPg','NextMonth','Btn','Clk');
  static String CalendarMiladiPg_LastMonth_Btn_Clk = setTitleName('CalendarMiladiPg','LastMonth','Btn','Clk');
  static String CalendarMiladiPg_ItemDate_Item_Clk = setTitleName('CalendarMiladiPg','ItemDate','Item','Clk');
  static String CalendarMiladiPg_RecordNotes_Btn_Clk = setTitleName('CalendarMiladiPg','RecordNotes','Btn','Clk');
  static String CalendarMiladiPg_Notes_Btn_Clk = setTitleName('CalendarMiladiPg','Notes','Btn','Clk');
  static String CalendarMiladiPg_AdvBanner_Banner_Clk = setTitleName('CalendarMiladiPg','AdvBanner','Banner','Clk');
  static String NotePg_Self_Pg_Load = setTitleName('NotePg','Self','Pg','Load');
  static String NotePg_Back_Btn_Clk = setTitleName('NotePg','Back','Btn','Clk');
  static String NotePg_Back_NavBar_Clk = setTitleName('NotePg','Back','NavBar','Clk');
  static String NotePg_Profile_Btn_Clk = setTitleName('NotePg','Profile','Btn','Clk');
  static String NotePg_SetTheDate_Btn_Clk = setTitleName('NotePg','SetTheDate','Btn','Clk');
  static String NotePg_SetTheDateYesBtmSht_Btn_Clk = setTitleName('NotePg','SetTheDateYesBtmSht','Btn','Clk');
  static String NotePg_SetTheDateNoBtmSht_Btn_Clk = setTitleName('NotePg','SetTheDateNoBtmSht','Btn','Clk');
  static String NotePg_TurnOnTheAlarmCalendar_Switch_Clk = setTitleName('NotePg','TurnOnTheAlarmCalendar','Switch','Clk');
  static String NotePg_TurnOffTheAlarmCalendar_Switch_Clk = setTitleName('NotePg','TurnOffTheAlarmCalendar','Switch','Clk');
  static String NotePg_PermAlarmCalendar_Dlg_Load = setTitleName('NotePg','PermAlarmCalendar','Dlg','Load');
  static String NotePg_IAllowPermAlarmCalendar_Btn_Clk_Dlg = setTitleName('NotePg','IAllowPermAlarmCalendar','Btn','Clk','Dlg');
  static String NotePg_NoPermAlarmCalendar_Btn_Clk_Dlg = setTitleName('NotePg','NoPermAlarmCalendar','Btn','Clk','Dlg');
  static String NotePg_AcceptAndSave_Btn_Clk = setTitleName('NotePg','AcceptAndSave','Btn','Clk');
  static String NotePg_Edit_Btn_Clk = setTitleName('NotePg','Edit','Btn','Clk');
  static String NotePg_No_Btn_Clk = setTitleName('NotePg','No','Btn','Clk');
  static String NotePg_RemoveNote_Btn_Clk = setTitleName('NotePg','RemoveNote','Btn','Clk');
  static String NotePg_RemoveNoteYesDlg_Btn_Clk = setTitleName('NotePg','RemoveNoteYesDlg','Btn','Clk');
  static String NotePg_RemoveNoteNoDlg_Btn_Clk = setTitleName('NotePg','RemoveNoteNoDlg','Btn','Clk');
  static String NoteListPg_Self_Pg_Load = setTitleName('NoteListPg','Self','Pg','Load');
  static String NoteListPg_Back_Btn_Clk = setTitleName('NoteListPg','Back','Btn','Clk');
  static String NoteListPg_Back_NavBar_Clk = setTitleName('NoteListPg','Back','NavBar','Clk');
  static String NoteListPg_Profile_Btn_Clk = setTitleName('NoteListPg','Profile','Btn','Clk');
  static String NoteListPg_NotesList_Item_Clk = setTitleName('NoteListPg','NotesList','Item','Clk');
  static String NoteListPg_AddNote_Btn_Clk = setTitleName('NoteListPg','AddNote','Btn','Clk');
  static String ProfilePg_Self_Pg_Load = setTitleName('ProfilePg','Self','Pg','Load');
  static String ProfilePg_Back_Btn_Clk = setTitleName('ProfilePg','Back','Btn','Clk');
  static String ProfilePg_Back_NavBar_Clk = setTitleName('ProfilePg','Back','NavBar','Clk');
  static String ProfilePg_CycleLength_Btn_Clk = setTitleName('ProfilePg','CycleLength','Btn','Clk');
  static String ProfilePg_PeriodLength_Btn_Clk = setTitleName('ProfilePg','PeriodLength','Btn','Clk');
  static String ProfilePg_Subscribe_Btn_Clk = setTitleName('ProfilePg','Subscribe','Btn','Clk');
  static String ProfilePg_MyImpoItem_Btn_Clk = setTitleName('ProfilePg','MyImpoItem','Btn','Clk');
  static String ProfilePg_ReportingItem_Btn_Clk = setTitleName('ProfilePg','ReportingItem','Btn','Clk');
  static String ProfilePg_PartnerItem_Btn_Clk = setTitleName('ProfilePg','PartnerItem','Btn','Clk');
  static String ProfilePg_EnterFaceCode_Btn_Clk = setTitleName('ProfilePg','EnterFaceCode','Btn','Clk');
  static String ProfilePg_Support_Btn_Clk = setTitleName('ProfilePg','Support','Btn','Clk');
  static String ProfilePg_ContactImpo_Btn_Clk = setTitleName('ProfilePg','ContactImpo','Btn','Clk');
  static String ProfilePg_AboutItem_Btn_Clk = setTitleName('ProfilePg','AboutItem','Btn','Clk');
  static String ProfilePg_Update_Btn_Clk = setTitleName('ProfilePg','Update','Btn','Clk');
  static String ProfilePg_SendRate_Btn_Clk = setTitleName('ProfilePg','SendRate','Btn','Clk');
  static String ProfilePg_Browser_Icon_Clk = setTitleName('ProfilePg','Browser','Icon','Clk');
  static String ProfilePg_Telegram_Icon_Clk = setTitleName('ProfilePg','Telegram','Icon','Clk');
  static String ProfilePg_Twitter_Icon_Clk = setTitleName('ProfilePg','Twitter','Icon','Clk');
  static String ProfilePg_Instagram_Icon_Clk = setTitleName('ProfilePg','Instagram','Icon','Clk');
  static String ProfilePg_AdvBanner_Banner_Clk = setTitleName('ProfilePg','AdvBanner','Banner','Clk');
  static String ProfilePg_Pregnancy_Btn_Clk = setTitleName('ProfilePg','Pregnancy','Btn','Clk');
  static String ChangeCycleValuePg_Back_Btn_Clk = setTitleName('ChangeCycleValuePg','Back','Btn','Clk');
  static String ChangeCycleValuePg_Back_NavBar_Clk = setTitleName('ChangeCycleValuePg','Back','NavBar','Clk');
  static String ChangeCycleValuePg_CyclesLength_Picker_Scr = setTitleName('ChangeCycleValuePg','CyclesLength','Picker','Scr');
  static String ChangeCycleValuePg_Edit_Btn_Clk = setTitleName('ChangeCycleValuePg','Edit','Btn','Clk');
  static String ChangePeriodValuePg_Back_Btn_Clk = setTitleName('ChangePeriodValuePg','Back','Btn','Clk');
  static String ChangePeriodValuePg_Back_NavBar_Clk = setTitleName('ChangePeriodValuePg','Back','NavBar','Clk');
  static String ChangePeriodValuePg_PeriodLength_Picker_Scr = setTitleName('ChangePeriodValuePg','PeriodLength','Picker','Scr');
  static String ChangePeriodValuePg_Edit_Btn_Clk = setTitleName('ChangePeriodValuePg','Edit','Btn','Clk');
  static String MyImpoPg_Back_Btn_Clk = setTitleName('MyImpoPg','Back','Btn','Clk');
  static String MyImpoPg_Back_NavBar_Clk = setTitleName('MyImpoPg','Back','NavBar','Clk');
  static String MyImpoPg_Account_Btn_Clk = setTitleName('MyImpoPg','Account','Btn','Clk');
  static String MyImpoPg_Pass_Btn_Clk = setTitleName('MyImpoPg','Pass','Btn','Clk');
  static String MyImpoPg_CalendarTp_Btn_Clk = setTitleName('MyImpoPg','CalendarTp','Btn','Clk');
  static String MyImpoPg_PeriodLength_Btn_Clk = setTitleName('MyImpoPg','PeriodLength','Btn','Clk');
  static String MyImpoPg_CycleLength_Btn_Clk = setTitleName('MyImpoPg','CycleLength','Btn','Clk');
  static String MyImpoPg_Sub_Btn_Clk = setTitleName('MyImpoPg','Sub','Btn','Clk');
  static String MyImpoPg_TurnOffNotify_Switch_Clk = setTitleName('MyImpoPg','TurnOffNotify','Switch','Clk');
  static String MyImpoPg_OffNotifyYesDlg_Btn_Clk = setTitleName('MyImpoPg','OffNotifyYesDlg','Btn','Clk');
  static String MyImpoPg_OffNotifyNoDlg_Btn_Clk = setTitleName('MyImpoPg','OffNotifyNoDlg','Btn','Clk');
  static String MyImpoPg_TurnOnNotify_Switch_Clk = setTitleName('MyImpoPg','TurnOnNotify','Switch','Clk');
  static String MyImpoPg_Logout_Btn_Clk = setTitleName('MyImpoPg','Logout','Btn','Clk');
  static String MyImpoPg_LogoutYesDlg_Btn_Clk = setTitleName('MyImpoPg','LogoutYesDlg','Btn','Clk');
  static String MyImpoPg_LogoutNoDlg_Btn_Clk = setTitleName('MyImpoPg','LogoutNoDlg','Btn','Clk');
  static String EditProfilePg_Back_Btn_Clk = setTitleName('EditProfilePg','Back','Btn','Clk');
  static String EditProfilePg_Back_NavBar_Clk = setTitleName('EditProfilePg','Back','NavBar','Clk');
  static String EditProfilePg_EditName_Btn_Clk = setTitleName('EditProfilePg','EditName','Btn','Clk');
  static String EditProfilePg_EditCountry_Btn_Clk = setTitleName('EditProfilePg','EditCountry','Btn','Clk');
  static String EditProfilePg_EditBirthday_Btn_Clk = setTitleName('EditProfilePg','EditBirthday','Btn','Clk');
  static String EditProfilePg_EditSexTp_Btn_Clk = setTitleName('EditProfilePg','EditSexTp','Btn','Clk');
  static String EditProfilePg_GoalInstall_Btn_Clk = setTitleName('EditProfilePg','GoalInstall','Btn','Clk');
  static String EditValueNamePg_Back_Btn_Clk = setTitleName('EditValueNamePg','Back','Btn','Clk');
  static String EditValueNamePg_Back_NavBar_Clk = setTitleName('EditValueNamePg','Back','NavBar','Clk');
  static String EditValueNamePg_Edit_Btn_Clk = setTitleName('EditValueNamePg','Edit','Btn','Clk');
  static String EditValueGoalInstallPg_Back_Btn_Clk = setTitleName('EditValueGoalInstallPg','Back','Btn','Clk');
  static String EditValueGoalInstallPg_Back_NavBar_Clk = setTitleName('EditValueGoalInstallPg','Back','NavBar','Clk');
  static String EditValueGoalInstallPg_Edit_Btn_Clk = setTitleName('EditValueGoalInstallPg','Edit','Btn','Clk');
  static String EditValueCountryPg_Back_Btn_Clk = setTitleName('EditValueCountryPg','Back','Btn','Clk');
  static String EditValueCountryPg_Back_NavBar_Clk = setTitleName('EditValueCountryPg','Back','NavBar','Clk');
  static String EditValueCountryPg_CountryList_Picker_Scr = setTitleName('EditValueCountryPg','CountryList','Picker','Scr');
  static String EditValueCountryPg_Edit_Btn_Clk = setTitleName('EditValueCountryPg','Edit','Btn','Clk');
  static String EditValueBirthdayPg_Back_Btn_Clk = setTitleName('EditValueBirthdayPg','Back','Btn','Clk');
  static String EditValueBirthdayPg_Back_NavBar_Clk = setTitleName('EditValueBirthdayPg','Back','NavBar','Clk');
  static String EditValueBirthdayPg_Edit_Btn_Clk = setTitleName('EditValueBirthdayPg','Edit','Btn','Clk');
  static String EditValueSexTpPg_Back_Btn_Clk = setTitleName('EditValueSexTpPg','Back','Btn','Clk');
  static String EditValueSexTpPg_Back_NavBar_Clk = setTitleName('EditValueSexTpPg','Back','NavBar','Clk');
  static String EditValueSexTpPg_SexTpList_Picker_Scr = setTitleName('EditValueSexTpPg','SexTpList','Picker','Scr');
  static String EditValueSexTpPg_Edit_Btn_Clk = setTitleName('EditValueSexTpPg','Edit','Btn','Clk');
  static String PasswordPg_Back_Btn_Clk = setTitleName('PasswordPg','Back','Btn','Clk');
  static String PasswordPg_Back_NavBar_Clk = setTitleName('PasswordPg','Back','NavBar','Clk');
  static String PasswordPg_TurnOnThePass_Switch_Clk = setTitleName('PasswordPg','TurnOnThePass','Switch','Clk');
  static String PasswordPg_TurnOffThePass_Switch_Clk = setTitleName('PasswordPg','TurnOffThePass','Switch','Clk');
  static String PasswordPg_EditPass_Btn_Clk = setTitleName('PasswordPg','EditPass','Btn','Clk');
  static String PasswordPg_TurnOnTheFinger_Switch_Clk = setTitleName('PasswordPg','TurnOnTheFinger','Switch','Clk');
  static String PasswordPg_TurnOffTheFinger_Switch_Clk = setTitleName('PasswordPg','TurnOffTheFinger','Switch','Clk');
  static String SetPassPg_Back_Btn_Clk = setTitleName('SetPassPg','Back','Btn','Clk');
  static String SetPassPg_Back_NavBar_Clk = setTitleName('SetPassPg','Back','NavBar','Clk');
  static String SetPassPg_PasswordRegistration_Btn_Clk = setTitleName('SetPassPg','PasswordRegistration','Btn','Clk');
  static String EnterFaceCodePg_Back_Btn_Clk = setTitleName('EnterFaceCodePg','Back','Btn','Clk');
  static String EnterFaceCodePg_Back_NavBar_Clk = setTitleName('EnterFaceCodePg','Back','NavBar','Clk');
  static String EnterFaceCodePg_CopyCode_Icon_Clk = setTitleName('EnterFaceCodePg','CopyCode','Icon','Clk');
  static String EnterFaceCodePg_ShareCode_Btn_Clk = setTitleName('EnterFaceCodePg','ShareCode','Btn','Clk');
  static String ChangeCalendarTpPg_Back_Btn_Clk = setTitleName('ChangeCalendarTpPg','Back','Btn','Clk');
  static String ChangeCalendarTpPg_Back_NavBar_Clk = setTitleName('ChangeCalendarTpPg','Back','NavBar','Clk');
  static String ChangeCalendarTpPg_ClndTpList_Picker_Scr = setTitleName('ChangeCalendarTpPg','ClndTpList','Picker','Scr');
  static String ChangeCalendarTpPg_Edit_Btn_Clk = setTitleName('ChangeCalendarTpPg','Edit','Btn','Clk');

  static String SupportPg_Back_Btn_Clk = setTitleName('SupportPg','Back','Btn','Clk');
  static String SupportPg_Back_NavBar_Clk = setTitleName('SupportPg','Back','NavBar','Clk');
  static String SupportPg_Self_Pg_Load = setTitleName('SupportPg','Self','Pg','Load');
  static String SupportPg_HistorySupport_Icon_Clk = setTitleName('SupportPg','HistorySupport','Icon','Clk');
  static String SupportPg_CategoriesList_Item_Clk = setTitleName('SupportPg','CategoriesList','Item','Clk');
  static String SupportPg_ContactSupport_Btn_Clk = setTitleName('SupportPg','ContactSupport','Btn','Clk');
  static String SupportHistoryPg_Back_Btn_Clk = setTitleName('SupportHistoryPg','Back','Btn','Clk');
  static String SupportHistoryPg_Back_NavBar_Clk = setTitleName('SupportHistoryPg','Back','NavBar','Clk');
  static String SupportHistoryPg_Self_Pg_Load = setTitleName('SupportHistoryPg','Self','Pg','Load');
  static String SupportHistoryPg_HistoryList_Item_Clk = setTitleName('SupportHistoryPg','HistoryList','Item','Clk');
  static String SupportHistoryPg_HistoryList_List_Scr  = setTitleName('SupportHistoryPg','HistoryList','List','Scr');
  static String SupportCategoryPg_Back_Btn_Clk = setTitleName('SupportCategoryPg','Back','Btn','Clk');
  static String SupportCategoryPg_Back_NavBar_Clk = setTitleName('SupportCategoryPg','Back','NavBar','Clk');
  static String SupportCategoryPg_Self_Pg_Load = setTitleName('SupportCategoryPg','Self','Pg','Load');
  static String SupportCategoryPg_CategoryItems_Item_Clk = setTitleName('SupportCategoryPg','CategoryItems','Item','Clk');
  static String SupportCategoryPg_ContactSupport_Btn_Clk = setTitleName('SupportCategoryPg','ContactSupport','Btn','Clk');
  static String SendSupportPg_Back_Btn_Clk = setTitleName('SendSupportPg','Back','Btn','Clk');
  static String SendSupportPg_Back_NavBar_Clk = setTitleName('SendSupportPg','Back','NavBar','Clk');
  static String SendSupportPg_Self_Pg_Load = setTitleName('SendSupportPg','Self','Pg','Load');
  static String SendSupportPg_SelectCategory_Btn_Clk = setTitleName('SendSupportPg','SelectCategory','Btn','Clk');
  static String SendSupportPg_CategoriesList_Item_Clk = setTitleName('SendSupportPg','CategoriesList','Item','Clk');
  static String SendSupportPg_FileUpload_Btn_Clk = setTitleName('SendSupportPg','FileUpload','Btn','Clk');
  static String SendSupportPg_DeleteFile_Btn_Clk = setTitleName('SendSupportPg','DeleteFile','Btn','Clk');
  static String SendSupportPg_Send_Btn_Clk = setTitleName('SendSupportPg','Send','Btn','Clk');
  static String ChatSupportPg_Back_Btn_Clk = setTitleName('ChatSupportPg','Back','Btn','Clk');
  static String ChatSupportPg_Back_NavBar_Clk = setTitleName('ChatSupportPg','Back','NavBar','Clk');
  static String ChatSupportPg_Self_Pg_Load = setTitleName('ChatSupportPg','Self','Pg','Load');
  static String ChatSupportPg_SendSupport_Btn_Clk = setTitleName('ChatSupportPg','Attach','Btn','Clk');
  static String ChatSupportPg_Attach_Btn_Clk = setTitleName('ChatSupportPg','Attach','Btn','Clk');
  static String ChatSupportPg_CameraAttach_Btn_Clk = setTitleName('ChatSupportPg','CameraAttach','Btn','Clk');
  static String ChatSupportPg_GalleryAttach_Btn_Clk = setTitleName('ChatSupportPg','GalleryAttach','Btn','Clk');
  static String ChatSupportPg_DocumentAttack_Btn_Clk = setTitleName('ChatSupportPg','DocumentAttack','Btn','Clk');


  static String ContactImpoPg_Back_Btn_Clk = setTitleName('ContactImpoPg','Back','Btn','Clk');
  static String ContactImpoPg_Back_NavBar_Clk = setTitleName('ContactImpoPg','Back','NavBar','Clk');
  static String ContactImpoPg_RegCommit_Btn_Clk = setTitleName('ContactImpoPg','RegCommit','Btn','Clk');
  static String ContactImpoPg_Call_Text_Clk = setTitleName('ContactImpoPg','Call','Text','Clk');
  static String AboutPg_Back_Btn_Clk = setTitleName('AboutPg','Back','Btn','Clk');
  static String AboutPg_Back_NavBar_Clk = setTitleName('AboutPg','Back','NavBar','Clk');
  static String UpdatePg_Back_Btn_Clk = setTitleName('UpdatePg','Back','Btn','Clk');
  static String UpdatePg_Back_NavBar_Clk = setTitleName('UpdatePg','Back','NavBar','Clk');
  static String UpdatePg_Update_Btn_Clk = setTitleName('UpdatePg','Update','Btn','Clk');
  static String ReportingPg_Back_Btn_Clk = setTitleName('ReportingPg','Back','Btn','Clk');
  static String ReportingPg_Back_NavBar_Clk = setTitleName('ReportingPg','Back','NavBar','Clk');
  static String ReportingPg_Reporting_Tab_Load = setTitleName('ReportingPg','Reporting','Tab','Load');
  static String ReportingPg_HistoryReporting_Tab_Load = setTitleName('ReportingPg','HistoryReporting','Tab','Load');
  static String ReportingPg_ReportingList_Item_Clk = setTitleName('ReportingPg','ReportingList','Item','Clk');
  static String ReportingPg_HistoryReportingList_Item_Clk = setTitleName('ReportingPg','HistoryReportingList','Item','Clk');
  static String ChartPg_Self_Pg_Load = setTitleName('ChartPg','Self','Pg','Load');
  static String ChartPg_Back_Btn_Clk = setTitleName('ChartPg','Back','Btn','Clk');
  static String ChartPg_Back_NavBar_Clk = setTitleName('ChartPg','Back','NavBar','Clk');
  static String ChartPg_SharePDF_Btn_Clk = setTitleName('ChartPg','SharePDF','Btn','Clk');
  static String ChartPg_ViewPDF_Btn_Clk = setTitleName('ChartPg','ViewPDF','Btn','Clk');
  static String ChartPg_AskNowDoctor_Btn_Clk = setTitleName('ChartPg','AskNowDoctor','Btn','Clk');
  static String PartnerPg_Back_Btn_Clk = setTitleName('PartnerPg','Back','Btn','Clk');
  static String PartnerPg_Back_NavBar_Clk = setTitleName('PartnerPg','Back','NavBar','Clk');
  static String PartnerPg_CreatePartner_Btn_Clk = setTitleName('PartnerPg','CreatePartner','Btn','Clk');
  static String PartnerPg_RefreshCode_Btn_Clk = setTitleName('PartnerPg','RefreshCode','Btn','Clk');
  static String PartnerPg_CopyCode_Icon_Clk = setTitleName('PartnerPg','CopyCode','Icon','Clk');
  static String PartnerPg_ShareCode_Btn_Clk = setTitleName('PartnerPg','ShareCode','Btn','Clk');
  static String PartnerPg_EditDistance_Btn_Clk = setTitleName('PartnerPg','EditDistance','Btn','Clk');
  static String PartnerPg_RemovePartner_Btn_Clk = setTitleName('PartnerPg','RemovePartner','Btn','Clk');
  static String PartnerPg_RemovePartnerYesDlg_Btn_Clk = setTitleName('PartnerPg','RemovePartnerYesDlg','Btn','Clk');
  static String PartnerPg_RemovePartnerNoDlg_Btn_Clk = setTitleName('PartnerPg','RemovePartnerNoDlg','Btn','Clk');
  static String ChangeDistancePg_Self_Pg_Load = setTitleName('ChangeDistancePg','Self','Pg','Load');
  static String ChangeDistancePg_Back_Btn_Clk = setTitleName('ChangeDistancePg','Back','Btn','Clk');
  static String ChangeDistancePg_Back_NavBar_Clk = setTitleName('ChangeDistancePg','Back','NavBar','Clk');
  static String ChangeDistancePg_DistanceTpList_Picker_Scr = setTitleName('ChangeDistancePg','DistanceTpList','Picker','Scr');
  static String ChangeDistancePg_Accept_Btn_Clk = setTitleName('ChangeDistancePg','Accept','Btn','Clk');
  static String ChangeDistancePg_Edit_Btn_Clk = setTitleName('ChangeDistancePg','Edit','Btn','Clk');
  static String AlarmsPg_Self_Pg_Load = setTitleName('AlarmsPg','Self','Pg','Load');
  static String AlarmsPg_Back_Btn_Clk = setTitleName('AlarmsPg','Back','Btn','Clk');
  static String AlarmsPg_Back_NavBar_Clk = setTitleName('AlarmsPg','Back','NavBar','Clk');
  static String AlarmsPg_Profile_Btn_Clk = setTitleName('AlarmsPg','Profile','Btn','Clk');
  static String AlarmsPg_IProblemReceivingReminder_Btn_Clk = setTitleName('AlarmsPg','IProblemReceivingReminder','Btn','Clk');
  static String AlarmsPg_AlarmsList_Item_Clk = setTitleName('AlarmsPg','AlarmsList','Item','Clk');
  static String HelpAlarmsPg_Back_Btn_Clk = setTitleName('HelpAlarmsPg','Back','Btn','Clk');
  static String HelpAlarmsPg_Back_NavBar_Clk = setTitleName('HelpAlarmsPg','Back','NavBar','Clk');
  static String HelpAlarmsPg_Profile_Btn_Clk = setTitleName('HelpAlarmsPg','Profile','Btn','Clk');
  static String ListAlarmsPg_Back_Btn_Clk = setTitleName('ListAlarmsPg','Back','Btn','Clk');
  static String ListAlarmsPg_Back_NavBar_Clk = setTitleName('ListAlarmsPg','Back','NavBar','Clk');
  static String ListAlarmsPg_Profile_Btn_Clk = setTitleName('ListAlarmsPg','Profile','Btn','Clk');
  static String ListAlarmsPg_AlarmsList_Item_Clk = setTitleName('ListAlarmsPg','AlarmsList','Item','Clk');
  static String ListAlarmsPg_TurnOnTheAlarm_Switch_Clk = setTitleName('ListAlarmsPg','TurnOnTheAlarm','Switch','Clk');
  static String ListAlarmsPg_TurnOffTheAlarm_Switch_Clk = setTitleName('ListAlarmsPg','TurnOffTheAlarm','Switch','Clk');
  static String ListAlarmsPg_TurnOnTheSoundAlarm_Btn_Clk = setTitleName('ListAlarmsPg','TurnOnTheSoundAlarm','Btn','Clk');
  static String ListAlarmsPg_TurnOffTheSoundAlarm_Btn_Clk = setTitleName('ListAlarmsPg','TurnOffTheSoundAlarm','Btn','Clk');
  static String ListAlarmsPg_RemoveAlarm_Btn_Clk = setTitleName('ListAlarmsPg','RemoveAlarm','Btn','Clk');
  static String ListAlarmsPg_RemoveAlarmYesDlg_Btn_Clk = setTitleName('ListAlarmsPg','RemoveAlarmYesDlg','Btn','Clk');
  static String ListAlarmsPg_RemoveAlarmNoDlg_Btn_Clk = setTitleName('ListAlarmsPg','RemoveAlarmNoDlg','Btn','Clk');
  static String ListAlarmsPg_PermAlarm_Dlg_Load = setTitleName('ListAlarmsPg','PermAlarm','Dlg','Load');
  static String ListAlarmsPg_IAllowPermAlarm_Btn_Clk_Dlg = setTitleName('ListAlarmsPg','IAllowPermAlarm','Btn','Clk','Dlg');
  static String ListAlarmsPg_NoPermAlarm_Btn_Clk_Dlg = setTitleName('ListAlarmsPg','NoPermAlarm','Btn','Clk','Dlg');
  static String ListAlarmsPg_AddAlarm_Btn_Clk = setTitleName('ListAlarmsPg','AddAlarm','Btn','Clk');
  static String AddAlarmPg_Self_Pg_Load = setTitleName('AddAlarmPg','Self','Pg','Load');
  static String AddAlarmPg_Back_Btn_Clk = setTitleName('AddAlarmPg','Back','Btn','Clk');
  static String AddAlarmPg_Back_NavBar_Clk = setTitleName('AddAlarmPg','Back','NavBar','Clk');
  static String AddAlarmPg_Profile_Btn_Clk = setTitleName('AddAlarmPg','Profile','Btn','Clk');
  static String AddAlarmPg_ShowDatePicker_Text_Clk = setTitleName('AddAlarmPg','ShowDatePicker','Text','Clk');
  static String AddAlarmPg_WeekList_Item_Clk = setTitleName('AddAlarmPg','WeekList','Item','Clk');
  static String AddAlarmPg_RemoveAlarm_Btn_Clk = setTitleName('AddAlarmPg','RemoveAlarm','Btn','Clk');
  static String AddAlarmPg_RemoveAlarmYesDlg_Btn_Clk = setTitleName('AddAlarmPg','RemoveAlarmYesDlg','Btn','Clk');
  static String AddAlarmPg_RemoveAlarmNoDlg_Btn_Clk = setTitleName('AddAlarmPg','RemoveAlarmNoDlg','Btn','Clk');
  static String AddAlarmPg_SaveAlarm_Btn_Clk = setTitleName('AddAlarmPg','SaveAlarm','Btn','Clk');
  static String ChooseSubscriptionPg_Self_Pg_Load = setTitleName('ChooseSubscriptionPg','Self','Pg','Load');
  static String ChooseSubscriptionPg_Back_NavBar_Clk = setTitleName('ChooseSubscriptionPg','Back','NavBar','Clk');
  static String ChooseSubscriptionPg_FreeSub_Item_Clk = setTitleName('ChooseSubscriptionPg','FreeSub','Item','Clk');
  static String ChooseSubscriptionPg_PaySub_Item_Clk = setTitleName('ChooseSubscriptionPg','PaySub','Item','Clk');
  static String ChooseSubscriptionPg_Close_Icon_Clk = setTitleName('ChooseSubscriptionPg','Close','Icon','Clk');
  static String ChooseSubscriptionPg_Profile_Icon_Clk = setTitleName('ChooseSubscriptionPg','Profile','Icon','Clk');
  static String ChooseSubscriptionPg_ExitYesDlg_Btn_Clk = setTitleName('ChooseSubscriptionPg','ExitYesDlg','Btn','Clk');
  static String ChooseSubscriptionPg_ExitNoDlg_Btn_Clk = setTitleName('ChooseSubscriptionPg','ExitNoDlg','Btn','Clk');
  static String SubNotActivatedPg_Back_Btn_Clk = setTitleName('SubNotActivatedPg','Back','Btn','Clk');
  static String SubNotActivatedPg_Back_NavBar_Clk = setTitleName('SubNotActivatedPg','Back','NavBar','Clk');
  static String SubNotActivatedPg_SendToken_Btn_Clk = setTitleName('SubNotActivatedPg','SendToken','Btn','Clk');
  static String ShareExpPg_Self_Pg_Load = setTitleName('ShareExpPg','Self','Pg','Load');
  static String ShareExpPg_Back_Btn_Clk = setTitleName('ShareExpPg','Back','Btn','Clk');
  static String ShareExpPg_Back_NavBar_Clk = setTitleName('ShareExpPg','Back','NavBar','Clk');
  static String ShareExpPg_Info_Btn_Clk = setTitleName('ShareExpPg','Info','Btn','Clk');
  static String ShareExpPg_ChangeSigns_Btn_Clk = setTitleName('ShareExpPg','ChangeSigns','Btn','Clk');
  static String ShareExpPg_ViewAll_Btn_Clk = setTitleName('ShareExpPg','ViewAll','Btn','Clk');
  static String ShareExpPg_SelfExp_List_Scr = setTitleName('ShareExpPg','SelfExp','List','Scr');
  static String ShareExpPg_OtherExp_List_Scr = setTitleName('ShareExpPg','OtherExp','List','Scr');
  static String ShareExpPg_TopicsExp_List_Scr = setTitleName('ShareExpPg','TopicsExp','List','Scr');
  static String ShareExpPg_Like_Icon_Clk = setTitleName('ShareExpPg','Like','Icon','Clk');
  static String ShareExpPg_Dislike_Icon_Clk = setTitleName('ShareExpPg','Dislike','Icon','Clk');
  static String ShareExpPg_RemoveLike_Icon_Clk = setTitleName('ShareExpPg','RemoveLike','Icon','Clk');
  static String ShareExpPg_RemoveDislike_Icon_Clk = setTitleName('ShareExpPg','RemoveDislike','Icon','Clk');
  static String ShareExpPg_SendExp_Btn_Clk = setTitleName('ShareExpPg','SendExp','Btn','Clk');
  static String SelfShareExpPg_Self_Pg_Load = setTitleName('SelfShareExpPg','Self','Pg','Load');
  static String SelfShareExpPg_Back_Btn_Clk = setTitleName('SelfShareExpPg','Back','Btn','Clk');
  static String SelfShareExpPg_Back_NavBar_Clk = setTitleName('SelfShareExpPg','Back','NavBar','Clk');
  static String SelfShareExpPg_AllSelfExp_List_Scr = setTitleName('SelfShareExpPg','AllSelfExp','List','Scr');
  static String SelfShareExpPg_RemoveExp_Btn_Clk = setTitleName('SelfShareExpPg','RemoveExp','Btn','Clk');
  static String SelfShareExpPg_RemoveExpYesDlg_Btn_Clk = setTitleName('SelfShareExpPg','RemoveExpYesDlg','Btn','Clk');
  static String SelfShareExpPg_RemoveExpNoDlg_Btn_Clk = setTitleName('SelfShareExpPg','RemoveExpNoDlg','Btn','Clk');
  static String ComntShareExpPg_Self_Pg_Load = setTitleName('ComntShareExpPg','Self','Pg','Load');
  static String ComntShareExpPg_Back_Btn_Clk = setTitleName('ComntShareExpPg','Back','Btn','Clk');
  static String ComntShareExpPg_Back_NavBar_Clk = setTitleName('ComntShareExpPg','Back','NavBar','Clk');
  static String ComntShareExpPg_AllCommentExp_List_Scr = setTitleName('ComntShareExpPg','AllCommentExp','List','Scr');
  static String ComntShareExpPg_Like_Icon_Clk = setTitleName('ComntShareExpPg','Like','Icon','Clk');
  static String ComntShareExpPg_Dislike_Icon_Clk = setTitleName('ComntShareExpPg','Dislike','Icon','Clk');
  static String ComntShareExpPg_RemoveLike_Icon_Clk = setTitleName('ComntShareExpPg','RemoveLike','Icon','Clk');
  static String ComntShareExpPg_RemoveDislike_Icon_Clk = setTitleName('ComntShareExpPg','RemoveDislike','Icon','Clk');
  static String ComntShareExpPg_ComntLike_Icon_Clk = setTitleName('ComntShareExpPg','ComntLike','Icon','Clk');
  static String ComntShareExpPg_ComntDislike_Icon_Clk = setTitleName('ComntShareExpPg','ComntDislike','Icon','Clk');
  static String ComntShareExpPg_ComntRemoveLike_Icon_Clk = setTitleName('ComntShareExpPg','ComntRemoveLike','Icon','Clk');
  static String ComntShareExpPg_ComntRemoveDislike_Icon_Clk = setTitleName('ComntShareExpPg','ComntRemoveDislike','Icon','Clk');
  static String ComntShareExpPg_RemoveExp_Btn_Clk = setTitleName('ComntShareExpPg','RemoveExp','Btn','Clk');
  static String ComntShareExpPg_RemoveExpYesDlg_Btn_Clk = setTitleName('ComntShareExpPg','RemoveExpYesDlg','Btn','Clk');
  static String ComntShareExpPg_RemoveExpNoDlg_Btn_Clk = setTitleName('ComntShareExpPg','RemoveExpNoDlg','Btn','Clk');
  static String ComntShareExpPg_SendExp_Btn_Clk = setTitleName('ComntShareExpPg','SendExp','Btn','Clk');
  static String TopicShareExpPg_Self_Pg_Load = setTitleName('TopicShareExpPg','Self','Pg','Load');
  static String TopicShareExpPg_Back_Btn_Clk = setTitleName('TopicShareExpPg','Back','Btn','Clk');
  static String TopicShareExpPg_Back_NavBar_Clk = setTitleName('TopicShareExpPg','Back','NavBar','Clk');
  static String TopicShareExpPg_TopicsExp_List_Scr = setTitleName('TopicShareExpPg','TopicsExp','List','Scr');
  static String TopicShareExpPg_Like_Icon_Clk = setTitleName('TopicShareExpPg','Like','Icon','Clk');
  static String TopicShareExpPg_Dislike_Icon_Clk = setTitleName('TopicShareExpPg','Dislike','Icon','Clk');
  static String TopicShareExpPg_RemoveLike_Icon_Clk = setTitleName('TopicShareExpPg','RemoveLike','Icon','Clk');
  static String TopicShareExpPg_RemoveDislike_Icon_Clk = setTitleName('TopicShareExpPg','RemoveDislike','Icon','Clk');
  static String TopicShareExpPg_SendExp_Btn_Clk = setTitleName('TopicShareExpPg','SendExp','Btn','Clk');

}
