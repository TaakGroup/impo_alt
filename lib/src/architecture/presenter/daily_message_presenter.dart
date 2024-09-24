import 'dart:async';

import 'package:flutter/material.dart';
import 'package:impo/packages/featureDiscovery/src/foundation/feature_discovery.dart';
import 'package:impo/src/architecture/model/daily_message_model.dart';
import 'package:impo/src/architecture/presenter/partner_tab_presenter.dart';
import 'package:impo/src/core/app/view/widgets/snackbar/custom_snack_bar.dart';
import 'package:impo/src/data/http.dart';
import 'package:impo/src/models/challenge/archive_challenge_model.dart';
import 'package:impo/src/models/challenge/get_form_model.dart';
import 'package:impo/src/models/register/register_parameters_model.dart';
import 'package:page_transition/page_transition.dart';
import 'package:rxdart/rxdart.dart';
import 'package:social/chat_application.dart';

class DailyMessagePresenter {

  // late DailyMessageView _dailyMessageView;

  DailyMassageModel _dailyMassageModel = DailyMassageModel();


  DailyMessagePresenter();

  // DailyMessagePresenter(DailyMessageView view) {
  //   this._dailyMessageView = view;
  // }

  // late TabController tabController;

  // final currentIndex = BehaviorSubject<int>.seeded(0);
  final textInputDaiyMessage = BehaviorSubject<String>.seeded('');
  final isLoading = BehaviorSubject<bool>.seeded(false);
  final isMoreLoading = BehaviorSubject<bool>.seeded(false);
  final tryButtonError = BehaviorSubject<bool>.seeded(false);
  final valueError = BehaviorSubject<String>.seeded('');
  final fromDailyMessage = BehaviorSubject<GetFormModel>();
  final isLoadingButton = BehaviorSubject<bool>.seeded(false);
  final archiveChallenge = BehaviorSubject<ArchiveChallengeModel>();
  final itemsArchiveChallenge = BehaviorSubject<List<ItemsArchiveChallengeModel>>.seeded([]);

  // Stream<int> get currentIndexObserve => currentIndex.stream;
  Stream<String> get textInputDaiyMessageObserve => textInputDaiyMessage.stream;
  Stream<bool> get isLoadingObserve => isLoading.stream;
  Stream<bool> get isMoreLoadingObserve => isMoreLoading.stream;
  Stream<bool> get tryButtonErrorObserve => tryButtonError.stream;
  Stream<String> get valueErrorObserve => valueError.stream;
  Stream<GetFormModel> get fromDailyMessageObserve => fromDailyMessage.stream;
  Stream<bool> get isLoadingButtonObserve => isLoadingButton.stream;
  Stream<ArchiveChallengeModel> get archiveChallengeObserve => archiveChallenge.stream;
  Stream<List<ItemsArchiveChallengeModel>> get itemsArchiveChallengeObserve => itemsArchiveChallenge.stream;

  int counterNumPageArchives = 0;
  int totalCountArchives = 0;
  List<ItemsArchiveChallengeModel> _itemsArchiveChallenge = [];

  bool hasPartner = true;

  // initTabController(_this){
  //   tabController = TabController(length: 2, vsync: _this)..addListener(() {
  //     if(!currentIndex.isClosed){
  //       currentIndex.sink.add(tabController.index);
  //     }
  //   });
  // }

  RegisterParamViewModel getRegisters() {
    return _dailyMassageModel.getRegisters();
  }

  changedInput(String value){
    if(!textInputDaiyMessage.isClosed){
      textInputDaiyMessage.sink.add(value);
    }
  }

  getForm()async{
    if(!isLoading.isClosed){
      isLoading.sink.add(true);
    }
    if(!tryButtonError.isClosed){
      tryButtonError.sink.add(false);
    }
    Map<String,dynamic>? responseBody = await Http().sendRequest(
        womanUrl,
        'challenge/form',
        'GET',
        {

        },
        _dailyMassageModel.getRegisters().token!
    );
    print(responseBody);
    if(responseBody != null){
      if(!isLoading.isClosed){
        isLoading.sink.add(false);
      }
      if(!fromDailyMessage.isClosed){
        fromDailyMessage.sink.add(GetFormModel.fromJson(responseBody));
      }

    }else{
      if(!tryButtonError.isClosed){
        tryButtonError.sink.add(true);
      }
      valueError.sink.add('مشکلی در بارگزاری اطلاعات به وجود آمد، لطفا مجددا تلاش کنید');
    }
  }

