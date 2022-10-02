import 'dart:async';

import 'package:advanced_flutter/domain/model/models.dart';
import 'package:advanced_flutter/presentation/base/baseviewmodel.dart';
import 'package:advanced_flutter/presentation/resources/strings_manager.dart';
import 'package:easy_localization/easy_localization.dart';

import '../../resources/assets_manager.dart';

class OnBoardingViewModel extends BaseViewModel
  with OnBoardingViewModelInputs , OnBoardingViewModelOutputs
{

  final StreamController _streamController = StreamController<SliderViewObject>();
  late final List<SliderObject> _list ;
  int _currentIndex = 0;

  //OnBoarding BaseViewModelInputs
  @override
  void start() {
    _list = _getSliderDate();
    _postDataToView();
  }

  @override
  void dispose() {
    _streamController.close();
  }


  @override
  int goNext() {
    int nextIndex = ++_currentIndex;
    if(nextIndex == _list.length)
      nextIndex = 0;
    return nextIndex;
  }

  @override
  int goPrevious() {
    int perviousIndex = --_currentIndex;
    if(perviousIndex == -1)
      perviousIndex = _list.length - 1;
    return perviousIndex;
  }

  @override
  void onPageChanged(int index) {
    _currentIndex = index;
    _postDataToView();
  }

  @override
  Sink get inputSliderViewObject => _streamController.sink;


  @override
  Stream<SliderViewObject> get outputSliderViewObject =>
      _streamController.stream.map((sliderViewObject) => sliderViewObject);
  
  void _postDataToView(){
    inputSliderViewObject.add(
        SliderViewObject(
            _list[_currentIndex],
            _list.length,
            _currentIndex
        )
    );
  }

  List<SliderObject> _getSliderDate() => [
    SliderObject(AppStrings.onBoardingTitle1.tr(),
        AppStrings.onBoardingSubTitle1.tr(),ImageAssets.onboardingLogo1),
    SliderObject(AppStrings.onBoardingTitle2.tr(),
        AppStrings.onBoardingSubTitle2.tr(),ImageAssets.onboardingLogo2),
    SliderObject(AppStrings.onBoardingTitle3.tr(),
        AppStrings.onBoardingSubTitle3.tr(),ImageAssets.onboardingLogo3),
    SliderObject(AppStrings.onBoardingTitle4.tr(),
        AppStrings.onBoardingSubTitle4.tr(),ImageAssets.onboardingLogo4),
  ];

}

// inputs mean that "Orders" that our view model will receive from view
abstract class OnBoardingViewModelInputs{
  int goNext(); //when user clicks on right arrow or swipe left
  int goPrevious();//when user clicks on left arrow or swipe right
  void onPageChanged(int index);

  // stream controller input
  Sink get inputSliderViewObject;

}

abstract class OnBoardingViewModelOutputs{
  Stream<SliderViewObject> get outputSliderViewObject;
}


