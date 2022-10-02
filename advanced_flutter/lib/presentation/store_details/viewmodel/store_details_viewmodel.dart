import 'dart:ffi';

import 'package:advanced_flutter/domain/usecase/store_details_usecase.dart';
import 'package:advanced_flutter/presentation/base/baseviewmodel.dart';
import 'package:advanced_flutter/presentation/common/state-renderer/state_renderer.dart';
import 'package:advanced_flutter/presentation/common/state-renderer/state_renderer_impl.dart';
import 'package:rxdart/rxdart.dart';

class StoreDetailsViewModel extends BaseViewModel
    with StoreDetailsViewModelInput, StoreDetailsViewModelOutput {
  final _dataStreamController = BehaviorSubject<StoreDetailsObject>();
  StoreUseCase _storeUseCase;

  StoreDetailsViewModel(this._storeUseCase);

  // INPUTS

  @override
  void start() {
    _getStoreDetails();
  }

  _getStoreDetails() async {
    inputState.add(
      LoadingState(
        stateRendererType: StateRendererType.fullScreenLoadingState));
    //fold from Either to return LEFT and RIGHT
    (await _storeUseCase.execute(Void)).fold(
        (failure) => {
              // left -> (failure)
              inputState.add(ErrorState(
                  stateRendererType: StateRendererType.fullScreenErrorState,
                  message: failure.message))
        }, (storeObject) {
          // right -> (success)
          inputState.add(ContentState());
          inputHomeData.add(
            StoreDetailsObject(
              storeObject.id,storeObject.title,storeObject.image,
              storeObject.about!,storeObject.details!,storeObject.services!
              ));
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

  //OUTPUTS

  @override
  Stream<StoreDetailsObject> get outputHomeData => _dataStreamController.stream.map((data) => data);
}

abstract class StoreDetailsViewModelOutput {
  Sink get inputHomeData;
}

abstract class StoreDetailsViewModelInput {
  Stream<StoreDetailsObject> get outputHomeData;
}

class StoreDetailsObject {
  int id;
  String title, image, details, services, about;
  StoreDetailsObject(
      this.id, this.title, this.image, this.about, this.details, this.services);
}
