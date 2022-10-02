import 'dart:async';
import 'dart:ffi';

import 'package:advanced_flutter/domain/model/models.dart';
import 'package:advanced_flutter/domain/usecase/home_usecase.dart';
import 'package:advanced_flutter/presentation/base/baseviewmodel.dart';
import 'package:advanced_flutter/presentation/common/state-renderer/state_renderer.dart';
import 'package:advanced_flutter/presentation/common/state-renderer/state_renderer_impl.dart';
import 'package:rxdart/rxdart.dart';

class HomeViewModel extends BaseViewModel
    with HomeViewModelInput, HomeViewModelOutput {
  final _dataStreamController = BehaviorSubject<HomeViewObject>();

  HomeUseCase _homeUseCase;

  HomeViewModel(this._homeUseCase);

  // INPUTS

  @override
  void start() {
    _getHomeDate();
  }

  _getHomeDate() async {
    inputState.add(LoadingState(
        stateRendererType: StateRendererType.fullScreenLoadingState));
    //fold from Either to return LEFT and RIGHT
    (await _homeUseCase.execute(Void)).fold(
        (failure) => {
              // left -> (failure)
              inputState.add(ErrorState(
                  stateRendererType: StateRendererType.fullScreenErrorState,
                  message: failure.message))
        }, (homeObject) {
          // right -> (success)
          inputState.add(ContentState());
          inputHomeData.add(HomeViewObject(homeObject.data.stores,
              homeObject.data.services, homeObject.data.banners));
          //navigate to main screen
        }
    );
  }

  @override
  void dispose() {
    _dataStreamController.close();
    super.dispose();
  }

  @override
  Sink get inputHomeData => _dataStreamController.sink;

  // OUTPUTS

  @override
  Stream<HomeViewObject> get outputHomeData =>
      _dataStreamController.stream.map((data) => data);
}

abstract class HomeViewModelOutput {
  Sink get inputHomeData;
}

abstract class HomeViewModelInput {
  Stream<HomeViewObject> get outputHomeData;
}

class HomeViewObject {
  List<Store> stores;
  List<Service> services;
  List<BannerAd> banners;

  HomeViewObject(this.stores, this.services, this.banners);
}
