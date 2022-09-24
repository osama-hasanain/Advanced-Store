import 'dart:async';
import 'dart:ffi';

import 'package:advanced_flutter/domain/model/models.dart';
import 'package:advanced_flutter/domain/usecase/home_usecase.dart';
import 'package:advanced_flutter/presentation/base/baseviewmodel.dart';
import 'package:advanced_flutter/presentation/common/state-renderer/state_renderer.dart';
import 'package:advanced_flutter/presentation/common/state-renderer/state_renderer_impl.dart';
import 'package:rxdart/rxdart.dart';

class HomeViewModel extends BaseViewModel with HomeViewModelInput , HomeViewModelOutput{

  final StreamController _bannersStreamController = 
            BehaviorSubject<List<BannerAd>>(); 
  final StreamController _servicesStreamController = 
            BehaviorSubject<List<Service>>(); 
  final StreamController _storesStreamController = 
            BehaviorSubject<List<Store>>(); 

  HomeUseCase _homeUseCase;

  HomeViewModel(this._homeUseCase);

  // INPUTS

  @override
  void start() {
    _getHomeDate();
  }

  _getHomeDate() async {
     inputState.add(
      LoadingState(stateRendererType: StateRendererType.fullScreenLoadingState));
    //fold from Either to return LEFT and RIGHT
    (await _homeUseCase.execute(Void))
      .fold((failure) => {
        // left -> (failure)
         inputState.add(ErrorState(stateRendererType: StateRendererType.fullScreenErrorState,message: failure.message))
      }, (homeObject)  {
        // right -> (success)
        inputState.add(ContentState());
        inputBanners.add(homeObject.data.banners);
        inputServices.add(homeObject.data.services);
        inputStores.add(homeObject.data.stores);
        //navigate to main screen
      });
  }

  @override
  void dispose() {
    _bannersStreamController.close();
    _servicesStreamController.close();
    _storesStreamController.close();
    super.dispose();
  }
  

  @override
  Sink get inputBanners => _bannersStreamController.sink;
  
  @override
  Sink get inputServices => _servicesStreamController.sink;
  
  @override
  Sink get inputStores => _storesStreamController.sink;
  

  // OUTPUTS

  @override
  Stream<List<BannerAd>> get outputBanners =>
   _bannersStreamController.stream.map((banners) => banners);
  
  @override
  Stream<List<Service>> get outputServices => 
   _servicesStreamController.stream.map((services) => services);
  
  @override
  Stream<List<Store>> get outputStores =>
   _storesStreamController.stream.map((stores) => stores);
}

abstract class HomeViewModelOutput{
  Sink get inputStores;
  Sink get inputServices;
  Sink get inputBanners;
}

abstract class HomeViewModelInput{
  Stream<List<Store>> get outputStores;
  Stream<List<Service>> get outputServices;
  Stream<List<BannerAd>> get outputBanners;
}