  sendQuestions(context,String text,GetFormModel form,PartnerTabPresenter partnerTabPresenter) async {
    if (!isLoadingButton.isClosed) {
      isLoadingButton.sink.add(true);
    }

    Map<String,dynamic>? responseBody = await Http().sendRequest(
        womanUrl,
        'challenge/form/${form.id}',
        'POST',
        {
          "text": text,
          "questionText": form.question
        },
        _dailyMassageModel.getRegisters().token!
    );

    if (!isLoadingButton.isClosed) {
      isLoadingButton.sink.add(false);
    }
    if (responseBody != null) {
      if (responseBody['valid']) {
        hasPartner = true;
        if(form.btn.nextStep == 0){
          partnerTabPresenter.getChallenge();
          Navigator.pop(context);
        }else if(form.btn.nextStep == 1){
          Navigator.push(
              context,
              PageTransition(
                  type: PageTransitionType.fade,
                  child: ChatApp(
                    back: (bool hasPartnerFromChat){
                      if(hasPartnerFromChat){
                        partnerTabPresenter.getChallenge();
                      }else{
                       partnerTabPresenter.getManInfo(context,false);
                      }
                      Navigator.pop(context);
                      Navigator.pop(context);
                    },
                    baseUrl: womanUrl,
                    baseMediaUrl: mediaUrl,
                    token: _dailyMassageModel.getRegisters().token!,
                    id: form.id,
                  )
              )
          );
        }

      } else {
        hasPartner = false;
        CustomSnackBar.show(context, 'پارتنرت رابطه همدلی رو حذف کرده و ادامه چالش ممکن نیست');
      }
    } else {
      CustomSnackBar.show(context, 'مشکلی در بارگزاری اطلاعات به وجود آمد، لطفا مجددا تلاش کنید');
    }
  }

  getArchives({int pageNum= 0, int pageSize= 10, int? state}) async {
    // print(pageNum);
    if (state == 0) {
      if (!isLoading.isClosed) {
        isLoading.sink.add(true);
      }
      if (!isMoreLoading.isClosed) {
        isMoreLoading.sink.add(true);
      }

      _itemsArchiveChallenge.clear();
      if (!itemsArchiveChallenge.isClosed) {
        itemsArchiveChallenge.sink.add(_itemsArchiveChallenge);
      }
      counterNumPageArchives= 0;
    } else if (state == 1) {
      if (!isMoreLoading.isClosed) {
        isMoreLoading.sink.add(true);
      }
    }

    if (!tryButtonError.isClosed) {
      tryButtonError.sink.add(false);
    }
    // print(ttoken);
    Map<String,dynamic>? responseBody = await Http().sendRequest(
        womanUrl,
        'challenge/archive/$pageNum/$pageSize',
        'GET',
        {},
        _dailyMassageModel.getRegisters().token!
    );
    print(responseBody);
    if (responseBody != null) {

      if (!isLoading.isClosed) {
        isLoading.sink.add(false);
      }
      if (!isMoreLoading.isClosed) {
        isMoreLoading.sink.add(false);
      }
      // if (responseBody['totalCount'] != 0) {
        if (state == 0) {
          totalCountArchives = responseBody['totalCount'];
          if(!archiveChallenge.isClosed){
            archiveChallenge.sink.add(ArchiveChallengeModel.fromJson(responseBody));
          }
        } else {
          if (!isMoreLoading.isClosed) {
            isMoreLoading.sink.add(false);
          }
        }
        responseBody['items'].forEach((item) {
          _itemsArchiveChallenge.add(ItemsArchiveChallengeModel.fromJson(item));
        });
        if (!itemsArchiveChallenge.isClosed) {
          itemsArchiveChallenge.sink.add(_itemsArchiveChallenge);
        }
      // }
    } else {
      if (state == 0) {
        if (!tryButtonError.isClosed) {
          tryButtonError.sink.add(true);
        }
        valueError.sink
            .add('مشکلی در بارگزاری اطلاعات به وجود آمد، لطفا مجددا تلاش کنید');
      } else {
        Timer(Duration(seconds: 3), () {
          getArchives(pageNum: pageNum, state: 1);
        });
      }
    }
  }

  moreLoadGetArchives() {
    if (itemsArchiveChallenge.stream.value.length < totalCountArchives) {

      counterNumPageArchives = counterNumPageArchives + 1;

      getArchives(state: 1, pageNum: counterNumPageArchives);
    }
  }


  dispose(){
    // currentIndex.close();
    textInputDaiyMessage.close();
    isLoading.close();
    tryButtonError.close();
    valueError.close();
    fromDailyMessage.close();
    isLoadingButton.close();
    isMoreLoading.close();
    archiveChallenge.close();
    itemsArchiveChallenge.close();
  }

}